local addonName, AddOn = ...
---@class PranGearView
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

local DebugPrint = AddOn.DebugPrint
local ColorText = AddOn.ColorText

---@class PGVCharSlotMixin
PGVCharSlotMixin = {}

function PGVCharSlotMixin:OnLoad()
    self.Embellishment:SetScript("OnShow", function() self:OnShowEmbellishment() end)
    self.Embellishment:SetScript("OnHide", function() self:OnHideEmbellishment() end)
    self.DurabilityBar:SetScript("OnShow", function() self:OnShowDurabilityBar() end)
    self.DurabilityBar:SetScript("OnHide", function() self:OnHideDurabilityBar() end)
    self:UpdateSlotInfo()
end

function PGVCharSlotMixin:UpdateSlotInfo()
    ---@type ItemSlot
    local slot = self:GetParent()
    self.IsLeftSideSlot = slot.IsLeftSide == true
    self.IsBottomSlot = slot.IsLeftSide == nil
    local hasItem, item = AddOn:IsItemEquippedInSlot(slot)
    local shouldHideSlotDetails = AddOn.db.profile.general.hideShirtTabardInfo and (slot == CharacterShirtSlot or slot == CharacterTabardSlot)

    if hasItem and not shouldHideSlotDetails then
        if AddOn.db.profile.itemLevel.show then
            self:GetItemLevel(slot, item)
            self:PositionItemLevel()
        elseif self.ItemLevel:IsShown() then
            self.ItemLevel:Hide()
        end
        
        if AddOn:AreUpgradeTracksShownForCharacter() then
            self:GetUpgradeTrack(slot, item)
            self:PositionUpgradeTrack(slot == CharacterMainHandSlot)
        elseif self.UpgradeTrack:IsShown() then
            self.UpgradeTrack:Hide()
        end
        
        if AddOn:AreGemsShownForCharacter() then
            self:GetGems(slot, item)
            self:PositionGems(slot == CharacterMainHandSlot)
        elseif self.Gems:IsShown() then
            self.Gems:Hide()
        end

        if AddOn:AreEnchantsShownForCharacter() then
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
        
        if AddOn:AreEmbellishmentsShownForCharacter() then
            self:GetEmbellishment(slot, item)
        elseif self.Embellishment:IsShown() then
            self.Embellishment:Hide()
        end
    elseif not hasItem then
        self:HideAllFrames()
    end
end

---Fetch and format item level text for a gear slot
---@param slot ItemSlot Gear slot frame
---@param item ItemMixin Equipped item
function PGVCharSlotMixin:GetItemLevel(slot, item)
    local itemLevel = item:GetCurrentItemLevel()
    if itemLevel > 0 then -- positive value indicates item info has loaded
        local iLvlText = tostring(itemLevel)
        if AddOn.db.profile.itemLevel.useGradientColors then
            local equippedItemLevel = select(2, GetAverageItemLevel())
            local color = (itemLevel < equippedItemLevel - 10 and "Error"
                or itemLevel > equippedItemLevel + 10 and "Uncommon"
                or "Info")
            iLvlText = ColorText(iLvlText, color)
        elseif AddOn.db.profile.itemLevel.useQualityColor then
            local qualityHex = select(4, C_Item.GetItemQualityColor(item:GetItemQuality()))
            iLvlText = "|c"..qualityHex..iLvlText.."|r"
        elseif AddOn.db.profile.itemLevel.useClassColor then
            local classFile = select(2, UnitClass("player"))
            local classHexWithAlpha = select(4, GetClassColor(classFile))
            iLvlText = "|c"..classHexWithAlpha..iLvlText.."|r"
        elseif AddOn.db.profile.itemLevel.useCustomColor then
            iLvlText = ColorText(iLvlText, AddOn.db.profile.itemLevel.customColor)
        end

        DebugPrint("GetItemLevel: Slot", ColorText(slot:GetName(), "Heirloom"), "item level is", iLvlText)
        self.ItemLevel:SetFormattedText(iLvlText)
        self.ItemLevel:ClearAllPoints()

        if AddOn.db.profile.itemLevel.onItem then
            self.ItemLevel:SetPoint("CENTER", slot, "TOP", 0, -10)
        elseif slot.IsLeftSide == nil then
            self.ItemLevel:SetPoint("CENTER", slot, "TOP", 0, 10)
        else
            self.ItemLevel:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, 0)
        end
        self.ItemLevel:Show()
    else
        DebugPrint("GetItemLevel: Negative item level returned, retry GetItemLevel for slot", ColorText(slot:GetName(), "Heirloom"))
        C_Timer.After(0.5, function() self:GetItemLevel(slot, item) end)
    end
