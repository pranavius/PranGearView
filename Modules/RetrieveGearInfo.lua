local addonName, AddOn = ...
---@class PranGearView: AceAddon, AceConsole-3.0, AceEvent-3.0
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

local DebugPrint = AddOn.DebugPrint
local ColorText = AddOn.ColorText

---Fetches and formats the item level for an item in the defined gear slot (if one exists)
---@param slot Slot The gear slot to get item level for
---@param isInspect? boolean Whether or not a character is currently being inspected
function AddOn:GetItemLevelBySlot(slot, isInspect)
    local hasItem, item = self:IsItemEquippedInSlot(slot, isInspect)
    if hasItem then
        local itemLevel = item:GetCurrentItemLevel()
        if itemLevel > 0 then -- positive value indicates item info has loaded
            local iLvlText = tostring(itemLevel)
            if self.db.profile.useGradientColorsForILvl then
                local equippedItemLevel = select(2, GetAverageItemLevel())
                local color = (itemLevel < equippedItemLevel - 10 and "Error"
                    or itemLevel > equippedItemLevel + 10 and "Uncommon"
                    or "Info")
                iLvlText = ColorText(iLvlText, color)
            elseif self.db.profile.useQualityColorForILvl then
                local qualityHex = select(4, C_Item.GetItemQualityColor(item:GetItemQuality()))
                iLvlText = "|c"..qualityHex..iLvlText.."|r"
            elseif self.db.profile.useClassColorForILvl then
                local classFile = select(2, UnitClass("player"))
                local classHexWithAlpha = select(4, GetClassColor(classFile))
                iLvlText = "|c"..classHexWithAlpha..iLvlText.."|r"
            elseif self.db.profile.useCustomColorForILvl then
                iLvlText = ColorText(iLvlText, self.db.profile.iLvlCustomColor)
            end

            DebugPrint("Item Level text for slot", ColorText(slot:GetID(), "Heirloom"), "=", iLvlText)
            slot.PGVItemLevel:SetFormattedText(iLvlText)
            slot.PGVItemLevel:Show()
        else
            DebugPrint("Item Level less than 0 found, retry self:GetItemLevelBySlot for slot", ColorText(slot:GetID(), "Heirloom"))
            C_Timer.After(0.5, function() self:GetItemLevelBySlot(slot, isInspect) end)
        end
    end
end

---Fetches and formats the upgrade track for an item in the defined gear slot (if one exists)
---@param slot Slot The gear slot to get item level for
---@param isInspect? boolean Whether or not a character is currently being inspected
function AddOn:GetUpgradeTrackBySlot(slot, isInspect)
    local hasItem, item = self:IsItemEquippedInSlot(slot, isInspect)
    if hasItem then
        local upgradeTrackText = ""
        local upgradeColor = ""
        local tooltip = C_TooltipInfo.GetHyperlink(item:GetItemLink())
        if tooltip and tooltip.lines then
            for _, ttdata in pairs(tooltip.lines) do
                if ttdata and ttdata.type and ttdata.type == self.TooltipDataType.UpgradeTrack then
                    -- Displays past-season upgrade tracks in gray
                    upgradeColor = ttdata.leftColor:GenerateHexColorNoAlpha()
                    local upgradeText = ttdata.leftText
                    upgradeText = self:AbbreviateText(upgradeText, self.UpgradeTextReplacements)
                    upgradeTrackText = upgradeText
                    DebugPrint("Upgrade track for item", ColorText(slot:GetID(), "Heirloom"), "=", upgradeText)
                end
            end
        end

        if upgradeTrackText ~= "" then
            if upgradeColor:lower() ~= self.HexColorPresets.PrevSeasonGear:lower() then
                if self.db.profile.useQualityScaleColorsForUpgradeTrack then
                    -- Do something
                    if upgradeTrackText:match("E") or upgradeTrackText:match("A") then
                        upgradeColor = self.HexColorPresets.Priest
                    elseif upgradeTrackText:match("V") then
                        upgradeColor = self.HexColorPresets.Uncommon
                    elseif upgradeTrackText:match("C") then
                        upgradeColor = self.HexColorPresets.Rare
                    elseif upgradeTrackText:match("H") then
                        upgradeColor = self.HexColorPresets.Epic
                    elseif upgradeTrackText:match("M") then
                        upgradeColor = self.HexColorPresets.Legendary
                    else
                        -- If a match isn't found, fallback to the item quality color
                        upgradeColor = select(4, C_Item.GetItemQualityColor(item:GetItemQuality())):sub(3)
                    end
                elseif self.db.profile.useCustomColorForUpgradeTrack then
                    upgradeColor = self.db.profile.upgradeTrackCustomColor
                else
                    upgradeColor = select(4, C_Item.GetItemQualityColor(item:GetItemQuality())):sub(3)
                end
            end
            slot.PGVUpgradeTrack:SetFormattedText(ColorText(upgradeTrackText, upgradeColor))
            slot.PGVUpgradeTrack:Show()
        end
    end
