local _, PGV = ...
local L = PGV.L

PGV.StatsCache = {}

function PGV.GetCharacterCurrentSpecIDAndRole()
    local specIndex = C_SpecializationInfo.GetSpecialization()
    local specID, _, _, _, role = C_SpecializationInfo.GetSpecializationInfo(specIndex)
    return specID, role
end

function PGV.GetSpecAndRoleForSelectedCharacterStatsOption()
    if PGV.db.characterStats.lastSelectedSpecID then
        local specID, _, _, _, role = GetSpecializationInfoByID(PGV.db.characterStats.lastSelectedSpecID)
        return specID, role
    end
    return PGV.GetCharacterCurrentSpecIDAndRole()
end

local function buildDefaultStatOrder(role)
    local order = CopyTable(PGV.DefaultStatOrder)
    if role == "TANK" then
        for _, stat in ipairs(PGV.DefaultTankStatOrder) do
            tinsert(order, stat)
        end
    end
    return order
end

function PGV.IsStatOrderAtDefault(specID)
    local order = specID and PGV.db.characterStats.customSpecStatOrders[specID]
    if not order then
        return true
    end
    local role = select(5, GetSpecializationInfoByID(specID))
    local defaultOrder = buildDefaultStatOrder(role)
    if #order ~= #defaultOrder then
        return false
    end
    for index, stat in ipairs(order) do
        if stat ~= defaultOrder[index] then
            return false
        end
    end
    return true
end

function PGV.InitializeCustomSpecStatOrderDB(selectedSpecID, reset)
    local specID, role
    if selectedSpecID then
        specID = selectedSpecID
        role = select(5, GetSpecializationInfoByID(selectedSpecID))
    else
        specID, role = PGV.GetCharacterCurrentSpecIDAndRole()
    end
    if not specID then
        return
    end
    local order = PGV.db.characterStats.customSpecStatOrders[specID]
    if not order or #order == 0 or reset then
        PGV.db.characterStats.customSpecStatOrders[specID] = buildDefaultStatOrder(role)
    end
end

function PGV.SetStatOrderForEditingSpec(newOrder)
    local specID = PGV.GetSpecAndRoleForSelectedCharacterStatsOption()
    if not specID then
        return
    end
    PGV.db.characterStats.customSpecStatOrders[specID] = newOrder
    PGV.ReorderStatFramesBySpec()
end

function PGV.CachePlayerStatValues()
    if C_Secrets.ShouldUnitStatsBeSecret() then
        return
    end
    for _, statFrame in ipairs({ CharacterStatsPane:GetChildren() }) do
        if statFrame.Label and statFrame.Label:GetText() then
            PGV.StatsCache[statFrame.Label:GetText():gsub(":", "")] = statFrame.numericValue
        end
    end
end

function PGV.ReorderStatFramesBySpec()
    local specID = PGV.GetCharacterCurrentSpecIDAndRole()
    local statOrder = specID and PGV.db.characterStats.customSpecStatOrders[specID]
    if not statOrder then
        return
    end

    local frameByStat = {}
    for _, statFrame in ipairs({ CharacterStatsPane:GetChildren() }) do
        if statFrame.Label then
            local localeStatName = statFrame.Label:GetText() and statFrame.Label:GetText():gsub(":", "")
            for _, stat in ipairs(statOrder) do
                if L[stat] == localeStatName then
                    frameByStat[stat] = statFrame
                    break
                end
            end
        end
    end

    local previousFrame, position
    for _, stat in ipairs(statOrder) do
        local frame = frameByStat[stat]
        if frame then
            position = (position or 0) + 1
            frame:ClearAllPoints()
            if previousFrame then
                frame:SetPoint("TOP", previousFrame, "BOTTOM", 0, 0)
            else
                frame:SetPoint("TOP", CharacterStatsPane.EnhancementsCategory, "BOTTOM", 0, -2)
            end
            frame.Background:SetShown((position % 2) == 0)
            previousFrame = frame
        end
    end
end

function PGV.ShowDecimalStatValues()
    for _, frame in ipairs({ CharacterStatsPane:GetChildren() }) do
        if frame.Label then
            local cleanStatName = frame.Label:GetText() and frame.Label:GetText():gsub(":", "")
            if cleanStatName and PGV.StatsCache[cleanStatName] then
                if issecretvalue(PGV.StatsCache[cleanStatName]) then
                    PGV.StatsCache[cleanStatName] = nil
                elseif PGV.StatsCache[cleanStatName] % 1 ~= 0 then
                    frame.Value:SetFormattedText("%."..PGV.db.characterStats.decimalPlaces.."f%%", PGV.StatsCache[cleanStatName])
                end
            end
        end
    end
end

CharacterStatsPane:HookScript("OnShow", PGV.CachePlayerStatValues)

hooksecurefunc("PaperDollFrame_UpdateStats", function()
    PGV.ReorderStatFramesBySpec()
    if CharacterStatsPane and PGV.db.characterStats.showDecimals then
        PGV.ShowDecimalStatValues()
    end
end)

PGV.RegisterEvent("PLAYER_ENTERING_WORLD", function(isInitialLogin, isReloadingUi)
    if isInitialLogin or isReloadingUi then
        PGV.InitializeCustomSpecStatOrderDB()
    end
end)

PGV.RegisterEvent("ACTIVE_PLAYER_SPECIALIZATION_CHANGED", function()
    PGV.InitializeCustomSpecStatOrderDB()
end)

SettingsPanel:HookScript("OnShow", function()
    PGV.db.characterStats.lastSelectedSpecID = select(1, PGV.GetCharacterCurrentSpecIDAndRole())
    PGV.RefreshStatOrderList()
end)
