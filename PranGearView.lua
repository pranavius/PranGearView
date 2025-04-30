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
                    name = "Show Upgrade Track",
                    desc = "Display the item's upgrade track and progress next to the item level",
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
                enchTextColorOptionsDesc = {
                    type = "description",
                    name = L["ench_color_opts_desc"],
                    order = 3
                },
                spacerTwo = {
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
        enchScale = 1,
        durabilityScale = 1,
        useCustomColorForEnchants = false,
        enchCustomColor = AddOn.PGVHexColors.Uncommon,
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
    PGV_DebugPrint(PGV_ColorText(addonName, "Heirloom"), "initialized successfully")

    hooksecurefunc(CharacterFrame, "ShowSubFrame", function(_, subFrame)
        if subFrame == "PaperDollFrame" then
            self:UpdateEquippedGearInfo()
        end
    end)
end

function AddOn:HandleEquipmentChange()
    if PaperDollFrame:IsVisible() then
        PGV_DebugPrint("Changed equipped item, updating gear information")
        self:UpdateEquippedGearInfo();
    end
end

function AddOn:UpdateEquippedGearInfo()
    PGV_DebugPrint("Enchants collapsed:", self.db.profile.collapseEnchants)
    local GEAR_SLOT_FRAMES = {
        CharacterHeadSlot,
        CharacterNeckSlot,
        CharacterShoulderSlot,
        CharacterBackSlot,
        CharacterChestSlot,
        CharacterShirtSlot,
        CharacterTabardSlot,
        CharacterWristSlot,
        CharacterHandsSlot,
        CharacterWaistSlot,
        CharacterLegsSlot,
        CharacterFeetSlot,
        CharacterFinger0Slot,
        CharacterFinger1Slot,
        CharacterTrinket0Slot,
        CharacterTrinket1Slot,
        CharacterMainHandSlot,
        CharacterSecondaryHandSlot
    }

    for _, slot in ipairs(GEAR_SLOT_FRAMES) do
        local slotID = slot:GetID()
        if self.db.profile.showiLvl then
            if not slot.ilvl then
                slot.ilvl = slot:CreateFontString("PGVItemLevelText"..slotID, "OVERLAY", "GameTooltipText")
            end
            -- Outline text when placed on the gear icon
            if self.db.profile.iLvlOnItem then
                local iFont, iSize = slot.ilvl:GetFont()
                slot.ilvl:SetFont(iFont, iSize, "THICKOUTLINE")
            else
                slot.ilvl:SetFontObject("GameTooltipText")
            end
            slot.ilvl:SetFormattedText("")
            local iLvlTextScale = 1
            if self.db.profile.iLvlScale and self.db.profile.iLvlScale > 0 then
                iLvlTextScale = iLvlTextScale * self.db.profile.iLvlScale
            end
            slot.ilvl:SetTextScale(iLvlTextScale)

            self:GetItemLevelBySlot(slot, true)
            self:SetItemLevelPositionBySlot(slot)
        elseif slot.ilvl then
            slot.ilvl = nil
        end

        if self.db.profile.showGems then
            if not slot.gems then
                slot.gems = slot:CreateFontString("PGVGemsText"..slotID, "OVERLAY", "GameTooltipText")
            end
            slot.gems:SetFormattedText("")
            local gemScale = 1
            if self.db.profile.gemScale and self.db.profile.gemScale > 0 then
                gemScale = gemScale * self.db.profile.gemScale
            end
            slot.gems:SetTextScale(gemScale)

            self:GetGemsBySlot(slot)
            self:SetGemsPositionBySlot(slot)
        elseif slot.gems then
            slot.gems = nil
        end

        if self.db.profile.showEnchants then
            if not slot.ench then
                slot.ench = slot:CreateFontString("PGVEnchantText"..slotID, "OVERLAY", "GameTooltipText")
            end
            slot.ench:SetFormattedText("")
            local enchTextScale = 0.9
            if self.db.profile.enchScale and self.db.profile.enchScale > 0 then
                enchTextScale = enchTextScale * self.db.profile.enchScale
            end
            slot.ench:SetTextScale(enchTextScale)

            self:GetEnchantmentBySlot(slot)
            self:PGV_SetEnchantPositionBySlot(slot)
        elseif slot.ench then
            slot.ench = nil
        end
        
        if self.db.profile.showDurability then
            self:ShowDurabilityBySlot(slot)
        elseif slot.dur then
            slot.dur = nil
        end

        if self.db.profile.showEmbellishments then
            self:ShowEmbellishmentBySlot(slot)
        elseif slot.emb then
            slot.emb = nil
        end

        if self.db.profile.hideShirtTabardInfo and (slot == CharacterShirtSlot or slot == CharacterTabardSlot) then
            if slot.ilvl then slot.ilvl:SetFormattedText("") end
            if slot.gems then slot.gems:SetFormattedText("") end
            if slot.ench then slot.ench:SetFormattedText("") end
        end
    end
end

------------ Information Functions ------------
function AddOn:GetItemLevelBySlot(slot, retry)
    if retry then
        local hasItem, item = AddOn.PGV_IsItemEquippedInSlot(slot)
        if hasItem then
            if self.db.profile.showiLvl then
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
                        local _, _, _, qualityHex = GetItemQualityColor(item:GetItemQuality())
                        iLvlText = "|c"..qualityHex..iLvlText.."|r"
                    elseif self.db.profile.useClassColorForILvl then
                        local _, classFile = UnitClass("player")
                        local _, _, _, classHex = GetClassColor(classFile)
                        iLvlText = PGV_ColorText(iLvlText, classHex)
                    elseif self.db.profile.useCustomColorForILvl then
                        iLvlText = PGV_ColorText(iLvlText, self.db.profile.iLvlCustomColor)
                    end
    
                    PGV_DebugPrint("Item Level text for slot", PGV_ColorText(slot:GetID(), "Heirloom"), "=", iLvlText)
                    slot.ilvl:SetFormattedText(iLvlText)
                else
                    PGV_DebugPrint("Item Level less than 0 found, retry self:GetItemLevelBySlot for slot", PGV_ColorText(slot:GetID(), "Heirloom"))
                    C_Timer.After(0.5, function() self:GetItemLevelBySlot(slot, true) end)
                end
            end
        end
    end
end

function AddOn:GetGemsBySlot(slot)
    local hasItem, item = AddOn.PGV_IsItemEquippedInSlot(slot)
    if hasItem then
        local gemText = ""
        local tooltip = C_TooltipInfo.GetHyperlink(item:GetItemLink())
        if tooltip and tooltip.lines then
            for _, ttdata in pairs(tooltip.lines) do
                -- Tooltip data type 3 is gem
                if ttdata and ttdata.type and ttdata.type == 3 then
                    local icon = ttdata.gemIcon
                    if icon then
                        gemText = slot.IsLeftSide and gemText.." |T"..icon..":15:15|t" or "|T"..icon..":15:15|t "..gemText
                    end
                end
            end
            slot.gems:SetFormattedText(gemText)
        end
    end
end

function AddOn:GetEnchantmentBySlot(slot)
    local hasItem, item = AddOn.PGV_IsItemEquippedInSlot(slot)
    if hasItem then
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
                        slot.ench:SetFormattedText(PGV_ColorText(enchText, self.db.profile.enchCustomColor))
                    else
                        slot.ench:SetFormattedText(PGV_ColorText(enchText, "Uncommon"))
                    end
                end
            end
        end
    end
end

function AddOn:ShowDurabilityBySlot(slot)
    local hasItem = AddOn.PGV_IsItemEquippedInSlot(slot)
    if hasItem then
        local cDur, mDur = GetInventoryItemDurability(slot:GetID())
        if cDur and mDur then
            if not slot.dur then
                slot.dur = slot:CreateFontString("PGVDurabilityText"..slot:GetID(), "OVERLAY", "GameTooltipText")
            end
            local dFont, dSize = slot.dur:GetFont()
            slot.dur:SetFont(dFont, dSize, "OUTLINE")
            slot.dur:SetFormattedText("")
            local durTextScale = 0.9
            if self.db.profile.durabilityScale and self.db.profile.durabilityScale > 0 then
                durTextScale = durTextScale * self.db.profile.durabilityScale
            end
            slot.dur:SetTextScale(durTextScale)
            slot.dur:SetPoint("CENTER", slot, "BOTTOM", 0, 5)

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
            slot.dur:SetFormattedText(durText)
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
            local markedEmbellished = false
            for _, ttdata in pairs(tooltip.lines) do
                if not markedEmbellished and ttdata and ttdata.leftText:find("Embellished") then
                    if not slot.emb then
                        slot.emb = CreateFrame("Frame", "PGVEmbellishmentFrame"..slot:GetID(), slot)
                    end
                    slot.emb:SetFrameStrata("MEDIUM")
                    slot.emb:SetSize(15, 15)
                    slot.emb:SetPoint("TOPLEFT", slot, "TOPLEFT", 0, 0)
                    if not slot.emb.texture then
                        slot.emb.texture = slot.emb:CreateTexture("PGVEmbellishmentTexture"..slot:GetID(), "OVERLAY")
                    end
                    slot.emb.texture:SetPoint("CENTER", slot.emb, "CENTER", 0, 0)
                    slot.emb.texture:SetTexture(650035) -- interface/buttons/greengradiant
                    slot.emb.texture:SetMask("Interface/LootFrame/Toast-Star")
                    slot.emb.texture:SetSize(15, 15)
                    PGV_DebugPrint("Showing embellishments enabled, embellishment found on slot |cFF00ccff"..slot:GetID().."|r")
                    markedEmbellished = true
                end
            end
        else
            PGV_DebugPrint("Tooltip information could not be obtained for slot |cFFc00ccff"..slot:GetID().."|r")
            slot.emb = nil
        end
    elseif slot.emb then
    PGV_DebugPrint("Showing embellishments enabled, but found embellishment frame on unembellished item in slot |cFF00ccff"..slot:GetID().."|r")
    slot.emb = nil
    end
end

------------ Positioning Functions ------------
function AddOn:SetItemLevelPositionBySlot(slot)
    slot.ilvl:ClearAllPoints()

    if self.db.profile.iLvlOnItem then
        slot.ilvl:SetPoint("CENTER", slot, "TOP", 0, -10)
    elseif slot.IsLeftSide == nil then
        slot.ilvl:SetPoint("CENTER", slot, "TOP", 0, 10)
    else
        slot.ilvl:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, 0)
    end
