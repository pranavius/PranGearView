local _, PGV = ...

PGVSlotOverlayMixin = {}

local LAYOUTS = {
    left = { side = "LEFT", opposite = "RIGHT", xOffset = 10, inlineXOffset = 2.5, yOffset = 7.5 },
    right = { side = "RIGHT", opposite = "LEFT", xOffset = -10, inlineXOffset = -2.5, yOffset = 7.5 },
}

local DK_ENCH_ABBR_TEXTURES = {
    [PGV.DKEnchantAbbr.Razorice] = 135842,
    [PGV.DKEnchantAbbr.Sanguination] = 1778226,
    [PGV.DKEnchantAbbr.Spellwarding] = 425952,
    [PGV.DKEnchantAbbr.Apocalypse] = 237535,
    [PGV.DKEnchantAbbr.FallenCrusader] = 135957,
    [PGV.DKEnchantAbbr.StoneskinGargoyle] = 237480,
    [PGV.DKEnchantAbbr.UnendingThirst] = 3163621,
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

function PGVSlotOverlayMixin:PositionItemLevel()
    self.ItemLevel:ClearAllPoints()

    if PGV.db.itemLevel.onItem then
        self.ItemLevel:SetPoint("CENTER", self, "TOP", 0, -10)
    elseif self.context.category == "bottom" then
        self.ItemLevel:SetPoint("CENTER", self, "TOP", 0, 10)
    else
        local layout = LAYOUTS[self.context.category]
        self.ItemLevel:SetPoint(layout.side, self, layout.opposite, layout.xOffset, layout.yOffset)
    end
end

function PGVSlotOverlayMixin:PositionUpgradeTrack()
    self.UpgradeTrack:ClearAllPoints()

    if self.context.category == "bottom" then
        local sign = self.context.isMainHand and -1 or 1
        self.UpgradeTrack:SetPoint("CENTER", self, "BOTTOM", sign * 40, 5)
        return
    end

    local layout = LAYOUTS[self.context.category]
    if self.ItemLevel:IsShown() and not PGV.db.itemLevel.onItem then
        self.UpgradeTrack:SetPoint(layout.side, self.ItemLevel, layout.opposite, layout.inlineXOffset, 0)
    else
        self.UpgradeTrack:SetPoint(layout.side, self, layout.opposite, layout.xOffset, layout.yOffset)
    end
end

function PGVSlotOverlayMixin:PositionEnchant()
    self.Enchant:ClearAllPoints()

    if self.context.category == "bottom" then
        local isMainHand = self.context.isMainHand
        self.Enchant:SetPoint(isMainHand and "RIGHT" or "LEFT", self, isMainHand and "TOPRIGHT" or "TOPLEFT", 0, 20)
        return
    end

    
    local layout = LAYOUTS[self.context.category]
    self.Enchant:SetPoint(layout.side, self, layout.opposite, layout.xOffset, -layout.yOffset)
end

function PGVSlotOverlayMixin:PositionGems()
    self.Gems:ClearAllPoints()

    if self.context.category == "bottom" then
        local isMainHand = self.context.isMainHand
        self.Gems:SetPoint(isMainHand and "RIGHT" or "LEFT", self.UpgradeTrack, isMainHand and "LEFT" or "RIGHT", isMainHand and -1 or 1, 0)
        return
    end
    
    local layout = LAYOUTS[self.context.category]
    self.Gems:SetPoint(layout.side, self.UpgradeTrack, layout.opposite, layout.inlineXOffset, 0)
end

function PGVSlotOverlayMixin:SetFontOptions()
    if self.ItemLevel:IsShown() then
        local font, size = self.ItemLevel:GetFont()
        self.ItemLevel:SetFont(font, size, PGV.db.itemLevel.outline)
        self.ItemLevel:SetTextScale(PGV.db.itemLevel.scale)
    end

    if self.UpgradeTrack:IsShown() then
        local font, size = self.UpgradeTrack:GetFont()
        self.UpgradeTrack:SetFont(font, size, PGV.db.upgradeTrack.outline)
        self.UpgradeTrack:SetTextScale(0.9 * PGV.db.upgradeTrack.scale)
    end

    if self.Gems:IsShown() then
        self.Gems:SetTextScale(PGV.db.gems.scale)
    end

    if self.Enchant:IsShown() then
        local font, size = self.Enchant:GetFont()
        self.Enchant:SetFont(font, size, PGV.db.enchants.outline)
        self.Enchant:SetTextScale(0.9 * PGV.db.enchants.scale)
    end

    if self.Durability:IsShown() then
        local font, size = self.Durability:GetFont()
        self.Durability:SetFont(font, size, "OUTLINE")
        self.Durability:SetTextScale(0.9 * PGV.db.durability.scale)
    end
end

function PGVSlotOverlayMixin:PositionElements()
    self:PositionItemLevel()
    self.Durability:ClearAllPoints()
    self.Durability:SetPoint("BOTTOM", self, "BOTTOM", 0, 2)
    self:PositionUpgradeTrack()
    self:PositionEnchant()
    self:PositionGems()
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

local function ResolveUpgradeTrackColor(data, rawColor)
    if rawColor and rawColor:lower() == PGV.HexColorPresets.PrevSeasonGear:lower() then
        return rawColor
    end

    local opts = PGV.db.upgradeTrack
    if opts.useQualityScaleColors then
        local text = data.upgradeTrack.text
        if text:match("E") or text:match("A") then
            return PGV.HexColorPresets.Priest
        elseif text:match("V") then
            return PGV.HexColorPresets.Uncommon
        elseif text:match("C") then
            return PGV.HexColorPresets.Rare
        elseif text:match("H") then
            return PGV.HexColorPresets.Epic
        elseif text:match("M") then
            return PGV.HexColorPresets.Legendary
        end
    elseif opts.useCustomColor then
        return opts.customColor
    end

    local r, g, b = C_Item.GetItemQualityColor(data.quality)
    return CreateColor(r, g, b):GenerateHexColorNoAlpha()
end

local function ResolveEnchantColor()
    local opts = PGV.db.enchants
    if opts.useCustomColor then
        return opts.customColor
    end
    return "Uncommon"
end

local function ResolveDurabilityColor(percent)
    local opts = PGV.db.durability
    if percent > 0.5 then
        return opts.colorHigh
    elseif percent > 0.25 then
        return opts.colorMedium
    end
    return opts.colorLow
end

local function ResolveEnchantText(rawText)
    local text = PGV.AbbreviateText(rawText, PGV.EnchantTextReplacements)
    if GetLocale() == "ptBR" then
        text = PGV.AbbreviateText(text, PGV.ptbrEnchantTextReplacements)
    elseif GetLocale() == "frFR" then
        text = PGV.AbbreviateText(text, PGV.frfrEnchantTextReplacements)
    end
    text = strtrim(text)

    local atlas = text:match("|A:(.-):")
    if atlas then
        text = text:gsub(" |A:.-|a", CreateAtlasMarkup(atlas, 15, 15))
    else
        text = text..CreateSimpleTextureMarkup(DK_ENCH_ABBR_TEXTURES[text] or 628564, 15, 15)
    end
    return text
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
            local upgradeText = PGV.AbbreviateText(data.upgradeTrack.text, PGV.UpgradeTextReplacements)
            self.UpgradeTrack:SetText(PGV.ColorText(upgradeText, ResolveUpgradeTrackColor(data, data.upgradeTrack.color)))
            self.UpgradeTrack:Show()
        end

        if context.IsShowingGems() and data.gems then
            local isLeftSide = context.category == "left"
            local gemText = ""
            for _, gem in ipairs(data.gems) do
                local icon
                if gem.icon then
                    icon = CreateSimpleTextureMarkup(gem.icon, 15, 15)
                elseif gem.socketType then
                    icon = CreateSimpleTextureMarkup("Interface/ItemSocketingFrame/UI-EmptySocket-"..gem.socketType, 15, 15)
                else
                    icon = CreateSimpleTextureMarkup(458977, 15, 15)
                end
                gemText = isLeftSide and (gemText..icon) or (icon..gemText)
            end
            self.Gems:SetText(gemText)
            self.Gems:Show()
        end

        if context.IsShowingEnchants() and data.enchant then
            self.Enchant:SetText(PGV.ColorText(ResolveEnchantText(data.enchant.text), ResolveEnchantColor()))
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
                    local percentText = math.floor(percent * 100).."%"
                    self.Durability:SetText(PGV.ColorText(percentText, ResolveDurabilityColor(percent)))
                    self.Durability:Show()
                end
            end
        end

        self:SetFontOptions()
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
