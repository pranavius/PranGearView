local addonName, AddOn = ...
---@class PranGearView: AceAddon, AceConsole-3.0, AceEvent-3.0
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)

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
            self.db.profile.customSpecStatOrders[specID][STAT_DODGE] = AddOn.DefaultTankStatOrder[STAT_DODGE]
            self.db.profile.customSpecStatOrders[specID][STAT_PARRY] = AddOn.DefaultTankStatOrder[STAT_PARRY]
            self.db.profile.customSpecStatOrders[specID][STAT_BLOCK] = AddOn.DefaultTankStatOrder[STAT_BLOCK]
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
    local specID = self:GetCharacterCurrentSpecIDAndRole()
    local statFrames = {}
    local enhancementStatFrames = {}
    for _, statFrame in pairs({ CharacterStatsPane:GetChildren() }) do
        if statFrame.Label then
            statFrames[#statFrames + 1] = statFrame
        end
    end

    for _, statFrame in pairs(statFrames) do
        local cleanStatName = statFrame.Label and statFrame.Label:GetText() and statFrame.Label:GetText():gsub(":", "") or nil
        if cleanStatName and self.db.profile.customSpecStatOrders[specID][cleanStatName] ~= nil then
            local order = self.db.profile.customSpecStatOrders[specID][cleanStatName]
            enhancementStatFrames[order] = statFrame
        end
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