end

---Fetches and formats the gems currently socketed for an item in the defined gear slot (if one exists).
---If sockets are empty/can be addded to the item and the option to show missing sockets is enabled, these will also be indicated in the formatted text.
---@param slot Slot The gear slot to get gem information for
---@param isInspect? boolean Whether or not a character is currently being inspected
function AddOn:GetGemsBySlot(slot, isInspect)
    local hasItem, item = self:IsItemEquippedInSlot(slot, isInspect)
    if hasItem then
        local existingSocketCount = 0
        local gemText = ""
        local IsLeftSide = self:GetSlotIsLeftSide(slot, isInspect)
        local tooltip = C_TooltipInfo.GetHyperlink(item:GetItemLink())
        if tooltip and tooltip.lines then
            for _, ttdata in pairs(tooltip.lines) do
                if ttdata and ttdata.type and ttdata.type == self.TooltipDataType.Gem then
                    -- Socketed item will have gemIcon variable
                    if ttdata.gemIcon and IsLeftSide then
                        DebugPrint("Found Gem Icon on left side slot:", ColorText(slot:GetID(), "Heirloom"), ttdata.gemIcon, self.GetTextureString(ttdata.gemIcon))
                        gemText = gemText..self.GetTextureString(ttdata.gemIcon)
                    elseif ttdata.gemIcon then
                        DebugPrint("Found Gem Icon:", ColorText(slot:GetID(), "Heirloom"), ttdata.gemIcon, self.GetTextureString(ttdata.gemIcon))
                        gemText = self.GetTextureString(ttdata.gemIcon)..gemText
                    -- Two conditions below check for tinker sockets
                    elseif ttdata.socketType and IsLeftSide then
                        DebugPrint("Empty tinker socket for in slot on left side:", ColorText(slot:GetID(), "Heirloom"), self.GetTextureString("Interface/ItemSocketingFrame/UI-EmptySocket-"..ttdata.socketType))
                        gemText = gemText..self.GetTextureString("Interface/ItemSocketingFrame/UI-EmptySocket-"..ttdata.socketType)
                    elseif ttdata.socketType then
                        DebugPrint("Empty tinker socket found in slot:", ColorText(slot:GetID(), "Heirloom"), self.GetTextureString("Interface/ItemSocketingFrame/UI-EmptySocket-"..ttdata.socketType))
                        gemText = self.GetTextureString("Interface/ItemSocketingFrame/UI-EmptySocket-"..ttdata.socketType)..gemText
                    -- The two conditions below indicate that there is an empty socket on the item
                    elseif IsLeftSide then
                        DebugPrint("Empty socket found in slot on left side:", ColorText(slot:GetID(), "Heirloom"), self.GetTextureString(458977))
                        -- Texture: Interface/ItemSocketingFrame/UI-EmptySocket-Prismatic
                        gemText = gemText..self.GetTextureString(458977)
                    else
                        DebugPrint("Empty socket found in slot:", ColorText(slot:GetID(), "Heirloom"), self.GetTextureString(458977))
                        gemText = self.GetTextureString(458977)..gemText
                    end
                    existingSocketCount = existingSocketCount + 1
                end
            end
        end

        -- Indicates slots that can have sockets added to them
        local showGems = isInspect and self.db.profile.showInspectGems or self.db.profile.showGems
        if showGems and self.db.profile.showMissingGems and self:IsSocketableSlot(slot) and existingSocketCount < self.CurrentExpac.MaxSocketsPerItem then
            local isCharacterMaxLevel = UnitLevel("player") == self.CurrentExpac.LevelCap
            if (self.db.profile.missingGemsMaxLevelOnly and isCharacterMaxLevel) or not self.db.profile.missingGemsMaxLevelOnly then
                for i = 1, self.CurrentExpac.MaxSocketsPerItem - existingSocketCount, 1 do
                    DebugPrint("Slot", ColorText(slot:GetID(), "Heirloom"), "can add", i, i == 1 and "socket" or "sockets")
                    gemText = IsLeftSide and gemText..self.GetTextureAtlasString("Socket-Prismatic-Closed") or self.GetTextureAtlasString("Socket-Prismatic-Closed")..gemText
                end
            end
        end
        if gemText ~= "" then
            slot.PGVGems:SetFormattedText(gemText)
            slot.PGVGems:Show()
        end
    end
