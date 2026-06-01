local addonName, AddOn = ...
---@class PranGearView
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)
local LDB = LibStub("LibDataBroker-1.1")
local LDBIcon  = LibStub("LibDBIcon-1.0")

local DebugPrint = AddOn.DebugPrint
local ColorText = AddOn.ColorText

AddOn.StatsCache = {
    [STAT_CRITICAL_STRIKE] = nil,
    [STAT_HASTE] = nil,
    [STAT_MASTERY] = nil,
    [STAT_VERSATILITY] = nil,
    [STAT_AVOIDANCE] = nil,
    [STAT_LIFESTEAL] = nil,
    [STAT_SPEED] = nil,
    [STAT_ARMOR] = nil,
    [STAT_BLOCK] = nil,
    [STAT_PARRY] = nil,
}

---Ace3 entry point. Initializes the database, registers the LDB launcher and minimap icon,
---wires up slash commands and options, and hooks the Blizzard frames needed to render gear info.
function AddOn:OnInitialize()
    -- Load database
	 ---@diagnostic disable-next-line: field-type-mismatch
    self.db = LibStub("AceDB-3.0"):New("PranGearViewDB", self.DatabaseDefaults, true)

    -- Data broker registration for minimap icon
    local broker = LDB:NewDataObject(addonName, {
    type = "launcher",
    text = addonName,
    icon = "Interface/AddOns/PranGearView/Media/PranGearViewIcon",
    OnClick = function()
      -- Open options window when not restricted
      if not self:IsAddOnCurrentlyRestricted() then Settings.OpenToCategory(self.categoryID) end
    end,
    OnTooltipShow = function(tt)
      tt:AddLine(addonName)
      tt:AddLine(L["Open the AddOn options window"], 1,1,1)
    end,
  })
  LDBIcon:Register(addonName, broker, self.db.profile.general.minimap)

    -- Setup config options
    local profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
    local config = LibStub("AceConfig-3.0")
    local registry = LibStub("AceConfigRegistry-3.0")

    -- Register Ace3 slash commands and override the default behavior so /pgv and /prangearview open the settings window
    config:RegisterOptionsTable(addonName, self.SlashOptions, self.SlashCmds)
    self:RegisterChatCommand("pgv", function(input) self.HandlePGVSlashCmd("pgv", input) end)
    self:RegisterChatCommand("prangearview", function(input) self.HandlePGVSlashCmd("prangearview", input) end)
    LibStub("AceConfigRegistry-3.0"):ValidateOptionsTable(self.OptionsTable, addonName)
    registry:RegisterOptionsTable("PGVOptions", self.OptionsTable)
	registry:RegisterOptionsTable("PGVProfiles", profiles)
    _, self.categoryID = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("PGVOptions", addonName)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("PGVProfiles", "Profiles", addonName);

    if self.db.profile.enchants.collapse then
        DebugPrint("OnInit: Enchant text is collapsed, update button text accordingly")
        self.PGVToggleEnchantButton:UpdateTooltipText(L["Show Enchant Text"])
    end

    self.PGVToggleEnchantButton:SetScript("OnClick", function(button)
        local collapseEnchants = not self.db.profile.enchants.collapse
        self.db.profile.enchants.collapse = collapseEnchants
        self.UpdateEquippedGearInfo(self)
        button:UpdateTooltipText(collapseEnchants and L["Show Enchant Text"] or L["Hide Enchant Text"])
    end)

    if (not self:AreEnchantsShownForCharacter() or (self:AreEnchantsShownForCharacter() and not self.db.profile.enchants.showTextButton)) and self.PGVToggleEnchantButton:IsShown() then
        self.PGVToggleEnchantButton:Hide()
    end

    self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", "HandleEquipmentOrSettingsChange")
    self:RegisterEvent("UPDATE_INVENTORY_DURABILITY", "HandleEquipmentOrSettingsChange")
    self:RegisterEvent("SOCKET_INFO_ACCEPT", "HandleEquipmentOrSettingsChange")

    -- Necessary to create DB entries for stat ordering when playing a new class/specialization
    self:RegisterEvent("PLAYER_ENTERING_WORLD", function() self:InitializeCustomSpecStatOrderDB() end)
    self:RegisterEvent("ACTIVE_PLAYER_SPECIALIZATION_CHANGED", function() self:InitializeCustomSpecStatOrderDB() end)

    self:RegisterEvent("INSPECT_READY", function(_, unitGUID)
        if InspectFrame and InspectFrame.unit then
            if not self.inspectHookSetup then
                self.inspectHookSetup = true
                InspectFrame:HookScript("OnHide", function()
                    self.inspectedUnitGUID = nil
                    self.noUnitTokenMessagePrinted = false
                    ClearInspectPlayer()
                    for _, slotName in ipairs(self.InspectInfo.slots) do
                        local slot = _G[slotName]
                        if slot and slot.PGVInspectSlot then
                            slot.PGVInspectSlot:HideAllFrames()
                        end
                    end
                    if InspectPaperDollItemsFrame and InspectPaperDollItemsFrame.PGVAverageItemLevel then
                        InspectPaperDollItemsFrame.PGVAverageItemLevel:Hide()
                    end
                    DebugPrint("InspectFrame OnHide: Cleared InspectPlayer and inspectedUnitGUID variable")
                end)
            end

            self:UpdateInspectedGearInfo(unitGUID)
        end
    end)
    DebugPrint(ColorText(addonName, "Heirloom"), "initialized successfully")

    -- Hook into necessary secure functions
    hooksecurefunc(CharacterFrame, "ShowSubFrame", function(_, subFrame)
        if subFrame == "PaperDollFrame" then
            self:UpdateEquippedGearInfo()
        end
    end)
    hooksecurefunc(CharacterFrame, "RefreshDisplay", function()
        self:AdjustCharacterInfoWindowSize()
    end)
    hooksecurefunc(CharacterModelScene, "TransitionToModelSceneID", function(cms, sceneID)
        if sceneID == 595 and PaperDollFrame:IsVisible() and self.db.profile.general.increaseCharacterInfoSize then
            local actor = cms:GetPlayerActor()
            DebugPrint("CMS TransitionToModelSceneID: requested scale before modification -", actor:GetRequestedScale())
            actor:SetRequestedScale(actor:GetRequestedScale() * 0.8)
            actor:UpdateScale()
            DebugPrint("CMS TransitionToModelSceneID: Updated requested scale to", actor:GetRequestedScale())
            local posX, posY, posZ = actor:GetPosition()
            -- Apply a offeset to the vertical positioning so that more of the model is visible (feet are not covered)
            actor:SetPosition(posX, posY, posZ + 0.25)
        end
    end)
    hooksecurefunc("PaperDollFrame_UpdateStats", function()
        self:ReorderStatFramesBySpec()
        if CharacterStatsPane and self.db.profile.characterStats.showDecimals then self:ShowDecimalStatValues() end
        if CharacterStatsPane and self.db.profile.general.showCharacteriLvlDecimal then
            CharacterStatsPane.ItemLevelFrame.Value:SetFormattedText("%."..self.db.profile.general.decimalPlacesForCharacteriLvl.."f", select(2, GetAverageItemLevel()))
        end
    end)

    -- When the Character Stats Pane is shown, attempt to fetch character stat values
    -- Should succeed as long as player stats are not currently secret
    CharacterStatsPane:HookScript("OnShow", function()
        self:CachePlayerStatValues()
    end)

    -- When the options window is opened, default the spec dropdown to the character's current specialization.
    -- If the current spec has no known option key (e.g. unsupported spec), leave lastSelectedSpecID untouched
    -- so the user's previous valid selection is preserved.
    SettingsPanel:HookScript("OnShow", function()
        local specID = self:GetCharacterCurrentSpecIDAndRole()
        if self.SpecOptionKeys[specID] then
            self.db.profile.characterStats.lastSelectedSpecID = specID
        end
        LibStub("AceConfigRegistry-3.0"):NotifyChange(addonName)
        LibStub("AceConfigRegistry-3.0"):NotifyChange("PGVOptions")
    end)
