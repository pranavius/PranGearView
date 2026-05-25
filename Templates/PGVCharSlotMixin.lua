local addonName, AddOn = ...
---@class PranGearView
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

local DebugPrint = AddOn.DebugPrint
local ColorText = AddOn.ColorText

---@class PGVCharSlotMixin: PGVSlotMixinBase
PGVCharSlotMixin = {}
Mixin(PGVCharSlotMixin, PGVSlotMixinBase)

function PGVCharSlotMixin:OnLoad()
    self.DurabilityBar:SetScript("OnShow", function() self:OnShowDurabilityBar() end)
    self.DurabilityBar:SetScript("OnHide", function() self:OnHideDurabilityBar() end)
    self.Durability:SetScript("OnShow", function() self:OnShowDurabilityText() end)
    self:UpdateSlotInfo()
end

---Executes logic to determine and position necessary information about the item equipped in the parent gear slot
function PGVCharSlotMixin:UpdateSlotInfo()
    ---@type ItemSlot
    local slot = self:GetParent()
    self.IsLeftSideSlot = slot.IsLeftSide == true
    self.IsBottomSlot = slot.IsLeftSide == nil
    local hasItem, item = AddOn:IsItemEquippedInSlot(slot)
    local shouldHideSlotDetails = AddOn.db.profile.general.hideShirtTabardInfo and (slot == CharacterShirtSlot or slot == CharacterTabardSlot)

    if hasItem and not shouldHideSlotDetails then
        if self:IsShowingItemLevel() then
            self:GetItemLevel(slot, item)
            self:PositionItemLevel()
        elseif self.ItemLevel:IsShown() then
            self.ItemLevel:Hide()
        end

        if self:IsShowingUpgradeTrack() then
            self:GetUpgradeTrack(slot, item)
            self:PositionUpgradeTrack(slot == self:GetMainHandSlot())
        elseif self.UpgradeTrack:IsShown() then
            self.UpgradeTrack:Hide()
        end

        if self:IsShowingGems() then
            self:GetGems(slot, item)
            self:PositionGems(slot == self:GetMainHandSlot())
        elseif self.Gems:IsShown() then
            self.Gems:Hide()
        end

        if self:IsShowingEnchants() then
            self:GetEnchant(slot, item)
            self:PositionEnchant(slot)
        elseif self.Enchant:IsShown() then
            self.Enchant:Hide()
        end

        if AddOn.db.profile.durability.show then
            self:GetAndPositionDurability(slot)
        elseif self.Durability:IsShown() or self.DurabilityBar:IsShown() then
            self.Durability:Hide()
            self.DurabilityBar:Hide()
        end

        if self:IsShowingEmbellishments() then
            self:GetEmbellishment(slot, item)
        elseif self.Embellishment:IsShown() then
            self:SetEmbellishmentVisible(false)
        end
    elseif not hasItem then
        self:HideAllFrames()
    end
end

---Extends base SetFontOptions to also apply durability text font options
function PGVCharSlotMixin:SetFontOptions()
    PGVSlotMixinBase.SetFontOptions(self)
    if AddOn.db.profile.durability.show and not AddOn.db.profile.durability.showAsBar then
        local dFont, dSize = self.Durability:GetFont()
        ---@cast dFont string
        self.Durability:SetFont(dFont, dSize, "OUTLINE")
        self.Durability:SetTextScale(0.9 * AddOn.db.profile.durability.scale)
    end
end

---Hides all child frames including durability frames
function PGVCharSlotMixin:HideAllFrames()
    PGVSlotMixinBase.HideAllFrames(self)
    self.Durability:Hide()
    self.DurabilityBar:Hide()
end

