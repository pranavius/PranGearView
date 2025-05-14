local addonName, AddOn = ...
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)

local DebugPrint = AddOn.DebugPrint
local ColorText = AddOn.ColorText

function AddOn:SetInspectUnitID(unitID)
    if self.db.profile.showOnInspect and (not self.db.profile.inspectedUnitID or self.db.profile.inspectedUnitID ~= unitID) then
        self.db.profile.inspectedUnitID = unitID
        print("Currently inspecting: ", ColorText(select(6, GetPlayerInfoByGUID(self.db.profile.inspectedUnitID)), "Legendary"))
    end
end

function AddOn:UpdatedInspectedGearInfo(_, unitID)
    if not AddOn.InspectInfo or not AddOn.InspectInfo.slots then
        print("Inspect slots table not found")
        return
    end

    self:SetInspectUnitID(unitID)
    -- Currently, no values are found when iterating over the table
    for idx, v in ipairs(AddOn.InspectInfo.slots) do
        print("inspect slot:", idx, "==", _G[v])
    end
    for _, slot in ipairs(AddOn.InspectInfo.slots) do
        local slotID = slot:GetID()
        print("Updating Slot ID:", ColorText(slotID, "Heirloom"))
        if self.db.profile.showILvl then
            if not slot.PGVItemLevel then
                slot.PGVItemLevel = slot:CreateFontString("PGVItemLevel"..slotID, "OVERLAY", "GameTooltipText")
            end
            -- Outline text when placed on the gear icon
            local iFont, iSize = slot.PGVItemLevel:GetFont()
            if self.db.profile.iLvlOnItem then
                slot.PGVItemLevel:SetFont(iFont, iSize, "THICKOUTLINE")
            else
                slot.PGVItemLevel:SetFont(iFont, iSize, "")
            end
            slot.PGVItemLevel:Hide()
            local iLvlTextScale = 1
            if self.db.profile.iLvlScale and self.db.profile.iLvlScale > 0 then
                iLvlTextScale = iLvlTextScale * self.db.profile.iLvlScale
            end
            slot.PGVItemLevel:SetTextScale(iLvlTextScale)
        end

        self:GetItemLevelBySlot(slot)
        self:SetInspectItemLevelPositionBySlot(slot)
    end
end

function AddOn:SetInspectItemLevelPositionBySlot(slot)
    local IsLeftSide = false
    for _, leftSlot in ipairs(AddOn.InspectInfo.leftSideSlots) do
        if slot == leftSlot then IsLeftSide = true end
    end
    for _, bottomSlot in ipairs(AddOn.InspectInfo.bottomSlots) do
        if slot == bottomSlot then IsLeftSide = nil end
    end
    slot.PGVItemLevel:ClearAllPoints()

    if self.db.profile.iLvlOnItem then
        slot.PGVItemLevel:SetPoint("CENTER", slot, "TOP", 0, -10)
    elseif IsLeftSide == nil then
        slot.PGVItemLevel:SetPoint("CENTER", slot, "TOP", 0, 10)
    else
        slot.PGVItemLevel:SetPoint(IsLeftSide and "LEFT" or "RIGHT", slot, IsLeftSide and "RIGHT" or "LEFT", (IsLeftSide and 1 or -1) * 10, 0)
    end
end