end

---Set item level text position in the Character Info window
function PGVCharSlotMixin:PositionItemLevel()
    self.ItemLevel:ClearAllPoints()

    if AddOn.db.profile.itemLevel.onItem then
        self.ItemLevel:SetPoint("CENTER", self, "TOP", 0, -10)
    elseif self.IsBottomSlot then
        self.ItemLevel:SetPoint("CENTER", self, "TOP", 0, 10)
    else
        self.ItemLevel:SetPoint(self.IsLeftSideSlot and "LEFT" or "RIGHT", self, self.IsLeftSideSlot and "RIGHT" or "LEFT", (self.IsLeftSideSlot and 1 or -1) * 10, self.ItemLevel:GetHeight() / 1.5)
    end
end

---Fetch and format upgrade track text for a gear slot
---@param slot ItemSlot Gear slot frame
---@param item ItemMixin Equipped item
function PGVCharSlotMixin:GetUpgradeTrack(slot, item)
    local upgradeTrackText = ""
    local upgradeColor = ""
    local tooltip = C_TooltipInfo.GetHyperlink(item:GetItemLink())
    if tooltip and tooltip.lines then
        for _, ttdata in pairs(tooltip.lines) do
            if ttdata and ttdata.type and ttdata.type == AddOn.TooltipDataType.UpgradeTrack then
                -- Displays past-season upgrade tracks in gray
                upgradeColor = ttdata.leftColor:GenerateHexColorNoAlpha()
                local upgradeText = ttdata.leftText
                upgradeText = AddOn:AbbreviateText(upgradeText, AddOn.UpgradeTextReplacements)
                upgradeTrackText = upgradeText
                DebugPrint("GetUpgradeTrack: Slot", ColorText(slot:GetName(), "Heirloom"), "upgrade track is", upgradeText)
            end
        end
    end

    if upgradeTrackText ~= "" then
        if upgradeColor:lower() ~= AddOn.HexColorPresets.PrevSeasonGear:lower() then
            if AddOn.db.profile.upgradeTrack.useQualityScaleColors then
                if upgradeTrackText:match("E") or upgradeTrackText:match("A") then
                    upgradeColor = AddOn.HexColorPresets.Priest
                elseif upgradeTrackText:match("V") then
                    upgradeColor = AddOn.HexColorPresets.Uncommon
                elseif upgradeTrackText:match("C") then
                    upgradeColor = AddOn.HexColorPresets.Rare
                elseif upgradeTrackText:match("H") then
                    upgradeColor = AddOn.HexColorPresets.Epic
                elseif upgradeTrackText:match("M") then
                    upgradeColor = AddOn.HexColorPresets.Legendary
                else
                    -- If a match isn't found, fallback to the item quality color
                    upgradeColor = select(4, C_Item.GetItemQualityColor(item:GetItemQuality())):sub(3)
                end
            elseif AddOn.db.profile.upgradeTrack.useCustomColor then
                upgradeColor = AddOn.db.profile.upgradeTrack.customColor
            else
                upgradeColor = select(4, C_Item.GetItemQualityColor(item:GetItemQuality())):sub(3)
            end
        end
        self.UpgradeTrack:SetFormattedText(ColorText(upgradeTrackText, upgradeColor))
        self.UpgradeTrack:Show()
    else
        self.UpgradeTrack:ClearText()
        self.UpgradeTrack:Hide()
    end
end

---Set upgrade track text position in the Character Info window
---@param isMainHand boolean `true` if the slot represents the main-hand gear slot, `false` otherwise
function PGVCharSlotMixin:PositionUpgradeTrack(isMainHand)
    self.UpgradeTrack:ClearAllPoints()

    local itemLevelShown = AddOn.db.profile.itemLevel.show and not AddOn.db.profile.itemLevel.onItem and self.ItemLevel:IsShown()
    local itemLevelShownOnItem = AddOn.db.profile.itemLevel.show and AddOn.db.profile.itemLevel.onItem and self.ItemLevel:IsShown()

    if self.IsBottomSlot then
        self.UpgradeTrack:SetPoint("CENTER", self, "BOTTOM", (isMainHand and -1 or 1) * 40, 5)
    elseif itemLevelShown and not itemLevelShownOnItem then
        self.UpgradeTrack:SetPoint(self.IsLeftSideSlot and "LEFT" or "RIGHT", self.ItemLevel, self.IsLeftSideSlot and "RIGHT" or "LEFT", self.IsLeftSideSlot and 2.5 or -2.5, 0)
    else
        self.UpgradeTrack:SetPoint(self.IsLeftSideSlot and "LEFT" or "RIGHT", self, self.IsLeftSideSlot and "RIGHT" or "LEFT", (self.IsLeftSideSlot and 1 or -1) * 10, self.UpgradeTrack:GetHeight() / 1.5)
    end
