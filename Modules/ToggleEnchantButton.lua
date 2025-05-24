local addonName, AddOn = ...
---@class PranGearView: AceAddon, AceConsole-3.0, AceEvent-3.0
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

local button = CreateFrame("Button", "PGVToggleEnchantButton", PaperDollSidebarTabs)
button:SetSize(96, 17)
button:SetFrameStrata("TOOLTIP")
button:SetPoint("BOTTOMRIGHT", PaperDollSidebarTabs, "TOPRIGHT", -15, 6)
button:SetNormalTexture("Interface\\BUTTONS\\UI-DialogBox-Button-Up")
button:GetNormalTexture():SetTexCoord(0.0, 1.0, 0.0, 0.71875)
button:SetPushedTexture("Interface\\BUTTONS\\UI-DialogBox-Button-Down")
button:GetPushedTexture():SetTexCoord(0.0, 1.0, 0.0, 0.71875)
button:SetHighlightTexture("Interface\\BUTTONS\\UI-Common-MouseHilight", "ADD")
button:GetHighlightTexture():SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)

button:SetFontString(button:CreateFontString(nil, "OVERLAY", "GameFontNormal"))
button:GetFontString():SetText(L["Hide Enchant Text"])
button:GetFontString():SetPoint("CENTER")
button:GetFontString():SetTextScale(0.8)
button:SetHighlightFontObject("GameFontHighlight")

AddOn.PGVToggleEnchantButton = button

---Updates the text shown on the enchant text toggling button in the Character Info window
---@param text string The text that should appear on the button
function AddOn.PGVToggleEnchantButton:UpdateText(text)
    self:GetFontString():SetText(text)
end
