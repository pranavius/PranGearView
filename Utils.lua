local addonName, AddOn = ...
---@class PranGearView
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

AddOn.CurrentExpac = AddOn.ExpansionInfo.Midnight

---Formats `text` to be displayed in a specific color in-game. If the argument is a valid entry in the `HexColorPresets` table, that value will be used.
---Alternatively, a color's hexadecimal code can be provided for the `color` argument instead.
---@param text string|number The text to display
---@param color string The color to display the text in.
---@return string result A formatted string wrapped in syntax to display `text` in the `color` desired at full opacity
---@see HexColorPresets for a list of predefined colors such as class colors, item quality, etc.
function AddOn.ColorText(text, color)
    if AddOn.HexColorPresets[color] then
        return WrapTextInColorCode(tostring(text), "FF"..AddOn.HexColorPresets[color])
    end

    return WrapTextInColorCode(tostring(text), "FF"..color)
end

local ColorText = AddOn.ColorText

---Prints the desired text if the AddOn is in debugging mode. This is just a wrapper around the standard `print` function.
---@vararg string|number
---@see print
function AddOn.DebugPrint(...)
    if AddOn.db.profile.general.debug then
		print(ColorText("[PGV Debug]", "Heirloom"), ...)
	end
end
local DebugPrint = AddOn.DebugPrint

---Prints the contents of a Lua table as key-value pairs if the AddOn is in debugging mode.
---@param tbl table The table to print key-value pairs for
function AddOn.DebugTable(tbl)
    if AddOn.db.profile.general.debug then
        print(ColorText("[PGV Debug Table: START]", "Heirloom"))
        for k, v in pairs(tbl) do
            print(k, "=", ColorText(v, "Info"))
        end
        print(ColorText("[PGV Debug Table: END]", "Heirloom"))
    end
end

