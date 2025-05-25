# Credit

## class


```lua
ClassIcons
```

World of Warcraft class they identify with in-game

## color


```lua
HexColorPresets
```

Color to display the contributor's name in

## name


```lua
string
```

Contributor name

## race


```lua
string
```

World of Warcraft race & gender they identify with in-game


---

# ExpansionDetails

## AuxSocketableSlots


```lua
table<number, any>
```

A list of gear slots that can have a gem socket added to it via auxillary methods in the expansion (example: S.A.D. in _The War Within_). Slots can be defined as either a `Frame` or `string` containing the name of a frame.

## EnchantableSlots


```lua
table<number, any>
```

A list of gear slots that can be enchanted in the expansion. Slots can be defined as either a Frame or string containing the name of a frame.

## HeadEnchantAvailable


```lua
boolean
```

Indicates whether or not a head enchant from the expansion is currently available in-game

## LevelCap


```lua
number
```

The maximum reachable level for the expansion

## MaxAuxSocketsPerItem


```lua
number
```

The maximum number of sockets items that can be socketed via auxillary methods can have

## MaxSocketsPerItem


```lua
number
```

The maximum number of sockets an item can have

## OffhandEnchantAvailable


```lua
boolean
```

Indicates whether or not an off-hand enchant from the expansion is currently available in-game

## ShieldEnchantAvailable


```lua
boolean
```

Indicates whether or not a shield enchant from the expansion is currently available in-game

## SocketableSlots


```lua
table<number, any>
```

A list of gear slots that can have a gem socket added to it in the expansion. Slots can be defined as either a `Frame` or `string` containing the name of a frame.


---

# InspectInfo

## bottomSlots


```lua
table<number, string>
```

A list of all slots that appear on the bottom of the character model when inspecting a character

## leftSideSlots


```lua
table<number, string>
```

A list of all slots that appear on the left side of the character model when inspecting a character

## slots


```lua
table<number, string>
```

A list of all slot names when inspecting a character


---

# InspectPaperDollItemsFrame.PGVAverageItemLevel


```lua
unknown
```


---

# LuaLS


---

# OutlineOption

## key


```lua
string
```

The localization key for the dropdown option

## value


```lua
string
```

The value for text outline to pass to `SetFont()`


---

# PranGearView

## BuildCreditsGroup


```lua
(method) PranGearView:BuildCreditsGroup()
  -> table
```

Generates the Credits section of the AddOn options dynamically based on tables of contributors and special mentions (special thanks)

## ClassIcons


```lua
enum ClassIcons
```

## ColorText


```lua
function PranGearView.ColorText(text: string|number, color: string)
  -> result: string
```

Formats `text` to be displayed in a specific color in-game. If the argument is a valid entry in the `HexColorPresets` table, that value will be used.
Alternatively, a color's hexadecimal code can be provided for the `color` argument instead.

@*param* `text` — The text to display

@*param* `color` — The color to display the text in.

@*return* `result` — A formatted string wrapped in syntax to display `text` in the `color` desired at full opacity

