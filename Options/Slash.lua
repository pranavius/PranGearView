local addonName, PGV = ...
local L = PGV.L

local ToggleMap = {
    ilvl = { help = L["Toggle showing item level"], dbTable = "itemLevel", dbKey = "show" },
    gems = { help = L["Toggle showing gem info"], dbTable = "gems", dbKey = "show" },
    dur = { help = L["Toggle showing durability percentages"], dbTable = "durability", dbKey = "show" },
    etext = { help = L["Toggle showing enchant text in the Character Info window"], dbTable = "enchants", dbKey = "collapse" },
    inspect = { help = L["Toggle showing gear info when inspecting another player"], dbTable = "inspect", dbKey = "show" },
}
if not PGV.isCamelot then
    ToggleMap.track = { help = L["Toggle showing upgrade track"], dbTable = "upgradeTrack", dbKey = "show" }
end

local function printHelp()
    print(addonName..": /pgv <command>")
    print("  help - "..L["List all available slash commands for the AddOn"])
    for cmd, entry in pairs(ToggleMap) do
        print("  "..cmd.." - "..entry.help)
    end
    print("  ench - "..L["Toggle showing enchant info"])
    if not PGV.isCamelot then
        print("  expand - "..L["Toggle using the larger Character Info window"])
    end
    print("  minimap - "..L["Show/hide the minimap icon"])
end

local function handleSlashCmd(input)
    input = input:trim():lower()

    if input == "" then
        if PGV.IsAddOnCurrentlyRestricted() then
            print(addonName..": "..L["Settings cannot be modified while the AddOn is restricted (combat, an encounter, a Mythic+ dungeon, or a PvP match)."])
            return
        end
        Settings.OpenToCategory(PGV.categoryID)
        return
    end

    if input == "help" then
        printHelp()
        return
    end

    local toggle = ToggleMap[input]
    if toggle then
        PGV.db[toggle.dbTable][toggle.dbKey] = not PGV.db[toggle.dbTable][toggle.dbKey]
        PGV.RefreshSlots()
        return
    end

    if input == "ench" then
        PGV.db.enchants.show = not PGV.db.enchants.show
        PGV.RefreshSlots()
        return
    end

    if input == "expand" and not PGV.isCamelot then
        PGV.db.general.increaseCharacterInfoSize = not PGV.db.general.increaseCharacterInfoSize
        PGV.AdjustCharacterInfoWindowSize()
        PGV.RefreshSlots()
        return
    end

    if input == "minimap" then
        PGV.db.general.minimap.hide = not PGV.db.general.minimap.hide
        local LDBIcon = LibStub("LibDBIcon-1.0")
        if PGV.db.general.minimap.hide then
            LDBIcon:Hide(addonName)
        else
            LDBIcon:Show(addonName)
        end
        PGV.RefreshSlots()
        return
    end

    printHelp()
end

SLASH_PRANGEARVIEW1 = "/prangearview"
SLASH_PRANGEARVIEW2 = "/pgv"
SlashCmdList["PRANGEARVIEW"] = handleSlashCmd
