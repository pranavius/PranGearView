# BuildCharacterFrame


```lua
function BuildCharacterFrame()
```


---

# CloseSpecialWindows


```lua
function CloseSpecialWindows()
  -> boolean
```


---

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

A list of gear slots that can have a gem socket added to it via auxillary methods in the expansion (example: S.A.D. in The War Within). Slots can be defined as either a Frame or string containing the name of a frame.

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

A list of gear slots that can have a gem socket added to it in the expansion. Slots can be defined as either a Frame or string containing the name of a frame.


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

# LuaLS


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

See: [HexColorPresets](file:///Users/pranavchary/Documents/repos/PranGearView/Globals.lua#110#9) for a list of predefined colors such as class colors, item quality, etc.

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
function PranGearView.CreateOptionsSpacer(order: number)
  -> spacer: { type: "description", name: " ", order: number }
```

Creates a blank entry to display a space or create separation between items in the AddOn options menu

@*param* `order` — The position of the blank entry in the immediate parent object

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

## ExpansionInfo


```lua
table
```

See:
  * ~Frame~ for generic definition along without common functions and variables available for all Frames
  * [InspectInfo](file:///Users/pranavchary/Documents/repos/PranGearView/Globals.lua#158#10) for a list of Frame names available when the Inspect window is open

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

See: [SpecOptions](file:///Users/pranavchary/Documents/repos/PranGearView/Globals.lua#263#9) for a list of specializations and their IDs

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

See: [SpecOptions](file:///Users/pranavchary/Documents/repos/PranGearView/Globals.lua#263#9) for a list of specializations and their IDs

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

@*return* `options` — A table of the order in which options should appear in the dropdown

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

## SpecOptions


```lua
enum SpecOptions
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

The original text to search for when abbreviating text

## replacement


```lua
string
```

The abbreviation for the original text


---

# _


```lua
unknown
```


```lua
unknown
```


```lua
unknown
```


---

# _G


---

# _G


```lua
_G
```


---

# _VERSION


```lua
string
```


---

# any


---

# arg


```lua
string[]
```


---

# assert


```lua
function assert(v?: <T>, message?: any, ...any)
  -> <T>
  2. ...any
```


---

# boolean


---

# collectgarbage


```lua
function collectgarbage(opt?: "collect"|"count"|"generational"|"incremental"|"isrunning"...(+3), ...any)
  -> any
```


---

# coroutine


```lua
coroutinelib
```


---

# coroutine.close


```lua
function coroutine.close(co: thread)
  -> noerror: boolean
  2. errorobject: any
```


---

# coroutine.create


```lua
function coroutine.create(f: fun(...any):...unknown)
  -> thread
```


---

# coroutine.isyieldable


```lua
function coroutine.isyieldable(co?: thread)
  -> boolean
```


---

# coroutine.resume


```lua
function coroutine.resume(co: thread, val1?: any, ...any)
  -> success: boolean
  2. ...any
```


---

# coroutine.running


```lua
function coroutine.running()
  -> running: thread
  2. ismain: boolean
```


---

# coroutine.status


```lua
function coroutine.status(co: thread)
  -> "dead"|"normal"|"running"|"suspended"
```


---

# coroutine.wrap


```lua
function coroutine.wrap(f: fun(...any):...unknown)
  -> fun(...any):...unknown
```


---

# coroutine.yield


```lua
(async) function coroutine.yield(...any)
  -> ...any
```


---

# coroutinelib

## close


```lua
function coroutine.close(co: thread)
  -> noerror: boolean
  2. errorobject: any
```


Closes coroutine `co` , closing all its pending to-be-closed variables and putting the coroutine in a dead state.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-coroutine.close"])

## create


```lua
function coroutine.create(f: fun(...any):...unknown)
  -> thread
```


Creates a new coroutine, with body `f`. `f` must be a function. Returns this new coroutine, an object with type `"thread"`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-coroutine.create"])

## isyieldable


```lua
function coroutine.isyieldable(co?: thread)
  -> boolean
```


Returns true when the coroutine `co` can yield. The default for `co` is the running coroutine.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-coroutine.isyieldable"])

## resume


```lua
function coroutine.resume(co: thread, val1?: any, ...any)
  -> success: boolean
  2. ...any
```


Starts or continues the execution of coroutine `co`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-coroutine.resume"])

## running


```lua
function coroutine.running()
  -> running: thread
  2. ismain: boolean
```


Returns the running coroutine plus a boolean, true when the running coroutine is the main one.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-coroutine.running"])

## status


```lua
function coroutine.status(co: thread)
  -> "dead"|"normal"|"running"|"suspended"
```


Returns the status of coroutine `co`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-coroutine.status"])


```lua
return #1:
    | "running" -- Is running.
    | "suspended" -- Is suspended or not started.
    | "normal" -- Is active but not running.
    | "dead" -- Has finished or stopped with an error.
```

## wrap


```lua
function coroutine.wrap(f: fun(...any):...unknown)
  -> fun(...any):...unknown
```


Creates a new coroutine, with body `f`; `f` must be a function. Returns a function that resumes the coroutine each time it is called.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-coroutine.wrap"])

## yield


```lua
(async) function coroutine.yield(...any)
  -> ...any
```


Suspends the execution of the calling coroutine.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-coroutine.yield"])


---

# debug


```lua
debuglib
```


---

# debug.debug


```lua
function debug.debug()
```


---

# debug.getfenv


```lua
function debug.getfenv(o: any)
  -> table
```


---

# debug.gethook


```lua
function debug.gethook(co?: thread)
  -> hook: function
  2. mask: string
  3. count: integer
```


---

# debug.getinfo


```lua
function debug.getinfo(thread: thread, f: integer|fun(...any):...unknown, what?: string|"L"|"S"|"f"|"l"...(+4))
  -> debuginfo
```


---

# debug.getlocal


```lua
function debug.getlocal(thread: thread, f: integer|fun(...any):...unknown, index: integer)
  -> name: string
  2. value: any
```


---

# debug.getmetatable


```lua
function debug.getmetatable(object: any)
  -> metatable: table
```


---

# debug.getregistry


```lua
function debug.getregistry()
  -> table
```


---

# debug.getupvalue


```lua
function debug.getupvalue(f: fun(...any):...unknown, up: integer)
  -> name: string
  2. value: any
```


---

# debug.getuservalue


```lua
function debug.getuservalue(u: userdata, n?: integer)
  -> any
  2. boolean
```


---

# debug.setcstacklimit


```lua
function debug.setcstacklimit(limit: integer)
  -> boolean|integer
```


---

# debug.setfenv


```lua
function debug.setfenv(object: <T>, env: table)
  -> object: <T>
```


---

# debug.sethook


```lua
function debug.sethook(thread: thread, hook: fun(...any):...unknown, mask: string|"c"|"l"|"r", count?: integer)
```


---

# debug.setlocal


```lua
function debug.setlocal(thread: thread, level: integer, index: integer, value: any)
  -> name: string
```


---

# debug.setmetatable


```lua
function debug.setmetatable(value: <T>, meta?: table)
  -> value: <T>
```


---

# debug.setupvalue


```lua
function debug.setupvalue(f: fun(...any):...unknown, up: integer, value: any)
  -> name: string
```


---

# debug.setuservalue


```lua
function debug.setuservalue(udata: userdata, value: any, n?: integer)
  -> udata: userdata
```


---

# debug.traceback


```lua
function debug.traceback(thread: thread, message?: any, level?: integer)
  -> message: string
```


---

# debug.upvalueid


```lua
function debug.upvalueid(f: fun(...any):...unknown, n: integer)
  -> id: lightuserdata
```


---

# debug.upvaluejoin


```lua
function debug.upvaluejoin(f1: fun(...any):...unknown, n1: integer, f2: fun(...any):...unknown, n2: integer)
```


---

# debuginfo

## activelines


```lua
table
```

## currentline


```lua
integer
```

## ftransfer


```lua
integer
```

## func


```lua
function
```

## istailcall


```lua
boolean
```

## isvararg


```lua
boolean
```

## lastlinedefined


```lua
integer
```

## linedefined


```lua
integer
```

## name


```lua
string
```

## namewhat


```lua
string
```

## nparams


```lua
integer
```

## ntransfer


```lua
integer
```

## nups


```lua
integer
```

## short_src


```lua
string
```

## source


```lua
string
```

## what


```lua
string
```


---

# debuglib

## debug


```lua
function debug.debug()
```


Enters an interactive mode with the user, running each string that the user enters.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.debug"])

## getfenv


```lua
function debug.getfenv(o: any)
  -> table
```


Returns the environment of object `o` .

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.getfenv"])

## gethook


```lua
function debug.gethook(co?: thread)
  -> hook: function
  2. mask: string
  3. count: integer
```


Returns the current hook settings of the thread.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.gethook"])

## getinfo


```lua
function debug.getinfo(thread: thread, f: integer|fun(...any):...unknown, what?: string|"L"|"S"|"f"|"l"...(+4))
  -> debuginfo
```


Returns a table with information about a function.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.getinfo"])


---

```lua
what:
   +> "n" -- `name` and `namewhat`
   +> "S" -- `source`, `short_src`, `linedefined`, `lastlinedefined`, and `what`
   +> "l" -- `currentline`
   +> "t" -- `istailcall`
   +> "u" -- `nups`, `nparams`, and `isvararg`
   +> "f" -- `func`
   +> "r" -- `ftransfer` and `ntransfer`
   +> "L" -- `activelines`
```

## getlocal


```lua
function debug.getlocal(thread: thread, f: integer|fun(...any):...unknown, index: integer)
  -> name: string
  2. value: any
```


Returns the name and the value of the local variable with index `local` of the function at level `f` of the stack.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.getlocal"])

## getmetatable


```lua
function debug.getmetatable(object: any)
  -> metatable: table
```


Returns the metatable of the given value.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.getmetatable"])

## getregistry


```lua
function debug.getregistry()
  -> table
```


Returns the registry table.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.getregistry"])

## getupvalue


```lua
function debug.getupvalue(f: fun(...any):...unknown, up: integer)
  -> name: string
  2. value: any
```


Returns the name and the value of the upvalue with index `up` of the function.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.getupvalue"])

## getuservalue


```lua
function debug.getuservalue(u: userdata, n?: integer)
  -> any
  2. boolean
```


Returns the `n`-th user value associated
to the userdata `u` plus a boolean,
`false` if the userdata does not have that value.


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.getuservalue"])

## setcstacklimit


```lua
function debug.setcstacklimit(limit: integer)
  -> boolean|integer
```


### **Deprecated in `Lua 5.4.2`**

Sets a new limit for the C stack. This limit controls how deeply nested calls can go in Lua, with the intent of avoiding a stack overflow.

In case of success, this function returns the old limit. In case of error, it returns `false`.


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.setcstacklimit"])

## setfenv


```lua
function debug.setfenv(object: <T>, env: table)
  -> object: <T>
```


Sets the environment of the given `object` to the given `table` .

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.setfenv"])

## sethook


```lua
function debug.sethook(thread: thread, hook: fun(...any):...unknown, mask: string|"c"|"l"|"r", count?: integer)
```


Sets the given function as a hook.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.sethook"])


---

```lua
mask:
   +> "c" -- Calls hook when Lua calls a function.
   +> "r" -- Calls hook when Lua returns from a function.
   +> "l" -- Calls hook when Lua enters a new line of code.
```

## setlocal


```lua
function debug.setlocal(thread: thread, level: integer, index: integer, value: any)
  -> name: string
```


Assigns the `value` to the local variable with index `local` of the function at `level` of the stack.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.setlocal"])

## setmetatable


```lua
function debug.setmetatable(value: <T>, meta?: table)
  -> value: <T>
```


Sets the metatable for the given value to the given table (which can be `nil`).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.setmetatable"])

## setupvalue


```lua
function debug.setupvalue(f: fun(...any):...unknown, up: integer, value: any)
  -> name: string
```


Assigns the `value` to the upvalue with index `up` of the function.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.setupvalue"])

## setuservalue


```lua
function debug.setuservalue(udata: userdata, value: any, n?: integer)
  -> udata: userdata
```


Sets the given `value` as
the `n`-th user value associated to the given `udata`.
`udata` must be a full userdata.


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.setuservalue"])

## traceback


```lua
function debug.traceback(thread: thread, message?: any, level?: integer)
  -> message: string
```


Returns a string with a traceback of the call stack. The optional message string is appended at the beginning of the traceback.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.traceback"])

## upvalueid


```lua
function debug.upvalueid(f: fun(...any):...unknown, n: integer)
  -> id: lightuserdata
```


Returns a unique identifier (as a light userdata) for the upvalue numbered `n` from the given function.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.upvalueid"])

## upvaluejoin


```lua
function debug.upvaluejoin(f1: fun(...any):...unknown, n1: integer, f2: fun(...any):...unknown, n2: integer)
```


Make the `n1`-th upvalue of the Lua closure `f1` refer to the `n2`-th upvalue of the Lua closure `f2`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-debug.upvaluejoin"])


---

# dofile


```lua
function dofile(filename?: string)
  -> ...any
```


---

# error


```lua
function error(message: any, level?: integer)
```


---

# exitcode


---

# false


---

# file*

## close


```lua
(method) file*:close()
  -> suc: boolean?
  2. exitcode: ("exit"|"signal")?
  3. code: integer?
```


Close `file`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-file:close"])


```lua
exitcode:
    | "exit"
    | "signal"
```

## flush


```lua
(method) file*:flush()
```


Saves any written data to `file`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-file:flush"])

## lines


```lua
(method) file*:lines(...string|integer|"L"|"a"|"l"...(+1))
  -> fun():any, ...unknown
```


------
```lua
for c in file:lines(...) do
    body
end
```


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-file:lines"])


```lua
...(param):
    | "n" -- Reads a numeral and returns it as number.
    | "a" -- Reads the whole file.
   -> "l" -- Reads the next line skipping the end of line.
    | "L" -- Reads the next line keeping the end of line.
```

## read


```lua
(method) file*:read(...string|integer|"L"|"a"|"l"...(+1))
  -> any
  2. ...any
```


Reads the `file`, according to the given formats, which specify what to read.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-file:read"])


```lua
...(param):
    | "n" -- Reads a numeral and returns it as number.
    | "a" -- Reads the whole file.
   -> "l" -- Reads the next line skipping the end of line.
    | "L" -- Reads the next line keeping the end of line.
```

## seek


```lua
(method) file*:seek(whence?: "cur"|"end"|"set", offset?: integer)
  -> offset: integer
  2. errmsg: string?
```


Sets and gets the file position, measured from the beginning of the file.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-file:seek"])


```lua
whence:
    | "set" -- Base is beginning of the file.
   -> "cur" -- Base is current position.
    | "end" -- Base is end of file.
```

## setvbuf


```lua
(method) file*:setvbuf(mode: "full"|"line"|"no", size?: integer)
```


Sets the buffering mode for an output file.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-file:setvbuf"])


```lua
mode:
    | "no" -- Output operation appears immediately.
    | "full" -- Performed only when the buffer is full.
    | "line" -- Buffered until a newline is output.
```

## write


```lua
(method) file*:write(...string|number)
  -> file*?
  2. errmsg: string?
```


Writes the value of each of its arguments to `file`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-file:write"])


---

# filetype


---

# function


---

# gcoptions


---

# getfenv


```lua
function getfenv(f?: integer|fun(...any):...unknown)
  -> table
```


---

# getmetatable


```lua
function getmetatable(object: any)
  -> metatable: table
```


---

# hookmask


---

# infowhat


---

# integer


---

# io


```lua
iolib
```


---

# io.close


```lua
function io.close(file?: file*)
  -> suc: boolean?
  2. exitcode: ("exit"|"signal")?
  3. code: integer?
```


---

# io.flush


```lua
function io.flush()
```


---

# io.input


```lua
function io.input(file: string|file*)
```


---

# io.lines


```lua
function io.lines(filename?: string, ...string|integer|"L"|"a"|"l"...(+1))
  -> fun():any, ...unknown
```


---

# io.open


```lua
function io.open(filename: string, mode?: "a"|"a+"|"a+b"|"ab"|"r"...(+7))
  -> file*?
  2. errmsg: string?
```


---

# io.output


```lua
function io.output(file: string|file*)
```


---

# io.popen


```lua
function io.popen(prog: string, mode?: "r"|"w")
  -> file*?
  2. errmsg: string?
```


---

# io.read


```lua
function io.read(...string|integer|"L"|"a"|"l"...(+1))
  -> any
  2. ...any
```


---

# io.tmpfile


```lua
function io.tmpfile()
  -> file*
```


---

# io.type


```lua
function io.type(file: file*)
  -> "closed file"|"file"|`nil`
```


---

# io.write


```lua
function io.write(...any)
  -> file*
  2. errmsg: string?
```


---

# iolib

## close


```lua
function io.close(file?: file*)
  -> suc: boolean?
  2. exitcode: ("exit"|"signal")?
  3. code: integer?
```


Close `file` or default output file.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-io.close"])


```lua
exitcode:
    | "exit"
    | "signal"
```

## flush


```lua
function io.flush()
```


Saves any written data to default output file.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-io.flush"])

## input


```lua
function io.input(file: string|file*)
```


Sets `file` as the default input file.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-io.input"])

## lines


```lua
function io.lines(filename?: string, ...string|integer|"L"|"a"|"l"...(+1))
  -> fun():any, ...unknown
```


------
```lua
for c in io.lines(filename, ...) do
    body
end
```


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-io.lines"])


```lua
...(param):
    | "n" -- Reads a numeral and returns it as number.
    | "a" -- Reads the whole file.
   -> "l" -- Reads the next line skipping the end of line.
    | "L" -- Reads the next line keeping the end of line.
```

## open


```lua
function io.open(filename: string, mode?: "a"|"a+"|"a+b"|"ab"|"r"...(+7))
  -> file*?
  2. errmsg: string?
```


Opens a file, in the mode specified in the string `mode`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-io.open"])


```lua
mode:
   -> "r" -- Read mode.
    | "w" -- Write mode.
    | "a" -- Append mode.
    | "r+" -- Update mode, all previous data is preserved.
    | "w+" -- Update mode, all previous data is erased.
    | "a+" -- Append update mode, previous data is preserved, writing is only allowed at the end of file.
    | "rb" -- Read mode. (in binary mode.)
    | "wb" -- Write mode. (in binary mode.)
    | "ab" -- Append mode. (in binary mode.)
    | "r+b" -- Update mode, all previous data is preserved. (in binary mode.)
    | "w+b" -- Update mode, all previous data is erased. (in binary mode.)
    | "a+b" -- Append update mode, previous data is preserved, writing is only allowed at the end of file. (in binary mode.)
```

## output


```lua
function io.output(file: string|file*)
```


Sets `file` as the default output file.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-io.output"])

## popen


```lua
function io.popen(prog: string, mode?: "r"|"w")
  -> file*?
  2. errmsg: string?
```


Starts program prog in a separated process.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-io.popen"])


```lua
mode:
    | "r" -- Read data from this program by `file`.
    | "w" -- Write data to this program by `file`.
```

## read


```lua
function io.read(...string|integer|"L"|"a"|"l"...(+1))
  -> any
  2. ...any
```


Reads the `file`, according to the given formats, which specify what to read.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-io.read"])


```lua
...(param):
    | "n" -- Reads a numeral and returns it as number.
    | "a" -- Reads the whole file.
   -> "l" -- Reads the next line skipping the end of line.
    | "L" -- Reads the next line keeping the end of line.
```

## stderr


```lua
file*
```


standard error.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-io.stderr"])


## stdin


```lua
file*
```


standard input.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-io.stdin"])


## stdout


```lua
file*
```


standard output.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-io.stdout"])


## tmpfile


```lua
function io.tmpfile()
  -> file*
```


In case of success, returns a handle for a temporary file.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-io.tmpfile"])

## type


```lua
function io.type(file: file*)
  -> "closed file"|"file"|`nil`
```


Checks whether `obj` is a valid file handle.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-io.type"])


```lua
return #1:
    | "file" -- Is an open file handle.
    | "closed file" -- Is a closed file handle.
    | `nil` -- Is not a file handle.
```

## write


```lua
function io.write(...any)
  -> file*
  2. errmsg: string?
```


Writes the value of each of its arguments to default output file.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-io.write"])


---

# ipairs


```lua
function ipairs(t: <T:table>)
  -> fun(table: <V>[], i?: integer):integer, <V>
  2. <T:table>
  3. i: integer
```


---

# lightuserdata


---

# load


```lua
function load(chunk: string|function, chunkname?: string, mode?: "b"|"bt"|"t", env?: table)
  -> function?
  2. error_message: string?
```


---

# loadfile


```lua
function loadfile(filename?: string, mode?: "b"|"bt"|"t", env?: table)
  -> function?
  2. error_message: string?
```


---

# loadmode


---

# loadstring


```lua
function loadstring(text: string, chunkname?: string)
  -> function?
  2. error_message: string?
```


---

# localecategory


---

# math


```lua
mathlib
```


---

# math.abs


```lua
function math.abs(x: <Number:number>)
  -> <Number:number>
```


---

# math.acos


```lua
function math.acos(x: number)
  -> number
```


---

# math.asin


```lua
function math.asin(x: number)
  -> number
```


---

# math.atan


```lua
function math.atan(y: number, x?: number)
  -> number
```


---

# math.atan2


```lua
function math.atan2(y: number, x: number)
  -> number
```


---

# math.ceil


```lua
function math.ceil(x: number)
  -> integer
```


---

# math.cos


```lua
function math.cos(x: number)
  -> number
```


---

# math.cosh


```lua
function math.cosh(x: number)
  -> number
```


---

# math.deg


```lua
function math.deg(x: number)
  -> number
```


---

# math.exp


```lua
function math.exp(x: number)
  -> number
```


---

# math.floor


```lua
function math.floor(x: number)
  -> integer
```


---

# math.fmod


```lua
function math.fmod(x: number, y: number)
  -> number
```


---

# math.frexp


```lua
function math.frexp(x: number)
  -> m: number
  2. e: number
```


---

# math.ldexp


```lua
function math.ldexp(m: number, e: number)
  -> number
```


---

# math.log


```lua
function math.log(x: number, base?: integer)
  -> number
```


---

# math.log10


```lua
function math.log10(x: number)
  -> number
```


---

# math.max


```lua
function math.max(x: <Number:number>, ...<Number:number>)
  -> <Number:number>
```


---

# math.min


```lua
function math.min(x: <Number:number>, ...<Number:number>)
  -> <Number:number>
```


---

# math.modf


```lua
function math.modf(x: number)
  -> integer
  2. number
```


---

# math.pow


```lua
function math.pow(x: number, y: number)
  -> number
```


---

# math.rad


```lua
function math.rad(x: number)
  -> number
```


---

# math.random


```lua
function math.random(m: integer, n: integer)
  -> integer
```


---

# math.randomseed


```lua
function math.randomseed(x?: integer, y?: integer)
```


---

# math.sin


```lua
function math.sin(x: number)
  -> number
```


---

# math.sinh


```lua
function math.sinh(x: number)
  -> number
```


---

# math.sqrt


```lua
function math.sqrt(x: number)
  -> number
```


---

# math.tan


```lua
function math.tan(x: number)
  -> number
```


---

# math.tanh


```lua
function math.tanh(x: number)
  -> number
```


---

# math.tointeger


```lua
function math.tointeger(x: any)
  -> integer?
```


---

# math.type


```lua
function math.type(x: any)
  -> "float"|"integer"|'nil'
```


---

# math.ult


```lua
function math.ult(m: integer, n: integer)
  -> boolean
```


---

# mathlib

## abs


```lua
function math.abs(x: <Number:number>)
  -> <Number:number>
```


Returns the absolute value of `x`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.abs"])

## acos


```lua
function math.acos(x: number)
  -> number
```


Returns the arc cosine of `x` (in radians).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.acos"])

## asin


```lua
function math.asin(x: number)
  -> number
```


Returns the arc sine of `x` (in radians).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.asin"])

## atan


```lua
function math.atan(y: number, x?: number)
  -> number
```


Returns the arc tangent of `y/x` (in radians).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.atan"])

## atan2


```lua
function math.atan2(y: number, x: number)
  -> number
```


Returns the arc tangent of `y/x` (in radians).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.atan2"])

## ceil


```lua
function math.ceil(x: number)
  -> integer
```


Returns the smallest integral value larger than or equal to `x`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.ceil"])

## cos


```lua
function math.cos(x: number)
  -> number
```


Returns the cosine of `x` (assumed to be in radians).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.cos"])

## cosh


```lua
function math.cosh(x: number)
  -> number
```


Returns the hyperbolic cosine of `x` (assumed to be in radians).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.cosh"])

## deg


```lua
function math.deg(x: number)
  -> number
```


Converts the angle `x` from radians to degrees.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.deg"])

## exp


```lua
function math.exp(x: number)
  -> number
```


Returns the value `e^x` (where `e` is the base of natural logarithms).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.exp"])

## floor


```lua
function math.floor(x: number)
  -> integer
```


Returns the largest integral value smaller than or equal to `x`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.floor"])

## fmod


```lua
function math.fmod(x: number, y: number)
  -> number
```


Returns the remainder of the division of `x` by `y` that rounds the quotient towards zero.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.fmod"])

## frexp


```lua
function math.frexp(x: number)
  -> m: number
  2. e: number
```


Decompose `x` into tails and exponents. Returns `m` and `e` such that `x = m * (2 ^ e)`, `e` is an integer and the absolute value of `m` is in the range [0.5, 1) (or zero when `x` is zero).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.frexp"])

## huge


```lua
number
```


A value larger than any other numeric value.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.huge"])


## ldexp


```lua
function math.ldexp(m: number, e: number)
  -> number
```


Returns `m * (2 ^ e)` .

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.ldexp"])

## log


```lua
function math.log(x: number, base?: integer)
  -> number
```


Returns the logarithm of `x` in the given base.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.log"])

## log10


```lua
function math.log10(x: number)
  -> number
```


Returns the base-10 logarithm of x.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.log10"])

## max


```lua
function math.max(x: <Number:number>, ...<Number:number>)
  -> <Number:number>
```


Returns the argument with the maximum value, according to the Lua operator `<`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.max"])

## maxinteger


```lua
integer
```


Miss locale <math.maxinteger>

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.maxinteger"])


## min


```lua
function math.min(x: <Number:number>, ...<Number:number>)
  -> <Number:number>
```


Returns the argument with the minimum value, according to the Lua operator `<`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.min"])

## mininteger


```lua
integer
```


Miss locale <math.mininteger>

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.mininteger"])


## modf


```lua
function math.modf(x: number)
  -> integer
  2. number
```


Returns the integral part of `x` and the fractional part of `x`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.modf"])

## pi


```lua
number
```


The value of *π*.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.pi"])


## pow


```lua
function math.pow(x: number, y: number)
  -> number
```


Returns `x ^ y` .

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.pow"])

## rad


```lua
function math.rad(x: number)
  -> number
```


Converts the angle `x` from degrees to radians.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.rad"])

## random


```lua
function math.random(m: integer, n: integer)
  -> integer
```


* `math.random()`: Returns a float in the range [0,1).
* `math.random(n)`: Returns a integer in the range [1, n].
* `math.random(m, n)`: Returns a integer in the range [m, n].


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.random"])

## randomseed


```lua
function math.randomseed(x?: integer, y?: integer)
```


* `math.randomseed(x, y)`: Concatenate `x` and `y` into a 128-bit `seed` to reinitialize the pseudo-random generator.
* `math.randomseed(x)`: Equate to `math.randomseed(x, 0)` .
* `math.randomseed()`: Generates a seed with a weak attempt for randomness.


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.randomseed"])

## sin


```lua
function math.sin(x: number)
  -> number
```


Returns the sine of `x` (assumed to be in radians).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.sin"])

## sinh


```lua
function math.sinh(x: number)
  -> number
```


Returns the hyperbolic sine of `x` (assumed to be in radians).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.sinh"])

## sqrt


```lua
function math.sqrt(x: number)
  -> number
```


Returns the square root of `x`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.sqrt"])

## tan


```lua
function math.tan(x: number)
  -> number
```


Returns the tangent of `x` (assumed to be in radians).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.tan"])

## tanh


```lua
function math.tanh(x: number)
  -> number
```


Returns the hyperbolic tangent of `x` (assumed to be in radians).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.tanh"])

## tointeger


```lua
function math.tointeger(x: any)
  -> integer?
```


Miss locale <math.tointeger>

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.tointeger"])

## type


```lua
function math.type(x: any)
  -> "float"|"integer"|'nil'
```


Miss locale <math.type>

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.type"])


```lua
return #1:
    | "integer"
    | "float"
    | 'nil'
```

## ult


```lua
function math.ult(m: integer, n: integer)
  -> boolean
```


Miss locale <math.ult>

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-math.ult"])


---

# metatable

## __add


```lua
fun(t1: any, t2: any):any|nil
```

## __band


```lua
fun(t1: any, t2: any):any|nil
```

## __bnot


```lua
fun(t: any):any|nil
```

## __bor


```lua
fun(t1: any, t2: any):any|nil
```

## __bxor


```lua
fun(t1: any, t2: any):any|nil
```

## __call


```lua
fun(t: any, ...any):...unknown|nil
```

## __close


```lua
fun(t: any, errobj: any):any|nil
```

## __concat


```lua
fun(t1: any, t2: any):any|nil
```

## __div


```lua
fun(t1: any, t2: any):any|nil
```

## __eq


```lua
fun(t1: any, t2: any):boolean|nil
```

## __gc


```lua
fun(t: any)|nil
```

## __idiv


```lua
fun(t1: any, t2: any):any|nil
```

## __index


```lua
table|fun(t: any, k: any):any|nil
```

## __le


```lua
fun(t1: any, t2: any):boolean|nil
```

## __len


```lua
fun(t: any):integer|nil
```

## __lt


```lua
fun(t1: any, t2: any):boolean|nil
```

## __metatable


```lua
any
```

## __mod


```lua
fun(t1: any, t2: any):any|nil
```

## __mode


```lua
'k'|'kv'|'v'|nil
```

## __mul


```lua
fun(t1: any, t2: any):any|nil
```

## __newindex


```lua
table|fun(t: any, k: any, v: any)|nil
```

## __pairs


```lua
fun(t: any):fun(t: any, k: any, v: any):any, any, any, any|nil
```

## __pow


```lua
fun(t1: any, t2: any):any|nil
```

## __shl


```lua
fun(t1: any, t2: any):any|nil
```

## __shr


```lua
fun(t1: any, t2: any):any|nil
```

## __sub


```lua
fun(t1: any, t2: any):any|nil
```

## __tostring


```lua
fun(t: any):string|nil
```

## __unm


```lua
fun(t: any):any|nil
```


---

# module


```lua
function module(name: string, ...any)
```


---

# newproxy


```lua
function newproxy(proxy: boolean|table|userdata)
  -> userdata
```


---

# next


```lua
function next(table: table<<K>, <V>>, index?: <K>)
  -> <K>?
  2. <V>?
```


---

# nil


---

# number


---

# openmode


---

# os


```lua
oslib
```


---

# os.clock


```lua
function os.clock()
  -> number
```


---

# os.date


```lua
function os.date(format?: string, time?: integer)
  -> string|osdate
```


---

# os.difftime


```lua
function os.difftime(t2: integer, t1: integer)
  -> integer
```


---

# os.execute


```lua
function os.execute(command?: string)
  -> suc: boolean?
  2. exitcode: ("exit"|"signal")?
  3. code: integer?
```


---

# os.exit


```lua
function os.exit(code?: boolean|integer, close?: boolean)
```


---

# os.getenv


```lua
function os.getenv(varname: string)
  -> string?
```


---

# os.remove


```lua
function os.remove(filename: string)
  -> suc: boolean
  2. errmsg: string?
```


---

# os.rename


```lua
function os.rename(oldname: string, newname: string)
  -> suc: boolean
  2. errmsg: string?
```


---

# os.setlocale


```lua
function os.setlocale(locale: string|nil, category?: "all"|"collate"|"ctype"|"monetary"|"numeric"...(+1))
  -> localecategory: string
```


---

# os.time


```lua
function os.time(date?: osdateparam)
  -> integer
```


---

# os.tmpname


```lua
function os.tmpname()
  -> string
```


---

# osdate

## day


```lua
string|integer
```


1-31

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-osdate.day"])


## hour


```lua
string|integer
```


0-23

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-osdate.hour"])


## isdst


```lua
boolean
```


daylight saving flag, a boolean

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-osdate.isdst"])


## min


```lua
string|integer
```


0-59

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-osdate.min"])


## month


```lua
string|integer
```


1-12

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-osdate.month"])


## sec


```lua
string|integer
```


0-61

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-osdate.sec"])


## wday


```lua
string|integer
```


weekday, 1–7, Sunday is 1

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-osdate.wday"])


## yday


```lua
string|integer
```


day of the year, 1–366

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-osdate.yday"])


## year


```lua
string|integer
```


four digits

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-osdate.year"])



---

# osdateparam

## day


```lua
string|integer
```


1-31

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-osdate.day"])


## hour


```lua
(string|integer)?
```


0-23

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-osdate.hour"])


## isdst


```lua
boolean?
```


daylight saving flag, a boolean

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-osdate.isdst"])


## min


```lua
(string|integer)?
```


0-59

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-osdate.min"])


## month


```lua
string|integer
```


1-12

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-osdate.month"])


## sec


```lua
(string|integer)?
```


0-61

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-osdate.sec"])


## wday


```lua
(string|integer)?
```


weekday, 1–7, Sunday is 1

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-osdate.wday"])


## yday


```lua
(string|integer)?
```


day of the year, 1–366

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-osdate.yday"])


## year


```lua
string|integer
```


four digits

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-osdate.year"])



---

# oslib

## clock


```lua
function os.clock()
  -> number
```


Returns an approximation of the amount in seconds of CPU time used by the program.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-os.clock"])

## date


```lua
function os.date(format?: string, time?: integer)
  -> string|osdate
```


Returns a string or a table containing date and time, formatted according to the given string `format`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-os.date"])

## difftime


```lua
function os.difftime(t2: integer, t1: integer)
  -> integer
```


Returns the difference, in seconds, from time `t1` to time `t2`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-os.difftime"])

## execute


```lua
function os.execute(command?: string)
  -> suc: boolean?
  2. exitcode: ("exit"|"signal")?
  3. code: integer?
```


Passes `command` to be executed by an operating system shell.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-os.execute"])


```lua
exitcode:
    | "exit"
    | "signal"
```

## exit


```lua
function os.exit(code?: boolean|integer, close?: boolean)
```


Calls the ISO C function `exit` to terminate the host program.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-os.exit"])

## getenv


```lua
function os.getenv(varname: string)
  -> string?
```


Returns the value of the process environment variable `varname`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-os.getenv"])

## remove


```lua
function os.remove(filename: string)
  -> suc: boolean
  2. errmsg: string?
```


Deletes the file with the given name.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-os.remove"])

## rename


```lua
function os.rename(oldname: string, newname: string)
  -> suc: boolean
  2. errmsg: string?
```


Renames the file or directory named `oldname` to `newname`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-os.rename"])

## setlocale


```lua
function os.setlocale(locale: string|nil, category?: "all"|"collate"|"ctype"|"monetary"|"numeric"...(+1))
  -> localecategory: string
```


Sets the current locale of the program.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-os.setlocale"])


```lua
category:
   -> "all"
    | "collate"
    | "ctype"
    | "monetary"
    | "numeric"
    | "time"
```

## time


```lua
function os.time(date?: osdateparam)
  -> integer
```


Returns the current time when called without arguments, or a time representing the local date and time specified by the given table.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-os.time"])

## tmpname


```lua
function os.tmpname()
  -> string
```


Returns a string with a file name that can be used for a temporary file.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-os.tmpname"])


---

# package


```lua
packagelib
```


---

# package.config


```lua
string
```


---

# package.loaders


```lua
table
```


---

# package.loadlib


```lua
function package.loadlib(libname: string, funcname: string)
  -> any
```


---

# package.searchers


```lua
table
```


---

# package.searchpath


```lua
function package.searchpath(name: string, path: string, sep?: string, rep?: string)
  -> filename: string?
  2. errmsg: string?
```


---

# package.seeall


```lua
function package.seeall(module: table)
```


---

# packagelib

## config


```lua
string
```


A string describing some compile-time configurations for packages.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-package.config"])


## cpath


```lua
string
```


The path used by `require` to search for a C loader.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-package.cpath"])


## loaded


```lua
table
```


A table used by `require` to control which modules are already loaded.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-package.loaded"])


## loaders


```lua
table
```


A table used by `require` to control how to load modules.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-package.loaders"])


## loadlib


```lua
function package.loadlib(libname: string, funcname: string)
  -> any
```


Dynamically links the host program with the C library `libname`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-package.loadlib"])

## path


```lua
string
```


The path used by `require` to search for a Lua loader.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-package.path"])


## preload


```lua
table
```


A table to store loaders for specific modules.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-package.preload"])


## searchers


```lua
table
```


A table used by `require` to control how to load modules.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-package.searchers"])


## searchpath


```lua
function package.searchpath(name: string, path: string, sep?: string, rep?: string)
  -> filename: string?
  2. errmsg: string?
```


Searches for the given `name` in the given `path`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-package.searchpath"])

## seeall


```lua
function package.seeall(module: table)
```


Sets a metatable for `module` with its `__index` field referring to the global environment, so that this module inherits values from the global environment. To be used as an option to function `module` .

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-package.seeall"])


---

# pairs


```lua
function pairs(t: <T:table>)
  -> fun(table: table<<K>, <V>>, index?: <K>):<K>, <V>
  2. <T:table>
```


---

# pcall


```lua
function pcall(f: fun(...any):...unknown, arg1?: any, ...any)
  -> success: boolean
  2. result: any
  3. ...any
```


---

# popenmode


---

# print


```lua
function print(...any)
```


---

# rawequal


```lua
function rawequal(v1: any, v2: any)
  -> boolean
```


---

# rawget


```lua
function rawget(table: table, index: any)
  -> any
```


---

# rawlen


```lua
function rawlen(v: string|table)
  -> len: integer
```


---

# rawset


```lua
function rawset(table: table, index: any, value: any)
  -> table
```


---

# readmode


---

# require


```lua
function require(modname: string)
  -> unknown
  2. loaderdata: unknown
```


---

# seekwhence


---

# select


```lua
function select(index: integer|"#", ...any)
  -> any
```


---

# setfenv


```lua
function setfenv(f: integer|fun(...any):...unknown, table: table)
  -> function
```


---

# setmetatable


```lua
function setmetatable(table: table, metatable?: table|metatable)
  -> table
```


---

# string


```lua
stringlib
```


---

# string

## byte


```lua
function string.byte(s: string|number, i?: integer, j?: integer)
  -> ...integer
```


Returns the internal numeric codes of the characters `s[i], s[i+1], ..., s[j]`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.byte"])

## char


```lua
function string.char(byte: integer, ...integer)
  -> string
```


Returns a string with length equal to the number of arguments, in which each character has the internal numeric code equal to its corresponding argument.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.char"])

## dump


```lua
function string.dump(f: fun(...any):...unknown, strip?: boolean)
  -> string
```


Returns a string containing a binary representation (a *binary chunk*) of the given function.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.dump"])

## find


```lua
function string.find(s: string|number, pattern: string|number, init?: integer, plain?: boolean)
  -> start: integer|nil
  2. end: integer|nil
  3. ...any
```


Miss locale <string.find>

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.find"])

@*return* `start`

@*return* `end`

@*return* `...` — captured

## format


```lua
function string.format(s: string|number, ...any)
  -> string
```


Returns a formatted version of its variable number of arguments following the description given in its first argument.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.format"])

## gmatch


```lua
function string.gmatch(s: string|number, pattern: string|number, init?: integer)
  -> fun():string, ...unknown
```


Miss locale <string.gmatch>

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.gmatch"])

## gsub


```lua
function string.gsub(s: string|number, pattern: string|number, repl: string|number|function|table, n?: integer)
  -> string
  2. count: integer
```


Miss locale <string.gsub>

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.gsub"])

## len


```lua
function string.len(s: string|number)
  -> integer
```


Returns its length.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.len"])

## lower


```lua
function string.lower(s: string|number)
  -> string
```


Returns a copy of this string with all uppercase letters changed to lowercase.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.lower"])

## match


```lua
function string.match(s: string|number, pattern: string|number, init?: integer)
  -> ...any
```


Miss locale <string.match>

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.match"])

## pack


```lua
function string.pack(fmt: string, v1: string|number, v2?: string|number, ...string|number)
  -> binary: string
```


Miss locale <string.pack>

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.pack"])

## packsize


```lua
function string.packsize(fmt: string)
  -> integer
```


Miss locale <string.packsize>

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.packsize"])

## rep


```lua
function string.rep(s: string|number, n: integer, sep?: string|number)
  -> string
```


Returns a string that is the concatenation of `n` copies of the string `s` separated by the string `sep`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.rep"])

## reverse


```lua
function string.reverse(s: string|number)
  -> string
```


Returns a string that is the string `s` reversed.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.reverse"])

## sub


```lua
function string.sub(s: string|number, i: integer, j?: integer)
  -> string
```


Returns the substring of the string that starts at `i` and continues until `j`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.sub"])

## unpack


```lua
function string.unpack(fmt: string, s: string, pos?: integer)
  -> ...any
```


Returns the values packed in string according to the format string `fmt` (see [§6.4.2](command:extension.lua.doc?["en-us/54/manual.html/6.4.2"])) .

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.unpack"])

## upper


```lua
function string.upper(s: string|number)
  -> string
```


Returns a copy of this string with all lowercase letters changed to uppercase.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.upper"])


---

# string.byte


```lua
function string.byte(s: string|number, i?: integer, j?: integer)
  -> ...integer
```


---

# string.char


```lua
function string.char(byte: integer, ...integer)
  -> string
```


---

# string.dump


```lua
function string.dump(f: fun(...any):...unknown, strip?: boolean)
  -> string
```


---

# string.find


```lua
function string.find(s: string|number, pattern: string|number, init?: integer, plain?: boolean)
  -> start: integer|nil
  2. end: integer|nil
  3. ...any
```


---

# string.format


```lua
function string.format(s: string|number, ...any)
  -> string
```


---

# string.gmatch


```lua
function string.gmatch(s: string|number, pattern: string|number, init?: integer)
  -> fun():string, ...unknown
```


---

# string.gsub


```lua
function string.gsub(s: string|number, pattern: string|number, repl: string|number|function|table, n?: integer)
  -> string
  2. count: integer
```


---

# string.len


```lua
function string.len(s: string|number)
  -> integer
```


---

# string.lower


```lua
function string.lower(s: string|number)
  -> string
```


---

# string.match


```lua
function string.match(s: string|number, pattern: string|number, init?: integer)
  -> ...any
```


---

# string.pack


```lua
function string.pack(fmt: string, v1: string|number, v2?: string|number, ...string|number)
  -> binary: string
```


---

# string.packsize


```lua
function string.packsize(fmt: string)
  -> integer
```


---

# string.rep


```lua
function string.rep(s: string|number, n: integer, sep?: string|number)
  -> string
```


---

# string.reverse


```lua
function string.reverse(s: string|number)
  -> string
```


---

# string.sub


```lua
function string.sub(s: string|number, i: integer, j?: integer)
  -> string
```


---

# string.unpack


```lua
function string.unpack(fmt: string, s: string, pos?: integer)
  -> ...any
```


---

# string.upper


```lua
function string.upper(s: string|number)
  -> string
```


---

# stringlib

## byte


```lua
function string.byte(s: string|number, i?: integer, j?: integer)
  -> ...integer
```


Returns the internal numeric codes of the characters `s[i], s[i+1], ..., s[j]`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.byte"])

## char


```lua
function string.char(byte: integer, ...integer)
  -> string
```


Returns a string with length equal to the number of arguments, in which each character has the internal numeric code equal to its corresponding argument.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.char"])

## dump


```lua
function string.dump(f: fun(...any):...unknown, strip?: boolean)
  -> string
```


Returns a string containing a binary representation (a *binary chunk*) of the given function.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.dump"])

## find


```lua
function string.find(s: string|number, pattern: string|number, init?: integer, plain?: boolean)
  -> start: integer|nil
  2. end: integer|nil
  3. ...any
```


Miss locale <string.find>

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.find"])

@*return* `start`

@*return* `end`

@*return* `...` — captured

## format


```lua
function string.format(s: string|number, ...any)
  -> string
```


Returns a formatted version of its variable number of arguments following the description given in its first argument.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.format"])

## gmatch


```lua
function string.gmatch(s: string|number, pattern: string|number, init?: integer)
  -> fun():string, ...unknown
```


Miss locale <string.gmatch>

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.gmatch"])

## gsub


```lua
function string.gsub(s: string|number, pattern: string|number, repl: string|number|function|table, n?: integer)
  -> string
  2. count: integer
```


Miss locale <string.gsub>

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.gsub"])

## len


```lua
function string.len(s: string|number)
  -> integer
```


Returns its length.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.len"])

## lower


```lua
function string.lower(s: string|number)
  -> string
```


Returns a copy of this string with all uppercase letters changed to lowercase.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.lower"])

## match


```lua
function string.match(s: string|number, pattern: string|number, init?: integer)
  -> ...any
```


Miss locale <string.match>

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.match"])

## pack


```lua
function string.pack(fmt: string, v1: string|number, v2?: string|number, ...string|number)
  -> binary: string
```


Miss locale <string.pack>

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.pack"])

## packsize


```lua
function string.packsize(fmt: string)
  -> integer
```


Miss locale <string.packsize>

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.packsize"])

## rep


```lua
function string.rep(s: string|number, n: integer, sep?: string|number)
  -> string
```


Returns a string that is the concatenation of `n` copies of the string `s` separated by the string `sep`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.rep"])

## reverse


```lua
function string.reverse(s: string|number)
  -> string
```


Returns a string that is the string `s` reversed.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.reverse"])

## sub


```lua
function string.sub(s: string|number, i: integer, j?: integer)
  -> string
```


Returns the substring of the string that starts at `i` and continues until `j`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.sub"])

## unpack


```lua
function string.unpack(fmt: string, s: string, pos?: integer)
  -> ...any
```


Returns the values packed in string according to the format string `fmt` (see [§6.4.2](command:extension.lua.doc?["en-us/54/manual.html/6.4.2"])) .

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.unpack"])

## upper


```lua
function string.upper(s: string|number)
  -> string
```


Returns a copy of this string with all lowercase letters changed to uppercase.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-string.upper"])


---

# table


```lua
tablelib
```


---

# table


---

# table.concat


```lua
function table.concat(list: table, sep?: string, i?: integer, j?: integer)
  -> string
```


---

# table.foreach


```lua
function table.foreach(list: any, callback: fun(key: string, value: any):<T>|nil)
  -> <T>|nil
```


---

# table.foreachi


```lua
function table.foreachi(list: any, callback: fun(key: string, value: any):<T>|nil)
  -> <T>|nil
```


---

# table.getn


```lua
function table.getn(list: <T>[])
  -> integer
```


---

# table.insert


```lua
function table.insert(list: table, pos: integer, value: any)
```


---

# table.maxn


```lua
function table.maxn(table: table)
  -> integer
```


---

# table.move


```lua
function table.move(a1: table, f: integer, e: integer, t: integer, a2?: table)
  -> a2: table
```


---

# table.pack


```lua
function table.pack(...any)
  -> table
```


---

# table.remove


```lua
function table.remove(list: table, pos?: integer)
  -> any
```


---

# table.sort


```lua
function table.sort(list: <T>[], comp?: fun(a: <T>, b: <T>):boolean)
```


---

# table.unpack


```lua
function table.unpack(list: { [1]: <T1>, [2]: <T2>, [3]: <T3>, [4]: <T4>, [5]: <T5>, [6]: <T6>, [7]: <T7>, [8]: <T8>, [9]: <T9>, [10]: <T10> }, i?: integer, j?: integer)
  -> <T1>
  2. <T2>
  3. <T3>
  4. <T4>
  5. <T5>
  6. <T6>
  7. <T7>
  8. <T8>
  9. <T9>
 10. <T10>
```


---

# tablelib

## concat


```lua
function table.concat(list: table, sep?: string, i?: integer, j?: integer)
  -> string
```


Given a list where all elements are strings or numbers, returns the string `list[i]..sep..list[i+1] ··· sep..list[j]`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.concat"])

## foreach


```lua
function table.foreach(list: any, callback: fun(key: string, value: any):<T>|nil)
  -> <T>|nil
```


Executes the given f over all elements of table. For each element, f is called with the index and respective value as arguments. If f returns a non-nil value, then the loop is broken, and this value is returned as the final value of foreach.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.foreach"])

## foreachi


```lua
function table.foreachi(list: any, callback: fun(key: string, value: any):<T>|nil)
  -> <T>|nil
```


Executes the given f over the numerical indices of table. For each index, f is called with the index and respective value as arguments. Indices are visited in sequential order, from 1 to n, where n is the size of the table. If f returns a non-nil value, then the loop is broken and this value is returned as the result of foreachi.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.foreachi"])

## getn


```lua
function table.getn(list: <T>[])
  -> integer
```


Returns the number of elements in the table. This function is equivalent to `#list`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.getn"])

## insert


```lua
function table.insert(list: table, pos: integer, value: any)
```


Inserts element `value` at position `pos` in `list`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.insert"])

## maxn


```lua
function table.maxn(table: table)
  -> integer
```


Returns the largest positive numerical index of the given table, or zero if the table has no positive numerical indices.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.maxn"])

## move


```lua
function table.move(a1: table, f: integer, e: integer, t: integer, a2?: table)
  -> a2: table
```


Moves elements from table `a1` to table `a2`.
```lua
a2[t],··· =
a1[f],···,a1[e]
return a2
```


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.move"])

## pack


```lua
function table.pack(...any)
  -> table
```


Returns a new table with all arguments stored into keys `1`, `2`, etc. and with a field `"n"` with the total number of arguments.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.pack"])

## remove


```lua
function table.remove(list: table, pos?: integer)
  -> any
```


Removes from `list` the element at position `pos`, returning the value of the removed element.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.remove"])

## sort


```lua
function table.sort(list: <T>[], comp?: fun(a: <T>, b: <T>):boolean)
```


Sorts list elements in a given order, *in-place*, from `list[1]` to `list[#list]`.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.sort"])

## unpack


```lua
function table.unpack(list: { [1]: <T1>, [2]: <T2>, [3]: <T3>, [4]: <T4>, [5]: <T5>, [6]: <T6>, [7]: <T7>, [8]: <T8>, [9]: <T9>, [10]: <T10> }, i?: integer, j?: integer)
  -> <T1>
  2. <T2>
  3. <T3>
  4. <T4>
  5. <T5>
  6. <T6>
  7. <T7>
  8. <T8>
  9. <T9>
 10. <T10>
```


Returns the elements from the given list. This function is equivalent to
```lua
    return list[i], list[i+1], ···, list[j]
```
By default, `i` is `1` and `j` is `#list`.


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-table.unpack"])


---

# thread


---

# tonumber


```lua
function tonumber(e: any)
  -> number?
```


---

# tostring


```lua
function tostring(v: any)
  -> string
```


---

# true


---

# type


---

# type


```lua
function type(v: any)
  -> type: "boolean"|"function"|"nil"|"number"|"string"...(+3)
```


---

# unknown


---

# unpack


```lua
function unpack(list: { [1]: <T1>, [2]: <T2>, [3]: <T3>, [4]: <T4>, [5]: <T5>, [6]: <T6>, [7]: <T7>, [8]: <T8>, [9]: <T9>, [10]: <T10> }, i?: integer, j?: integer)
  -> <T1>
  2. <T2>
  3. <T3>
  4. <T4>
  5. <T5>
  6. <T6>
  7. <T7>
  8. <T8>
  9. <T9>
 10. <T10>
```


```lua
function unpack(list: { [1]: <T1>, [2]: <T2>, [3]: <T3>, [4]: <T4>, [5]: <T5>, [6]: <T6>, [7]: <T7>, [8]: <T8>, [9]: <T9> })
  -> <T1>
  2. <T2>
  3. <T3>
  4. <T4>
  5. <T5>
  6. <T6>
  7. <T7>
  8. <T8>
  9. <T9>
```


---

# userdata


---

# utf8


```lua
utf8lib
```


---

# utf8.char


```lua
function utf8.char(code: integer, ...integer)
  -> string
```


---

# utf8.codepoint


```lua
function utf8.codepoint(s: string, i?: integer, j?: integer, lax?: boolean)
  -> code: integer
  2. ...integer
```


---

# utf8.codes


```lua
function utf8.codes(s: string, lax?: boolean)
  -> fun(s: string, p: integer):integer, integer
```


---

# utf8.len


```lua
function utf8.len(s: string, i?: integer, j?: integer, lax?: boolean)
  -> integer?
  2. errpos: integer?
```


---

# utf8.offset


```lua
function utf8.offset(s: string, n: integer, i?: integer)
  -> p: integer
```


---

# utf8lib

## char


```lua
function utf8.char(code: integer, ...integer)
  -> string
```


Receives zero or more integers, converts each one to its corresponding UTF-8 byte sequence and returns a string with the concatenation of all these sequences.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-utf8.char"])

## charpattern


```lua
string
```


The pattern which matches exactly one UTF-8 byte sequence, assuming that the subject is a valid UTF-8 string.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-utf8.charpattern"])


## codepoint


```lua
function utf8.codepoint(s: string, i?: integer, j?: integer, lax?: boolean)
  -> code: integer
  2. ...integer
```


Returns the codepoints (as integers) from all characters in `s` that start between byte position `i` and `j` (both included).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-utf8.codepoint"])

## codes


```lua
function utf8.codes(s: string, lax?: boolean)
  -> fun(s: string, p: integer):integer, integer
```


Returns values so that the construction
```lua
for p, c in utf8.codes(s) do
    body
end
```
will iterate over all UTF-8 characters in string s, with p being the position (in bytes) and c the code point of each character. It raises an error if it meets any invalid byte sequence.


[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-utf8.codes"])

## len


```lua
function utf8.len(s: string, i?: integer, j?: integer, lax?: boolean)
  -> integer?
  2. errpos: integer?
```


Returns the number of UTF-8 characters in string `s` that start between positions `i` and `j` (both inclusive).

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-utf8.len"])

## offset


```lua
function utf8.offset(s: string, n: integer, i?: integer)
  -> p: integer
```


Returns the position (in bytes) where the encoding of the `n`-th character of `s` (counting from position `i`) starts.

[View documents](command:extension.lua.doc?["en-us/54/manual.html/pdf-utf8.offset"])


---

# vbuf


---

# warn


```lua
function warn(message: string, ...any)
```


---

# xpcall


```lua
function xpcall(f: fun(...any):...unknown, msgh: function, arg1?: any, ...any)
  -> success: boolean
  2. result: any
  3. ...any
```