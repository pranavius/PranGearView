local addonName, PGV = ...
local L = PGV.L

PGVOptionsDescriptionMixin = {}
function PGVOptionsDescriptionMixin:Init(initializer)
    self.Text:SetText(initializer:GetName())
end

local function RefreshSlots()
    if PGV.UpdateAllSlots then
        PGV.UpdateAllSlots()
    end
    if PGV.UpdateInspectedGearInfo and InspectPaperDollFrame and InspectPaperDollFrame:IsVisible() then
        PGV.UpdateInspectedGearInfo(PGV.inspectedUnitGUID, true)
    end
end

local function MakeToggle(category, variable, name, tooltip, getValue, setValue)
    local setting = Settings.RegisterProxySetting(category, variable, Settings.VarType.Boolean, name, false, getValue, function(value)
        setValue(value)
        RefreshSlots()
    end)
    return Settings.CreateCheckbox(category, setting, tooltip)
end

local function MakeSharedToggle(rootCategory, subCategory, variable, name, tooltip, getValue, setValue)
    local setting = Settings.RegisterProxySetting(rootCategory, variable, Settings.VarType.Boolean, name, false, getValue, function(value)
        setValue(value)
        RefreshSlots()
    end)
    local rootInit = Settings.CreateCheckbox(rootCategory, setting, tooltip)
    local subInit = Settings.CreateCheckbox(subCategory, setting, tooltip)
    return rootInit, subInit
end

local function ScalePercentFormatter(value)
    return FormatPercentage(value, true)
end

local function MakeSlider(category, variable, name, tooltip, minValue, maxValue, step, getValue, setValue)
    local setting = Settings.RegisterProxySetting(category, variable, Settings.VarType.Number, name, minValue, getValue, function(value)
        setValue(value)
        RefreshSlots()
    end)
    local options = Settings.CreateSliderOptions(minValue, maxValue, step)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
    return Settings.CreateSlider(category, setting, options, tooltip)
end

local function MakeSharedScaleSlider(rootCategory, subCategory, variable, name, tooltip, dbTable)
    local setting = Settings.RegisterProxySetting(rootCategory, variable, Settings.VarType.Number, name, 1,
        function() return dbTable.scale end,
        function(value)
            dbTable.scale = value
            RefreshSlots()
        end)
    local options = Settings.CreateSliderOptions(0.01, 2, 0.01)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, ScalePercentFormatter)
    local rootInit = Settings.CreateSlider(rootCategory, setting, options, tooltip)
    local subInit = Settings.CreateSlider(subCategory, setting, options, tooltip)
    return rootInit, subInit
end

local function MakeOutlineDropdown(category, variable, name, tooltip, dbTable)
    local setting = Settings.RegisterProxySetting(category, variable, Settings.VarType.String, name, "",
        function() return dbTable.outline end,
        function(value)
            dbTable.outline = value
            RefreshSlots()
        end)
    local function GetOptions()
        local container = Settings.CreateControlTextContainer()
        for _, option in ipairs(PGV.OutlineOptions) do
            container:Add(option.value, option.key)
        end
        return container:GetData()
    end
    return Settings.CreateDropdown(category, setting, GetOptions, tooltip)
end

local function MakeColorSwatch(category, variable, name, tooltip, dbTable, key)
    local setting = Settings.RegisterProxySetting(category, variable, Settings.VarType.String, name, "FF"..PGV.HexColorPresets.Priest,
        function() return "FF"..dbTable[key] end,
        function(value)
            dbTable[key] = value:sub(-6)
            RefreshSlots()
        end)
    return Settings.CreateColorSwatch(category, setting, tooltip)
end

local function MakeColorModeDropdown(category, variable, name, tooltip, dbTable, modes)
    local function GetCurrentMode()
        for _, mode in ipairs(modes) do
            if dbTable[mode.dbKey] then
                return mode.value
            end
        end
        return modes[1].value
    end
    local setting = Settings.RegisterProxySetting(category, variable, Settings.VarType.String, name, modes[1].value, GetCurrentMode, function(value)
        for _, mode in ipairs(modes) do
            if mode.dbKey then
                dbTable[mode.dbKey] = (mode.value == value)
            end
        end
        RefreshSlots()
    end)
    local function GetOptions()
        local container = Settings.CreateControlTextContainer()
        for _, mode in ipairs(modes) do
            container:Add(mode.value, mode.label)
        end
        return container:GetData()
    end
    return Settings.CreateDropdown(category, setting, GetOptions, tooltip)
