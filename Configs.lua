local addonName, AddOn = ...
---@class PranGearView
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

AddOn.DatabaseDefaults = {
    profile = {
        -- Item Level settings
        itemLevel = {
            show = true,
            scale = 1,
            outline = "",
            onItem = false,
            useQualityColor = true,
            useClassColor = false,
            useGradientColors = false,
            useCustomColor = false,
            customColor = AddOn.HexColorPresets.Priest,
        },
        -- Upgrade Track settings
        upgradeTrack = {
            show = true,
            scale = 1,
            outline = "",
            useQualityScaleColors = false,
            useCustomColor = false,
            customColor = AddOn.HexColorPresets.Priest,
        },
        -- Gem settings
        gems = {
            show = true,
            scale = 1,
            showMissing = true,
            missingMaxLevelOnly = true,
        },
        -- Enchant settings
        enchants = {
            show = true,
            scale = 1,
            outline = "OUTLINE",
            showMissing = true,
            missingMaxLevelOnly = true,
            collapse = false,
            showTextButton = true,
            useCustomColor = false,
            customColor = AddOn.HexColorPresets.Uncommon,
        },
        -- Durability settings
        durability = {
            show = false,
            scale = 1,
            showAsBar = false,
            colorHigh = AddOn.HexColorPresets.Uncommon,
            colorMedium = AddOn.HexColorPresets.Info,
            colorLow = AddOn.HexColorPresets.Error,
        },
        -- Inspect Window settings
        inspect = {
            show = false,
            showAvgILvl = true,
            includeAvgLabel = false,
            showILvl = true,
            showUpgradeTrack = true,
            showGems = true,
            showEnchants = true,
            showEmbellishments = true,
        },
        -- Character Stats settings
        characterStats = {
            showDecimals = false,
            decimalPlaces = 2,
            lastSelectedSpecID = nil,
            customSpecStatOrders = {},
        },
        -- General / UI settings
        general = {
            debug = false,
            showEmbellishments = true,
            showCharacteriLvlDecimal = false,
            decimalPlacesForCharacteriLvl = 2,
            hideShirtTabardInfo = false,
            increaseCharacterInfoSize = true,
            minimap = { hide = true },
        },
    }
}

-- Migration map: old flat key -> new nested path
local databaseMigrationMap = {
    showiLvl                            = { "itemLevel", "show" },
    iLvlScale                           = { "itemLevel", "scale" },
    iLvlOutline                         = { "itemLevel", "outline" },
    iLvlOnItem                          = { "itemLevel", "onItem" },
    useQualityColorForILvl              = { "itemLevel", "useQualityColor" },
    useClassColorForILvl                = { "itemLevel", "useClassColor" },
    useGradientColorsForILvl            = { "itemLevel", "useGradientColors" },
    useCustomColorForILvl               = { "itemLevel", "useCustomColor" },
    iLvlCustomColor                     = { "itemLevel", "customColor" },

    showUpgradeTrack                    = { "upgradeTrack", "show" },
    upgradeTrackScale                   = { "upgradeTrack", "scale" },
    upgradeTrackOutline                 = { "upgradeTrack", "outline" },
    useQualityScaleColorsForUpgradeTrack = { "upgradeTrack", "useQualityScaleColors" },
    useCustomColorForUpgradeTrack       = { "upgradeTrack", "useCustomColor" },
    upgradeTrackCustomColor             = { "upgradeTrack", "customColor" },

    showGems                            = { "gems", "show" },
    gemScale                            = { "gems", "scale" },
    showMissingGems                     = { "gems", "showMissing" },
    missingGemsMaxLevelOnly             = { "gems", "missingMaxLevelOnly" },

    showEnchants                        = { "enchants", "show" },
    enchScale                           = { "enchants", "scale" },
    enchantOutline                      = { "enchants", "outline" },
    showMissingEnchants                 = { "enchants", "showMissing" },
    missingEnchantsMaxLevelOnly         = { "enchants", "missingMaxLevelOnly" },
    collapseEnchants                    = { "enchants", "collapse" },
    showEnchantTextButton               = { "enchants", "showTextButton" },
    useCustomColorForEnchants           = { "enchants", "useCustomColor" },
    enchCustomColor                     = { "enchants", "customColor" },

    showDurability                      = { "durability", "show" },
    durabilityScale                     = { "durability", "scale" },
    showDurabilityAsBar                 = { "durability", "showAsBar" },
    durabilityColorHigh                 = { "durability", "colorHigh" },
    durabilityColorMedium               = { "durability", "colorMedium" },
    durabilityColorLow                  = { "durability", "colorLow" },

    showOnInspect                       = { "inspect", "show" },
    showInspectAvgILvl                  = { "inspect", "showAvgILvl" },
    includeAvgLabel                     = { "inspect", "includeAvgLabel" },
    showInspectiLvl                     = { "inspect", "showILvl" },
    showInspectUpgradeTrack             = { "inspect", "showUpgradeTrack" },
    showInspectGems                     = { "inspect", "showGems" },
    showInspectEnchants                 = { "inspect", "showEnchants" },
    showInspectEmbellishments           = { "inspect", "showEmbellishments" },

    showDecimalsForStats                = { "characterStats", "showDecimals" },
    decimalPlacesForStats               = { "characterStats", "decimalPlaces" },
    lastSelectedSpecID                  = { "characterStats", "lastSelectedSpecID" },
    customSpecStatOrders                = { "characterStats", "customSpecStatOrders" },

    debug                               = { "general", "debug" },
    showEmbellishments                  = { "general", "showEmbellishments" },
    showCharacteriLvlDecimal            = { "general", "showCharacteriLvlDecimal" },
    decimalPlacesForCharacteriLvl       = { "general", "decimalPlacesForCharacteriLvl" },
    hideShirtTabardInfo                 = { "general", "hideShirtTabardInfo" },
    increaseCharacterInfoSize           = { "general", "increaseCharacterInfoSize" },
    minimap                             = { "general", "minimap" },
}

---Migrates the saved profile from the old flat key structure to the new grouped structure.
---This only runs once per profile; the `_pgvMigrated` flag prevents re-migration.
---@param db AceDBObject-3.0 The AceDB database object
function AddOn:MigrateProfileSettings(db)
    local migratedProfiles = 0
    for _, profile in pairs(db.profiles) do
        if not profile._pgvMigrated then
            for oldKey, path in pairs(databaseMigrationMap) do
                if profile[oldKey] ~= nil then
                    local group, key = path[1], path[2]
                    if not profile[group] then profile[group] = {} end
                    profile[group][key] = profile[oldKey]
                    profile[oldKey] = nil
                end
            end
            self.DebugPrint("Migrated database profile from flat key to grouped key structure")
            profile._pgvMigrated = true
            migratedProfiles = migratedProfiles + 1
        end
    end
    if migratedProfiles > 0 then
        print(self.ColorText("["..addonName.."]", "Heirloom"), "AddOn database structure has been updated. This should not affect any of your profiles' settings.")
    end
end
