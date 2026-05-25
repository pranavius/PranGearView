local addonName, AddOn = ...
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)
---@cast AddOn PranGearView

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
