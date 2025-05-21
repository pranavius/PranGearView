local addonName, AddOn = ...
---@class PranGearView
AddOn = LibStub("AceAddon-3.0"):GetAddon(addonName)
local L = LibStub("AceLocale-3.0"):GetLocale(addonName, true)

local ColorText = AddOn.ColorText

-- { name, race, class, color }
local contributors = {
    { name = "ZamestoTV", race = AddOn.RaceIcons.NightElf.Male, class = AddOn.ClassIcons.Druid, color = AddOn.HexColorPresets.Druid },
    { name = "Lirfdam", race = AddOn.RaceIcons.Nightborne.Female, class = AddOn.ClassIcons.Mage, color = AddOn.HexColorPresets.Mage }
}

local specialThanks = {
    { name = "Tusk", race = AddOn.RaceIcons.Pandaren.Male, class = AddOn.ClassIcons.Monk, color = AddOn.HexColorPresets.Monk },
    { name = "Beo", race = AddOn.RaceIcons.Pandaren.Female, class = AddOn.ClassIcons.DemonHunter, color = AddOn.HexColorPresets.DemonHunter },
    { name = "Knifermonkey", race = AddOn.RaceIcons.Undead.Male, class = AddOn.ClassIcons.Warlock, color = AddOn.HexColorPresets.Warlock },
    { name = "Jery", race = AddOn.RaceIcons.BloodElf.Male, class = AddOn.ClassIcons.Mage, color = AddOn.HexColorPresets.Mage },
    { name = "Emraliya", race = AddOn.RaceIcons.HighmountainTauren.Female, class = AddOn.ClassIcons.DeathKnight, color = AddOn.HexColorPresets.DeathKnight },
    { name = "Aliakin", race = AddOn.RaceIcons.Human.Male, class = AddOn.ClassIcons.Mage, color = AddOn.HexColorPresets.Mage },
    { name = "Grok", race = AddOn.RaceIcons.Orc.Male, class = AddOn.ClassIcons.Warrior, color = AddOn.HexColorPresets.Warrior }
}

function AddOn:BuildCreditsGroup()
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
            postTitleSpacer = self.CreateOptionsSpacer(2),
            author = {
                type = "description",
                name = ColorText("Created by "..self.GetTextureAtlasString(self.RaceIcons.BloodElf.Male)..self.GetTextureAtlasString(self.ClassIcons.Monk).." Pranavius", "Heirloom"),
                fontSize = "medium",
                order = 3
            },
            postDescSpacer = self.CreateOptionsSpacer(4),
            contributorsHeader = {
                type = "header",
                name = L["Contributors"],
                order = 5
            },
        }
    }

    for idx, cont in ipairs(contributors) do
        credits.args["contributor"..idx] = {
            type = "description",
            name = self.GetTextureAtlasString(cont.race)..self.GetTextureAtlasString(cont.class).." "..ColorText(cont.name, cont.color),
            fontSize = "medium",
            order = credits.args.contributorsHeader.order + idx
        }
    end

    -- Calculate the size of the args table
    local argsSize = 0
    for _ in pairs(credits.args) do
        argsSize = argsSize + 1
    end

    credits.args.postContributorsSpacer = self.CreateOptionsSpacer(argsSize + 1)

    credits.args.contributionMessage = {
        type = "description",
        name = L["If you would like to contribute to development, you can find the repository on GitHub."].."\n"..L["Please follow the development guidelines outlined in the README document."],
        order = argsSize + 2
    }
    credits.args.postContributionMessageSpacer = self.CreateOptionsSpacer(argsSize + 3)
    credits.args.specialThanksHeader = {
        type = "header",
        name = L["Special Thanks"],
        order = argsSize + 4
    }

    for idx, thanks in ipairs(specialThanks) do
        credits.args["specialThanks"..idx] = {
            type = "description",
            fontSize = "medium",
            name = self.GetTextureAtlasString(thanks.race)..self.GetTextureAtlasString(thanks.class).." "..ColorText(thanks.name, thanks.color),
            order = credits.args.specialThanksHeader.order + idx
        }
    end

    -- Recalculate the size of the args table
    argsSize = 0
    for _ in pairs(credits.args) do
        argsSize = argsSize + 1
    end

    credits.args.postSpecialThanksSpacer = self.CreateOptionsSpacer(argsSize + 1)
    credits.args.connectHeader = {
        type = "header",
        name = L["Connect"],
        order = argsSize + 2
    }
    credits.args.twitter = {
        type = "description",
        name = "|TInterface\\AddOns\\PranGearView\\Media\\X-logo:20:20:0:5|t   "..ColorText("@PranaviusWoW", "Legendary"),
        order = argsSize + 3,
    }
    credits.args.github = {
        type = "description",
        name = "|TInterface\\AddOns\\PranGearView\\Media\\Github-logo:20:20:0:5|t   "..ColorText("Pranavius", "Legendary"),
        order = argsSize + 4,
    }

    return credits
end
