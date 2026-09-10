local _, PGV = ...

function PGV.GetItemDisplayData(itemLink, callback)
    local item = Item:CreateFromItemLink(itemLink)
    item:ContinueOnItemLoad(function()
        local data = {
            itemLevel = item:GetCurrentItemLevel(),
        }

        local tooltipData = C_TooltipInfo.GetHyperlink(itemLink)
        if tooltipData and tooltipData.lines then
            for _, line in ipairs(tooltipData.lines) do
                if line.type == Enum.TooltipDataLineType.ItemUpgradeLevel then
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
                end
            end
        end

        callback(data)
    end)
end

function PGV.DebugDumpTooltipLines(itemLink)
    local tooltipData = C_TooltipInfo.GetHyperlink(itemLink)
    if not tooltipData or not tooltipData.lines then
        PGV.DebugPrint("No tooltip data for", itemLink)
        return
    end

    for i, line in ipairs(tooltipData.lines) do
        PGV.DebugPrint("Line", i, "type", line.type, "leftText", line.leftText)
        for key, value in pairs(line) do
            if key ~= "type" and key ~= "leftText" then
                PGV.DebugPrint("  ", key, "=", tostring(value))
            end
        end
    end
end
