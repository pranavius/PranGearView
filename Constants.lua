local addonName, AddOn = ...
---@class PranGearView: AceAddon, AceConsole-3.0, AceEvent-3.0
AddOn = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceConsole-3.0", "AceEvent-3.0")

---@enum DKEnchantAbbr
AddOn.DKEnchantAbbr = {
    Razorice = "Razorice",
    Sanguination = "Sang",
    Spellwarding = "Spellward",
    Apocalypse = "Apoc",
    FallenCrusader = "Fall Crus",
    StoneskinGargoyle = "Stnskn Garg",
    UnendingThirst = "Unend Thirst"
}

---@class TextReplacement
---@field original string The localization key for the original text to search for when abbreviating text
---@field replacement string The localization key for the abbreviation for the original text

---A list of tables containing text replacement patterns for enchants
---@type TextReplacement[]
AddOn.EnchantTextReplacementKeysmentKeys = {
    { original = "%%", replacement = "%%%%" }, -- Required for proper string formatting (% is a special character in formatting)
    { original = "+", replacement = "" }, -- Removes the '+' that usually prefixes enchantment text
    { original = "Enchanted: ", replacement = "" },
    { original = "Radiant Critical Strike", replacement = "Rad Crit" },
    { original = "Radiant Haste", replacement = "Rad Hst" },
    { original = "Radiant Mastery", replacement = "Rad Mast" },
    { original = "Radiant Versatility", replacement = "Rad Vers" },
    { original = "Cursed Critical Strike", replacement = "Curs Crit" },
    { original = "Cursed Haste", replacement = "Curs Hst" },
    { original = "Cursed Mastery", replacement = "Curs Mast" },
    { original = "Cursed Versatility", replacement = "Curs Vers" },
    { original = "Whisper of Armored Avoidance", replacement = "Arm Avoid" },
    { original = "Whisper of Armored Leech", replacement = "Arm Leech" },
    { original = "Whisper of Armored Speed", replacement = "Arm Spd" },
    { original = "Whisper of Silken Avoidance", replacement = "Silk Avoid" },
    { original = "Whisper of Silken Leech", replacement = "Silk Leech" },
    { original = "Whisper of Silken Speed", replacement = "Silk Spd" },
    { original = "Chant of Armored Avoidance", replacement = "Arm Avoid" },
    { original = "Chant of Armored Leech", replacement = "Arm Leech" },
    { original = "Chant of Armored Speed", replacement = "Arm Spd" },
    { original = "Scout's March", replacement = "Sco March" },
    { original = "Defenders's March", replacement = "Def March" },
    { original = "Cavalry's March", replacement = "Cav March" },
    { original = "Stormrider's Agility", replacement = "Agi" },
    { original = "Council's Intellect", replacement = "Int" },
    { original = "Crystalline Radiance", replacement = "Crys Rad" },
    { original = "Oathsworn's Strength", replacement = "Oath Str" },
    { original = "Chant of Winged Grace", replacement = "Wing Grc" },
    { original = "Chant of Leeching Fangs", replacement = "Leech Fang" },
    { original = "Chant of Burrowing Rapidity", replacement = "Burr Rap" },
    { original = "Authority of Air", replacement = "Auth Air" },
    { original = "Authority of Fiery Resolve", replacement = "Fire Res" },
    { original = "Authority of Radiant Power", replacement = "Rad Pow" },
    { original = "Authority of the Depths", replacement = "Auth Deps" },
    { original = "Authority of Storms", replacement = "Auth Storm" },
    { original = "Oathsworn's Tenacity", replacement = "Oath Ten" },
    { original = "Stonebound Artistry", replacement = "Stn Art" },
    { original = "Stormrider's Fury", replacement = "Fury" },
    { original = "Council's Guile", replacement = "Guile" },
    { original = "Lesser Twilight Devastation", replacement = "Lssr Twi Dev" },
    { original = "Greater Twilight Devastation", replacement = "Grtr Twi Dev" },
    { original = "Lesser Void Ritual", replacement = "Lssr Void Rit" },
    { original = "Greater Void Ritual", replacement = "Grtr Void Rit" },
    { original = "Lesser Twisted Appendage", replacement = "Lssr Twst App" },
    { original = "Greater Twisted Appendage", replacement = "Grtr Twst App" },
    { original = "Lesser Echoing Void", replacement = "Lssr Echo Void" },
    { original = "Greater Echoing Void", replacement = "Grtr Echo Void" },
    { original = "Lesser Gushing Wound", replacement = "Lssr Gush Wnd" },
    { original = "Greater Gushing Wound", replacement = "Grtr Gush Wnd" },
    { original = "Lesser Infinite Stars", replacement = "Lssr Inf Star" },
    { original = "Greater Infinite Stars", replacement = "Grtr Inf Star" },
    { original = "Rune of the Fallen Crusader", replacement = AddOn.DKEnchantAbbr.FallenCrusader },
    { original = "Rune of Razorice", replacement = AddOn.DKEnchantAbbr.Razorice },
    { original = "Rune of Sanguination", replacement = AddOn.DKEnchantAbbr.Sanguination },
    { original = "Rune of Spellwarding", replacement = AddOn.DKEnchantAbbr.Spellwarding },
    { original = "Rune of the Apocalypse", replacement = AddOn.DKEnchantAbbr.Apocalypse },
    { original = "Rune of the Stoneskin Gargoyle", replacement = AddOn.DKEnchantAbbr.StoneskinGargoyle },
    { original = "Rune of Unending Thirst", replacement = AddOn.DKEnchantAbbr.UnendingThirst },
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
    { original = "Deftness", replacement = "Deft" },
    { original = "Finesse", replacement = "Fin" },
    { original = "Ingenuity", replacement = "Ing" },
    { original = "Perception", replacement = "Perc" },
    { original = "Resourcefulness", replacement = "Rsrc" },
    { original = "Absorption", replacement = "Absorb" },
}

