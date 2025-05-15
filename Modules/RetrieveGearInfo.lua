local addonName, AddOn = ...
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

local DebugPrint = AddOn.DebugPrint
local ColorText = AddOn.ColorText

function AddOn:GetItemLevelBySlot(slot, isInspect)
    local hasItem, item = self:IsItemEquippedInSlot(slot, isInspect)
    if hasItem then
        local itemLevel = item:GetCurrentItemLevel()
        if itemLevel > 0 then -- positive value indicates item info has loaded
            local iLvlText = itemLevel
            if self.db.profile.useQualityColorForILvl then
                local qualityHex = select(4, GetItemQualityColor(item:GetItemQuality()))
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

function AddOn:GetUpgradeTrackBySlot(slot, isInspect)
    local hasItem, item = AddOn:IsItemEquippedInSlot(slot, isInspect)
    if hasItem then
        local upgradeTrackText = ""
        local upgradeColor = ""
        local tooltip = C_TooltipInfo.GetHyperlink(item:GetItemLink())
        if tooltip and tooltip.lines then
            for _, ttdata in pairs(tooltip.lines) do
                -- Tooltip data type 42 is upgrade track
                if ttdata and ttdata.type and ttdata.type == 42 then
                    -- Displays past-season upgrade tracks in Gray
                    upgradeColor = ttdata.leftColor:GenerateHexColorNoAlpha()
                    local upgradeText = ttdata.leftText
                    for _, repl in pairs(AddOn.UpgradeTextReplace) do
                        upgradeText = upgradeText:gsub(repl.original, repl.replacement)
                    end
                    upgradeTrackText = upgradeText
                    DebugPrint("Upgrade track for item", ColorText(slot:GetID(), "Heirloom"), "=", upgradeText)
                end
            end
        end

        if upgradeTrackText ~= "" then
            local IsLeftSide = AddOn.GetSlotIsLeftSide(slot, isInspect)
            if IsLeftSide ~= nil and IsLeftSide then upgradeTrackText = " "..upgradeTrackText
            elseif IsLeftSide ~= nil then upgradeTrackText = upgradeTrackText.." "
            end
            if upgradeColor:lower() ~= AddOn.HexColorPresets.PrevSeasonGear:lower() then
                if self.db.profile.useCustomColorForUpgradeTrack then
                    upgradeColor = self.db.profile.upgradeTrackCustomColor
                else
                    upgradeColor = select(4, GetItemQualityColor(item:GetItemQuality()))
                    upgradeColor = upgradeColor:sub(3)
                end
            end
            slot.PGVUpgradeTrack:SetFormattedText(ColorText(upgradeTrackText, upgradeColor))
            slot.PGVUpgradeTrack:Show()
        end
    end
end

function AddOn:GetGemsBySlot(slot, isInspect)
    local hasItem, item = AddOn:IsItemEquippedInSlot(slot, isInspect)
    if hasItem then
        local existingSocketCount = 0
        local gemText = ""
        local IsLeftSide = self.GetSlotIsLeftSide(slot, isInspect)
        local tooltip = C_TooltipInfo.GetHyperlink(item:GetItemLink())
        if tooltip and tooltip.lines then
            for _, ttdata in pairs(tooltip.lines) do
                -- Tooltip data type 3 is gem
                if ttdata and ttdata.type and ttdata.type == 3 then
                    -- Socketed item will have gemIcon variable
                    if ttdata.gemIcon and IsLeftSide then
                        gemText = gemText..(existingSocketCount > 0 and "" or " ")..AddOn.GetTextureString(ttdata.gemIcon)
                    elseif ttdata.gemIcon then
                        gemText = AddOn.GetTextureString(ttdata.gemIcon)..(existingSocketCount > 0 and "" or " ")..gemText
                    -- The two conditions below indicate that there is an empty socket on the item
                    -- Texture: Interface/ItemSocketingFrame/UI-EmptySocket-Prismatic
                    elseif IsLeftSide then
                        gemText = gemText..(existingSocketCount > 0 and "" or " ")..AddOn.GetTextureString(458977)
                    else
                        gemText = AddOn.GetTextureString(458977)..(existingSocketCount > 0 and "" or " ")..gemText
                    end
                    existingSocketCount = existingSocketCount + 1
                end
            end
        end

        -- Indicates slots that can have sockets added to them
        if self.db.profile.showGems and self.db.profile.showMissingGems and AddOn.IsSocketableSlot(slot) and existingSocketCount < AddOn.CurrentExpac.MaxSocketsPerItem then
            local isCharacterMaxLevel = UnitLevel("player") == AddOn.CurrentExpac.LevelCap
            if (self.db.profile.missingGemsMaxLevelOnly and isCharacterMaxLevel) or not self.db.profile.missingGemsMaxLevelOnly then
                for i = 1, AddOn.CurrentExpac.MaxSocketsPerItem - existingSocketCount, 1 do
                    DebugPrint("Slot", ColorText(slot:GetID(), "Heirloom"), "can add", i, i == 1 and "socket" or "sockets")
                    gemText = IsLeftSide and gemText..(existingSocketCount > 0 and "" or " ")..AddOn.GetTextureAtlasString("Socket-Prismatic-Closed") or AddOn.GetTextureAtlasString("Socket-Prismatic-Closed")..(existingSocketCount > 0 and "" or " ")..gemText
                end
            end
        end
        if gemText ~= "" then
            slot.PGVGems:SetFormattedText(gemText)
            slot.PGVGems:Show()
        end
    end
