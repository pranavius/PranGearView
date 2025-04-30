local addonName, AddOn = ...
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

local xpacInfo = AddOn.PGVExpansionInfo and AddOn.PGVExpansionInfo.TheWarWithin or {}

function PGV_ColorText(text, color)
    if AddOn.PGVHexColors[color] then
        return "|cFF"..AddOn.PGVHexColors[color]..text.."|r"
    end

    return "|cFF"..color..text.."|r"
end
AddOn.PGV_ColorText = PGV_ColorText

function PGV_DebugPrint(...)
    if AddOn.db.profile.debug then
		print(PGV_ColorText("[PGV Debug]", "Heirloom"), ...)
	end
end
AddOn.PGV_DebugPrint = PGV_DebugPrint

function AddOn.PGV_DebugTable(table)
    if AddOn.db.profile.debug then
        print(PGV_ColorText("[PGV Debug Table: START]", "Heirloom"))
        for k, v in pairs(table) do
            print(k, "=", v)
        end
        print(PGV_ColorText("[PGV Debug Table: END]", "Heirloom"))
    end
end

function AddOn.PGV_IsItemEquippedInSlot(slot)
    local item = Item:CreateFromEquipmentSlot(slot:GetID())
    return not item:IsItemEmpty(), item
end

function AddOn.PGV_IsSocketableSlot(slot)
    if xpacInfo and xpacInfo.SocketableSlots then
        for _, gearSlot in ipairs(xpacInfo.SocketableSlots) do
            if slot == gearSlot then
                PGV_DebugPrint("Slot", "|cff00ccff"..slot:GetID().."|r", "is socketable")
                return true
            end
        end
    else
        PGV_DebugPrint("|cFFff3300SocketableSlots not found in expansion info table|r")
    end
    return false
end

function AddOn.PGV_IsEnchantableSlot(slot)
    if xpacInfo and xpacInfo.EnchantableSlots then
        for _, gearSlot in ipairs(xpacInfo.EnchantableSlots) do
            if slot == gearSlot then
                PGV_DebugPrint("Slot", "|cff00ccff"..slot:GetID().."|r", "is enchantable")
                return true
            end
        end
    else
        PGV_DebugPrint("|cFFff3300EnchantableSlots not found in expansion info table|r")
    end
    return false
end

function AddOn.PGV_ConvertRGBToHex(r, g, b)
    return string.format("%02X%02X%02X", r*255, g*255, b*255)
end

function AddOn.PGV_ConvertHexToRGB(hex)
    if tonumber("0x"..hex:sub(1,2)) == nil or tonumber("0x"..hex:sub(3,4)) == nil or tonumber("0x"..hex:sub(5,6)) == nil then
        print("|cFF00ccffPran Gear View: |cFFff3300"..L["invalid_hex_code_msg"].."|r")
        return nil, nil, nil
    end
    return tonumber("0x"..hex:sub(1,2)) / 255,
           tonumber("0x"..hex:sub(3,4)) / 255,
           tonumber("0x"..hex:sub(5,6)) / 255
end

function AddOn.PGV_RoundNumber(val)
    return math.floor(val + 0.5)
end