end

---Handles slash commands in a way that overrides the default behavior of Ace3 slash commands. Executing the command with no arguments
---opens the AddOn options window, providing the `help` argument displays a list of available arguments and uses for the slash command,
---and all other arguments are handled using Ace3's default behavior.
---@param cmd string The slash command used (should be one of `/pgv` or `/prangearview`)
---@param input string The argument provided to the slash command
function AddOn.HandlePGVSlashCmd(cmd, input)
    input = strtrim(input)
    if input == "" then
        if not AddOn:IsAddOnCurrentlyRestricted() then Settings.OpenToCategory(AddOn.categoryID) end
    elseif input == "help" then
        LibStub("AceConfigCmd-3.0"):HandleCommand(cmd, addonName, "")
        -- Mimic the Ace3 command description format to indicate that no argument opens the addon options
        print("  |cffffff78(no argument)|r - "..L["Open the AddOn options window"])
    else
        LibStub("AceConfigCmd-3.0"):HandleCommand(cmd, addonName, input)
    end
end

---Handles changing the Character Info window size when the option to use the larger character window is checked
function AddOn:AdjustCharacterInfoWindowSize()
    DebugPrint("AdjustCharacterInfoWindowSize: Refreshing display")
    if PaperDollFrame:IsVisible() and self.db.profile.general.increaseCharacterInfoSize then
        DebugPrint("AdjustCharacterInfoWindowSize: Larger character info window enabled")
        -- Overwrite defined character frame width and adjust positioning of frames within CharacterFrame
        CharacterFrame:SetWidth(650)
        CharacterFrameInset:SetPoint("BOTTOMRIGHT", CharacterFrame, "BOTTOMLEFT", 450, 4)
        CharacterModelScene:SetPoint("BOTTOMRIGHT", CharacterFrameInset, "BOTTOMLEFT", 400, 35)
        CharacterMainHandSlot:SetPoint("BOTTOMLEFT", PaperDollItemsFrame, "BOTTOMLEFT", 200, 16)
        CharacterModelFrameBackgroundTopLeft:SetWidth(331)
        CharacterModelFrameBackgroundBotLeft:SetWidth(331)
    elseif PaperDollFrame:IsVisible() then
        DebugPrint("AdjustCharacterInfoWindowSize: Larger character info window disabled. Resetting any adjusted values.")
        -- Undo all changes made for displaying the larger window
        -- Sources: /fstack in-game and https://www.townlong-yak.com/framexml/live/Blizzard_UIPanels_Game/PaperDollFrame.xml
        local charFrameInsetBotRightXOffset = select(4, CharacterFrameInset:GetPointByName("BOTTOMRIGHT"))
        local charModelSceneBotRight = CharacterModelScene:GetPointByName("BOTTOMRIGHT")
        local charMainHandSlotBotLeftXOffset = select(4, CharacterMainHandSlot:GetPointByName("BOTTOMLEFT"))
        if CharacterFrame:GetWidth() ~= CHARACTERFRAME_EXPANDED_WIDTH then CharacterFrame:SetWidth(CHARACTERFRAME_EXPANDED_WIDTH) end
        if charFrameInsetBotRightXOffset ~= 32 then CharacterFrameInset:SetPoint("BOTTOMRIGHT", CharacterFrame, "BOTTOMLEFT", 332, 4) end
        if charModelSceneBotRight then CharacterModelScene:ClearPoint("BOTTOMRIGHT") end
        if charMainHandSlotBotLeftXOffset ~= 130 then CharacterMainHandSlot:SetPoint("BOTTOMLEFT", PaperDollItemsFrame, "BOTTOMLEFT", 130, 16) end
        if CharacterModelFrameBackgroundTopLeft:GetWidth() ~= 212 then CharacterModelFrameBackgroundTopLeft:SetWidth(212) end
        if CharacterModelFrameBackgroundBotLeft:GetWidth() ~= 212 then CharacterModelFrameBackgroundBotLeft:SetWidth(212) end
        if CharacterModelScene:GetPlayerActor() then
            local actor = CharacterModelScene:GetPlayerActor()
            if actor:GetRequestedScale() then actor.requestedScale = nil end
            actor:UpdateScale()
            if select(3, actor:GetPosition()) > 1.25 then actor:SetPosition(0, 0, select(3, actor:GetPosition()) - 0.25) end
        end
    end
