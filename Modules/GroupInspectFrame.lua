local addonName, AddOn = ...
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)

local DebugPrint = AddOn.DebugPrint
local ColorText = AddOn.ColorText

function AddOn:SetInspectUnitGUID(unitGUID)
    if self.db.profile.showOnInspect and (not self.db.profile.inspectedUnitGUID or self.db.profile.inspectedUnitGUID ~= unitGUID) then
        self.db.profile.inspectedUnitGUID = unitGUID
        DebugPrint("Currently inspecting: ", ColorText(select(6, GetPlayerInfoByGUID(self.db.profile.inspectedUnitGUID)), "Legendary"), self.db.profile.inspectedUnitGUID)
    end
end

function AddOn:UpdatedInspectedGearInfo(_, unitGUID)
    -- if not IsInRaid() and not IsInGroup() then
    --     print("Not in raid or group")
    --     return
    -- end
    if not AddOn.InspectInfo or not AddOn.InspectInfo.slots then
        DebugPrint("Inspect slots table not found")
        return
    end

    self:SetInspectUnitGUID(unitGUID)
    for _, slotName in ipairs(AddOn.InspectInfo.slots) do
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

function AddOn:SetInspectItemLevelPositionBySlot(slot)
    local IsLeftSide = self.GetSlotIsLeftSide(slot, true)
    slot.PGVItemLevel:ClearAllPoints()

    if self.db.profile.iLvlOnItem then
        slot.PGVItemLevel:SetPoint("CENTER", slot, "TOP", 0, -10)
    elseif IsLeftSide == nil then
        slot.PGVItemLevel:SetPoint("CENTER", slot, "TOP", 0, 10)
    else
        slot.PGVItemLevel:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot, IsLeftSide and "RIGHT" or "LEFT", (IsLeftSide and 1 or -1) * 10, 0)
    end
end

function AddOn:SetInspectUpgradeTrackPositionBySlot(slot)
    local IsLeftSide = self.GetSlotIsLeftSide(slot, true)
    slot.PGVUpgradeTrack:ClearAllPoints()

    if self.db.profile.iLvlOnItem and slot.PGVItemLevel and slot.PGVItemLevel:IsShown() and IsLeftSide == nil then
        slot.PGVUpgradeTrack:SetPoint("CENTER", slot, "BOTTOM", (slot == _G["InspectMainHandSlot"] and -1 or 1) * 35, 5)
    elseif self.db.profile.iLvlOnItem and slot.PGVItemLevel and slot.PGVItemLevel:IsShown() then
        slot.PGVUpgradeTrack:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot, IsLeftSide and "RIGHT" or "LEFT", (IsLeftSide and 1 or -1) * 10, 0)
    elseif slot.PGVItemLevel and slot.PGVItemLevel:IsShown() and IsLeftSide == nil then
        slot.PGVUpgradeTrack:SetPoint("CENTER", slot, "BOTTOM", (slot == _G["InspectMainHandSlot"] and -1 or 1) * 35, 5)
    elseif slot.PGVItemLevel and slot.PGVItemLevel:IsShown() then
        slot.PGVUpgradeTrack:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot.PGVItemLevel, IsLeftSide and "RIGHT" or "LEFT", 0, (0.1 * slot.PGVItemLevel:GetHeight()) / 2)
    end
end

function AddOn:SetInspectGemsPositionBySlot(slot)
    local IsLeftSide = self.GetSlotIsLeftSide(slot, true)
    slot.PGVGems:ClearAllPoints()
    local itemLevelShown = slot.PGVItemLevel and slot.PGVItemLevel:IsShown()
    local upgradeTrackShown = slot.PGVUpgradeTrack and slot.PGVUpgradeTrack:IsShown()

    if self.db.profile.iLvlOnItem and IsLeftSide == nil and itemLevelShown and upgradeTrackShown then
        slot.PGVGems:SetPoint("LEFT", slot.PGVUpgradeTrack, "RIGHT", 0, -1)
    elseif self.db.profile.iLvlOnItem and IsLeftSide == nil and itemLevelShown then
        slot.PGVGems:SetPoint("CENTER", slot, "TOP", 0, 10)
    elseif self.db.profile.iLvlOnItem and itemLevelShown and upgradeTrackShown then
        slot.PGVGems:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot.PGVUpgradeTrack, IsLeftSide and "RIGHT" or "LEFT", 0, -1)
    elseif self.db.profile.iLvlOnItem and itemLevelShown then
        slot.PGVGems:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot, IsLeftSide and "RIGHT" or "LEFT", (IsLeftSide and 1 or -1) * 10, 0)
    elseif IsLeftSide == nil and itemLevelShown and upgradeTrackShown then
        slot.PGVGems:SetPoint("LEFT", slot.PGVUpgradeTrack, "RIGHT", 0, -1)
    elseif IsLeftSide == nil and itemLevelShown then
        slot.PGVGems:SetPoint("LEFT", slot.PGVItemLevel, "RIGHT", 0, 0)
    elseif itemLevelShown and upgradeTrackShown then
        slot.PGVGems:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot.PGVUpgradeTrack, IsLeftSide and "RIGHT" or "LEFT", 0, -1)
    elseif itemLevelShown then
        slot.PGVGems:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot.PGVItemLevel, IsLeftSide and "RIGHT" or "LEFT", 0, 0)
    elseif IsLeftSide == nil then
        slot.PGVGems:SetPoint("CENTER", slot, "TOP", 0, 10)
    else
        slot.PGVGems:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot, IsLeftSide and "RIGHT" or "LEFT", (IsLeftSide and 1 or -1) * 10, 0)
    end
