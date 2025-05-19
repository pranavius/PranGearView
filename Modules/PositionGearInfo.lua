local addonName, AddOn = ...
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)

function AddOn:SetItemLevelPositionBySlot(slot)
    slot.PGVItemLevel:ClearAllPoints()

    if self.db.profile.iLvlOnItem then
        slot.PGVItemLevel:SetPoint("CENTER", slot, "TOP", 0, -10)
    elseif slot.IsLeftSide == nil then
        slot.PGVItemLevel:SetPoint("CENTER", slot, "TOP", 0, 10)
    else
        slot.PGVItemLevel:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, 0)
    end
end

function AddOn:SetInspectItemLevelPositionBySlot(slot)
    local IsLeftSide = self:GetSlotIsLeftSide(slot, true)
    slot.PGVItemLevel:ClearAllPoints()

    if self.db.profile.iLvlOnItem then
        slot.PGVItemLevel:SetPoint("CENTER", slot, "TOP", 0, -10)
    elseif IsLeftSide == nil then
        slot.PGVItemLevel:SetPoint("CENTER", slot, "TOP", 0, 10)
    else
        slot.PGVItemLevel:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot, IsLeftSide and "RIGHT" or "LEFT", (IsLeftSide and 1 or -1) * 10, 0)
    end
end

function AddOn:SetUpgradeTrackPositionBySlot(slot)
    slot.PGVUpgradeTrack:ClearAllPoints()

    if self.db.profile.iLvlOnItem and slot.PGVItemLevel and slot.PGVItemLevel:IsShown() and slot.IsLeftSide == nil then
        slot.PGVUpgradeTrack:SetPoint("CENTER", slot, "BOTTOM", (slot == CharacterMainHandSlot and -1 or 1) * 35, 5)
    elseif self.db.profile.iLvlOnItem and slot.PGVItemLevel and slot.PGVItemLevel:IsShown() then
        slot.PGVUpgradeTrack:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, 0)
    elseif slot.PGVItemLevel and slot.PGVItemLevel:IsShown() and slot.IsLeftSide == nil then
        slot.PGVUpgradeTrack:SetPoint("CENTER", slot, "BOTTOM", (slot == CharacterMainHandSlot and -1 or 1) * 35, 5)
    elseif slot.PGVItemLevel and slot.PGVItemLevel:IsShown() then
        slot.PGVUpgradeTrack:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot.PGVItemLevel, slot.IsLeftSide and "RIGHT" or "LEFT", 0, (0.1 * slot.PGVItemLevel:GetHeight()) / 2)
    end
end

function AddOn:SetInspectUpgradeTrackPositionBySlot(slot)
    local IsLeftSide = self:GetSlotIsLeftSide(slot, true)
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

function AddOn:SetGemsPositionBySlot(slot)
    slot.PGVGems:ClearAllPoints()
    local itemLevelShown = slot.PGVItemLevel and slot.PGVItemLevel:IsShown()
    local upgradeTrackShown = slot.PGVUpgradeTrack and slot.PGVUpgradeTrack:IsShown()

    if self.db.profile.iLvlOnItem and slot.IsLeftSide == nil and itemLevelShown and upgradeTrackShown then
        slot.PGVGems:SetPoint("LEFT", slot.PGVUpgradeTrack, "RIGHT", 0, -1)
    elseif self.db.profile.iLvlOnItem and slot.IsLeftSide == nil and itemLevelShown then
        slot.PGVGems:SetPoint("CENTER", slot, "TOP", 0, 10)
    elseif self.db.profile.iLvlOnItem and itemLevelShown and upgradeTrackShown then
        slot.PGVGems:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot.PGVUpgradeTrack, slot.IsLeftSide and "RIGHT" or "LEFT", 0, -1)
    elseif self.db.profile.iLvlOnItem and itemLevelShown then
        slot.PGVGems:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, 0)
    elseif slot.IsLeftSide == nil and itemLevelShown and upgradeTrackShown then
        slot.PGVGems:SetPoint("LEFT", slot.PGVUpgradeTrack, "RIGHT", 0, -1)
    elseif slot.IsLeftSide == nil and itemLevelShown then
        slot.PGVGems:SetPoint("LEFT", slot.PGVItemLevel, "RIGHT", 0, 0)
    elseif itemLevelShown and upgradeTrackShown then
        slot.PGVGems:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot.PGVUpgradeTrack, slot.IsLeftSide and "RIGHT" or "LEFT", 0, -1)
    elseif itemLevelShown then
        slot.PGVGems:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot.PGVItemLevel, slot.IsLeftSide and "RIGHT" or "LEFT", 0, 0)
    elseif slot.IsLeftSide == nil then
        slot.PGVGems:SetPoint("CENTER", slot, "TOP", 0, 10)
    else
        slot.PGVGems:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, 0)
    end
end

function AddOn:SetInspectGemsPositionBySlot(slot)
    local IsLeftSide = self:GetSlotIsLeftSide(slot, true)
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