---A list of tables containing text replacement patterns for upgrade tracks
---@type TextReplacement[]
AddOn.UpgradeTextReplacementKeys = {
    { original = "Upgrade Level: ", replacement = "" },
    { original = "Explorer ", replacement = "E" },
    { original = "Adventurer ", replacement = "A" },
    { original = "Veteran ", replacement = "V" },
    { original = "Champion ", replacement = "C" },
    { original = "Hero ", replacement = "H" },
    { original = "Myth ", replacement = "M" }
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
---@field slots string[] A list of all slot names when inspecting a character
---@field leftSideSlots string[] A list of all slots that appear on the left side of the character model when inspecting a character
---@field bottomSlots string[] A list of all slots that appear on the bottom of the character model when inspecting a character
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
---@field SocketableSlots any[] A list of gear slots that can have a gem socket added to it in the expansion. Slots can be defined as either a `Frame` or `string` containing the name of a frame.
---@field AuxSocketableSlots any[] A list of gear slots that can have a gem socket added to it via auxillary methods in the expansion (example: S.A.D. in _The War Within_). Slots can be defined as either a `Frame` or `string` containing the name of a frame.
---@field MaxSocketsPerItem number The maximum number of sockets an item can have
---@field MaxAuxSocketsPerItem number The maximum number of sockets items that can be socketed via auxillary methods can have
---@field EnchantableSlots any[] A list of gear slots that can be enchanted in the expansion. Slots can be defined as either a Frame or string containing the name of a frame.
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

---@enum SpecOptionKeys
AddOn.SpecOptionKeys = {
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

---@class OutlineOption
---@field key string The localization key for the dropdown option
---@field value string The value for text outline to pass to `SetFont()`

---@type OutlineOption[]
AddOn.OutlineOptions = {
    { key = "None", value = "" },
    { key = "Monochrome", value = "MONOCHROME" },
    { key = "Regular", value = "OUTLINE" },
    { key = "Thick", value = "THICKOUTLINE" },
}
