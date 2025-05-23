local addonName, AddOn = ...
---@class PranGearView
AddOn = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceConsole-3.0", "AceEvent-3.0")

---@enum DKEnchantAbbr
AddOn.DKEnchantAbbr = {
    Razorice = "Razorice",
    Sanguination = "Sang",
    Spellwarding = "Spellward",
    Apocalypse = "Apoc",
    Fallen = "Fall",
    Crusader = "Crus",
    FallenCrusader = "Fall Crus",
    Stoneskin = "Stnskn",
    Gargoyle = "Garg",
    StoneskinGargoyle = "Stnskn Garg",
    Unending = "Unend",
    UnendingThirst = "Unend Thirst"
}

---@class TextReplacement
---@field original string The original text to search for when abbreviating text
---@field replacement string The abbreviation for the original text

---@type table<number, TextReplacement>
AddOn.EnchantTextReplace = {
    { original = "%%", replacement = "%%%%" }, -- Required for proper string formatting (% is a special character in formatting)
    { original = "+", replacement = "" }, -- Removes the '+' that usually prefixes enchantment text
    { original = "Enchanted: ", replacement = "" },
    { original = "Chant", replacement = "" },
    { original = "Whisper", replacement = "" },
    { original = "Council", replacement = "" },
    { original = "Council's", replacement = "" },
    { original = "Stormrider", replacement = "" },
    { original = "Stormrider's", replacement = "" },
    { original = "Stonebound", replacement = "Stn" },
    { original = "Cursed", replacement = "Curs" },
    { original = "Lesser", replacement = "Lssr" },
    { original = "Greater", replacement = "Grtr" },
    { original = "Rune", replacement = "" },
    { original = " of", replacement = "" },
    { original = " the", replacement = "" },
    { original = "'s", replacement = "" },
    { original = "Stamina", replacement = "Stam" },
    { original = "Intellect", replacement = "Int" },
    { original = "Strength", replacement = "Str" },
    { original = "Agility", replacement = "Agi" },
    { original = "Speed", replacement = "Spd" },
    { original = "Avoidance", replacement = "Avoid" },
    { original = "Armor", replacement = "Arm" },
    { original = "Haste", replacement = "Hst" },
    { original = "Damage", replacement = "Dmg" },
    { original = "Mastery", replacement = "Mast" },
    { original = "Critical Strike", replacement = "Crit" },
    { original = "Versatility", replacement = "Vers" },
    { original = "Cavalry", replacement = "Cav" },
    { original = "Defender", replacement = "Def" },
    { original = "Defense", replacement = "Def" },
    { original = "Scout", replacement = "Sco" },
    { original = "Authority", replacement = "Auth" },
    { original = "Crystalline", replacement = "Crys" },
    { original = "Radiance", replacement = "Rad" },
    { original = "Radiant", replacement = "Rad" },
    { original = "Power", replacement = "Pwr" },
    { original = "Oathsworn", replacement = "Oath" },
    { original = "Oathsworn's", replacement = "Oath" },
    { original = "Tenacity", replacement = "Ten" },
    { original = "Winged", replacement = "Wing" },
    { original = "Burrowing", replacement = "Burr" },
    { original = "Rapidity", replacement = "Rap" },
    { original = "Leeching", replacement = "Leech" },
    { original = "Silken", replacement = "Silk" },
    { original = "Deftness", replacement = "Deft" },
    { original = "Finesse", replacement = "Fin" },
    { original = "Ingenuity", replacement = "Ing" },
    { original = "Perception", replacement = "Perc" },
    { original = "Resourcefulness", replacement = "Rsrc" },
    { original = "Absorption", replacement = "Absorb" },
    { original = "Artistry", replacement = "Art" },
    { original = "Sanguination", replacement = AddOn.DKEnchantAbbr.Sanguination },
    { original = "Spellwarding", replacement = AddOn.DKEnchantAbbr.Spellwarding },
    { original = "Apocalypse", replacement = AddOn.DKEnchantAbbr.Apocalypse },
    { original = "Fallen", replacement = AddOn.DKEnchantAbbr.Fallen },
    { original = "Crusader", replacement = AddOn.DKEnchantAbbr.Crusader },
    { original = "Stoneskin", replacement = AddOn.DKEnchantAbbr.Stoneskin },
    { original = "Gargoyle", replacement = AddOn.DKEnchantAbbr.Gargoyle },
    { original = "Unending", replacement = AddOn.DKEnchantAbbr.Unending },
    { original = "Twilight", replacement = "Twi" },
    { original = "Devastation", replacement = "Dev" },
    { original = "Ritual", replacement = "Rit" },
    { original = "Twisted", replacement = "Twst" },
    { original = "Appendage", replacement = "App" },
    { original = "Gushing", replacement = "Gush" },
    { original = "Wound", replacement = "Wnd" },
    { original = "Infinite", replacement = "Inf" },
    { original = "Stars", replacement = "Star" },
    { original = "Echoing", replacement = "Echo" },
}

