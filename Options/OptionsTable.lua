local addonName, AddOn = ...
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)
---@cast AddOn PranGearView
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)
local LDBIcon = LibStub("LibDBIcon-1.0")
local ColorText = AddOn.ColorText
local DebugPrint = AddOn.DebugPrint

local orderCounter = CreateCounter()
AddOn.OptionsTable = {
    type = "group",
    name = addonName,
    args = {
        usageDesc = {
            type = "description",
            name = L["Choose information to show in the Character Info window"],
            width = "full",
            order = orderCounter(),
        },
        spacer = AddOn.CreateOptionsSpacer(orderCounter()),
        showiLvl = {
            type = "toggle",
            name = L["Item Level"],
            desc = L["Display item levels for equipped items"],
            order = orderCounter(),
            get = function() return AddOn.db.profile.itemLevel.show end,
            set = function(_, val)
                AddOn.db.profile.itemLevel.show = val
                AddOn:HandleEquipmentOrSettingsChange()
            end
        },
        showUpgradeTrack = {
            type = "toggle",
            name = L["Upgrade Track"],
            desc = L["Display upgrade track and progress for equipped items"],
            order = orderCounter(),
            get = function() return AddOn.db.profile.upgradeTrack.show end,
            set = function(_, val)
                AddOn.db.profile.upgradeTrack.show = val
                AddOn:HandleEquipmentOrSettingsChange()
            end,
            hidden = function() return AddOn:IsTimerunningCharacter() end
        },
        showGems = {
            type = "toggle",
            name = L["Gems"],
            desc = L["Display gem and socket information for equipped items"],
            order = orderCounter(),
            get = function() return AddOn.db.profile.gems.show end,
            set = function(_, val)
                AddOn.db.profile.gems.show = val
                AddOn:HandleEquipmentOrSettingsChange()
            end,
            hidden = function() return AddOn:IsTimerunningCharacter() end
        },
        showEnchants = {
            type = "toggle",
            name = L["Enchants"],
            desc = L["Display enchant information for equipped items"],
            order = orderCounter(),
            get = function() return AddOn.db.profile.enchants.show end,
            set = function(_, val)
                AddOn.db.profile.enchants.show = val
                if not val and AddOn.PGVToggleEnchantButton:IsShown() then
                    AddOn.PGVToggleEnchantButton:Hide()
                elseif val and not AddOn.PGVToggleEnchantButton:IsShown() then
                    AddOn.PGVToggleEnchantButton:Show()
                end
                AddOn:HandleEquipmentOrSettingsChange()
            end,
            hidden = function() return AddOn:IsTimerunningCharacter() end
        },
        showDurability = {
            type = "toggle",
            name = L["Durability"],
            desc = L["Display durability percentages for equipped items"],
            order = orderCounter(),
            get = function() return AddOn.db.profile.durability.show end,
            set = function(_, val)
                AddOn.db.profile.durability.show = val
                AddOn:HandleEquipmentOrSettingsChange()
            end
        },
        divider = {
            type = "header",
            name = "",
            order = orderCounter()
        },
        iLvlOptions = {
            type = "group",
            name = L["Item Level"],
            order = orderCounter(),
            args = {
                iLvlScale = {
                    type = "range",
                    name = L["Font Scale"],
                    desc = L["Scale item level text size relative to the default"],
                    order = orderCounter(),
                    min = 0.1,
                    max = 2,
                    step = 0.05,
                    get = function() return AddOn.db.profile.itemLevel.scale end,
                    set = function(_, val)
                        AddOn.db.profile.itemLevel.scale = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.itemLevel.show end
                },
                smallSpacer = AddOn.CreateOptionsSpacer(orderCounter(), 0.25),
                iLvlOutline = {
                    type = "select",
                    name = L["Outline"],
                    desc = L["The outline style to add to item level text"].."\n\n"..L["Does nothing if the Alternate Item Level Placement checkbox is checked"],
                    order = orderCounter(),
                    values = function()
                        local options = {}
                        for _, option in ipairs(AddOn.OutlineOptions) do
                            options[option.value] = option.key
                        end
                        return options
                    end,
                    get = function()
                        if not AddOn.db.profile.itemLevel.outline then
                            AddOn.db.profile.itemLevel.outline = ""
                        end

                        return AddOn.db.profile.itemLevel.outline
                    end,
                    set = function(_, val)
                        AddOn.db.profile.itemLevel.outline = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.itemLevel.show end
                },
                spacer = AddOn.CreateOptionsSpacer(orderCounter()),
                iLvlOnItem = {
                    type = "toggle",
                    name = L["Alternate Item Level Placement"],
                    width = "full",
                    desc = L["Display item levels on top of equipment icons"],
                    order = orderCounter(),
                    get = function() return AddOn.db.profile.itemLevel.onItem end,
                    set = function(_, val)
                        AddOn.db.profile.itemLevel.onItem = val
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.itemLevel.show end
                },
                spacerTwo = AddOn.CreateOptionsSpacer(orderCounter()),
                iLvlColorOptionsDesc = {
                    type = "description",
                    name = ColorText(L["Item levels shown in white when no color options are selected"], "Info"),
                    order = orderCounter()
                },
                spacerThree = AddOn.CreateOptionsSpacer(orderCounter()),
                useQualityColorForILvl = {
                    type = "toggle",
                    name = L["Use Item Quality Color"],
                    desc = L["Color item levels based on item quality"],
                    order = orderCounter(),
                    get = function() return AddOn.db.profile.itemLevel.useQualityColor end,
                    set = function(_, val)
                        AddOn.db.profile.itemLevel.useQualityColor = val
                        if val then
                            AddOn.db.profile.itemLevel.useClassColor = false
                            AddOn.db.profile.itemLevel.useGradientColors = false
                            AddOn.db.profile.itemLevel.useCustomColor = false
                        end
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.itemLevel.show end
                },
                useClassColorForILvl = {
                    type = "toggle",
                    name = L["Use Class Color"],
                    desc = L["Color item levels based on the character's class"],
                    order = orderCounter(),
                    get = function() return AddOn.db.profile.itemLevel.useClassColor end,
                    set = function(_, val)
                        AddOn.db.profile.itemLevel.useClassColor = val
                        if val then
                            AddOn.db.profile.itemLevel.useQualityColor = false
                            AddOn.db.profile.itemLevel.useGradientColors = false
                            AddOn.db.profile.itemLevel.useCustomColor = false
                        end
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.itemLevel.show end
                },
                useGradientColorsForILvl = {
                    type = "toggle",
                    name = L["Use Item Level Gradient"],
                    desc = L["Color highest item level in green, lowest item level in red, and the rest in yellow."].."\n\n"..L["This color scheme follows a similar pattern to the Shadow & Light plugin for ElvUI"],
                    order = orderCounter(),
                    get = function() return AddOn.db.profile.itemLevel.useGradientColors end,
                    set = function(_, val)
                        AddOn.db.profile.itemLevel.useGradientColors = val
                        if val then
                            AddOn.db.profile.itemLevel.useQualityColor = false
                            AddOn.db.profile.itemLevel.useClassColor = false
                            AddOn.db.profile.itemLevel.useCustomColor = false
                        end
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.itemLevel.show end
                },
                useCustomColorForILvl = {
                    type = "toggle",
                    name = L["Use Custom Color"],
                    width = "full",
                    desc = L["Customize item level color"],
                    order = orderCounter(),
                    get = function() return AddOn.db.profile.itemLevel.useCustomColor end,
                    set = function(_, val)
                        AddOn.db.profile.itemLevel.useCustomColor = val
                        if val then
                            AddOn.db.profile.itemLevel.useQualityColor = false
                            AddOn.db.profile.itemLevel.useClassColor = false
                            AddOn.db.profile.itemLevel.useGradientColors = false
                        end
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.itemLevel.show end
                },
                customColorDesc = {
                    type = "description",
                    name = "\n"..L["Choose from the color picker or enter the hex code for a specific color."].."\n"..L["Color codes should be entered in the format #RRGGBB"].."\n\n",
                    order = orderCounter(),
                    hidden = function() return not AddOn.db.profile.itemLevel.useCustomColor end
                },
                iLvlCustomColor = {
                    type = "color",
                    name = L["Choose a Color"],
                    order = orderCounter(),
                    hasAlpha = false,
                    get = function()
                        if not AddOn.db.profile.itemLevel.customColor then AddOn.db.profile.itemLevel.customColor = AddOn.HexColorPresets.Priest end
                        local hex = AddOn.db.profile.itemLevel.customColor
                        return AddOn.ConvertHexToRGB(hex)
                    end,
                    set = function(_, r, g, b)
                        AddOn.db.profile.itemLevel.customColor = AddOn.ConvertRGBToHex(r, g, b)
                        LibStub("AceConfigRegistry-3.0"):NotifyChange(addonName)
                        LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.itemLevel.show or not AddOn.db.profile.itemLevel.useCustomColor end,
                    hidden = function() return not AddOn.db.profile.itemLevel.useCustomColor end
                },
                customColorHex = {
                    type = "input",
                    name = "",
                    width = 0.65,
                    order = orderCounter(),
                    get = function()
                        if not AddOn.db.profile.itemLevel.customColor then
                            AddOn.db.profile.itemLevel.customColor = AddOn.HexColorPresets.Priest
                        end
                        return "#"..AddOn.db.profile.itemLevel.customColor
                    end,
                    set = function(_, val)
                        -- Validate that the provided hex code can be converted to an RGB color before setting
                        local r, g, b = AddOn.ConvertHexToRGB(val:gsub("#", ""))
                        if r ~= nil and g ~= nil and b ~= nil then
                            AddOn.db.profile.itemLevel.customColor = val:gsub("#", "")
                            AddOn:HandleEquipmentOrSettingsChange()
                        end
                    end,
                    disabled = function() return not AddOn.db.profile.itemLevel.show or not AddOn.db.profile.itemLevel.useCustomColor end,
                    hidden = function() return not AddOn.db.profile.itemLevel.useCustomColor end
                },
                resetCustomColor = {
                    type = "execute",
                    name = L["Reset"],
                    width = "half",
                    order = orderCounter(),
                    func = function()
                        AddOn.db.profile.itemLevel.customColor = AddOn.HexColorPresets.Priest
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function()
                        local itemLevelShown = AddOn.db.profile.itemLevel.show
                        local usingCustomColor = AddOn.db.profile.itemLevel.useCustomColor
                        local customColorIsDefault = itemLevelShown and usingCustomColor and AddOn.db.profile.itemLevel.customColor == AddOn.HexColorPresets.Priest
                        return not itemLevelShown or not usingCustomColor or customColorIsDefault
                    end,
                    hidden = function() return not AddOn.db.profile.itemLevel.useCustomColor end
                }
            }
        },
        upgradeTrackOptions = {
            type = "group",
            name = L["Upgrade Track"],
            order = orderCounter(),
            args = {
                upgradeTrackScale = {
                    type = "range",
                    name = L["Font Scale"],
                    desc = L["Scale upgrade track text size relative to the default"],
                    order = orderCounter(),
                    min = 0.1,
                    max = 2,
                    step = 0.05,
                    get = function() return AddOn.db.profile.upgradeTrack.scale end,
                    set = function(_, val)
                        AddOn.db.profile.upgradeTrack.scale = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.upgradeTrack.show end
                },
                smallSpacer = AddOn.CreateOptionsSpacer(orderCounter(), 0.25),
                upgradeTrackOutline = {
                    type = "select",
                    name = L["Outline"],
                    desc = L["The outline style to add to upgrade track text"],
                    order = orderCounter(),
                    values = function()
                        local options = {}
                        for _, option in ipairs(AddOn.OutlineOptions) do
                            options[option.value] = option.key
                        end
                        return options
                    end,
                    get = function()
                        if not AddOn.db.profile.upgradeTrack.outline then
                            AddOn.db.profile.upgradeTrack.outline = ""
                        end

                        return AddOn.db.profile.upgradeTrack.outline
                    end,
                    set = function(_, val)
                        AddOn.db.profile.upgradeTrack.outline = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.itemLevel.show or AddOn.db.profile.itemLevel.onItem end
                },
                spacer = AddOn.CreateOptionsSpacer(orderCounter()),
                upgradeTrackColorDesc = {
                    type = "description",
                    name = ColorText(L["By default, upgrade tracks are shown in the color that matches the quality of the equipment. Upgrade tracks for previous season equipment always appear in gray"], "Info"),
                    order = orderCounter()
                },
                spacerTwo = AddOn.CreateOptionsSpacer(orderCounter()),
                useQualityScaleColorsForUpgradeTrack = {
                    type = "toggle",
                    name = L["Use Quality Color Scale"],
                    width = "full",
                    desc = L["Use the item quality color scale when showing upgrade tracks"].."\n\n"..ColorText(strtrim(L["Explorer "]), "Priest").."\n"..ColorText(strtrim(L["Adventurer "]), "Priest").."\n"..ColorText(strtrim(L["Veteran "]), "Uncommon").."\n"..ColorText(strtrim(L["Champion "]), "Rare").."\n"..ColorText(strtrim(L["Hero "]), "Epic").."\n"..ColorText(strtrim(L["Myth "]), "Legendary"),
                    order = orderCounter(),
                    get = function() return AddOn.db.profile.upgradeTrack.useQualityScaleColors end,
                    set = function(_, val)
                        AddOn.db.profile.upgradeTrack.useQualityScaleColors = val
                        if val then AddOn.db.profile.upgradeTrack.useCustomColor = false end
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.upgradeTrack.show end
                },
                useCustomColorForUpgradeTrack = {
                    type = "toggle",
                    name = L["Use Custom Color"],
                    width = "full",
                    desc = L["Customize upgrade track color for current season items"],
                    order = orderCounter(),
                    get = function() return AddOn.db.profile.upgradeTrack.useCustomColor end,
                    set = function(_, val)
                        AddOn.db.profile.upgradeTrack.useCustomColor = val
                        if val then AddOn.db.profile.upgradeTrack.useQualityScaleColors = false end
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.upgradeTrack.show end
                },
                customColorDesc = {
                    type = "description",
                    name = "\n"..L["Choose from the color picker or enter the hex code for a specific color."].."\n"..L["Color codes should be entered in the format #RRGGBB"].."\n\n",
                    order = orderCounter(),
                    hidden = function() return not AddOn.db.profile.upgradeTrack.useCustomColor end
                },
                upgradeTrackCustomColor = {
                    type = "color",
                    name = L["Choose a Color"],
                    order = orderCounter(),
                    hasAlpha = false,
                    get = function()
                        if not AddOn.db.profile.upgradeTrack.customColor then AddOn.db.profile.upgradeTrack.customColor = AddOn.HexColorPresets.Priest end
                        local hex = AddOn.db.profile.upgradeTrack.customColor
                        return AddOn.ConvertHexToRGB(hex)
                    end,
                    set = function(_, r, g, b)
                        AddOn.db.profile.upgradeTrack.customColor = AddOn.ConvertRGBToHex(r, g, b)
                        LibStub("AceConfigRegistry-3.0"):NotifyChange(addonName)
                        LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.upgradeTrack.show or not AddOn.db.profile.upgradeTrack.useCustomColor end,
                    hidden = function() return not AddOn.db.profile.upgradeTrack.useCustomColor end
                },
                upgradeTrackCustomColorHex = {
                    type = "input",
                    name = "",
                    width = 0.65,
                    order = orderCounter(),
                    get = function()
                        if not AddOn.db.profile.upgradeTrack.customColor then
                            AddOn.db.profile.upgradeTrack.customColor = AddOn.HexColorPresets.Priest
                        end
                        return "#"..AddOn.db.profile.upgradeTrack.customColor
                    end,
                    set = function(_, val)
                        -- Validate that the provided hex code can be converted to an RGB color before setting
                        local r, g, b = AddOn.ConvertHexToRGB(val:gsub("#", ""))
                        if r ~= nil and g ~= nil and b ~= nil then
                            AddOn.db.profile.upgradeTrack.customColor = val:gsub("#", "")
                            AddOn:HandleEquipmentOrSettingsChange()
                        end
                    end,
                    disabled = function() return not AddOn.db.profile.upgradeTrack.show or not AddOn.db.profile.upgradeTrack.useCustomColor end,
                    hidden = function() return not AddOn.db.profile.upgradeTrack.useCustomColor end
                },
                resetUpgradeTrackCustomColor = {
                    type = "execute",
                    name = L["Reset"],
                    width = "half",
                    order = orderCounter(),
                    func = function()
                        AddOn.db.profile.upgradeTrack.customColor = AddOn.HexColorPresets.Priest
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function()
                        local upgradeTrackShown = AddOn.db.profile.upgradeTrack.show
                        local usingCustomColor = AddOn.db.profile.upgradeTrack.useCustomColor
                        local customColorIsDefault = upgradeTrackShown and usingCustomColor and AddOn.db.profile.upgradeTrack.customColor == AddOn.HexColorPresets.Priest
                        return not upgradeTrackShown or not usingCustomColor or customColorIsDefault
                    end,
                    hidden = function() return not AddOn.db.profile.upgradeTrack.useCustomColor end
                }
            },
            hidden = function() return AddOn:IsTimerunningCharacter() end
        },
        gemOptions = {
            type = "group",
            name = L["Gems"],
            order = orderCounter(),
            args = {
                gemScale = {
                    type = "range",
                    name = L["Icon Scale"],
                    desc = L["Scale gem icon size relative to the default"],
                    order = orderCounter(),
                    min = 0.1,
                    max = 2,
                    step = 0.05,
                    get = function() return AddOn.db.profile.gems.scale end,
                    set = function(_, val)
                        AddOn.db.profile.gems.scale = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.gems.show end
                },
                spacer = AddOn.CreateOptionsSpacer(orderCounter()),
                showMissingGems = {
                    type = "toggle",
                    name = L["Show Missing Gems & Sockets"],
                    desc = L["Show when an item is missing gems or sockets"],
                    width = "full",
                    order = orderCounter(),
                    get = function() return AddOn.db.profile.gems.showMissing end,
                    set = function(_, val)
                        AddOn.db.profile.gems.showMissing = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.gems.show end
                },
                missingGemsMaxLevelOnly = {
                    type = "toggle",
                    name = L["Only Show for Max Level"],
                    desc = L["Hide missing gem & socket info for characters under the level cap"],
                    width = "double",
                    order = orderCounter(),
                    get = function() return AddOn.db.profile.gems.missingMaxLevelOnly end,
                    set = function(_, val)
                        AddOn.db.profile.gems.missingMaxLevelOnly = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.gems.show or (AddOn.db.profile.gems.show and not AddOn.db.profile.gems.showMissing) end
                },
                spacerTwo = AddOn.CreateOptionsSpacer(orderCounter()),
                missingGemsDesc = {
                    type = "description",
                    name = ColorText(L["indicates that a socket can be added to the item"], "Info"),
                    order = orderCounter()
                },
                emptySocketDesc = {
                    type = "description",
                    name = ColorText(L["indicates an empty socket on the item"], "Info"),
                    order = orderCounter()
                }
            },
            hidden = function() return AddOn:IsTimerunningCharacter() end
        },
        enchantOptions = {
            type = "group",
            name = L["Enchants"],
            order = orderCounter(),
            args = {
                enchScale = {
                    type = "range",
                    name = L["Font Scale"],
                    desc = L["Scale enchant text size relative to the default"],
                    order = orderCounter(),
                    min = 0.1,
                    max = 2,
                    step = 0.05,
                    get = function() return AddOn.db.profile.enchants.scale end,
                    set = function(_, val)
                        AddOn.db.profile.enchants.scale = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.enchants.show end
                },
                smallSpacer = AddOn.CreateOptionsSpacer(orderCounter(), 0.25),
                enchantOutline = {
                    type = "select",
                    name = L["Outline"],
                    desc = L["The outline style to add to enchant text"],
                    order = orderCounter(),
                    values = function()
                        local options = {}
                        for _, option in ipairs(AddOn.OutlineOptions) do
                            options[option.value] = option.key
                        end
                        return options
                    end,
                    get = function()
                        if not AddOn.db.profile.enchants.outline then
                            AddOn.db.profile.enchants.outline = "OUTLINE"
                        end

                        return AddOn.db.profile.enchants.outline
                    end,
                    set = function(_, val)
                        AddOn.db.profile.enchants.outline = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.itemLevel.show or AddOn.db.profile.itemLevel.onItem end
                },
                spacer = AddOn.CreateOptionsSpacer(orderCounter()),
                showMissingEnchants = {
                    type = "toggle",
                    name = L["Missing Enchant Indicator"],
                    desc = L["Show when an item is missing an enchant with a warning symbol"],
                    width="full",
                    order = orderCounter(),
                    get = function() return AddOn.db.profile.enchants.showMissing end,
                    set = function(_, val)
                        AddOn.db.profile.enchants.showMissing = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.enchants.show end
                },
                missingEnchantsMaxLevelOnly = {
                    type = "toggle",
                    name = L["Only Show for Max Level"],
                    desc = L["Hide missing enchant info for characters under the level cap"],
                    width = "full",
                    order = orderCounter(),
                    get = function() return AddOn.db.profile.enchants.missingMaxLevelOnly end,
                    set = function(_, val)
                        AddOn.db.profile.enchants.missingMaxLevelOnly = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.enchants.show or (AddOn.db.profile.enchants.show and not AddOn.db.profile.enchants.showMissing) end
                },
                spacerTwo = AddOn.CreateOptionsSpacer(orderCounter()),
                -- Options to toggle enchant button visibility
                showEnchantTextButton = {
                    type = "toggle",
                    name = L["Enchant Text Button"],
                    desc = L["Display a button to show or hide enchant text in the Character Info window"],
                    width = "full",
                    order = orderCounter(),
                    get = function() return AddOn.db.profile.enchants.showTextButton end,
                    set = function(_, val)
                        AddOn.db.profile.enchants.showTextButton = val
                        -- Hide if unchecked, regardless of whether showEnchants is checked or not
                        if not val and AddOn.PGVToggleEnchantButton:IsShown() then
                            AddOn.PGVToggleEnchantButton:Hide()
                        -- Show if checked, showEnchants is checked, and button is not already shown
                        elseif val and AddOn.db.profile.enchants.show and not AddOn.PGVToggleEnchantButton:IsShown() then
                            AddOn.PGVToggleEnchantButton:Show()
                        end
                        AddOn:HandleEquipmentOrSettingsChange()
                    end
                },
                spacerThree = AddOn.CreateOptionsSpacer(orderCounter()),
                enchTextColorOptionsDesc = {
                    type = "description",
                    name = ColorText(L["Enchant quality symbol is not affected by the custom color option"], "Info"),
                    order = orderCounter()
                },
                spacerFour = AddOn.CreateOptionsSpacer(orderCounter()),
                useCustomColorForEnchants = {
                    type = "toggle",
                    name = L["Use Custom Color"],
                    width = "full",
                    desc = L["Customize enchant text color"],
                    order = orderCounter(),
                    get = function() return AddOn.db.profile.enchants.useCustomColor end,
                    set = function(_, val)
                        AddOn.db.profile.enchants.useCustomColor = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.enchants.show end
                },
                customColorDesc = {
                    type = "description",
                    name = "\n"..L["Choose from the color picker or enter the hex code for a specific color."].."\n"..L["Color codes should be entered in the format #RRGGBB"].."\n\n",
                    order = orderCounter(),
                    hidden = function() return not AddOn.db.profile.enchants.useCustomColor end
                },
                enchCustomColor = {
                    type = "color",
                    name = L["Choose a Color"],
                    order = orderCounter(),
                    hasAlpha = false,
                    get = function()
                        if not AddOn.db.profile.enchants.customColor then AddOn.db.profile.enchants.customColor = AddOn.HexColorPresets.Uncommon end
                        local hex = AddOn.db.profile.enchants.customColor
                        return AddOn.ConvertHexToRGB(hex)
                    end,
                    set = function(_, r, g, b)
                        AddOn.db.profile.enchants.customColor = AddOn.ConvertRGBToHex(r, g, b)
                        LibStub("AceConfigRegistry-3.0"):NotifyChange(addonName)
                        LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.enchants.show or not AddOn.db.profile.enchants.useCustomColor end,
                    hidden = function() return not AddOn.db.profile.enchants.useCustomColor end
                },
                customColorHex = {
                    type = "input",
                    name = "",
                    width = 0.65,
                    order = orderCounter(),
                    get = function() return "#"..AddOn.db.profile.enchants.customColor end,
                    set = function(_, val)
                        -- Validate that the provided hex code can be converted to an RGB color before setting
                        local r, g, b = AddOn.ConvertHexToRGB(val:gsub("#", ""))
                        if r ~= nil and g ~= nil and b ~= nil then
                            AddOn.db.profile.enchants.customColor = val:gsub("#", "")
                            AddOn:HandleEquipmentOrSettingsChange()
                        end
                    end,
                    disabled = function() return not AddOn.db.profile.enchants.show or not AddOn.db.profile.enchants.useCustomColor end,
                    hidden = function() return not AddOn.db.profile.enchants.useCustomColor end
                },
                resetCustomColor = {
                    type = "execute",
                    name = L["Reset"],
                    width = "half",
                    order = orderCounter(),
                    func = function()
                        AddOn.db.profile.enchants.customColor = AddOn.HexColorPresets.Uncommon
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function()
                        local enchantsShown = AddOn.db.profile.enchants.show
                        local usingCustomEnchColor = AddOn.db.profile.enchants.useCustomColor
                        local enchCustomColorIsDefault = enchantsShown and usingCustomEnchColor and AddOn.db.profile.enchants.customColor == AddOn.HexColorPresets.Uncommon
                        return not enchantsShown or not usingCustomEnchColor or enchCustomColorIsDefault
                    end,
                    hidden = function() return not AddOn.db.profile.enchants.useCustomColor end
                }
            },
            hidden = function() return AddOn:IsTimerunningCharacter() end
        },
        durabilityOptions = {
            type = "group",
            name = L["Durability"],
            order = orderCounter(),
            args = {
                durUsageDesc = {
                    type = "description",
                    name = ColorText(L["Durability text is always hidden at 100%"], "Info"),
                    order = orderCounter()
                },
                spacer = AddOn.CreateOptionsSpacer(orderCounter()),
                durabilityScale = {
                    type = "range",
                    name = L["Font Scale"],
                    desc = L["Scale durability text size relative to the default"].."\n\n"..L["Does nothing if Show Durability as Bar is enabled"],
                    order = orderCounter(),
                    min = 0.1,
                    max = 2,
                    step = 0.05,
                    get = function() return AddOn.db.profile.durability.scale end,
                    set = function(_, val)
                        AddOn.db.profile.durability.scale = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.durability.show end
                },
                spacerThree = AddOn.CreateOptionsSpacer(orderCounter()),
                durabilityColorChart = {
                    type = "description",
                    name = L["High: above 50%"].." | "..L["Medium: 25% - 50%"].." | "..L["Low: 25% or less"],
                    order = orderCounter()
                },
                spacerFour = AddOn.CreateOptionsSpacer(orderCounter()),
                durabilityColorHigh = {
                    type = "color",
                    name = L["High"],
                    order = orderCounter(),
                    hasAlpha = false,
                    get = function()
                        local hex = AddOn.db.profile.durability.colorHigh or "1EFF00"
                        return AddOn.ConvertHexToRGB(hex)
                    end,
                    set = function(_, r, g, b)
                        AddOn.db.profile.durability.colorHigh = AddOn.ConvertRGBToHex(r, g, b)
                        C_Timer.After(0, function()
                            LibStub("AceConfigRegistry-3.0"):NotifyChange(addonName)
                            LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
                        end)
                        AddOn:HandleEquipmentOrSettingsChange()
                    end
                },
                durabilityColorHighHex = {
                    type = "input",
                    name = "",
                    width = 0.65,
                    order = orderCounter(),
                    get = function()
                        if not AddOn.db.profile.durability.colorHigh then
                            AddOn.db.profile.durability.colorHigh = AddOn.HexColorPresets.Uncommon
                        end
                        return "#"..AddOn.db.profile.durability.colorHigh
                    end,
                    set = function(_, val)
                        -- Validate that the provided hex code can be converted to an RGB color before setting
                        local r, g, b = AddOn.ConvertHexToRGB(val:gsub("#", ""))
                        if r ~= nil and g ~= nil and b ~= nil then
                            AddOn.db.profile.durability.colorHigh = val:gsub("#", "")
                            AddOn:HandleEquipmentOrSettingsChange()
                        end
                    end
                },
                resetDurabilityColorHigh = {
                    type = "execute",
                    name = L["Reset"],
                    width = "half",
                    order = orderCounter(),
                    func = function()
                        AddOn.db.profile.durability.colorHigh = AddOn.HexColorPresets.Uncommon
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function()
                        return AddOn.db.profile.durability.colorHigh == AddOn.HexColorPresets.Uncommon
                    end
                },
                durabilityColorMedium = {
                    type = "color",
                    name = L["Medium"],
                    order = orderCounter(),
                    hasAlpha = false,
                    get = function()
                        local hex = AddOn.db.profile.durability.colorMedium or "FFD100"
                        return AddOn.ConvertHexToRGB(hex)
                    end,
                    set = function(_, r, g, b)
                        AddOn.db.profile.durability.colorMedium = AddOn.ConvertRGBToHex(r, g, b)
                        C_Timer.After(0, function()
                            LibStub("AceConfigRegistry-3.0"):NotifyChange(addonName)
                            LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
                        end)
                        AddOn:HandleEquipmentOrSettingsChange()
                    end
                },
                durabilityColorMediumHex = {
                    type = "input",
                    name = "",
                    width = 0.65,
                    order = orderCounter(),
                    get = function()
                        if not AddOn.db.profile.durability.colorMedium then
                            AddOn.db.profile.durability.colorMedium = AddOn.HexColorPresets.Info
                        end
                        return "#"..AddOn.db.profile.durability.colorMedium
                    end,
                    set = function(_, val)
                        -- Validate that the provided hex code can be converted to an RGB color before setting
                        local r, g, b = AddOn.ConvertHexToRGB(val:gsub("#", ""))
                        if r ~= nil and g ~= nil and b ~= nil then
                            AddOn.db.profile.durability.colorMedium = val:gsub("#", "")
                            AddOn:HandleEquipmentOrSettingsChange()
                        end
                    end
                },
                resetDurabilityColorMedium = {
                    type = "execute",
                    name = L["Reset"],
                    width = "half",
                    order = orderCounter(),
                    func = function()
                        AddOn.db.profile.durability.colorMedium = AddOn.HexColorPresets.Info
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function()
                        return AddOn.db.profile.durability.colorMedium == AddOn.HexColorPresets.Info
                    end
                },
                durabilityColorLow = {
                    type = "color",
                    name = L["Low"],
                    order = orderCounter(),
                    hasAlpha = false,
                    get = function()
                        local hex = AddOn.db.profile.durability.colorLow or "FF3300"
                        return AddOn.ConvertHexToRGB(hex)
                    end,
                    set = function(_, r, g, b)
                        AddOn.db.profile.durability.colorLow = AddOn.ConvertRGBToHex(r, g, b)
                        C_Timer.After(0, function()
                            LibStub("AceConfigRegistry-3.0"):NotifyChange(addonName)
                            LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
                        end)
                        AddOn:HandleEquipmentOrSettingsChange()
                    end
                },
                durabilityColorLowHex = {
                    type = "input",
                    name = "",
                    width = 0.65,
                    order = orderCounter(),
                    get = function()
                        if not AddOn.db.profile.durability.colorLow then
                            AddOn.db.profile.durability.colorLow = AddOn.HexColorPresets.Error
                        end
                        return "#"..AddOn.db.profile.durability.colorLow
                    end,
                    set = function(_, val)
                        -- Validate that the provided hex code can be converted to an RGB color before setting
                        local r, g, b = AddOn.ConvertHexToRGB(val:gsub("#", ""))
                        if r ~= nil and g ~= nil and b ~= nil then
                            AddOn.db.profile.durability.colorLow = val:gsub("#", "")
                            AddOn:HandleEquipmentOrSettingsChange()
                        end
                    end
                },
                resetDurabilityColorLow = {
                    type = "execute",
                    name = L["Reset"],
                    width = "half",
                    order = orderCounter(),
                    func = function()
                        AddOn.db.profile.durability.colorLow = AddOn.HexColorPresets.Error
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function()
                        return AddOn.db.profile.durability.colorLow == AddOn.HexColorPresets.Error
                    end
                },
                spacerFive = AddOn.CreateOptionsSpacer(orderCounter()),
                resetAllDurabilityColors = {
                    type = "execute",
                    name = L["Reset All"],
                    order = orderCounter(),
                    func = function()
                        AddOn.db.profile.durability.colorHigh = AddOn.HexColorPresets.Uncommon
                        AddOn.db.profile.durability.colorMedium = AddOn.HexColorPresets.Info
                        AddOn.db.profile.durability.colorLow = AddOn.HexColorPresets.Error
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function()
                        return AddOn.db.profile.durability.colorLow == AddOn.HexColorPresets.Error and AddOn.db.profile.durability.colorMedium == AddOn.HexColorPresets.Info and AddOn.db.profile.durability.colorHigh == AddOn.HexColorPresets.Uncommon
                    end
                },
                spacerTwo = AddOn.CreateOptionsSpacer(orderCounter()),
                showDurabilityAsBar = {
                    type = "toggle",
                    name = L["Show Durability as Bar"],
                    desc = L["Display durability as a bar instead of text over gear icons"],
                    width = "full",
                    order = orderCounter(),
                    get = function() return AddOn.db.profile.durability.showAsBar end,
                    set = function(_, val)
                        AddOn.db.profile.durability.showAsBar = val
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.durability.show end
                }
            }
        },
        inspectOptions = {
            type = "group",
            name = L["Inspect Window"],
            order = orderCounter(),
            args = {
                showOnInspect = {
                    type = "toggle",
                    name = L["Show Gear Info on Inspect"],
                    desc = L["Displays information about equipped gear when inspecting another player"],
                    order = orderCounter(),
                    width = "full",
                    get = function() return AddOn.db.profile.inspect.show end,
                    set = function(_, val)
                        AddOn.db.profile.inspect.show = val
                    end
                },
                spacer = AddOn.CreateOptionsSpacer(orderCounter()),
                inspectDescription = {
                    type = "description",
                    name = ColorText(L["Choose which information should be displayed when inspecting another player."].." "..L["Colors, size, and other display settings when inspecting a character will follow the same settings as the Character Info window."], "Info"),
                    order = orderCounter()
                },
                spacerTwo = AddOn.CreateOptionsSpacer(orderCounter()),
                showInspectAvgILvl = {
                    type = "toggle",
                    name = L["Average Item Level"],
                    desc = L["Display average item level in the character's class color"],
                    order = orderCounter(),
                    get = function() return AddOn.db.profile.inspect.showAvgILvl end,
                    set = function(_, val)
                        AddOn.db.profile.inspect.showAvgILvl = val
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.inspect.show end
                },
                includeAvgLabel = {
                    type = "toggle",
                    name = L["Include \"Avg\" Label"],
                    desc = L["Adds the text \"Avg: \" before the average item level."].."\n\n"..L["This can help easily identify the average item level when there is a lot of information shown in the Inspect window."],
                    order = orderCounter(),
                    get = function() return AddOn.db.profile.inspect.includeAvgLabel end,
                    set = function(_, val)
                        AddOn.db.profile.inspect.includeAvgLabel = val
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.inspect.show or not AddOn.db.profile.inspect.showAvgILvl end
                },
                showInspectiLvl = {
                    type = "toggle",
                    name = L["Item Level"],
                    desc = L["Display item levels for equipped items"],
                    order = orderCounter(),
                    get = function() return AddOn.db.profile.inspect.showILvl end,
                    set = function(_, val)
                        AddOn.db.profile.inspect.showILvl = val
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.inspect.show end
                },
                showInspectUpgradeTrack = {
                    type = "toggle",
                    name = L["Upgrade Track"],
                    desc = L["Display upgrade track and progress for equipped items"],
                    order = orderCounter(),
                    get = function() return AddOn.db.profile.inspect.showUpgradeTrack end,
                    set = function(_, val)
                        AddOn.db.profile.inspect.showUpgradeTrack = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.inspect.show end,
                    hidden = function() return AddOn:IsTimerunningCharacter() end
                },
                showInspectGems = {
                    type = "toggle",
                    name = L["Gems"],
                    desc = L["Display gem and socket information for equipped items"],
                    order = orderCounter(),
                    get = function() return AddOn.db.profile.inspect.showGems end,
                    set = function(_, val)
                        AddOn.db.profile.inspect.showGems = val
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.inspect.show end,
                    hidden = function() return AddOn:IsTimerunningCharacter() end
                },
                showInspectEnchants = {
                    type = "toggle",
                    name = L["Enchants"],
                    desc = L["Display enchant information for equipped items"].."\n\n".."Enchant text is always shown when inspecting another player",
                    order = orderCounter(),
                    get = function() return AddOn.db.profile.inspect.showEnchants end,
                    set = function(_, val)
                        AddOn.db.profile.inspect.showEnchants = val
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.inspect.show end,
                    hidden = function() return AddOn:IsTimerunningCharacter() end
                },
                showInspectEmbellishments = {
                    type = "toggle",
                    name = L["Embellishments"],
                    width = "full",
                    desc = L["Show a green star in the top-left corner of embellished equipment"],
                    order = orderCounter(),
                    get = function() return AddOn.db.profile.inspect.showEmbellishments end,
                    set = function(_, val)
                        AddOn.db.profile.inspect.showEmbellishments = val
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.inspect.show end,
                    hidden = function() return AddOn:IsTimerunningCharacter() end
                },
            }
        },
        characterStatOptions = {
            type = "group",
            name = L["Character Stats"],
            order = orderCounter(),
            args = {
                showDecimalsForStats = {
                    type = "toggle",
                    name = L["Show Decimals for Stats"],
                    width = "full",
                    desc = L["Show your character's stats with decimal places"],
                    order = orderCounter(),
                    get = function() return AddOn.db.profile.characterStats.showDecimals end,
                    set = function(_, val)
                        AddOn.db.profile.characterStats.showDecimals = val
                        AddOn:ShowDecimalStatValues()
                        AddOn:HandleEquipmentOrSettingsChange()
                    end
                },
                decimalPlacesForStats = {
                    type = "range",
                    name = L["Decimal Precision"],
                    desc = L["Number of decimal places to show for character's stats"],
                    order = orderCounter(),
                    min = 1,
                    max = 3,
                    step = 1,
                    get = function() return AddOn.db.profile.characterStats.decimalPlaces end,
                    set = function(_, val)
                        AddOn.db.profile.characterStats.decimalPlaces = val
                        AddOn:ShowDecimalStatValues()
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.characterStats.showDecimals end,
                    hidden = function() return not AddOn.db.profile.characterStats.showDecimals end
                },
                spacer = AddOn.CreateOptionsSpacer(orderCounter()),
                statUsageDesc = {
                    type = "description",
                    name = ColorText(L["Customize secondary & tertiary stat order in the Character Info window by specialization"], "Info"),
                    order = orderCounter(),
                },
                spacerTwo = AddOn.CreateOptionsSpacer(orderCounter()),
                specSelect = {
                    type = "select",
                    name = L["Specialization"],
                    order = orderCounter(),
                    values = function()
                        local options = {}
                        local specID = AddOn:GetCharacterCurrentSpecIDAndRole()
                        if not AddOn.SpecOptionKeys[specID] then
                            options[0] = ""
                        end
                        for id, specKey in pairs(AddOn.SpecOptionKeys) do
                            local classFile = select(6, GetSpecializationInfoByID(id))
                            options[id] = "|A:classicon-"..classFile..":15:15|a "..specKey
                        end
                        return options
                    end,
                    get = function()
                        if AddOn.db.profile.characterStats.lastSelectedSpecID then
                            return AddOn.db.profile.characterStats.lastSelectedSpecID
                        end

                        local specID = AddOn:GetCharacterCurrentSpecIDAndRole()
                        if AddOn.SpecOptionKeys[specID] then
                            return specID
                        else
                            return 0
                        end
                    end,
                    set = function(_, val)
                        AddOn.db.profile.characterStats.lastSelectedSpecID = val
                        AddOn:InitializeCustomSpecStatOrderDB(val)
                    end
                },
                resetButtonSpacer = {
                    type = "description",
                    name = " ",
                    order = orderCounter(),
                    width = "half"
                },
                resetOrderButton = {
                    type = "execute",
                    name = L["Reset"],
                    width = "half",
                    order = orderCounter(),
                    func = function()
                        local specID = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        AddOn:InitializeCustomSpecStatOrderDB(specID, true)
                    end,
                    disabled = function()
                        local specID = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        if AddOn.db.profile.characterStats.customSpecStatOrders[specID] == nil then AddOn:InitializeCustomSpecStatOrderDB(specID, true) end
                        local dbStatOrder = AddOn.db.profile.characterStats.customSpecStatOrders[specID]
                        for stat, order in pairs(dbStatOrder) do
                            local isTankStat = stat == "Dodge" or stat == "Parry" or stat == "Block"
                            local defaultStatUnordered = not isTankStat and order ~= AddOn.DefaultStatOrder[stat]
                            local tankStatUnordered = isTankStat and order ~= AddOn.DefaultTankStatOrder[stat]
                            if defaultStatUnordered or tankStatUnordered then
                                DebugPrint("ResetOrderButtonDisabled:",
                                    ColorText(stat.." is unordered!", "Legendary"),
                                    "Expected order:",
                                    ColorText(AddOn.DefaultStatOrder[stat] or AddOn.DefaultTankStatOrder[stat] or "unknown", "Uncommon"),
                                    "and actual order:",
                                    ColorText(order, "DeathKnight")
                                )
                                return false
                            end
                        end
                        return true
                    end
                },
                postSpecSelectSpacer = AddOn.CreateOptionsSpacer(orderCounter()),
                secondaryStatsHeader = {
                    type = "header",
                    name = L["Secondary Stats"],
                    order = orderCounter()
                },
                critStrikeLabel = {
                    type = "description",
                    name = ColorText(STAT_CRITICAL_STRIKE, "Info"),
                    order = orderCounter(),
                    width = "half"
                },
                ["Critical Strike"] = {
                    type = "select",
                    name = "",
                    order = orderCounter(),
                    width = 0.33,
                    values = function() return AddOn:GetStatOrderValuesHandler() end,
                    get = function(item) return AddOn:GetStatOrderHandler(item) end,
                    set = function(item, val)
                        AddOn:SetStatOrderHandler(item, val)
                        AddOn:HandleEquipmentOrSettingsChange()
                        end
                },
                postCritSpacer = AddOn.CreateOptionsSpacer(orderCounter()),
                hasteLabel = {
                    type = "description",
                    name = ColorText(STAT_HASTE, "Info"),
                    order = orderCounter(),
                    width = "half"
                },
                ["Haste"] = {
                    type = "select",
                    name = "",
                    order = orderCounter(),
                    width = 0.33,
                    values = function() return AddOn:GetStatOrderValuesHandler() end,
                    get = function(item) return AddOn:GetStatOrderHandler(item) end,
                    set = function(item, val)
                        AddOn:SetStatOrderHandler(item, val)
                        AddOn:HandleEquipmentOrSettingsChange()
                        end
                },
                postHasteSpacer = AddOn.CreateOptionsSpacer(orderCounter()),
                masteryLabel = {
                    type = "description",
                    name = ColorText(STAT_MASTERY, "Info"),
                    order = orderCounter(),
                    width = "half"
                },
                ["Mastery"] = {
                    type = "select",
                    name = "",
                    order = orderCounter(),
                    width = 0.33,
                    values = function() return AddOn:GetStatOrderValuesHandler() end,
                    get = function(item) return AddOn:GetStatOrderHandler(item) end,
                    set = function(item, val)
                        AddOn:SetStatOrderHandler(item, val)
                        AddOn:HandleEquipmentOrSettingsChange()
                        end
                },
                postMastSpacer = AddOn.CreateOptionsSpacer(orderCounter()),
                versLabel = {
                    type = "description",
                    name = ColorText(STAT_VERSATILITY, "Info"),
                    order = orderCounter(),
                    width = "half"
                },
                ["Versatility"] = {
                    type = "select",
                    name = "",
                    order = orderCounter(),
                    width = 0.33,
                    values = function() return AddOn:GetStatOrderValuesHandler() end,
                    get = function(item) return AddOn:GetStatOrderHandler(item) end,
                    set = function(item, val)
                        AddOn:SetStatOrderHandler(item, val)
                        AddOn:HandleEquipmentOrSettingsChange()
                        end
                },
                tertiaryStatsHeader = {
                    type = "header",
                    name = L["Tertiary Stats"],
                    order = orderCounter()
                },
                leechLabel = {
                    type = "description",
                    name = ColorText(STAT_LIFESTEAL, "Info"),
                    order = orderCounter(),
                    width = "half"
                },
                ["Leech"] = {
                    type = "select",
                    name = "",
                    order = orderCounter(),
                    width = 0.33,
                    values = function() return AddOn:GetStatOrderValuesHandler() end,
                    get = function(item) return AddOn:GetStatOrderHandler(item) end,
                    set = function(item, val)
                        AddOn:SetStatOrderHandler(item, val)
                        AddOn:HandleEquipmentOrSettingsChange()
                        end
                },
                postLeechSpacer = AddOn.CreateOptionsSpacer(orderCounter()),
                avoidLabel = {
                    type = "description",
                    name = ColorText(STAT_AVOIDANCE, "Info"),
                    order = orderCounter(),
                    width = "half"
                },
                ["Avoidance"] = {
                    type = "select",
                    name = "",
                    order = orderCounter(),
                    width = 0.33,
                    values = function() return AddOn:GetStatOrderValuesHandler() end,
                    get = function(item) return AddOn:GetStatOrderHandler(item) end,
                    set = function(item, val)
                        AddOn:SetStatOrderHandler(item, val)
                        AddOn:HandleEquipmentOrSettingsChange()
                        end
                },
                postAvoidSpacer = AddOn.CreateOptionsSpacer(orderCounter()),
                speedLabel = {
                    type = "description",
                    name = ColorText(STAT_SPEED, "Info"),
                    order = orderCounter(),
                    width = "half"
                },
                ["Speed"] = {
                    type = "select",
                    name = "",
                    order = orderCounter(),
                    width = 0.33,
                    values = function() return AddOn:GetStatOrderValuesHandler() end,
                    get = function(item) return AddOn:GetStatOrderHandler(item) end,
                    set = function(item, val)
                        AddOn:SetStatOrderHandler(item, val)
                        AddOn:HandleEquipmentOrSettingsChange()
                        end
                },
                tankOnlyHeader = {
                    type = "header",
                    name = L["Tank Stats"],
                    order = orderCounter(),
                    hidden = function()
                        local _, role = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return role ~= "TANK"
                    end
                },
                dodgeLabel = {
                    type = "description",
                    name = ColorText(STAT_DODGE, "Info"),
                    order = orderCounter(),
                    width = "half",
                    hidden = function()
                        local _, role = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return role ~= "TANK"
                    end
                },
                ["Dodge"] = {
                    type = "select",
                    name = "",
                    order = orderCounter(),
                    width = 0.33,
                    values = function() return AddOn:GetStatOrderValuesHandler() end,
                    get = function(item) return AddOn:GetStatOrderHandler(item) end,
                    set = function(item, val)
                        AddOn:SetStatOrderHandler(item, val)
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    hidden = function()
                        local _, role = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return role ~= "TANK"
                    end
                },
                postDodgeSpacer = {
                    type = "description",
                    name = " ",
                    order = orderCounter(),
                    hidden = function()
                        local _, role = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return role ~= "TANK"
                    end
                },
                parryLabel = {
                    type = "description",
                    name = ColorText(STAT_PARRY, "Info"),
                    order = orderCounter(),
                    width = "half",
                    hidden = function()
                        local _, role = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return role ~= "TANK"
                    end
                },
                ["Parry"] = {
                    type = "select",
                    name = "",
                    order = orderCounter(),
                    width = 0.33,
                    values = function() return AddOn:GetStatOrderValuesHandler() end,
                    get = function(item) return AddOn:GetStatOrderHandler(item) end,
                    set = function(item, val)
                        AddOn:SetStatOrderHandler(item, val)
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    hidden = function()
                        local _, role = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return role ~= "TANK"
                    end
                },
                postParrySpacer = {
                    type = "description",
                    name = " ",
                    order = orderCounter(),
                    hidden = function()
                        local _, role = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return role ~= "TANK"
                    end
                },
                blockLabel = {
                    type = "description",
                    name = ColorText(STAT_BLOCK, "Info"),
                    order = orderCounter(),
                    width = "half",
                    hidden = function()
                        local _, role = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return role ~= "TANK"
                    end
                },
                ["Block"] = {
                    type = "select",
                    name = "",
                    order = orderCounter(),
                    width = 0.33,
                    values = function() return AddOn:GetStatOrderValuesHandler() end,
                    get = function(item) return AddOn:GetStatOrderHandler(item) end,
                    set = function(item, val)
                        AddOn:SetStatOrderHandler(item, val)
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    hidden = function()
                        local _, role = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return role ~= "TANK"
                    end
                },
            }
        },
        otherOptions = {
            type = "group",
            name = L["Other Options"],
            order = orderCounter(),
            args = {
                showMinimap = {
                    type = "toggle",
                    name = L["Show Minimap Icon"],
                    width = "full",
                    desc = L["Show an icon on the minimap to open the AddOn settings"],
                    order = orderCounter(),
                    get = function() return not AddOn.db.profile.general.minimap.hide end,
                    set = function(_, val)
                        AddOn.db.profile.general.minimap.hide = not val
                        if val then
                            LDBIcon:Show(addonName)
                        else
                            LDBIcon:Hide(addonName)
                        end
                    end
                },
                increaseCharacterInfoSize = {
                    type = "toggle",
                    name = L["Larger Character Info Window"],
                    width = "full",
                    desc = L["Increase the size of the Character Info window"].."\n\n"..L["This can help reduce text overlap with the character model and make reading text easier."],
                    order = orderCounter(),
                    get = function() return AddOn.db.profile.general.increaseCharacterInfoSize end,
                    set = function(_, val)
                        AddOn.db.profile.general.increaseCharacterInfoSize = val
                        AddOn:AdjustCharacterInfoWindowSize()
                    end
                },
                showEmbellishments = {
                    type = "toggle",
                    name = L["Show Embellishments"],
                    width = "full",
                    desc = L["Show a green star in the top-left corner of embellished equipment"],
                    order = orderCounter(),
                    get = function() return AddOn.db.profile.general.showEmbellishments end,
                    set = function(_, val)
                        AddOn.db.profile.general.showEmbellishments = val
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                },
                showCharacteriLvlDecimal = {
                    type = "toggle",
                    name = L["Show Decimals for Equipped Item Level"],
                    width = "full",
                    desc = L["Show your character's average equipped item level with decimal places"],
                    order = orderCounter(),
                    get = function() return AddOn.db.profile.general.showCharacteriLvlDecimal end,
                    set = function(_, val)
                        AddOn.db.profile.general.showCharacteriLvlDecimal = val
                        AddOn:HandleEquipmentOrSettingsChange()
                    end
                },
                decimalPlacesForCharacteriLvl = {
                    type = "range",
                    name = L["Decimal Precision"],
                    desc = L["Number of decimal places to show for character's equipped item level"],
                    order = orderCounter(),
                    min = 1,
                    max = 3,
                    step = 1,
                    get = function() return AddOn.db.profile.general.decimalPlacesForCharacteriLvl end,
                    set = function(_, val)
                        AddOn.db.profile.general.decimalPlacesForCharacteriLvl = val
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.general.showCharacteriLvlDecimal end,
                    hidden = function() return not AddOn.db.profile.general.showCharacteriLvlDecimal end
                },
                spacer = AddOn.CreateOptionsSpacer(orderCounter()),
                hideShirtTabardInfo = {
                    type = "toggle",
                    name = L["Hide Shirt & Tabard Info"],
                    width = "full",
                    desc = L["Hide information for equipped shirt & tabard"],
                    order = orderCounter(),
                    get = function() return AddOn.db.profile.general.hideShirtTabardInfo end,
                    set = function(_, val)
                        AddOn.db.profile.general.hideShirtTabardInfo = val
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.itemLevel.show and not AddOn.db.profile.gems.show and not AddOn.db.profile.enchants.show end
                },
                debug = {
                    type = "toggle",
                    name = L["Debug Mode"],
                    desc = L["Display debugging messages in the default chat window"].."\n\n"..ColorText(L["You should never need to enable this"], "DeathKnight"),
                    order = orderCounter(),
                    get = function() return AddOn.db.profile.general.debug end,
                    set = function(_, val) AddOn.db.profile.general.debug = val end
                },
            }
        },
        credits = AddOn:BuildCreditsGroup()
    }
}

