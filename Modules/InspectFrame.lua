local addonName, AddOn = ...
---@class PranGearView: AceAddon, AceConsole-3.0, AceEvent-3.0
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

local DebugPrint = AddOn.DebugPrint
local ColorText = AddOn.ColorText

---Updates displayed info in the Inspect window when AddOn settings are changed or a new character is inspected
---@param unitGUID string The Globally Unique Identifier (GUID) for the character being inspected
---@param forceUpdate? boolean Whether or not to force an update to the information displayed
function AddOn:UpdateInspectedGearInfo(unitGUID, forceUpdate)
    local showOnInspect = self.db.profile.showOnInspect
    -- Check for a force update even if the DB value is false (required for toggling inspect visibility via slash command)
    if not showOnInspect and not forceUpdate then
        print("Gear info on inspect disabled")
        return
    end
    if not IsInRaid() and not IsInGroup() and (InspectFrame.unit and UnitGUID(InspectFrame.unit)) ~= unitGUID then
        DebugPrint("Cannot find inspected unit")
        return
    end
    if not self.InspectInfo or not self.InspectInfo.slots then
        DebugPrint("Inspect slots table not found")
        return
    end
    
    -- Retained as more of a failsafe in case db variable is not set to nil when the inspect window is closed
    if self.db.profile.inspectedUnitGUID ~= unitGUID then
        self.db.profile.inspectedUnitGUID = unitGUID
    end
    DebugPrint("Currently inspecting: ", ColorText(select(6, GetPlayerInfoByGUID(self.db.profile.inspectedUnitGUID)), "Uncommon"), ColorText(self.db.profile.inspectedUnitGUID, "Heirloom"))

    local showInspectItemLevel = showOnInspect and self.db.profile.showInspectiLvl
    local showInspectUpgradeTrack = self.db.profile.showInspectUpgradeTrack
    local showInspectGems = showOnInspect and self.db.profile.showInspectGems
    local showInspectEnchants = showOnInspect and self.db.profile.showInspectEnchants
    local showInspectEmbellishments = showOnInspect and self.db.profile.showInspectEmbellishments
    for _, slotName in ipairs(self.InspectInfo.slots) do
        ---@type Slot
        local slot = _G[slotName]
        local slotID = slot:GetID()
        if showInspectItemLevel then
            if not slot.PGVItemLevel then
                slot.PGVItemLevel = slot:CreateFontString("PGVItemLevel"..slotID, "OVERLAY", "GameTooltipText")
            end
            -- Outline text when placed on the gear icon
            local iFont, iSize = slot.PGVItemLevel:GetFont()
            ---@cast iFont string
            if self.db.profile.iLvlOnItem then
                slot.PGVItemLevel:SetFont(iFont, iSize, "THICKOUTLINE")
            else
                slot.PGVItemLevel:SetFont(iFont, iSize, "")
            end
            slot.PGVItemLevel:Hide()
            local iLvlTextScale = 1
            if self.db.profile.iLvlScale and self.db.profile.iLvlScale > 0 then
                iLvlTextScale = iLvlTextScale * self.db.profile.iLvlScale
            end
            slot.PGVItemLevel:SetTextScale(iLvlTextScale)
            
            self:GetItemLevelBySlot(slot, true)
            self:SetInspectItemLevelPositionBySlot(slot)
        elseif slot.PGVItemLevel then
            slot.PGVItemLevel:Hide()
        end


        if showInspectUpgradeTrack then
            if not slot.PGVUpgradeTrack then
                slot.PGVUpgradeTrack = slot:CreateFontString("PGVUpgradeTrack"..slotID, "OVERLAY", "GameTooltipText")
            end
            slot.PGVUpgradeTrack:Hide()
            local upgradeTrackTextScale = 0.9
            if self.db.profile.iLvlScale and self.db.profile.iLvlScale > 0 then
                upgradeTrackTextScale = upgradeTrackTextScale * self.db.profile.iLvlScale
            end
            slot.PGVUpgradeTrack:SetTextScale(upgradeTrackTextScale)

            self:GetUpgradeTrackBySlot(slot, true)
            self:SetInspectUpgradeTrackPositionBySlot(slot)
        elseif slot.PGVUpgradeTrack then
            slot.PGVUpgradeTrack:Hide()
        end

        if showInspectGems then
            if not slot.PGVGems then
                slot.PGVGems = slot:CreateFontString("PGVGems"..slotID, "OVERLAY", "GameTooltipText")
            end
            slot.PGVGems:Hide()
            local gemScale = 1
            if self.db.profile.gemScale and self.db.profile.gemScale > 0 then
                gemScale = gemScale * self.db.profile.gemScale
            end
            slot.PGVGems:SetTextScale(gemScale)

            self:GetGemsBySlot(slot, true)
            self:SetInspectGemsPositionBySlot(slot)
        elseif slot.PGVGems then
            slot.PGVGems:Hide()
        end

        if showInspectEnchants then
            if not slot.PGVEnchant then
                slot.PGVEnchant = slot:CreateFontString("PGVEnchant"..slotID, "OVERLAY", "GameTooltipText")
            end
            local eFont, eSize = slot.PGVEnchant:GetFont()
            ---@cast eFont string
            slot.PGVEnchant:SetFont(eFont, eSize, "OUTLINE")
            slot.PGVEnchant:Hide()
            local enchTextScale = 0.9
            if self.db.profile.enchScale and self.db.profile.enchScale > 0 then
                enchTextScale = enchTextScale * self.db.profile.enchScale
            end
            slot.PGVEnchant:SetTextScale(enchTextScale)

            self:GetEnchantmentBySlot(slot, true)
            self:SetInspectEnchantPositionBySlot(slot)
        elseif slot.PGVEnchant then
            slot.PGVEnchant:Hide()
        end

        if showInspectEmbellishments then
            self:ShowEmbellishmentBySlot(slot, true)
        elseif slot.PGVEmbellishmentTexture then
            slot.PGVEmbellishmentTexture:Hide()
        end

        if self.db.profile.hideShirtTabardInfo and (slot == _G["InspectShirtSlot"] or slot == _G["InspectTabardSlot"]) then
            if slot.PGVItemLevel then slot.PGVItemLevel:Hide() end
            if slot.PGVGems then slot.PGVGems:Hide() end
            if slot.PGVEnchant then slot.PGVEnchant:Hide() end
        end
    end

    if self.db.profile.showInspectAvgILvl then
        if InspectPaperDollItemsFrame and not InspectPaperDollItemsFrame.PGVAverageItemLevel then
            InspectPaperDollItemsFrame.PGVAverageItemLevel = InspectPaperDollItemsFrame:CreateFontString("PGVAverageItemLevel", "OVERLAY", "GameTooltipHeader")
        end
        InspectPaperDollItemsFrame.PGVAverageItemLevel:Hide()
        InspectPaperDollItemsFrame.PGVAverageItemLevel:SetPoint("BOTTOMLEFT", InspectPaperDollItemsFrame, "BOTTOMLEFT", 10, 11)
        local token = UnitTokenFromGUID(self.db.profile.inspectedUnitGUID)
        ---@cast token string
        DebugPrint("Inspected unit token for average item level:", ColorText(token, "Heirloom"))
        local itemLevelText = tostring(C_PaperDollInfo.GetInspectItemLevel(token))
        local classFile = select(2, UnitClass(token))
        local classHexWithAlpha = select(4, GetClassColor(classFile))
        if self.db.profile.includeAvgLabel then
            DebugPrint("Include \"Avg: \" label")
            itemLevelText = L["Avg"]..": "..itemLevelText
        end
        InspectPaperDollItemsFrame.PGVAverageItemLevel:SetFormattedText("|c"..classHexWithAlpha..itemLevelText.."|r")
        InspectPaperDollItemsFrame.PGVAverageItemLevel:Show()
    elseif InspectPaperDollItemsFrame.PGVAverageItemLevel then
        InspectPaperDollItemsFrame.PGVAverageItemLevel:Hide()
    end
end
