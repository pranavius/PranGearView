local addonName, AddOn = ...

AddOn = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceConsole-3.0", "AceEvent-3.0")

AddOn.EnchantTextReplace = {
    { original = "Enchanted: ", replacement = "" },
    { original = "Chant", replacement = "" },
    { original = "Whisper", replacement = "" },
    { original = "Council", replacement = "" },
    { original = "Council's", replacement = "" },
    { original = "Stormrider", replacement = "" },
    { original = "Stormrider's", replacement = "" },
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
    { original = "Resourcefulness", replacement = "Resource" },
    { original = "Absorption", replacement = "Absorb" },
}

AddOn.UpgradeTextReplace = {
    { original = "Upgrade Level: Explorer", replacement = "E" },
    { original = "Upgrade Level: Adventurer", replacement = "A" },
    { original = "Upgrade Level: Veteran", replacement = "V" },
    { original = "Upgrade Level: Champion", replacement = "C" },
    { original = "Upgrade Level: Hero", replacement = "H" },
    { original = "Upgrade Level: Myth", replacement = "M" }
}

AddOn.PGVHexColors = {
    Poor = "9D9D9D",
    Uncommon = "1EFF00",
    Rare = "0070DD",
    Epic = "A335EE",
    Legendary = "FF8000",
    Artifact = "E6CC80",
    Heirloom = "00CCFF",
    Info = "FFD100",
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

AddOn.PGVExpansionInfo = {
    TheWarWithin = {
        SocketableSlots = {
            CharacterNeckSlot,
            CharacterFinger0Slot,
            CharacterFinger1Slot
        },
        MaxSocketsPerItem = 2,
        MaxEmbellishments = 2,
        EnchantableSlots = {
            CharacterBackSlot,
            CharacterChestSlot,
            CharacterWristSlot,
            CharacterLegsSlot,
            CharacterFeetSlot,
            CharacterFinger0Slot,
            CharacterFinger1Slot,
            CharacterMainHandSlot,
            CharacterSecondaryHandSlot
        }
    }
}