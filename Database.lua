local addonName, PGV = ...

PGV.DatabaseDefaults = {
    itemLevel = {
        show = true,
        scale = 1,
        outline = "",
        onItem = false,
        useQualityColor = true,
        useClassColor = false,
        useGradientColors = false,
        useCustomColor = false,
        customColor = PGV.HexColorPresets.Priest,
    },
    upgradeTrack = {
        show = true,
        scale = 1,
        outline = "",
        useQualityScaleColors = false,
        useCustomColor = false,
        customColor = PGV.HexColorPresets.Priest,
    },
    gems = {
        show = true,
        scale = 1,
        showMissing = true,
        missingMaxLevelOnly = true,
    },
    enchants = {
        show = true,
        scale = 1,
        outline = "OUTLINE",
        showMissing = true,
        missingMaxLevelOnly = true,
        collapse = false,
        showTextButton = true,
        useCustomColor = false,
        customColor = PGV.HexColorPresets.Uncommon,
    },
    durability = {
        show = false,
        scale = 1,
        showAsBar = false,
        colorHigh = PGV.HexColorPresets.Uncommon,
        colorMedium = PGV.HexColorPresets.Info,
        colorLow = PGV.HexColorPresets.Error,
    },
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
    characterStats = {
        showDecimals = false,
        decimalPlaces = 2,
        customSpecStatOrders = {},
    },
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

local function mergeDefaults(target, defaults)
    for key, value in pairs(defaults) do
        if type(value) == "table" then
            if type(target[key]) ~= "table" then
                target[key] = {}
            end
            mergeDefaults(target[key], value)
        elseif target[key] == nil then
            target[key] = value
        end
    end
    return target
end

local function migrateFromAceDB(source, target)
    if target.migratedFromAceDB then
        PGV.DebugPrint("Migration already ran, skipping")
        return
    end

    if not source or not source.profiles then
        PGV.DebugPrint("No AceDB profile data found to migrate")
        return
    end

    local charKey = UnitName("player").." - "..GetRealmName()
    local profileKey = source.profileKeys and source.profileKeys[charKey] or "Default"
    local profileData = source.profiles[profileKey] or source.profiles.Default or {}

    PGV.DebugPrint("Migrating AceDB profile", profileKey, "for", charKey)

    for key, value in pairs(profileData) do
        target[key] = value
    end

    target.migratedFromAceDB = true
end

PGV.RegisterEvent("ADDON_LOADED", function(loadedAddon)
    if loadedAddon ~= addonName then return end

    PGV.DebugPrint("ADDON_LOADED:", addonName)

    PranGearView_NewDB = PranGearView_NewDB or {}
    migrateFromAceDB(PranGearViewDB, PranGearView_NewDB)
    mergeDefaults(PranGearView_NewDB, PGV.DatabaseDefaults)

    PGV.db = PranGearView_NewDB
    PGV.DebugPrint("Database ready")

    PGV.UnregisterEvent("ADDON_LOADED")
end)