function AddOn:SetEnchantPositionBySlot(slot)
    slot.PGVEnchant:ClearAllPoints()

    local isSocketableSlot = self:IsSocketableSlot(slot)
    local isEnchantableSlot = self:IsEnchantableSlot(slot)
    local itemLevelShown = self.db.profile.showiLvl and not self.db.profile.iLvlOnItem and slot.PGVItemLevel and slot.PGVItemLevel:IsShown()
    local itemLevelShownOnItem = self.db.profile.showiLvl and self.db.profile.iLvlOnItem and slot.PGVItemLevel and slot.PGVItemLevel:IsShown()
    local upgradeTrackShown = self.db.profile.showiLvl and self.db.profile.showUpgradeTrack and slot.PGVUpgradeTrack and slot.PGVUpgradeTrack:IsShown()
    local gemsShown = self.db.profile.showGems and slot.PGVGems and slot.PGVGems:IsShown()
    local defaultYOffset = (itemLevelShownOnItem or (not itemLevelShown and self.db.profile.showGems and not isSocketableSlot)) and 10 or 25

    if self.db.profile.collapseEnchants and slot.IsLeftSide == nil and upgradeTrackShown then
        -- Update positioning for main and off-hand slot enchants when collapsed and upgrade track is shown
        DebugPrint("Adjusting positions for main and off-hand slots with enchant text collapsed")
        slot.PGVEnchant:SetPoint("CENTER", slot, "TOP", 0, 25)
    elseif self.db.profile.collapseEnchants and slot.IsLeftSide == nil then
        -- Update positioning for main and off-hand slot enchants when collapsed
        DebugPrint("Adjusting positions for main and off-hand slots with enchant text collapsed")
        slot.PGVEnchant:SetPoint("CENTER", slot, "TOP", 0, defaultYOffset)
    elseif itemLevelShown and slot.IsLeftSide ~= nil and isEnchantableSlot then
        -- Adjust positioning for slots that have both item level and enchants visible
        DebugPrint("ilvl and enchant visible")
        slot.PGVItemLevel:ClearAllPoints()
        slot.PGVItemLevel:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, slot:GetHeight() / 4)
        slot.PGVEnchant:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, (slot:GetHeight() / 4) * -1)
    elseif itemLevelShownOnItem and upgradeTrackShown and slot.IsLeftSide ~= nil and isEnchantableSlot then
        -- Adjust positioning for slots that have both upgrade track and enchants visible
        DebugPrint("upgrade track and enchant visible in slot", slot:GetID())
        slot.PGVUpgradeTrack:ClearAllPoints()
        slot.PGVUpgradeTrack:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, slot:GetHeight() / 4)
        slot.PGVEnchant:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, (slot:GetHeight() / 4) * -1)
    elseif (not self.db.profile.showiLvl or itemLevelShownOnItem) and gemsShown and slot.IsLeftSide ~= nil and isSocketableSlot and isEnchantableSlot then
        -- Adjust positioning for slots that have both gems and enchants visible
        slot.PGVGems:ClearAllPoints()
        slot.PGVGems:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, slot:GetHeight() / 4)
        slot.PGVEnchant:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, (slot:GetHeight() / 4) * -1)
    elseif slot.IsLeftSide == nil then
        slot.PGVEnchant:SetPoint(slot == CharacterMainHandSlot and "RIGHT" or "LEFT", slot, slot == CharacterMainHandSlot and "TOPRIGHT" or "TOPLEFT", 0, 25)
    else
        slot.PGVEnchant:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, 0)
    end
end

function AddOn:SetInspectEnchantPositionBySlot(slot)
    local IsLeftSide = self:GetSlotIsLeftSide(slot, true)
    slot.PGVEnchant:ClearAllPoints()

    local isSocketableSlot = self:IsSocketableSlot(slot)
    local isEnchantableSlot = self:IsEnchantableSlot(slot)
    local itemLevelShown = self.db.profile.showInspectiLvl and not self.db.profile.iLvlOnItem and slot.PGVItemLevel and slot.PGVItemLevel:IsShown()
    local itemLevelShownOnItem = self.db.profile.showInspectiLvl and self.db.profile.iLvlOnItem and slot.PGVItemLevel and slot.PGVItemLevel:IsShown()
    local upgradeTrackShown = self.db.profile.showInspectiLvl and self.db.profile.showInspectUpgradeTrack and slot.PGVUpgradeTrack and slot.PGVUpgradeTrack:IsShown()
    local gemsShown = self.db.profile.showInspectGems and slot.PGVGems and slot.PGVGems:IsShown()

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
        slot.PGVEnchant:SetPoint(slot == _G["InspectMainHandSlot"] and "RIGHT" or "LEFT", slot, slot == _G["InspectMainHandSlot"] and "TOPRIGHT" or "TOPLEFT", (slot == _G["InspectMainHandSlot"] and -1 or 1) * 15, 25)
    else
        slot.PGVEnchant:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot, IsLeftSide and "RIGHT" or "LEFT", (IsLeftSide and 1 or -1) * 10, 0)
    end
end
