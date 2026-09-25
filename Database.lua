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
        forever_ShowAvgILvlOnCharacter = true,
        forever_IncludeAvgLabelOnCharacter = false,
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

-- AceDB stored settings under profiles[profileKey]; the current format is flat.
-- The presence of `profiles` marks a legacy DB, which is replaced by the active profile's data.
local function migrateFromAceDB(db)
    if not db.profiles then
        return db
    end

    local charKey = UnitName("player").." - "..GetRealmName()
    local profileKey = db.profileKeys and db.profileKeys[charKey] or "Default"
    local profileData = db.profiles[profileKey] or db.profiles.Default or {}

    PGV.DebugPrint("Migrating AceDB profile", profileKey, "for", charKey)

    return CopyTable(profileData)
end

PGV.RegisterEvent("ADDON_LOADED", function(loadedAddon)
    if loadedAddon ~= addonName then return end

    PGV.DebugPrint("ADDON_LOADED:", addonName)

    PranGearViewDB = migrateFromAceDB(PranGearViewDB or {})
    mergeDefaults(PranGearViewDB, PGV.DatabaseDefaults)

    PGV.db = PranGearViewDB
    PGV.DebugPrint("Database ready")

    PGV.UnregisterEvent("ADDON_LOADED")
end)
