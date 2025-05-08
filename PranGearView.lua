local addonName, AddOn = ...
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
            set = function(item, val) AddOn.db.profile[item[#item]] = val end
        },
        showGems = {
            type = "toggle",
            name = L["Gems"],
            desc = L["Display gem and socket information for equipped items"],
            order = 4,
            get = function(item) return AddOn.db.profile[item[#item]] end,
            set = function(item, val) AddOn.db.profile[item[#item]] = val end
        },
        showEnchants = {
            type = "toggle",
            name = L["Enchants"],
            desc = L["Display enchant information for equipped items"],
            order = 5,
            get = function(item) return AddOn.db.profile[item[#item]] end,
            set = function(item, val)
                AddOn.db.profile[item[#item]] = val
                if not val and AddOn.PGVToggleEnchantButton:IsShown() then
                    AddOn.PGVToggleEnchantButton:Hide()
                elseif val and not AddOn.PGVToggleEnchantButton:IsShown() then
                    AddOn.PGVToggleEnchantButton:Show()
                end
            end
        },
        showDurability = {
            type = "toggle",
            name = L["Durability"],
            desc = L["Display durability percentages for equipped items"],
            order = 6,
            get = function(item) return AddOn.db.profile[item[#item]] end,
            set = function(item, val) AddOn.db.profile[item[#item]] = val end
        },
        divider = {
            type = "header",
            name = "",
            order = 7
        },
        iLvlOptions = {
            type = "group",
            name = L["Item Level"],
            order = 8,
            args = {
                iLvlScale = {
                    type = "range",
                    name = L["Font Scale"],
                    desc = L["Scale item level text size relative to the default"],
                    order = 8.01,
                    min = 0.1,
                    max = 2,
                    step = 0.05,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val) AddOn.db.profile[item[#item]] = val end,
                    disabled = function() return not AddOn.db.profile.showiLvl end
                },
                spacer = AddOn.CreateOptionsSpacer(8.02),
                showUpgradeTrack = {
                    type = "toggle",
                    name = L["Show Upgrade Track"],
                    desc = L["Display upgrade track and progress next to item level"],
                    order = 8.03,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val) AddOn.db.profile[item[#item]] = val end,
                    disabled = function() return not AddOn.db.profile.showiLvl end
                },
                iLvlColorOptionsDesc = {
                    type = "description",
                    name = ColorText(L["Item levels shown in white when no color options are selected"], "Info"),
                    order = 8.04
                },
                spacerTwo = AddOn.CreateOptionsSpacer(8.05),
                useQualityColorForILvl = {
                    type = "toggle",
                    name = L["Use Item Quality Color"],
                    desc = L["Color item levels based on item quality"],
                    order = 8.06,
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
                    desc = L["Color item levels based on the character's class"],
                    order = 8.07,
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
                    desc = L["Customize item level color"],
                    order = 8.08,
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
                    name = "\n"..L["Choose from the color picker or enter the hex code for a specific color."].."\n"..L["Color codes should be entered in the format #|cFFff3300RR|cFF1eff00GG|cFF0070ddBB|r"].."\n\n",
                    order = 8.09
                },
                iLvlCustomColor = {
                    type = "color",
                    name = L["Choose a Color"],
                    order = 8.1,
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
                    end,
                    disabled = function() return not AddOn.db.profile.showiLvl or not AddOn.db.profile.useCustomColorForILvl end
                },
                customColorHex = {
                    type = "input",
                    name = "",
                    width = "half",
                    order = 8.11,
                    get = function() return "#"..AddOn.db.profile.iLvlCustomColor end,
                    set = function(_, val)
                        -- Validate that the provided hex code can be converted to an RGB color before setting
                        local r, g, b = AddOn.ConvertHexToRGB(val:gsub("#", ""))
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
                    order = 8.12,
                    func = function() AddOn.db.profile.iLvlCustomColor = AddOn.HexColorPresets.Priest end,
                    disabled = function()
                        local itemLevelShown = AddOn.db.profile.showiLvl
                        local usingCustomColor = AddOn.db.profile.useCustomColorForILvl
                        local customColorIsDefault = itemLevelShown and usingCustomColor and AddOn.db.profile.iLvlCustomColor == AddOn.HexColorPresets.Priest
                        return not itemLevelShown or not usingCustomColor or customColorIsDefault
                    end
                }
            }
        },
        gemOptions = {
            type = "group",
            name = L["Gems"],
            order = 9,
            args = {
                gemScale = {
                    type = "range",
                    name = L["Icon Scale"],
                    desc = L["Scale gem icon size relative to the default"],
                    order = 9.01,
                    min = 0.1,
                    max = 2,
                    step = 0.05,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val) AddOn.db.profile[item[#item]] = val end,
                    disabled = function() return not AddOn.db.profile.showGems end
                },
                spacer = AddOn.CreateOptionsSpacer(9.02),
                showMissingGems = {
                    type = "toggle",
                    name = L["Show Missing Gems & Sockets"],
                    desc = L["Show when an item is missing gems or sockets"],
                    order = 9.03,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val) AddOn.db.profile[item[#item]] = val end,
                    disabled = function() return not AddOn.db.profile.showGems end
                },
                missingGemsMaxLevelOnly = {
                    type = "toggle",
                    name = L["Only Show for Max Level"],
                    desc = L["Hide missing gem & socket info for characters under the level cap"],
                    width = "double",
                    order = 9.04,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val) AddOn.db.profile[item[#item]] = val end,
                    disabled = function() return not AddOn.db.profile.showGems or (AddOn.db.profile.showGems and not AddOn.db.profile.showMissingGems) end
                },
                spacerTwo = AddOn.CreateOptionsSpacer(9.05),
                missingGemsDesc = {
                    type = "description",
                    name = ColorText(L["indicates that a socket can be added to the item"], "Info"),
                    order = 9.06
                },
                emptySocketDesc = {
                    type = "description",
                    name = ColorText(L["indicates an empty socket on the item"], "Info"),
                    order = 9.07
                }
            }
        },
        enchantOptions = {
            type = "group",
            name = L["Enchants"],
            order = 10,
            args = {
                enchScale = {
                    type = "range",
                    name = L["Font Scale"],
                    desc = L["Scale enchant text size relative to the default"],
                    order = 10.01,
                    min = 0.1,
                    max = 2,
                    step = 0.05,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val) AddOn.db.profile[item[#item]] = val end,
                    disabled = function() return not AddOn.db.profile.showEnchants end
                },
                spacer = AddOn.CreateOptionsSpacer(10.02),
                showMissingEnchants = {
                    type = "toggle",
                    name = L["Missing Enchant Indicator"],
                    desc = L["Show when an item is missing an enchant with a warning symbol"],
                    order = 10.03,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val) AddOn.db.profile[item[#item]] = val end,
                    disabled = function() return not AddOn.db.profile.showEnchants end
                },
                missingEnchantsMaxLevelOnly = {
                    type = "toggle",
                    name = L["Only Show for Max Level"],
                    desc = L["Hide missing enchant info for characters under the level cap"],
                    width = "double",
                    order = 10.04,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val) AddOn.db.profile[item[#item]] = val end,
                    disabled = function() return not AddOn.db.profile.showEnchants or (AddOn.db.profile.showEnchants and not AddOn.db.profile.showMissingEnchants) end
                },
                spacerTwo = AddOn.CreateOptionsSpacer(10.05),
                enchTextColorOptionsDesc = {
                    type = "description",
                    name = ColorText(L["Enchant quality symbol is not affected by the custom color option"], "Info"),
                    order = 10.06
                },
                spacerThree = AddOn.CreateOptionsSpacer(10.07),
                useCustomColorForEnchants = {
                    type = "toggle",
                    name = L["Use Custom Color"],
                    width = "full",
                    desc = L["Customize enchant text color"],
                    order = 10.08,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val) AddOn.db.profile[item[#item]] = val end,
                    disabled = function() return not AddOn.db.profile.showEnchants end
                },
                customColorDesc = {
                    type = "description",
                    name = "\n"..L["Choose from the color picker or enter the hex code for a specific color."].."\n"..L["Color codes should be entered in the format #|cFFff3300RR|cFF1eff00GG|cFF0070ddBB|r"].."\n\n",
                    order = 10.09
                },
                enchCustomColor = {
                    type = "color",
                    name = L["Choose a Color"],
                    order = 10.1,
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
                    end,
                    disabled = function() return not AddOn.db.profile.showEnchants or not AddOn.db.profile.useCustomColorForEnchants end
                },
                customColorHex = {
                    type = "input",
                    name = "",
                    width = "half",
                    order = 10.11,
                    get = function() return "#"..AddOn.db.profile.enchCustomColor end,
                    set = function(_, val)
                        -- Validate that the provided hex code can be converted to an RGB color before setting
                        local r, g, b = AddOn.ConvertHexToRGB(val:gsub("#", ""))
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
                    order = 10.12,
                    func = function() AddOn.db.profile.enchCustomColor = AddOn.HexColorPresets.Uncommon end,
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
            order = 11,
            args = {
                durUsageDesc = {
                    type = "description",
                    name = ColorText(L["Durability always hidden at 100%"], "Info"),
                    order = 11.01
                },
                spacer = AddOn.CreateOptionsSpacer(11.02),
                durabilityScale = {
                    type = "range",
                    name = L["Font Scale"],
                    desc = L["Scale durability text size relative to the default"],
                    order = 11.03,
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
            name = L["Character Stats"],
            order = 12,
            args = {
                statUsageDesc = {
                    type = "description",
                    name = ColorText(L["Customize secondary & tertiary stat order in the Character Info window by specialization"], "Info"),
                    order = 12.01,
                },
                spacer = AddOn.CreateOptionsSpacer(12.02),
                specSelect = {
                    type = "select",
                    name = L["Specialization"],
                    order = 12.03,
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
                resetButtonSpacer = {
                    type = "description",
                    name = " ",
                    order = 12.04,
                    width = "half"
                },
                resetOrderButton = {
                    type = "execute",
                    name = L["Reset"],
                    width = "half",
                    order = 12.05,
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
                postSpecSelectSpacer = AddOn.CreateOptionsSpacer(12.06),
                secondaryStatsHeader = {
                    type = "header",
                    name = L["Secondary Stats"],
                    order = 12.07
                },
                critStrikeLabel = {
                    type = "description",
                    name = ColorText(STAT_CRITICAL_STRIKE, "Info"),
                    order = 12.08,
                    width = "half"
                },
                [STAT_CRITICAL_STRIKE] = {
                    type = "select",
                    name = "",
                    order = 12.09,
                    width = 0.33,
                    values = function() return AddOn:GetStatOrderValuesHandler() end,
                    get = function(item) return AddOn:GetStatOrderHandler(item) end,
                    set = function(item, val) AddOn:SetStatOrderHandler(item, val) end
                },
                postCritSpacer = AddOn.CreateOptionsSpacer(12.1),
                hasteLabel = {
                    type = "description",
                    name = ColorText(STAT_HASTE, "Info"),
                    order = 12.11,
                    width = "half"
                },
                [STAT_HASTE] = {
                    type = "select",
                    name = "",
                    order = 12.12,
                    width = 0.33,
                    values = function() return AddOn:GetStatOrderValuesHandler() end,
                    get = function(item) return AddOn:GetStatOrderHandler(item) end,
                    set = function(item, val) AddOn:SetStatOrderHandler(item, val) end
                },
                postHasteSpacer = AddOn.CreateOptionsSpacer(12.13),
                masteryLabel = {
                    type = "description",
                    name = ColorText(STAT_MASTERY, "Info"),
                    order = 12.14,
                    width = "half"
                },
                [STAT_MASTERY] = {
                    type = "select",
                    name = "",
                    order = 12.15,
                    width = 0.33,
                    values = function() return AddOn:GetStatOrderValuesHandler() end,
                    get = function(item) return AddOn:GetStatOrderHandler(item) end,
                    set = function(item, val) AddOn:SetStatOrderHandler(item, val) end
                },
                postMastSpacer = AddOn.CreateOptionsSpacer(12.16),
                versLabel = {
                    type = "description",
                    name = ColorText(STAT_VERSATILITY, "Info"),
                    order = 12.17,
                    width = "half"
                },
                [STAT_VERSATILITY] = {
                    type = "select",
                    name = "",
                    order = 12.18,
                    width = 0.33,
                    values = function() return AddOn:GetStatOrderValuesHandler() end,
                    get = function(item) return AddOn:GetStatOrderHandler(item) end,
                    set = function(item, val) AddOn:SetStatOrderHandler(item, val) end
                },
                tertiaryStatsHeader = {
                    type = "header",
                    name = L["Tertiary Stats"],
                    order = 12.19
                },
                leechLabel = {
                    type = "description",
                    name = ColorText(STAT_LIFESTEAL, "Info"),
                    order = 12.2,
                    width = "half"
                },
                [STAT_LIFESTEAL] = {
                    type = "select",
                    name = "",
                    order = 12.21,
                    width = 0.33,
                    values = function() return AddOn:GetStatOrderValuesHandler() end,
                    get = function(item) return AddOn:GetStatOrderHandler(item) end,
                    set = function(item, val) AddOn:SetStatOrderHandler(item, val) end
                },
                postLeechSpacer = AddOn.CreateOptionsSpacer(12.22),
                avoidLabel = {
                    type = "description",
                    name = ColorText(STAT_AVOIDANCE, "Info"),
                    order = 12.23,
                    width = "half"
                },
                [STAT_AVOIDANCE] = {
                    type = "select",
                    name = "",
                    order = 12.24,
                    width = 0.33,
                    values = function() return AddOn:GetStatOrderValuesHandler() end,
                    get = function(item) return AddOn:GetStatOrderHandler(item) end,
                    set = function(item, val) AddOn:SetStatOrderHandler(item, val) end
                },
                postAvoidSpacer = AddOn.CreateOptionsSpacer(12.25),
                speedLabel = {
                    type = "description",
                    name = ColorText(STAT_SPEED, "Info"),
                    order = 12.26,
                    width = "half"
                },
                [STAT_SPEED] = {
                    type = "select",
                    name = "",
                    order = 12.27,
                    width = 0.33,
                    values = function() return AddOn:GetStatOrderValuesHandler() end,
                    get = function(item) return AddOn:GetStatOrderHandler(item) end,
                    set = function(item, val) AddOn:SetStatOrderHandler(item, val) end
                },
                tankOnlyHeader = {
                    type = "header",
                    name = L["Tank Stats"],
                    order = 12.28,
                    hidden = function()
                        local _, role = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return role ~= "TANK"
                    end
                },
                dodgeLabel = {
                    type = "description",
                    name = ColorText(STAT_DODGE, "Info"),
                    order = 12.29,
                    width = "half",
                    hidden = function()
                        local _, role = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return role ~= "TANK"
                    end
                },
                [STAT_DODGE] = {
                    type = "select",
                    name = "",
                    order = 12.3,
                    width = 0.33,
                    values = function() return AddOn:GetStatOrderValuesHandler() end,
                    get = function(item) return AddOn:GetStatOrderHandler(item) end,
                    set = function(item, val) AddOn:SetStatOrderHandler(item, val) end,
                    hidden = function()
                        local _, role = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return role ~= "TANK"
                    end
                },
                postDodgeSpacer = {
                    type = "description",
                    name = " ",
                    order = 12.31,
                    hidden = function()
                        local _, role = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return role ~= "TANK"
                    end
                },
                parryLabel = {
                    type = "description",
                    name = ColorText(STAT_PARRY, "Info"),
                    order = 12.32,
                    width = "half",
                    hidden = function()
                        local _, role = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return role ~= "TANK"
                    end
                },
                [STAT_PARRY] = {
                    type = "select",
                    name = "",
                    order = 12.33,
                    width = 0.33,
                    values = function() return AddOn:GetStatOrderValuesHandler() end,
                    get = function(item) return AddOn:GetStatOrderHandler(item) end,
                    set = function(item, val) AddOn:SetStatOrderHandler(item, val) end,
                    hidden = function()
                        local _, role = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return role ~= "TANK"
                    end
                },
                postParrySpacer = {
                    type = "description",
                    name = " ",
                    order = 12.34,
                    hidden = function()
                        local _, role = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return role ~= "TANK"
                    end
                },
                blockLabel = {
                    type = "description",
                    name = ColorText(STAT_BLOCK, "Info"),
                    order = 12.35,
                    width = "half",
                    hidden = function()
                        local _, role = AddOn:GetSpecAndRoleForSelectedCharacterStatsOption()
                        return role ~= "TANK"
                    end
                },
                [STAT_BLOCK] = {
                    type = "select",
                    name = "",
                    order = 12.36,
                    width = 0.33,
                    values = function() return AddOn:GetStatOrderValuesHandler() end,
                    get = function(item) return AddOn:GetStatOrderHandler(item) end,
                    set = function(item, val) AddOn:SetStatOrderHandler(item, val) end,
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
            order = 13,
            args = {
                iLvlOnItem = {
                    type = "toggle",
                    name = L["Alternate Item Level Placement"],
                    width = "full",
                    desc = L["Display item levels on top of equipment icons"].."\n\n"..L["Does nothing if the Item Level checkbox is unchecked"],
                    order = 13.1,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val) AddOn.db.profile[item[#item]] = val end,
                    disabled = function() return not AddOn.db.profile.showiLvl end
                },
                showEmbellishments = {
                    type = "toggle",
                    name = L["Show Embellishments"],
                    width = "full",
                    desc = L["Show a green star in the top-left corner of embellished equipment"],
                    order = 13.2,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val) AddOn.db.profile[item[#item]] = val end
                },
                hideShirtTabardInfo = {
                    type = "toggle",
                    name = L["Hide Shirt & Tabard Info"],
                    width = "full",
                    desc = L["Hide information for equipped shirt & tabard"],
                    order = 13.3,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val) AddOn.db.profile[item[#item]] = val end,
                    disabled = function() return not AddOn.db.profile.showiLvl and not AddOn.db.profile.showGems and not AddOn.db.profile.showEnchants end
                },
                debug = {
                    type = "toggle",
                    name = L["Debug Mode"],
                    desc = L["Display debugging messages in the default chat window"].."\n\n"..ColorText(L["You should never need to enable this"], "DeathKnight"),
                    order = 13.4,
                    get = function(item) return AddOn.db.profile[item[#item]] end,
                    set = function(item, val) AddOn.db.profile[item[#item]] = val end
                },
            }
        },
        credits = AddOn.BuildCreditsGroup()
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
        iLvlCustomColor = AddOn.HexColorPresets.Priest,
        gemScale = 1,
        showMissingGems = true,
        missingGemsMaxLevelOnly = true,
        enchScale = 1,
        durabilityScale = 1,
        useCustomColorForEnchants = false,
        enchCustomColor = AddOn.HexColorPresets.Uncommon,
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
			desc = L["Open the AddOn options window"],
			func = function() Settings.OpenToCategory(addonName) end,
		},
        ilvl = {
            type = "toggle",
            name = "ilvl",
            desc = L["Toggle showing item level info"],
            get = function() return AddOn.db.profile.showiLvl end,
	        set = function()
                AddOn.db.profile.showiLvl = not AddOn.db.profile.showiLvl
                LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
                if PaperDollFrame:IsVisible() then
                    DebugPrint("Toggled item level with slash command, updating character window")
                    AddOn:UpdateEquippedGearInfo();
                end
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
                if PaperDollFrame:IsVisible() then
                    DebugPrint("Toggled gems with slash command, updating character window")
                    AddOn:UpdateEquippedGearInfo();
                end
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
                if PaperDollFrame:IsVisible() then
                    DebugPrint("Toggled enchants with slash command, updating character window")
                    AddOn:UpdateEquippedGearInfo();
                end
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
                if PaperDollFrame:IsVisible() then
                    DebugPrint("Toggled durability with slash command, updating character window")
                    AddOn:UpdateEquippedGearInfo();
                end
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
                if PaperDollFrame:IsVisible() then
                    DebugPrint("Toggled enchant text with slash command, updating character window")
                    AddOn:UpdateEquippedGearInfo();
                end
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

    self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", "HandleEquipmentChange")
    self:RegisterEvent("UPDATE_INVENTORY_DURABILITY", "HandleEquipmentChange")
    self:RegisterEvent("SOCKET_INFO_ACCEPT", "HandleEquipmentChange")

    -- Necessary to create DB entries for stat ordering when playing a new class/specialization
    self:RegisterEvent("PLAYER_ENTERING_WORLD", function() self:InitializeCustomSpecStatOrderDB() end)
    self:RegisterEvent("ACTIVE_PLAYER_SPECIALIZATION_CHANGED", function() self:InitializeCustomSpecStatOrderDB() end)
    DebugPrint(ColorText(addonName, "Heirloom"), "initialized successfully")

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
        DebugPrint("Changed equipped item, updating gear information")
        self:UpdateEquippedGearInfo();
    end
end

function AddOn:UpdateEquippedGearInfo()
    if not AddOn.GearSlots then
        DebugPrint("Gear slots table not found")
        return
    end
    
    DebugPrint("Enchants collapsed:", self.db.profile.collapseEnchants)
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
    local hasItem, item = AddOn.IsItemEquippedInSlot(slot)
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
                            DebugPrint("Upgrade track for item", ColorText(slot:GetID(), "Heirloom"), "=", upgradeText)
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
                iLvlText = ColorText(iLvlText, self.db.profile.iLvlCustomColor)
            end

            DebugPrint("Item Level text for slot", ColorText(slot:GetID(), "Heirloom"), "=", iLvlText)
            slot.PGVItemLevel:SetFormattedText(iLvlText)
        else
            DebugPrint("Item Level less than 0 found, retry self:GetItemLevelBySlot for slot", ColorText(slot:GetID(), "Heirloom"))
            C_Timer.After(0.5, function() self:GetItemLevelBySlot(slot) end)
        end
    end
end

function AddOn:GetGemsBySlot(slot)
    local hasItem, item = AddOn.IsItemEquippedInSlot(slot)
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
                    else
                        -- This indicates that there is an empty socket on the item
                        -- Texture: Interface/ItemSocketingFrame/UI-EmptySocket-Prismatic
                        gemText = slot.IsLeftSide and gemText.." |T458977:15:15|t" or "|T458977:15:15|t "..gemText
                    end
                    existingSocketCount = existingSocketCount + 1
                end
            end
        end

        -- Indicates slots that can have sockets added to them
        if self.db.profile.showMissingGems and AddOn.IsSocketableSlot(slot) and existingSocketCount < AddOn.CurrentExpac.MaxSocketsPerItem then
            local isCharacterMaxLevel = UnitLevel("player") == AddOn.CurrentExpac.LevelCap
            if (self.db.profile.missingGemsMaxLevelOnly and isCharacterMaxLevel) or not self.db.profile.missingGemsMaxLevelOnly then
                for i = 1, AddOn.CurrentExpac.MaxSocketsPerItem - existingSocketCount, 1 do
                    DebugPrint("Slot", ColorText(slot:GetID(), "Heirloom"), "can add", i, i == 1 and "socket" or "sockets")
                    gemText = slot.IsLeftSide and gemText.." |A:Socket-Prismatic-Closed:15:15|a" or "|A:Socket-Prismatic-Closed:15:15|a "..gemText
                end
            end
        end
        slot.PGVGems:SetFormattedText(gemText)
    end
end

function AddOn:GetEnchantmentBySlot(slot)
    local hasItem, item = AddOn.IsItemEquippedInSlot(slot)
    if hasItem then
        local isEnchanted = false
        local eFont, eSize = slot.PGVEnchant:GetFont()
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
                        if enchText == AddOn.DKEnchantAbbr.Razorice then
                            texture = "|T135842:15:15|t" -- Interface/Icons/Spell_Frost_FrostArmor
                        elseif enchText == AddOn.DKEnchantAbbr.Sanguination then
                            texture = "|T1778226:15:15|t" -- Interface/Icons/Ability_Argus_DeathFod
                        elseif enchText == AddOn.DKEnchantAbbr.Spellwarding then
                            texture = "|T425952:15:15|t" -- Interface/Icons/Spell_Fire_TwilightFireward
                        elseif enchText == AddOn.DKEnchantAbbr.Apocalypse then
                            texture = "|T237535:15:15|t" -- Interface/Icons/Spell_DeathKnight_Thrash_Ghoul
                        elseif enchText == AddOn.DKEnchantAbbr.FallenCrusader then
                            texture = "|T135957:15:15|t" -- Interface/Icons/Spell_Holy_RetributionAura
                        elseif enchText == AddOn.DKEnchantAbbr.StoneskinGargoyle then
                            texture = "|T237480:15:15|t" -- Interface/Icons/Inv_Sword_130
                        elseif enchText == AddOn.DKEnchantAbbr.UnendingThirst then
                            texture = "|T3163621:15:15|t" -- Interface/Icons/Spell_NZInsanity_Bloodthirst
                        else
                            texture = "|T628564:15:15|t" -- Interface/Scenarios/ScenarioIcon-Check
                        end

                        enchText = self.db.profile.collapseEnchants and texture or (enchText.." "..texture)
                        -- If the preference is to hide enchant text, only show the enchant quality
                    elseif self.db.profile.collapseEnchants then
                        enchText = "|A:"..texture..":15:15:0:0|a"
                    else
                        enchText = enchText:gsub("|A:.-|a", "|A:"..texture..":15:15:0:0|a")
                    end
                    DebugPrint("Abbreviated enchantment text:", ColorText(enchText, "Uncommon"))
    
                    if self.db.profile.useCustomColorForEnchants then
                        slot.PGVEnchant:SetFormattedText(ColorText(enchText, self.db.profile.enchCustomColor))
                    else
                        slot.PGVEnchant:SetFormattedText(ColorText(enchText, "Uncommon"))
                    end
                    slot.PGVEnchant:SetFont(eFont, eSize)
                    isEnchanted = true
                end
            end
        end

        if not isEnchanted and AddOn.IsEnchantableSlot(slot) and self.db.profile.showMissingEnchants then
            local isCharacterMaxLevel = UnitLevel("player") == AddOn.CurrentExpac.LevelCap
            if (self.db.profile.missingEnchantsMaxLevelOnly and isCharacterMaxLevel) or not self.db.profile.missingEnchantsMaxLevelOnly then
                -- Texture: Interface/EncounterJournal/UI-EJ-WarningTextIcon
                if self.db.profile.collapseEnchants then
                    slot.PGVEnchant:SetFormattedText("|T523826:15:15|t")
                else
                    slot.PGVEnchant:SetFormattedText("|T523826:15:15|t "..ColorText(L["Enchant"], "Druid"))
                end
                slot.PGVEnchant:SetFont(eFont, eSize, "OUTLINE")
            end
        end
    end
end

function AddOn:ShowDurabilityBySlot(slot)
    local hasItem = AddOn.IsItemEquippedInSlot(slot)
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
            local percent = AddOn.RoundNumber((cDur / mDur) * 100)
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
        end
    else
        DebugPrint("Slot", ColorText(slot:GetID(), "Heirloom"), "does not have an item equipped")
    end
end

function AddOn:ShowEmbellishmentBySlot(slot)
    local hasItem, item = AddOn.IsItemEquippedInSlot(slot)
    if hasItem then
        local tooltip = C_TooltipInfo.GetHyperlink(item:GetItemLink())
        if tooltip and tooltip.lines then
            for _, ttdata in pairs(tooltip.lines) do
                if ttdata and ttdata.leftText:find("Embellished") then
                    if not slot.PGVEmbellishmentTexture then
                        DebugPrint("Creating embellishment texture in slot", ColorText(slot:GetID(), "Heirloom"))
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
                    DebugPrint("Showing embellishments enabled, embellishment found on slot |cFF00ccff"..slot:GetID().."|r")
                end
            end
        else
            DebugPrint("Tooltip information could not be obtained for slot |cFFc00ccff"..slot:GetID().."|r")
        end
    elseif slot.PGVEmbellishmentTexture then
        DebugPrint("Showing embellishments enabled, but found embellishment frame on unembellished item in slot |cFF00ccff"..slot:GetID().."|r")
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

    local isSocketableSlot = AddOn.IsSocketableSlot(slot)
    local isEnchantableSlot = AddOn.IsEnchantableSlot(slot)
    local iLvlVisbleOnItem = self.db.profile.showiLvl and self.db.profile.iLvlOnItem and slot.PGVItemLevel
    local iLvlVisibleInDefaultLocation = self.db.profile.showiLvl and not self.db.profile.iLvlOnItem and slot.PGVItemLevel
    local defaultYOffset = (iLvlVisbleOnItem or (not iLvlVisibleInDefaultLocation and self.db.profile.showGems and not isSocketableSlot)) and 10 or 25

    if self.db.profile.collapseEnchants and slot.IsLeftSide == nil then
        -- Update positioning for main and off-hand slot enchants when collapsed
        DebugPrint("Adjusting positions for main and off-hand slots with enchant text collapsed")
        slot.PGVEnchant:SetPoint("CENTER", slot, "TOP", 0, defaultYOffset)
    elseif iLvlVisibleInDefaultLocation and slot.PGVItemLevel:GetText() ~= "" and slot.IsLeftSide ~= nil and isEnchantableSlot then
        -- Adjust positioning for slots that have both item level and enchants visible
        DebugPrint("ilvl and enchant visible")
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
