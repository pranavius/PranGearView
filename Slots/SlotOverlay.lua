local _, PGV = ...

PGVSlotOverlayMixin = {}

local function PositionBottomUpgradeTrack(self, context)
    local corner = context.isMainHand and "BOTTOMLEFT" or "BOTTOMRIGHT"
    self.UpgradeTrack:ClearAllPoints()
    self.UpgradeTrack:SetPoint(corner, self, corner, 0, 0)
end

local LAYOUTS = {
    left = {
        side = "LEFT",
        myPoint = "TOPLEFT",
        iconAnchor = "TOPRIGHT", iconOffsetX = 10, iconOffsetY = 0,
        chainAnchor = "BOTTOMLEFT", chainOffsetX = 0, chainOffsetY = -1,
        inlineOffsetX = 2.5,
    },
    right = {
        side = "RIGHT",
        myPoint = "TOPRIGHT",
        iconAnchor = "TOPLEFT", iconOffsetX = -10, iconOffsetY = 0,
        chainAnchor = "BOTTOMRIGHT", chainOffsetX = 0, chainOffsetY = -1,
        inlineOffsetX = -2.5,
    },
    bottom = {
        elements = { "Enchant", "Gems" },
        myPoint = "BOTTOM",
        iconAnchor = "TOP", iconOffsetX = 0, iconOffsetY = 2,
        chainAnchor = "TOP", chainOffsetX = 0, chainOffsetY = 2,
        positionUpgradeTrack = PositionBottomUpgradeTrack,
    },
}

function PGVSlotOverlayMixin:OnLoad()
    self.DurabilityBar:SetBackdrop({ bgFile = "Interface/Buttons/WHITE8x8" })
    self.DurabilityBar:SetBackdropColor(0, 0, 0, 0.6)
end

function PGVSlotOverlayMixin:HideAllElements()
    self.ItemLevel:Hide()
    self.UpgradeTrack:Hide()
    self.Gems:Hide()
    self.Enchant:Hide()
    self.Durability:Hide()
    self.DurabilityBar:Hide()
end

local function GetIconSideAnchor(layout)
    local oppositePoint = layout.side == "LEFT" and "RIGHT" or "LEFT"
    return layout.side, oppositePoint, layout.iconOffsetX
end

function PGVSlotOverlayMixin:PositionItemLevel()
    self.ItemLevel:ClearAllPoints()

    local layout = LAYOUTS[self.context.category]

    if PGV.db.itemLevel.onItem then
        self.ItemLevel:SetPoint("CENTER", self, "TOP", 0, -10)
    elseif self.context.category == "bottom" then
        self.ItemLevel:SetPoint("CENTER", self, "TOP", 0, 10)
    else
        local myPoint, targetPoint, xOffset = GetIconSideAnchor(layout)
        self.ItemLevel:SetPoint(myPoint, self, targetPoint, xOffset, self.ItemLevel:GetHeight() / 1.5)
    end
end

function PGVSlotOverlayMixin:PositionUpgradeTrackSide()
    local layout = LAYOUTS[self.context.category]
    self.UpgradeTrack:ClearAllPoints()

    if self.ItemLevel:IsShown() and not PGV.db.itemLevel.onItem then
        local targetPoint = layout.side == "LEFT" and "RIGHT" or "LEFT"
        self.UpgradeTrack:SetPoint(layout.side, self.ItemLevel, targetPoint, layout.inlineOffsetX, 0)
    else
        local myPoint, targetPoint, xOffset = GetIconSideAnchor(layout)
        self.UpgradeTrack:SetPoint(myPoint, self, targetPoint, xOffset, self.UpgradeTrack:GetHeight() / 1.5)
    end
end

function PGVSlotOverlayMixin:PositionEnchant()
    local layout = LAYOUTS[self.context.category]
    if not layout.side then return end

    self.Enchant:ClearAllPoints()
    local myPoint, targetPoint, xOffset = GetIconSideAnchor(layout)
    self.Enchant:SetPoint(myPoint, self, targetPoint, xOffset, (self.ItemLevel:GetHeight() / 1.5) * -1)
end

function PGVSlotOverlayMixin:PositionGems()
    local layout = LAYOUTS[self.context.category]
    if not layout.side then return end

    self.Gems:ClearAllPoints()
    if self.Enchant:IsShown() then
        self.Gems:SetPoint(layout.myPoint, self.Enchant, layout.chainAnchor, layout.chainOffsetX, layout.chainOffsetY)
    else
        local myPoint, targetPoint, xOffset = GetIconSideAnchor(layout)
        self.Gems:SetPoint(myPoint, self, targetPoint, xOffset, (self.ItemLevel:GetHeight() / 1.5) * -1)
    end
end

function PGVSlotOverlayMixin:PositionElements()
    local layout = LAYOUTS[self.context.category]

    if self.ItemLevel:IsShown() then
        self:PositionItemLevel()
    end

    if self.Durability:IsShown() then
        self.Durability:ClearAllPoints()
        self.Durability:SetPoint("BOTTOM", self, "BOTTOM", 0, 2)
    end

    if self.UpgradeTrack:IsShown() then
        if layout.positionUpgradeTrack then
            layout.positionUpgradeTrack(self, self.context)
        else
            self:PositionUpgradeTrackSide()
        end
    end

    if self.Enchant:IsShown() then
        self:PositionEnchant()
    end

    if self.Gems:IsShown() then
        self:PositionGems()
    end

    if layout.elements then
        local previous, targetPoint, xOffset, yOffset = self, layout.iconAnchor, layout.iconOffsetX, layout.iconOffsetY
        for _, key in ipairs(layout.elements) do
            local element = self[key]
            if element:IsShown() then
                element:ClearAllPoints()
                element:SetPoint(layout.myPoint, previous, targetPoint, xOffset, yOffset)
                previous = element
                targetPoint, xOffset, yOffset = layout.chainAnchor, layout.chainOffsetX, layout.chainOffsetY
            end
        end
    end
