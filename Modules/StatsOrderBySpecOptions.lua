local addonName, AddOn = ...
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)

local DebugPrint = AddOn.DebugPrint

-- Retrieves acceptable values for stat order dropdowns
function AddOn:GetStatOrderValuesHandler()
    local specID = self:GetSpecAndRoleForSelectedCharacterStatsOption()
    local options = {}
    for _, order in pairs(self.db.profile.customSpecStatOrders[specID]) do
        options[order] = order
    end
    return options
end

function AddOn:GetStatOrderHandler(item)
    local specID = self:GetSpecAndRoleForSelectedCharacterStatsOption()
    return self.db.profile.customSpecStatOrders[specID][item[#item]]
end

-- handles setting all stat order options
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

-- Returns specialization ID and role for the logged-in character
function AddOn:GetCharacterCurrentSpecIDAndRole()
    local specIndex = GetSpecialization()
    local specID, _, _, _, role = GetSpecializationInfo(specIndex)
    return specID, role
end

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

-- Returns specialization ID and role for the chosen spec whenever it is changed in the options menu
function AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
    local specID, role
    if self.db.profile.lastSelectedSpecID then
        specID, _, _, _, role = GetSpecializationInfoByID(self.db.profile.lastSelectedSpecID)
    else
        specID, role = self:GetCharacterCurrentSpecIDAndRole()
    end

    return specID, role
end

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
            DebugPrint("Enhancement stat frame added:", cleanStatName, "with order =", order)
        end
    end

    -- if stat in position (order - 1) is hidden, there could be overlapping/hidden stats in the Character Info window
    -- Compressing the table so that indices are in a running numeric order rather than potentially having gaps between indices
    AddOn.CompressTable(enhancementStatFrames)

    for order, frame in pairs(enhancementStatFrames) do
        DebugPrint("Reordering frame: ", frame.Label:GetText())
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