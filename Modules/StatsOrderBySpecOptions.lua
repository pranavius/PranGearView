local addonName, AddOn = ...
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)

local PGV_DebugPrint = AddOn.PGV_DebugPrint

-- handles setting all stat order options
function AddOn:SetStatOrderHandler(item, val)
    local specID = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
    local currentOrder = AddOn.db.profile.customSpecStatOrders[specID][item[#item]]
    AddOn.db.profile.customSpecStatOrders[specID][item[#item]] = tonumber(val)
    for stat, order in pairs(AddOn.db.profile.customSpecStatOrders[specID]) do
        if order == tonumber(val) and stat ~= item[#item] then
            PGV_DebugPrint("Duplicate order number found on stat:", stat)
            AddOn.db.profile.customSpecStatOrders[specID][stat] = currentOrder
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

function AddOn:InitializeCustomSpecStatOrderDB(selectedSpecID)
    local specID, role
    if selectedSpecID then
        specID = selectedSpecID
        role = select(5, GetSpecializationInfoByID(selectedSpecID))
    else
        specID, role = self:GetCharacterCurrentSpecIDAndRole()
    end
    if not self.db.profile.customSpecStatOrders[specID] then
        self.db.profile.customSpecStatOrders[specID] = {
            [STAT_CRITICAL_STRIKE] = 1,
            [STAT_HASTE] = 2,
            [STAT_MASTERY] = 3,
            [STAT_VERSATILITY] = 4,
            [STAT_LIFESTEAL] = 5,
            [STAT_AVOIDANCE] = 6,
            [STAT_SPEED] = 7
        }
        -- Tanks have extra secondary stats to consider, so only add those options for Tank specs
        if role == "TANK" then
            self.db.profile.customSpecStatOrders[specID][STAT_DODGE] = 8
            self.db.profile.customSpecStatOrders[specID][STAT_PARRY] = 9
            self.db.profile.customSpecStatOrders[specID][STAT_BLOCK] = 10
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
        local cleanStatName = statFrame.Label:GetText():gsub(":", "")
        if self.db.profile.customSpecStatOrders[specID][cleanStatName] ~= nil then
            local order = self.db.profile.customSpecStatOrders[specID][cleanStatName]
            PGV_DebugPrint("Enhancement Stat Frame:", cleanStatName)
            enhancementStatFrames[order] = statFrame
        end
    end

    for order, frame in ipairs(enhancementStatFrames) do
        frame:ClearAllPoints()
        if order == 1 then
            frame:SetPoint("TOP", CharacterStatsPane.EnhancementsCategory, "BOTTOM", 0, -2)
        else
            frame:SetPoint("TOP", enhancementStatFrames[order - 1], "BOTTOM", 0, 0)
        end
        frame.Background:SetShown((order % 2) == 0)
    end
end