end

---Fetch and format gem text for a gear slot
---If sockets are empty/can be addded to the item and the option to show missing sockets is enabled, this will also be indicated.
---@param slot ItemSlot Gear slot frame
---@param item ItemMixin Equipped item
function PGVCharSlotMixin:GetGems(slot, item)
    local existingSocketCount = 0
    local gemText = ""
    local tooltip = C_TooltipInfo.GetHyperlink(item:GetItemLink())
    if tooltip and tooltip.lines then
        for _, ttdata in pairs(tooltip.lines) do
            if ttdata and ttdata.type and ttdata.type == AddOn.TooltipDataType.Gem then
                if ttdata.gemIcon and self.IsLeftSideSlot then
                    DebugPrint("GetGems: Gem", ttdata.gemIcon, "found on left side slot:", ColorText(slot:GetName(), "Heirloom"), AddOn.GetTextureString(ttdata.gemIcon))
                    gemText = gemText..AddOn.GetTextureString(ttdata.gemIcon)
                elseif ttdata.gemIcon then
                    DebugPrint("GetGems: Gem", ttdata.gemIcon, "found on slot:", ColorText(slot:GetName(), "Heirloom"), AddOn.GetTextureString(ttdata.gemIcon))
                    gemText = AddOn.GetTextureString(ttdata.gemIcon)..gemText
                -- Two conditions below check for tinker sockets
                elseif ttdata.socketType and self.IsLeftSideSlot then
                    DebugPrint("GetGems: Empty tinker socket", ttdata.socketType, "found on left side slot:", ColorText(slot:GetName(), "Heirloom"), AddOn.GetTextureString("Interface/ItemSocketingFrame/UI-EmptySocket-"..ttdata.socketType))
                    gemText = gemText..AddOn.GetTextureString("Interface/ItemSocketingFrame/UI-EmptySocket-"..ttdata.socketType)
                elseif ttdata.socketType then
                    DebugPrint("GetGems: Empty tinker socket", ttdata.socketType, "found on slot:", ColorText(slot:GetName(), "Heirloom"), AddOn.GetTextureString("Interface/ItemSocketingFrame/UI-EmptySocket-"..ttdata.socketType))
                    gemText = AddOn.GetTextureString("Interface/ItemSocketingFrame/UI-EmptySocket-"..ttdata.socketType)..gemText
                -- The two conditions below indicate that there is an empty socket on the item
                elseif self.IsLeftSideSlot then
                    DebugPrint("GetGems: Empty socket found on left side slot:", ColorText(slot:GetName(), "Heirloom"))
                    -- Texture: Interface/ItemSocketingFrame/UI-EmptySocket-Prismatic
                    gemText = gemText..AddOn.GetTextureString(458977)
                else
                    DebugPrint("GetGems: Empty socket found on slot:", ColorText(slot:GetName(), "Heirloom"))
                    gemText = AddOn.GetTextureString(458977)..gemText
                end
                existingSocketCount = existingSocketCount + 1
            end
        end
    end

    -- Indicate slots that can have sockets added to them
    if AddOn:AreGemsShownForCharacter() and AddOn.db.profile.gems.showMissing and AddOn:IsSocketableSlot(slot) and existingSocketCount < AddOn.CurrentExpac.MaxSocketsPerItem then
        local isCharacterMaxLevel = UnitLevel("player") == AddOn.CurrentExpac.LevelCap
        if (AddOn.db.profile.gems.missingMaxLevelOnly and isCharacterMaxLevel) or not AddOn.db.profile.gems.missingMaxLevelOnly then
            for i = 1, AddOn.CurrentExpac.MaxSocketsPerItem - existingSocketCount, 1 do
                DebugPrint("GetGems: Slot", ColorText(slot:GetName(), "Heirloom"), "can have", i, i == 1 and "socket" or "sockets")
                gemText = self.IsLeftSideSlot and gemText..AddOn.GetTextureAtlasString("Socket-Prismatic-Closed") or AddOn.GetTextureAtlasString("Socket-Prismatic-Closed")..gemText
            end
        end
    end
    if gemText == "" then
        self.Gems:ClearText()
        self.Gems:Hide()
    else
        self.Gems:SetFormattedText(gemText)
        self.Gems:Show()
    end
