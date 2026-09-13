local _, PGV = ...
local L = PGV.L

local inspectContext = {
    showDurability = false,
    IsShowingItemLevel = function() return PGV.db.inspect.showILvl end,
    IsShowingUpgradeTrack = function() return PGV.db.inspect.showUpgradeTrack end,
    IsShowingGems = function() return PGV.db.inspect.showGems end,
    IsShowingEnchants = function() return PGV.db.inspect.showEnchants end,
    IsShowingEmbellishments = function() return PGV.db.inspect.showEmbellishments end,
}

local function GetInspectSlotCategory(slotName)
    if slotName == "InspectMainHandSlot" or slotName == "InspectSecondaryHandSlot" then
        return "bottom"
    elseif tContains(PGV.InspectInfo.leftSideSlots, slotName) then
        return "left"
    end
    return "right"
end

local function UpdateInspectSlotOverlay(slotName)
    local slot = _G[slotName]
    if not slot then
        return
    end

    local overlay = slot.PGVSlotOverlay
    if not overlay then
        if InCombatLockdown() or PGV.IsAddOnCurrentlyRestricted() then
            return
        end
        overlay = CreateFrame("Frame", nil, slot, "PGVSlotOverlayTemplate")
        overlay.context = setmetatable({
            category = GetInspectSlotCategory(slotName),
            isMainHand = (slotName == "InspectMainHandSlot"),
        }, { __index = inspectContext })
        slot.PGVSlotOverlay = overlay
    end

    overlay:UpdateSlotInfo()
end

local function UpdateAverageItemLevel(unitToken, unitGUID)
    if not InspectPaperDollItemsFrame then
        return
    end

    if not PGV.db.inspect.showAvgILvl then
        if InspectPaperDollItemsFrame.PGVAverageItemLevel then
            InspectPaperDollItemsFrame.PGVAverageItemLevel:Hide()
        end
        return
    end

    if not InspectPaperDollItemsFrame.PGVAverageItemLevel then
        InspectPaperDollItemsFrame.PGVAverageItemLevel = InspectPaperDollItemsFrame:CreateFontString(nil, "OVERLAY", "GameTooltipHeader")
        InspectPaperDollItemsFrame.PGVAverageItemLevel:SetPoint("BOTTOMLEFT", InspectPaperDollItemsFrame, "BOTTOMLEFT", 10, 11)
    end
    local ilvlText = InspectPaperDollItemsFrame.PGVAverageItemLevel

    if not unitToken then
        if ilvlText.inspectedGUID ~= unitGUID then
            ilvlText:Hide()
        end
        return
    end

    local itemLevelText = tostring(C_PaperDollInfo.GetInspectItemLevel(unitToken))
    if PGV.db.inspect.includeAvgLabel then
        itemLevelText = L["Avg"]..": "..itemLevelText
    end
    local classFile = select(2, UnitClass(unitToken))
    ilvlText:SetText(PGV.ColorText(itemLevelText, GetClassColorObj(classFile):GenerateHexColorNoAlpha()))
    ilvlText.inspectedGUID = unitGUID
    ilvlText:Show()
end

function PGV.UpdateInspectedGearInfo(unitGUID, forceUpdate)
    if not PGV.db.inspect.show then
        if forceUpdate then
            for _, slotName in ipairs(PGV.InspectInfo.slots) do
                local slot = _G[slotName]
                if slot and slot.PGVSlotOverlay then
                    slot.PGVSlotOverlay:HideAllElements()
                end
            end
            if InspectPaperDollItemsFrame and InspectPaperDollItemsFrame.PGVAverageItemLevel then
                InspectPaperDollItemsFrame.PGVAverageItemLevel:Hide()
            end
        end
        return
    end
    if not IsInRaid() and not IsInGroup() and (InspectFrame.unit and UnitGUID(InspectFrame.unit)) ~= unitGUID then
        return
    end

    PGV.inspectedUnitGUID = unitGUID

    local unitToken = InspectFrame.unit
    if not unitToken or UnitGUID(unitToken) ~= unitGUID then
        unitToken = UnitTokenFromGUID(unitGUID)
    end
    inspectContext.unit = unitToken

    for _, slotName in ipairs(PGV.InspectInfo.slots) do
        UpdateInspectSlotOverlay(slotName)
    end

    UpdateAverageItemLevel(unitToken, unitGUID)
end

local function RefreshIfInspecting()
    if InspectPaperDollFrame and InspectPaperDollFrame:IsVisible() then
        PGV.UpdateInspectedGearInfo(PGV.inspectedUnitGUID, true)
    end
end

PGV.RegisterEvent("PLAYER_EQUIPMENT_CHANGED", RefreshIfInspecting)
PGV.RegisterEvent("UPDATE_INVENTORY_DURABILITY", RefreshIfInspecting)
PGV.RegisterEvent("SOCKET_INFO_ACCEPT", RefreshIfInspecting)

PGV.RegisterEvent("INSPECT_READY", function(unitGUID)
    if not InspectFrame or not InspectFrame.unit then
        return
    end

    if not PGV.inspectHookSetup then
        InspectFrame:HookScript("OnHide", function()
            PGV.inspectedUnitGUID = nil
            ClearInspectPlayer()
            for _, slotName in ipairs(PGV.InspectInfo.slots) do
                local slot = _G[slotName]
                if slot and slot.PGVSlotOverlay then
                    slot.PGVSlotOverlay:HideAllElements()
                end
            end
            if InspectPaperDollItemsFrame and InspectPaperDollItemsFrame.PGVAverageItemLevel then
                InspectPaperDollItemsFrame.PGVAverageItemLevel:Hide()
            end
        end)
        PGV.inspectHookSetup = true
    end

    PGV.UpdateInspectedGearInfo(unitGUID)
end)
