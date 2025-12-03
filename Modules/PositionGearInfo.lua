local addonName, AddOn = ...
---@class PranGearView: AceAddon, AceConsole-3.0, AceEvent-3.0
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)

local DebugPrint = AddOn.DebugPrint

---Set item level text position in the Character Info window
---@param slot Slot The gear slot to set item level position for
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

---Set item level text position in the Inspect window
---@param slot Slot The gear slot to set item level position for
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

---Set upgrade track text position in the Character Info window
---@param slot Slot The gear slot to set upgrade tracks position for
function AddOn:SetUpgradeTrackPositionBySlot(slot)
    slot.PGVUpgradeTrack:ClearAllPoints()
    local itemLevelShown = self.db.profile.showiLvl and not self.db.profile.iLvlOnItem and slot.PGVItemLevel and slot.PGVItemLevel:IsShown()
    local itemLevelShownOnItem = self.db.profile.showiLvl and self.db.profile.iLvlOnItem and slot.PGVItemLevel and slot.PGVItemLevel:IsShown()
    local isMainHand = slot == CharacterMainHandSlot

    if slot.IsLeftSide == nil then
        slot.PGVUpgradeTrack:SetPoint("CENTER", slot, "BOTTOM", (isMainHand and -1 or 1) * 40, 5)
    elseif itemLevelShownOnItem then
        slot.PGVUpgradeTrack:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, 0)
    elseif itemLevelShown then
        slot.PGVUpgradeTrack:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot.PGVItemLevel, slot.IsLeftSide and "RIGHT" or "LEFT", slot.IsLeftSide and 2.5 or -2.5, 0)
    else
        slot.PGVUpgradeTrack:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, 0)
    end
end

---Set upgrade track text position in the Inspect window
---@param slot Slot The gear slot to set upgrade tracks position for
function AddOn:SetInspectUpgradeTrackPositionBySlot(slot)
    local IsLeftSide = self:GetSlotIsLeftSide(slot, true)
    slot.PGVUpgradeTrack:ClearAllPoints()
    local itemLevelShown = self.db.profile.showInspectiLvl and not self.db.profile.iLvlOnItem and slot.PGVItemLevel and slot.PGVItemLevel:IsShown()
    local itemLevelShownOnItem = self.db.profile.showInspectiLvl and self.db.profile.iLvlOnItem and slot.PGVItemLevel and slot.PGVItemLevel:IsShown()
    local isMainHand = slot == _G["InspectMainHandSlot"]

    if IsLeftSide == nil then
        slot.PGVUpgradeTrack:SetPoint("CENTER", slot, "BOTTOM", (isMainHand and -1 or 1) * 40, 5)
    elseif itemLevelShownOnItem then
        slot.PGVUpgradeTrack:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot, IsLeftSide and "RIGHT" or "LEFT", (IsLeftSide and 1 or -1) * 10, 0)
    elseif itemLevelShown then
        slot.PGVUpgradeTrack:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot.PGVItemLevel, IsLeftSide and "RIGHT" or "LEFT", IsLeftSide and 2.5 or -2.5, 0)
    else
        slot.PGVUpgradeTrack:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot, IsLeftSide and "RIGHT" or "LEFT", (IsLeftSide and 1 or -1) * 10, 0)
    end
end

---Set gems text position in the Character Info window
---@param slot Slot The gear slot to set gems position for
function AddOn:SetGemsPositionBySlot(slot)
    slot.PGVGems:ClearAllPoints()
    local itemLevelShown = self.db.profile.showiLvl and not self.db.profile.iLvlOnItem and slot.PGVItemLevel and slot.PGVItemLevel:IsShown()
    local itemLevelShownOnItem = self.db.profile.showiLvl and self.db.profile.iLvlOnItem and slot.PGVItemLevel and slot.PGVItemLevel:IsShown()
    local upgradeTrackShown = self:ShouldShowUpgradeTrack() and slot.PGVUpgradeTrack and slot.PGVUpgradeTrack:IsShown()
    local isMainHand = slot == CharacterMainHandSlot

    -- Gems on weapon/shield/off-hand slots (not possible as far as I am aware, but you never know)
    if upgradeTrackShown and slot.IsLeftSide == nil then
        slot.PGVGems:SetPoint(isMainHand and "RIGHT" or "LEFT", slot.PGVUpgradeTrack, isMainHand and "LEFT" or "RIGHT", isMainHand and -1 or 1, 0)
    elseif upgradeTrackShown then
        slot.PGVGems:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot.PGVUpgradeTrack, slot.IsLeftSide and "RIGHT" or "LEFT", slot.IsLeftSide and 1 or -1, 0)
    elseif itemLevelShownOnItem and slot.IsLeftSide == nil then
        slot.PGVGems:SetPoint("CENTER", slot, "BOTTOM", (isMainHand and -1 or 1) * 40, 5)
    elseif itemLevelShownOnItem then
        slot.PGVGems:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, 0)
    elseif itemLevelShown and slot.IsLeftSide == nil then
        slot.PGVGems:SetPoint("LEFT", slot.PGVItemLevel, "RIGHT", 1, 0)
    elseif itemLevelShown then
        slot.PGVGems:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot.PGVItemLevel, slot.IsLeftSide and "RIGHT" or "LEFT", slot.IsLeftSide and 1 or -1, 0)
    elseif slot.IsLeftSide == nil then
        slot.PGVGems:SetPoint("CENTER", slot, "TOP", 0, 10)
    else
        slot.PGVGems:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, 0)
    end