---@type table<number, TextReplacement>
AddOn.UpgradeTextReplace = {
    { original = "Upgrade Level: Explorer ", replacement = "E" },
    { original = "Upgrade Level: Adventurer ", replacement = "A" },
    { original = "Upgrade Level: Veteran ", replacement = "V" },
    { original = "Upgrade Level: Champion ", replacement = "C" },
    { original = "Upgrade Level: Hero ", replacement = "H" },
    { original = "Upgrade Level: Myth ", replacement = "M" }
}

---@enum HexColorPresets
AddOn.HexColorPresets = {
    Poor = "9D9D9D",
    Uncommon = "1EFF00",
    Rare = "0070DD",
    Epic = "A335EE",
    Legendary = "FF8000",
    Artifact = "E6CC80",
    Heirloom = "00CCFF",
    Info = "FFD100",
    PrevSeasonGear = "808080",
    Error = "FF3300",
    DeathKnight = "C41E3A",
    DemonHunter = "A330C9",
    Druid = "FF7C0A",
    Evoker = "33937F",
    Hunter = "AAD372",
    Mage = "3FC7EB",
    Monk = "00FF98",
    Paladin = "F48CBA",
    Priest = "FFFFFF",
    Rogue = "FFF468",
    Shaman = "0070DD",
    Warlock = "8788EE",
    Warrior = "C69B6D"
}

