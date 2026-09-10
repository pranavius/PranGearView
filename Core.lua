local addonName, PGV = ...

local activeLocale = GetLocale()
local defaultLocale = {}
local activeLocaleTable = defaultLocale

function PGV.NewLocale(locale)
    if locale == "enUS" then
        -- Ensures enUS localization is always available as a fallback when a localized translation doesn't exist
        PGV.DebugPrint("enUS locale is", activeLocale == "enUS" and "default & active" or "default only")
        return defaultLocale
    elseif locale == activeLocale then
        -- Returns localizations for the active locale, falling back to defaultLocale (enUS) if a key isn't found
        activeLocaleTable = setmetatable({}, { __index = defaultLocale })
        PGV.DebugPrint("Locale", locale, "is active")
        return activeLocaleTable
    end
    -- This should basically always fall back to enUS (I think?)
    PGV.DebugPrint("Locale", locale, "is unknown, do nothing")
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