end

---Set gems text position in the Character Info window
---@param isMainHand boolean `true` if the slot represents the main-hand gear slot, `false` otherwise
function PGVCharSlotMixin:PositionGems(isMainHand)
    self.Gems:ClearAllPoints()
    local itemLevelShown = AddOn.db.profile.itemLevel.show and not AddOn.db.profile.itemLevel.onItem and self.ItemLevel:IsShown()
    local itemLevelShownOnItem = AddOn.db.profile.itemLevel.show and AddOn.db.profile.itemLevel.onItem and self.ItemLevel:IsShown()
    local upgradeTrackShown = AddOn:AreUpgradeTracksShownForCharacter() and self.UpgradeTrack:IsShown()

    -- Gems on weapon/shield/off-hand slots (not possible as far as I am aware, but you never know)
    if upgradeTrackShown and self.IsBottomSlot then
        self.Gems:SetPoint(isMainHand and "RIGHT" or "LEFT", self.UpgradeTrack, isMainHand and "LEFT" or "RIGHT", isMainHand and -1 or 1, 0)
    elseif upgradeTrackShown then
        self.Gems:SetPoint(self.IsLeftSideSlot and "LEFT" or "RIGHT", self.UpgradeTrack, self.IsLeftSideSlot and "RIGHT" or "LEFT", (self.IsLeftSideSlot and 1 or -1) * 2, 0)
    elseif itemLevelShownOnItem and self.IsBottomSlot then
        self.Gems:SetPoint("CENTER", self, "BOTTOM", (isMainHand and -1 or 1) * 40, 5)
    elseif itemLevelShownOnItem then
        self.Gems:SetPoint(self.IsLeftSideSlot and "LEFT" or "RIGHT", self, self.IsLeftSideSlot and "RIGHT" or "LEFT", (self.IsLeftSideSlot and 1 or -1) * 10, 0)
    elseif itemLevelShown and self.IsBottomSlot then
        self.Gems:SetPoint("LEFT", self.ItemLevel, "RIGHT", 1, 0)
    elseif itemLevelShown then
        self.Gems:SetPoint(self.IsLeftSideSlot and "LEFT" or "RIGHT", self.ItemLevel, self.IsLeftSideSlot and "RIGHT" or "LEFT", (self.IsLeftSideSlot and 1 or -1) * 2, 0)
    elseif self.IsBottomSlot then
        self.Gems:SetPoint("CENTER", self, "TOP", 0, 10)
    else
        self.Gems:SetPoint(self.IsLeftSideSlot and "LEFT" or "RIGHT", self, self.IsLeftSideSlot and "RIGHT" or "LEFT", (self.IsLeftSideSlot and 1 or -1) * 10, self.Gems:GetHeight() / 1.5)
    end
end

