local addonName, AddOn = ...
---@class PranGearView: AceAddon, AceConsole-3.0, AceEvent-3.0
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

local DebugPrint = AddOn.DebugPrint
local ColorText = AddOn.ColorText


local Options = {
    type = "group",
    name = addonName,
    args = {
        usageDesc = {
            type = "description",
            name = L["Choose information to show in the Character Info window"],
            width = "full",
            order = 1,
        },
        spacer = AddOn.CreateOptionsSpacer(2),
        showiLvl = {
            type = "toggle",
            name = L["Item Level"],
            desc = L["Display item levels for equipped items"],
            order = 3,
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
            order = 4,
            get = function(item) return AddOn.db.profile[item[#item]] end,
            set = function(item, val)
                AddOn.db.profile[item[#item]] = val
                AddOn:HandleEquipmentOrSettingsChange()
                end,
        },
        showGems = {
            type = "toggle",
            name = L["Gems"],
            desc = L["Display gem and socket information for equipped items"],
            order = 5,
            get = function(item) return AddOn.db.profile[item[#item]] end,
            set = function(item, val)
                AddOn.db.profile[item[#item]] = val
                AddOn:HandleEquipmentOrSettingsChange()
            end
        },
        showEnchants = {
            type = "toggle",
            name = L["Enchants"],
            desc = L["Display enchant information for equipped items"],
            order = 6,
            get = function(item) return AddOn.db.profile[item[#item]] end,
            set = function(item, val)
                AddOn.db.profile[item[#item]] = val
                if not val and AddOn.PGVToggleEnchantButton:IsShown() then
                    AddOn.PGVToggleEnchantButton:Hide()
                elseif val and not AddOn.PGVToggleEnchantButton:IsShown() then
                    AddOn.PGVToggleEnchantButton:Show()
                end
                AddOn:HandleEquipmentOrSettingsChange()
            end
        },
        showDurability = {
            type = "toggle",
            name = L["Durability"],
            desc = L["Display durability percentages for equipped items"],
            order = 7,
            get = function(item) return AddOn.db.profile[item[#item]] end,
            set = function(item, val)
                AddOn.db.profile[item[#item]] = val
                AddOn:HandleEquipmentOrSettingsChange()
            end
        },
        divider = {
            type = "header",
            name = "",
            order = 8
        },
        iLvlOptions = {
            type = "group",
            name = L["Item Level"],
            order = 9,
            args = {
                iLvlScale = {
                    type = "range",
                    name = L["Font Scale"],
                    desc = L["Scale item level text size relative to the default"],
                    order = 9.01,
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
                smallSpacer = AddOn.CreateOptionsSpacer(9.02, 0.25),
                iLvlOutline = {
                    type = "select",
                    name = L["Outline"],
                    desc = L["The outline style to add to item level text"].."\n\n"..L["Does nothing if the Alternate Item Level Placement checkbox is checked"],
                    order = 9.03,
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
                spacer = AddOn.CreateOptionsSpacer(9.04),
                iLvlOnItem = {
                    type = "toggle",
                    name = L["Alternate Item Level Placement"],
                    width = "full",
                    desc = L["Display item levels on top of equipment icons"],
                    order = 9.05,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.showiLvl end
                },
                spacerTwo = AddOn.CreateOptionsSpacer(9.06),
                iLvlColorOptionsDesc = {
                    type = "description",
                    name = ColorText(L["Item levels shown in white when no color options are selected"], "Info"),
                    order = 9.07
                },
                spacerThree = AddOn.CreateOptionsSpacer(9.08),
                useQualityColorForILvl = {
                    type = "toggle",
                    name = L["Use Item Quality Color"],
                    desc = L["Color item levels based on item quality"],
                    order = 9.09,
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
                    order = 9.1,
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
                    order = 9.11,
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
                    order = 9.12,
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
                    order = 9.13
                },
                iLvlCustomColor = {
                    type = "color",
                    name = L["Choose a Color"],
                    order = 9.14,
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
                    disabled = function() return not AddOn.db.profile.showiLvl or not AddOn.db.profile.useCustomColorForILvl end
                },
                customColorHex = {
                    type = "input",
                    name = "",
                    width = "half",
                    order = 9.15,
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
                    disabled = function() return not AddOn.db.profile.showiLvl or not AddOn.db.profile.useCustomColorForILvl end
                },
                resetCustomColor = {
                    type = "execute",
                    name = L["Reset"],
                    width = "half",
                    order = 9.16,
                    func = function()
                        AddOn.db.profile.iLvlCustomColor = AddOn.HexColorPresets.Priest
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function()
                        local itemLevelShown = AddOn.db.profile.showiLvl
                        local usingCustomColor = AddOn.db.profile.useCustomColorForILvl
                        local customColorIsDefault = itemLevelShown and usingCustomColor and AddOn.db.profile.iLvlCustomColor == AddOn.HexColorPresets.Priest
                        return not itemLevelShown or not usingCustomColor or customColorIsDefault
                    end
                }
            }
        },
        upgradeTrackOptions = {
            type = "group",
            name = L["Upgrade Track"],
            order = 10,
            args = {
                upgradeTrackScale = {
                    type = "range",
                    name = L["Font Scale"],
                    desc = L["Scale upgrade track text size relative to the default"],
                    order = 10.01,
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
                smallSpacer = AddOn.CreateOptionsSpacer(10.02, 0.25),
                upgradeTrackOutline = {
                    type = "select",
                    name = L["Outline"],
                    desc = L["The outline style to add to upgrade track text"],
                    order = 10.03,
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
                spacer = AddOn.CreateOptionsSpacer(10.04),
                useCustomColorForUpgradeTrack = {
                    type = "toggle",
                    name = L["Use Custom Color"],
                    width = "full",
                    desc = L["Customize upgrade track color for current season items"],
                    order = 10.05,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.showUpgradeTrack end
                },
                customColorDesc = {
                    type = "description",
                    name = "\n"..L["Choose from the color picker or enter the hex code for a specific color."].."\n"..L["Color codes should be entered in the format #RRGGBB"].."\n\n",
                    order = 10.06
                },
                upgradeTrackCustomColor = {
                    type = "color",
                    name = L["Choose a Color"],
                    order = 10.07,
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
                    disabled = function() return not AddOn.db.profile.showUpgradeTrack or not AddOn.db.profile.useCustomColorForUpgradeTrack end
                },
                upgradeTrackCustomColorHex = {
                    type = "input",
                    name = "",
                    width = "half",
                    order = 10.08,
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
                    disabled = function() return not AddOn.db.profile.showUpgradeTrack or not AddOn.db.profile.useCustomColorForILvl end
                },
                resetUpgradeTrackCustomColor = {
                    type = "execute",
                    name = L["Reset"],
                    width = "half",
                    order = 10.09,
                    func = function()
                        AddOn.db.profile.upgradeTrackCustomColor = AddOn.HexColorPresets.Priest
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function()
                        local upgradeTrackShown = AddOn.db.profile.showUpgradeTrack
                        local usingCustomColor = AddOn.db.profile.useCustomColorForUpgradeTrack
                        local customColorIsDefault = upgradeTrackShown and usingCustomColor and AddOn.db.profile.upgradeTrackCustomColor == AddOn.HexColorPresets.Priest
                        return not upgradeTrackShown or not usingCustomColor or customColorIsDefault
                    end
                }
            }
        },
        gemOptions = {
            type = "group",
            name = L["Gems"],
            order = 11,
            args = {
                gemScale = {
                    type = "range",
                    name = L["Icon Scale"],
                    desc = L["Scale gem icon size relative to the default"],
                    order = 11.01,
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
                spacer = AddOn.CreateOptionsSpacer(11.02),
                showMissingGems = {
                    type = "toggle",
                    name = L["Show Missing Gems & Sockets"],
                    desc = L["Show when an item is missing gems or sockets"],
                    width = "full",
                    order = 11.03,
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
                    order = 11.04,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.showGems or (AddOn.db.profile.showGems and not AddOn.db.profile.showMissingGems) end
                },
                spacerTwo = AddOn.CreateOptionsSpacer(11.05),
                missingGemsDesc = {
                    type = "description",
                    name = ColorText(L["indicates that a socket can be added to the item"], "Info"),
                    order = 11.06
                },
                emptySocketDesc = {
                    type = "description",
                    name = ColorText(L["indicates an empty socket on the item"], "Info"),
                    order = 11.07
                }
            }
        },
        enchantOptions = {
            type = "group",
            name = L["Enchants"],
            order = 12,
            args = {
                enchScale = {
                    type = "range",
                    name = L["Font Scale"],
                    desc = L["Scale enchant text size relative to the default"],
                    order = 12.01,
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
                smallSpacer = AddOn.CreateOptionsSpacer(12.02, 0.25),
                enchantOutline = {
                    type = "select",
                    name = L["Outline"],
                    desc = L["The outline style to add to enchant text"],
                    order = 12.03,
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
                spacer = AddOn.CreateOptionsSpacer(12.04),
                showMissingEnchants = {
                    type = "toggle",
                    name = L["Missing Enchant Indicator"],
                    desc = L["Show when an item is missing an enchant with a warning symbol"],
                    order = 12.05,
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
                    width = "double",
                    order = 12.06,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.showEnchants or (AddOn.db.profile.showEnchants and not AddOn.db.profile.showMissingEnchants) end
                },
                spacerTwo = AddOn.CreateOptionsSpacer(12.07),
                enchTextColorOptionsDesc = {
                    type = "description",
                    name = ColorText(L["Enchant quality symbol is not affected by the custom color option"], "Info"),
                    order = 12.08
                },
                spacerThree = AddOn.CreateOptionsSpacer(12.09),
                useCustomColorForEnchants = {
                    type = "toggle",
                    name = L["Use Custom Color"],
                    width = "full",
                    desc = L["Customize enchant text color"],
                    order = 12.1,
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
                    order = 12.11
                },
                enchCustomColor = {
                    type = "color",
                    name = L["Choose a Color"],
                    order = 12.12,
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
                    disabled = function() return not AddOn.db.profile.showEnchants or not AddOn.db.profile.useCustomColorForEnchants end
                },
                customColorHex = {
                    type = "input",
                    name = "",
                    width = "half",
                    order = 12.13,
                    get = function() return "#"..AddOn.db.profile.enchCustomColor end,
                    set = function(_, val)
                        -- Validate that the provided hex code can be converted to an RGB color before setting
                        local r, g, b = AddOn.ConvertHexToRGB(val:gsub("#", ""))
                        if r ~= nil and g ~= nil and b ~= nil then
                            AddOn.db.profile.enchCustomColor = val:gsub("#", "")
                            AddOn:HandleEquipmentOrSettingsChange()
                        end
                    end,
                    disabled = function() return not AddOn.db.profile.showEnchants or not AddOn.db.profile.useCustomColorForEnchants end
                },
                resetCustomColor = {
                    type = "execute",
                    name = L["Reset"],
                    width = "half",
                    order = 12.14,
                    func = function()
                        AddOn.db.profile.enchCustomColor = AddOn.HexColorPresets.Uncommon
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function()
                        local enchantsShown = AddOn.db.profile.showEnchants
                        local usingCustomEnchColor = AddOn.db.profile.useCustomColorForEnchants
                        local enchCustomColorIsDefault = enchantsShown and usingCustomEnchColor and AddOn.db.profile.enchCustomColor == AddOn.HexColorPresets.Uncommon
                        return not enchantsShown or not usingCustomEnchColor or enchCustomColorIsDefault
                    end
                }
            }
        },
        durabilityOptions = {
            type = "group",
            name = L["Durability"],
            order = 13,
            args = {
                durUsageDesc = {
                    type = "description",
                    name = ColorText(L["Durability always hidden at 100%"], "Info"),
                    order = 13.01
                },
                spacer = AddOn.CreateOptionsSpacer(13.02),
                durabilityScale = {
                    type = "range",
                    name = L["Font Scale"],
                    desc = L["Scale durability text size relative to the default"],
                    order = 13.03,
                    min = 0.1,
                    max = 2,
                    step = 0.05,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.showDurability end
                }
            }
        },
        inspectOptions = {
            type = "group",
            name = L["Inspect Window"],
            order = 14,
            args = {
                showOnInspect = {
                    type = "toggle",
                    name = L["Show Gear Info on Inspect"],
                    desc = L["Displays information about equipped gear when inspecting another player"],
                    order = 14.01,
                    width = "full",
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                    end
                },
                spacer = AddOn.CreateOptionsSpacer(14.02),
                inspectDescription = {
                    type = "description",
                    name = ColorText(L["Choose which information should be displayed when inspecting another player."].." "..L["Colors, size, and other display settings when inspecting a character will follow the same settings as the Character Info window."], "Info"),
                    order = 14.03
                },
                spacerTwo = AddOn.CreateOptionsSpacer(14.04),
                showInspectAvgILvl = {
                    type = "toggle",
                    name = L["Average Item Level"],
                    desc = L["Display average item level in the character's class color"],
                    order = 14.05,
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
                    order = 14.06,
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
                    order = 14.07,
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
                    order = 14.08,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                        end,
                    disabled = function() return not AddOn.db.profile.showOnInspect end
                },
                showInspectGems = {
                    type = "toggle",
                    name = L["Gems"],
                    desc = L["Display gem and socket information for equipped items"],
                    order = 14.09,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.showOnInspect end
                },
                showInspectEnchants = {
                    type = "toggle",
                    name = L["Enchants"],
                    desc = L["Display enchant information for equipped items"].."\n\n".."Enchant text is always shown when inspecting another player",
                    order = 14.1,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.showOnInspect end
                },
                showInspectEmbellishments = {
                    type = "toggle",
                    name = L["Embellishments"],
                    width = "full",
                    desc = L["Show a green star in the top-left corner of embellished equipment"],
                    order = 14.11,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                    end,
                    disabled = function() return not AddOn.db.profile.showOnInspect end
                },
            }
        },
        characterStatOptions = {
            type = "group",
            name = L["Character Stats"],
            order = 15,
            args = {
                statUsageDesc = {
                    type = "description",
                    name = ColorText(L["Customize secondary & tertiary stat order in the Character Info window by specialization"], "Info"),
                    order = 15.01,
                },
                spacer = AddOn.CreateOptionsSpacer(15.02),
                specSelect = {
                    type = "select",
                    name = L["Specialization"],
                    order = 15.03,
                    values = function()
                        local options = {}
                        local specID = AddOn:GetCharacterCurrentSpecIDAndRole()
                        if not AddOn.SpecOptionKeys[specID] then
                            options[0] = ""
                        end
                        for id, specKey in pairs(AddOn.SpecOptionKeys) do
                            local classFile = select(6, GetSpecializationInfoByID(id))
                            options[id] = "|A:classicon-"..classFile..":15:15|a "..L[specKey]
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
                    order = 15.04,
                    width = "half"
                },
                resetOrderButton = {
                    type = "execute",
                    name = L["Reset"],
                    width = "half",
                    order = 15.05,
                    func = function()
                        local specID = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        AddOn:InitializeCustomSpecStatOrderDB(specID, true)
                    end,
                    disabled = function()
                        local specID, role = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        local dbStatOrder = AddOn.db.profile.customSpecStatOrders[specID]
                        for stat, order in pairs(dbStatOrder) do
                            local isTankStat = stat == STAT_DODGE or stat == STAT_PARRY or stat == STAT_BLOCK
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
                postSpecSelectSpacer = AddOn.CreateOptionsSpacer(15.06),
                secondaryStatsHeader = {
                    type = "header",
                    name = L["Secondary Stats"],
                    order = 15.07
                },
                critStrikeLabel = {
                    type = "description",
                    name = ColorText(STAT_CRITICAL_STRIKE, "Info"),
                    order = 15.08,
                    width = "half"
                },
                [STAT_CRITICAL_STRIKE] = {
                    type = "select",
                    name = "",
                    order = 15.09,
                    width = 0.33,
                    values = function() return AddOn:GetStatOrderValuesHandler() end,
                    get = function(item) return AddOn:GetStatOrderHandler(item) end,
                    set = function(item, val)
                        AddOn:SetStatOrderHandler(item, val)
                        AddOn:HandleEquipmentOrSettingsChange()
                        end
                },
                postCritSpacer = AddOn.CreateOptionsSpacer(15.1),
                hasteLabel = {
                    type = "description",
                    name = ColorText(STAT_HASTE, "Info"),
                    order = 15.11,
                    width = "half"
                },
                [STAT_HASTE] = {
                    type = "select",
                    name = "",
                    order = 15.12,
                    width = 0.33,
                    values = function() return AddOn:GetStatOrderValuesHandler() end,
                    get = function(item) return AddOn:GetStatOrderHandler(item) end,
                    set = function(item, val)
                        AddOn:SetStatOrderHandler(item, val)
                        AddOn:HandleEquipmentOrSettingsChange()
                        end
                },
                postHasteSpacer = AddOn.CreateOptionsSpacer(15.13),
                masteryLabel = {
                    type = "description",
                    name = ColorText(STAT_MASTERY, "Info"),
                    order = 15.14,
                    width = "half"
                },
                [STAT_MASTERY] = {
                    type = "select",
                    name = "",
                    order = 15.15,
                    width = 0.33,
                    values = function() return AddOn:GetStatOrderValuesHandler() end,
                    get = function(item) return AddOn:GetStatOrderHandler(item) end,
                    set = function(item, val)
                        AddOn:SetStatOrderHandler(item, val)
                        AddOn:HandleEquipmentOrSettingsChange()
                        end
                },
                postMastSpacer = AddOn.CreateOptionsSpacer(15.16),
                versLabel = {
                    type = "description",
                    name = ColorText(STAT_VERSATILITY, "Info"),
                    order = 15.17,
                    width = "half"
                },
                [STAT_VERSATILITY] = {
                    type = "select",
                    name = "",
                    order = 15.18,
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
                    order = 15.19
                },
                leechLabel = {
                    type = "description",
                    name = ColorText(STAT_LIFESTEAL, "Info"),
                    order = 15.2,
                    width = "half"
                },
                [STAT_LIFESTEAL] = {
                    type = "select",
                    name = "",
                    order = 15.21,
                    width = 0.33,
                    values = function() return AddOn:GetStatOrderValuesHandler() end,
                    get = function(item) return AddOn:GetStatOrderHandler(item) end,
                    set = function(item, val)
                        AddOn:SetStatOrderHandler(item, val)
                        AddOn:HandleEquipmentOrSettingsChange()
                        end
                },
                postLeechSpacer = AddOn.CreateOptionsSpacer(15.22),
                avoidLabel = {
                    type = "description",
                    name = ColorText(STAT_AVOIDANCE, "Info"),
                    order = 15.23,
                    width = "half"
                },
                [STAT_AVOIDANCE] = {
                    type = "select",
                    name = "",
                    order = 15.24,
                    width = 0.33,
                    values = function() return AddOn:GetStatOrderValuesHandler() end,
                    get = function(item) return AddOn:GetStatOrderHandler(item) end,
                    set = function(item, val)
                        AddOn:SetStatOrderHandler(item, val)
                        AddOn:HandleEquipmentOrSettingsChange()
                        end
                },
                postAvoidSpacer = AddOn.CreateOptionsSpacer(15.25),
                speedLabel = {
                    type = "description",
                    name = ColorText(STAT_SPEED, "Info"),
                    order = 15.26,
                    width = "half"
                },
                [STAT_SPEED] = {
                    type = "select",
                    name = "",
                    order = 15.27,
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
                    order = 15.28,
                    hidden = function()
                        local _, role = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return role ~= "TANK"
                    end
                },
                dodgeLabel = {
                    type = "description",
                    name = ColorText(STAT_DODGE, "Info"),
                    order = 15.29,
                    width = "half",
                    hidden = function()
                        local _, role = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return role ~= "TANK"
                    end
                },
                [STAT_DODGE] = {
                    type = "select",
                    name = "",
                    order = 15.3,
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
                    order = 15.31,
                    hidden = function()
                        local _, role = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return role ~= "TANK"
                    end
                },
                parryLabel = {
                    type = "description",
                    name = ColorText(STAT_PARRY, "Info"),
                    order = 15.32,
                    width = "half",
                    hidden = function()
                        local _, role = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return role ~= "TANK"
                    end
                },
                [STAT_PARRY] = {
                    type = "select",
                    name = "",
                    order = 15.33,
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
                    order = 15.34,
                    hidden = function()
                        local _, role = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return role ~= "TANK"
                    end
                },
                blockLabel = {
                    type = "description",
                    name = ColorText(STAT_BLOCK, "Info"),
                    order = 15.35,
                    width = "half",
                    hidden = function()
                        local _, role = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return role ~= "TANK"
                    end
                },
                [STAT_BLOCK] = {
                    type = "select",
                    name = "",
                    order = 15.36,
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
            order = 16,
            args = {
                showEmbellishments = {
                    type = "toggle",
                    name = L["Show Embellishments"],
                    width = "full",
                    desc = L["Show a green star in the top-left corner of embellished equipment"],
                    order = 16.02,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        AddOn:HandleEquipmentOrSettingsChange()
                    end
                },
                hideShirtTabardInfo = {
                    type = "toggle",
                    name = L["Hide Shirt & Tabard Info"],
                    width = "full",
                    desc = L["Hide information for equipped shirt & tabard"],
                    order = 16.03,
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
                    order = 16.04,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val) AddOn.db.profile[item[#item]] = val end
                },
            }
        },
        credits = AddOn:BuildCreditsGroup()
    }
}

local Defaults = {
    profile = {
        showiLvl = true,
        showUpgradeTrack = true,
        showGems = true,
        showEnchants = true,
        showDurability = false,
        inspectedUnitGUID = nil,
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
        hideShirtTabardInfo = false,
        collapseEnchants = false,
    }
}

local SlashOptions = {
	type = "group",
	handler = AddOn,
	get = function(item) return AddOn.db.profile[item[#item]] end,
	set = function(item, value) AddOn.db.profile[item[#item]] = value end,
	args = {
		config = {
			type = "execute",
			name = "config",
			desc = L["Open the AddOn options window"],
			func = function() Settings.OpenToCategory(addonName) end,
		},
        ilvl = {
            type = "toggle",
            name = "ilvl",
            desc = L["Toggle showing item level"],
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
            get = function() return AddOn.db.profile.showOnInspect end,
            set = function()
                AddOn.db.profile.showOnInspect = not AddOn.db.profile.showOnInspect
                LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
                AddOn:HandleEquipmentOrSettingsChange()
            end
        }
	},
}

local SlashCmds = { "prangearview", "pgv" }

function AddOn:OnInitialize()
    -- Load database
	self.db = LibStub("AceDB-3.0"):New("PranGearViewDB", Defaults, true)

    -- Setup config options
    local profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
    local config = LibStub("AceConfig-3.0")
    local registry = LibStub("AceConfigRegistry-3.0")

    config:RegisterOptionsTable(addonName, SlashOptions, SlashCmds)
    LibStub("AceConfigRegistry-3.0"):ValidateOptionsTable(Options, addonName)
    registry:RegisterOptionsTable("PGVOptions", Options)
	registry:RegisterOptionsTable("PGVProfiles", profiles)
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("PGVOptions", addonName)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("PGVProfiles", "Profiles", addonName);

    if self.db.profile.collapseEnchants then
        DebugPrint("Enchant text is collapsed, update button text accordingly")
        AddOn.PGVToggleEnchantButton:UpdateText(L["Show Enchant Text"])
    end

    AddOn.PGVToggleEnchantButton:SetScript("OnClick", function(self, button, down)
        local collapseEnchants = not AddOn.db.profile.collapseEnchants
        AddOn.db.profile.collapseEnchants = collapseEnchants
        AddOn.UpdateEquippedGearInfo(AddOn)
        self:UpdateText(collapseEnchants and L["Show Enchant Text"] or L["Hide Enchant Text"])
    end)

    if not self.db.profile.showEnchants and AddOn.PGVToggleEnchantButton:IsShown() then
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
                AddOn.db.profile.inspectedUnitGUID = nil
                ClearInspectPlayer()
                DebugPrint("InspectFrame hidden, DB value and InspectPlayer cleared")
            end)

            self:UpdateInspectedGearInfo(unitGUID)
        end
    end)
    DebugPrint(ColorText(addonName, "Heirloom"), "initialized successfully")

    hooksecurefunc(CharacterFrame, "ShowSubFrame", function(_, subFrame)
        if subFrame == "PaperDollFrame" then
            self:UpdateEquippedGearInfo()
        end
    end)

    hooksecurefunc("PaperDollFrame_UpdateStats", function()
        self:ReorderStatFramesBySpec()
        -- TODO: Implement showing item level with 0-2 decimal places based on AddOn Option
        -- CharacterStatsPane.ItemLevelFrame.Value:SetFormattedText("%.2f", GetAverageItemLevel())
    end)

    -- Whenever the options window is opened, clear the lastSelectedSpecID entry from the database so that
    -- it shows the character's current specialization options by default
    SettingsPanel:SetScript("OnShow", function()
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

---Handles changes to equipped gear or AddOn settings when Character Info and/or Inspect window is visible
function AddOn:HandleEquipmentOrSettingsChange()
    if PaperDollFrame:IsVisible() then
        DebugPrint("Changed equipped item or AddOn setting, updating gear information")
        self:UpdateEquippedGearInfo();
    end
    if InspectPaperDollFrame and InspectPaperDollFrame:IsVisible() then
        DebugPrint("Changed AddOn setting for inspect window, updating inspect gear information")
        self:UpdateInspectedGearInfo(self.db.profile.inspectedUnitGUID, true)
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
            local iFont, iSize = slot.PGVItemLevel:GetFont()
            if self.db.profile.iLvlOnItem then
                -- Outline text when placed on the gear icon ignoring any selected outline option
                slot.PGVItemLevel:SetFont(iFont, iSize, "THICKOUTLINE")
            else
                slot.PGVItemLevel:SetFont(iFont, iSize, self.db.profile.iLvlOutline)
            end
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

        if self.db.profile.showUpgradeTrack then
            if not slot.PGVUpgradeTrack then
                slot.PGVUpgradeTrack = slot:CreateFontString("PGVUpgradeTrack"..slotID, "OVERLAY", "GameTooltipText")
            end
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

        if self.db.profile.showGems then
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

        if self.db.profile.showEnchants then
            if not slot.PGVEnchant then
                slot.PGVEnchant = slot:CreateFontString("PGVEnchant"..slotID, "OVERLAY", "GameTooltipText")
            end
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

        if self.db.profile.showEmbellishments then
            self:ShowEmbellishmentBySlot(slot)
        elseif slot.PGVEmbellishmentTexture then
            slot.PGVEmbellishmentTexture:Hide()
        end

        if self.db.profile.hideShirtTabardInfo and (slot == CharacterShirtSlot or slot == CharacterTabardSlot) then
            if slot.PGVItemLevel then slot.PGVItemLevel:Hide() end
            if slot.PGVGems then slot.PGVGems:Hide() end
            if slot.PGVEnchant then slot.PGVEnchant:Hide() end
        end
    end
end