end

---Handles changes to equipped gear or AddOn settings when Character Info and/or Inspect window is visible
function AddOn:HandleEquipmentOrSettingsChange()
    if PaperDollFrame:IsVisible() then
        DebugPrint("HandleEquipmentOrSettingsChange: Updating character gear information")
        self:UpdateEquippedGearInfo();
    end
    if InspectPaperDollFrame and InspectPaperDollFrame:IsVisible() then
        DebugPrint("HandleEquipmentOrSettingsChange: Updating inspected gear information")
        self:UpdateInspectedGearInfo(self.inspectedUnitGUID, true)
    end
end

---Updates information displayed in the Character Info window
function AddOn:UpdateEquippedGearInfo()
    if not self.GearSlots then
        DebugPrint("UpdateEquippedGearInfo: Gear slots table not readable")
        return
    end
    
    DebugPrint("UpdateEquippedGearInfo: Enchants collapsed -", self.db.profile.enchants.collapse)
    for _, slot in ipairs(self.GearSlots) do
        local slotID = slot:GetID()
        if not slot.PGVCharSlot then
            ---@type PGVCharSlotMixin
            slot.PGVCharSlot = CreateFrame("Frame", "PGVSlot"..slotID, slot, "PGVCharSlotTemplate")
        else
            slot.PGVCharSlot:UpdateSlotInfo()
        end
        slot.PGVCharSlot:SetFontOptions()
    end
    -- Manually force a stats update to update item level decimal places and stat ordering if needed
    if not C_Secrets.ShouldUnitStatsBeSecret() then PaperDollFrame_UpdateStats() end
end
