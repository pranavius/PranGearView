local addonName, AddOn = ...
---@class PranGearView: AceAddon, AceConsole-3.0, AceEvent-3.0
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)
local LDB = LibStub("LibDataBroker-1.1")
local LDBIcon  = LibStub("LibDBIcon-1.0")

local DebugPrint = AddOn.DebugPrint
local ColorText = AddOn.ColorText

local orderCounter = CreateCounter()
local OptionsTable = {
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
            get = function(item) return AddOn.db.profile[item[#item]] end,
            set = function(item, val)
                AddOn.db.profile[item[#item]] = val
                AddOn:HandleEquipmentOrSettingsChange()
            end
        },
        showUpgradeTrack = {
            type = "toggle",
            name = L["Upgrade Track"],
            desc = L["Display upgrade track and progress for equipped items"],
            order = orderCounter(),
            get = function(item) return AddOn.db.profile[item[#item]] end,
            set = function(item, val)
                AddOn.db.profile[item[#item]] = val
                AddOn:HandleEquipmentOrSettingsChange()
                end,
            hidden = PlayerGetTimerunningSeasonID() ~= nil
        },
        showGems = {
            type = "toggle",
            name = L["Gems"],
            desc = L["Display gem and socket information for equipped items"],
            order = orderCounter(),
            get = function(item) return AddOn.db.profile[item[#item]] end,
            set = function(item, val)
                AddOn.db.profile[item[#item]] = val
                AddOn:HandleEquipmentOrSettingsChange()
            end,
            hidden = PlayerGetTimerunningSeasonID() ~= nil
        },
        showEnchants = {
            type = "toggle",
            name = L["Enchants"],
            desc = L["Display enchant information for equipped items"],
            order = orderCounter(),
            get = function(item) return AddOn.db.profile[item[#item]] end,
            set = function(item, val)
                AddOn.db.profile[item[#item]] = val
                if not val and AddOn.PGVToggleEnchantButton:IsShown() then
                    AddOn.PGVToggleEnchantButton:Hide()
                elseif val and not AddOn.PGVToggleEnchantButton:IsShown() then
                    AddOn.PGVToggleEnchantButton:Show()
                end
                AddOn:HandleEquipmentOrSettingsChange()
            end,
            hidden = PlayerGetTimerunningSeasonID() ~= nil
        },
        showDurability = {
            type = "toggle",
            name = L["Durability"],
            desc = L["Display durability percentages for equipped items"],
            order = orderCounter(),
            get = function(item) return AddOn.db.profile[item[#item]] end,
            set = function(item, val)
                AddOn.db.profile[item[#item]] = val
                AddOn:HandleEquipmentOrSettingsChange()
            end,
            hidden = PlayerGetTimerunningSeasonID() ~= nil
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
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.showiLvl end
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
                    get = function(item)
                        if not AddOn.db.profile[item[#item]] then
                            AddOn.db.profile[item[#item]] = ""
                        end

                        return AddOn.db.profile[item[#item]]
                    end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.showiLvl end
                },
                spacer = AddOn.CreateOptionsSpacer(orderCounter()),
                iLvlOnItem = {
                    type = "toggle",
                    name = L["Alternate Item Level Placement"],
                    width = "full",
                    desc = L["Display item levels on top of equipment icons"],
                    order = orderCounter(),
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.showiLvl end
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
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        if val then
                            AddOn.db.profile.useClassColorForILvl = false
                            AddOn.db.profile.useGradientColorsForILvl = false
                            AddOn.db.profile.useCustomColorForILvl = false
                        end
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.showiLvl end
                },
                useClassColorForILvl = {
                    type = "toggle",
                    name = L["Use Class Color"],
                    desc = L["Color item levels based on the character's class"],
                    order = orderCounter(),
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        if val then
                            AddOn.db.profile.useQualityColorForILvl = false
                            AddOn.db.profile.useGradientColorsForILvl = false
                            AddOn.db.profile.useCustomColorForILvl = false
                        end
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.showiLvl end
                },
                useGradientColorsForILvl = {
                    type = "toggle",
                    name = L["Use Item Level Gradient"],
                    desc = L["Color highest item level in green, lowest item level in red, and the rest in yellow."].."\n\n"..L["This color scheme follows a similar pattern to the Shadow & Light plugin for ElvUI"],
                    order = orderCounter(),
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        if val then
                            AddOn.db.profile.useQualityColorForILvl = false
                            AddOn.db.profile.useClassColorForILvl = false
                            AddOn.db.profile.useCustomColorForILvl = false
                        end
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.showiLvl end
                },
                useCustomColorForILvl = {
                    type = "toggle",
                    name = L["Use Custom Color"],
                    width = "full",
                    desc = L["Customize item level color"],
                    order = orderCounter(),
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        if val then
                            AddOn.db.profile.useQualityColorForILvl = false
                            AddOn.db.profile.useClassColorForILvl = false
                            AddOn.db.profile.useGradientColorsForILvl = false
                        end
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.showiLvl end
                },
                customColorDesc = {
                    type = "description",
                    name = "\n"..L["Choose from the color picker or enter the hex code for a specific color."].."\n"..L["Color codes should be entered in the format #RRGGBB"].."\n\n",
                    order = orderCounter(),
                    hidden = function() return not AddOn.db.profile.useCustomColorForILvl end
                },
                iLvlCustomColor = {
                    type = "color",
                    name = L["Choose a Color"],
                    order = orderCounter(),
                    hasAlpha = false,
                    get = function(item)
                        if not AddOn.db.profile[item[#item]] then AddOn.db.profile[item[#item]] = AddOn.HexColorPresets.Priest end
                        local hex = AddOn.db.profile[item[#item]]
                        return AddOn.ConvertHexToRGB(hex)
                    end,
                    set = function(item, r, g, b)
                        AddOn.db.profile[item[#item]] = AddOn.ConvertRGBToHex(r, g, b)
                        LibStub("AceConfigRegistry-3.0"):NotifyChange(addonName)
                        LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.showiLvl or not AddOn.db.profile.useCustomColorForILvl end,
                    hidden = function() return not AddOn.db.profile.useCustomColorForILvl end
                },
                customColorHex = {
                    type = "input",
                    name = "",
                    width = 0.65,
                    order = orderCounter(),
                    get = function()
                        if not AddOn.db.profile.iLvlCustomColor then
                            AddOn.db.profile.iLvlCustomColor = AddOn.HexColorPresets.Priest
                        end
                        return "#"..AddOn.db.profile.iLvlCustomColor
                    end,
                    set = function(_, val)
                        -- Validate that the provided hex code can be converted to an RGB color before setting
                        local r, g, b = AddOn.ConvertHexToRGB(val:gsub("#", ""))
                        if r ~= nil and g ~= nil and b ~= nil then
                            AddOn.db.profile.iLvlCustomColor = val:gsub("#", "")
                            AddOn:HandleEquipmentOrSettingsChange()
                        end
                    end,
                    disabled = function() return not AddOn.db.profile.showiLvl or not AddOn.db.profile.useCustomColorForILvl end,
                    hidden = function() return not AddOn.db.profile.useCustomColorForILvl end
                },
                resetCustomColor = {
                    type = "execute",
                    name = L["Reset"],
                    width = "half",
                    order = orderCounter(),
                    func = function()
                        AddOn.db.profile.iLvlCustomColor = AddOn.HexColorPresets.Priest
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function()
                        local itemLevelShown = AddOn.db.profile.showiLvl
                        local usingCustomColor = AddOn.db.profile.useCustomColorForILvl
                        local customColorIsDefault = itemLevelShown and usingCustomColor and AddOn.db.profile.iLvlCustomColor == AddOn.HexColorPresets.Priest
                        return not itemLevelShown or not usingCustomColor or customColorIsDefault
                    end,
                    hidden = function() return not AddOn.db.profile.useCustomColorForILvl end
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
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.showUpgradeTrack end
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
                    get = function(item)
                        if not AddOn.db.profile[item[#item]] then
                            AddOn.db.profile[item[#item]] = ""
                        end

                        return AddOn.db.profile[item[#item]]
                    end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.showiLvl or AddOn.db.profile.iLvlOnItem end
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
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        if val then AddOn.db.profile.useCustomColorForUpgradeTrack = false end
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.showUpgradeTrack end
                },
                useCustomColorForUpgradeTrack = {
                    type = "toggle",
                    name = L["Use Custom Color"],
                    width = "full",
                    desc = L["Customize upgrade track color for current season items"],
                    order = orderCounter(),
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        if val then AddOn.db.profile.useQualityScaleColorsForUpgradeTrack = false end
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.showUpgradeTrack end
                },
                customColorDesc = {
                    type = "description",
                    name = "\n"..L["Choose from the color picker or enter the hex code for a specific color."].."\n"..L["Color codes should be entered in the format #RRGGBB"].."\n\n",
                    order = orderCounter(),
                    hidden = function() return not AddOn.db.profile.useCustomColorForUpgradeTrack end
                },
                upgradeTrackCustomColor = {
                    type = "color",
                    name = L["Choose a Color"],
                    order = orderCounter(),
                    hasAlpha = false,
                    get = function(item)
                        if not AddOn.db.profile[item[#item]] then AddOn.db.profile[item[#item]] = AddOn.HexColorPresets.Priest end
                        local hex = AddOn.db.profile[item[#item]]
                        return AddOn.ConvertHexToRGB(hex)
                    end,
                    set = function(item, r, g, b)
                        AddOn.db.profile[item[#item]] = AddOn.ConvertRGBToHex(r, g, b)
                        LibStub("AceConfigRegistry-3.0"):NotifyChange(addonName)
                        LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.showUpgradeTrack or not AddOn.db.profile.useCustomColorForUpgradeTrack end,
                    hidden = function() return not AddOn.db.profile.useCustomColorForUpgradeTrack end
                },
                upgradeTrackCustomColorHex = {
                    type = "input",
                    name = "",
                    width = 0.65,
                    order = orderCounter(),
                    get = function()
                        if not AddOn.db.profile.upgradeTrackCustomColor then
                            AddOn.db.profile.upgradeTrackCustomColor = AddOn.HexColorPresets.Priest
                        end
                        return "#"..AddOn.db.profile.upgradeTrackCustomColor
                    end,
                    set = function(_, val)
                        -- Validate that the provided hex code can be converted to an RGB color before setting
                        local r, g, b = AddOn.ConvertHexToRGB(val:gsub("#", ""))
                        if r ~= nil and g ~= nil and b ~= nil then
                            AddOn.db.profile.upgradeTrackCustomColor = val:gsub("#", "")
                            AddOn:HandleEquipmentOrSettingsChange()
                        end
                    end,
                    disabled = function() return not AddOn.db.profile.showUpgradeTrack or not AddOn.db.profile.useCustomColorForILvl end,
                    hidden = function() return not AddOn.db.profile.useCustomColorForUpgradeTrack end
                },
                resetUpgradeTrackCustomColor = {
                    type = "execute",
                    name = L["Reset"],
                    width = "half",
                    order = orderCounter(),
                    func = function()
                        AddOn.db.profile.upgradeTrackCustomColor = AddOn.HexColorPresets.Priest
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function()
                        local upgradeTrackShown = AddOn.db.profile.showUpgradeTrack
                        local usingCustomColor = AddOn.db.profile.useCustomColorForUpgradeTrack
                        local customColorIsDefault = upgradeTrackShown and usingCustomColor and AddOn.db.profile.upgradeTrackCustomColor == AddOn.HexColorPresets.Priest
                        return not upgradeTrackShown or not usingCustomColor or customColorIsDefault
                    end,
                    hidden = function() return not AddOn.db.profile.useCustomColorForUpgradeTrack end
                }
            },
            hidden = PlayerGetTimerunningSeasonID() ~= nil
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
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.showGems end
                },
                spacer = AddOn.CreateOptionsSpacer(orderCounter()),
                showMissingGems = {
                    type = "toggle",
                    name = L["Show Missing Gems & Sockets"],
                    desc = L["Show when an item is missing gems or sockets"],
                    width = "full",
                    order = orderCounter(),
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.showGems end
                },
                missingGemsMaxLevelOnly = {
                    type = "toggle",
                    name = L["Only Show for Max Level"],
                    desc = L["Hide missing gem & socket info for characters under the level cap"],
                    width = "double",
                    order = orderCounter(),
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.showGems or (AddOn.db.profile.showGems and not AddOn.db.profile.showMissingGems) end
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
            hidden = PlayerGetTimerunningSeasonID() ~= nil
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
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.showEnchants end
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
                    get = function(item)
                        if not AddOn.db.profile[item[#item]] then
                            AddOn.db.profile[item[#item]] = "OUTLINE"
                        end

                        return AddOn.db.profile[item[#item]]
                    end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.showiLvl or AddOn.db.profile.iLvlOnItem end
                },
                spacer = AddOn.CreateOptionsSpacer(orderCounter()),
                showMissingEnchants = {
                    type = "toggle",
                    name = L["Missing Enchant Indicator"],
                    desc = L["Show when an item is missing an enchant with a warning symbol"],
                    order = orderCounter(),
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.showEnchants end
                },
                missingEnchantsMaxLevelOnly = {
                    type = "toggle",
                    name = L["Only Show for Max Level"],
                    desc = L["Hide missing enchant info for characters under the level cap"],
                    width = "full",
                    order = orderCounter(),
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.showEnchants or (AddOn.db.profile.showEnchants and not AddOn.db.profile.showMissingEnchants) end
                },
                spacerTwo = AddOn.CreateOptionsSpacer(orderCounter()),
                -- Options to toggle enchant button visibility
                showEnchantTextButton = {
                    type = "toggle",
                    name = L["Enchant Text Button"],
                    desc = L["Display a button to show or hide enchant text in the Character Info window"],
                    width = "full",
                    order = orderCounter(),
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        -- Hide if unchecked, regardless of whether showEnchants is checked or not
                        if not val and AddOn.PGVToggleEnchantButton:IsShown() then
                            AddOn.PGVToggleEnchantButton:Hide()
                        -- Show if checked, showEnchants is checked, and button is not already shown
                        elseif val and AddOn.db.profile.showEnchants and not AddOn.PGVToggleEnchantButton:IsShown() then
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
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.showEnchants end
                },
                customColorDesc = {
                    type = "description",
                    name = "\n"..L["Choose from the color picker or enter the hex code for a specific color."].."\n"..L["Color codes should be entered in the format #RRGGBB"].."\n\n",
                    order = orderCounter(),
                    hidden = function() return not AddOn.db.profile.useCustomColorForEnchants end
                },
                enchCustomColor = {
                    type = "color",
                    name = L["Choose a Color"],
                    order = orderCounter(),
                    hasAlpha = false,
                    get = function(item)
                        if not AddOn.db.profile[item[#item]] then AddOn.db.profile[item[#item]] = AddOn.HexColorPresets.Uncommon end
                        local hex = AddOn.db.profile[item[#item]]
                        return AddOn.ConvertHexToRGB(hex)
                    end,
                    set = function(item, r, g, b)
                        AddOn.db.profile[item[#item]] = AddOn.ConvertRGBToHex(r, g, b)
                        LibStub("AceConfigRegistry-3.0"):NotifyChange(addonName)
                        LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.showEnchants or not AddOn.db.profile.useCustomColorForEnchants end,
                    hidden = function() return not AddOn.db.profile.useCustomColorForEnchants end
                },
                customColorHex = {
                    type = "input",
                    name = "",
                    width = 0.65,
                    order = orderCounter(),
                    get = function() return "#"..AddOn.db.profile.enchCustomColor end,
                    set = function(_, val)
                        -- Validate that the provided hex code can be converted to an RGB color before setting
                        local r, g, b = AddOn.ConvertHexToRGB(val:gsub("#", ""))
                        if r ~= nil and g ~= nil and b ~= nil then
                            AddOn.db.profile.enchCustomColor = val:gsub("#", "")
                            AddOn:HandleEquipmentOrSettingsChange()
                        end
                    end,
                    disabled = function() return not AddOn.db.profile.showEnchants or not AddOn.db.profile.useCustomColorForEnchants end,
                    hidden = function() return not AddOn.db.profile.useCustomColorForEnchants end
                },
                resetCustomColor = {
                    type = "execute",
                    name = L["Reset"],
                    width = "half",
                    order = orderCounter(),
                    func = function()
                        AddOn.db.profile.enchCustomColor = AddOn.HexColorPresets.Uncommon
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function()
                        local enchantsShown = AddOn.db.profile.showEnchants
                        local usingCustomEnchColor = AddOn.db.profile.useCustomColorForEnchants
                        local enchCustomColorIsDefault = enchantsShown and usingCustomEnchColor and AddOn.db.profile.enchCustomColor == AddOn.HexColorPresets.Uncommon
                        return not enchantsShown or not usingCustomEnchColor or enchCustomColorIsDefault
                    end,
                    hidden = function() return not AddOn.db.profile.useCustomColorForEnchants end
                }
            },
            hidden = PlayerGetTimerunningSeasonID() ~= nil
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
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.showDurability end
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
                    get = function(item)
                        local hex = AddOn.db.profile[item[#item]] or "1EFF00"
                        return AddOn.ConvertHexToRGB(hex)
                    end,
                    set = function(item, r, g, b)
                        AddOn.db.profile[item[#item]] = AddOn.ConvertRGBToHex(r, g, b)
                        LibStub("AceConfigRegistry-3.0"):NotifyChange(addonName)
                        LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
                        AddOn:HandleEquipmentOrSettingsChange()
                    end
                },
                durabilityColorHighHex = {
                    type = "input",
                    name = "",
                    width = 0.65,
                    order = orderCounter(),
                    get = function()
                        if not AddOn.db.profile.durabilityColorHigh then
                            AddOn.db.profile.durabilityColorHigh = AddOn.HexColorPresets.Uncommon
                        end
                        return "#"..AddOn.db.profile.durabilityColorHigh
                    end,
                    set = function(_, val)
                        -- Validate that the provided hex code can be converted to an RGB color before setting
                        local r, g, b = AddOn.ConvertHexToRGB(val:gsub("#", ""))
                        if r ~= nil and g ~= nil and b ~= nil then
                            AddOn.db.profile.durabilityColorHigh = val:gsub("#", "")
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
                        AddOn.db.profile.durabilityColorHigh = AddOn.HexColorPresets.Uncommon
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function()
                        return AddOn.db.profile.durabilityColorHigh == AddOn.HexColorPresets.Uncommon
                    end
                },
                durabilityColorMedium = {
                    type = "color",
                    name = L["Medium"],
                    order = orderCounter(),
                    hasAlpha = false,
                    get = function(item)
                        local hex = AddOn.db.profile[item[#item]] or "FFD100"
                        return AddOn.ConvertHexToRGB(hex)
                    end,
                    set = function(item, r, g, b)
                        AddOn.db.profile[item[#item]] = AddOn.ConvertRGBToHex(r, g, b)
                        LibStub("AceConfigRegistry-3.0"):NotifyChange(addonName)
                        LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
                        AddOn:HandleEquipmentOrSettingsChange()
                    end
                },
                durabilityColorMediumHex = {
                    type = "input",
                    name = "",
                    width = 0.65,
                    order = orderCounter(),
                    get = function()
                        if not AddOn.db.profile.durabilityColorMedium then
                            AddOn.db.profile.durabilityColorMedium = AddOn.HexColorPresets.Info
                        end
                        return "#"..AddOn.db.profile.durabilityColorMedium
                    end,
                    set = function(_, val)
                        -- Validate that the provided hex code can be converted to an RGB color before setting
                        local r, g, b = AddOn.ConvertHexToRGB(val:gsub("#", ""))
                        if r ~= nil and g ~= nil and b ~= nil then
                            AddOn.db.profile.durabilityColorMedium = val:gsub("#", "")
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
                        AddOn.db.profile.durabilityColorMedium = AddOn.HexColorPresets.Info
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function()
                        return AddOn.db.profile.durabilityColorMedium == AddOn.HexColorPresets.Info
                    end
                },
                durabilityColorLow = {
                    type = "color",
                    name = L["Low"],
                    order = orderCounter(),
                    hasAlpha = false,
                    get = function(item)
                        local hex = AddOn.db.profile[item[#item]] or "FF3300"
                        return AddOn.ConvertHexToRGB(hex)
                    end,
                    set = function(item, r, g, b)
                        AddOn.db.profile[item[#item]] = AddOn.ConvertRGBToHex(r, g, b)
                        LibStub("AceConfigRegistry-3.0"):NotifyChange(addonName)
                        LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
                        AddOn:HandleEquipmentOrSettingsChange()
                    end
                },
                durabilityColorLowHex = {
                    type = "input",
                    name = "",
                    width = 0.65,
                    order = orderCounter(),
                    get = function()
                        if not AddOn.db.profile.durabilityColorLow then
                            AddOn.db.profile.durabilityColorLow = AddOn.HexColorPresets.Error
                        end
                        return "#"..AddOn.db.profile.durabilityColorLow
                    end,
                    set = function(_, val)
                        -- Validate that the provided hex code can be converted to an RGB color before setting
                        local r, g, b = AddOn.ConvertHexToRGB(val:gsub("#", ""))
                        if r ~= nil and g ~= nil and b ~= nil then
                            AddOn.db.profile.durabilityColorLow = val:gsub("#", "")
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
                        AddOn.db.profile.durabilityColorLow = AddOn.HexColorPresets.Error
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function()
                        return AddOn.db.profile.durabilityColorLow == AddOn.HexColorPresets.Error
                    end
                },
                spacerFive = AddOn.CreateOptionsSpacer(orderCounter()),
                resetAllDurabilityColors = {
                    type = "execute",
                    name = L["Reset All"],
                    order = orderCounter(),
                    func = function()
                        AddOn.db.profile.durabilityColorHigh = AddOn.HexColorPresets.Uncommon
                        AddOn.db.profile.durabilityColorMedium = AddOn.HexColorPresets.Info
                        AddOn.db.profile.durabilityColorLow = AddOn.HexColorPresets.Error
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function()
                        return AddOn.db.profile.durabilityColorLow == AddOn.HexColorPresets.Error and AddOn.db.profile.durabilityColorMedium == AddOn.HexColorPresets.Info and AddOn.db.profile.durabilityColorHigh == AddOn.HexColorPresets.Uncommon
                    end
                },
                spacerTwo = AddOn.CreateOptionsSpacer(orderCounter()),
                showDurabilityAsBar = {
                    type = "toggle",
                    name = L["Show Durability as Bar"],
                    desc = L["Display durability as a bar instead of text over gear icons"],
                    width = "full",
                    order = orderCounter(),
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.showDurability end
                }
            },
            hidden = PlayerGetTimerunningSeasonID() ~= nil
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
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
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
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.showOnInspect end
                },
                includeAvgLabel = {
                    type = "toggle",
                    name = L["Include \"Avg\" Label"],
                    desc = L["Adds the text \"Avg: \" before the average item level."].."\n\n"..L["This can help easily identify the average item level when there is a lot of information shown in the Inspect window."],
                    order = orderCounter(),
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.showOnInspect or not AddOn.db.profile.showInspectAvgILvl end
                },
                showInspectiLvl = {
                    type = "toggle",
                    name = L["Item Level"],
                    desc = L["Display item levels for equipped items"],
                    order = orderCounter(),
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.showOnInspect end
                },
                showInspectUpgradeTrack = {
                    type = "toggle",
                    name = L["Upgrade Track"],
                    desc = L["Display upgrade track and progress for equipped items"],
                    order = orderCounter(),
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.showOnInspect end,
                    hidden = PlayerGetTimerunningSeasonID() ~= nil
                },
                showInspectGems = {
                    type = "toggle",
                    name = L["Gems"],
                    desc = L["Display gem and socket information for equipped items"],
                    order = orderCounter(),
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.showOnInspect end,
                    hidden = PlayerGetTimerunningSeasonID() ~= nil
                },
                showInspectEnchants = {
                    type = "toggle",
                    name = L["Enchants"],
                    desc = L["Display enchant information for equipped items"].."\n\n".."Enchant text is always shown when inspecting another player",
                    order = orderCounter(),
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.showOnInspect end,
                    hidden = PlayerGetTimerunningSeasonID() ~= nil
                },
                showInspectEmbellishments = {
                    type = "toggle",
                    name = L["Embellishments"],
                    width = "full",
                    desc = L["Show a green star in the top-left corner of embellished equipment"],
                    order = orderCounter(),
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.showOnInspect end,
                    hidden = PlayerGetTimerunningSeasonID() ~= nil
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
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
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
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:ShowDecimalStatValues()
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.showDecimalsForStats end,
                    hidden = function() return not AddOn.db.profile.showDecimalsForStats end
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
                        if AddOn.db.profile.lastSelectedSpecID then
                            return AddOn.db.profile.lastSelectedSpecID
                        end

                        local specID = AddOn:GetCharacterCurrentSpecIDAndRole()
                        if AddOn.SpecOptionKeys[specID] then
                            return specID
                        else
                            return 0
                        end
                    end,
                    set = function(_, val)
                        AddOn.db.profile.lastSelectedSpecID = val
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
                        local specID, role = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        if AddOn.db.profile.customSpecStatOrders[specID] == nil then AddOn:InitializeCustomSpecStatOrderDB(specID, true) end
                        local dbStatOrder = AddOn.db.profile.customSpecStatOrders[specID]
                        for stat, order in pairs(dbStatOrder) do
                            local isTankStat = stat == "Dodge" or stat == "Parry" or stat == "Block"
                            local defaultStatUnordered = not isTankStat and order ~= AddOn.DefaultStatOrder[stat]
                            local tankStatUnordered = isTankStat and order ~= AddOn.DefaultTankStatOrder[stat]
                            if defaultStatUnordered or tankStatUnordered then
                                DebugPrint(ColorText(stat.." is unordered!", "Legendary"),
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
                    get = function() return not AddOn.db.profile.minimap.hide end,
                    set = function(_, val)
                        AddOn.db.profile.minimap.hide = not val
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
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:AdjustCharacterInfoWindowSize()
                    end
                },
                showEmbellishments = {
                    type = "toggle",
                    name = L["Show Embellishments"],
                    width = "full",
                    desc = L["Show a green star in the top-left corner of embellished equipment"],
                    order = orderCounter(),
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                    end
                },
                showCharacteriLvlDecimal = {
                    type = "toggle",
                    name = L["Show Decimals for Equipped Item Level"],
                    width = "full",
                    desc = L["Show your character's average equipped item level with decimal places"],
                    order = orderCounter(),
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
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
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.showCharacteriLvlDecimal end,
                    hidden = function() return not AddOn.db.profile.showCharacteriLvlDecimal end
                },
                spacer = AddOn.CreateOptionsSpacer(orderCounter()),
                hideShirtTabardInfo = {
                    type = "toggle",
                    name = L["Hide Shirt & Tabard Info"],
                    width = "full",
                    desc = L["Hide information for equipped shirt & tabard"],
                    order = orderCounter(),
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.showiLvl and not AddOn.db.profile.showGems and not AddOn.db.profile.showEnchants end
                },
                debug = {
                    type = "toggle",
                    name = L["Debug Mode"],
                    desc = L["Display debugging messages in the default chat window"].."\n\n"..ColorText(L["You should never need to enable this"], "DeathKnight"),
                    order = orderCounter(),
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val) AddOn.db.profile[item[#item]] = val end
                },
            }
        },
        credits = AddOn:BuildCreditsGroup()
    }
}

local DBDefaults = {
    profile = {
        showiLvl = true,
        showUpgradeTrack = true,
        showGems = true,
        showEnchants = true,
        showDurability = false,
        debug = false,
        iLvlScale = 1,
        iLvlOutline = "",
        useQualityColorForILvl = true,
        useClassColorForILvl = false,
        useGradientColorsForILvl = false,
        useCustomColorForILvl = false,
        iLvlCustomColor = AddOn.HexColorPresets.Priest,
        upgradeTrackScale = 1,
        upgradeTrackOutline = "",
        useQualityScaleColorsForUpgradeTrack = false,
        useCustomColorForUpgradeTrack = false,
        upgradeTrackCustomColor = AddOn.HexColorPresets.Priest,
        gemScale = 1,
        showMissingGems = true,
        missingGemsMaxLevelOnly = true,
        enchScale = 1,
        enchantOutline = "OUTLINE",
        showMissingEnchants = true,
        missingEnchantsMaxLevelOnly = true,
        useCustomColorForEnchants = false,
        enchCustomColor = AddOn.HexColorPresets.Uncommon,
        durabilityScale = 1,
        lastSelectedSpecID = nil,
        showDecimalsForStats = false,
        decimalPlacesForStats = 2,
        showOnInspect = false,
        showInspectAvgILvl = true,
        includeAvgLabel = false,
        showInspectiLvl = true,
        showInspectUpgradeTrack = true,
        showInspectGems = true,
        showInspectEnchants = true,
        showInspectEmbellishments = true,
        customSpecStatOrders = {},
        iLvlOnItem = false,
        showEmbellishments = true,
        showCharacteriLvlDecimal = false,
        decimalPlacesForCharacteriLvl = 2,
        hideShirtTabardInfo = false,
        collapseEnchants = false,
        minimap = { hide = true },
        increaseCharacterInfoSize = true,
        showEnchantTextButton = true,
        durabilityColorHigh = AddOn.HexColorPresets.Uncommon,
        durabilityColorMedium = AddOn.HexColorPresets.Info,
        durabilityColorLow = AddOn.HexColorPresets.Error,
    }
}

local incrementSlashOptionOrder = CreateCounter();
local SlashOptions = {
	type = "group",
	handler = AddOn,
	get = function(item) return AddOn.db.profile[item[#item]] end,
	set = function(item, value) AddOn.db.profile[item[#item]] = value end,
	args = {
        ilvl = {
            type = "toggle",
            name = "ilvl",
            desc = L["Toggle showing item level"],
            order = incrementSlashOptionOrder(),
            get = function() return AddOn.db.profile.showiLvl end,
	        set = function()
                AddOn.db.profile.showiLvl = not AddOn.db.profile.showiLvl
                LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
                AddOn:HandleEquipmentOrSettingsChange()
            end
        },
        track = {
            type = "toggle",
            name = "track",
            desc = L["Toggle showing upgrade track"],
            order = incrementSlashOptionOrder(),
            get = function() return AddOn.db.profile.showUpgradeTrack end,
	        set = function()
                AddOn.db.profile.showUpgradeTrack = not AddOn.db.profile.showUpgradeTrack
                LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
                AddOn:HandleEquipmentOrSettingsChange()
            end
        },
        gems = {
            type = "toggle",
            name = "gems",
            desc = L["Toggle showing gem info"],
            order = incrementSlashOptionOrder(),
            get = function() return AddOn.db.profile.showGems end,
	        set = function()
                AddOn.db.profile.showGems = not AddOn.db.profile.showGems
                LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
                AddOn:HandleEquipmentOrSettingsChange()
            end
        },
        ench = {
            type = "toggle",
            name = "ench",
            desc = L["Toggle showing enchant info"],
            order = incrementSlashOptionOrder(),
            get = function() return AddOn.db.profile.showEnchants end,
	        set = function()
                AddOn.db.profile.showEnchants = not AddOn.db.profile.showEnchants
                LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
                AddOn:HandleEquipmentOrSettingsChange()
                if not AddOn.db.profile.showEnchants and AddOn.PGVToggleEnchantButton:IsShown() then
                    AddOn.PGVToggleEnchantButton:Hide()
                elseif AddOn.db.profile.showEnchants and not AddOn.PGVToggleEnchantButton:IsShown() then
                    AddOn.PGVToggleEnchantButton:Show()
                end
            end
        },
        dur = {
            type = "toggle",
            name = "dur",
            desc = L["Toggle showing durability percentages"],
            order = incrementSlashOptionOrder(),
            get = function() return AddOn.db.profile.showDurability end,
            set = function()
                AddOn.db.profile.showDurability = not AddOn.db.profile.showDurability
                LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
                AddOn:HandleEquipmentOrSettingsChange()
            end
        },
        etext = {
            type = "toggle",
            name = "etext",
            desc = L["Toggle showing enchant text in the Character Info window"],
            order = incrementSlashOptionOrder(),
            get = function() return AddOn.db.profile.collapseEnchants end,
            set = function()
                AddOn.db.profile.collapseEnchants = not AddOn.db.profile.collapseEnchants
                LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
                AddOn:HandleEquipmentOrSettingsChange()
            end
        },
        inspect = {
            type = "toggle",
            name = "inspect",
            desc = L["Toggle showing gear info when inspecting another player"],
            order = incrementSlashOptionOrder(),
            get = function() return AddOn.db.profile.showOnInspect end,
            set = function()
                AddOn.db.profile.showOnInspect = not AddOn.db.profile.showOnInspect
                LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
                AddOn:HandleEquipmentOrSettingsChange()
            end
        },
        expand = {
            type = "toggle",
            name = "expand",
            desc = L["Toggle using the larger Character Info window"],
            order = incrementSlashOptionOrder(),
            get = function() return AddOn.db.profile.increaseCharacterInfoSize end,
            set = function()
                AddOn.db.profile.increaseCharacterInfoSize = not AddOn.db.profile.increaseCharacterInfoSize
                LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
                AddOn:AdjustCharacterInfoWindowSize()
            end
        },
        minimap = {
            type = "toggle",
            name = "minimap",
            desc = L["Show/hide the minimap icon"],
            order = incrementSlashOptionOrder(),
            get = function() return not AddOn.db.profile.minimap.hide end,
            set = function()
                AddOn.db.profile.minimap.hide = not AddOn.db.profile.minimap.hide
                if AddOn.db.profile.minimap.hide then
                    LDBIcon:Hide(addonName)
                else
                    LDBIcon:Show(addonName)
                end
                LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
            end
        }
	},
}

local SlashCmds = { "prangearview", "pgv" }

function AddOn:OnInitialize()
    -- Load database
	self.db = LibStub("AceDB-3.0"):New("PranGearViewDB", DBDefaults, true)

    -- Data broker registration for minimap icon
    local broker = LDB:NewDataObject(addonName, {
    type = "launcher",
    text = addonName,
    icon = "Interface/AddOns/PranGearView/Media/PranGearViewIcon",
    OnClick = function()
      -- Open options window
      Settings.OpenToCategory(addonName)
    end,
    OnTooltipShow = function(tt)
      tt:AddLine(addonName)
      tt:AddLine(L["Open the AddOn options window"], 1,1,1)
    end,
  })
  LDBIcon:Register(addonName, broker, self.db.profile.minimap)

    -- Setup config options
    local profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
    local config = LibStub("AceConfig-3.0")
    local registry = LibStub("AceConfigRegistry-3.0")

    -- Register Ace3 slash commands and override the default behavior so /pgv and /prangearview open the settings window
    config:RegisterOptionsTable(addonName, SlashOptions, SlashCmds)
    self:RegisterChatCommand("pgv", function(input) self.HandlePGVSlashCmd("pgv", input) end)
    self:RegisterChatCommand("prangearview", function(input) self.HandlePGVSlashCmd("prangearview", input) end)
    LibStub("AceConfigRegistry-3.0"):ValidateOptionsTable(OptionsTable, addonName)
    registry:RegisterOptionsTable("PGVOptions", OptionsTable)
	registry:RegisterOptionsTable("PGVProfiles", profiles)
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("PGVOptions", addonName)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("PGVProfiles", "Profiles", addonName);

    self.ShowGems = self.db.profile.showGems and not PlayerGetTimerunningSeasonID()
    self.ShowEnchants = self.db.profile.showEnchants and not PlayerGetTimerunningSeasonID()
    self.ShowEmbellishments = self.db.profile.showEmbellishments and not PlayerGetTimerunningSeasonID()
    self.ShowUpgradeTrack = self.db.profile.showUpgradeTrack and not PlayerGetTimerunningSeasonID()

    if self.db.profile.collapseEnchants then
        DebugPrint("Enchant text is collapsed, update button text accordingly")
        AddOn.PGVToggleEnchantButton:UpdateTooltipText(L["Show Enchant Text"])
    end

    AddOn.PGVToggleEnchantButton:SetScript("OnClick", function(button)
        local collapseEnchants = not AddOn.db.profile.collapseEnchants
        AddOn.db.profile.collapseEnchants = collapseEnchants
        AddOn.UpdateEquippedGearInfo(AddOn)
        button:UpdateTooltipText(collapseEnchants and L["Show Enchant Text"] or L["Hide Enchant Text"])
    end)

    if (not self.ShowEnchants or (self.ShowEnchants and not self.db.profile.showEnchantTextButton)) and AddOn.PGVToggleEnchantButton:IsShown() then
        AddOn.PGVToggleEnchantButton:Hide()
    end

    self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", "HandleEquipmentOrSettingsChange")
    self:RegisterEvent("UPDATE_INVENTORY_DURABILITY", "HandleEquipmentOrSettingsChange")
    self:RegisterEvent("SOCKET_INFO_ACCEPT", "HandleEquipmentOrSettingsChange")

    -- Necessary to create DB entries for stat ordering when playing a new class/specialization
    self:RegisterEvent("PLAYER_ENTERING_WORLD", function() self:InitializeCustomSpecStatOrderDB() end)
    self:RegisterEvent("ACTIVE_PLAYER_SPECIALIZATION_CHANGED", function() self:InitializeCustomSpecStatOrderDB() end)

    self:RegisterEvent("INSPECT_READY", function(_, unitGUID)
        if InspectFrame and InspectFrame.unit then
            InspectFrame:HookScript("OnHide", function()
                AddOn.inspectedUnitGUID = nil
                ClearInspectPlayer()
                DebugPrint("InspectFrame hidden, DB value and InspectPlayer cleared")
            end)

            self:UpdateInspectedGearInfo(unitGUID)
        end
    end)
    DebugPrint(ColorText(addonName, "Heirloom"), "initialized successfully")

    -- Hook into necessary secure functions
    hooksecurefunc(CharacterFrame, "ShowSubFrame", function(_, subFrame) if subFrame == "PaperDollFrame" then self:UpdateEquippedGearInfo() end end)
    hooksecurefunc(CharacterFrame, "RefreshDisplay", function() self:AdjustCharacterInfoWindowSize() end)
    hooksecurefunc(CharacterModelScene, "TransitionToModelSceneID", function(cms, sceneID)
        if sceneID == 595 and PaperDollFrame:IsVisible() and self.db.profile.increaseCharacterInfoSize then
            local actor = cms:GetPlayerActor()
            DebugPrint("CMS Transition: requested scale before mod - ", actor:GetRequestedScale())
            actor:SetRequestedScale(actor:GetRequestedScale() * 0.8)
            actor:UpdateScale()
            DebugPrint("Updated requested scale to", actor:GetRequestedScale())
            local posX, posY, posZ = actor:GetPosition()
            -- Apply a offeset to the vertical positioning so that more of the model is visible (feet are not covered)
            actor:SetPosition(posX, posY, posZ + 0.25)
        end
    end)
    hooksecurefunc("PaperDollFrame_UpdateStats", function()
        self:ReorderStatFramesBySpec()
        if CharacterStatsPane and self.db.profile.showDecimalsForStats then self:ShowDecimalStatValues() end
        if CharacterStatsPane and self.db.profile.showCharacteriLvlDecimal then
            CharacterStatsPane.ItemLevelFrame.Value:SetFormattedText("%."..self.db.profile.decimalPlacesForCharacteriLvl.."f", select(2, GetAverageItemLevel()))
        end
    end)

    -- Whenever the options window is opened, clear the lastSelectedSpecID entry from the database so that
    -- it shows the character's current specialization options by default
    SettingsPanel:HookScript("OnShow", function()
        local specID = AddOn.GetCharacterCurrentSpecIDAndRole(AddOn)
        if AddOn.SpecOptionKeys[specID] and specID ~= AddOn.db.profile.lastSelectedSpecID then
            AddOn.db.profile.lastSelectedSpecID = specID
        else
            AddOn.db.profile.lastSelectedSpecID = nil
        end
        LibStub("AceConfigRegistry-3.0"):NotifyChange(addonName)
        LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
    end)
end

---Handles slash commands in a way that overrides the default behavior of Ace3 slash commands. Executing the command with no arguments
---opens the AddOn options window, providing the `help` argument displays a list of available arguments and uses for the slash command,
---and all other arguments are handled using Ace3's default behavior.
---@param cmd string The slash command used (should be one of `/pgv` or `/prangearview`)
---@param input string The argument provided to the slash command
function AddOn.HandlePGVSlashCmd(cmd, input)
    input = strtrim(input)
    if input == "" then
        Settings.OpenToCategory(addonName)
    elseif input == "help" then
        LibStub("AceConfigCmd-3.0"):HandleCommand(cmd, addonName, "")
        -- Mimic the Ace3 command description format to indicate that no argument opens the addon options
        print("  |cffffff78(no argument)|r - "..L["Open the AddOn options window"])
    else
        LibStub("AceConfigCmd-3.0"):HandleCommand(cmd, addonName, input)
    end
end

---Handles changing the Character Info window size when the option to use the larger character window is checked
function AddOn:AdjustCharacterInfoWindowSize()
    DebugPrint("AdjustCharacterInfoWindowSize - Refreshing display")
    if PaperDollFrame:IsVisible() and self.db.profile.increaseCharacterInfoSize then
        DebugPrint("Larger character info window enabled")
        -- Overwrite defined character frame width and adjust positioning of frames within CharacterFrame
        CharacterFrame:SetWidth(650)
        CharacterFrameInset:SetPoint("BOTTOMRIGHT", CharacterFrame, "BOTTOMLEFT", 450, 4)
        CharacterModelScene:SetPoint("BOTTOMRIGHT", CharacterFrameInset, "BOTTOMLEFT", 400, 35)
        CharacterMainHandSlot:SetPoint("BOTTOMLEFT", PaperDollItemsFrame, "BOTTOMLEFT", 200, 16)
        CharacterModelFrameBackgroundTopLeft:SetWidth(331)
        CharacterModelFrameBackgroundBotLeft:SetWidth(331)
    elseif PaperDollFrame:IsVisible() then
        DebugPrint("Larger character info window disabled. Resetting any adjusted values.")
        -- Undo all changes made for displaying the larger window
        -- Sources: /fstack in-game and https://www.townlong-yak.com/framexml/live/Blizzard_UIPanels_Game/PaperDollFrame.xml
        local charFrameInsetBotRightXOffset = select(4, CharacterFrameInset:GetPointByName("BOTTOMRIGHT"))
        local charModelSceneBotRight = CharacterModelScene:GetPointByName("BOTTOMRIGHT")
        local charMainHandSlotBotLeftXOffset = select(4, CharacterMainHandSlot:GetPointByName("BOTTOMLEFT"))
        if CharacterFrame:GetWidth() ~= CHARACTERFRAME_EXPANDED_WIDTH then CharacterFrame:SetWidth(CHARACTERFRAME_EXPANDED_WIDTH) end
        if charFrameInsetBotRightXOffset ~= 32 then CharacterFrameInset:SetPoint("BOTTOMRIGHT", CharacterFrame, "BOTTOMLEFT", 332, 4) end
        if charModelSceneBotRight then CharacterModelScene:ClearPoint("BOTTOMRIGHT") end
        if charMainHandSlotBotLeftXOffset ~= 130 then CharacterMainHandSlot:SetPoint("BOTTOMLEFT", PaperDollItemsFrame, "BOTTOMLEFT", 130, 16) end
        if CharacterModelFrameBackgroundTopLeft:GetWidth() ~= 212 then CharacterModelFrameBackgroundTopLeft:SetWidth(212) end
        if CharacterModelFrameBackgroundBotLeft:GetWidth() ~= 212 then CharacterModelFrameBackgroundBotLeft:SetWidth(212) end
        if CharacterModelScene:GetPlayerActor() then
            local actor = CharacterModelScene:GetPlayerActor()
            if actor:GetRequestedScale() then actor.requestedScale = nil end
            actor:UpdateScale()
            if select(3, actor:GetPosition()) > 1.25 then actor:SetPosition(0, 0, select(3, actor:GetPosition()) - 0.25) end
        end
    end
end

---Handles changes to equipped gear or AddOn settings when Character Info and/or Inspect window is visible
function AddOn:HandleEquipmentOrSettingsChange()
    if PaperDollFrame:IsVisible() then
        DebugPrint("Changed equipped item or AddOn setting, updating gear information")
        self:UpdateEquippedGearInfo();
    end
    if InspectPaperDollFrame and InspectPaperDollFrame:IsVisible() then
        DebugPrint("Changed AddOn setting for inspect window, updating inspect gear information")
        self:UpdateInspectedGearInfo(self.inspectedUnitGUID, true)
    end
end

---Updates information displayed in the Character Info window
function AddOn:UpdateEquippedGearInfo()
    if not self.GearSlots then
        DebugPrint("Gear slots table not found")
        return
    end
    
    DebugPrint("Enchants collapsed:", self.db.profile.collapseEnchants)
       for _, slot in ipairs(self.GearSlots) do
        local slotID = slot:GetID()
        if self.db.profile.showiLvl then
            if not slot.PGVItemLevel then
                slot.PGVItemLevel = slot:CreateFontString("PGVItemLevel"..slotID, "OVERLAY", "GameTooltipText")
            end
            ---@type string, number
            local iFont, iSize = slot.PGVItemLevel:GetFont()
            slot.PGVItemLevel:SetFont(iFont, iSize, self.db.profile.iLvlOutline)
            slot.PGVItemLevel:Hide()
            local iLvlTextScale = 1
            if self.db.profile.iLvlScale and self.db.profile.iLvlScale > 0 then
                iLvlTextScale = iLvlTextScale * self.db.profile.iLvlScale
            end
            slot.PGVItemLevel:SetTextScale(iLvlTextScale)

            self:GetItemLevelBySlot(slot)
            self:SetItemLevelPositionBySlot(slot)
        elseif slot.PGVItemLevel then
            slot.PGVItemLevel:Hide()
        end

        if self.ShowUpgradeTrack then
            if not slot.PGVUpgradeTrack then
                slot.PGVUpgradeTrack = slot:CreateFontString("PGVUpgradeTrack"..slotID, "OVERLAY", "GameTooltipText")
            end
            ---@type string, number
            local uFont, uSize = slot.PGVUpgradeTrack:GetFont()
            slot.PGVUpgradeTrack:SetFont(uFont, uSize, self.db.profile.upgradeTrackOutline)
            slot.PGVUpgradeTrack:Hide()
            local upgradeTrackTextScale = 0.9
            if self.db.profile.upgradeTrackScale and self.db.profile.upgradeTrackScale > 0 then
                upgradeTrackTextScale = upgradeTrackTextScale * self.db.profile.upgradeTrackScale
            end
            slot.PGVUpgradeTrack:SetTextScale(upgradeTrackTextScale)

            self:GetUpgradeTrackBySlot(slot)
            self:SetUpgradeTrackPositionBySlot(slot)
        elseif slot.PGVUpgradeTrack then
            slot.PGVUpgradeTrack:Hide()
        end

        if self.ShowGems then
            if not slot.PGVGems then
                slot.PGVGems = slot:CreateFontString("PGVGems"..slotID, "OVERLAY", "GameTooltipText")
            end
            slot.PGVGems:Hide()
            local gemScale = 1
            if self.db.profile.gemScale and self.db.profile.gemScale > 0 then
                gemScale = gemScale * self.db.profile.gemScale
            end
            slot.PGVGems:SetTextScale(gemScale)

            self:GetGemsBySlot(slot)
            self:SetGemsPositionBySlot(slot)
        elseif slot.PGVGems then
            slot.PGVGems:Hide()
        end

        if self.ShowEnchants then
            if not slot.PGVEnchant then
                slot.PGVEnchant = slot:CreateFontString("PGVEnchant"..slotID, "OVERLAY", "GameTooltipText")
            end
            ---@type string, number
            local eFont, eSize = slot.PGVEnchant:GetFont()
            slot.PGVEnchant:SetFont(eFont, eSize, self.db.profile.enchantOutline)
            slot.PGVEnchant:Hide()
            local enchTextScale = 0.9
            if self.db.profile.enchScale and self.db.profile.enchScale > 0 then
                enchTextScale = enchTextScale * self.db.profile.enchScale
            end
            slot.PGVEnchant:SetTextScale(enchTextScale)

            self:GetEnchantmentBySlot(slot)
            self:SetEnchantPositionBySlot(slot)
        elseif slot.PGVEnchant then
            slot.PGVEnchant:Hide()
        end
        
        if self.db.profile.showDurability then
            self:ShowDurabilityBySlot(slot)
        elseif slot.PGVDurability then
            slot.PGVDurability:Hide()
        end

        if self.ShowEmbellishments then
            self:ShowEmbellishmentBySlot(slot)
        else
            if slot.PGVEmbellishmentTexture then slot.PGVEmbellishmentTexture:Hide() end
            if slot.PGVEmbellishmentShadow then slot.PGVEmbellishmentShadow:Hide() end
        end

        if self.db.profile.hideShirtTabardInfo and (slot == CharacterShirtSlot or slot == CharacterTabardSlot) then
            if slot.PGVItemLevel then slot.PGVItemLevel:Hide() end
            if slot.PGVGems then slot.PGVGems:Hide() end
            if slot.PGVEnchant then slot.PGVEnchant:Hide() end
        end
    end
    -- Manually force a stats update to update item level decimal places and stat ordering if needed
    PaperDollFrame_UpdateStats()
end