end

---Fetches and formats the enchant details for an item in the defined gear slot (if one exists).
---If an item that can be enchanted isn't and the option to show missing enchants is enabled, this will also be indicated in the formatted text.
---@param slot Slot The gear slot to get gem information for
---@param isInspect? boolean Whether or not a character is currently being inspected
function AddOn:GetEnchantmentBySlot(slot, isInspect)
    local hasItem, item = self:IsItemEquippedInSlot(slot, isInspect)
    if hasItem then
        local isEnchanted = false
        local tooltip = C_TooltipInfo.GetHyperlink(item:GetItemLink())
        if tooltip and tooltip.lines then
            for _, ttdata in pairs(tooltip.lines) do
                if ttdata and ttdata.type and ttdata.type == self.TooltipDataType.Enchant then
                    DebugPrint("Item in slot", ColorText(slot:GetID(), "Heirloom"), "is enchanted")
                    local enchText = ttdata.leftText
                    DebugPrint("Original enchantment text:", ColorText(enchText, "Uncommon"))
                    enchText = self:AbbreviateText(enchText, self.EnchantTextReplacements)
                    -- Perform locale replacements specific to ptBR to further shorten and fix some abbreviations
                    if GetLocale() == "ptBR" then enchText = self:AbbreviateText(enchText, self.ptbrEnchantTextReplacements) end
                    -- Trim enchant text to remove leading and trailing whitespace
                    -- strtrim is a Blizzard-provided global utility function
                    enchText = strtrim(enchText)
                    -- Resize any textures in the enchantment text
                    local texture = enchText:match("|A:(.-):")
                    -- If no texture is found, the enchant could be an older/DK one.
                    -- If DK enchant, set texture based on the icon shown for each enchant in Runeforging
                    if not texture then
                        local textureID
                        if enchText == self.DKEnchantAbbr.Razorice then
                            textureID = 135842 -- Interface/Icons/Spell_Frost_FrostArmor
                        elseif enchText == self.DKEnchantAbbr.Sanguination then
                            textureID = 1778226 -- Interface/Icons/Ability_Argus_DeathFod
                        elseif enchText == self.DKEnchantAbbr.Spellwarding then
                            textureID = 425952 -- Interface/Icons/Spell_Fire_TwilightFireward
                        elseif enchText == self.DKEnchantAbbr.Apocalypse then
                            textureID = 237535 -- Interface/Icons/Spell_DeathKnight_Thrash_Ghoul
                        elseif enchText == self.DKEnchantAbbr.FallenCrusader then
                            textureID = 135957 -- Interface/Icons/Spell_Holy_RetributionAura
                        elseif enchText == self.DKEnchantAbbr.StoneskinGargoyle then
                            textureID = 237480 -- Interface/Icons/Inv_Sword_130
                        elseif enchText == self.DKEnchantAbbr.UnendingThirst then
                            textureID = 3163621 -- Interface/Icons/Spell_NZInsanity_Bloodthirst
                        else
                            textureID = 628564 -- Interface/Scenarios/ScenarioIcon-Check
                        end
                        texture = self.GetTextureString(textureID)

                        enchText = (self.db.profile.collapseEnchants and not isInspect) and texture or (enchText..texture)
                    else
                        -- If the preference is to hide enchant text, only show the enchant quality
                        enchText = (self.db.profile.collapseEnchants and not isInspect) and self.GetTextureAtlasString(texture) or enchText:gsub(" |A:.-|a", self.GetTextureAtlasString(texture))
                    end
                    DebugPrint("Abbreviated enchantment text:", ColorText(enchText, "Uncommon"))
    
                    if self.db.profile.useCustomColorForEnchants then
                        slot.PGVEnchant:SetFormattedText(ColorText(enchText, self.db.profile.enchCustomColor))
                    else
                        slot.PGVEnchant:SetFormattedText(ColorText(enchText, "Uncommon"))
                    end
                    slot.PGVEnchant:Show()
                    isEnchanted = true
                end
            end
        end

        if not isEnchanted and self:IsEnchantableSlot(slot) and self.db.profile.showMissingEnchants then
            local isCharacterMaxLevel = UnitLevel("player") == self.CurrentExpac.LevelCap
            if (self.db.profile.missingEnchantsMaxLevelOnly and isCharacterMaxLevel) or not self.db.profile.missingEnchantsMaxLevelOnly then
                local IsLeftSide = self:GetSlotIsLeftSide(slot, isInspect)
                if self.db.profile.collapseEnchants and not isInspect then
                    -- Texture: Interface/EncounterJournal/UI-EJ-WarningTextIcon
                    slot.PGVEnchant:SetFormattedText(self.GetTextureString(523826))
                -- For left side and main hand slots, show the icon to the right of the text. For all other slots, show the icon to the left (better mirroring look and feel)
                elseif IsLeftSide or (IsLeftSide == nil and slot:GetID() == 16) then slot.PGVEnchant:SetFormattedText(ColorText(L["Enchant"], "Druid")..self.GetTextureString(523826))
                else slot.PGVEnchant:SetFormattedText(self.GetTextureString(523826)..ColorText(L["Enchant"], "Druid"))
                end
                slot.PGVEnchant:Show()
            end
        end
    end
