local addonName, PGV = ...
local L = PGV.L

local function AdjustCharacterInfoWindowSize()
    if InCombatLockdown() or not PaperDollFrame:IsVisible() then
        return
    end

    if PGV.db.general.increaseCharacterInfoSize then
        CharacterFrame:SetWidth(650)
        CharacterFrameInset:SetPoint("BOTTOMRIGHT", CharacterFrame, "BOTTOMLEFT", 450, 4)
        CharacterModelScene:SetPoint("BOTTOMRIGHT", CharacterFrameInset, "BOTTOMLEFT", 400, 35)
        CharacterMainHandSlot:SetPoint("BOTTOMLEFT", PaperDollItemsFrame, "BOTTOMLEFT", 200, 16)
        CharacterModelFrameBackgroundTopLeft:SetWidth(331)
        CharacterModelFrameBackgroundBotLeft:SetWidth(331)
        return
    end

    local charFrameInsetBotRightXOffset = select(4, CharacterFrameInset:GetPointByName("BOTTOMRIGHT"))
    local charModelSceneBotRight = CharacterModelScene:GetPointByName("BOTTOMRIGHT")
    local charMainHandSlotBotLeftXOffset = select(4, CharacterMainHandSlot:GetPointByName("BOTTOMLEFT"))
    if CharacterFrame:GetWidth() ~= CHARACTERFRAME_EXPANDED_WIDTH then
        CharacterFrame:SetWidth(CHARACTERFRAME_EXPANDED_WIDTH)
    end
    if charFrameInsetBotRightXOffset ~= 32 then
        CharacterFrameInset:SetPoint("BOTTOMRIGHT", CharacterFrame, "BOTTOMLEFT", 332, 4)
    end
    if charModelSceneBotRight then
        CharacterModelScene:ClearPoint("BOTTOMRIGHT")
    end
    if charMainHandSlotBotLeftXOffset ~= 130 then
        CharacterMainHandSlot:SetPoint("BOTTOMLEFT", PaperDollItemsFrame, "BOTTOMLEFT", 130, 16)
    end
    if CharacterModelFrameBackgroundTopLeft:GetWidth() ~= 212 then
        CharacterModelFrameBackgroundTopLeft:SetWidth(212)
    end
    if CharacterModelFrameBackgroundBotLeft:GetWidth() ~= 212 then
        CharacterModelFrameBackgroundBotLeft:SetWidth(212)
    end

    local actor = CharacterModelScene:GetPlayerActor()
    if actor then
        if actor:GetRequestedScale() then
            actor.requestedScale = nil
        end
        actor:UpdateScale()
        if select(3, actor:GetPosition()) > 1.25 then
            actor:SetPosition(0, 0, select(3, actor:GetPosition()) - 0.25)
        end
    end
end

PGV.AdjustCharacterInfoWindowSize = AdjustCharacterInfoWindowSize

hooksecurefunc(CharacterFrame, "RefreshDisplay", AdjustCharacterInfoWindowSize)

hooksecurefunc(CharacterModelScene, "TransitionToModelSceneID", function(cms, sceneID)
    if sceneID == 595 and PaperDollFrame:IsVisible() and PGV.db.general.increaseCharacterInfoSize then
        local actor = cms:GetPlayerActor()
        actor:SetRequestedScale(actor:GetRequestedScale() * 0.8)
        actor:UpdateScale()
        local posX, posY, posZ = actor:GetPosition()
        actor:SetPosition(posX, posY, posZ + 0.25)
    end
end)

hooksecurefunc("PaperDollFrame_UpdateStats", function()
    if CharacterStatsPane and PGV.db.general.showCharacteriLvlDecimal then
        CharacterStatsPane.ItemLevelFrame.Value:SetFormattedText("%."..PGV.db.general.decimalPlacesForCharacteriLvl.."f", select(2, GetAverageItemLevel()))
    end
end)

PGV.RegisterEvent("ADDON_LOADED", function(loadedAddon)
    if loadedAddon ~= addonName then return end

    local LDB = LibStub("LibDataBroker-1.1")
    local LDBIcon = LibStub("LibDBIcon-1.0")
    local broker = LDB:NewDataObject(addonName, {
        type = "launcher",
        text = addonName,
        icon = "Interface/AddOns/PranGearView/Media/PranGearViewIcon",
        OnClick = function()
            if not PGV.IsAddOnCurrentlyRestricted() then
                Settings.OpenToCategory(PGV.categoryID)
            end
        end,
        OnTooltipShow = function(tt)
            tt:AddLine(addonName)
            tt:AddLine(L["Open the AddOn options window"], 1, 1, 1)
        end,
    })
    LDBIcon:Register(addonName, broker, PGV.db.general.minimap)
end)
