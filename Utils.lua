local addonName, AddOn = ...
---@class PranGearView
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

AddOn.CurrentExpac = AddOn.ExpansionInfo.TheWarWithin

---Formats `text` to be displayed in a specific color in-game. If the argument is a valid entry in the `HexColorPresets` table, that value will be used.
---Alternatively, a color's hexadecimal code can be provided for the `color` argument instead.
---@see HexColorPresets
---@param text string|number The text to display
---@param color string The color to display the text in.
---@return string result A formatted string wrapped in syntax to display `text` in the `color` desired at full opacity
function ColorText(text, color)
    if AddOn.HexColorPresets[color] then
        return "|cFF"..AddOn.HexColorPresets[color]..text.."|r"
    end

    return "|cFF"..color..text.."|r"
end
AddOn.ColorText = ColorText

---Prints the desired text if the AddOn is in debugging mode. This is just a wrapper around the standard `print` function.
---@see print
---@vararg string|number
function DebugPrint(...)
    if AddOn.db.profile.debug then
		print(ColorText("[PGV Debug]", "Heirloom"), ...)
	end
end
AddOn.DebugPrint = DebugPrint

---Prints the contents of a Lua table as key-value pairs if the AddOn is in debugging mode.
---@param tbl table The table to print key-value pairs for
function AddOn.DebugTable(tbl)
    if AddOn.db.profile.debug then
        print(ColorText("[PGV Debug Table: START]", "Heirloom"))
        for k, v in pairs(tbl) do
            print(k, "=", ColorText(v, "Info"))
        end
        print(ColorText("[PGV Debug Table: END]", "Heirloom"))
    end
end

---Removes gaps in indicies of a table if values are `nil`
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
---@return { type: "description", name: " ", order: number } spacer A table entry for showing a blank space between option elements
function AddOn.CreateOptionsSpacer(order)
    return {
        type = "description",
        name = " ",
        order = order
    }
end

---@class Slot: Frame
---@field IsLeftSide boolean|nil Indicates whether the equipment slot is on the left, right, or bottom of the Character model in the default UI Character Info and Inspect windows

---Indicates whether an item is equipped in a particular gear slot or not
---@param slot Slot The gear slot to check for an equipped item
---@param isInspect? boolean Whether a player is being inspected or not
---@return boolean hasItem `true` if the slot has an item equipped in it, `false` otherwise
---@return ItemMixin|nil item The equipped item. When `hasItem` is `false`, this is always `nil`
function AddOn:IsItemEquippedInSlot(slot, isInspect)
    local slotID = slot:GetID()
    if isInspect then
        DebugPrint("Inspected unit GUID:", self.db.profile.inspectedUnitGUID)
        if IsInRaid() then
            local numRaidMembers = GetNumGroupMembers()
            for i = 1, numRaidMembers do
                local token = "raid"..i
                if UnitExists(token) and UnitGUID(token) == self.db.profile.inspectedUnitGUID then
                    DebugPrint("Matching raid unit found")
                    local itemLink = GetInventoryItemLink(token, slotID)
                    if itemLink then return true, Item:CreateFromItemLink(itemLink) end
                end
            end
            return false, nil
        elseif IsInGroup() then
            for i = 1, MAX_PARTY_MEMBERS do
                local token = "party"..i
                if UnitExists(token) and UnitGUID(token) == self.db.profile.inspectedUnitGUID then
                    DebugPrint("Matching party unit found")
                    local itemLink = GetInventoryItemLink(token, slotID)
                    if itemLink then return true, Item:CreateFromItemLink(itemLink) end
                end
            end
            return false, nil
        end
    else
        local item = Item:CreateFromEquipmentSlot(slot:GetID())
        return not item:IsItemEmpty(), item:IsItemEmpty() and nil or item
    -- Disable missing-return for next line since else condition always returns values
    ---@diagnostic disable-next-line: missing-return
    end
end

