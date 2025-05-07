local addonName, AddOn = ...
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

AddOn.CurrentExpac = AddOn.PGVExpansionInfo.TheWarWithin

function ColorText(text, color)
    if AddOn.HexColorPresets[color] then
        return "|cFF"..AddOn.HexColorPresets[color]..text.."|r"
    end

    return "|cFF"..color..text.."|r"
end
AddOn.ColorText = ColorText

function DebugPrint(...)
    if AddOn.db.profile.debug then
		print(ColorText("[PGV Debug]", "Heirloom"), ...)
	end
end
AddOn.DebugPrint = DebugPrint

function AddOn.DebugTable(table)
    if AddOn.db.profile.debug then
        print(ColorText("[PGV Debug Table: START]", "Heirloom"))
        for k, v in pairs(table) do
            print(k, "=", v)
        end
        print(ColorText("[PGV Debug Table: END]", "Heirloom"))
    end
end

function AddOn.CompressTable(tbl)
    -- collect all numeric indices
    local keys = {}
    for k in pairs(tbl) do
        if type(k) == "number" then
            keys[#keys+1] = k
        end
    end
    table.sort(keys)

    -- re-assign values to 1..n, clear old slots
    local n = 1
    for _, oldIndex in ipairs(keys) do
        tbl[n] = tbl[oldIndex]
        if oldIndex ~= n then
            tbl[oldIndex] = nil
        end
        n = n + 1
    end
end

function AddOn.CreateOptionsSpacer(order)
    return {
        type = "description",
        name = " ",
        order = order
    }
end

function AddOn.IsItemEquippedInSlot(slot)
    local item = Item:CreateFromEquipmentSlot(slot:GetID())
    return not item:IsItemEmpty(), item
end

function AddOn.IsSocketableSlot(slot)
    if AddOn.CurrentExpac and AddOn.CurrentExpac.SocketableSlots then
        for _, gearSlot in ipairs(AddOn.CurrentExpac.SocketableSlots) do
            if slot == gearSlot then
                DebugPrint("Slot", "|cff00ccff"..slot:GetID().."|r", "is socketable")
                return true
            end
        end
    else
        DebugPrint("|cFFff3300SocketableSlots not found in expansion info table|r")
    end
    return false
end

function AddOn.IsAuxSocketableSlot(slot)
    if AddOn.CurrentExpac and AddOn.CurrentExpac.AuxSocketableSlots then
        for _, gearSlot in ipairs(AddOn.CurrentExpac.AuxSocketableSlots) do
            if slot == gearSlot then
                DebugPrint("Slot", "|cff00ccff"..slot:GetID().."|r", "is socketable (aux)")
                return true
            end
        end
    else
        DebugPrint("|cFFff3300AuxSocketableSlots not found in expansion info table|r")
    end
    return false
end

function AddOn.IsEnchantableSlot(slot)
    if AddOn.CurrentExpac and AddOn.CurrentExpac.EnchantableSlots then
        for _, gearSlot in ipairs(AddOn.CurrentExpac.EnchantableSlots) do
            if slot == gearSlot then
                DebugPrint("Slot", "|cff00ccff"..slot:GetID().."|r", "is enchantable")
                return true
            end
        end
    else
        DebugPrint("|cFFff3300EnchantableSlots not found in expansion info table|r")
    end
    return false
end

function AddOn.ConvertRGBToHex(r, g, b)
    return string.format("%02X%02X%02X", r*255, g*255, b*255)
end

function AddOn.ConvertHexToRGB(hex)
    if tonumber("0x"..hex:sub(1,2)) == nil or tonumber("0x"..hex:sub(3,4)) == nil or tonumber("0x"..hex:sub(5,6)) == nil then
        print("|cFF00ccffPran Gear View: |cFFff3300"..L["Invalid hexadecimal color code provided."].."|r")
        return nil, nil, nil
    end
    return tonumber("0x"..hex:sub(1,2)) / 255,
           tonumber("0x"..hex:sub(3,4)) / 255,
           tonumber("0x"..hex:sub(5,6)) / 255
end

function AddOn.RoundNumber(val)
    return math.floor(val + 0.5)
end

function AddOn.GetTextureString(texture, dim)
    local size = 15
    if dim and type(dim) == "number" then
        size = dim
    end
    return "|T"..texture..":"..size..":"..size.."|t"
end

function AddOn.GetTextureAtlasString(atlas, dim)
    local size = 15
    if dim and type(dim) == "number" then
        size = dim
    end
    return "|A:"..atlas..":"..size..":"..size.."|a"
end