end

---Set gems text position in the Inspect window
---@param slot Slot The gear slot to set gems position for
function AddOn:SetInspectGemsPositionBySlot(slot)
    local IsLeftSide = self:GetSlotIsLeftSide(slot, true)
    slot.PGVGems:ClearAllPoints()
    local itemLevelShown = self.db.profile.showInspectiLvl and not self.db.profile.iLvlOnItem and slot.PGVItemLevel and slot.PGVItemLevel:IsShown()
    local itemLevelShownOnItem = self.db.profile.showInspectiLvl and self.db.profile.iLvlOnItem and slot.PGVItemLevel and slot.PGVItemLevel:IsShown()
    local upgradeTrackShown = self.db.profile.showInspectUpgradeTrack and slot.PGVUpgradeTrack and slot.PGVUpgradeTrack:IsShown() and not PlayerGetTimerunningSeasonID()
    local isMainHand = slot == _G["InspectMainHandSlot"]

    if upgradeTrackShown and IsLeftSide == nil then
        slot.PGVGems:SetPoint(isMainHand and "RIGHT" or "LEFT", slot.PGVUpgradeTrack, isMainHand and "LEFT" or "RIGHT", isMainHand and -1 or 1, 0)
    elseif upgradeTrackShown then
        slot.PGVGems:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot.PGVUpgradeTrack, IsLeftSide and "RIGHT" or "LEFT", IsLeftSide and 1 or -1, 0)
    elseif itemLevelShownOnItem and IsLeftSide == nil then
        slot.PGVGems:SetPoint("CENTER", slot, "BOTTOM", (isMainHand and -1 or 1) * 40, 5)
    elseif itemLevelShownOnItem then
        slot.PGVGems:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot, IsLeftSide and "RIGHT" or "LEFT", (IsLeftSide and 1 or -1) * 10, 0)
    elseif itemLevelShown and IsLeftSide == nil then
        slot.PGVGems:SetPoint("LEFT", slot.PGVItemLevel, "RIGHT", 1, 0)
    elseif itemLevelShown then
        slot.PGVGems:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot.PGVItemLevel, IsLeftSide and "RIGHT" or "LEFT", IsLeftSide and 1 or -1, 0)
    elseif IsLeftSide == nil then
        slot.PGVGems:SetPoint("CENTER", slot, "TOP", 0, 10)
    else
        slot.PGVGems:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot, IsLeftSide and "RIGHT" or "LEFT", (IsLeftSide and 1 or -1) * 10, 0)
    end
end

---Set enchant text position in the Character Info window
---@param slot Slot The gear slot to set enchant position for
function AddOn:SetEnchantPositionBySlot(slot)
    slot.PGVEnchant:ClearAllPoints()

    local isSocketableSlot = self:IsSocketableSlot(slot) or self:IsAuxSocketableSlot(slot)
    local isEnchantableSlot = self:IsEnchantableSlot(slot)
    local itemLevelShown = self.db.profile.showiLvl and not self.db.profile.iLvlOnItem and slot.PGVItemLevel and slot.PGVItemLevel:IsShown()
    local itemLevelShownOnItem = self.db.profile.showiLvl and self.db.profile.iLvlOnItem and slot.PGVItemLevel and slot.PGVItemLevel:IsShown()
    local upgradeTrackShown = self:ShouldShowUpgradeTrack() and slot.PGVUpgradeTrack and slot.PGVUpgradeTrack:IsShown()
    local gemsShown = self:ShouldShowGems() and slot.PGVGems and slot.PGVGems:IsShown()
    local defaultYOffset = (itemLevelShownOnItem or (not itemLevelShown and self:ShouldShowGems() and not isSocketableSlot)) and 10 or 25

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
        slot.PGVItemLevel:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, slot.PGVItemLevel:GetHeight() / 1.5)
        slot.PGVEnchant:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, (slot.PGVItemLevel:GetHeight() / 1.5) * -1)
    elseif upgradeTrackShown and slot.IsLeftSide ~= nil and isEnchantableSlot then
        -- Adjust positioning for slots that have both upgrade track and enchants visible
        DebugPrint("upgrade track and enchant visible in slot", slot:GetID())
        slot.PGVUpgradeTrack:ClearAllPoints()
        slot.PGVUpgradeTrack:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, slot.PGVUpgradeTrack:GetHeight() / 1.5)
        slot.PGVEnchant:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, (slot.PGVUpgradeTrack:GetHeight() / 1.5) * -1)
    elseif (not self.db.profile.showiLvl or itemLevelShownOnItem) and gemsShown and slot.IsLeftSide ~= nil and isSocketableSlot and isEnchantableSlot then
        -- Adjust positioning for slots that have both gems and enchants visible
        slot.PGVGems:ClearAllPoints()
        slot.PGVGems:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, slot.PGVGems:GetHeight() / 1.5)
        slot.PGVEnchant:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, (slot.PGVGems:GetHeight() / 1.5) * -1)
    elseif slot.IsLeftSide == nil then
        slot.PGVEnchant:SetPoint(slot == CharacterMainHandSlot and "RIGHT" or "LEFT", slot, slot == CharacterMainHandSlot and "TOPRIGHT" or "TOPLEFT", 0, 25)
    else
        slot.PGVEnchant:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, 0)
    end