end

---Fetches and formats the durability percentage for an item in the defined gear slot (if one exists).
---@param slot Slot The gear slot to get durability information for
function AddOn:ShowDurabilityBySlot(slot)
    local hasItem = self:IsItemEquippedInSlot(slot)
    if hasItem then
        local cDur, mDur = GetInventoryItemDurability(slot:GetID())
        if cDur and mDur then
            if not slot.PGVDurability then
                slot.PGVDurability = slot:CreateFontString("PGVDurability"..slot:GetID(), "OVERLAY", "GameTooltipText")
            end
            slot.PGVDurability:Hide()
            local dFont, dSize = slot.PGVDurability:GetFont()
            ---@cast dFont string
            slot.PGVDurability:SetFont(dFont, dSize, "OUTLINE")
            local durTextScale = 0.9
            if self.db.profile.durabilityScale and self.db.profile.durabilityScale > 0 then
                durTextScale = durTextScale * self.db.profile.durabilityScale
            end
            slot.PGVDurability:SetTextScale(durTextScale)
            slot.PGVDurability:SetPoint("CENTER", slot, "BOTTOM", 0, 5)

            local durText = ""
            local percent = self.RoundNumber((cDur / mDur) * 100)
            if percent < 100 and percent > 50 then
                durText = ColorText(percent.."%%", "Uncommon")
            elseif percent < 100 and percent > 25 then
                durText = ColorText(percent.."%%", "Info")
            elseif percent < 100 and percent > 0 then
                durText = ColorText(percent.."%%", "Legendary")
            elseif percent == 0 then
                durText = ColorText(percent.."%%", "DeathKnight")
            end
            DebugPrint("Durability for slot", ColorText(slot:GetID(), "Heirloom"), "=", durText)
            slot.PGVDurability:SetFormattedText(durText)
            if durText ~= "" then slot.PGVDurability:Show() end
        elseif slot.PGVDurability then
            slot.PGVDurability:Hide()
        end
    else
        DebugPrint("Slot", ColorText(slot:GetID(), "Heirloom"), "does not have an item equipped")
        if slot.PGVDurability then slot.PGVDurability:Hide() end
    end
