local addonName, PGV = ...
local L = PGV.L

PGVOptionsDescriptionMixin = {}
function PGVOptionsDescriptionMixin:Init(initializer)
    self.Text:SetText(initializer:GetName())
    if initializer:GetData().large then
        self.Text:SetFontObject(GameFontNormalLarge)
    end
end

local function refreshSlots()
    if PGV.UpdateAllSlots then
        PGV.UpdateAllSlots()
    end
    if PGV.UpdateInspectedGearInfo and InspectPaperDollFrame and InspectPaperDollFrame:IsVisible() then
        PGV.UpdateInspectedGearInfo(PGV.inspectedUnitGUID, true)
    end
    if PGV.UpdateEnchantToggleButtonVisibility then
        PGV.UpdateEnchantToggleButtonVisibility()
    end
end
PGV.RefreshSlots = refreshSlots

local function makeToggle(category, variable, name, tooltip, getValue, setValue)
    local setting = Settings.RegisterProxySetting(category, variable, Settings.VarType.Boolean, name, false, getValue, function(value)
        setValue(value)
        refreshSlots()
    end)
    return Settings.CreateCheckbox(category, setting, tooltip)
end

local function makeSharedToggle(rootCategory, subCategory, variable, name, tooltip, getValue, setValue)
    local setting = Settings.RegisterProxySetting(rootCategory, variable, Settings.VarType.Boolean, name, false, getValue, function(value)
        setValue(value)
        refreshSlots()
    end)
    local rootInit = Settings.CreateCheckbox(rootCategory, setting, tooltip)
    local subInit = Settings.CreateCheckbox(subCategory, setting, tooltip)
    return rootInit, subInit
end

local function scalePercentFormatter(value)
    return FormatPercentage(value, true)
end

local function makeSlider(category, variable, name, tooltip, minValue, maxValue, step, getValue, setValue)
    local setting = Settings.RegisterProxySetting(category, variable, Settings.VarType.Number, name, minValue, getValue, function(value)
        setValue(value)
        refreshSlots()
    end)
    local options = Settings.CreateSliderOptions(minValue, maxValue, step)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
    return Settings.CreateSlider(category, setting, options, tooltip)
end

local function makeSharedScaleSlider(rootCategory, subCategory, variable, name, tooltip, dbTable)
    local setting = Settings.RegisterProxySetting(rootCategory, variable, Settings.VarType.Number, name, 1,
        function() return dbTable.scale end,
        function(value)
            dbTable.scale = value
            refreshSlots()
        end)
    local options = Settings.CreateSliderOptions(0.01, 2, 0.01)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, scalePercentFormatter)
    local rootInit = Settings.CreateSlider(rootCategory, setting, options, tooltip)
    local subInit = Settings.CreateSlider(subCategory, setting, options, tooltip)
    return rootInit, subInit
end

local function makeOutlineDropdown(category, variable, name, tooltip, dbTable)
    local setting = Settings.RegisterProxySetting(category, variable, Settings.VarType.String, name, "",
        function() return dbTable.outline end,
        function(value)
            dbTable.outline = value
            refreshSlots()
        end)
    local function getOptions()
        local container = Settings.CreateControlTextContainer()
        for _, option in ipairs(PGV.OutlineOptions) do
            container:Add(option.value, option.key)
        end
        return container:GetData()
    end
    return Settings.CreateDropdown(category, setting, getOptions, tooltip)
end

local function makeColorSwatch(category, variable, name, tooltip, dbTable, key)
    local setting = Settings.RegisterProxySetting(category, variable, Settings.VarType.String, name, "FF"..PGV.HexColorPresets.Priest,
        function() return "FF"..dbTable[key] end,
        function(value)
            dbTable[key] = value:sub(-6)
            refreshSlots()
        end)
    return Settings.CreateColorSwatch(category, setting, tooltip)
end

local function makeSharedColorModeDropdown(rootCategory, subCategory, variable, name, tooltip, dbTable, modes)
    local function getCurrentMode()
        for _, mode in ipairs(modes) do
            if dbTable[mode.dbKey] then
                return mode.value
            end
        end
        return modes[1].value
    end
    local setting = Settings.RegisterProxySetting(rootCategory, variable, Settings.VarType.String, name, modes[1].value, getCurrentMode, function(value)
        for _, mode in ipairs(modes) do
            if mode.dbKey then
                dbTable[mode.dbKey] = (mode.value == value)
            end
        end
        refreshSlots()
    end)
    local function getOptions()
        local container = Settings.CreateControlTextContainer()
        for _, mode in ipairs(modes) do
            container:Add(mode.value, mode.label)
        end
        return container:GetData()
    end
    local rootInit = Settings.CreateDropdown(rootCategory, setting, getOptions, tooltip)
    local subInit = Settings.CreateDropdown(subCategory, setting, getOptions, tooltip)
    return rootInit, subInit
end

