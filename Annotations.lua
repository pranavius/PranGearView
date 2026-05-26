----- Constants -----
---@class DKEnchantAbbr
---@field Razorice string
---@field Sanguination string
---@field Spellwarding string
---@field Apocalypse string
---@field FallenCrusader string
---@field StoneskinGargoyle string
---@field UnendingThirst string

---@class TextReplacement
---@field original string
---@field replacement string

---@class HexColorPresets
---@field Poor string
---@field Uncommon string
---@field Rare string
---@field Epic string
---@field Legendary string
---@field Artifact string
---@field Heirloom string
---@field Info string
---@field PrevSeasonGear string
---@field Error string
---@field DeathKnight string
---@field DemonHunter string
---@field Druid string
---@field Evoker string
---@field Hunter string
---@field Mage string
---@field Monk string
---@field Paladin string
---@field Priest string
---@field Rogue string
---@field Shaman string
---@field Warlock string
---@field Warrior string

---@alias CharacterSlot CharacterHeadSlot|CharacterNeckSlot|CharacterShoulderSlot|CharacterBackSlot|CharacterChestSlot|CharacterShirtSlot|CharacterTabardSlot|CharacterWristSlot|CharacterHandsSlot|CharacterWaistSlot|CharacterLegsSlot|CharacterFeetSlot|CharacterFinger0Slot|CharacterFinger1Slot|CharacterTrinket0Slot|CharacterTrinket1Slot|CharacterMainHandSlot|CharacterSecondaryHandSlot

---@alias InspectSlotName "InspectHeadSlot"|"InspectNeckSlot"|"InspectShoulderSlot"|"InspectBackSlot"|"InspectChestSlot"|"InspectShirtSlot"|"InspectTabardSlot"|"InspectWristSlot"|"InspectHandsSlot"|"InspectWaistSlot"|"InspectLegsSlot"|"InspectFeetSlot"|"InspectFinger0Slot"|"InspectFinger1Slot"|"InspectTrinket0Slot"|"InspectTrinket1Slot"|"InspectMainHandSlot"|"InspectSecondaryHandSlot"
---@class InspectInfo
---@field slots InspectSlotName[]
---@field leftSideSlots InspectSlotName[]
---@field bottomSlots InspectSlotName[]

---@alias RaceIcon { Male: string, Female: string }
---@class RaceIcons
---@field Human RaceIcon
---@field Dwarf RaceIcon
---@field NightElf RaceIcon
---@field Gnome RaceIcon
---@field Draenei RaceIcon
---@field Worgen RaceIcon
---@field VoidElf RaceIcon
---@field LightforgedDraenei RaceIcon
---@field DarkIronDwarf RaceIcon
---@field KulTiran RaceIcon
---@field Mechagnome RaceIcon
---@field Orc RaceIcon
---@field Undead RaceIcon
---@field Tauren RaceIcon
---@field Troll RaceIcon
---@field BloodElf RaceIcon
---@field Goblin RaceIcon
---@field Nightborne RaceIcon
---@field HighmountainTauren RaceIcon
---@field MagharOrc RaceIcon
---@field ZandalariTroll RaceIcon
---@field Vulpera RaceIcon
---@field Pandaren RaceIcon
---@field Dracthyr RaceIcon
---@field Earthen RaceIcon
---@field Haranir RaceIcon

---@class ClassIcons
---@field DeathKnight string
---@field DemonHunter string
---@field Druid string
---@field Evoker string
---@field Hunter string
---@field Mage string
---@field Monk string
---@field Paladin string
---@field Priest string
---@field Rogue string
---@field Shaman string
---@field Warlock string
---@field Warrior string

---@class OutlineOption
---@field key string
---@field value string

----- Utils -----

---@class ItemSlot: Button
---@field IsLeftSide boolean?
---@field PGVCharSlot PGVCharSlotMixin
---@field PGVInspectSlot PGVInspectSlotMixin

---@class CharacterStatFrame: Frame
---@field Label FontString
---@field Value FontString
---@field Background Texture
---@field numericValue number

---@class ExpansionDetails
---@field NameAbbr string
---@field LevelCap number
---@field SocketableSlots (CharacterSlot|InspectSlotName)[]
---@field AuxSocketableSlots (CharacterSlot|InspectSlotName)[]
---@field MaxSocketsPerItem number
---@field MaxAuxSocketsPerItem number
---@field MaxEmbellishments number
---@field EnchantableSlots (CharacterSlot|InspectSlotName)[]
---@field ShieldEnchantAvailable boolean
---@field OffhandEnchantAvailable boolean

---@class Credit
---@field name string
---@field race? string
---@field class? string
---@field color string

---@class PGVSlotMixinBase: Frame
---@field ItemLevel FontString
---@field UpgradeTrack FontString
---@field Gems FontString
---@field Enchant FontString
---@field Embellishment Texture
---@field EmbellishmentShadow Texture
---@field IsLeftSideSlot boolean
---@field IsBottomSlot boolean

---@class PGVCharSlotMixin: PGVSlotMixinBase
---@field Durability FontString
---@field DurabilityBar StatusBar
---@field DurabilityBarBg StatusBar

---@class PGVInspectSlotMixin: PGVSlotMixinBase

