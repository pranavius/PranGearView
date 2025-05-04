local addonName, AddOn = ...
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

local ColorText = AddOn.ColorText

local function GetSizedIconText(icon, dim)
    local size = 15
    if dim and type(dim) == "number" then
        size = dim
    end
    return "|A:"..icon..":"..size..":"..size.."|a"
end

-- { name, race, class, color }
local contributors = {}

local specialThanks = {
    { name = "Tusk", race = AddOn.RaceIcons.Pandaren.Male, class = AddOn.ClassIcons.Monk, color = AddOn.HexColorPresets.Monk },
    { name = "Beo", race = AddOn.RaceIcons.Pandaren.Female, class = AddOn.ClassIcons.DemonHunter, color = AddOn.HexColorPresets.DemonHunter },
    { name = "Knifermonkey", race = AddOn.RaceIcons.Undead.Male, class = AddOn.ClassIcons.Warlock, color = AddOn.HexColorPresets.Warlock },
    { name = "Jery", race = AddOn.RaceIcons.BloodElf.Male, class = AddOn.ClassIcons.Mage, color = AddOn.HexColorPresets.Mage },
    { name = "Emraliya", race = AddOn.RaceIcons.HighmountainTauren.Female, class = AddOn.ClassIcons.DeathKnight, color = AddOn.HexColorPresets.DeathKnight },
    { name = "Aliakin", race = AddOn.RaceIcons.Human.Male, class = AddOn.ClassIcons.Mage, color = AddOn.HexColorPresets.Mage },
    { name = "Grok", race = AddOn.RaceIcons.Orc.Male, class = AddOn.ClassIcons.Warrior, color = AddOn.HexColorPresets.Warrior }
}

function AddOn.BuildCreditsGroup()
    local credits = {
        type = "group",
        name = L["Credits"],
        order = 999,
        args = {
            title = {
                type = "description",
                name = ColorText(addonName.." "..L["Credits"], "Info"),
                fontSize = "large",
                order = 1
            },
            spacer = AddOn.CreateOptionsSpacer(2),
            author = {
                type = "description",
                name = ColorText("Created by "..GetSizedIconText(AddOn.RaceIcons.BloodElf.Male)..GetSizedIconText(AddOn.ClassIcons.Monk).." Pranavius", "Heirloom"),
                fontSize = "medium",
                order = 3
            },
            spacer2 = AddOn.CreateOptionsSpacer(4),
            contributorsTitle = {
                type = "description",
                name = ColorText(L["Contributors"], "Info"),
                fontSize = "large",
                order = 5
            },
        }
    }

    for idx, contributor in ipairs(contributors) do
        credits.args["contributor"..idx] = {
            type = "description",
            name = GetSizedIconText(contributor.race)..GetSizedIconText(contributor.class).." "..contributor.name,
            fontSize = "medium",
            order = credits.args.contributorsTitle.order + idx
        }
    end

    -- Calculate the size of the args table
    local argsSize = 0
    for _ in pairs(credits.args) do
        argsSize = argsSize + 1
    end

    credits.args.contributionMessage = {
        type = "description",
        name = L["If you would like to contribute to development, you can find the repository on GitHub."].."\n"..L["Please follow the development guidelines outlined in the README document."],
        order = argsSize + 1
    }
    credits.args.spacer4 = AddOn.CreateOptionsSpacer(argsSize + 2)
    credits.args.specialThanksTitle = {
        type = "description",
        name = ColorText(L["Special Thanks"], "Info"),
        fontSize = "large",
        order = argsSize + 3
    }

    for idx, thanks in ipairs(specialThanks) do
        credits.args["specialThanks"..idx] = {
            type = "description",
            fontSize = "medium",
            name = GetSizedIconText(thanks.race)..GetSizedIconText(thanks.class).." "..ColorText(thanks.name, thanks.color),
            order = credits.args.specialThanksTitle.order + idx
        }
    end

    -- Recalculate the size of the args table
    argsSize = 0
    for _ in pairs(credits.args) do
        argsSize = argsSize + 1
    end

    credits.args.spacer6 = AddOn.CreateOptionsSpacer(argsSize + 1)
    credits.args.connectTitle = {
        type = "description",
        name = ColorText(L["Connect"], "Info"),
        fontSize = "large",
        order = argsSize + 2
    }
    credits.args.spacer7 = AddOn.CreateOptionsSpacer(argsSize + 3)
    credits.args.twitter = {
        type = "description",
        name = "|TInterface\\AddOns\\PranGearView\\Media\\X-logo:20:20:0:5|t   "..ColorText("@PranaviusWoW", "Legendary"),
        order = argsSize + 4,
    }
    credits.args.github = {
        type = "description",
        name = "|TInterface\\AddOns\\PranGearView\\Media\\Github-logo:20:20:0:5|t   "..ColorText("Pranavius", "Legendary"),
        order = argsSize + 5,
    }

    return credits
end