end

function AddOn:SetInspectEnchantPositionBySlot(slot)
    local IsLeftSide = self.GetSlotIsLeftSide(slot, true)
    slot.PGVEnchant:ClearAllPoints()

    local isSocketableSlot = AddOn.IsSocketableSlot(slot)
    local isEnchantableSlot = AddOn.IsEnchantableSlot(slot)
    local itemLevelShown = self.db.profile.showInspectiLvl and not self.db.profile.iLvlOnItem and slot.PGVItemLevel and slot.PGVItemLevel:IsShown()
    local itemLevelShownOnItem = self.db.profile.showInspectiLvl and self.db.profile.iLvlOnItem and slot.PGVItemLevel and slot.PGVItemLevel:IsShown()
    local upgradeTrackShown = self.db.profile.showInspectiLvl and self.db.profile.showInspectUpgradeTrack and slot.PGVUpgradeTrack and slot.PGVUpgradeTrack:IsShown()
    local gemsShown = self.db.profile.showInspectGems and slot.PGVGems and slot.PGVGems:IsShown()
    local defaultYOffset = (itemLevelShownOnItem or (not itemLevelShown and self.db.profile.showInspectGems and not isSocketableSlot)) and 10 or 25

    if IsLeftSide == nil and upgradeTrackShown then
        -- Update positioning for main and off-hand slot enchants when collapsed and upgrade track is shown
        DebugPrint("Adjusting positions for main and off-hand slots with enchant text collapsed")
        slot.PGVEnchant:SetPoint("CENTER", slot, "TOP", 0, 25)
    elseif itemLevelShown and IsLeftSide ~= nil and isEnchantableSlot then
        -- Adjust positioning for slots that have both item level and enchants visible
        DebugPrint("ilvl and enchant visible")
        slot.PGVItemLevel:ClearAllPoints()
        slot.PGVItemLevel:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot, IsLeftSide and "RIGHT" or "LEFT", (IsLeftSide and 1 or -1) * 10, slot:GetHeight() / 4)
        slot.PGVEnchant:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot, IsLeftSide and "RIGHT" or "LEFT", (IsLeftSide and 1 or -1) * 10, (slot:GetHeight() / 4) * -1)
    elseif itemLevelShownOnItem and upgradeTrackShown and IsLeftSide ~= nil and isEnchantableSlot then
        -- Adjust positioning for slots that have both upgrade track and enchants visible
        DebugPrint("upgrade track and enchant visible in slot", slot:GetID())
        slot.PGVUpgradeTrack:ClearAllPoints()
        slot.PGVUpgradeTrack:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot, IsLeftSide and "RIGHT" or "LEFT", (IsLeftSide and 1 or -1) * 10, slot:GetHeight() / 4)
        slot.PGVEnchant:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot, IsLeftSide and "RIGHT" or "LEFT", (IsLeftSide and 1 or -1) * 10, (slot:GetHeight() / 4) * -1)
    elseif (not self.db.profile.showInspectiLvl or itemLevelShownOnItem) and gemsShown and IsLeftSide ~= nil and isSocketableSlot and isEnchantableSlot then
        -- Adjust positioning for slots that have both gems and enchants visible
        slot.PGVGems:ClearAllPoints()
        slot.PGVGems:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot, IsLeftSide and "RIGHT" or "LEFT", (IsLeftSide and 1 or -1) * 10, slot:GetHeight() / 4)
        slot.PGVEnchant:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot, IsLeftSide and "RIGHT" or "LEFT", (IsLeftSide and 1 or -1) * 10, (slot:GetHeight() / 4) * -1)
    elseif IsLeftSide == nil then
        slot.PGVEnchant:SetPoint(slot == _G["InspectMainHandSlot"] and "RIGHT" or "LEFT", slot, slot == _G["InspectMainHandSlot"] and "TOPRIGHT" or "TOPLEFT", 0, 25)
    else
        slot.PGVEnchant:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot, IsLeftSide and "RIGHT" or "LEFT", (IsLeftSide and 1 or -1) * 10, 0)
    end
end
