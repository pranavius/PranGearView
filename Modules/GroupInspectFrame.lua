local addonName, AddOn = ...
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)

local DebugPrint = AddOn.DebugPrint
local ColorText = AddOn.ColorText

function AddOn:UpdateInspectedGearInfo(unitGUID)
    if not self.db.profile.showOnInspect then
        DebugPrint("Gear info on inspect disabled")
        return
    end
    if not IsInRaid() and not IsInGroup() then
        DebugPrint("Not in raid or party")
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
    for _, slotName in ipairs(self.InspectInfo.slots) do
        local slot = _G[slotName]
        local slotID = slot:GetID()
        if self.db.profile.showInspectiLvl then
            if not slot.PGVItemLevel then
                slot.PGVItemLevel = slot:CreateFontString("PGVItemLevel"..slotID, "OVERLAY", "GameTooltipText")
            end
            -- Outline text when placed on the gear icon
            local iFont, iSize = slot.PGVItemLevel:GetFont()
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


        if self.db.profile.showInspectiLvl and self.db.profile.showInspectUpgradeTrack then
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

        if self.db.profile.showInspectGems then
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

        if self.db.profile.showInspectEnchants then
            if not slot.PGVEnchant then
                slot.PGVEnchant = slot:CreateFontString("PGVEnchant"..slotID, "OVERLAY", "GameTooltipText")
            end
            local eFont, eSize = slot.PGVEnchant:GetFont()
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

        if self.db.profile.showInspectEmbellishments then
            self:ShowEmbellishmentBySlot(slot, true)
        elseif slot.PGVEmbellishmentTexture then
            slot.PGVEmbellishmentTexture:Hide()
        end
    end
end
