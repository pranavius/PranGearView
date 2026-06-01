local addonName, AddOn = ...
---@class PranGearView
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)
local LDBIcon = LibStub("LibDBIcon-1.0")

local registry = LibStub("AceConfigRegistry-3.0")
local incrementSlashOptionOrder = CreateCounter()

-- Pure DB-key toggles: flip the boolean, notify, then trigger a redraw
local SlashToggleMap = {
    { key = "ilvl",    group = "itemLevel",    dbKey = "show",     desc = L["Toggle showing item level"] },
    { key = "track",   group = "upgradeTrack", dbKey = "show",     desc = L["Toggle showing upgrade track"] },
    { key = "gems",    group = "gems",          dbKey = "show",     desc = L["Toggle showing gem info"] },
    { key = "dur",     group = "durability",    dbKey = "show",     desc = L["Toggle showing durability percentages"] },
    { key = "etext",   group = "enchants",      dbKey = "collapse", desc = L["Toggle showing enchant text in the Character Info window"] },
    { key = "inspect", group = "inspect",       dbKey = "show",     desc = L["Toggle showing gear info when inspecting another player"] },
}

local args = {}
for _, toggle in ipairs(SlashToggleMap) do
    local group, dbKey = toggle.group, toggle.dbKey
    args[toggle.key] = {
        type  = "toggle",
        name  = toggle.key,
        desc  = toggle.desc,
        order = incrementSlashOptionOrder(),
        get   = function() return AddOn.db.profile[group][dbKey] end,
        set   = function()
            AddOn.db.profile[group][dbKey] = not AddOn.db.profile[group][dbKey]
            registry:NotifyChange("PGVOptions")
            AddOn:HandleEquipmentOrSettingsChange()
        end,
    }
end

-- Enchants toggle additionally syncs the enchant button visibility
args.ench = {
    type  = "toggle",
    name  = "ench",
    desc  = L["Toggle showing enchant info"],
    order = incrementSlashOptionOrder(),
    get   = function() return AddOn.db.profile.enchants.show end,
    set   = function()
        AddOn.db.profile.enchants.show = not AddOn.db.profile.enchants.show
        registry:NotifyChange("PGVOptions")
        AddOn:HandleEquipmentOrSettingsChange()
        if not AddOn.db.profile.enchants.show and AddOn.PGVToggleEnchantButton:IsShown() then
            AddOn.PGVToggleEnchantButton:Hide()
        elseif AddOn.db.profile.enchants.show and not AddOn.PGVToggleEnchantButton:IsShown() then
            AddOn.PGVToggleEnchantButton:Show()
        end
    end,
}

-- Expand toggle calls AdjustCharacterInfoWindowSize instead of HandleEquipmentOrSettingsChange
args.expand = {
    type  = "toggle",
    name  = "expand",
    desc  = L["Toggle using the larger Character Info window"],
    order = incrementSlashOptionOrder(),
    get   = function() return AddOn.db.profile.general.increaseCharacterInfoSize end,
    set   = function()
        AddOn.db.profile.general.increaseCharacterInfoSize = not AddOn.db.profile.general.increaseCharacterInfoSize
        registry:NotifyChange("PGVOptions")
        AddOn:AdjustCharacterInfoWindowSize()
    end,
}

-- Minimap toggle is inverted (hide=false means shown) and drives LDBIcon directly
args.minimap = {
    type  = "toggle",
    name  = "minimap",
    desc  = L["Show/hide the minimap icon"],
    order = incrementSlashOptionOrder(),
    get   = function() return not AddOn.db.profile.general.minimap.hide end,
    set   = function()
        AddOn.db.profile.general.minimap.hide = not AddOn.db.profile.general.minimap.hide
        if AddOn.db.profile.general.minimap.hide then
            LDBIcon:Hide(addonName)
        else
            LDBIcon:Show(addonName)
        end
        registry:NotifyChange("PGVOptions")
    end,
}

AddOn.SlashOptions = {
    type    = "group",
    handler = AddOn,
    get     = function() end,
    set     = function() end,
    args    = args,
}

AddOn.SlashCmds = { "prangearview", "pgv" }