---Fetch and format enchant text for a gear slot
---If an item that can be enchanted isn't and the option to show missing enchants is enabled, this will also be indicated.
---@param slot ItemSlot Gear slot frame
---@param item ItemMixin Equipped item
function PGVCharSlotMixin:GetEnchant(slot, item)
    local isEnchanted = false
    local tooltip = C_TooltipInfo.GetHyperlink(item:GetItemLink())
    if tooltip and tooltip.lines then
        for _, ttdata in pairs(tooltip.lines) do
            if ttdata and ttdata.type and ttdata.type == AddOn.TooltipDataType.Enchant then
                DebugPrint("GetEnchant: Item in slot", ColorText(slot:GetName(), "Heirloom"), "is enchanted")
                local enchText = ttdata.leftText
                DebugPrint("GetEnchant: Original enchantment text:", ColorText(enchText, "Info"))
                enchText = AddOn:AbbreviateText(enchText, AddOn.EnchantTextReplacements)
                -- Perform locale replacements specific to ptBR to further shorten and fix some abbreviations
                if GetLocale() == "ptBR" then enchText = AddOn:AbbreviateText(enchText, AddOn.ptbrEnchantTextReplacements)
                elseif GetLocale() == "frFR" then enchText = AddOn:AbbreviateText(enchText, AddOn.frfrEnchantTextReplacements) end
                -- Trim enchant text to remove leading and trailing whitespace
                -- strtrim is a Blizzard-provided global utility function
                enchText = strtrim(enchText)
                -- Resize any textures in the enchantment text
                local texture = enchText:match("|A:(.-):")
                -- If no texture is found, the enchant could be an older/DK one.
                -- If DK enchant, set texture based on the icon shown for each enchant in Runeforging
                if not texture then
                    texture = AddOn.GetTextureString(AddOn:GetLegacyEnchantTextureID(enchText))
                    enchText = AddOn.db.profile.enchants.collapse and texture or (enchText..texture)
                else
                    -- If the preference is to hide enchant text, only show the enchant quality
                    enchText = AddOn.db.profile.enchants.collapse and AddOn.GetTextureAtlasString(texture) or enchText:gsub(" |A:.-|a", AddOn.GetTextureAtlasString(texture))
                end
                DebugPrint("GetEnchant: Abbreviated enchantment text:", ColorText(enchText, "Uncommon"))

                if AddOn.db.profile.enchants.useCustomColor then
                    self.Enchant:SetFormattedText(ColorText(enchText, AddOn.db.profile.enchants.customColor))
                else
                    self.Enchant:SetFormattedText(ColorText(enchText, "Uncommon"))
                end
                self.Enchant:Show()
                isEnchanted = true
            end
        end
    end

    if not isEnchanted and AddOn:IsEnchantableSlot(slot) and AddOn.db.profile.enchants.showMissing then
        local isCharacterMaxLevel = UnitLevel("player") == AddOn.CurrentExpac.LevelCap
        if (AddOn.db.profile.enchants.missingMaxLevelOnly and isCharacterMaxLevel) or not AddOn.db.profile.enchants.missingMaxLevelOnly then
            if AddOn.db.profile.enchants.collapse then
                -- Texture: Interface/EncounterJournal/UI-EJ-WarningTextIcon
                self.Enchant:SetFormattedText(AddOn.GetTextureString(523826))
            -- For left side and main hand slots, show the icon to the right of the text. For all other slots, show the icon to the left (better mirroring look and feel)
            elseif self.IsLeftSideSlot or (self.IsBottomSlot and slot:GetID() == 16) then self.Enchant:SetFormattedText(ColorText(L["Enchant"], "Druid")..AddOn.GetTextureString(523826))
            else self.Enchant:SetFormattedText(AddOn.GetTextureString(523826)..ColorText(L["Enchant"], "Druid"))
            end
            self.Enchant:Show()
        end
    elseif not isEnchanted then
        self.Enchant:ClearText()
        self.Enchant:Hide()
    end
end

---Set enchant text position in the Character Info window
---@param slot ItemSlot The gear slot to position enchant for
function PGVCharSlotMixin:PositionEnchant(slot)
    self.Enchant:ClearAllPoints()

    local itemLevelShown = AddOn.db.profile.itemLevel.show and not AddOn.db.profile.itemLevel.onItem and self.ItemLevel:IsShown()
    local itemLevelShownOnItem = AddOn.db.profile.itemLevel.show and AddOn.db.profile.itemLevel.onItem and self.ItemLevel:IsShown()
    local upgradeTrackShown = AddOn:AreUpgradeTracksShownForCharacter() and self.UpgradeTrack:IsShown()
    local defaultYOffset = (itemLevelShownOnItem or (not itemLevelShown and AddOn:AreGemsShownForCharacter())) and 10 or 25
    local isMainHand = slot == CharacterMainHandSlot

    if AddOn.db.profile.enchants.collapse and self.IsBottomSlot and upgradeTrackShown then
        self.Enchant:SetPoint("CENTER", self, "TOP", 0, 25)
    elseif AddOn.db.profile.enchants.collapse and self.IsBottomSlot then
        self.Enchant:SetPoint("CENTER", self, "TOP", 0, defaultYOffset)
    elseif not self.IsBottomSlot then
        self.Enchant:SetPoint(self.IsLeftSideSlot and "LEFT" or "RIGHT", self, self.IsLeftSideSlot and "RIGHT" or "LEFT", (self.IsLeftSideSlot and 1 or -1) * 10, (self.ItemLevel:GetHeight() / 1.5) * -1)
    else
        self.Enchant:SetPoint(isMainHand and "RIGHT" or "LEFT", self, isMainHand and "TOPRIGHT" or "TOPLEFT", 0, 25)
    end
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
                durText = ColorText(percentText.."%%", AddOn.db.profile.durability.colorHigh)
            elseif percentText < 100 and percentText > 25 then
                durText = ColorText(percentText.."%%", AddOn.db.profile.durability.colorMedium)
            elseif percentText < 100 and percentText >= 0 then
                durText = ColorText(percentText.."%%", AddOn.db.profile.durability.colorLow)
            end
            DebugPrint("GetAndPositionDurability: Durability for slot", ColorText(slot:GetName(), "Heirloom"), "is", durText)
            if durText ~= "" then
                self.Durability:SetFormattedText(durText)
                self.Durability:Show()
            end
        end
    elseif AddOn.db.profile.durability.show and AddOn.db.profile.durability.showAsBar then
        self.DurabilityBar:Hide()
        self.DurabilityBarBg:Hide()
    elseif AddOn.db.profile.durability.show then
        self.Durability:Hide()
    end
