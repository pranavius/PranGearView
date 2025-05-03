local addonName, AddOn = ...
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

local PGV_DebugPrint = AddOn.PGV_DebugPrint
local PGV_ColorText = AddOn.PGV_ColorText

local Options = {
    type = "group",
    name = addonName,
    args = {
        usageDesc = {
            type = "description",
            name = L["usage_desc"],
            width = "full",
            order = 0,
        },
        spacer = {
            type = "description",
            name = " ",
            order = 1,
        },
        showiLvl = {
            type = "toggle",
            name = L["Item Level"],
            desc = L["show_ilvl_desc"],
            order = 2,
            get = function(item) return AddOn.db.profile[item[#item]] end,
            set = function(item, val) AddOn.db.profile[item[#item]] = val end
        },
        showGems = {
            type = "toggle",
            name = L["Gems"],
            desc = L["show_gems_desc"],
            order = 3,
            get = function(item) return AddOn.db.profile[item[#item]] end,
            set = function(item, val) AddOn.db.profile[item[#item]] = val end
        },
        showEnchants = {
            type = "toggle",
            name = L["Enchants"],
            desc = L["show_enchants_desc"],
            order = 4,
            get = function(item) return AddOn.db.profile[item[#item]] end,
            set = function(item, val) AddOn.db.profile[item[#item]] = val end
        },
        showDurability = {
            type = "toggle",
            name = L["Durability"],
            desc = L["show_durability_desc"],
            order = 5,
            get = function(item) return AddOn.db.profile[item[#item]] end,
            set = function(item, val) AddOn.db.profile[item[#item]] = val end
        },
        divider = {
            type = "header",
            name = "",
            order = 6
        },
        iLvlOptions = {
            type = "group",
            name = L["Item Level"],
            order = 1,
            args = {
                iLvlScale = {
                    type = "range",
                    name = L["Font Scale"],
                    desc = L["ilvl_font_scale_desc"],
                    order = 1,
                    min = 0.1,
                    max = 2,
                    step = 0.05,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val) AddOn.db.profile[item[#item]] = val end,
                    disabled = function() return not AddOn.db.profile.showiLvl end
                },
                spacer = {
                    type = "description",
                    name = " ",
                    order = 2
                },
                showUpgradeTrack = {
                    type = "toggle",
                    name = L["Show Upgrade Track"],
                    desc = L["upgrade_track_desc"],
                    order = 2.1,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val) AddOn.db.profile[item[#item]] = val end,
                    disabled = function() return not AddOn.db.profile.showiLvl end
                },
                iLvlColorOptionsDesc = {
                    type = "description",
                    name = PGV_ColorText(L["ilvl_color_opts_desc"], "Info"),
                    order = 3
                },
                spacerTwo = {
                    type = "description",
                    name = " ",
                    order = 4
                },
                useQualityColorForILvl = {
                    type = "toggle",
                    name = L["Use Item Quality Color"],
                    desc = L["ilvl_use_quality_color_desc"],
                    order = 5,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        if val then
                            AddOn.db.profile.useClassColorForILvl = false
                            AddOn.db.profile.useCustomColorForILvl = false
                        end
                    end,
                    disabled = function() return not AddOn.db.profile.showiLvl end
                },
                useClassColorForILvl = {
                    type = "toggle",
                    name = L["Use Class Color"],
                    desc = L["ilvl_use_class_color_desc"],
                    order = 6,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        if val then
                            AddOn.db.profile.useQualityColorForILvl = false
                            AddOn.db.profile.useCustomColorForILvl = false
                        end
                    end,
                    disabled = function() return not AddOn.db.profile.showiLvl end
                },
                useCustomColorForILvl = {
                    type = "toggle",
                    name = L["Use Custom Color"],
                    width = "full",
                    desc = L["ilvl_use_custom_color_desc"],
                    order = 7,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val)
                        AddOn.db.profile[item[#item]] = val
                        if val then
                            AddOn.db.profile.useQualityColorForILvl = false
                            AddOn.db.profile.useClassColorForILvl = false
                        end
                    end,
                    disabled = function() return not AddOn.db.profile.showiLvl end
                },
                customColorDesc = {
                    type = "description",
                    name = "\n"..L["custom_color_desc"].."\n"..L["custom_color_instruction"].."\n\n",
                    order = 8
                },
                iLvlCustomColor = {
                    type = "color",
                    name = L["Choose a Color"],
                    order = 9,
                    hasAlpha = false,
                    get = function(item)
                        if not AddOn.db.profile[item[#item]] then AddOn.db.profile[item[#item]] = AddOn.PGVHexColors.Priest end
                        local hex = AddOn.db.profile[item[#item]]
                        return AddOn.PGV_ConvertHexToRGB(hex)
                    end,
                    set = function(item, r, g, b)
                        AddOn.db.profile[item[#item]] = AddOn.PGV_ConvertRGBToHex(r, g, b)
                        LibStub("AceConfigRegistry-3.0"):NotifyChange(addonName)
                        LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
                    end,
                    disabled = function() return not AddOn.db.profile.showiLvl or not AddOn.db.profile.useCustomColorForILvl end
                },
                customColorHex = {
                    type = "input",
                    name = "",
                    width = "half",
                    order = 10,
                    get = function() return "#"..AddOn.db.profile.iLvlCustomColor end,
                    set = function(_, val)
                        -- Validate that the provided hex code can be converted to an RGB color before setting
                        local r, g, b = AddOn.PGV_ConvertHexToRGB(val:gsub("#", ""))
                        if r ~= nil and g ~= nil and b ~= nil then
                            AddOn.db.profile.iLvlCustomColor = val:gsub("#", "")
                        end
                    end,
                    disabled = function() return not AddOn.db.profile.showiLvl or not AddOn.db.profile.useCustomColorForILvl end
                },
                resetCustomColor = {
                    type = "execute",
                    name = L["Reset"],
                    width = "half",
                    order = 11,
                    func = function() AddOn.db.profile.iLvlCustomColor = AddOn.PGVHexColors.Priest end,
                    disabled = function()
                        local itemLevelShown = AddOn.db.profile.showiLvl
                        local usingCustomColor = AddOn.db.profile.useCustomColorForILvl
                        local customColorIsDefault = itemLevelShown and usingCustomColor and AddOn.db.profile.iLvlCustomColor == AddOn.PGVHexColors.Priest
                        return not itemLevelShown or not usingCustomColor or customColorIsDefault
                    end
                }
            }
        },
        gemOptions = {
            type = "group",
            name = L["Gems"],
            order = 2,
            args = {
                gemScale = {
                    type = "range",
                    name = L["Icon Scale"],
                    desc = L["gem_icon_scale_desc"],
                    order = 1,
                    min = 0.1,
                    max = 2,
                    step = 0.05,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val) AddOn.db.profile[item[#item]] = val end,
                    disabled = function() return not AddOn.db.profile.showGems end
                },
                spacer = {
                    type = "description",
                    name = " ",
                    order = 2
                },
                showMissingGems = {
                    type = "toggle",
                    name = L["Missing Gems Indicator"],
                    desc = L["missing_gems_desc"],
                    order = 2.1,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val) AddOn.db.profile[item[#item]] = val end,
                    disabled = function() return not AddOn.db.profile.showGems end
                },
                missingGemsMaxLevelOnly = {
                    type = "toggle",
                    name = L["Only Show Missing Gems for Max Level"],
                    desc = L["missing_gems_max_lvl_desc"],
                    width = "double",
                    order = 2.2,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val) AddOn.db.profile[item[#item]] = val end,
                    disabled = function() return not AddOn.db.profile.showGems or (AddOn.db.profile.showGems and not AddOn.db.profile.showMissingGems) end
                },
                spacerTwo = {
                    type = "description",
                    name = " ",
                    order = 2.3
                },
                missingGemsDesc = {
                    type = "description",
                    name = PGV_ColorText(L["add_socket_desc"], "Info"),
                    order = 2.4
                },
                emptySocketDesc = {
                    type = "description",
                    name = PGV_ColorText(L["empty_socket_desc"], "Info"),
                    order = 2.5
                }
            }
        },
        enchantOptions = {
            type = "group",
            name = L["Enchants"],
            order = 3,
            args = {
                enchScale = {
                    type = "range",
                    name = L["Font Scale"],
                    desc = L["ench_font_scale_desc"],
                    order = 1,
                    min = 0.1,
                    max = 2,
                    step = 0.05,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val) AddOn.db.profile[item[#item]] = val end,
                    disabled = function() return not AddOn.db.profile.showEnchants end
                },
                spacer = {
                    type = "description",
                    name = " ",
                    order = 2
                },
                showMissingEnchants = {
                    type = "toggle",
                    name = L["Missing Enchant Indicator"],
                    desc = L["missing_ench_desc"],
                    order = 2.1,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val) AddOn.db.profile[item[#item]] = val end,
                    disabled = function() return not AddOn.db.profile.showEnchants end
                },
                missingEnchantsMaxLevelOnly = {
                    type = "toggle",
                    name = L["Only Show Missing Enchants for Max Level"],
                    desc = L["missing_ench_max_lvl_desc"],
                    width = "double",
                    order = 2.2,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val) AddOn.db.profile[item[#item]] = val end,
                    disabled = function() return not AddOn.db.profile.showEnchants or (AddOn.db.profile.showEnchants and not AddOn.db.profile.showMissingEnchants) end
                },
                spacerTwo = {
                    type = "description",
                    name = " ",
                    order = 2.3
                },
                enchTextColorOptionsDesc = {
                    type = "description",
                    name = L["ench_color_opts_desc"],
                    order = 3
                },
                spacerThree = {
                    type = "description",
                    name = " ",
                    order = 4
                },
                useCustomColorForEnchants = {
                    type = "toggle",
                    name = L["Use Custom Color"],
                    width = "full",
                    desc = L["ench_use_custom_color_desc"],
                    order = 5,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val) AddOn.db.profile[item[#item]] = val end,
                    disabled = function() return not AddOn.db.profile.showEnchants end
                },
                customColorDesc = {
                    type = "description",
                    name = "\n"..L["custom_color_desc"].."\n"..L["custom_color_instruction"].."\n\n",
                    order = 6
                },
                enchCustomColor = {
                    type = "color",
                    name = L["Choose a Color"],
                    order = 7,
                    hasAlpha = false,
                    get = function(item)
                        if not AddOn.db.profile[item[#item]] then AddOn.db.profile[item[#item]] = AddOn.PGVHexColors.Uncommon end
                        local hex = AddOn.db.profile[item[#item]]
                        return AddOn.PGV_ConvertHexToRGB(hex)
                    end,
                    set = function(item, r, g, b)
                        AddOn.db.profile[item[#item]] = AddOn.PGV_ConvertRGBToHex(r, g, b)
                        LibStub("AceConfigRegistry-3.0"):NotifyChange(addonName)
                        LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
                    end,
                    disabled = function() return not AddOn.db.profile.showEnchants or not AddOn.db.profile.useCustomColorForEnchants end
                },
                customColorHex = {
                    type = "input",
                    name = "",
                    width = "half",
                    order = 8,
                    get = function() return "#"..AddOn.db.profile.enchCustomColor end,
                    set = function(_, val)
                        -- Validate that the provided hex code can be converted to an RGB color before setting
                        local r, g, b = AddOn.PGV_ConvertHexToRGB(val:gsub("#", ""))
                        if r ~= nil and g ~= nil and b ~= nil then
                            AddOn.db.profile.enchCustomColor = val:gsub("#", "")
                        end
                    end,
                    disabled = function() return not AddOn.db.profile.showEnchants or not AddOn.db.profile.useCustomColorForEnchants end
                },
                resetCustomColor = {
                    type = "execute",
                    name = L["Reset"],
                    width = "half",
                    order = 9,
                    func = function() AddOn.db.profile.enchCustomColor = AddOn.PGVHexColors.Uncommon end,
                    disabled = function()
                        local enchantsShown = AddOn.db.profile.showEnchants
                        local usingCustomEnchColor = AddOn.db.profile.useCustomColorForEnchants
                        local enchCustomColorIsDefault = enchantsShown and usingCustomEnchColor and AddOn.db.profile.enchCustomColor == AddOn.PGVHexColors.Uncommon
                        return not enchantsShown or not usingCustomEnchColor or enchCustomColorIsDefault
                    end
                }
            }
        },
        durabilityOptions = {
            type = "group",
            name = L["Durability"],
            order = 4,
            args = {
                durUsageDesc = {
                    type = "description",
                    name = PGV_ColorText(L["dur_hidden_at_100"], "Info"),
                    order = 1
                },
                spacer = {
                    type = "description",
                    name = " ",
                    order = 2
                },
                durabilityScale = {
                    type = "range",
                    name = L["Font Scale"],
                    desc = L["dur_font_scale_desc"],
                    order = 3,
                    min = 0.1,
                    max = 2,
                    step = 0.05,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val) AddOn.db.profile[item[#item]] = val end,
                    disabled = function() return not AddOn.db.profile.showDurability end
                }
            }
        },
        characterStatOptions = {
            type = "group",
            name = "Character Stats",
            order = 4.1,
            args = {
                statUsageDesc = {
                    type = "description",
                    name = PGV_ColorText("Customize the order of secondary and teritary stats when viewing the Character Info window by specialization", "Info"),
                    order = 1,
                },
                spacer = {
                    type = "description",
                    name = " ",
                    order = 1.1
                },
                specSelect = {
                    type = "select",
                    name = "Specialization",
                    desc = "",
                    order = 2,
                    values = function()
                        local options = {}
                        local specID = AddOn:GetCharacterCurrentSpecIDAndRole()
                        if not AddOn.SpecOptions[specID] then
                            options[0] = ""
                        end
                        for id, spec in pairs(AddOn.SpecOptions) do
                            local classFile = select(6, GetSpecializationInfoByID(id))
                            options[id] = "|A:classicon-"..classFile..":15:15|a "..spec
                        end
                        return options
                    end,
                    get = function()
                        if AddOn.db.profile.lastSelectedSpecID then
                            return AddOn.db.profile.lastSelectedSpecID
                        end

                        local specID = AddOn:GetCharacterCurrentSpecIDAndRole()
                        if AddOn.SpecOptions[specID] then
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
                secondaryStatsHeader = {
                    type = "header",
                    name = "Secondary Stats",
                    order = 2.1
                },
                [STAT_CRITICAL_STRIKE] = {
                    type = "input",
                    name = "Critical Strike",
                    order = 3.1,
                    width = "half",
                    get = function(item)
                        local specID = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return tostring(AddOn.db.profile.customSpecStatOrders[specID][item[#item]])
                    end,
                    set = function(item, val)
                        AddOn:SetStatOrderHandler(item, val)
                    end
                },
                [STAT_HASTE] = {
                    type = "input",
                    name = "Haste",
                    order = 3.2,
                    width = "half",
                    get = function(item)
                        local specID = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return tostring(AddOn.db.profile.customSpecStatOrders[specID][item[#item]])
                    end,
                    set = function(item, val)
                        AddOn:SetStatOrderHandler(item, val)
                    end
                },
                [STAT_MASTERY] = {
                    type = "input",
                    name = "Mastery",
                    order = 3.3,
                    width = "half",
                    get = function(item)
                        local specID = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return tostring(AddOn.db.profile.customSpecStatOrders[specID][item[#item]])
                    end,
                    set = function(item, val)
                        AddOn:SetStatOrderHandler(item, val)
                    end
                },
                [STAT_VERSATILITY] = {
                    type = "input",
                    name = "Versatility",
                    order = 3.4,
                    width = "half",
                    get = function(item)
                        local specID = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return tostring(AddOn.db.profile.customSpecStatOrders[specID][item[#item]])
                    end,
                    set = function(item, val)
                        AddOn:SetStatOrderHandler(item, val)
                    end
                },
                tertiaryStatsHeader = {
                    type = "header",
                    name = "Tertiary Stats",
                    order = 4
                },
                [STAT_LIFESTEAL] = {
                    type = "input",
                    name = "Leech",
                    order = 5.1,
                    width = "half",
                    get = function(item)
                        local specID = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return tostring(AddOn.db.profile.customSpecStatOrders[specID][item[#item]])
                    end,
                    set = function(item, val)
                        AddOn:SetStatOrderHandler(item, val)
                    end
                },
                [STAT_AVOIDANCE] = {
                    type = "input",
                    name = "Avoidance",
                    order = 5.2,
                    width = "half",
                    get = function(item)
                        local specID = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return tostring(AddOn.db.profile.customSpecStatOrders[specID][item[#item]])
                    end,
                    set = function(item, val)
                        AddOn:SetStatOrderHandler(item, val)
                    end
                },
                [STAT_SPEED] = {
                    type = "input",
                    name = "Speed",
                    order = 5.3,
                    width = "half",
                    get = function(item)
                        local specID = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return tostring(AddOn.db.profile.customSpecStatOrders[specID][item[#item]])
                    end,
                    set = function(item, val)
                        AddOn:SetStatOrderHandler(item, val)
                    end
                },
                tankOnlyHeader = {
                    type = "header",
                    name = "Tank-Specific Stats",
                    order = 6,
                    hidden = function()
                        local _, role = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return role ~= "TANK"
                    end
                },
                [STAT_DODGE] = {
                    type = "input",
                    name = "Dodge",
                    order = 7.1,
                    width = "half",
                    get = function(item)
                        local specID = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return tostring(AddOn.db.profile.customSpecStatOrders[specID][item[#item]])
                    end,
                    set = function(item, val)
                        AddOn:SetStatOrderHandler(item, val)
                    end,
                    hidden = function()
                        local _, role = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return role ~= "TANK"
                    end
                },
                [STAT_PARRY] = {
                    type = "input",
                    name = "Parry",
                    order = 7.2,
                    width = "half",
                    get = function(item)
                        local specID = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return tostring(AddOn.db.profile.customSpecStatOrders[specID][item[#item]])
                    end,
                    set = function(item, val)
                        AddOn:SetStatOrderHandler(item, val)
                    end,
                    hidden = function()
                        local _, role = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return role ~= "TANK"
                    end
                },
                [STAT_BLOCK] = {
                    type = "input",
                    name = "Block",
                    order = 7.3,
                    width = "half",
                    get = function(item)
                        local specID = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return tostring(AddOn.db.profile.customSpecStatOrders[specID][item[#item]])
                    end,
                    set = function(item, val)
                        AddOn:SetStatOrderHandler(item, val)
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
            order = 5,
            args = {
                iLvlOnItem = {
                    type = "toggle",
                    name = L["Alternate Item Level Placement"],
                    width = "full",
                    desc = L["alt_ilvl_placement_desc"].."\n\n"..L["ilvl_unchecked_info_text"],
                    order = 1,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val) AddOn.db.profile[item[#item]] = val end,
                    disabled = function() return not AddOn.db.profile.showiLvl end
                },
                showEmbellishments = {
                    type = "toggle",
                    name = L["Show Embellishments"],
                    width = "full",
                    desc = L["show_embellish_desc"],
                    order = 2,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val) AddOn.db.profile[item[#item]] = val end
                },
                hideShirtTabardInfo = {
                    type = "toggle",
                    name = L["Hide Shirt & Tabard Info"],
                    width = "full",
                    desc = L["hide_shirt_tabard_desc"],
                    order = 3,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val) AddOn.db.profile[item[#item]] = val end,
                    disabled = function() return not AddOn.db.profile.showiLvl and not AddOn.db.profile.showGems and not AddOn.db.profile.showEnchants end
                },
                debug = {
                    type = "toggle",
                    name = L["Debug Mode"],
                    desc = L["debug_mode_desc"].."\n\n"..PGV_ColorText(L["dont_enable_warning"], "DeathKnight"),
                    order = 4,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val) AddOn.db.profile[item[#item]] = val end
                },
            }
        }
    }
}

local Defaults = {
    profile = {
        showiLvl = true,
        showGems = true,
        showEnchants = true,
        showDurability = false,
        debug = false,
        iLvlScale = 1,
        showUpgradeTrack = true,
        useQualityColorForILvl = true,
        useClassColorForILvl = false,
        useCustomColorForILvl = false,
        iLvlCustomColor = AddOn.PGVHexColors.Priest,
        gemScale = 1,
        showMissingGems = true,
        missingGemsMaxLevelOnly = true,
        enchScale = 1,
        durabilityScale = 1,
        useCustomColorForEnchants = false,
        enchCustomColor = AddOn.PGVHexColors.Uncommon,
        showMissingEnchants = true,
        missingEnchantsMaxLevelOnly = true,
        lastSelectedSpecID = nil,
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
			desc = L["config_desc"],
			func = function() Settings.OpenToCategory(addonName) end,
		},
        ilvl = {
            type = "toggle",
            name = "ilvl",
            desc = L["ilvl_desc"],
            get = function() return AddOn.db.profile.showiLvl end,
	        set = function()
                AddOn.db.profile.showiLvl = not AddOn.db.profile.showiLvl
                LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
                if PaperDollFrame:IsVisible() then
                    PGV_DebugPrint("Toggled item level with slash command, updating character window")
                    AddOn:UpdateEquippedGearInfo();
                end
            end
        },
        gems = {
            type = "toggle",
            name = "gems",
            desc = L["gems_desc"],
            get = function() return AddOn.db.profile.showGems end,
	        set = function()
                AddOn.db.profile.showGems = not AddOn.db.profile.showGems
                LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
                if PaperDollFrame:IsVisible() then
                    PGV_DebugPrint("Toggled gems with slash command, updating character window")
                    AddOn:UpdateEquippedGearInfo();
                end
            end
        },
        ench = {
            type = "toggle",
            name = "ench",
            desc = L["ench_desc"],
            get = function() return AddOn.db.profile.showEnchants end,
	        set = function()
                AddOn.db.profile.showEnchants = not AddOn.db.profile.showEnchants
                LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
                if PaperDollFrame:IsVisible() then
                    PGV_DebugPrint("Toggled enchants with slash command, updating character window")
                    AddOn:UpdateEquippedGearInfo();
                end
            end
        },
        dur = {
            type = "toggle",
            name = "dur",
            desc = L["dur_desc"],
            get = function() return AddOn.db.profile.showDurability end,
            set = function()
                AddOn.db.profile.showDurability = not AddOn.db.profile.showDurability
                LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
                if PaperDollFrame:IsVisible() then
                    PGV_DebugPrint("Toggled durability with slash command, updating character window")
                    AddOn:UpdateEquippedGearInfo();
                end
            end
        },
        etext = {
            type = "toggle",
            name = "etext",
            desc = L["etext_desc"],
            get = function() return AddOn.db.profile.collapseEnchants end,
            set = function()
                AddOn.db.profile.collapseEnchants = not AddOn.db.profile.collapseEnchants
                LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
                if PaperDollFrame:IsVisible() then
                    PGV_DebugPrint("Toggled enchant text with slash command, updating character window")
                    AddOn:UpdateEquippedGearInfo();
                end
            end
        },
        debug = {
            type = "toggle",
            name = "debug",
            desc = L["debug_desc"]
        }
	},
}

local SlashCmds = { "prangearview", "pgv" }

function AddOn:OnInitialize()
    -- Load database
	self.db = LibStub("AceDB-3.0"):New("PranGearViewDB", Defaults, true)
    PGV_DebugPrint("self.db", self.db)
    AddOn.PGV_DebugTable(self.db)

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
        PGV_DebugPrint("Enchant text is collapsed, update button text accordingly")
        AddOn.PGVToggleEnchantButton:UpdateText(L["Show Enchant Text"])
    end

    AddOn.PGVToggleEnchantButton:SetScript("OnClick", function(self, button, down)
        local collapseEnchants = not AddOn.db.profile.collapseEnchants
        AddOn.db.profile.collapseEnchants = collapseEnchants
        AddOn.UpdateEquippedGearInfo(AddOn)
        self:UpdateText(collapseEnchants and L["Show Enchant Text"] or L["Hide Enchant Text"])
    end)

    self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", "HandleEquipmentChange")
    self:RegisterEvent("UPDATE_INVENTORY_DURABILITY", "HandleEquipmentChange")
    self:RegisterEvent("SOCKET_INFO_ACCEPT", "HandleEquipmentChange")

    -- Necessary to create DB entries for stat ordering when playing a new class/specialization
    self:RegisterEvent("PLAYER_ENTERING_WORLD", function() self:InitializeCustomSpecStatOrderDB() end)
    self:RegisterEvent("ACTIVE_PLAYER_SPECIALIZATION_CHANGED", function() self:InitializeCustomSpecStatOrderDB() end)
    PGV_DebugPrint(PGV_ColorText(addonName, "Heirloom"), "initialized successfully")

    hooksecurefunc(CharacterFrame, "ShowSubFrame", function(_, subFrame)
        if subFrame == "PaperDollFrame" then
            self:UpdateEquippedGearInfo()
            -- self:ReorderStatFramesBySpec()
        end
    end)

    hooksecurefunc("PaperDollFrame_UpdateStats", function()
        self:ReorderStatFramesBySpec()
    end)

    -- Whenever the options window is opened, clear the lastSelectedSpecID entry from the database so that
    -- it shows the character's current specialization options by default
    SettingsPanel:SetScript("OnShow", function()
        local specID = AddOn.GetCharacterCurrentSpecIDAndRole(AddOn)
        if AddOn.SpecOptions[specID] and specID ~= AddOn.db.profile.lastSelectedSpecID then
            AddOn.db.profile.lastSelectedSpecID = specID
        else
            AddOn.db.profile.lastSelectedSpecID = nil
        end
        LibStub("AceConfigRegistry-3.0"):NotifyChange(addonName)
        LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
    end)
end

function AddOn:HandleEquipmentChange()
    if PaperDollFrame:IsVisible() then
        PGV_DebugPrint("Changed equipped item, updating gear information")
        self:UpdateEquippedGearInfo();
    end
end

function AddOn:UpdateEquippedGearInfo()
    if not AddOn.GearSlots then
        PGV_DebugPrint("Gear slots table not found")
        return
    end
    
    PGV_DebugPrint("Enchants collapsed:", self.db.profile.collapseEnchants)
    for _, slot in ipairs(AddOn.GearSlots) do
        local slotID = slot:GetID()
        if self.db.profile.showiLvl then
            if not slot.PGVItemLevel then
                slot.PGVItemLevel = slot:CreateFontString("PGVItemLevel"..slotID, "OVERLAY", "GameTooltipText")
            end
            -- Outline text when placed on the gear icon
            if self.db.profile.iLvlOnItem then
                local iFont, iSize = slot.PGVItemLevel:GetFont()
                slot.PGVItemLevel:SetFont(iFont, iSize, "THICKOUTLINE")
            else
                slot.PGVItemLevel:SetFontObject("GameTooltipText")
            end
            slot.PGVItemLevel:SetFormattedText("")
            local iLvlTextScale = 1
            if self.db.profile.iLvlScale and self.db.profile.iLvlScale > 0 then
                iLvlTextScale = iLvlTextScale * self.db.profile.iLvlScale
            end
            slot.PGVItemLevel:SetTextScale(iLvlTextScale)

            self:GetItemLevelBySlot(slot)
            self:SetItemLevelPositionBySlot(slot)
        end

        if self.db.profile.showGems then
            if not slot.PGVGems then
                slot.PGVGems = slot:CreateFontString("PGVGems"..slotID, "OVERLAY", "GameTooltipText")
            end
            slot.PGVGems:SetFormattedText("")
            local gemScale = 1
            if self.db.profile.gemScale and self.db.profile.gemScale > 0 then
                gemScale = gemScale * self.db.profile.gemScale
            end
            slot.PGVGems:SetTextScale(gemScale)

            self:GetGemsBySlot(slot)
            self:SetGemsPositionBySlot(slot)
        end

        if self.db.profile.showEnchants then
            if not slot.PGVEnchant then
                slot.PGVEnchant = slot:CreateFontString("PGVEnchant"..slotID, "OVERLAY", "GameTooltipText")
            end
            slot.PGVEnchant:SetFormattedText("")
            local enchTextScale = 0.9
            if self.db.profile.enchScale and self.db.profile.enchScale > 0 then
                enchTextScale = enchTextScale * self.db.profile.enchScale
            end
            slot.PGVEnchant:SetTextScale(enchTextScale)

            self:GetEnchantmentBySlot(slot)
            self:PGV_SetEnchantPositionBySlot(slot)
        end
        
        if self.db.profile.showDurability then
            self:ShowDurabilityBySlot(slot)
        end

        if self.db.profile.showEmbellishments then
            self:ShowEmbellishmentBySlot(slot)
        end

        if self.db.profile.hideShirtTabardInfo and (slot == CharacterShirtSlot or slot == CharacterTabardSlot) then
            if slot.PGVItemLevel then slot.PGVItemLevel:SetFormattedText("") end
            if slot.PGVGems then slot.PGVGems:SetFormattedText("") end
            if slot.PGVEnchant then slot.PGVEnchant:SetFormattedText("") end
        end
    end
end

------------ Information Functions ------------
function AddOn:GetItemLevelBySlot(slot)
    local hasItem, item = AddOn.PGV_IsItemEquippedInSlot(slot)
    if hasItem then
        local ilvl = item:GetCurrentItemLevel()
        if ilvl > 0 then -- positive value indicates item info has loaded
            local iLvlText = ilvl
            if self.db.profile.showUpgradeTrack then
                local tooltip = C_TooltipInfo.GetHyperlink(item:GetItemLink())
                if tooltip and tooltip.lines then
                    for _, ttdata in pairs(tooltip.lines) do
                        -- Tooltip data type 42 is upgrade track
                        if ttdata and ttdata.type and ttdata.type == 42 then
                            local upgradeText = ttdata.leftText
                            for _, repl in pairs(AddOn.UpgradeTextReplace) do
                                upgradeText = upgradeText:gsub(repl.original, repl.replacement)
                            end
                            PGV_DebugPrint("Upgrade track for item", PGV_ColorText(slot:GetID(), "Heirloom"), "=", upgradeText)
                            iLvlText = iLvlText.." ("..upgradeText..")"
                        end
                    end
                end
            end

            if self.db.profile.useQualityColorForILvl then
                local qualityHex = select(4, GetItemQualityColor(item:GetItemQuality()))
                iLvlText = "|c"..qualityHex..iLvlText.."|r"
            elseif self.db.profile.useClassColorForILvl then
                local classFile = select(2, UnitClass("player"))
                local classHexWithAlpha = select(4, GetClassColor(classFile))
                iLvlText = "|c"..classHexWithAlpha..iLvlText.."|r"
            elseif self.db.profile.useCustomColorForILvl then
                iLvlText = PGV_ColorText(iLvlText, self.db.profile.iLvlCustomColor)
            end

            PGV_DebugPrint("Item Level text for slot", PGV_ColorText(slot:GetID(), "Heirloom"), "=", iLvlText)
            slot.PGVItemLevel:SetFormattedText(iLvlText)
        else
            PGV_DebugPrint("Item Level less than 0 found, retry self:GetItemLevelBySlot for slot", PGV_ColorText(slot:GetID(), "Heirloom"))
            C_Timer.After(0.5, function() self:GetItemLevelBySlot(slot) end)
        end
    end
end

function AddOn:GetGemsBySlot(slot)
    local hasItem, item = AddOn.PGV_IsItemEquippedInSlot(slot)
    if hasItem then
        local existingSocketCount = 0
        local gemText = ""
        local tooltip = C_TooltipInfo.GetHyperlink(item:GetItemLink())
        if tooltip and tooltip.lines then
            for _, ttdata in pairs(tooltip.lines) do
                -- Tooltip data type 3 is gem
                if ttdata and ttdata.type and ttdata.type == 3 then
                    -- Socketed item will have gemIcon variable
                    if ttdata.gemIcon then
                        local icon = ttdata.gemIcon
                        gemText = slot.IsLeftSide and gemText.." |T"..icon..":15:15|t" or "|T"..icon..":15:15|t "..gemText
                    else -- This indicates that there is an empty socket on the item
                        gemText = slot.IsLeftSide and gemText.." |T458977:15:15|t" or "|T458977:15:15|t "..gemText
                    end
                    existingSocketCount = existingSocketCount + 1
                end
            end
        end

        -- Indicates slots that can have sockets added to them
        if self.db.profile.showMissingGems and AddOn.PGV_IsSocketableSlot(slot) and existingSocketCount < AddOn.CurrentExpac.MaxSocketsPerItem then
            local isCharacterMaxLevel = UnitLevel("player") == AddOn.CurrentExpac.LevelCap
            if (self.db.profile.missingGemsMaxLevelOnly and isCharacterMaxLevel) or not self.db.profile.missingGemsMaxLevelOnly then
                for i = 1, AddOn.CurrentExpac.MaxSocketsPerItem - existingSocketCount, 1 do
                    PGV_DebugPrint("Slot", PGV_ColorText(slot:GetID(), "Heirloom"), "can add", i, i == 1 and "socket" or "sockets")
                    gemText = slot.IsLeftSide and gemText.." |A:Socket-Prismatic-Closed:15:15|a" or "|A:Socket-Prismatic-Closed:15:15|a "..gemText
                end
            end
        end
        slot.PGVGems:SetFormattedText(gemText)
    end
end

function AddOn:GetEnchantmentBySlot(slot)
    local hasItem, item = AddOn.PGV_IsItemEquippedInSlot(slot)
    if hasItem then
        local isEnchanted = false
        local eFont, eSize = slot.PGVEnchant:GetFont()
        local tooltip = C_TooltipInfo.GetHyperlink(item:GetItemLink())
        if tooltip and tooltip.lines then
            for _, ttdata in pairs(tooltip.lines) do
                -- Tooltip data type 15 is enchant
                if ttdata and ttdata.type and ttdata.type == 15 then
                    PGV_DebugPrint("Item in slot", PGV_ColorText(slot:GetID(), "Heirloom"), "is enchanted")
                    local enchText = ttdata.leftText
                    PGV_DebugPrint("Original enchantment text:", PGV_ColorText(enchText, "Uncommon"))
                    for _, repl in pairs(AddOn.EnchantTextReplace) do
                        enchText = enchText:gsub(repl.original, repl.replacement)
                    end
                    -- Resize any textures in the enchantment text
                    local texture = enchText:match("|A:(.-):")
                    -- If the preference is to hide enchant text, only show the enchant quality
                    if self.db.profile.collapseEnchants then
                        enchText = "|A:"..texture..":15:15:0:0|a"
                    else
                        enchText = enchText:gsub("|A:.-|a", "|A:"..texture..":15:15:0:0|a")
                    end
                    PGV_DebugPrint("Abbreviated enchantment text:", PGV_ColorText(enchText, "Uncommon"))
    
                    if self.db.profile.useCustomColorForEnchants then
                        slot.PGVEnchant:SetFormattedText(PGV_ColorText(enchText, self.db.profile.enchCustomColor))
                    else
                        slot.PGVEnchant:SetFormattedText(PGV_ColorText(enchText, "Uncommon"))
                    end
                    slot.PGVEnchant:SetFont(eFont, eSize)
                    isEnchanted = true
                end
            end
        end

        if not isEnchanted and AddOn.PGV_IsEnchantableSlot(slot) and self.db.profile.showMissingEnchants then
            local isCharacterMaxLevel = UnitLevel("player") == AddOn.CurrentExpac.LevelCap
            if (self.db.profile.missingEnchantsMaxLevelOnly and isCharacterMaxLevel) or not self.db.profile.missingEnchantsMaxLevelOnly then
                if self.db.profile.collapseEnchants then
                    slot.PGVEnchant:SetFormattedText("|T523826:15:15|t")
                else
                    slot.PGVEnchant:SetFormattedText("|T523826:15:15|t "..PGV_ColorText(L["Enchant"], "Druid"))
                end
                slot.PGVEnchant:SetFont(eFont, eSize, "OUTLINE")
            end
        end
    end
end

function AddOn:ShowDurabilityBySlot(slot)
    local hasItem = AddOn.PGV_IsItemEquippedInSlot(slot)
    if hasItem then
        local cDur, mDur = GetInventoryItemDurability(slot:GetID())
        if cDur and mDur then
            if not slot.PGVDurability then
                slot.PGVDurability = slot:CreateFontString("PGVDurability"..slot:GetID(), "OVERLAY", "GameTooltipText")
            end
            local dFont, dSize = slot.PGVDurability:GetFont()
            slot.PGVDurability:SetFont(dFont, dSize, "OUTLINE")
            slot.PGVDurability:SetFormattedText("")
            local durTextScale = 0.9
            if self.db.profile.durabilityScale and self.db.profile.durabilityScale > 0 then
                durTextScale = durTextScale * self.db.profile.durabilityScale
            end
            slot.PGVDurability:SetTextScale(durTextScale)
            slot.PGVDurability:SetPoint("CENTER", slot, "BOTTOM", 0, 5)

            local durText = ""
            local percent = AddOn.PGV_RoundNumber((cDur / mDur) * 100)
            if percent < 100 and percent > 50 then
                durText = PGV_ColorText(percent.."%%", "Uncommon")
            elseif percent < 100 and percent > 25 then
                durText = PGV_ColorText(percent.."%%", "Info")
            elseif percent < 100 and percent > 0 then
                durText = PGV_ColorText(percent.."%%", "Legendary")
            elseif percent == 0 then
                durText = PGV_ColorText(percent.."%%", "DeathKnight")
            end
            PGV_DebugPrint("Durability for slot", PGV_ColorText(slot:GetID(), "Heirloom"), "=", durText)
            slot.PGVDurability:SetFormattedText(durText)
        end
    else
        PGV_DebugPrint("Slot", PGV_ColorText(slot:GetID(), "Heirloom"), "does not have an item equipped")
    end
end

function AddOn:ShowEmbellishmentBySlot(slot)
    local hasItem, item = AddOn.PGV_IsItemEquippedInSlot(slot)
    if hasItem then
        local tooltip = C_TooltipInfo.GetHyperlink(item:GetItemLink())
        if tooltip and tooltip.lines then
            for _, ttdata in pairs(tooltip.lines) do
                if ttdata and ttdata.leftText:find("Embellished") then
                    if not slot.PGVEmbellishmentTexture then
                        PGV_DebugPrint("Creating embellishment texture in slot", PGV_ColorText(slot:GetID(), "Heirloom"))
                        slot.PGVEmbellishmentTexture = slot:CreateTexture("PGVEmbellishmentTexture"..slot:GetID(), "OVERLAY")
                    end
                    slot.PGVEmbellishmentTexture:SetSize(20, 20)
                    slot.PGVEmbellishmentTexture:ClearAllPoints()
                    if self.db.profile.showiLvl and self.db.profile.iLvlOnItem then
                        slot.PGVEmbellishmentTexture:SetPoint("BOTTOMLEFT", slot, "BOTTOMLEFT", 0, -5)
                    else
                        slot.PGVEmbellishmentTexture:SetPoint("TOPLEFT", slot, "TOPLEFT", 0, 0)
                    end
                    slot.PGVEmbellishmentTexture:SetTexture(1342533) -- Interface/LootFrame/Toast-Star
                    slot.PGVEmbellishmentTexture:SetVertexColor(0, 1, 0.6, 1)
                    PGV_DebugPrint("Showing embellishments enabled, embellishment found on slot |cFF00ccff"..slot:GetID().."|r")
                end
            end
        else
            PGV_DebugPrint("Tooltip information could not be obtained for slot |cFFc00ccff"..slot:GetID().."|r")
        end
    elseif slot.PGVEmbellishmentTexture then
        PGV_DebugPrint("Showing embellishments enabled, but found embellishment frame on unembellished item in slot |cFF00ccff"..slot:GetID().."|r")
    end
end

------------ Positioning Functions ------------
function AddOn:SetItemLevelPositionBySlot(slot)
    slot.PGVItemLevel:ClearAllPoints()

    if self.db.profile.iLvlOnItem then
        slot.PGVItemLevel:SetPoint("CENTER", slot, "TOP", 0, -10)
    elseif slot.IsLeftSide == nil then
        slot.PGVItemLevel:SetPoint("CENTER", slot, "TOP", 0, 10)
    else
        slot.PGVItemLevel:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, 0)
    end
end

function AddOn:SetGemsPositionBySlot(slot)
    slot.PGVGems:ClearAllPoints()

    if self.db.profile.showiLvl and self.db.profile.iLvlOnItem and slot.IsLeftSide == nil then
        slot.PGVGems:SetPoint("CENTER", slot, "TOP", 0, 10)
    elseif self.db.profile.showiLvl and self.db.profile.iLvlOnItem then
        slot.PGVGems:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, 0)
    elseif self.db.profile.showiLvl and slot.IsLeftSide == nil then
        slot.PGVGems:SetPoint("LEFT", slot.PGVItemLevel, "RIGHT", 0, 0)
    elseif self.db.profile.showiLvl then
        slot.PGVGems:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot.PGVItemLevel, slot.IsLeftSide and "RIGHT" or "LEFT", 0, 0)
    elseif slot.IsLeftSide == nil then
        slot.PGVGems:SetPoint("CENTER", slot, "TOP", 0, 10)
    else
        slot.PGVGems:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, 0)
    end
end

function AddOn:PGV_SetEnchantPositionBySlot(slot)
    slot.PGVEnchant:ClearAllPoints()

    local isSocketableSlot = AddOn.PGV_IsSocketableSlot(slot)
    local isEnchantableSlot = AddOn.PGV_IsEnchantableSlot(slot)
    local iLvlVisbleOnItem = self.db.profile.showiLvl and self.db.profile.iLvlOnItem and slot.PGVItemLevel
    local iLvlVisibleInDefaultLocation = self.db.profile.showiLvl and not self.db.profile.iLvlOnItem and slot.PGVItemLevel
    local defaultYOffset = (iLvlVisbleOnItem or (not iLvlVisibleInDefaultLocation and self.db.profile.showGems and not isSocketableSlot)) and 10 or 25

    if self.db.profile.collapseEnchants and slot.IsLeftSide == nil then
        -- Update positioning for main and off-hand slot enchants when collapsed
        PGV_DebugPrint("Adjusting positions for main and off-hand slots with enchant text collapsed")
        slot.PGVEnchant:SetPoint("CENTER", slot, "TOP", 0, defaultYOffset)
    elseif iLvlVisibleInDefaultLocation and slot.PGVItemLevel:GetText() ~= "" and slot.IsLeftSide ~= nil and isEnchantableSlot then
        -- Adjust positioning for slots that have both item level and enchants visible
        PGV_DebugPrint("ilvl and enchant visible")
        slot.PGVItemLevel:ClearAllPoints()
        slot.PGVItemLevel:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, slot:GetHeight() / 4)
        slot.PGVEnchant:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, (slot:GetHeight() / 4) * -1)
    elseif (not self.db.profile.showiLvl or iLvlVisbleOnItem) and slot.PGVGems and slot.PGVGems:GetText() ~= "" and self.db.profile.showGems and slot.IsLeftSide ~= nil and isSocketableSlot and isEnchantableSlot then
        -- Adjust positioning for slots that have both gems and enchants visible
        slot.PGVGems:ClearAllPoints()
        slot.PGVGems:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, slot:GetHeight() / 4)
        slot.PGVEnchant:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, (slot:GetHeight() / 4) * -1)
    elseif slot.IsLeftSide == nil then
        slot.PGVEnchant:SetPoint(slot == CharacterMainHandSlot and "RIGHT" or "LEFT", slot, slot == CharacterMainHandSlot and "TOPRIGHT" or "TOPLEFT", 0, 25)
    else
        slot.PGVEnchant:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, 0)
    end
end