---@class PGVToggleEnchantButton: Button
---@field tooltipText string

---@class InspectFrame
---@field unit string?

---@class BackdropOptions
---@field bgFile? string
---@field edgeFile? string
---@field tile? boolean
---@field tileSize? number
---@field tileEdge? boolean
---@field edgeSize? number
---@field insets? { left: number, right: number, top: number, bottom: number }


---@class StatusBar
---@field SetBackdrop fun(self: StatusBar, options?: BackdropOptions)
---@field SetBackdropBorderColor fun(self: StatusBar, r: number, g: number, b: number, a?: number)
---@field GetValue fun(self: StatusBar): number

---@class InspectPaperDollItemsFrame
---@field PGVAverageItemLevel FontString?

---@class TooltipDataLine
---@field gemIcon? number
---@field socketType? string

---@class PGVDatabaseProfileItemLevel
---@field show boolean
---@field scale number
---@field outline string
---@field onItem boolean
---@field useQualityColor boolean
---@field useClassColor boolean
---@field useGradientColors boolean
---@field useCustomColor boolean
---@field customColor string

---@class PGVDatabaseProfileUpgradeTrack
---@field show boolean
---@field scale number
---@field outline string
---@field useQualityScaleColors boolean
---@field useCustomColor boolean
---@field customColor string

---@class PGVDatabaseProfileGems
---@field show boolean
---@field scale number
---@field showMissing boolean
---@field missingMaxLevelOnly boolean

---@class PGVDatabaseProfileEnchants
---@field show boolean
---@field scale number
---@field outline string
---@field showMissing boolean
---@field missingMaxLevelOnly boolean
---@field collapse boolean
---@field showTextButton boolean
---@field useCustomColor boolean
---@field customColor string

---@class PGVDatabaseProfileDurability
---@field show boolean
---@field scale number
---@field showAsBar boolean
---@field colorHigh string
---@field colorMedium string
---@field colorLow string

---@class PGVDatabaseProfileInspect
---@field show boolean
---@field showAvgILvl boolean
---@field includeAvgLabel boolean
---@field showILvl boolean
---@field showUpgradeTrack boolean
---@field showGems boolean
---@field showEnchants boolean
---@field showEmbellishments boolean

---@class PGVDatabaseProfileCharacterStats
---@field showDecimals boolean
---@field decimalPlaces number
---@field lastSelectedSpecID number?
---@field customSpecStatOrders table<number, table<string, number>>

---@class PGVDatabaseProfileGeneral
---@field debug boolean
---@field showEmbellishments boolean
---@field showCharacteriLvlDecimal boolean
---@field decimalPlacesForCharacteriLvl number
---@field hideShirtTabardInfo boolean
---@field increaseCharacterInfoSize boolean
---@field minimap LibDBIcon.button.DB

---@class PGVDatabaseProfile
---@field itemLevel PGVDatabaseProfileItemLevel
---@field upgradeTrack PGVDatabaseProfileUpgradeTrack
---@field gems PGVDatabaseProfileGems
---@field enchants PGVDatabaseProfileEnchants
---@field durability PGVDatabaseProfileDurability
---@field inspect PGVDatabaseProfileInspect
---@field characterStats PGVDatabaseProfileCharacterStats
---@field general PGVDatabaseProfileGeneral

---@class PGVDatabaseDefaults: AceDB.Schema
---@field profile PGVDatabaseProfile

---@class PGVDatabase: AceDBObject-3.0
---@field profile PGVDatabaseProfile

---@class PGVTooltipDataType
---@field UpgradeTrack number
---@field Gem number
---@field Enchant number

---@alias Stat "Critical Strike"|"Haste"|"Mastery"|"Versatility"|"Avoidance"|"Leech"|"Speed"|"Armor"|"Block"|"Parry"

---@class PranGearView: AceAddon, AceConsole-3.0, AceEvent-3.0
---@field categoryID number
---@field db PGVDatabase
---@field frfrEnchantTextReplacements TextReplacement[]
---@field inspectHookSetup boolean
---@field inspectedUnitGUID string?
---@field noUnitTokenMessagePrinted boolean
---@field ptbrEnchantTextReplacements TextReplacement[]
---@field ClassIcons ClassIcons
---@field CurrentExpac ExpansionDetails
---@field DatabaseDefaults PGVDatabaseDefaults
---@field DefaultStatOrder DefaultStatOrder
---@field DefaultTankStatOrder DefaultTankStatOrder
---@field DKEnchantAbbr DKEnchantAbbr
---@field EnchantTextReplacements TextReplacement[]
---@field ExpansionInfo table<string, ExpansionDetails>
---@field GearSlots CharacterSlot[]
---@field HexColorPresets HexColorPresets
---@field InspectInfo InspectInfo
---@field OptionsTable table
---@field OutlineOptions OutlineOption[]
---@field PGVToggleEnchantButton PGVToggleEnchantButton
---@field RaceIcons RaceIcons
---@field SlashCmds string[]
---@field SlashOptions table
---@field SpecOptionKeys table<number, string>
---@field StatsCache table<Stat, number>
---@field TooltipDataType PGVTooltipDataType
---@field UpgradeTextReplacements TextReplacement[]
