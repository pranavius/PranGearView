local _, PGV = ...

function PGV.GetItemDisplayData(itemLink, unit, slotID, callback)
    local item = Item:CreateFromItemLink(itemLink)
    local function buildDisplayData()
        local data = {
            itemLevel = item:GetCurrentItemLevel(),
            quality = item:GetItemQuality(),
        }

        local tooltipData = C_TooltipInfo.GetInventoryItem(unit, slotID)
        if tooltipData and tooltipData.lines then
            for _, line in ipairs(tooltipData.lines) do
                if line.type == Enum.TooltipDataLineType.ItemLevel then
                    local ilvl = line.leftText and tonumber(line.leftText:match("%d+"))
                    if ilvl then
                        data.itemLevel = ilvl
                    end
                elseif line.type == Enum.TooltipDataLineType.ItemUpgradeLevel then
                    data.upgradeTrack = {
                        text = line.leftText,
                        color = line.leftColor and line.leftColor:GenerateHexColorNoAlpha(),
                    }
                elseif line.type == Enum.TooltipDataLineType.GemSocket then
                    data.gems = data.gems or {}
                    tinsert(data.gems, {
                        icon = line.gemIcon,
                        socketType = line.socketType,
                    })
                elseif line.type == Enum.TooltipDataLineType.ItemEnchantmentPermanent then
                    data.enchant = {
                        text = line.leftText,
                    }
                elseif line.leftText and line.leftText:find(PGV.L["Embellished"], 1, true) then
                    data.isEmbellished = true
                end
            end
        end

        callback(data)
    end

    -- Found a ton of taint that I had no idea was happening while looking into a Settings issue lol
    -- Preventative measure to reduce taint where possible
    if item:IsItemDataCached() then
        buildDisplayData()
    else
        item:ContinueOnItemLoad(buildDisplayData)
    end
end
