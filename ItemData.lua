local _, PGV = ...

function PGV.GetItemDisplayData(itemLink, callback)
    local item = Item:CreateFromItemLink(itemLink)
    item:ContinueOnItemLoad(function()
        local data = {
            itemLevel = item:GetCurrentItemLevel(),
            quality = item:GetItemQuality(),
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
                elseif line.leftText and line.leftText:find(PGV.L["Embellished"], 1, true) then
                    data.isEmbellished = true
                end
            end
        end

        callback(data)
    end)
end