---Indicates whether an item equipped in a particular gear slot can have a gem socket added to it
---@param slot Slot The gear slot to check for socketable equipment
---@return boolean result `true` if the item can have a socket, `false` otherwise
function AddOn:IsSocketableSlot(slot)
    if self.CurrentExpac and self.CurrentExpac.SocketableSlots then
        for _, gearSlot in ipairs(self.CurrentExpac.SocketableSlots) do
            if slot == gearSlot or (type(gearSlot) == "string" and slot == _G[gearSlot]) then
                DebugPrint("Slot", ColorText(slot:GetID(), "Heirloom"), "is socketable")
                return true
            end
        end
    elseif self.IsAuxSocketableSlot(slot) then
        return true
    else
        DebugPrint(ColorText("SocketableSlots not found in expansion info table", "Error"))
    end
    return false
end

---Indicates whether an item equipped in a particular gear slot can have a gem socket added to it via auxillary methods (example: S.A.D. in The War Within)
---@param slot Slot The gear slot to check for socketable equipment
---@return boolean result `true` if the item can have a socket via auxillary methods, `false` otherwise
function AddOn.IsAuxSocketableSlot(slot)
    if AddOn.CurrentExpac and AddOn.CurrentExpac.AuxSocketableSlots then
        for _, gearSlot in ipairs(AddOn.CurrentExpac.AuxSocketableSlots) do
            if slot == gearSlot or (type(gearSlot) == "string" and slot == _G[gearSlot]) then
                DebugPrint("Slot", ColorText(slot:GetID(), "Heirloom"), "is socketable (aux)")
                return true
            end
        end
    else
        DebugPrint(ColorText("AuxSocketableSlots not found in expansion info table", "Error"))
    end
    return false
end

---Indicates whether an item equipped in a particular gear slot can be enchanted or not
---@param slot Slot The gear slot to check for enchantable equipment
---@return boolean result `true` if the item can be enchanted, `false` otherwise
function AddOn:IsEnchantableSlot(slot)
    if self.CurrentExpac and self.CurrentExpac.EnchantableSlots then
        for _, gearSlot in ipairs(self.CurrentExpac.EnchantableSlots) do
            -- Check for available head enchants when inspecting another player (Horrific Visions, Amirdrassil, etc.)
            if gearSlot == "InspectHeadSlot" and slot == _G[gearSlot] then
                return self.CurrentExpac.HeadEnchantAvailable
            -- Check for available shield or off-hand enchants when inspecting another player
            elseif gearSlot == "InspectSecondaryHandSlot" and slot == _G[gearSlot] then
                local _, item = self:IsItemEquippedInSlot(slot, true)
                if item then
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
            -- Check for any other available enchants when inspecting another player
            if type(gearSlot) == "string" and slot == _G[gearSlot] then
                DebugPrint("Inspect Slot", ColorText(slot:GetID(), "Heirloom"), "is enchantable")
                return true
            end
            -- Check for available head enchants for current character (Horrific Visions, Amirdrassil, etc.)
            if slot == gearSlot and slot == CharacterHeadSlot and GetInventoryItemID("player", slot:GetID()) then
                return self.CurrentExpac.HeadEnchantAvailable
            -- Check for available shield or off-hand enchants for current character
            elseif slot == gearSlot and slot == CharacterSecondaryHandSlot and GetInventoryItemID("player", slot:GetID()) then
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
            -- Check for any other available enchants for current character
            if slot == gearSlot then
                DebugPrint("Slot", ColorText(slot:GetID(), "Heirloom"), "is enchantable")
                return true
            end
        end
    else
        DebugPrint(ColorText("EnchantableSlots not found in expansion info table", "Error"))
    end
    return false
end

---Indicates whether a gear slot is positioned to the left of the character model in the default Character Info/Inspect windows or not
---@param slot Slot The gear slot to check
---@param isInspect boolean Whether a player is being inspected or not
---@return boolean|nil result Returns `nil` if the slot is for a weapon or off-hand item, `true` if the slot is to the left of the character model, and `false` otherwise
function AddOn:GetSlotIsLeftSide(slot, isInspect)
    if isInspect then
        for _, bottomSlotName in ipairs(self.InspectInfo.bottomSlots) do
            if slot == _G[bottomSlotName] then return nil end
        end
        for _, leftSlotName in ipairs(self.InspectInfo.leftSideSlots) do
            if slot == _G[leftSlotName] then return true end
        end
        return false
    else
        return slot.IsLeftSide
    end
end
