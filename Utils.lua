local addonName, AddOn = ...
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

AddOn.CurrentExpac = AddOn.PGVExpansionInfo.TheWarWithin

-- General Utility
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
            print(k, "=", ColorText(v, "Info"))
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

function AddOn.ConvertRGBToHex(r, g, b)
    return string.format("%02X%02X%02X", r*255, g*255, b*255)
end

function AddOn.ConvertHexToRGB(hex)
    if tonumber("0x"..hex:sub(1,2)) == nil or tonumber("0x"..hex:sub(3,4)) == nil or tonumber("0x"..hex:sub(5,6)) == nil then
        print(ColorText("Pran Gear View:", "Heirloom"), ColorText(L["Invalid hexadecimal color code provided."], "Error"))
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

-- Options Utility
function AddOn.CreateOptionsSpacer(order)
    return {
        type = "description",
        name = " ",
        order = order
    }
end

-- Gear Utility
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
                    return false, nil
                end
            end
        elseif IsInGroup() then
            for i = 1, MAX_PARTY_MEMBERS do
                local token = "party"..i
                if UnitExists(token) and UnitGUID(token) == self.db.profile.inspectedUnitGUID then
                    DebugPrint("Matching party unit found")
                    local itemLink = GetInventoryItemLink(token, slotID)
                    if itemLink then return true, Item:CreateFromItemLink(itemLink) end
                    return false, nil
                end
            end
        else -- remove else condition for release (testing only)
            for _, plate in ipairs(C_NamePlate.GetNamePlates()) do
                -- use the nameplate token to get item info
                local token = plate.namePlateUnitToken
                if UnitGUID(token) == self.db.profile.inspectedUnitGUID then
                    local itemLink = GetInventoryItemLink(token, slotID)
                    if itemLink then
                        return true, Item:CreateFromItemLink(itemLink)
                    end
                    return false, nil
                end
            end
        end
    else
        local item = Item:CreateFromEquipmentSlot(slot:GetID())
        return not item:IsItemEmpty(), item
    end
end

function AddOn:IsSocketableSlot(slot)
    if self.CurrentExpac and self.CurrentExpac.SocketableSlots then
        for _, gearSlot in ipairs(self.CurrentExpac.SocketableSlots) do
            if slot == gearSlot or (type(gearSlot) == "string" and slot == _G[gearSlot]) then
                DebugPrint("Slot", ColorText(slot:GetID(), "Heirloom"), "is socketable")
                return true
            end
        end
    else
        DebugPrint(ColorText("SocketableSlots not found in expansion info table", "Error"))
    end
    return false
end

-- Currently unused
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

function AddOn:IsEnchantableSlot(slot)
    if self.CurrentExpac and self.CurrentExpac.EnchantableSlots then
        for _, gearSlot in ipairs(self.CurrentExpac.EnchantableSlots) do
            -- Condition for checking available shield/offhand enchants when inspecting another player
            if gearSlot == "InspectSecondaryHandSlot" and slot == _G[gearSlot] then
                local _, item = self:IsItemEquippedInSlot(slot, true)
                if item then
                    local itemClassID, itemSubclassID = select(6, GetItemInfoInstant(item:GetItemLink()))
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
            -- Condition for checking available enchants when inspecting another player
            if type(gearSlot) == "string" and slot == _G[gearSlot] then
                DebugPrint("Inspect Slot", ColorText(slot:GetID(), "Heirloom"), "is enchantable")
                return true
            end
            -- Condition for checking available shield/offhand enchants for current character
            if slot == gearSlot and slot == CharacterSecondaryHandSlot and GetInventoryItemID("player", slot:GetID()) then
                local itemClassID, itemSubclassID = select(6, GetItemInfoInstant(GetInventoryItemID("player", slot:GetID())))
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
            -- Condition for checking available enchants for current character
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
