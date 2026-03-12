local addonName, AddOn = ...
---@class PranGearView
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

local DebugPrint = AddOn.DebugPrint
local ColorText = AddOn.ColorText

---@class PGVInspectSlotMixin
PGVInspectSlotMixin = {}

-- A large chunk of this mixin's logic is lifted from PGVCharSlotMixin
-- TODO: Determine if/how a single mixin could be used for both Character Info and Inspect to avoid excessive code duplication

function PGVInspectSlotMixin:OnLoad()
    self:UpdateSlotInfo()
end

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

---Executes logic to determine and position necessary information about the item equipped in the parent gear slot
function PGVInspectSlotMixin:UpdateSlotInfo()
    ---@type ItemSlot
    local slot = self:GetParent()
    self.IsLeftSideSlot = IsInspectSlotLeftSide(slot) == true
    self.IsBottomSlot = IsInspectSlotLeftSide(slot) == nil
    local hasItem, item = AddOn:IsItemEquippedInSlot(slot, true)
    local shouldHideSlotDetails = AddOn.db.profile.general.hideShirtTabardInfo and (slot == _G["InspectShirtSlot"] or slot == _G["InspectTabardSlot"])
    
    if hasItem and not shouldHideSlotDetails then
        if AddOn.db.profile.inspect.showILvl then
            self:GetItemLevel(slot, item)
            self:PositionItemLevel()
        elseif self.ItemLevel:IsShown() then
            self.ItemLevel:Hide()
        end
        
        if AddOn.db.profile.inspect.showUpgradeTrack then
            self:GetUpgradeTrack(slot, item)
            self:PositionUpgradeTrack(slot == _G["InspectMainHandSlot"])
        elseif self.UpgradeTrack:IsShown() then
            self.UpgradeTrack:Hide()
        end
        
        if AddOn.db.profile.inspect.showGems then
            self:GetGems(slot, item)
            self:PositionGems(slot == _G["InspectMainHandSlot"])
        elseif self.Gems:IsShown() then
            self.Gems:Hide()
        end
    
        if AddOn.db.profile.inspect.showEnchants then
            self:GetEnchant(slot, item)
            self:PositionEnchant(slot)
        elseif self.Enchant:IsShown() then
            self.Enchant:Hide()
        end
        
        if AddOn.db.profile.inspect.showEmbellishments then
            self:GetEmbellishments(slot, item)
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
function PGVInspectSlotMixin:GetItemLevel(slot, item)
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
            local classFile = select(2, UnitClass(UnitTokenFromGUID(AddOn.inspectedUnitGUID)))
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

---Set item level text position in the Inspect window
function PGVInspectSlotMixin:PositionItemLevel()
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
function PGVInspectSlotMixin:GetUpgradeTrack(slot, item)
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

---Set upgrade track text position in the Inspect window
---@param isMainHand boolean `true` if the slot represents the main-hand gear slot, `false` otherwise
function PGVInspectSlotMixin:PositionUpgradeTrack(isMainHand)
    self.UpgradeTrack:ClearAllPoints()

    local itemLevelShown = AddOn.db.profile.inspect.showILvl and not AddOn.db.profile.itemLevel.onItem and self.ItemLevel:IsShown()
    local itemLevelShownOnItem = AddOn.db.profile.inspect.showILvl and AddOn.db.profile.itemLevel.onItem and self.ItemLevel:IsShown()

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
function PGVInspectSlotMixin:GetGems(slot, item)
    local existingSocketCount = 0
    local gemText = ""
    local tooltip = C_TooltipInfo.GetHyperlink(item:GetItemLink())
    if tooltip and tooltip.lines then
        for _, ttdata in pairs(tooltip.lines) do
            if ttdata and ttdata.type and ttdata.type == AddOn.TooltipDataType.Gem then
                -- Socketed item's TooltipData will have gemIcon variable
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
    if AddOn.db.profile.inspect.showGems and AddOn.db.profile.gems.showMissing and AddOn:IsSocketableSlot(slot) and existingSocketCount < AddOn.CurrentExpac.MaxSocketsPerItem then
        local isCharacterMaxLevel = UnitLevel(UnitTokenFromGUID(AddOn.inspectedUnitGUID)) == AddOn.CurrentExpac.LevelCap
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

