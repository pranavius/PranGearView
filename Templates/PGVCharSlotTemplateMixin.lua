local addonName, AddOn = ...
---@class PranGearView
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

local DebugPrint = AddOn.DebugPrint
local ColorText = AddOn.ColorText

---@class PGVCharSlotMixin
PGVCharSlotMixin = {}

function PGVCharSlotMixin:OnLoad()
    print("Slot onLoad")
    ---@type ItemSlot
    local slot = self:GetParent()
    self.IsLeftSideSlot = slot.IsLeftSide == true
    self.IsBottomSlot = slot.IsLeftSide == nil

    self:GetItemLevel(slot)
    self:PositionItemLevel(slot)
    
    self:GetUpgradeTrack(slot)
    self:PositionUpgradeTrack(slot)
end

---Fetches and formats the item level for an item in the defined gear slot (if one exists)
---@param slot ItemSlot The gear slot to get item level for
function PGVCharSlotMixin:GetItemLevel(slot)
    local hasItem, item = AddOn:IsItemEquippedInSlot(slot)
    if hasItem then
        local itemLevel = item:GetCurrentItemLevel()
        if itemLevel > 0 then -- positive value indicates item info has loaded
            local iLvlText = tostring(itemLevel)
            if AddOn.db.profile.itemLevel.useGradientColors then
                local equippedItemLevel = select(2, GetAverageItemLevel())
                local color = (itemLevel < equippedItemLevel - 10 and "Error"
                    or itemLevel > equippedItemLevel + 10 and "Uncommon"
                    or "Info")
                iLvlText = ColorText(iLvlText, color)
            elseif AddOn.db.profile.itemLevel.useQualityColor then
                local qualityHex = select(4, C_Item.GetItemQualityColor(item:GetItemQuality()))
                iLvlText = "|c"..qualityHex..iLvlText.."|r"
            elseif AddOn.db.profile.itemLevel.useClassColor then
                local classFile = select(2, UnitClass("player"))
                local classHexWithAlpha = select(4, GetClassColor(classFile))
                iLvlText = "|c"..classHexWithAlpha..iLvlText.."|r"
            elseif AddOn.db.profile.itemLevel.useCustomColor then
                iLvlText = ColorText(iLvlText, AddOn.db.profile.itemLevel.customColor)
            end

            DebugPrint("Item Level text for slot", ColorText(slot:GetID(), "Heirloom"), "=", iLvlText)
            self.ItemLevel:SetFormattedText(iLvlText)
            self.ItemLevel:ClearAllPoints()

            if AddOn.db.profile.itemLevel.onItem then
                self.ItemLevel:SetPoint("CENTER", slot, "TOP", 0, -10)
            elseif slot.IsLeftSide == nil then
                self.ItemLevel:SetPoint("CENTER", slot, "TOP", 0, 10)
            else
                self.ItemLevel:SetPoint(slot.IsLeftSide and "LEFT" or "RIGHT", slot, slot.IsLeftSide and "RIGHT" or "LEFT", (slot.IsLeftSide and 1 or -1) * 10, 0)
            end
            self.ItemLevel:Show()
        else
            DebugPrint("Item Level less than 0 found, retry self:GetItemLevelBySlot for slot", ColorText(slot:GetID(), "Heirloom"))
            C_Timer.After(0.5, function() self:GetItemLevel(slot) end)
        end
    end
end

---Set item level text position in the Character Info window
---@param slot ItemSlot The gear slot to position item level for
function PGVCharSlotMixin:PositionItemLevel(slot)
    self.ItemLevel:ClearAllPoints()

    if AddOn.db.profile.itemLevel.onItem then
        self.ItemLevel:SetPoint("CENTER", slot, "TOP", 0, -10)
    elseif self.IsBottomSlot then
        self.ItemLevel:SetPoint("CENTER", slot, "TOP", 0, 10)
    else
        self.ItemLevel:SetPoint(self.IsLeftSideSlot and "LEFT" or "RIGHT", slot, self.IsLeftSideSlot and "RIGHT" or "LEFT", (self.IsLeftSideSlot and 1 or -1) * 10, 0)
    end
end