end

function AddOn:SetGemsPositionBySlot(slot)
    slot.gems:ClearAllPoints()

    if self.db.profile.showiLvl and self.db.profile.iLvlOnItem and slot.IsLeftSide == nil then
        slot.gems:SetPoint("CENTER", slot, "TOP", 0, 10)
    elseif self.db.profile.showiLvl and self.db.profile.iLvlOnItem then
        slot.gems:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, 0)
    elseif self.db.profile.showiLvl and slot.IsLeftSide == nil then
        slot.gems:SetPoint("LEFT", slot.ilvl, "RIGHT", 0, 0)
    elseif self.db.profile.showiLvl then
        slot.gems:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot.ilvl, slot.IsLeftSide and "RIGHT" or "LEFT", 0, 0)
    elseif slot.IsLeftSide == nil then
        slot.gems:SetPoint("CENTER", slot, "TOP", 0, 10)
    else
        slot.gems:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, 0)
    end
end

function AddOn:PGV_SetEnchantPositionBySlot(slot)
    slot.ench:ClearAllPoints()

    local isSocketableSlot = AddOn.PGV_IsSocketableSlot(slot)
    local isEnchantableSlot = AddOn.PGV_IsEnchantableSlot(slot)
    local iLvlVisbleOnItem = self.db.profile.showiLvl and self.db.profile.iLvlOnItem
    local iLvlVisibleInDefaultLocation = self.db.profile.showiLvl and not self.db.profile.iLvlOnItem
    local defaultYOffset = (iLvlVisbleOnItem or (not iLvlVisibleInDefaultLocation and self.db.profile.showGems and not isSocketableSlot)) and 10 or 25

    if self.db.profile.collapseEnchants and slot.IsLeftSide == nil then
        -- Update positioning for main and off-hand slot enchants when collapsed
        PGV_DebugPrint("Adjusting positions for main and off-hand slots with enchant text collapsed")
        slot.ench:SetPoint("CENTER", slot, "TOP", 0, defaultYOffset)
    elseif slot.ilvl:GetText() ~= "" and iLvlVisibleInDefaultLocation and slot.IsLeftSide ~= nil and isEnchantableSlot then
        -- Adjust positioning for slots that have both item level and enchants visible
        PGV_DebugPrint("ilvl and enchant visible")
        slot.ilvl:ClearAllPoints()
        slot.ilvl:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, slot:GetHeight() / 4)
        slot.ench:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, (slot:GetHeight() / 4) * -1)
    elseif (not self.db.profile.showiLvl or iLvlVisbleOnItem) and slot.gems:GetText() ~= "" and self.db.profile.showGems and slot.IsLeftSide ~= nil and isSocketableSlot and isEnchantableSlot then
        -- Adjust positioning for slots that have both gems and enchants visible
        slot.gems:ClearAllPoints()
        slot.gems:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, slot:GetHeight() / 4)
        slot.ench:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, (slot:GetHeight() / 4) * -1)
    elseif slot.IsLeftSide == nil then
        slot.ench:SetPoint(slot == CharacterMainHandSlot and "RIGHT" or "LEFT", slot, slot == CharacterMainHandSlot and "TOPRIGHT" or "TOPLEFT", 0, 25)
    else
        slot.ench:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, 0)
    end
end
