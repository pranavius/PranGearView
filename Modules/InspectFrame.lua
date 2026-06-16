local addonName, AddOn = ...
---@class PranGearView
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

local DebugPrint = AddOn.DebugPrint
local ColorText = AddOn.ColorText

---Updates displayed info in the Inspect window when AddOn settings are changed or a new character is inspected
---@param unitGUID string The Globally Unique Identifier (GUID) for the character being inspected
---@param forceUpdate? boolean Whether or not to force an update to the information displayed
function AddOn:UpdateInspectedGearInfo(unitGUID, forceUpdate)
    local showOnInspect = self.db.profile.inspect.show
    -- Check for a force update even if the DB value is false (required for toggling inspect visibility via slash command)
    if not showOnInspect and not forceUpdate then
        DebugPrint("UpdateInspectedGearInfo: Gear info on inspect disabled")
        return
    end
    if not IsInRaid() and not IsInGroup() and (InspectFrame.unit and UnitGUID(InspectFrame.unit)) ~= unitGUID then
        DebugPrint("UpdateInspectedGearInfo: Cannot find inspected unit")
        return
    end
    if not self.InspectInfo or not self.InspectInfo.slots then
        DebugPrint("UpdateInspectedGearInfo: Inspect slots table not found")
        return
    end
    
    -- Retained as more of a failsafe in case db variable is not set to nil when the inspect window is closed
    if self.inspectedUnitGUID ~= unitGUID then
        self.inspectedUnitGUID = unitGUID
    end
    -- Fall back to UnitTokenFromGUID if InspectFrame.unit no longer matches the unit being inspected (e.g. inspecting a different raid member).
    -- UnitTokenFromGUID might return a secret, so hopefully it's never needed #prayge
    local unitToken = InspectFrame.unit
    if not unitToken or UnitGUID(unitToken) ~= self.inspectedUnitGUID then
        unitToken = UnitTokenFromGUID(self.inspectedUnitGUID)
    end
    DebugPrint("UpdateInspectedGearInfo: Inspecting: ", ColorText(select(6, GetPlayerInfoByGUID(self.inspectedUnitGUID)), "Uncommon"), ColorText(self.inspectedUnitGUID, "Heirloom"))
    for _, slotName in ipairs(self.InspectInfo.slots) do
        ---@type ItemSlot
        local slot = _G[slotName]
        local slotID = slot:GetID()
        if not slot.PGVInspectSlot then
            ---@type PGVInspectSlotMixin
            slot.PGVInspectSlot = CreateFrame("Frame", "PGVInspectSlot"..slotID, slot, "PGVInspectSlotTemplate")
        else
            slot.PGVInspectSlot:UpdateSlotInfo()
        end
        slot.PGVInspectSlot:SetFontOptions()
    end

    if self.db.profile.inspect.showAvgILvl then
        if InspectPaperDollItemsFrame and not InspectPaperDollItemsFrame.PGVAverageItemLevel then
            InspectPaperDollItemsFrame.PGVAverageItemLevel = InspectPaperDollItemsFrame:CreateFontString("PGVAverageItemLevel", "OVERLAY", "GameTooltipHeader")
            InspectPaperDollItemsFrame.PGVAverageItemLevel:SetPoint("BOTTOMLEFT", InspectPaperDollItemsFrame, "BOTTOMLEFT", 10, 11)
        end
        if not unitToken then
            -- If we've switched to a different unit we never got data for but unitToken is not available, hide the avg. item level FontString
            -- instead of retaining the previous unit's item level and class coloring (misleading).
            if InspectPaperDollItemsFrame.PGVAverageItemLevel.inspectedGUID ~= self.inspectedUnitGUID then
                InspectPaperDollItemsFrame.PGVAverageItemLevel:Hide()
            end
            DebugPrint("UpdateInspectedGearInfo: No usable unit token available, leaving average item level as-is")
            return
        end

        DebugPrint("UpdateInspectedGearInfo: Inspected unit token -", ColorText(unitToken, "Heirloom"))
        local itemLevelText = tostring(C_PaperDollInfo.GetInspectItemLevel(unitToken))
        local classFile = select(2, UnitClass(unitToken))
        local classHexWithAlpha = select(4, GetClassColor(classFile))
        if self.db.profile.inspect.includeAvgLabel then
            DebugPrint("UpdateInspectedGearInfo: Include \"Avg: \" label")
            itemLevelText = L["Avg"]..": "..itemLevelText
        end
        InspectPaperDollItemsFrame.PGVAverageItemLevel:SetText("|c"..classHexWithAlpha..itemLevelText.."|r")
        InspectPaperDollItemsFrame.PGVAverageItemLevel.inspectedGUID = self.inspectedUnitGUID
        InspectPaperDollItemsFrame.PGVAverageItemLevel:Show()
    elseif InspectPaperDollItemsFrame.PGVAverageItemLevel then
        InspectPaperDollItemsFrame.PGVAverageItemLevel:Hide()
    end
end