local function linkToShowToggle(rootShowInit, subShowInit, rootInit, subInit, isShown, shownPredicate)
    subInit:SetParentInitializer(subShowInit, isShown)
    if rootInit then
        rootInit:SetParentInitializer(rootShowInit, isShown)
    end
    if shownPredicate then
        subInit:AddShownPredicate(shownPredicate)
        if rootInit then
            rootInit:AddShownPredicate(shownPredicate)
        end
    end
end

local RaceIcons = {
    Human = { Male = "RaceIcon128-Human-Male", Female = "RaceIcon128-Human-Female" },
    Dwarf = { Male = "RaceIcon128-Dwarf-Male", Female = "RaceIcon128-Dwarf-Female" },
    NightElf = { Male = "RaceIcon128-NightElf-Male", Female = "RaceIcon128-NightElf-Female" },
    Gnome = { Male = "RaceIcon128-Gnome-Male", Female = "RaceIcon128-Gnome-Female" },
    Draenei = { Male = "RaceIcon128-Draenei-Male", Female = "RaceIcon128-Draenei-Female" },
    Worgen = { Male = "RaceIcon128-Worgen-Male", Female = "RaceIcon128-Worgen-Female" },
    VoidElf = { Male = "RaceIcon128-VoidElf-Male", Female = "RaceIcon128-VoidElf-Female" },
    LightforgedDraenei = { Male = "RaceIcon128-Lightforged-Male", Female = "RaceIcon128-Lightforged-Female" },
    DarkIronDwarf = { Male = "RaceIcon128-DarkIronDwarf-Male", Female = "RaceIcon128-DarkIronDwarf-Female" },
    KulTiran = { Male = "RaceIcon128-KulTiran-Male", Female = "RaceIcon128-KulTiran-Female" },
    Mechagnome = { Male = "RaceIcon128-Mechagnome-Male", Female = "RaceIcon128-Mechagnome-Female" },
    Orc = { Male = "RaceIcon128-Orc-Male", Female = "RaceIcon128-Orc-Female" },
    Undead = { Male = "RaceIcon128-Undead-Male", Female = "RaceIcon128-Undead-Female" },
    Tauren = { Male = "RaceIcon128-Tauren-Male", Female = "RaceIcon128-Tauren-Female" },
    Troll = { Male = "RaceIcon128-Troll-Male", Female = "RaceIcon128-Troll-Female" },
    BloodElf = { Male = "RaceIcon128-BloodElf-Male", Female = "RaceIcon128-BloodElf-Female" },
    Goblin = { Male = "RaceIcon128-Goblin-Male", Female = "RaceIcon128-Goblin-Female" },
    Nightborne = { Male = "RaceIcon128-Nightborne-Male", Female = "RaceIcon128-Nightborne-Female" },
    HighmountainTauren = { Male = "RaceIcon128-Highmountain-Male", Female = "RaceIcon128-Highmountain-Female" },
    MagharOrc = { Male = "RaceIcon128-MagharOrc-Male", Female = "RaceIcon128-MagharOrc-Female" },
    ZandalariTroll = { Male = "RaceIcon128-Zandalari-Male", Female = "RaceIcon128-Zandalari-Female" },
    Vulpera = { Male = "RaceIcon128-Vulpera-Male", Female = "RaceIcon128-Vulpera-Female" },
    Pandaren = { Male = "RaceIcon128-Pandaren-Male", Female = "RaceIcon128-Pandaren-Female" },
    Dracthyr = { Male = "RaceIcon128-Dracthyr-Male", Female = "RaceIcon128-Dracthyr-Female" },
    Earthen = { Male = "RaceIcon128-Earthen-Male", Female = "RaceIcon128-Earthen-Female" },
    Haranir = { Male = "RaceIcon128-Haranir-Male", Female = "RaceIcon128-Haranir-Female" },
}

local ClassIcons = {
    DeathKnight = "ClassIcon-DeathKnight",
    DemonHunter = "ClassIcon-DemonHunter",
    Druid = "ClassIcon-Druid",
    Evoker = "ClassIcon-Evoker",
    Hunter = "ClassIcon-Hunter",
    Mage = "ClassIcon-Mage",
    Monk = "ClassIcon-Monk",
    Paladin = "ClassIcon-Paladin",
    Priest = "ClassIcon-Priest",
    Rogue = "ClassIcon-Rogue",
    Shaman = "ClassIcon-Shaman",
    Warlock = "ClassIcon-Warlock",
    Warrior = "ClassIcon-Warrior",
}

local CONTRIBUTORS = {
    { name = "Tusk", race = RaceIcons.Pandaren.Male, class = ClassIcons.Monk, color = "Monk" },
    { name = "Numynum", race = RaceIcons.BloodElf.Female, class = ClassIcons.DemonHunter, color = "DemonHunter" },
    { name = "ZamestoTV", race = RaceIcons.NightElf.Male, class = ClassIcons.Druid, color = "Druid" },
    { name = "Lirfdam", color = "Priest" },
    { name = "BlueNightSky", color = "Priest" },
    { name = "Azaran", color = "Priest" },
    { name = "StummerKater", color = "Priest" },
    { name = "Rubyurek", color = "Priest" },
}