end

---Fetches and formats embellishment details for an item in the defined gear slot (if one exists and is embellished)
---@param slot Slot The gear slot to get gem information for
---@param isInspect? boolean Whether or not a character is currently being inspected
function AddOn:ShowEmbellishmentBySlot(slot, isInspect)
    if slot.PGVEmbellishmentTexture then slot.PGVEmbellishmentTexture:Hide() end
    if slot.PGVEmbellishmentShadow then slot.PGVEmbellishmentShadow:Hide() end
    local hasItem, item = self:IsItemEquippedInSlot(slot, isInspect)
    if hasItem then
        local tooltip = C_TooltipInfo.GetHyperlink(item:GetItemLink())
        if tooltip and tooltip.lines then
            for _, ttdata in pairs(tooltip.lines) do
                if ttdata and ttdata.leftText:find("Embellished") then
                    -- Create shadow layer (semi-transparent black)
                    if not slot.PGVEmbellishmentShadow then
                        slot.PGVEmbellishmentShadow = slot:CreateTexture("PGVEmbellishmentShadow"..slot:GetID(), "ARTWORK")
                    end
                    slot.PGVEmbellishmentShadow:ClearAllPoints()
                    slot.PGVEmbellishmentShadow:SetAllPoints(slot)
                    slot.PGVEmbellishmentShadow:SetTexture("Interface/Buttons/WHITE8x8")
                    slot.PGVEmbellishmentShadow:SetVertexColor(0, 0, 0, 0.3)
                    slot.PGVEmbellishmentShadow:Show()

                    -- Main embellishment star (top layer)
                    if not slot.PGVEmbellishmentTexture then
                        DebugPrint("Creating embellishment texture in slot", ColorText(slot:GetID(), "Heirloom"))
                        slot.PGVEmbellishmentTexture = slot:CreateTexture("PGVEmbellishmentTexture"..slot:GetID(), "OVERLAY")
                    end
                    slot.PGVEmbellishmentTexture:SetSize(25, 25)
                    slot.PGVEmbellishmentTexture:ClearAllPoints()
                    if self.db.profile.showiLvl and self.db.profile.iLvlOnItem then
                        slot.PGVEmbellishmentTexture:SetPoint("BOTTOMLEFT", slot, "BOTTOMLEFT", 2, -7)
                    else
                        slot.PGVEmbellishmentTexture:SetPoint("TOPLEFT", slot, "TOPLEFT", 0, 0)
                    end
                    slot.PGVEmbellishmentTexture:SetTexture("Interface/LootFrame/Toast-Star")
                    slot.PGVEmbellishmentTexture:SetVertexColor(0, 1, 0.6, 1)
                    DebugPrint("Showing embellishments enabled, embellishment found on slot |cFF00ccff"..slot:GetID().."|r")
                    slot.PGVEmbellishmentTexture:Show()
                end
            end
        else
            DebugPrint("Tooltip information could not be obtained for slot |cFFc00ccff"..slot:GetID().."|r")
        end
    else
        DebugPrint("No item equipped in slot |cFF00ccff"..slot:GetID().."|r")
    end
end