end

---Set enchant text position in the Inspect window
---@param slot Slot The gear slot to set enchant position for
function AddOn:SetInspectEnchantPositionBySlot(slot)
    local IsLeftSide = self:GetSlotIsLeftSide(slot, true)
    slot.PGVEnchant:ClearAllPoints()

    local isSocketableSlot = self:IsSocketableSlot(slot) or self:IsAuxSocketableSlot(slot)
    local isEnchantableSlot = self:IsEnchantableSlot(slot)
    local itemLevelShown = self.db.profile.showInspectiLvl and not self.db.profile.iLvlOnItem and slot.PGVItemLevel and slot.PGVItemLevel:IsShown()
    local itemLevelShownOnItem = self.db.profile.showInspectiLvl and self.db.profile.iLvlOnItem and slot.PGVItemLevel and slot.PGVItemLevel:IsShown()
    local upgradeTrackShown = self.db.profile.showInspectUpgradeTrack and slot.PGVUpgradeTrack and slot.PGVUpgradeTrack:IsShown()
    local gemsShown = self.db.profile.showInspectGems and slot.PGVGems and slot.PGVGems:IsShown() and not PlayerGetTimerunningSeasonID()

    
    if itemLevelShown and IsLeftSide ~= nil and isEnchantableSlot then
        -- Adjust positioning for slots that have both item level and enchants visible
        DebugPrint("ilvl and enchant visible")
        slot.PGVItemLevel:ClearAllPoints()
        slot.PGVItemLevel:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot, IsLeftSide and "RIGHT" or "LEFT", (IsLeftSide and 1 or -1) * 10, slot.PGVItemLevel:GetHeight() / 1.5)
        slot.PGVEnchant:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot, IsLeftSide and "RIGHT" or "LEFT", (IsLeftSide and 1 or -1) * 10, (slot.PGVItemLevel:GetHeight() / 1.5) * -1)
    elseif upgradeTrackShown and IsLeftSide ~= nil and isEnchantableSlot then
        -- Adjust positioning for slots that have both upgrade track and enchants visible
        DebugPrint("upgrade track and enchant visible in slot", slot:GetID())
        slot.PGVUpgradeTrack:ClearAllPoints()
        slot.PGVUpgradeTrack:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot, IsLeftSide and "RIGHT" or "LEFT", (IsLeftSide and 1 or -1) * 10, slot.PGVUpgradeTrack:GetHeight() / 1.5)
        slot.PGVEnchant:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot, IsLeftSide and "RIGHT" or "LEFT", (IsLeftSide and 1 or -1) * 10, (slot.PGVUpgradeTrack:GetHeight() / 1.5) * -1)
    elseif (not self.db.profile.showInspectiLvl or itemLevelShownOnItem) and gemsShown and IsLeftSide ~= nil and isSocketableSlot and isEnchantableSlot then
        -- Adjust positioning for slots that have both gems and enchants visible
        slot.PGVGems:ClearAllPoints()
        slot.PGVGems:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot, IsLeftSide and "RIGHT" or "LEFT", (IsLeftSide and 1 or -1) * 10, slot.PGVGems:GetHeight() / 1.5)
        slot.PGVEnchant:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot, IsLeftSide and "RIGHT" or "LEFT", (IsLeftSide and 1 or -1) * 10, (slot.PGVGems:GetHeight() / 1.5) * -1)
    elseif IsLeftSide == nil and itemLevelShown then
        -- Update positioning for main and off-hand slot enchants when item level is shown in default position
        slot.PGVEnchant:SetPoint(slot == _G["InspectMainHandSlot"] and "BOTTOMRIGHT" or "BOTTOMLEFT", slot.PGVItemLevel, slot == _G["InspectMainHandSlot"] and "TOPRIGHT" or "TOPLEFT", 0, 5)
    elseif IsLeftSide == nil then
        slot.PGVEnchant:SetPoint(slot == _G["InspectMainHandSlot"] and "RIGHT" or "LEFT", slot, slot == _G["InspectMainHandSlot"] and "TOPRIGHT" or "TOPLEFT", 0, 25)
    else
        slot.PGVEnchant:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot, IsLeftSide and "RIGHT" or "LEFT", (IsLeftSide and 1 or -1) * 10, 0)
    end
end
