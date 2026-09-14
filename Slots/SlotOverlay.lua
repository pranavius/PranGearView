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
    self.DurabilityBar:SetScript("OnEnter", function(bar)
        GameTooltip:SetOwner(bar, "ANCHOR_TOP")
        GameTooltip:AddLine(PGV.L["Durability: "]..Round(bar:GetValue() * 100).."%", 1, 1, 1)
        GameTooltip:Show()
    end)
    self.DurabilityBar:SetScript("OnLeave", GameTooltip_Hide)
end

function PGVSlotOverlayMixin:HideAllElements()
    self.ItemLevel:Hide()
    self.UpgradeTrack:Hide()
    self.Gems:Hide()
    self.Enchant:Hide()
    self.Durability:Hide()
    self.DurabilityBar:Hide()
    self:SetEmbellishmentVisible(false)
end

function PGVSlotOverlayMixin:SetEmbellishmentVisible(shown)
    self.Embellishment:SetShown(shown)
    -- Always toggle shadow along with embellishment texture (except one special case that's accounted for elsewhere)
    self.EmbellishmentShadow:SetShown(shown)
end

function PGVSlotOverlayMixin:PositionEmbellishment()
    self.Embellishment:ClearAllPoints()

    if self.context.IsShowingItemLevel() and PGV.db.itemLevel.onItem then
        if self.context.category == "bottom" then
            local isMainHand = self.context.isMainHand
            if self.Gems:IsShown() then
                self.Embellishment:SetPoint(isMainHand and "RIGHT" or "LEFT", self.Gems, isMainHand and "LEFT" or "RIGHT", isMainHand and -1 or 1, 0)
            elseif self.UpgradeTrack:IsShown() then
                self.Embellishment:SetPoint(isMainHand and "RIGHT" or "LEFT", self.UpgradeTrack, isMainHand and "LEFT" or "RIGHT", isMainHand and -1 or 1, 0)
            else
                self.Embellishment:SetPoint("CENTER", self, "BOTTOM", (isMainHand and -1 or 1) * 40, 5)
            end
        else
            local layout = LAYOUTS[self.context.category]
            if self.Gems:IsShown() then
                self.Embellishment:SetPoint(layout.side, self.Gems, layout.opposite, layout.inlineXOffset, 0)
            elseif self.UpgradeTrack:IsShown() then
                self.Embellishment:SetPoint(layout.side, self.UpgradeTrack, layout.opposite, layout.inlineXOffset, 0)
            else
                self.Embellishment:SetPoint(layout.side, self, layout.opposite, layout.xOffset, layout.yOffset)
            end
        end
        -- We're always hiding this since the Embellishment texture isnt even shown on the slot anymore (no shadow needed to make the texture more visible)
        self.EmbellishmentShadow:Hide()
    else
        self.Embellishment:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
    end
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
        self.Enchant:SetPoint(isMainHand and "RIGHT" or "LEFT", self, isMainHand and "TOPRIGHT" or "TOPLEFT", 0, 25)
        return
    end

    
    local layout = LAYOUTS[self.context.category]
    self.Enchant:SetPoint(layout.side, self, layout.opposite, layout.xOffset, -layout.yOffset)
end

function PGVSlotOverlayMixin:PositionGems()
    self.Gems:ClearAllPoints()

    if self.context.category == "bottom" then
        local isMainHand = self.context.isMainHand
        if self.UpgradeTrack:IsShown() then
            self.Gems:SetPoint(isMainHand and "RIGHT" or "LEFT", self.UpgradeTrack, isMainHand and "LEFT" or "RIGHT", isMainHand and -1 or 1, 0)
        else
            self.Gems:SetPoint("CENTER", self, "BOTTOM", (isMainHand and -1 or 1) * 40, 5)
        end
        return
    end

    local layout = LAYOUTS[self.context.category]
    if self.UpgradeTrack:IsShown() then
        self.Gems:SetPoint(layout.side, self.UpgradeTrack, layout.opposite, layout.inlineXOffset, 0)
    elseif self.ItemLevel:IsShown() and not PGV.db.itemLevel.onItem then
        self.Gems:SetPoint(layout.side, self.ItemLevel, layout.opposite, layout.inlineXOffset, 0)
    else
        self.Gems:SetPoint(layout.side, self, layout.opposite, layout.xOffset, layout.yOffset)
    end
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
    self:PositionEmbellishment()
end

local function ResolveItemLevelColor(context, data)
    local opts = PGV.db.itemLevel
    if opts.useCustomColor then
        return opts.customColor
    elseif opts.useClassColor then
        return GetClassColorObj(select(2, UnitClass(context.unit))):GenerateHexColorNoAlpha()
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
        text = text.." "..CreateSimpleTextureMarkup(DK_ENCH_ABBR_TEXTURES[text] or 628564, 15, 15)
    end
    return text
end

function PGVSlotOverlayMixin:UpdateSlotInfo()
    local context = self.context
    local slot = self:GetParent()
    local slotID = slot:GetID()
    local itemLink = GetInventoryItemLink(context.unit, slotID)

    self:HideAllElements()

    local shouldHideSlotDetails = PGV.db.general.hideShirtTabardInfo
        and (slot == CharacterShirtSlot or slot == CharacterTabardSlot or slot == InspectShirtSlot or slot == InspectTabardSlot)
    if not itemLink or shouldHideSlotDetails then
        return
    end

    PGV.GetItemDisplayData(itemLink, context.unit, slotID, function(data)
        if context.IsShowingItemLevel() then
            self.ItemLevel:SetText(PGV.ColorText(data.itemLevel, ResolveItemLevelColor(context, data)))
            self.ItemLevel:Show()
        end

        if context.IsShowingUpgradeTrack() and data.upgradeTrack then
            local upgradeText = PGV.AbbreviateText(data.upgradeTrack.text, PGV.UpgradeTextReplacements)
            self.UpgradeTrack:SetText(PGV.ColorText(upgradeText, ResolveUpgradeTrackColor(data, data.upgradeTrack.color)))
            self.UpgradeTrack:Show()
        end

        if context.IsShowingGems() then
            local isLeftSide = context.category == "left"
            local gemText = ""
            for _, gem in ipairs(data.gems or {}) do
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

            local existingSockets = data.gems and #data.gems or 0
            local isMaxLevel = UnitLevel(context.unit) == PGV.CurrentExpac.LevelCap
            if PGV.db.gems.showMissing and PGV.IsSocketableSlot(slot) and existingSockets < PGV.CurrentExpac.MaxSocketsPerItem
                and (isMaxLevel or not PGV.db.gems.missingMaxLevelOnly) then
                local icon = CreateAtlasMarkup("Socket-Prismatic-Closed", 15, 15)
                for _ = 1, PGV.CurrentExpac.MaxSocketsPerItem - existingSockets do
                    gemText = isLeftSide and (gemText..icon) or (icon..gemText)
                end
            end

            if gemText ~= "" then
                self.Gems:SetText(gemText)
                self.Gems:Show()
            end
        end

        if context.IsShowingEnchants() then
            if data.enchant then
                self.Enchant:SetText(PGV.ColorText(ResolveEnchantText(data.enchant.text), ResolveEnchantColor()))
                self.Enchant:Show()
            else
                local isMaxLevel = UnitLevel(context.unit) == PGV.CurrentExpac.LevelCap
                if PGV.db.enchants.showMissing and PGV.IsEnchantableSlot(slot) and (isMaxLevel or not PGV.db.enchants.missingMaxLevelOnly) then
                    local icon = CreateSimpleTextureMarkup(523826, 15, 15)
                    local label = PGV.ColorText(PGV.L["Enchant"], "Druid")
                    local isLabelFirst = context.category == "left" or (context.category == "bottom" and context.isMainHand)
                    self.Enchant:SetText(isLabelFirst and (label..icon) or (icon..label))
                    self.Enchant:Show()
                end
            end
        end

        if context.IsShowingEmbellishments() and data.isEmbellished then
            self:SetEmbellishmentVisible(true)
        end

        if context.showDurability and PGV.db.durability.show then
            local current, max = GetInventoryItemDurability(slotID)
            if current and max and max > 0 and current < max then
                local percent = current / max
                if PGV.db.durability.showAsBar then
                    self.DurabilityBar:SetMinMaxValues(0, 1)
                    self.DurabilityBar:SetValue(percent)
                    self.DurabilityBar:SetStatusBarColor(CreateColorFromHexString("FF"..ResolveDurabilityColor(percent)):GetRGB())
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
    IsShowingEmbellishments = function() return PGV.AreEmbellishmentsShownForCharacter() end,
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

PGV.UpdateAllSlots = UpdateAllSlots

PGV.RegisterEvent("PLAYER_EQUIPMENT_CHANGED", UpdateAllSlots)
PGV.RegisterEvent("UPDATE_INVENTORY_DURABILITY", UpdateAllSlots)
PGV.RegisterEvent("SOCKET_INFO_ACCEPT", UpdateAllSlots)

hooksecurefunc(CharacterFrame, "ShowSubFrame", function(_, subFrame)
    if subFrame == "PaperDollFrame" then
        UpdateAllSlots()
    end
end)
