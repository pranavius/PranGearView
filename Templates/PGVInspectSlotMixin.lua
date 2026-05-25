local addonName, AddOn = ...
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)
---@cast AddOn PranGearView

---@class PGVInspectSlotMixin: PGVSlotMixinBase
PGVInspectSlotMixin = {}
Mixin(PGVInspectSlotMixin, PGVSlotMixinBase)

---Indicates whether a gear slot in the default Blizzard inspection window appears on the left side of the frame or not
---@param slot ItemSlot Gear slot frame
---@return boolean|nil `true` if the slot appears on the left side of the frame, `false` if it appears on the right side, or `nil` if it appears at the bottom
local function IsInspectSlotLeftSide(slot)
    for _, bottomSlotName in ipairs(AddOn.InspectInfo.bottomSlots) do
        if slot == _G[bottomSlotName] then return nil end
    end
    for _, leftSlotName in ipairs(AddOn.InspectInfo.leftSideSlots) do
        if slot == _G[leftSlotName] then return true end
    end
    return false
end

-- API overrides for the Inspect window
function PGVInspectSlotMixin:GetUnitToken() return UnitTokenFromGUID(AddOn.inspectedUnitGUID) end
function PGVInspectSlotMixin:IsShowingItemLevel() return AddOn.db.profile.inspect.showILvl end
function PGVInspectSlotMixin:IsShowingUpgradeTrack() return AddOn.db.profile.inspect.showUpgradeTrack end
function PGVInspectSlotMixin:IsShowingGems() return AddOn.db.profile.inspect.showGems end
function PGVInspectSlotMixin:IsShowingEnchants() return AddOn.db.profile.inspect.showEnchants end
function PGVInspectSlotMixin:IsShowingEmbellishments() return AddOn.db.profile.inspect.showEmbellishments end
function PGVInspectSlotMixin:GetMainHandSlot() return _G["InspectMainHandSlot"] end

function PGVInspectSlotMixin:OnLoad()
    self:UpdateSlotInfo()
end

---Executes logic to determine and position necessary information about the item equipped in the parent gear slot
function PGVInspectSlotMixin:UpdateSlotInfo()
    ---@type ItemSlot
    local slot = self:GetParent()
    self.IsLeftSideSlot = IsInspectSlotLeftSide(slot) == true
    self.IsBottomSlot = IsInspectSlotLeftSide(slot) == nil
    local hasItem, item = AddOn:IsItemEquippedInSlot(slot, true)
    local shouldHideSlotDetails = AddOn.db.profile.general.hideShirtTabardInfo and (slot == _G["InspectShirtSlot"] or slot == _G["InspectTabardSlot"])

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

        if self:IsShowingEmbellishments() then
            self:GetEmbellishment(slot, item)
        elseif self.Embellishment:IsShown() then
            self:SetEmbellishmentVisible(false)
        end
    elseif not hasItem then
        self:HideAllFrames()
    end
end