---Set gems text position in the Inspect window
---@param isMainHand boolean `true` if the slot represents the main-hand gear slot, `false` otherwise
function PGVInspectSlotMixin:PositionGems(isMainHand)
    self.Gems:ClearAllPoints()
    local itemLevelShown = AddOn.db.profile.inspect.showILvl and not AddOn.db.profile.itemLevel.onItem and self.ItemLevel:IsShown()
    local itemLevelShownOnItem = AddOn.db.profile.inspect.showILvl and AddOn.db.profile.itemLevel.onItem and self.ItemLevel:IsShown()
    local upgradeTrackShown = AddOn:AreUpgradeTracksShownForCharacter() and self.UpgradeTrack:IsShown()

    -- Gems on weapon/shield/off-hand slots (not possible as far as I am aware, but you never know)
    if upgradeTrackShown and self.IsBottomSlot then
        self.Gems:SetPoint(isMainHand and "RIGHT" or "LEFT", self.UpgradeTrack, isMainHand and "LEFT" or "RIGHT", isMainHand and -1 or 1, 0)
    elseif upgradeTrackShown then
        self.Gems:SetPoint(self.IsLeftSideSlot and "LEFT" or "RIGHT", self.UpgradeTrack, self.IsLeftSideSlot and "RIGHT" or "LEFT", self.IsLeftSideSlot and 1 or -1, -1)
    elseif itemLevelShownOnItem and self.IsBottomSlot then
        self.Gems:SetPoint("CENTER", self, "BOTTOM", (isMainHand and -1 or 1) * 40, 5)
    elseif itemLevelShownOnItem then
        self.Gems:SetPoint(self.IsLeftSideSlot and "LEFT" or "RIGHT", self, self.IsLeftSideSlot and "RIGHT" or "LEFT", (self.IsLeftSideSlot and 1 or -1) * 10, 0)
    elseif itemLevelShown and self.IsBottomSlot then
        self.Gems:SetPoint("LEFT", self.ItemLevel, "RIGHT", 1, 0)
    elseif itemLevelShown then
        self.Gems:SetPoint(self.IsLeftSideSlot and "LEFT" or "RIGHT", self.ItemLevel, self.IsLeftSideSlot and "RIGHT" or "LEFT", self.IsLeftSideSlot and 1 or -1, -1)
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
function PGVInspectSlotMixin:GetEnchant(slot, item)
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
                    enchText = enchText..texture
                else
                    -- If the preference is to hide enchant text, only show the enchant quality
                    enchText = enchText:gsub(" |A:.-|a", AddOn.GetTextureAtlasString(texture))
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
        local isCharacterMaxLevel = UnitLevel(UnitTokenFromGUID(AddOn.inspectedUnitGUID)) == AddOn.CurrentExpac.LevelCap
        if (AddOn.db.profile.enchants.missingMaxLevelOnly and isCharacterMaxLevel) or not AddOn.db.profile.enchants.missingMaxLevelOnly then
            if self.IsLeftSideSlot or (self.IsBottomSlot and slot:GetID() == 16) then
                self.Enchant:SetFormattedText(ColorText(L["Enchant"], "Druid")..AddOn.GetTextureString(523826))
            else
                self.Enchant:SetFormattedText(AddOn.GetTextureString(523826)..ColorText(L["Enchant"], "Druid"))
            end
            self.Enchant:Show()
        end
    elseif not isEnchanted then
        self.Enchant:ClearText()
        self.Enchant:Hide()
    end
end