See: [HexColorPresets](file:///Users/pranavchary/Documents/repos/PranGearView/Constants.lua#114#9) for a list of predefined colors such as class colors, item quality, etc.

## CompressTable


```lua
function PranGearView.CompressTable(tbl: table)
```

Removes gaps in indicies of a table if values are `nil`. This modifies the `table` provided in the `tbl` argument and does not return a new one.

@*param* `tbl` — The table to compress indicies for

## ConvertHexToRGB


```lua
function PranGearView.ConvertHexToRGB(hex: string)
  -> red: number|nil
  2. green: number|nil
  3. blue: number|nil
```

Converts a hexadecimal code (without the leading '#' character) into its corresponding red, green, and blue decimal values

@*param* `hex` — The hex code to convert to RGB values

@*return* `red` — The red value for the color expressed as a decimal between `0` and `255`. Returns `nil` if the supplied hex code is invalid

@*return* `green` — The green value for the color expressed as a decimal between `0` and `255`. Returns `nil` if the supplied hex code is invalid

@*return* `blue` — The blue value for the color expressed as a decimal between `0` and `255`. Returns `nil` if the supplied hex code is invalid

## ConvertRGBToHex


```lua
function PranGearView.ConvertRGBToHex(r: number, g: number, b: number)
  -> hexadecimal: string
```

Converts color values for red, green, and blue into their corresponding hexadecimal code

@*param* `r` — The red value for the color expressed as a decimal between `0` and `255`

@*param* `g` — The green value for the color expressed as a decimal between `0` and `255`

@*param* `b` — The blue value for the color expressed as a decimal between `0` and `255`

@*return* `hexadecimal` — The corresponding hexadecimal code for the provided red, green, and blue decimal values at full opacity without the leading '#' character

## CreateOptionsSpacer


```lua
function PranGearView.CreateOptionsSpacer(order: number, width?: number)
  -> spacer: { type: "description", name: " ", order: number, width: number? }
```

Creates a blank entry to display a space or create separation between items in the AddOn options menu

@*param* `order` — The position of the blank entry in the immediate parent object

@*param* `width` — A specified width for the spacer if a full line is not desired

@*return* `spacer` — A table entry for showing a blank space between option elements

## CurrentExpac


```lua
table
```

## DKEnchantAbbr


```lua
enum DKEnchantAbbr
```

## DebugPrint


```lua
function PranGearView.DebugPrint(...string|number)
```

Prints the desired text if the AddOn is in debugging mode. This is just a wrapper around the standard `print` function.
See: [print](file:///Users/pranavchary/.vscode/extensions/sumneko.lua-3.14.0-darwin-arm64/server/meta/Lua%205.4%20en-us%20utf8/basic.lua#235#9)

## DebugTable


```lua
function PranGearView.DebugTable(tbl: table)
```

Prints the contents of a Lua table as key-value pairs if the AddOn is in debugging mode.

@*param* `tbl` — The table to print key-value pairs for

## DefaultStatOrder


```lua
enum DefaultStatOrder
```

## DefaultTankStatOrder


```lua
enum DefaultTankStatOrder
```

## EnchantTextReplace


```lua
{ [number]: TextReplacement }
```

A list of tables containing text replacement patterns for enchants

## ExpansionInfo


```lua
table
```

See:
  * ~Frame~ for generic definition along without common functions and variables available for all Frames
  * [InspectInfo](file:///Users/pranavchary/Documents/repos/PranGearView/Constants.lua#162#10) for a list of Frame names available when the Inspect window is open

## GearSlots


```lua
table
```

## GetCharacterCurrentSpecIDAndRole


```lua
(method) PranGearView:GetCharacterCurrentSpecIDAndRole()
  -> specID: number
  2. role: string
```

Returns specialization ID and role for the logged-in character

@*return* `specID` — The specialization ID for the currently logged in character

@*return* `role` — The role that the current specialization serves ("TANK", "DAMAGER", "HEALER")

See: [SpecOptionKeys](file:///Users/pranavchary/Documents/repos/PranGearView/Constants.lua#267#9) for a list of specializations and their IDs

## GetEnchantmentBySlot


```lua
(method) PranGearView:GetEnchantmentBySlot(slot: Slot, isInspect?: boolean)
```

Fetches and formats the enchant details for an item in the defined gear slot (if one exists).
If an item that can be enchanted isn't and the option to show missing enchants is enabled, this will also be indicated in the formatted text.

@*param* `slot` — The gear slot to get gem information for

@*param* `isInspect` — Whether or not a character is currently being inspected

## GetGemsBySlot


```lua
(method) PranGearView:GetGemsBySlot(slot: Slot, isInspect?: boolean)
```

Fetches and formats the gems currently socketed for an item in the defined gear slot (if one exists).
If sockets are empty/can be addded to the item and the option to show missing sockets is enabled, these will also be indicated in the formatted text.

@*param* `slot` — The gear slot to get gem information for

@*param* `isInspect` — Whether or not a character is currently being inspected

## GetItemLevelBySlot


```lua
(method) PranGearView:GetItemLevelBySlot(slot: Slot, isInspect?: boolean)
```

Fetches and formats the item level for an item in the defined gear slot (if one exists)

@*param* `slot` — The gear slot to get item level for

@*param* `isInspect` — Whether or not a character is currently being inspected

## GetSlotIsLeftSide


```lua
(method) PranGearView:GetSlotIsLeftSide(slot: Slot, isInspect?: boolean)
  -> result: boolean|nil
```

Indicates whether a gear slot is positioned to the left of the character model in the default Character Info/Inspect windows or not

@*param* `slot` — The gear slot to check

@*param* `isInspect` — Whether a player is being inspected or not

@*return* `result` — Returns `nil` if the slot is for a weapon or off-hand item, `true` if the slot is to the left of the character model, and `false` otherwise

## GetSpecAndRoleForSelectedCharacterStatsOption


```lua
(method) PranGearView:GetSpecAndRoleForSelectedCharacterStatsOption()
  -> specID: number
  2. role: string
```

Returns specialization ID and role for the chosen spec whenever it is changed in the options menu

@*return* `specID` — The specialization ID for the currently logged in character

@*return* `role` — The role that the current specialization serves ("TANK", "DAMAGER", "HEALER")

See: [SpecOptionKeys](file:///Users/pranavchary/Documents/repos/PranGearView/Constants.lua#267#9) for a list of specializations and their IDs

## GetStatOrderHandler


```lua
(method) PranGearView:GetStatOrderHandler(item: string)
  -> order: number
```

Retrieves the current order for a stat based on currently chosen specialization in the Character Stats options group

@*param* `item` — The stat to retrieve current order for

@*return* `order` — The order of a stat as per the database

## GetStatOrderValuesHandler


```lua
(method) PranGearView:GetStatOrderValuesHandler()
  -> options: table<number, number>
```

Retrieves selectable values for stat order dropdowns based on currently chosen specialization in the Character Stats options group

@*return* `options` — A list of the order in which options should appear in the dropdown

## GetTableSize


```lua
function PranGearView.GetTableSize(tbl: table)
  -> count: number
```

@*param* `tbl` — Table to count entries for

@*return* `count` — The number of entries in `tbl`

## GetTextureAtlasString


```lua
function PranGearView.GetTextureAtlasString(atlas: string, dim?: number)
  -> text: string
```

Formats `atlas` to be displayed in-game using square dimensions. This differs from `GetTextureString` in that atlases use filenames rather than ID numbers to render

@*param* `atlas` — the filename or atlas alias for the texture to render

@*param* `dim` — The value to be used for the height & width of the texture. Default value is `15`

@*return* `text` — A formatted string wrapped in syntax to display `atlas`

## GetTextureString


```lua
function PranGearView.GetTextureString(texture: number, dim?: number)
  -> text: string
```

Formats `texture` to be displayed in-game using square dimensions

@*param* `texture` — the ID for the texture to render

@*param* `dim` — The value to be used for the height & width of the texture. Default value is `15`

@*return* `text` — A formatted string wrapped in syntax to display `texture`

## GetUpgradeTrackBySlot


```lua
(method) PranGearView:GetUpgradeTrackBySlot(slot: Slot, isInspect?: boolean)
```

Fetches and formats the upgrade track for an item in the defined gear slot (if one exists)

@*param* `slot` — The gear slot to get item level for

@*param* `isInspect` — Whether or not a character is currently being inspected

## HandleEquipmentOrSettingsChange


```lua
(method) PranGearView:HandleEquipmentOrSettingsChange()
```

Handles changes to equipped gear or AddOn settings when Character Info and/or Inspect window is visible

## HexColorPresets


```lua
enum HexColorPresets
```

## InitializeCustomSpecStatOrderDB


```lua
(method) PranGearView:InitializeCustomSpecStatOrderDB(selectedSpecID?: number, reset?: boolean)
```

Initializes a stat order entry in the database for the specialization defined by `selectedSpecID`.

@*param* `selectedSpecID` — The specialization ID to update the database format

@*param* `reset` — `true` if stat order is being reset to default values, `false` otherwise

## InspectInfo


```lua
InspectInfo
```

## IsAuxSocketableSlot


```lua
(method) PranGearView:IsAuxSocketableSlot(slot: Slot)
  -> result: boolean
```

Indicates whether an item equipped in a particular gear slot can have a gem socket added to it via auxillary methods (example: S.A.D. in The War Within)

@*param* `slot` — The gear slot to check for socketable equipment

@*return* `result` — `true` if the item can have a socket via auxillary methods, `false` otherwise

## IsEnchantableSlot


```lua
(method) PranGearView:IsEnchantableSlot(slot: Slot)
  -> result: boolean
```

Indicates whether an item equipped in a particular gear slot can be enchanted or not

@*param* `slot` — The gear slot to check for enchantable equipment

@*return* `result` — `true` if the item can be enchanted, `false` otherwise

## IsItemEquippedInSlot


```lua
(method) PranGearView:IsItemEquippedInSlot(slot: Slot, isInspect?: boolean)
  -> hasItem: boolean
  2. item: ItemMixin
```

Indicates whether an item is equipped in a particular gear slot or not

@*param* `slot` — The gear slot to check for an equipped item

@*param* `isInspect` — Whether a player is being inspected or not

@*return* `hasItem` — `true` if the slot has an item equipped in it, `false` otherwise

@*return* `item` — The equipped item. When `hasItem` is `false`, this is always an empty table

## IsSocketableSlot


```lua
(method) PranGearView:IsSocketableSlot(slot: Slot)
  -> result: boolean
```

Indicates whether an item equipped in a particular gear slot can have a gem socket added to it

@*param* `slot` — The gear slot to check for socketable equipment

@*return* `result` — `true` if the item can have a socket, `false` otherwise

## OnInitialize


```lua
(method) PranGearView:OnInitialize()
```

## OutlineOptions


```lua
{ [number]: OutlineOption }
```

## PGVToggleEnchantButton


```lua
unknown
```

## RaceIcons


```lua
{ [string]: RaceGender }
```

## ReorderStatFramesBySpec


```lua
(method) PranGearView:ReorderStatFramesBySpec()
```

Reorders stats in the Character Info window based on the custom order defined in the Character Stats options

## RoundNumber


```lua
function PranGearView.RoundNumber(val: number)
  -> number: number
```

Utility function to round numbers

@*param* `val` — The number to round

@*return* `number` — The provided number rounded to the nearest whole number

## SetEnchantPositionBySlot


```lua
(method) PranGearView:SetEnchantPositionBySlot(slot: Slot)
```

Set enchant text position in the Character Info window

@*param* `slot` — The gear slot to set enchant position for

## SetGemsPositionBySlot


```lua
(method) PranGearView:SetGemsPositionBySlot(slot: Slot)
```

Set gems text position in the Character Info window

@*param* `slot` — The gear slot to set gems position for

## SetInspectEnchantPositionBySlot


```lua
(method) PranGearView:SetInspectEnchantPositionBySlot(slot: Slot)
```

Set enchant text position in the Inspect window

@*param* `slot` — The gear slot to set enchant position for

## SetInspectGemsPositionBySlot


```lua
(method) PranGearView:SetInspectGemsPositionBySlot(slot: Slot)
```

Set gems text position in the Inspect window

@*param* `slot` — The gear slot to set gems position for

## SetInspectItemLevelPositionBySlot


```lua
(method) PranGearView:SetInspectItemLevelPositionBySlot(slot: Slot)
```

Set item level text position in the Inspect window

@*param* `slot` — The gear slot to set item level position for

## SetInspectUpgradeTrackPositionBySlot


```lua
(method) PranGearView:SetInspectUpgradeTrackPositionBySlot(slot: Slot)
```

Set upgrade track text position in the Inspect window

@*param* `slot` — The gear slot to set upgrade tracks position for

## SetItemLevelPositionBySlot


```lua
(method) PranGearView:SetItemLevelPositionBySlot(slot: Slot)
```

Set item level text position in the Character Info window

@*param* `slot` — The gear slot to set item level position for

## SetStatOrderHandler


```lua
(method) PranGearView:SetStatOrderHandler(item: any, val: any)
```

Handles setting changes to stat order options

@*param* `item` — The stat to modify the display order for, typically a `string` containing the name of the key in the database table

@*param* `val` — The value to set in the database for the stat defined by `item`

## SetUpgradeTrackPositionBySlot


```lua
(method) PranGearView:SetUpgradeTrackPositionBySlot(slot: Slot)
```

Set upgrade track text position in the Character Info window

@*param* `slot` — The gear slot to set upgrade tracks position for

## ShowDurabilityBySlot


```lua
(method) PranGearView:ShowDurabilityBySlot(slot: Slot)
```

Fetches and formats the durability percentage for an item in the defined gear slot (if one exists).

@*param* `slot` — The gear slot to get durability information for

## ShowEmbellishmentBySlot


```lua
(method) PranGearView:ShowEmbellishmentBySlot(slot: Slot, isInspect?: boolean)
```

Fetches and formats embellishment details for an item in the defined gear slot (if one exists and is embellished)

@*param* `slot` — The gear slot to get gem information for

@*param* `isInspect` — Whether or not a character is currently being inspected

## SpecOptionKeys


```lua
enum SpecOptionKeys
```

## TooltipDataType


```lua
enum TooltipDataType
```

## UpdateEquippedGearInfo


```lua
(method) PranGearView:UpdateEquippedGearInfo()
```

Updates information displayed in the Character Info window

## UpdateInspectedGearInfo


```lua
(method) PranGearView:UpdateInspectedGearInfo(unitGUID: string, forceUpdate?: boolean)
```

Updates displayed info in the Inspect window when AddOn settings are changed or a new character is inspected

@*param* `unitGUID` — The Globally Unique Identifier (GUID) for the character being inspected

@*param* `forceUpdate` — Whether or not to force an update to the information displayed

## UpgradeTextReplace


```lua
{ [number]: TextReplacement }
```

A list of tables containing text replacement patterns for upgrade tracks

## db


```lua
unknown
```

 Load database


---

# RaceGender

## Female


```lua
string
```

The atlas alias for the icon corresponding to a female of the associated race

## Male


```lua
string
```

The atlas alias for the icon corresponding to a male of the associated race


---

# Slot

## IsLeftSide


```lua
boolean|nil
```

Indicates whether the equipment slot is on the left, right, or bottom of the Character model in the default UI Character Info and Inspect windows

## PGVDurability


```lua
FontString?
```

## PGVEmbellishmentTexture


```lua
Texture?
```

## PGVEnchant


```lua
FontString?
```

## PGVGems


```lua
FontString?
```

## PGVItemLevel


```lua
FontString?
```

## PGVUpgradeTrack


```lua
FontString?
```


---

# TextReplacement

## original


```lua
string
```

The localization key for the original text to search for when abbreviating text

## replacement


```lua
string
```

The localization key for the abbreviation for the original text