end

local function ResolveItemLevelColor(context, data)
    local opts = PGV.db.itemLevel
    if opts.useCustomColor then
        return opts.customColor
    elseif opts.useClassColor then
        return GetClassColor(select(2, UnitClass(context.unit))):GenerateHexColorNoAlpha()
    elseif opts.useGradientColors then
        local equippedAverage = select(2, GetAverageItemLevel())
        if data.itemLevel < equippedAverage - 10 then
            return "Error"
        elseif data.itemLevel > equippedAverage + 10 then
            return "Uncommon"
        end
        return "Info"
    elseif opts.useQualityColor then
        local r, g, b = C_Item.GetItemQualityColor(data.quality)
        return CreateColor(r, g, b):GenerateHexColorNoAlpha()
    end
    return "FFFFFF"
end

function PGVSlotOverlayMixin:UpdateSlotInfo()
    local context = self.context
    local slotID = self:GetParent():GetID()
    local itemLink = GetInventoryItemLink(context.unit, slotID)

    self:HideAllElements()

    if not itemLink then
        return
    end

    PGV.GetItemDisplayData(itemLink, function(data)
        if context.IsShowingItemLevel() then
            self.ItemLevel:SetText(PGV.ColorText(data.itemLevel, ResolveItemLevelColor(context, data)))
            self.ItemLevel:Show()
        end

        if context.IsShowingUpgradeTrack() and data.upgradeTrack then
            self.UpgradeTrack:SetText(PGV.ColorText(data.upgradeTrack.text, data.upgradeTrack.color))
            self.UpgradeTrack:Show()
        end

        if context.IsShowingGems() and data.gems then
            local gemText = ""
            for _, gem in ipairs(data.gems) do
                if gem.icon then
                    gemText = gemText..CreateSimpleTextureMarkup(gem.icon, 15, 15)
                elseif gem.socketType then
                    gemText = gemText..CreateSimpleTextureMarkup("Interface/ItemSocketingFrame/UI-EmptySocket-"..gem.socketType, 15, 15)
                end
            end
            if gemText ~= "" then
                self.Gems:SetText(gemText)
                self.Gems:Show()
            end
        end

        if context.IsShowingEnchants() and data.enchant then
            self.Enchant:SetText(data.enchant.text)
            self.Enchant:Show()
        end

        if context.showDurability and PGV.db.durability.show then
            local current, max = GetInventoryItemDurability(slotID)
            if current and max and max > 0 and current < max then
                local percent = current / max
                if PGV.db.durability.showAsBar then
                    self.DurabilityBar:SetMinMaxValues(0, 1)
                    self.DurabilityBar:SetValue(percent)
                    self.DurabilityBar:Show()
                else
                    self.Durability:SetText(math.floor(percent * 100).."%")
                    self.Durability:Show()
                end
            end
        end

        self:PositionElements()
    end)
end

local characterContext = {
    unit = "player",
    showDurability = true,
    IsShowingItemLevel = function() return PGV.db.itemLevel.show end,
    IsShowingUpgradeTrack = function() return PGV.AreUpgradeTracksShownForCharacter() end,
    IsShowingGems = function() return PGV.AreGemsShownForCharacter() end,
    IsShowingEnchants = function() return PGV.AreEnchantsShownForCharacter() end,
}

local function GetSlotCategory(slot)
    if slot == CharacterMainHandSlot or slot == CharacterSecondaryHandSlot then
        return "bottom"
    elseif slot.IsLeftSide then
        return "left"
    end
    return "right"
end

local function UpdateSlotOverlay(slot)
    local overlay = slot.PGVSlotOverlay
    if not overlay then
        if InCombatLockdown() or PGV.IsAddOnCurrentlyRestricted() then
            return
        end
        overlay = CreateFrame("Frame", nil, slot, "PGVSlotOverlayTemplate")
        overlay.context = setmetatable({
            category = GetSlotCategory(slot),
            isMainHand = (slot == CharacterMainHandSlot),
        }, { __index = characterContext })
        slot.PGVSlotOverlay = overlay
    end

    overlay:UpdateSlotInfo()
end

local function UpdateAllSlots()
    for _, slot in ipairs(PGV.GearSlots) do
        UpdateSlotOverlay(slot)
    end
end

PGV.RegisterEvent("PLAYER_EQUIPMENT_CHANGED", UpdateAllSlots)
PGV.RegisterEvent("UPDATE_INVENTORY_DURABILITY", UpdateAllSlots)
PGV.RegisterEvent("SOCKET_INFO_ACCEPT", UpdateAllSlots)

hooksecurefunc(CharacterFrame, "ShowSubFrame", function(_, subFrame)
    if subFrame == "PaperDollFrame" then
        UpdateAllSlots()
    end
end)