---Removes gaps in indicies of a table if values are `nil`. This modifies the `table` provided in the `tbl` argument and does not return a new one.
---@param tbl table The table to compress indicies for
function AddOn.CompressTable(tbl)
    -- collect all numeric indices
    local keys = {}
    for k in pairs(tbl) do
        if type(k) == "number" then
            keys[#keys+1] = k
        end
    end
    table.sort(keys)

    -- re-assign values to 1..n, clear old elements
    local n = 1
    for _, oldIndex in ipairs(keys) do
        tbl[n] = tbl[oldIndex]
        if oldIndex ~= n then
            tbl[oldIndex] = nil
        end
        n = n + 1
    end
end

---@param tbl table Table to count entries for
---@return number count The number of entries in `tbl`
function AddOn.GetTableSize(tbl)
    local count = 0
    for k in pairs(tbl) do
        count = count + 1
    end
    return count
end

---Converts color values for red, green, and blue into their corresponding hexadecimal code
---@param r number The red value for the color expressed as a decimal between `0` and `255`
---@param g number The green value for the color expressed as a decimal between `0` and `255`
---@param b number The blue value for the color expressed as a decimal between `0` and `255`
---@return string hexadecimal The corresponding hexadecimal code for the provided red, green, and blue decimal values at full opacity without the leading '#' character
function AddOn.ConvertRGBToHex(r, g, b)
    return string.format("%02X%02X%02X", r*255, g*255, b*255)
end

---Converts a hexadecimal code (without the leading '#' character) into its corresponding red, green, and blue decimal values
---@param hex string The hex code to convert to RGB values
---@return number|nil red The red value for the color expressed as a decimal between `0` and `255`. Returns `nil` if the supplied hex code is invalid
---@return number|nil green The green value for the color expressed as a decimal between `0` and `255`. Returns `nil` if the supplied hex code is invalid
---@return number|nil blue The blue value for the color expressed as a decimal between `0` and `255`. Returns `nil` if the supplied hex code is invalid
function AddOn.ConvertHexToRGB(hex)
    if tonumber("0x"..hex:sub(1,2)) == nil or tonumber("0x"..hex:sub(3,4)) == nil or tonumber("0x"..hex:sub(5,6)) == nil then
        print(ColorText("Pran Gear View:", "Heirloom"), ColorText(L["Invalid hexadecimal color code provided."], "Error"))
        return nil, nil, nil
    end
    return tonumber("0x"..hex:sub(1,2)) / 255,
        tonumber("0x"..hex:sub(3,4)) / 255,
        tonumber("0x"..hex:sub(5,6)) / 255
end

---Utility function to round numbers
---@param val number The number to round
---@return number number The provided number rounded to the nearest whole number
function AddOn.RoundNumber(val)
    return math.floor(val + 0.5)
end

---Formats `texture` to be displayed in-game using square dimensions
---@param texture number the ID for the texture to render
---@param dim? number The value to be used for the height & width of the texture. Default value is `15`
---@return string text A formatted string wrapped in syntax to display `texture`
function AddOn.GetTextureString(texture, dim)
    local size = 15
    if dim and type(dim) == "number" then
        size = dim
    end
    return "|T"..texture..":"..size..":"..size.."|t"
end

---Formats `atlas` to be displayed in-game using square dimensions. This differs from `GetTextureString` in that atlases use filenames rather than ID numbers to render
---@param atlas string the filename or atlas alias for the texture to render
---@param dim? number The value to be used for the height & width of the texture. Default value is `15`
---@return string text A formatted string wrapped in syntax to display `atlas`
function AddOn.GetTextureAtlasString(atlas, dim)
    local size = 15
    if dim and type(dim) == "number" then
        size = dim
    end
    return "|A:"..atlas..":"..size..":"..size.."|a"
end

---Creates a blank entry to display a space or create separation between items in the AddOn options menu
---@param order number The position of the blank entry in the immediate parent object
---@param width? number A specified width for the spacer if a full line is not desired
---@return { type: "description", name: " ", order: number, width: number? } spacer A table entry for showing a blank space between option elements
function AddOn.CreateOptionsSpacer(order, width)
    return {
        type = "description",
        name = " ",
        order = order,
        width = width
    }
end

---Indicates whether an item is equipped in a particular gear slot or not
---@param slot ItemSlot The gear slot to check for an equipped item
---@param isInspect? boolean Whether a player is being inspected or not
---@return boolean hasItem `true` if the slot has an item equipped in it, `false` otherwise
---@return ItemMixin item The equipped item. When `hasItem` is `false`, this is always an empty table
function AddOn:IsItemEquippedInSlot(slot, isInspect)
    local slotID = slot:GetID()
    if isInspect then
        local token = InspectFrame.unit
        if UnitGUID(InspectFrame.unit) ~= self.inspectedUnitGUID then token = UnitTokenFromGUID(self.inspectedUnitGUID) end
        if not token then return false, {} end
        local itemLink = GetInventoryItemLink(token, slotID)
        if itemLink then return true, Item:CreateFromItemLink(itemLink) end
    else
        local item = Item:CreateFromEquipmentSlot(slot:GetID())
        return not item:IsItemEmpty(), item:IsItemEmpty() and {} or item
    end
    return false, {}
end

---Indicates whether an item equipped in a particular gear slot can have a gem socket added to it
---@param slot ItemSlot The gear slot to check for socketable equipment
---@return boolean result `true` if the item can have a socket, `false` otherwise
function AddOn:IsSocketableSlot(slot)
    if self.CurrentExpac and self.CurrentExpac.SocketableSlots then
        for _, gearSlot in ipairs(self.CurrentExpac.SocketableSlots) do
            if slot == gearSlot or (type(gearSlot) == "string" and slot == _G[gearSlot]) then
                DebugPrint("IsSocketableSlot: Slot", ColorText(slot:GetName(), "Heirloom"), "is socketable in", self.CurrentExpac.NameAbbr)
                return true
            end
        end
    elseif self:IsAuxSocketableSlot(slot) then
        return true
    end
    return false
end

---Indicates whether an item equipped in a particular gear slot can have a gem socket added to it via auxillary methods (example: S.A.D. in The War Within)
---@param slot ItemSlot The gear slot to check for socketable equipment
---@return boolean result `true` if the item can have a socket via auxillary methods, `false` otherwise
function AddOn:IsAuxSocketableSlot(slot)
    if self.CurrentExpac and self.CurrentExpac.AuxSocketableSlots then
        for _, gearSlot in ipairs(self.CurrentExpac.AuxSocketableSlots) do
            if slot == gearSlot or (type(gearSlot) == "string" and slot == _G[gearSlot]) then
                DebugPrint("IsAuxSocketableSlot: Slot", ColorText(slot:GetName(), "Heirloom"), "can have sockets added in", self.CurrentExpac.NameAbbr)
                return true
            end
        end
    end
    return false
end

---Indicates whether an item equipped in a particular gear slot can be enchanted or not
---@param slot ItemSlot The gear slot to check for enchantable equipment
---@return boolean result `true` if the item can be enchanted, `false` otherwise
function AddOn:IsEnchantableSlot(slot)
    if self.CurrentExpac and self.CurrentExpac.EnchantableSlots then
        for _, gearSlot in ipairs(self.CurrentExpac.EnchantableSlots) do
            if gearSlot == "InspectSecondaryHandSlot" and slot == _G[gearSlot] then
                local _, item = self:IsItemEquippedInSlot(slot, true)
                if self.GetTableSize(item) > 0 then
                    local itemClassID, itemSubclassID = select(6, C_Item.GetItemInfoInstant(item:GetItemLink()))
                    local isShield = itemClassID == 4 and itemSubclassID == 6
                    local isOffhand = itemClassID == 4 and itemSubclassID == 0
                    if isShield and self.CurrentExpac.ShieldEnchantAvailable then
                        return true
                    elseif isShield then
                        return false
                    elseif isOffhand and self.CurrentExpac.OffhandEnchantAvailable then
                        return true
                    elseif isOffhand then
                        return false
                    end
                end
            end
            if slot == gearSlot and slot == CharacterSecondaryHandSlot and GetInventoryItemID("player", slot:GetID()) then
                local itemClassID, itemSubclassID = select(6, C_Item.GetItemInfoInstant(GetInventoryItemID("player", slot:GetID())))
                local isShield = itemClassID == 4 and itemSubclassID == 6
                local isOffhand = itemClassID == 4 and itemSubclassID == 0
                if isShield and self.CurrentExpac.ShieldEnchantAvailable then
                    return true
                elseif isShield then
                    return false
                elseif isOffhand and self.CurrentExpac.OffhandEnchantAvailable then
                    return true
                elseif isOffhand then
                    return false
                end
            end
            -- Check for other available enchants
            if slot == gearSlot or (type(gearSlot) == "string" and slot == _G[gearSlot]) then
                DebugPrint("IsEnchantableSlot: Slot", ColorText(slot:GetName(), "Heirloom"), "is enchantable")
                return true
            end
        end
    end
    return false
end

---Abbreviates `text` using the provided `replacementTable`
---@param text string The text to abbreviate
---@param replacementTable TextReplacement[] A table containing mappings for how to replace text
---@return string abbreviation The abbreviated version of `text` as per the entries in `replacementTable`
function AddOn:AbbreviateText(text, replacementTable)
    if not text then return "" end
    if self.GetTableSize(replacementTable) == 0 then return text end
    local abbreviation = text
    for _, repl in pairs(replacementTable) do
        abbreviation = abbreviation:gsub(repl.original, repl.replacement)
    end
    return abbreviation
end

---Provides a texture ID to display for a Death Knight weapon enchant, or returns the texture ID for a checkmark if the enchants does not have an associated icon
---@param enchantTextAbbr string
---@return number textureID
function AddOn:GetLegacyEnchantTextureID(enchantTextAbbr)
    if enchantTextAbbr == AddOn.DKEnchantAbbr.Razorice then
        return 135842 -- Interface/Icons/Spell_Frost_FrostArmor
    elseif enchantTextAbbr == AddOn.DKEnchantAbbr.Sanguination then
        return 1778226 -- Interface/Icons/Ability_Argus_DeathFod
    elseif enchantTextAbbr == AddOn.DKEnchantAbbr.Spellwarding then
        return 425952 -- Interface/Icons/Spell_Fire_TwilightFireward
    elseif enchantTextAbbr == AddOn.DKEnchantAbbr.Apocalypse then
        return 237535 -- Interface/Icons/Spell_DeathKnight_Thrash_Ghoul
    elseif enchantTextAbbr == AddOn.DKEnchantAbbr.FallenCrusader then
        return 135957 -- Interface/Icons/Spell_Holy_RetributionAura
    elseif enchantTextAbbr == AddOn.DKEnchantAbbr.StoneskinGargoyle then
        return 237480 -- Interface/Icons/Inv_Sword_130
    elseif enchantTextAbbr == AddOn.DKEnchantAbbr.UnendingThirst then
        return 3163621 -- Interface/Icons/Spell_NZInsanity_Bloodthirst
    else
        return 628564 -- Interface/Scenarios/ScenarioIcon-Check
    end
end

PlayerGetTimerunningSeasonID = PlayerGetTimerunningSeasonID or function() return nil end

---Dynamically determine whether upgrade track info and relevant AddOn options should be shown on the current character due to other constraints (e.g. WoW Remix)
---@return boolean result
function AddOn:AreUpgradeTracksShownForCharacter()
    return self.db.profile.upgradeTrack.show and PlayerGetTimerunningSeasonID() == nil
end

---Dynamically determine whether gem info and relevant AddOn options should be shown on the current character due to other constraints (e.g. WoW Remix)
---@return boolean result
function AddOn:AreGemsShownForCharacter()
    return self.db.profile.gems.show and PlayerGetTimerunningSeasonID() == nil
end

---Dynamically determine whether enchant info and relevant AddOn options should be shown on the current character due to other constraints (e.g. WoW Remix)
---@return boolean result
function AddOn:AreEnchantsShownForCharacter()
    return self.db.profile.enchants.show and PlayerGetTimerunningSeasonID() == nil
end

---Dynamically determine whether embellishment info and relevant AddOn options should be shown on the current character due to other constraints (e.g. WoW Remix)
---@return boolean result
function AddOn:AreEmbellishmentsShownForCharacter()
    return self.db.profile.general.showEmbellishments and PlayerGetTimerunningSeasonID() == nil
end

---Checks if AddOn restrictions are currently applied due to anyone of the following conditions:
---Current map, encounter(dungeon/raid/world boss, incomplete M+ run, PVP, or general combat)
---@return boolean `true` if any of these restricted states are active, `false` otherwise
function AddOn.IsAddOnCurrentlyRestricted()
    local RType = Enum.AddOnRestrictionType
	return C_RestrictedActions.IsAddOnRestrictionActive(RType.Map)
	or C_RestrictedActions.IsAddOnRestrictionActive(RType.Encounter)
	or C_RestrictedActions.IsAddOnRestrictionActive(RType.ChallengeMode)
	or C_RestrictedActions.IsAddOnRestrictionActive(RType.PvPMatch)
	or InCombatLockdown()
end