end

local function MakeSharedColorModeDropdown(rootCategory, subCategory, variable, name, tooltip, dbTable, modes)
    local function GetCurrentMode()
        for _, mode in ipairs(modes) do
            if dbTable[mode.dbKey] then
                return mode.value
            end
        end
        return modes[1].value
    end
    local setting = Settings.RegisterProxySetting(rootCategory, variable, Settings.VarType.String, name, modes[1].value, GetCurrentMode, function(value)
        for _, mode in ipairs(modes) do
            if mode.dbKey then
                dbTable[mode.dbKey] = (mode.value == value)
            end
        end
        RefreshSlots()
    end)
    local function GetOptions()
        local container = Settings.CreateControlTextContainer()
        for _, mode in ipairs(modes) do
            container:Add(mode.value, mode.label)
        end
        return container:GetData()
    end
    local rootInit = Settings.CreateDropdown(rootCategory, setting, GetOptions, tooltip)
    local subInit = Settings.CreateDropdown(subCategory, setting, GetOptions, tooltip)
    return rootInit, subInit
end

local function LinkToShowToggle(rootShowInit, subShowInit, rootInit, subInit, isShown, shownPredicate)
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

local function BuildOptions()
    local rootCategory, rootLayout = Settings.RegisterVerticalLayoutCategory("PranGearView (rework)")
    Settings.RegisterAddOnCategory(rootCategory)
    PGV.categoryID = rootCategory:GetID()

    MakeToggle(rootCategory, "showMinimap", L["Show Minimap Icon"], L["Show an icon on the minimap to open the AddOn settings"],
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
    MakeToggle(rootCategory, "increaseCharacterInfoSize", L["Larger Character Info Window"], L["Increase the size of the Character Info window"].."\n\n"..L["This can help reduce text overlap with the character model and make reading text easier."],
        function() return PGV.db.general.increaseCharacterInfoSize end,
        function(value)
            PGV.db.general.increaseCharacterInfoSize = value
            PGV.AdjustCharacterInfoWindowSize()
        end)
    MakeToggle(rootCategory, "showEmbellishments", L["Show Embellishments"], L["Show a green star in the top-left corner of embellished equipment"],
        function() return PGV.db.general.showEmbellishments end,
        function(value) PGV.db.general.showEmbellishments = value end)
    local showCharILvlDecimalInit = MakeToggle(rootCategory, "showCharacteriLvlDecimal", L["Show Decimals for Equipped Item Level"], L["Show your character's average equipped item level with decimal places"],
        function() return PGV.db.general.showCharacteriLvlDecimal end,
        function(value)
            PGV.db.general.showCharacteriLvlDecimal = value
            PaperDollFrame_UpdateStats()
        end)
    local decimalPlacesInit = MakeSlider(rootCategory, "decimalPlacesForCharacteriLvl", L["Decimal Precision"], L["Number of decimal places to show for character's equipped item level"], 1, 3, 1,
        function() return PGV.db.general.decimalPlacesForCharacteriLvl end,
        function(value)
            PGV.db.general.decimalPlacesForCharacteriLvl = value
            PaperDollFrame_UpdateStats()
        end)
    decimalPlacesInit:SetParentInitializer(showCharILvlDecimalInit, function() return PGV.db.general.showCharacteriLvlDecimal end)
    decimalPlacesInit:AddShownPredicate(function() return PGV.db.general.showCharacteriLvlDecimal end)
    MakeToggle(rootCategory, "hideShirtTabardInfo", L["Hide Shirt & Tabard Info"], L["Hide information for equipped shirt & tabard"],
        function() return PGV.db.general.hideShirtTabardInfo end,
        function(value) PGV.db.general.hideShirtTabardInfo = value end)
    MakeToggle(rootCategory, "debugMode", L["Debug Mode"], L["Display debugging messages in the default chat window"].."\n\n"..PGV.ColorText(L["You should never need to enable this"], "DeathKnight"),
        function() return PGV.db.general.debug end,
        function(value) PGV.db.general.debug = value end)

    rootLayout:AddInitializer(Settings.CreateElementInitializer("PGVOptionsSpacerTemplate", {}))

    rootLayout:AddInitializer(Settings.CreateElementInitializer("PGVOptionsDescriptionTemplate", { name = L["Choose information to show in the Character Info window"] }))
    rootLayout:AddInitializer(Settings.CreateElementInitializer("PGVOptionsDescriptionTemplate", { name = L["Open a specific category for additional customization options"] }))

    local itemLevelCategory = Settings.RegisterVerticalLayoutSubcategory(rootCategory, L["Item Level"])
    local itemLevelIsShown = function() return PGV.db.itemLevel.show end
    local itemLevelRootShow, itemLevelSubShow = MakeSharedToggle(rootCategory, itemLevelCategory, "itemLevelShow", L["Item Level"], L["Display item levels for equipped items"],
        itemLevelIsShown, function(value) PGV.db.itemLevel.show = value end)

    local itemLevelRootScale, itemLevelSubScale = MakeSharedScaleSlider(rootCategory, itemLevelCategory, "itemLevelScale", L["Font Scale"], L["Scale item level text size relative to the default"], PGV.db.itemLevel)
    local itemLevelOutlineInit = MakeOutlineDropdown(itemLevelCategory, "itemLevelOutline", L["Outline"], L["The outline style to add to item level text"], PGV.db.itemLevel)
    local itemLevelOnItemInit = MakeToggle(itemLevelCategory, "itemLevelOnItem", L["Alternate Item Level Placement"], L["Display item levels on top of equipment icons"],
        function() return PGV.db.itemLevel.onItem end,
        function(value) PGV.db.itemLevel.onItem = value end)

    local ITEM_LEVEL_COLOR_MODES = {
        { value = "quality", label = L["Use Item Quality Color"], dbKey = "useQualityColor" },
        { value = "class", label = L["Use Class Color"], dbKey = "useClassColor" },
        { value = "gradient", label = L["Use Item Level Gradient"], dbKey = "useGradientColors" },
        { value = "custom", label = L["Use Custom Color"], dbKey = "useCustomColor" },
    }
    local itemLevelRootColorMode, itemLevelSubColorMode = MakeSharedColorModeDropdown(rootCategory, itemLevelCategory, "itemLevelColorMode", L["Text Color"], L["Customize item level color"], PGV.db.itemLevel, ITEM_LEVEL_COLOR_MODES)
    local itemLevelColorInit = MakeColorSwatch(itemLevelCategory, "itemLevelColor", L["Choose a Color"], L["Customize item level color"], PGV.db.itemLevel, "customColor")
    itemLevelColorInit:AddShownPredicate(function() return PGV.db.itemLevel.useCustomColor end)

    LinkToShowToggle(itemLevelRootShow, itemLevelSubShow, itemLevelRootScale, itemLevelSubScale, itemLevelIsShown)
    LinkToShowToggle(itemLevelRootShow, itemLevelSubShow, itemLevelRootColorMode, itemLevelSubColorMode, itemLevelIsShown)
    for _, initializer in ipairs({ itemLevelOutlineInit, itemLevelOnItemInit, itemLevelColorInit }) do
        initializer:SetParentInitializer(itemLevelSubShow, itemLevelIsShown)
    end

    rootLayout:AddInitializer(Settings.CreateElementInitializer("PGVOptionsSpacerTemplate", {}))

    local upgradeTrackCategory = Settings.RegisterVerticalLayoutSubcategory(rootCategory, L["Upgrade Track"])
    local upgradeTrackIsShown = function() return PGV.db.upgradeTrack.show end
    local notTimerunning = function() return not PGV.IsTimerunningCharacter() end
    local upgradeTrackRootShow, upgradeTrackSubShow = MakeSharedToggle(rootCategory, upgradeTrackCategory, "upgradeTrackShow", L["Upgrade Track"], L["Display upgrade track and progress for equipped items"],
        upgradeTrackIsShown, function(value) PGV.db.upgradeTrack.show = value end)
    upgradeTrackRootShow:AddShownPredicate(notTimerunning)
    upgradeTrackSubShow:AddShownPredicate(notTimerunning)

    local upgradeTrackRootScale, upgradeTrackSubScale = MakeSharedScaleSlider(rootCategory, upgradeTrackCategory, "upgradeTrackScale", L["Font Scale"], L["Scale upgrade track text size relative to the default"], PGV.db.upgradeTrack)
    local upgradeTrackOutlineInit = MakeOutlineDropdown(upgradeTrackCategory, "upgradeTrackOutline", L["Outline"], L["The outline style to add to upgrade track text"], PGV.db.upgradeTrack)

    local UPGRADE_TRACK_COLOR_MODES = {
        { value = "quality", label = L["Use Item Quality Color"] },
        { value = "qualityScale", label = L["Use Quality Color Scale"], dbKey = "useQualityScaleColors" },
        { value = "custom", label = L["Use Custom Color"], dbKey = "useCustomColor" },
    }
    local upgradeTrackRootColorMode, upgradeTrackSubColorMode = MakeSharedColorModeDropdown(rootCategory, upgradeTrackCategory, "upgradeTrackColorMode", L["Text Color"], L["Customize upgrade track color for current season items"], PGV.db.upgradeTrack, UPGRADE_TRACK_COLOR_MODES)
    local upgradeTrackColorInit = MakeColorSwatch(upgradeTrackCategory, "upgradeTrackColor", L["Choose a Color"], L["Customize upgrade track color for current season items"], PGV.db.upgradeTrack, "customColor")
    upgradeTrackColorInit:AddShownPredicate(function() return PGV.db.upgradeTrack.useCustomColor end)

    LinkToShowToggle(upgradeTrackRootShow, upgradeTrackSubShow, upgradeTrackRootScale, upgradeTrackSubScale, upgradeTrackIsShown, notTimerunning)
    LinkToShowToggle(upgradeTrackRootShow, upgradeTrackSubShow, upgradeTrackRootColorMode, upgradeTrackSubColorMode, upgradeTrackIsShown, notTimerunning)
    for _, initializer in ipairs({ upgradeTrackOutlineInit, upgradeTrackColorInit }) do
        initializer:SetParentInitializer(upgradeTrackSubShow, upgradeTrackIsShown)
        initializer:AddShownPredicate(notTimerunning)
    end

    rootLayout:AddInitializer(Settings.CreateElementInitializer("PGVOptionsSpacerTemplate", {}))

    local gemsCategory = Settings.RegisterVerticalLayoutSubcategory(rootCategory, L["Gems"])
    local gemsIsShown = function() return PGV.db.gems.show end
    local gemsRootShow, gemsSubShow = MakeSharedToggle(rootCategory, gemsCategory, "gemsShow", L["Gems"], L["Display gem and socket information for equipped items"],
        gemsIsShown, function(value) PGV.db.gems.show = value end)
    gemsRootShow:AddShownPredicate(notTimerunning)
    gemsSubShow:AddShownPredicate(notTimerunning)

    local gemsRootScale, gemsSubScale = MakeSharedScaleSlider(rootCategory, gemsCategory, "gemsScale", L["Icon Scale"], L["Scale gem icon size relative to the default"], PGV.db.gems)
    local gemsShowMissingInit = MakeToggle(gemsCategory, "gemsShowMissing", L["Show Missing Gems & Sockets"], L["Show when an item is missing gems or sockets"],
        function() return PGV.db.gems.showMissing end,
        function(value) PGV.db.gems.showMissing = value end)
    local gemsMaxLevelOnlyInit = MakeToggle(gemsCategory, "gemsMaxLevelOnly", L["Only Show for Max Level"], L["Hide missing gem & socket info for characters under the level cap"],
        function() return PGV.db.gems.missingMaxLevelOnly end,
        function(value) PGV.db.gems.missingMaxLevelOnly = value end)

    LinkToShowToggle(gemsRootShow, gemsSubShow, gemsRootScale, gemsSubScale, gemsIsShown, notTimerunning)
    for _, initializer in ipairs({ gemsShowMissingInit, gemsMaxLevelOnlyInit }) do
        initializer:SetParentInitializer(gemsSubShow, gemsIsShown)
        initializer:AddShownPredicate(notTimerunning)
    end
    gemsMaxLevelOnlyInit:SetParentInitializer(gemsShowMissingInit, function() return PGV.db.gems.showMissing end)

    rootLayout:AddInitializer(Settings.CreateElementInitializer("PGVOptionsSpacerTemplate", {}))

    local enchantsCategory = Settings.RegisterVerticalLayoutSubcategory(rootCategory, L["Enchants"])
    local enchantsIsShown = function() return PGV.db.enchants.show end
    local enchantsRootShow, enchantsSubShow = MakeSharedToggle(rootCategory, enchantsCategory, "enchantsShow", L["Enchants"], L["Display enchant information for equipped items"],
        enchantsIsShown, function(value) PGV.db.enchants.show = value end)
    enchantsRootShow:AddShownPredicate(notTimerunning)
    enchantsSubShow:AddShownPredicate(notTimerunning)

    local enchantsRootScale, enchantsSubScale = MakeSharedScaleSlider(rootCategory, enchantsCategory, "enchantsScale", L["Font Scale"], L["Scale enchant text size relative to the default"], PGV.db.enchants)
    local enchantsOutlineInit = MakeOutlineDropdown(enchantsCategory, "enchantsOutline", L["Outline"], L["The outline style to add to enchant text"], PGV.db.enchants)
    local enchantsShowMissingInit = MakeToggle(enchantsCategory, "enchantsShowMissing", L["Missing Enchant Indicator"], L["Show when an item is missing an enchant with a warning symbol"],
        function() return PGV.db.enchants.showMissing end,
        function(value) PGV.db.enchants.showMissing = value end)
    local enchantsMaxLevelOnlyInit = MakeToggle(enchantsCategory, "enchantsMaxLevelOnly", L["Only Show for Max Level"], L["Hide missing enchant info for characters under the level cap"],
        function() return PGV.db.enchants.missingMaxLevelOnly end,
        function(value) PGV.db.enchants.missingMaxLevelOnly = value end)
    local enchantsRootUseCustomColor, enchantsSubUseCustomColor = MakeSharedToggle(rootCategory, enchantsCategory, "enchantsUseCustomColor", L["Text Color"], L["Customize enchant text color"],
        function() return PGV.db.enchants.useCustomColor end,
        function(value) PGV.db.enchants.useCustomColor = value end)
    local enchantsColorInit = MakeColorSwatch(enchantsCategory, "enchantsColor", L["Choose a Color"], L["Customize enchant text color"], PGV.db.enchants, "customColor")
    enchantsColorInit:AddShownPredicate(function() return PGV.db.enchants.useCustomColor end)

    LinkToShowToggle(enchantsRootShow, enchantsSubShow, enchantsRootScale, enchantsSubScale, enchantsIsShown, notTimerunning)
    LinkToShowToggle(enchantsRootShow, enchantsSubShow, enchantsRootUseCustomColor, enchantsSubUseCustomColor, enchantsIsShown, notTimerunning)
    for _, initializer in ipairs({ enchantsOutlineInit, enchantsShowMissingInit }) do
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
    local durabilityRootShow, durabilitySubShow = MakeSharedToggle(rootCategory, durabilityCategory, "durabilityShow", L["Durability"], L["Display durability percentages for equipped items"],
        durabilityIsShown, function(value) PGV.db.durability.show = value end)

    local durabilityRootScale, durabilitySubScale = MakeSharedScaleSlider(rootCategory, durabilityCategory, "durabilityScale", L["Font Scale"], L["Scale durability text size relative to the default"], PGV.db.durability)
    local durabilityRootShowAsBar, durabilitySubShowAsBar = MakeSharedToggle(rootCategory, durabilityCategory, "durabilityShowAsBar", L["Show Durability as Bar"], L["Display durability as a bar instead of text over gear icons"],
        function() return PGV.db.durability.showAsBar end,
        function(value) PGV.db.durability.showAsBar = value end)
    local durabilityHighInit = MakeColorSwatch(durabilityCategory, "durabilityHigh", L["High"], L["High: above 50%"], PGV.db.durability, "colorHigh")
    local durabilityMediumInit = MakeColorSwatch(durabilityCategory, "durabilityMedium", L["Medium"], L["Medium: 25% - 50%"], PGV.db.durability, "colorMedium")
    local durabilityLowInit = MakeColorSwatch(durabilityCategory, "durabilityLow", L["Low"], L["Low: 25% or less"], PGV.db.durability, "colorLow")

    LinkToShowToggle(durabilityRootShow, durabilitySubShow, durabilityRootScale, durabilitySubScale, durabilityIsShown)
    LinkToShowToggle(durabilityRootShow, durabilitySubShow, durabilityRootShowAsBar, durabilitySubShowAsBar, durabilityIsShown)
    for _, initializer in ipairs({ durabilityHighInit, durabilityMediumInit, durabilityLowInit }) do
        initializer:SetParentInitializer(durabilitySubShow, durabilityIsShown)
    end

    rootLayout:AddInitializer(Settings.CreateElementInitializer("PGVOptionsSpacerTemplate", {}))

    local inspectCategory, inspectLayout = Settings.RegisterVerticalLayoutSubcategory(rootCategory, L["Inspect Window"])
    local inspectIsShown = function() return PGV.db.inspect.show end
    local _, inspectSubShow = MakeSharedToggle(rootCategory, inspectCategory, "inspectShow", L["Inspect Window"], L["Displays information about equipped gear when inspecting another player"],
        inspectIsShown, function(value) PGV.db.inspect.show = value end)

    inspectLayout:AddInitializer(Settings.CreateElementInitializer("PGVOptionsDescriptionTemplate", { name = L["Choose which information should be displayed when inspecting another player."] }))
    inspectLayout:AddInitializer(Settings.CreateElementInitializer("PGVOptionsDescriptionTemplate", { name = L["Colors, size, and other display settings when inspecting a character will follow the same settings as the Character Info window."] }))

    local inspectShowILvlInit = MakeToggle(inspectCategory, "inspectShowILvl", L["Item Level"], L["Display item levels for equipped items"],
        function() return PGV.db.inspect.showILvl end,
        function(value) PGV.db.inspect.showILvl = value end)
    local inspectShowUpgradeTrackInit = MakeToggle(inspectCategory, "inspectShowUpgradeTrack", L["Upgrade Track"], L["Display upgrade track and progress for equipped items"],
        function() return PGV.db.inspect.showUpgradeTrack end,
        function(value) PGV.db.inspect.showUpgradeTrack = value end)
    local inspectShowGemsInit = MakeToggle(inspectCategory, "inspectShowGems", L["Gems"], L["Display gem and socket information for equipped items"],
        function() return PGV.db.inspect.showGems end,
        function(value) PGV.db.inspect.showGems = value end)
    local inspectShowEnchantsInit = MakeToggle(inspectCategory, "inspectShowEnchants", L["Enchants"], L["Display enchant information for equipped items"],
        function() return PGV.db.inspect.showEnchants end,
        function(value) PGV.db.inspect.showEnchants = value end)
    local inspectShowEmbellishmentsInit = MakeToggle(inspectCategory, "inspectShowEmbellishments", L["Show Embellishments"], L["Show a green star in the top-left corner of embellished equipment"],
        function() return PGV.db.inspect.showEmbellishments end,
        function(value) PGV.db.inspect.showEmbellishments = value end)

    inspectLayout:AddInitializer(Settings.CreateElementInitializer("PGVOptionsSpacerTemplate", {}))

    local inspectShowAvgILvlInit = MakeToggle(inspectCategory, "inspectShowAvgILvl", L["Average Item Level"], L["Display average item level in the character's class color"],
        function() return PGV.db.inspect.showAvgILvl end,
        function(value) PGV.db.inspect.showAvgILvl = value end)
    local inspectIncludeAvgLabelInit = MakeToggle(inspectCategory, "inspectIncludeAvgLabel", L["Include \"Avg\" Label"], L["Adds the text \"Avg: \" before the average item level."].."\n\n"..L["This can help easily identify the average item level when there is a lot of information shown in the Inspect window."],
        function() return PGV.db.inspect.includeAvgLabel end,
        function(value) PGV.db.inspect.includeAvgLabel = value end)
    inspectIncludeAvgLabelInit:SetParentInitializer(inspectShowAvgILvlInit, function() return PGV.db.inspect.show and PGV.db.inspect.showAvgILvl end)

    for _, initializer in ipairs({ inspectShowILvlInit, inspectShowUpgradeTrackInit, inspectShowGemsInit, inspectShowEnchantsInit, inspectShowEmbellishmentsInit, inspectShowAvgILvlInit }) do
        initializer:SetParentInitializer(inspectSubShow, inspectIsShown)
    end
end

PGV.RegisterEvent("ADDON_LOADED", function(loadedAddon)
    if loadedAddon ~= addonName then return end
    BuildOptions()
end)
