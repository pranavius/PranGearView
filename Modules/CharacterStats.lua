local addonName, AddOn = ...
---@class PranGearView: AceAddon, AceConsole-3.0, AceEvent-3.0
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

local DebugPrint = AddOn.DebugPrint

---Retrieves selectable values for stat order dropdowns based on currently chosen specialization in the Character Stats options group
---@return number[] options A list of the order in which options should appear in the dropdown
function AddOn:GetStatOrderValuesHandler()
    local specID = self:GetSpecAndRoleForSelectedCharacterStatsOption()
    local options = {}
    for _, order in pairs(self.db.profile.customSpecStatOrders[specID]) do
        options[order] = order
    end
    return options
end

---Retrieves the current order for a stat based on currently chosen specialization in the Character Stats options group
---@param item string The stat to retrieve current order for
---@return number order The order of a stat as per the database
function AddOn:GetStatOrderHandler(item)
    local specID = self:GetSpecAndRoleForSelectedCharacterStatsOption()
    return self.db.profile.customSpecStatOrders[specID][item[#item]]
end

---Handles setting changes to stat order options
---@param item any The stat to modify the display order for, typically a `string` containing the name of the key in the database table
---@param val any The value to set in the database for the stat defined by `item`
function AddOn:SetStatOrderHandler(item, val)
    local specID = self:GetSpecAndRoleForSelectedCharacterStatsOption()
    local currentOrder = self.db.profile.customSpecStatOrders[specID][item[#item]]
    self.db.profile.customSpecStatOrders[specID][item[#item]] = tonumber(val)
    for stat, order in pairs(self.db.profile.customSpecStatOrders[specID]) do
        if order == tonumber(val) and stat ~= item[#item] then
            DebugPrint("Duplicate order number found on stat:", stat)
            self.db.profile.customSpecStatOrders[specID][stat] = currentOrder
            break
        end
    end
end

---Returns specialization ID and role for the logged-in character
---@return number specID The specialization ID for the currently logged in character
---@return string role The role that the current specialization serves ("TANK", "DAMAGER", "HEALER")
---@see SpecOptionKeys for a list of specializations and their IDs
function AddOn:GetCharacterCurrentSpecIDAndRole()
    local specIndex = GetSpecialization()
    local specID, _, _, _, role = GetSpecializationInfo(specIndex)
    return specID, role
end

---Initializes a stat order entry in the database for the specialization defined by `selectedSpecID`.
---@param selectedSpecID? number The specialization ID to update the database format
---@param reset? boolean `true` if stat order is being reset to default values, `false` otherwise
function AddOn:InitializeCustomSpecStatOrderDB(selectedSpecID, reset)
    local specID, role
    if selectedSpecID then
        specID = selectedSpecID
        role = select(5, GetSpecializationInfoByID(selectedSpecID))
    else
        specID, role = self:GetCharacterCurrentSpecIDAndRole()
    end
    if not self.db.profile.customSpecStatOrders[specID] or reset then
        self.db.profile.customSpecStatOrders[specID] = AddOn.DefaultStatOrder
        -- Tanks have extra stats to consider, so only add those options for Tank specs
        if role == "TANK" then
            self.db.profile.customSpecStatOrders[specID]["Dodge"] = AddOn.DefaultTankStatOrder["Dodge"]
            self.db.profile.customSpecStatOrders[specID]["Parry"] = AddOn.DefaultTankStatOrder["Parry"]
            self.db.profile.customSpecStatOrders[specID]["Block"] = AddOn.DefaultTankStatOrder["Block"]
        end
    end
end

---Returns specialization ID and role for the chosen spec whenever it is changed in the options menu
---@return number specID The specialization ID for the currently logged in character
---@return string role The role that the current specialization serves ("TANK", "DAMAGER", "HEALER")
---@see SpecOptionKeys for a list of specializations and their IDs
function AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
    local specID, role
    if self.db.profile.lastSelectedSpecID then
        specID, _, _, _, role = GetSpecializationInfoByID(self.db.profile.lastSelectedSpecID)
    else
        specID, role = self:GetCharacterCurrentSpecIDAndRole()
    end

    return specID, role
end

---Reorders stats in the Character Info window based on the custom order defined in the Character Stats options
function AddOn:ReorderStatFramesBySpec()
    local specID, role = self:GetCharacterCurrentSpecIDAndRole()
    local statFrames = {}
    ---@type CharacterStatFrame[]
    local enhancementStatFrames = {}
    for _, statFrame in pairs({ CharacterStatsPane:GetChildren() }) do
        ---@cast statFrame CharacterStatFrame
        if statFrame.Label then
            statFrames[#statFrames + 1] = statFrame
        end
    end

    for _, statFrame in pairs(statFrames) do
        ---@cast statFrame CharacterStatFrame
        local localeStatName = statFrame.Label and statFrame.Label:GetText() and statFrame.Label:GetText():gsub(":", "") or nil
        local statName
        for stat, _ in pairs(self.DefaultStatOrder) do
            if L[stat] == localeStatName then statName = stat break end
        end
        -- Iterate over "Tank" stats as well for classes like Shaman which gain Block from equipping a shield as a non-tank
        for stat, _ in pairs(self.DefaultTankStatOrder) do
            if L[stat] == localeStatName then statName = stat break end
        end
        local order
        if statName and self.db.profile.customSpecStatOrders[specID][statName] ~= nil then
            order = self.db.profile.customSpecStatOrders[specID][statName]
        elseif statName then
            -- For non-tank classes with a "Tank" stat, simply append the stat to the end of the list of frames
            -- Adding 11 because there are currently 10 possible stats that can be shown, guaranteeing no overlap
            order = #enhancementStatFrames + 11
        end
        if order then enhancementStatFrames[order] = statFrame end
    end

    -- if stat in position (order - 1) is hidden, there could be overlapping/hidden stats in the Character Info window
    -- Compressing the table so that indices are in a running numeric order rather than potentially having gaps between indices
    AddOn.CompressTable(enhancementStatFrames)

    for order, frame in pairs(enhancementStatFrames) do
        frame:ClearAllPoints()
        if order == 1 then
            frame:SetPoint("TOP", CharacterStatsPane.EnhancementsCategory, "BOTTOM", 0, -2)
            frame.Background:SetShown(false)
        else
            frame:SetPoint("TOP", enhancementStatFrames[order - 1], "BOTTOM", 0, 0)
            frame.Background:SetShown((order % 2) == 0)
        end
    end
end

---Updates enhancement stat frame values to include decimal percentages when the relevant option is enabled 
function AddOn:ShowDecimalStatValues()
    for _, frame in pairs({ CharacterStatsPane:GetChildren() }) do
        ---@cast frame CharacterStatFrame
        if frame.Label and frame.numericValue then
            -- decimal in the numeric value indicates a secondary/tertiary stat (main stats don't have decimal parts from what I've seen)
            -- search for decimal with punctuation character (%p)
            if tostring(frame.numericValue):match("%p") then
                frame.Value:SetFormattedText("%."..self.db.profile.decimalPlacesForStats.."f%%", frame.numericValue)
            end
        end
    end
end