---Set enchant text position in the Inspect window
---@param slot ItemSlot The gear slot to position enchant for
function PGVInspectSlotMixin:PositionEnchant(slot)
    self.Enchant:ClearAllPoints()

    local itemLevelShown = AddOn.db.profile.itemLevel.show and not AddOn.db.profile.itemLevel.onItem and self.ItemLevel:IsShown()
    local itemLevelShownOnItem = AddOn.db.profile.itemLevel.show and AddOn.db.profile.itemLevel.onItem and self.ItemLevel:IsShown()
    local upgradeTrackShown = AddOn:AreUpgradeTracksShownForCharacter() and self.UpgradeTrack:IsShown()
    local defaultYOffset = (itemLevelShownOnItem or (not itemLevelShown and AddOn:AreGemsShownForCharacter())) and 10 or 25
    local isMainHand = slot == _G["InspectMainHandSlot"]

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

---Show an icon/indicator for a gear slot containing an embellished item
---@param slot ItemSlot Gear slot frame
---@param item ItemMixin Equipped item
function PGVInspectSlotMixin:GetEmbellishments(slot, item)
    local tooltip = C_TooltipInfo.GetHyperlink(item:GetItemLink())
    if tooltip and tooltip.lines then
        for _, ttdata in pairs(tooltip.lines) do
            if ttdata and ttdata.leftText:find("Embellished") then
                self.EmbellishmentShadow:Show()
                -- Main embellishment star
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
                self.Embellishment:Show()
            else
                self.EmbellishmentShadow:Hide()
                self.Embellishment:Hide()
            end
        end
    else
        DebugPrint("GetEmbellishment: Tooltip information not obtained for slot", ColorText(slot:GetName(), "Heirloom"))
    end
end

---Shows embellishment shadow texture when embellishment is shown
function PGVInspectSlotMixin:OnShowEmbellishment()
    self.EmbellishmentShadow:Show()
end

---Hides embellishment shadow texture when embellishment is hidden
function PGVInspectSlotMixin:OnHideEmbellishment()
    self.EmbellishmentShadow:Hide()
end

---Updates FontString frames with custom font options (e.g. font scale, outline) specified for the current AddOn profile
---Applies to item level, upgrade track, gems, enchants, and durability text
function PGVInspectSlotMixin:SetFontOptions()
    if AddOn.db.profile.inspect.showILvl then
        local iFont, iSize = self.ItemLevel:GetFont()
        ---@cast iFont string
        self.ItemLevel:SetFont(iFont, iSize, AddOn.db.profile.itemLevel.outline)
        self.ItemLevel:SetTextScale(AddOn.db.profile.itemLevel.scale)
    end

    if AddOn.db.profile.inspect.showUpgradeTrack and AddOn:AreUpgradeTracksShownForCharacter() then
        local uFont, uSize = self.UpgradeTrack:GetFont()
        ---@cast uFont string
        self.UpgradeTrack:SetFont(uFont, uSize, AddOn.db.profile.upgradeTrack.outline)
        self.UpgradeTrack:SetTextScale(0.9 * AddOn.db.profile.upgradeTrack.scale)
    end
    
    if AddOn.db.profile.inspect.showGems and AddOn:AreGemsShownForCharacter() then
        self.Gems:SetTextScale(AddOn.db.profile.gems.scale)
    end
    
    if AddOn.db.profile.inspect.showEnchants and AddOn:AreEnchantsShownForCharacter() then
        local eFont, eSize = self.Enchant:GetFont()
        ---@cast eFont string
        self.Enchant:SetFont(eFont, eSize, AddOn.db.profile.enchants.outline)
        self.Enchant:SetTextScale(0.9 * AddOn.db.profile.enchants.scale)
    end
end

---Hides all child frames of PGVCharSlot (intended for use when an item is not equipped in a slot)
function PGVInspectSlotMixin:HideAllFrames()
    self.ItemLevel:Hide()
    self.UpgradeTrack:Hide()
    self.Gems:Hide()
    self.Enchant:Hide()
    self.Embellishment:Hide()
end