local SPECIAL_THANKS = {
    { name = "Beo", race = RaceIcons.Pandaren.Female, class = ClassIcons.DemonHunter, color = "DemonHunter" },
    { name = "Knifermonkey", race = RaceIcons.Undead.Male, class = ClassIcons.Warlock, color = "Warlock" },
    { name = "Jery", race = RaceIcons.BloodElf.Male, class = ClassIcons.Mage, color = "Mage" },
    { name = "Emraliya", race = RaceIcons.HighmountainTauren.Female, class = ClassIcons.DeathKnight, color = "DeathKnight" },
    { name = "Aliakin", race = RaceIcons.Human.Male, class = ClassIcons.Mage, color = "Mage" },
    { name = "Grok", race = RaceIcons.Orc.Male, class = ClassIcons.Warrior, color = "Warrior" },
}

local function addCreditRow(layout, text, large)
    layout:AddInitializer(Settings.CreateElementInitializer("PGVOptionsDescriptionTemplate", { name = text, large = large }))
end

local function addCreditPerson(layout, person)
    local icons = (person.race and CreateAtlasMarkup(person.race, 20, 20) or "")..(person.class and CreateAtlasMarkup(person.class, 20, 20) or "")
    addCreditRow(layout, icons..(icons ~= "" and " " or "")..PGV.ColorText(person.name, person.color))
end

local function buildCreditsCategory(rootCategory)
    local _, creditsLayout = Settings.RegisterVerticalLayoutSubcategory(rootCategory, L["Credits"])

    addCreditRow(creditsLayout, PGV.ColorText(addonName.." "..L["Credits"], "Info"), true)
    creditsLayout:AddInitializer(Settings.CreateElementInitializer("PGVOptionsSpacerTemplate", {}))
    addCreditRow(creditsLayout, PGV.ColorText("Created by "..CreateAtlasMarkup(RaceIcons.BloodElf.Male, 20, 20)..CreateAtlasMarkup(ClassIcons.Monk, 20, 20).." Pranavius", "Heirloom"))
    creditsLayout:AddInitializer(Settings.CreateElementInitializer("PGVOptionsSpacerTemplate", {}))

    creditsLayout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L["Contributors"]))
    for _, contributor in ipairs(CONTRIBUTORS) do
        addCreditPerson(creditsLayout, contributor)
    end

    creditsLayout:AddInitializer(Settings.CreateElementInitializer("PGVOptionsSpacerTemplate", {}))
    addCreditRow(creditsLayout, L["If you would like to contribute to development, you can find the repository on GitHub."].."\n"..L["Please follow the development guidelines outlined in the README document."])
    creditsLayout:AddInitializer(Settings.CreateElementInitializer("PGVOptionsSpacerTemplate", {}))

    creditsLayout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L["Special Thanks"]))
    for _, person in ipairs(SPECIAL_THANKS) do
        addCreditPerson(creditsLayout, person)
    end

    creditsLayout:AddInitializer(Settings.CreateElementInitializer("PGVOptionsSpacerTemplate", {}))
    creditsLayout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L["Connect"]))
    addCreditRow(creditsLayout, CreateSimpleTextureMarkup("Interface/AddOns/PranGearView/Media/X-logo", 20, 20, 0, 5)..PGV.ColorText("@PranaviusWoW", "Legendary"))
    addCreditRow(creditsLayout, CreateSimpleTextureMarkup("Interface/AddOns/PranGearView/Media/Github-logo", 20, 20, 0, 5)..PGV.ColorText("Pranavius", "Legendary"))
end