---Fetches and formats the upgrade track for an item in the defined gear slot (if one exists)
---@param slot ItemSlot The gear slot to get upgrade track for
function PGVCharSlotMixin:GetUpgradeTrack(slot)
    local hasItem, item = AddOn:IsItemEquippedInSlot(slot)
    if hasItem then
        local upgradeTrackText = ""
        local upgradeColor = ""
        local tooltip = C_TooltipInfo.GetHyperlink(item:GetItemLink())
        if tooltip and tooltip.lines then
            for _, ttdata in pairs(tooltip.lines) do
                if ttdata and ttdata.type and ttdata.type == AddOn.TooltipDataType.UpgradeTrack then
                    -- Displays past-season upgrade tracks in gray
                    upgradeColor = ttdata.leftColor:GenerateHexColorNoAlpha()
                    local upgradeText = ttdata.leftText
                    upgradeText = AddOn:AbbreviateText(upgradeText, AddOn.UpgradeTextReplacements)
                    upgradeTrackText = upgradeText
                    DebugPrint("Upgrade track for item", ColorText(slot:GetID(), "Heirloom"), "=", upgradeText)
                end
            end
        end

        if upgradeTrackText ~= "" then
            if upgradeColor:lower() ~= AddOn.HexColorPresets.PrevSeasonGear:lower() then
                if AddOn.db.profile.upgradeTrack.useQualityScaleColors then
                    -- Do something
                    if upgradeTrackText:match("E") or upgradeTrackText:match("A") then
                        upgradeColor = AddOn.HexColorPresets.Priest
                    elseif upgradeTrackText:match("V") then
                        upgradeColor = AddOn.HexColorPresets.Uncommon
                    elseif upgradeTrackText:match("C") then
                        upgradeColor = AddOn.HexColorPresets.Rare
                    elseif upgradeTrackText:match("H") then
                        upgradeColor = AddOn.HexColorPresets.Epic
                    elseif upgradeTrackText:match("M") then
                        upgradeColor = AddOn.HexColorPresets.Legendary
                    else
                        -- If a match isn't found, fallback to the item quality color
                        upgradeColor = select(4, C_Item.GetItemQualityColor(item:GetItemQuality())):sub(3)
                    end
                elseif AddOn.db.profile.upgradeTrack.useCustomColor then
                    upgradeColor = AddOn.db.profile.upgradeTrack.customColor
                else
                    upgradeColor = select(4, C_Item.GetItemQualityColor(item:GetItemQuality())):sub(3)
                end
            end
            self.UpgradeTrack:SetFormattedText(ColorText(upgradeTrackText, upgradeColor))
            self.UpgradeTrack:Show()
        end
    end
end

---Set upgrade track text position in the Character Info window
---@param slot ItemSlot The gear slot to position upgrade track for
function PGVCharSlotMixin:PositionUpgradeTrack(slot)
    self.UpgradeTrack:ClearAllPoints()

    local itemLevelShown = AddOn.db.profile.itemLevel.show and not AddOn.db.profile.itemLevel.onItem and self.ItemLevel:IsShown()
    local itemLevelShownOnItem = AddOn.db.profile.itemLevel.show and AddOn.db.profile.itemLevel.onItem and self.ItemLevel:IsShown()
    local isMainHand = slot == CharacterMainHandSlot

    if self.IsBottomSlot then
        self.UpgradeTrack:SetPoint("CENTER", slot, "BOTTOM", (isMainHand and -1 or 1) * 40, 5)
    elseif itemLevelShownOnItem then
        self.UpgradeTrack:SetPoint(self.IsLeftSideSlot and "LEFT" or "RIGHT", slot, self.IsLeftSideSlot and "RIGHT" or "LEFT", (self.IsLeftSideSlot and 1 or -1) * 10, 0)
    elseif itemLevelShown then
        self.UpgradeTrack:SetPoint(self.IsLeftSideSlot and "LEFT" or "RIGHT", self.ItemLevel, self.IsLeftSideSlot and "RIGHT" or "LEFT", self.IsLeftSideSlot and 2.5 or -2.5, 0)
    else
        self.UpgradeTrack:SetPoint(self.IsLeftSideSlot and "LEFT" or "RIGHT", slot, self.IsLeftSideSlot and "RIGHT" or "LEFT", (self.IsLeftSideSlot and 1 or -1) * 10, 0)
    end
end