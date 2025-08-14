local addonName, AddOn = ...
---@class PranGearView: AceAddon, AceConsole-3.0, AceEvent-3.0
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

local button = CreateFrame("Button", "PGVToggleEnchantButton", CharacterFrame.TitleContainer, "UIPanelCloseButton")
local buttonDim = CharacterFrame.TitleContainer:GetHeight() - 1
button:SetSize(buttonDim, buttonDim)
button:SetFrameStrata("TOOLTIP")
button:SetPoint("RIGHT", CharacterFrame.TitleContainer, "RIGHT")
button:SetNormalTexture("Interface\\Icons\\Inv_Enchant_FormulaEpic_01") --237018
button:SetPushedTexture("Interface\\Icons\\Inv_Enchant_FormulaEpic_01")
button:SetHighlightTexture("Interface\\BUTTONS\\UI-Common-MouseHilight", "ADD")

button.tooltipText = L["Hide Enchant Text"]
function button:UpdateTooltip()
    GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
    GameTooltip:ClearLines()
    GameTooltip:SetText(self.tooltipText)
    GameTooltip:Show()
end

button:SetScript("OnEnter", function(self) self:UpdateTooltip() end)

button:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

AddOn.PGVToggleEnchantButton = button

---Updates the text shown for the tooltip when hovering over the enchant text toggling button in the Character Info window
---@param text string The text that should appear in the button's tooltip
function AddOn.PGVToggleEnchantButton:UpdateTooltipText(text)
    self.tooltipText = text
    self:UpdateTooltip()
end
