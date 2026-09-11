local addonName, PGV = ...

local currentLocale = GetLocale()
local defaultLocale = {}
local activeLocaleTable = defaultLocale

function PGV.NewLocale(locale)
    if locale == "enUS" then
        -- Ensures enUS localization is always available as a fallback when a localized translation doesn't exist
        PGV.DebugPrint("enUS locale is", currentLocale == "enUS" and "default & active" or "default only")
        return defaultLocale
    elseif locale == currentLocale then
        -- Returns localizations for the active locale, falling back to defaultLocale (enUS) if a key isn't found
        activeLocaleTable = setmetatable({}, { __index = defaultLocale })
        PGV.DebugPrint("Locale", locale, "is active")
        return activeLocaleTable
    end
    -- This should basically always fall back to enUS (I think?)
    PGV.DebugPrint("Locale", locale, "is inactive, do nothing")
    return nil
end

PGV.L = setmetatable({}, {
    __index = function(_, key)
        return activeLocaleTable[key] or key
    end,
})

local eventFrame = CreateFrame("Frame")
local eventHandlers = {}

eventFrame:SetScript("OnEvent", function(_, event, ...)
    for _, handler in ipairs(eventHandlers[event]) do
        handler(...)
    end
end)

function PGV.RegisterEvent(event, handler)
    -- TODO: Simplify this later, doing this for dev purposes only
    if not eventHandlers[event] then
        eventHandlers[event] = {}
        eventFrame:RegisterEvent(event)
    end
    tinsert(eventHandlers[event], handler)
end

function PGV.UnregisterEvent(event)
    -- TODO: See if anything needs to be updated here once RegisterEvent is revised
    eventFrame:UnregisterEvent(event)
end

function PGV.DebugPrint(...)
    -- TODO: Add debug flag gating this once there's a mechanism to toggle this in-game
    print(HEIRLOOM_BLUE_COLOR:WrapTextInColorCode("[PGV Debug]"), ...)
end

function PGV.ColorText(text, color)
    local hex = PGV.HexColorPresets[color] or color
    return WrapTextInColorCode(tostring(text), "FF"..hex)
end

function PGV.IsAddOnCurrentlyRestricted()
    local restrictionType = Enum.AddOnRestrictionType
    return C_RestrictedActions.IsAddOnRestrictionActive(restrictionType.Encounter)
        or C_RestrictedActions.IsAddOnRestrictionActive(restrictionType.ChallengeMode)
        or C_RestrictedActions.IsAddOnRestrictionActive(restrictionType.PvPMatch)
        or InCombatLockdown()
end

local PlayerGetTimerunningSeasonID = PlayerGetTimerunningSeasonID or function() return nil end

function PGV.AreUpgradeTracksShownForCharacter()
    return PGV.db.upgradeTrack.show and PlayerGetTimerunningSeasonID() == nil
end

function PGV.AreGemsShownForCharacter()
    return PGV.db.gems.show and PlayerGetTimerunningSeasonID() == nil
end

function PGV.AreEnchantsShownForCharacter()
    return PGV.db.enchants.show and PlayerGetTimerunningSeasonID() == nil
end

function PGV.AreEmbellishmentsShownForCharacter()
    return PGV.db.general.showEmbellishments and PlayerGetTimerunningSeasonID() == nil
end