local function buildOptions()
    local rootCategory, rootLayout = Settings.RegisterVerticalLayoutCategory("PranGearView")
    Settings.RegisterAddOnCategory(rootCategory)
    PGV.categoryID = rootCategory:GetID()

    makeToggle(rootCategory, "showMinimap", L["Show Minimap Icon"], L["Show an icon on the minimap to open the AddOn settings"],
        function() return not PGV.db.general.minimap.hide end,
        function(value)
            PGV.db.general.minimap.hide = not value
            local LDBIcon = LibStub("LibDBIcon-1.0")
            if value then
                LDBIcon:Show(addonName)
            else
                LDBIcon:Hide(addonName)
            end
        end)
    if not PGV.isCamelot then
        makeToggle(rootCategory, "increaseCharacterInfoSize", L["Larger Character Info Window"], L["Increase the size of the Character Info window"].."\n\n"..L["This can help reduce text overlap with the character model and make reading text easier."],
            function() return PGV.db.general.increaseCharacterInfoSize end,
            function(value)
                PGV.db.general.increaseCharacterInfoSize = value
                PGV.AdjustCharacterInfoWindowSize()
            end)
        makeToggle(rootCategory, "showEmbellishments", L["Show Embellishments"], L["Show a green star in the top-left corner of embellished equipment"],
            function() return PGV.db.general.showEmbellishments end,
            function(value) PGV.db.general.showEmbellishments = value end)
        local showCharILvlDecimalInit = makeToggle(rootCategory, "showCharacteriLvlDecimal", L["Show Decimals for Equipped Item Level"], L["Show your character's average equipped item level with decimal places"],
            function() return PGV.db.general.showCharacteriLvlDecimal end,
            function(value)
                PGV.db.general.showCharacteriLvlDecimal = value
                PaperDollFrame_UpdateStats()
            end)
        local decimalPlacesInit = makeSlider(rootCategory, "decimalPlacesForCharacteriLvl", L["Decimal Precision"], L["Number of decimal places to show for character's equipped item level"], 1, 3, 1,
            function() return PGV.db.general.decimalPlacesForCharacteriLvl end,
            function(value)
                PGV.db.general.decimalPlacesForCharacteriLvl = value
                PaperDollFrame_UpdateStats()
            end)
        decimalPlacesInit:SetParentInitializer(showCharILvlDecimalInit, function() return PGV.db.general.showCharacteriLvlDecimal end)
        decimalPlacesInit:AddShownPredicate(function() return PGV.db.general.showCharacteriLvlDecimal end)
    end
    makeToggle(rootCategory, "hideShirtTabardInfo", L["Hide Shirt & Tabard Info"], L["Hide information for equipped shirt & tabard"],
        function() return PGV.db.general.hideShirtTabardInfo end,
        function(value) PGV.db.general.hideShirtTabardInfo = value end)
    makeToggle(rootCategory, "debugMode", L["Debug Mode"], L["Display debugging messages in the default chat window"].."\n\n"..PGV.ColorText(L["You should never need to enable this"], "DeathKnight"),
        function() return PGV.db.general.debug end,
        function(value) PGV.db.general.debug = value end)

    rootLayout:AddInitializer(Settings.CreateElementInitializer("PGVOptionsSpacerTemplate", {}))

    rootLayout:AddInitializer(Settings.CreateElementInitializer("PGVOptionsDescriptionTemplate", { name = L["Choose information to show in the Character Info window."].." "..L["Open a specific category for additional customization options."] }))

    rootLayout:AddInitializer(Settings.CreateElementInitializer("PGVOptionsSpacerTemplate", {}))

    local itemLevelCategory = Settings.RegisterVerticalLayoutSubcategory(rootCategory, L["Item Level"])
    local itemLevelIsShown = function() return PGV.db.itemLevel.show end
    local itemLevelRootShow, itemLevelSubShow = makeSharedToggle(rootCategory, itemLevelCategory, "itemLevelShow", L["Item Level"], L["Display item levels for equipped items"],
        itemLevelIsShown, function(value) PGV.db.itemLevel.show = value end)

    local itemLevelRootScale, itemLevelSubScale = makeSharedScaleSlider(rootCategory, itemLevelCategory, "itemLevelScale", L["Font Scale"], L["Scale item level text size relative to the default"], PGV.db.itemLevel)
    local itemLevelOutlineInit = makeOutlineDropdown(itemLevelCategory, "itemLevelOutline", L["Outline"], L["The outline style to add to item level text"], PGV.db.itemLevel)
    local itemLevelOnItemInit = makeToggle(itemLevelCategory, "itemLevelOnItem", L["Alternate Item Level Placement"], L["Display item levels on top of equipment icons"],
        function() return PGV.db.itemLevel.onItem end,
        function(value) PGV.db.itemLevel.onItem = value end)

    local ITEM_LEVEL_COLOR_MODES = {
        { value = "quality", label = L["Use Item Quality Color"], dbKey = "useQualityColor" },
        { value = "class", label = L["Use Class Color"], dbKey = "useClassColor" },
        { value = "gradient", label = L["Use Item Level Gradient"], dbKey = "useGradientColors" },
        { value = "custom", label = L["Use Custom Color"], dbKey = "useCustomColor" },
    }
    local itemLevelRootColorMode, itemLevelSubColorMode = makeSharedColorModeDropdown(rootCategory, itemLevelCategory, "itemLevelColorMode", L["Text Color"], L["Customize item level color"], PGV.db.itemLevel, ITEM_LEVEL_COLOR_MODES)
    local itemLevelColorInit = makeColorSwatch(itemLevelCategory, "itemLevelColor", L["Choose a Color"], L["Customize item level color"], PGV.db.itemLevel, "customColor")
    itemLevelColorInit:AddShownPredicate(function() return PGV.db.itemLevel.useCustomColor end)

    linkToShowToggle(itemLevelRootShow, itemLevelSubShow, itemLevelRootScale, itemLevelSubScale, itemLevelIsShown)
    linkToShowToggle(itemLevelRootShow, itemLevelSubShow, itemLevelRootColorMode, itemLevelSubColorMode, itemLevelIsShown)
    for _, initializer in ipairs({ itemLevelOutlineInit, itemLevelOnItemInit, itemLevelColorInit }) do
        initializer:SetParentInitializer(itemLevelSubShow, itemLevelIsShown)
    end

    rootLayout:AddInitializer(Settings.CreateElementInitializer("PGVOptionsSpacerTemplate", {}))

    local notTimerunning = function() return not PGV.IsTimerunningCharacter() end

    if not PGV.isCamelot then
        local upgradeTrackCategory = Settings.RegisterVerticalLayoutSubcategory(rootCategory, L["Upgrade Track"])
        local upgradeTrackIsShown = function() return PGV.db.upgradeTrack.show end
        local upgradeTrackRootShow, upgradeTrackSubShow = makeSharedToggle(rootCategory, upgradeTrackCategory, "upgradeTrackShow", L["Upgrade Track"], L["Display upgrade track and progress for equipped items"],
            upgradeTrackIsShown, function(value) PGV.db.upgradeTrack.show = value end)
        upgradeTrackRootShow:AddShownPredicate(notTimerunning)
        upgradeTrackSubShow:AddShownPredicate(notTimerunning)

        local upgradeTrackRootScale, upgradeTrackSubScale = makeSharedScaleSlider(rootCategory, upgradeTrackCategory, "upgradeTrackScale", L["Font Scale"], L["Scale upgrade track text size relative to the default"], PGV.db.upgradeTrack)
        local upgradeTrackOutlineInit = makeOutlineDropdown(upgradeTrackCategory, "upgradeTrackOutline", L["Outline"], L["The outline style to add to upgrade track text"], PGV.db.upgradeTrack)

        local UPGRADE_TRACK_COLOR_MODES = {
            { value = "quality", label = L["Use Item Quality Color"] },
            { value = "qualityScale", label = L["Use Quality Color Scale"], dbKey = "useQualityScaleColors" },
            { value = "custom", label = L["Use Custom Color"], dbKey = "useCustomColor" },
        }
        local upgradeTrackRootColorMode, upgradeTrackSubColorMode = makeSharedColorModeDropdown(rootCategory, upgradeTrackCategory, "upgradeTrackColorMode", L["Text Color"], L["Customize upgrade track color for current season items"], PGV.db.upgradeTrack, UPGRADE_TRACK_COLOR_MODES)
        local upgradeTrackColorInit = makeColorSwatch(upgradeTrackCategory, "upgradeTrackColor", L["Choose a Color"], L["Customize upgrade track color for current season items"], PGV.db.upgradeTrack, "customColor")
        upgradeTrackColorInit:AddShownPredicate(function() return PGV.db.upgradeTrack.useCustomColor end)

        linkToShowToggle(upgradeTrackRootShow, upgradeTrackSubShow, upgradeTrackRootScale, upgradeTrackSubScale, upgradeTrackIsShown, notTimerunning)
        linkToShowToggle(upgradeTrackRootShow, upgradeTrackSubShow, upgradeTrackRootColorMode, upgradeTrackSubColorMode, upgradeTrackIsShown, notTimerunning)
        for _, initializer in ipairs({ upgradeTrackOutlineInit, upgradeTrackColorInit }) do
            initializer:SetParentInitializer(upgradeTrackSubShow, upgradeTrackIsShown)
            initializer:AddShownPredicate(notTimerunning)
        end

        rootLayout:AddInitializer(Settings.CreateElementInitializer("PGVOptionsSpacerTemplate", {}))
    end

    local gemsCategory = Settings.RegisterVerticalLayoutSubcategory(rootCategory, L["Gems"])
    local gemsIsShown = function() return PGV.db.gems.show end
    local gemsRootShow, gemsSubShow = makeSharedToggle(rootCategory, gemsCategory, "gemsShow", L["Gems"], L["Display gem and socket information for equipped items"],
        gemsIsShown, function(value) PGV.db.gems.show = value end)
    gemsRootShow:AddShownPredicate(notTimerunning)
    gemsSubShow:AddShownPredicate(notTimerunning)

    local gemsRootScale, gemsSubScale = makeSharedScaleSlider(rootCategory, gemsCategory, "gemsScale", L["Icon Scale"], L["Scale gem icon size relative to the default"], PGV.db.gems)
    local gemsShowMissingInit = makeToggle(gemsCategory, "gemsShowMissing", L["Show Missing Gems & Sockets"], L["Show when an item is missing gems or sockets"],
        function() return PGV.db.gems.showMissing end,
        function(value) PGV.db.gems.showMissing = value end)
    local gemsMaxLevelOnlyInit = makeToggle(gemsCategory, "gemsMaxLevelOnly", L["Only Show for Max Level"], L["Hide missing gem & socket info for characters under the level cap"],
        function() return PGV.db.gems.missingMaxLevelOnly end,
        function(value) PGV.db.gems.missingMaxLevelOnly = value end)

    linkToShowToggle(gemsRootShow, gemsSubShow, gemsRootScale, gemsSubScale, gemsIsShown, notTimerunning)
    for _, initializer in ipairs({ gemsShowMissingInit, gemsMaxLevelOnlyInit }) do
        initializer:SetParentInitializer(gemsSubShow, gemsIsShown)
        initializer:AddShownPredicate(notTimerunning)
    end
    gemsMaxLevelOnlyInit:SetParentInitializer(gemsShowMissingInit, function() return PGV.db.gems.showMissing end)

    rootLayout:AddInitializer(Settings.CreateElementInitializer("PGVOptionsSpacerTemplate", {}))

    local enchantsCategory = Settings.RegisterVerticalLayoutSubcategory(rootCategory, L["Enchants"])
    local enchantsIsShown = function() return PGV.db.enchants.show end
    local enchantsRootShow, enchantsSubShow = makeSharedToggle(rootCategory, enchantsCategory, "enchantsShow", L["Enchants"], L["Display enchant information for equipped items"],
        enchantsIsShown, function(value) PGV.db.enchants.show = value end)
    enchantsRootShow:AddShownPredicate(notTimerunning)
    enchantsSubShow:AddShownPredicate(notTimerunning)

    local enchantsRootScale, enchantsSubScale = makeSharedScaleSlider(rootCategory, enchantsCategory, "enchantsScale", L["Font Scale"], L["Scale enchant text size relative to the default"], PGV.db.enchants)
    local enchantsOutlineInit = makeOutlineDropdown(enchantsCategory, "enchantsOutline", L["Outline"], L["The outline style to add to enchant text"], PGV.db.enchants)
    local enchantsShowMissingInit = makeToggle(enchantsCategory, "enchantsShowMissing", L["Missing Enchant Indicator"], L["Show when an item is missing an enchant with a warning symbol"],
        function() return PGV.db.enchants.showMissing end,
        function(value) PGV.db.enchants.showMissing = value end)
    local enchantsMaxLevelOnlyInit = makeToggle(enchantsCategory, "enchantsMaxLevelOnly", L["Only Show for Max Level"], L["Hide missing enchant info for characters under the level cap"],
        function() return PGV.db.enchants.missingMaxLevelOnly end,
        function(value) PGV.db.enchants.missingMaxLevelOnly = value end)
    local enchantsShowTextButtonInit = makeToggle(enchantsCategory, "enchantsShowTextButton", L["Enchant Text Button"], L["Display a button to show or hide enchant text in the Character Info window"],
        function() return PGV.db.enchants.showTextButton end,
        function(value) PGV.db.enchants.showTextButton = value end)
    local enchantsRootUseCustomColor, enchantsSubUseCustomColor = makeSharedToggle(rootCategory, enchantsCategory, "enchantsUseCustomColor", L["Text Color"], L["Customize enchant text color"],
        function() return PGV.db.enchants.useCustomColor end,
        function(value) PGV.db.enchants.useCustomColor = value end)
    local enchantsColorInit = makeColorSwatch(enchantsCategory, "enchantsColor", L["Choose a Color"], L["Customize enchant text color"], PGV.db.enchants, "customColor")
    enchantsColorInit:AddShownPredicate(function() return PGV.db.enchants.useCustomColor end)

    linkToShowToggle(enchantsRootShow, enchantsSubShow, enchantsRootScale, enchantsSubScale, enchantsIsShown, notTimerunning)
    linkToShowToggle(enchantsRootShow, enchantsSubShow, enchantsRootUseCustomColor, enchantsSubUseCustomColor, enchantsIsShown, notTimerunning)
    for _, initializer in ipairs({ enchantsOutlineInit, enchantsShowMissingInit, enchantsShowTextButtonInit }) do
        initializer:SetParentInitializer(enchantsSubShow, enchantsIsShown)
        initializer:AddShownPredicate(notTimerunning)
    end
    enchantsMaxLevelOnlyInit:SetParentInitializer(enchantsShowMissingInit, function() return PGV.db.enchants.showMissing end)
    enchantsMaxLevelOnlyInit:AddShownPredicate(notTimerunning)
    enchantsColorInit:SetParentInitializer(enchantsSubShow, enchantsIsShown)
    enchantsColorInit:AddShownPredicate(notTimerunning)

    rootLayout:AddInitializer(Settings.CreateElementInitializer("PGVOptionsSpacerTemplate", {}))

    local durabilityCategory = Settings.RegisterVerticalLayoutSubcategory(rootCategory, L["Durability"])
    local durabilityIsShown = function() return PGV.db.durability.show end
    local durabilityRootShow, durabilitySubShow = makeSharedToggle(rootCategory, durabilityCategory, "durabilityShow", L["Durability"], L["Display durability percentages for equipped items"],
        durabilityIsShown, function(value) PGV.db.durability.show = value end)

    local durabilityRootScale, durabilitySubScale = makeSharedScaleSlider(rootCategory, durabilityCategory, "durabilityScale", L["Font Scale"], L["Scale durability text size relative to the default"], PGV.db.durability)
    local durabilityRootShowAsBar, durabilitySubShowAsBar = makeSharedToggle(rootCategory, durabilityCategory, "durabilityShowAsBar", L["Show Durability as Bar"], L["Display durability as a bar instead of text over gear icons"],
        function() return PGV.db.durability.showAsBar end,
        function(value) PGV.db.durability.showAsBar = value end)
    local durabilityHighInit = makeColorSwatch(durabilityCategory, "durabilityHigh", L["High"], L["High: above 50%"], PGV.db.durability, "colorHigh")
    local durabilityMediumInit = makeColorSwatch(durabilityCategory, "durabilityMedium", L["Medium"], L["Medium: 25% - 50%"], PGV.db.durability, "colorMedium")
    local durabilityLowInit = makeColorSwatch(durabilityCategory, "durabilityLow", L["Low"], L["Low: 25% or less"], PGV.db.durability, "colorLow")

    linkToShowToggle(durabilityRootShow, durabilitySubShow, durabilityRootScale, durabilitySubScale, durabilityIsShown)
    linkToShowToggle(durabilityRootShow, durabilitySubShow, durabilityRootShowAsBar, durabilitySubShowAsBar, durabilityIsShown)
    for _, initializer in ipairs({ durabilityHighInit, durabilityMediumInit, durabilityLowInit }) do
        initializer:SetParentInitializer(durabilitySubShow, durabilityIsShown)
    end

    rootLayout:AddInitializer(Settings.CreateElementInitializer("PGVOptionsSpacerTemplate", {}))

    local inspectCategory, inspectLayout = Settings.RegisterVerticalLayoutSubcategory(rootCategory, L["Inspect Window"])
    local inspectIsShown = function() return PGV.db.inspect.show end
    local _, inspectSubShow = makeSharedToggle(rootCategory, inspectCategory, "inspectShow", L["Inspect Window"], L["Displays information about equipped gear when inspecting another player"],
        inspectIsShown, function(value) PGV.db.inspect.show = value end)

    inspectLayout:AddInitializer(Settings.CreateElementInitializer("PGVOptionsDescriptionTemplate", { name = L["Choose which information should be displayed when inspecting another player."] }))
    inspectLayout:AddInitializer(Settings.CreateElementInitializer("PGVOptionsDescriptionTemplate", { name = L["Colors, size, and other display settings when inspecting a character will follow the same settings as the Character Info window."] }))
    inspectLayout:AddInitializer(Settings.CreateElementInitializer("PGVOptionsSpacerTemplate", {}))

    local inspectShowILvlInit = makeToggle(inspectCategory, "inspectShowILvl", L["Item Level"], L["Display item levels for equipped items"],
        function() return PGV.db.inspect.showILvl end,
        function(value) PGV.db.inspect.showILvl = value end)
    local inspectShowUpgradeTrackInit
    if not PGV.isCamelot then
        inspectShowUpgradeTrackInit = makeToggle(inspectCategory, "inspectShowUpgradeTrack", L["Upgrade Track"], L["Display upgrade track and progress for equipped items"],
            function() return PGV.db.inspect.showUpgradeTrack end,
            function(value) PGV.db.inspect.showUpgradeTrack = value end)
    end
    local inspectShowGemsInit = makeToggle(inspectCategory, "inspectShowGems", L["Gems"], L["Display gem and socket information for equipped items"],
        function() return PGV.db.inspect.showGems end,
        function(value) PGV.db.inspect.showGems = value end)
    local inspectShowEnchantsInit = makeToggle(inspectCategory, "inspectShowEnchants", L["Enchants"], L["Display enchant information for equipped items"],
        function() return PGV.db.inspect.showEnchants end,
        function(value) PGV.db.inspect.showEnchants = value end)
    local inspectShowEmbellishmentsInit
    if not PGV.isCamelot then
        inspectShowEmbellishmentsInit = makeToggle(inspectCategory, "inspectShowEmbellishments", L["Show Embellishments"], L["Show a green star in the top-left corner of embellished equipment"],
            function() return PGV.db.inspect.showEmbellishments end,
            function(value) PGV.db.inspect.showEmbellishments = value end)
    end

    inspectLayout:AddInitializer(Settings.CreateElementInitializer("PGVOptionsSpacerTemplate", {}))

    local inspectShowAvgILvlInit = makeToggle(inspectCategory, "inspectShowAvgILvl", L["Average Item Level"], L["Display average item level in the character's class color"],
        function() return PGV.db.inspect.showAvgILvl end,
        function(value) PGV.db.inspect.showAvgILvl = value end)
    local inspectIncludeAvgLabelInit = makeToggle(inspectCategory, "inspectIncludeAvgLabel", L["Include \"Avg\" Label"], L["Adds the text \"Avg: \" before the average item level."].."\n\n"..L["This can help easily identify the average item level when there is a lot of information shown in the Inspect window."],
        function() return PGV.db.inspect.includeAvgLabel end,
        function(value) PGV.db.inspect.includeAvgLabel = value end)
    inspectIncludeAvgLabelInit:SetParentInitializer(inspectShowAvgILvlInit, function() return PGV.db.inspect.show and PGV.db.inspect.showAvgILvl end)

    for _, initializer in pairs({ inspectShowILvlInit, inspectShowUpgradeTrackInit, inspectShowGemsInit, inspectShowEnchantsInit, inspectShowEmbellishmentsInit, inspectShowAvgILvlInit }) do
        initializer:SetParentInitializer(inspectSubShow, inspectIsShown)
    end

    if not PGV.isCamelot then
        rootLayout:AddInitializer(Settings.CreateElementInitializer("PGVOptionsSpacerTemplate", {}))

        local characterStatsCategory, characterStatsLayout = Settings.RegisterVerticalLayoutSubcategory(rootCategory, L["Character Stats"])
        local showDecimalStatsInit = makeToggle(characterStatsCategory, "showDecimalStats", L["Show Decimals for Stats"], L["Show your character's stats with decimal places"],
            function() return PGV.db.characterStats.showDecimals end,
            function(value)
                PGV.db.characterStats.showDecimals = value
                PaperDollFrame_UpdateStats()
            end)
        local decimalStatsPlacesInit = makeSlider(characterStatsCategory, "decimalStatsPlaces", L["Decimal Precision"], L["Number of decimal places to show for character's stats"], 1, 3, 1,
            function() return PGV.db.characterStats.decimalPlaces end,
            function(value)
                PGV.db.characterStats.decimalPlaces = value
                PaperDollFrame_UpdateStats()
            end)
        decimalStatsPlacesInit:SetParentInitializer(showDecimalStatsInit, function() return PGV.db.characterStats.showDecimals end)

        characterStatsLayout:AddInitializer(Settings.CreateElementInitializer("PGVOptionsDescriptionTemplate", { name = L["Customize secondary & tertiary stat order in the Character Info window by specialization"] }))
        characterStatsLayout:AddInitializer(Settings.CreateElementInitializer("PGVOptionsSpacerTemplate", {}))

        local specSetting = Settings.RegisterProxySetting(characterStatsCategory, "characterStatsSpec", Settings.VarType.Number, L["Specialization"], select(1, PGV.GetCharacterCurrentSpecIDAndRole()) or 0,
            function() return select(1, PGV.GetSpecAndRoleForSelectedCharacterStatsOption()) end,
            function(value)
                PGV.db.characterStats.lastSelectedSpecID = value
                PGV.RefreshStatOrderList()
            end)

        local function getSpecOptions()
            local container = Settings.CreateControlTextContainer()
            for classID = 1, 20 do
                local classInfo = C_CreatureInfo.GetClassInfo(classID)
                if classInfo then
                    for specIndex = 1, C_SpecializationInfo.GetNumSpecializationsForClassID(classID) do
                        local specID, specName = C_SpecializationInfo.GetSpecializationInfo(specIndex, false, false, nil, nil, nil, classID)
                        if specID and specName then
                            -- Cant show spec icons anymore in Settings API dropdown button, so gotta add each class name to the end of spec name instead
                            container:Add(specID, specName.." "..classInfo.className)
                        end
                    end
                end
            end
            return container:GetData()
        end
        local specDropdownInit = Settings.CreateDropdown(characterStatsCategory, specSetting, getSpecOptions, L["Specialization"])

        characterStatsLayout:AddInitializer(Settings.CreateElementInitializer("PGVStatOrderListTemplate", {}))
        local resetOrderInit = CreateSettingsButtonInitializer("", L["Reset"], function(button)
            local specID = PGV.GetSpecAndRoleForSelectedCharacterStatsOption()
            PGV.InitializeCustomSpecStatOrderDB(specID, true)
            PGV.RefreshStatOrderList()
            button:GetParent():EvaluateState()
        end, nil, false)
        resetOrderInit:SetParentInitializer(specDropdownInit, function()
            local specID = PGV.GetSpecAndRoleForSelectedCharacterStatsOption()
            return not PGV.IsStatOrderAtDefault(specID)
        end)
        characterStatsLayout:AddInitializer(resetOrderInit)
    end

    buildCreditsCategory(rootCategory)
end

PGV.RegisterEvent("ADDON_LOADED", function(loadedAddon)
    if loadedAddon ~= addonName then return end
    buildOptions()
end)