AddOn.GearSlots = {
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

---@class InspectInfo
---@field slots table<number, string> A list of all slot names when inspecting a character
---@field leftSideSlots table<number, string> A list of all slots that appear on the left side of the character model when inspecting a character
---@field bottomSlots table<number, string> A list of all slots that appear on the bottom of the character model when inspecting a character
AddOn.InspectInfo = {
    slots = {
        "InspectHeadSlot",
        "InspectNeckSlot",
        "InspectShoulderSlot",
        "InspectBackSlot",
        "InspectChestSlot",
        "InspectShirtSlot",
        "InspectTabardSlot",
        "InspectWristSlot",
        "InspectHandsSlot",
        "InspectWaistSlot",
        "InspectLegsSlot",
        "InspectFeetSlot",
        "InspectFinger0Slot",
        "InspectFinger1Slot",
        "InspectTrinket0Slot",
        "InspectTrinket1Slot",
        "InspectMainHandSlot",
        "InspectSecondaryHandSlot"
    },
    leftSideSlots = {
        "InspectHeadSlot",
        "InspectNeckSlot",
        "InspectShoulderSlot",
        "InspectBackSlot",
        "InspectChestSlot",
        "InspectShirtSlot",
        "InspectTabardSlot",
        "InspectWristSlot"
    },
    bottomSlots = {
        "InspectMainHandSlot",
        "InspectSecondaryHandSlot"
    }
}

---@class ExpansionDetails
---@field LevelCap number The maximum reachable level for the expansion
---@field SocketableSlots table<number, any> A list of gear slots that can have a gem socket added to it in the expansion. Slots can be defined as either a Frame or string containing the name of a frame.
---@field AuxSocketableSlots table<number, any> A list of gear slots that can have a gem socket added to it via auxillary methods in the expansion (example: S.A.D. in The War Within). Slots can be defined as either a Frame or string containing the name of a frame.
---@field MaxSocketsPerItem number The maximum number of sockets an item can have
---@field MaxAuxSocketsPerItem number The maximum number of sockets items that can be socketed via auxillary methods can have
---@field EnchantableSlots table<number, any> A list of gear slots that can be enchanted in the expansion. Slots can be defined as either a Frame or string containing the name of a frame.
---@field HeadEnchantAvailable boolean Indicates whether or not a head enchant from the expansion is currently available in-game
---@field ShieldEnchantAvailable boolean Indicates whether or not a shield enchant from the expansion is currently available in-game
---@field OffhandEnchantAvailable boolean Indicates whether or not an off-hand enchant from the expansion is currently available in-game

---@type table<string, ExpansionDetails>
---@see Frame for generic definition along without common functions and variables available for all Frames
---@see InspectInfo for a list of Frame names available when the Inspect window is open
AddOn.ExpansionInfo = {
    TheWarWithin = {
        LevelCap = 80,
        SocketableSlots = {
            CharacterNeckSlot,
            CharacterFinger0Slot,
            CharacterFinger1Slot,
            "InspectNeckSlot",
            "InspectFinger0Slot",
            "InspectFinger1Slot"
        },
        AuxSocketableSlots = {
            CharacterHeadSlot,
            CharacterWristSlot,
            CharacterWaistSlot,
            "InspectHeadSlot",
            "InspectWristSlot",
            "InspectWaistSlot"
        },
        MaxSocketsPerItem = 2,
        MaxAuxSocketsPerItem = 1,
        MaxEmbellishments = 2,
        EnchantableSlots = {
            CharacterHeadSlot,
            CharacterBackSlot,
            CharacterChestSlot,
            CharacterWristSlot,
            CharacterLegsSlot,
            CharacterFeetSlot,
            CharacterFinger0Slot,
            CharacterFinger1Slot,
            CharacterMainHandSlot,
            CharacterSecondaryHandSlot,
            "InspectHeadSlot",
            "InspectBackSlot",
            "InspectChestSlot",
            "InspectWristSlot",
            "InspectLegsSlot",
            "InspectFeetSlot",
            "InspectFinger0Slot",
            "InspectFinger1Slot",
            "InspectMainHandSlot",
            "InspectSecondaryHandSlot"
        },
        HeadEnchantAvailable = true,
        ShieldEnchantAvailable = false,
        OffhandEnchantAvailable = false
    }
}

---@enum SpecOptions
AddOn.SpecOptions = {
    [250] = "Blood",
    [251] = "Frost",
    [252] = "Unholy",
    [577] = "Havoc",
    [581] = "Vengeance",
    [102] = "Balance",
    [103] = "Feral",
    [104] = "Guardian",
    [105] = "Restoration",
    [1467] = "Devastation",
    [1468] = "Preservation",
    [1473] = "Augmentation",
    [253] = "Beast Mastery",
    [254] = "Marksmanship",
    [255] = "Survival",
    [62] = "Arcane",
    [63] = "Fire",
    [64] = "Frost",
    [268] = "Brewmaster",
    [270] = "Mistweaver",
    [269] = "Windwalker",
    [65] = "Holy",
    [66] = "Protection",
    [70] = "Retribution",
    [256] = "Discipline",
    [257] = "Holy",
    [258] = "Shadow",
    [259] = "Assassination",
    [260] = "Outlaw",
    [261] = "Subtlety",
    [262] = "Elemental",
    [263] = "Enchancement",
    [264] = "Restoration",
    [265] = "Affliction",
    [266] = "Demonology",
    [267] = "Destruction",
    [71] = "Arms",
    [72] = "Fury",
    [73] = "Protection",
}

---@enum DefaultStatOrder
AddOn.DefaultStatOrder = {
    [STAT_CRITICAL_STRIKE] = 1,
    [STAT_HASTE] = 2,
    [STAT_MASTERY] = 3,
    [STAT_VERSATILITY] = 4,
    [STAT_LIFESTEAL] = 5,
    [STAT_AVOIDANCE] = 6,
    [STAT_SPEED] = 7
}

---@enum DefaultTankStatOrder
AddOn.DefaultTankStatOrder = {
    [STAT_DODGE] = 8,
    [STAT_PARRY] = 9,
    [STAT_BLOCK] = 10
}

---@enum TooltipDataType
AddOn.TooltipDataType = {
    UpgradeTrack = 42,
    Gem = 3,
    Enchant = 15,

}

---@class (exact) RaceGender
---@field Male string The atlas alias for the icon corresponding to a male of the associated race
---@field Female string The atlas alias for the icon corresponding to a female of the associated race

---@type table<string, RaceGender>
AddOn.RaceIcons = {
    Human = {
        Male = "RaceIcon128-Human-Male",
        Female = "RaceIcon128-Human-Female"
    },
    Dwarf = {
        Male = "RaceIcon128-Dwarf-Male",
        Female = "RaceIcon128-Dwarf-Female"
    },
    NightElf = {
        Male = "RaceIcon128-NightElf-Male",
        Female = "RaceIcon128-NightElf-Female"
    },
    Gnome = {
        Male = "RaceIcon128-Gnome-Male",
        Female = "RaceIcon128-Gnome-Female"
    },
    Draenei = {
        Male = "RaceIcon128-Draenei-Male",
        Female = "RaceIcon128-Draenei-Female"
    },
    Worgen = {
        Male = "RaceIcon128-Worgen-Male",
        Female = "RaceIcon128-Worgen-Female"
    },
    VoidElf = {
        Male = "RaceIcon128-VoidElf-Male",
        Female = "RaceIcon128-VoidElf-Female"
    },
    LightforgedDraenei = {
        Male = "RaceIcon128-Lightforged-Male",
        Female = "RaceIcon128-Lightforged-Female"
    },
    DarkIronDwarf = {
        Male = "RaceIcon128-DarkIronDwarf-Male",
        Female = "RaceIcon128-DarkIronDwarf-Female"
    },
    KulTiran = {
        Male = "RaceIcon128-KulTiran-Male",
        Female = "RaceIcon128-KulTiran-Female"
    },
    Mechagnome = {
        Male = "RaceIcon128-Mechagnome-Male",
        Female = "RaceIcon128-Mechagnome-Female"
    },
    Orc = {
        Male = "RaceIcon128-Orc-Male",
        Female = "RaceIcon128-Orc-Female"
    },
    Undead = {
        Male = "RaceIcon128-Undead-Male",
        Female = "RaceIcon128-Undead-Female"
    },
    Tauren = {
        Male = "RaceIcon128-Tauren-Male",
        Female = "RaceIcon128-Tauren-Female"
    },
    Troll = {
        Male = "RaceIcon128-Troll-Male",
        Female = "RaceIcon128-Troll-Female"
    },
    BloodElf = {
        Male = "RaceIcon128-BloodElf-Male",
        Female = "RaceIcon128-BloodElf-Female"
    },
    Goblin = {
        Male = "RaceIcon128-Goblin-Male",
        Female = "RaceIcon128-Goblin-Female"
    },
    Nightborne = {
        Male = "RaceIcon128-Nightborne-Male",
        Female = "RaceIcon128-Nightborne-Female"
    },
    HighmountainTauren = {
        Male = "RaceIcon128-Highmountain-Male",
        Female = "RaceIcon128-Highmountain-Female"
    },
    MagharOrc = {
        Male = "RaceIcon128-MagharOrc-Male",
        Female = "RaceIcon128-MagharOrc-Female"
    },
    ZandalariTroll = {
        Male = "RaceIcon128-Zandalari-Male",
        Female = "RaceIcon128-Zandalari-Female"
    },
    Vulpera = {
        Male = "RaceIcon128-Vulpera-Male",
        Female = "RaceIcon128-Vulpera-Female"
    },
    Pandaren = {
        Male = "RaceIcon128-Pandaren-Male",
        Female = "RaceIcon128-Pandaren-Female"
    },
    Dracthyr = {
        Male = "RaceIcon128-Dracthyr-Male",
        Female = "RaceIcon128-Dracthyr-Female"
    },
    Earthen = {
        Male = "RaceIcon128-Earthen-Male",
        Female = "RaceIcon128-Earthen-Female"
    }
}

---@enum ClassIcons
AddOn.ClassIcons = {
    DeathKnight = "ClassIcon-DeathKnight",
    DemonHunter = "ClassIcon-DemonHunter",
    Druid = "ClassIcon-Druid",
    Evoker = "ClassIcon-Evoker",
    Hunter = "ClassIcon-Hunter",
    Mage = "ClassIcon-Mage",
    Monk = "ClassIcon-Monk",
    Paladin = "ClassIcon-Paladin",
    Priest = "ClassIcon-Priest",
    Rogue = "ClassIcon-Rogue",
    Shaman = "ClassIcon-Shaman",
    Warlock = "ClassIcon-Warlock",
    Warrior = "ClassIcon-Warrior"
}