end

function AddOn:GetEnchantmentBySlot(slot, isInspect)
    local hasItem, item = AddOn:IsItemEquippedInSlot(slot, isInspect)
    if hasItem then
        local isEnchanted = false
        local tooltip = C_TooltipInfo.GetHyperlink(item:GetItemLink())
        if tooltip and tooltip.lines then
            for _, ttdata in pairs(tooltip.lines) do
                -- Tooltip data type 15 is enchant
                if ttdata and ttdata.type and ttdata.type == 15 then
                    DebugPrint("Item in slot", ColorText(slot:GetID(), "Heirloom"), "is enchanted")
                    local enchText = ttdata.leftText
                    DebugPrint("Original enchantment text:", ColorText(enchText, "Uncommon"))
                    for _, repl in pairs(AddOn.EnchantTextReplace) do
                        enchText = enchText:gsub(repl.original, repl.replacement)
                    end
                    -- Trim enchant text to remove leading and trailing whitespace
                    -- strtrim is a Blizzard-provided global utility function
                    enchText = strtrim(enchText)
                    -- Resize any textures in the enchantment text
                    local texture = enchText:match("|A:(.-):")
                    -- If no texture is found, the enchant could be an older/DK one.
                    -- If DK enchant, set texture based on the icon shown for each enchant in Runeforging
                    if not texture then
                        local textureID
                        if enchText == AddOn.DKEnchantAbbr.Razorice then
                            textureID = 135842 -- Interface/Icons/Spell_Frost_FrostArmor
                        elseif enchText == AddOn.DKEnchantAbbr.Sanguination then
                            textureID = 1778226 -- Interface/Icons/Ability_Argus_DeathFod
                        elseif enchText == AddOn.DKEnchantAbbr.Spellwarding then
                            textureID = 425952 -- Interface/Icons/Spell_Fire_TwilightFireward
                        elseif enchText == AddOn.DKEnchantAbbr.Apocalypse then
                            textureID = 237535 -- Interface/Icons/Spell_DeathKnight_Thrash_Ghoul
                        elseif enchText == AddOn.DKEnchantAbbr.FallenCrusader then
                            textureID = 135957 -- Interface/Icons/Spell_Holy_RetributionAura
                        elseif enchText == AddOn.DKEnchantAbbr.StoneskinGargoyle then
                            textureID = 237480 -- Interface/Icons/Inv_Sword_130
                        elseif enchText == AddOn.DKEnchantAbbr.UnendingThirst then
                            textureID = 3163621 -- Interface/Icons/Spell_NZInsanity_Bloodthirst
                        else
                            textureID = 628564 -- Interface/Scenarios/ScenarioIcon-Check
                        end
                        texture = AddOn.GetTextureString(textureID)

                        enchText = (self.db.profile.collapseEnchants and not isInspect) and texture or (enchText..texture)
                    else
                        -- If the preference is to hide enchant text, only show the enchant quality
                        enchText = (self.db.profile.collapseEnchants and not isInspect) and AddOn.GetTextureAtlasString(texture) or enchText:gsub(" |A:.-|a", AddOn.GetTextureAtlasString(texture))
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

        if not isEnchanted and AddOn.IsEnchantableSlot(slot) and self.db.profile.showMissingEnchants then
            local isCharacterMaxLevel = UnitLevel("player") == AddOn.CurrentExpac.LevelCap
            if (self.db.profile.missingEnchantsMaxLevelOnly and isCharacterMaxLevel) or not self.db.profile.missingEnchantsMaxLevelOnly then
                -- Texture: Interface/EncounterJournal/UI-EJ-WarningTextIcon
                slot.PGVEnchant:SetFormattedText(self.db.profile.collapseEnchants and AddOn.GetTextureString(523826) or AddOn.GetTextureString(523826)..ColorText(L["Enchant"], "Druid"))
                slot.PGVEnchant:Show()
            end
        end
    end
end