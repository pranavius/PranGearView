---@class TextReplacement
---@field original string The localization key for the original text to search for when abbreviating text
---@field replacement string The localization key for the abbreviation for the original text

---@class InspectInfo
---@field slots string[] A list of all slot names when inspecting a character
---@field leftSideSlots string[] A list of all slots that appear on the left side of the character model when inspecting a character
---@field bottomSlots string[] A list of all slots that appear on the bottom of the character model when inspecting a character

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

---@class (exact) RaceGender
---@field Male string The atlas alias for the icon corresponding to a male of the associated race
---@field Female string The atlas alias for the icon corresponding to a female of the associated race

---@class OutlineOption
---@field key string The localization key for the dropdown option
---@field value string The value for text outline to pass to `SetFont()`

---@class PGVDurabilityBar: StatusBar
---@field percent number

---@class Slot: Frame
---@field IsLeftSide boolean|nil Indicates whether the equipment slot is on the left, right, or bottom of the Character model in the default UI Character Info and Inspect windows
---@field PGVItemLevel? FontString
---@field PGVUpgradeTrack? FontString
---@field PGVGems? FontString
---@field PGVEnchant? FontString
---@field PGVDurability? FontString
---@field PGVDurabilityBarBg? StatusBar
---@field PGVDurabilityBar? PGVDurabilityBar
---@field PGVEmbellishmentTexture? Texture
---@field PGVEmbellishmentShadow? Texture

---@class CharacterStatFrame : Frame
---@field Background Frame A highlight color that serves as a background for even-ordered displayed stats (helps with visual separation)
---@field Label FontString The name of the stat being shown
---@field Value FontString The displayed value of the stat being shown
---@field numericValue? number The true numeric value for the stat being shown

---@class (exact) Credit
---@field name string Contributor name
---@field race? string World of Warcraft race & gender they identify with in-game
---@field class? ClassIcons World of Warcraft class they identify with in-game
---@field color HexColorPresets Color to display the contributor's name in