end

---Show an icon/indicator for a gear slot containing an embellished item
---@param slot ItemSlot Gear slot frame
---@param item ItemMixin Equipped item
function PGVCharSlotMixin:GetEmbellishment(slot, item)
    local tooltip = C_TooltipInfo.GetHyperlink(item:GetItemLink())
    local isEmbellished = false
    if tooltip and tooltip.lines then
        for _, ttdata in pairs(tooltip.lines) do
            if ttdata and ttdata.leftText:find("Embellished") then
                self.Embellishment:ClearAllPoints()
                if AddOn.db.profile.itemLevel.show and AddOn.db.profile.itemLevel.onItem then
                    if AddOn.db.profile.durability.showAsBar then
                        self.Embellishment:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 2, 2) -- Move up
                    else
                        self.Embellishment:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 2, -7)
                    end
                else
                    self.Embellishment:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
                end
                DebugPrint("GetEmbellishment: Embellishment found on slot", ColorText(slot:GetName(), "Heirloom"))
                isEmbellished = true
            end
        end
    else
        DebugPrint("GetEmbellishment: Tooltip information not obtained for slot", ColorText(slot:GetName(), "Heirloom"))
    end

    if isEmbellished then self.Embellishment:Show() else self.Embellishment:Hide() end
end

function PGVCharSlotMixin:OnShowDurabilityBar()
    self.DurabilityBarBg:Show()
    self.Durability:Hide()
end

function PGVCharSlotMixin:OnHideDurabilityBar()
    self.DurabilityBarBg:Hide()
end

function PGVCharSlotMixin:OnShowDurabilityText()
    self.DurabilityBar:Hide()
end

function PGVCharSlotMixin:OnShowEmbellishment()
    self.EmbellishmentShadow:Show()
end

function PGVCharSlotMixin:OnHideEmbellishment()
    self.EmbellishmentShadow:Hide()
end

function PGVCharSlotMixin:SetFontOptions()
    if AddOn.db.profile.itemLevel.show then
        local iFont, iSize = self.ItemLevel:GetFont()
        ---@cast iFont string
        self.ItemLevel:SetFont(iFont, iSize, AddOn.db.profile.itemLevel.outline)
        self.ItemLevel:SetTextScale(AddOn.db.profile.itemLevel.scale)
    end

    if AddOn:AreUpgradeTracksShownForCharacter() then
        local uFont, uSize = self.UpgradeTrack:GetFont()
        ---@cast uFont string
        self.UpgradeTrack:SetFont(uFont, uSize, AddOn.db.profile.upgradeTrack.outline)
        self.UpgradeTrack:SetTextScale(0.9 * AddOn.db.profile.upgradeTrack.scale)
    end
    
    if AddOn:AreGemsShownForCharacter() then
        self.Gems:SetTextScale(AddOn.db.profile.gems.scale)
    end
    
    if AddOn:AreEnchantsShownForCharacter() then
        local eFont, eSize = self.Enchant:GetFont()
        ---@cast eFont string
        self.Enchant:SetFont(eFont, eSize, AddOn.db.profile.enchants.outline)
        self.Enchant:SetTextScale(0.9 * AddOn.db.profile.enchants.scale)
    end
    
    if AddOn.db.profile.durability.show and not AddOn.db.profile.durability.showAsBar then
        local dFont, dSize = self.Durability:GetFont()
        ---@cast dFont string
        self.Durability:SetFont(dFont, dSize, "OUTLINE")
        self.Durability:SetTextScale(0.9 * AddOn.db.profile.durability.scale)
    end
end

function PGVCharSlotMixin:HideAllFrames()
    self.ItemLevel:Hide()
    self.UpgradeTrack:Hide()
    self.Gems:Hide()
    self.Enchant:Hide()
    self.Durability:Hide()
    self.DurabilityBar:Hide()
    self.Embellishment:Hide()
end