---Defines a durability bar for an item slot in the Character Info window
---@param slot ItemSlot The gear slot to get a durability bar for
---@param isBgBar boolean `true` if the bar is a background bar, `false` otherwise
---@param durPercent? number The durability percentage for the item in the gear slot (only considered for non-background bars)
function PGVCharSlotMixin:DefineDurabilityBar(slot, isBgBar, durPercent)
    local bar = isBgBar and self.DurabilityBarBg or self.DurabilityBar
    if isBgBar then
        if bar.SetBackdrop then
            bar:SetBackdrop({
                bgFile = nil,
                edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                edgeSize = 8,
                insets = { left = 0, right = 0, top = 0, bottom = 0 },
            })
            bar:SetBackdropBorderColor(0, 0, 0, 1)
        end
        bar:SetFrameLevel(slot:GetFrameLevel() + 1)
    else
        if bar.SetBackdrop then bar:SetBackdrop(nil) end
        bar:SetFrameLevel(slot:GetFrameLevel() + 2)
        bar:SetValue(durPercent * 100)
        bar:SetScript("OnEnter", function(durBar)
            GameTooltip:SetOwner(durBar, "ANCHOR_TOP")
            GameTooltip:AddLine(L["Durability: "]..AddOn.RoundNumber(durBar:GetValue()).."%", 1, 1, 1)
            GameTooltip:Show()
        end)
        bar:SetScript("OnLeave", function() GameTooltip:Hide() end)
        -- Set default bar colors in DB if not present
        if not AddOn.db.profile.durability.colorHigh or not AddOn.db.profile.durability.colorMedium or not AddOn.db.profile.durability.colorLow then
            AddOn.db.profile.durability.colorHigh = AddOn.HexColorPresets.Uncommon
            AddOn.db.profile.durability.colorMedium = AddOn.HexColorPresets.Info
            AddOn.db.profile.durability.colorLow = AddOn.HexColorPresets.Error
        end
        local r, g, b
        if durPercent > 0.5 then
            r, g, b = AddOn.ConvertHexToRGB(AddOn.db.profile.durability.colorHigh)
        elseif durPercent > 0.25 then
            r, g, b = AddOn.ConvertHexToRGB(AddOn.db.profile.durability.colorMedium)
        else
            r, g, b = AddOn.ConvertHexToRGB(AddOn.db.profile.durability.colorLow)
        end
        if r ~= nil and g ~= nil and b ~= nil then
            bar:SetStatusBarColor(r, g, b, 1)
        else
            DebugPrint("DefineDurabilityBar: Unable to render durability bar due to invalid color value(s) -", r, g, b)
        end
    end
end

---Fetch and format durability display for a gear slot
---@param slot ItemSlot Gear slot frame
function PGVCharSlotMixin:GetAndPositionDurability(slot)
    -- Get current and max durability for the item
    local cDur, mDur = GetInventoryItemDurability(slot:GetID())
    if cDur and mDur then
        local percent = cDur / mDur
        if AddOn.db.profile.durability.show and AddOn.db.profile.durability.showAsBar then
            self:DefineDurabilityBar(slot, true)
            self:DefineDurabilityBar(slot, false, percent)
            self.DurabilityBar:Show()
        elseif AddOn.db.profile.durability.show then
            self.Durability:SetPoint("BOTTOM", self, "BOTTOM", 0, 2)
            -- Calculate durability percent and choose color
            local durText = ""
            local percentText = AddOn.RoundNumber(percent * 100)
            if percentText < 100 and percentText > 50 then
                durText = ColorText(percentText.."%", AddOn.db.profile.durability.colorHigh)
            elseif percentText < 100 and percentText > 25 then
                durText = ColorText(percentText.."%", AddOn.db.profile.durability.colorMedium)
            elseif percentText < 100 and percentText >= 0 then
                durText = ColorText(percentText.."%", AddOn.db.profile.durability.colorLow)
            end
            DebugPrint("GetAndPositionDurability: Durability for slot", ColorText(slot:GetName(), "Heirloom"), "is", durText)
            self.Durability:SetText(durText)
            if durText ~= "" then
                self.Durability:Show()
            else
                self.Durability:Hide()
            end
        end
    elseif AddOn.db.profile.durability.show and AddOn.db.profile.durability.showAsBar then
        self.DurabilityBar:Hide()
        self.DurabilityBarBg:Hide()
    elseif AddOn.db.profile.durability.show then
        self.Durability:Hide()
    end
end

---Shows durability bar background and hides durability text when durability bar is shown
function PGVCharSlotMixin:OnShowDurabilityBar()
    self.DurabilityBarBg:Show()
    self.Durability:Hide()
end

---Hides durability bar background when durability bar is hidden
function PGVCharSlotMixin:OnHideDurabilityBar()
    self.DurabilityBarBg:Hide()
end

---Hides durability bar when durability text is shown
function PGVCharSlotMixin:OnShowDurabilityText()
    self.DurabilityBar:Hide()
end
