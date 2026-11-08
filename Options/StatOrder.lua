local _, PGV = ...
local L = PGV.L

PGVStatOrderRowMixin = {}

function PGVStatOrderRowMixin:Init(elementData)
    self.Text:SetText(L[elementData.stat])
end

-- Predicate to find the Reset button for character stat order
local function isStatOrderResetRow(_, elementData)
    local data = elementData.GetData and elementData:GetData()
    return data and data.isStatOrderReset
end

PGVStatOrderListMixin = {}

function PGVStatOrderListMixin:OnLoad()
    local view = CreateScrollBoxListLinearView()
    view:SetElementExtent(20)
    view:SetElementFactory(function(factory, elementData)
        factory("PGVStatOrderRowTemplate", function(rowFrame, data)
            rowFrame:Init(data)
        end)
    end)
    ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, view)

    local dragBehavior = ScrollUtil.InitDefaultLinearDragBehavior(self.ScrollBox)
    dragBehavior:SetReorderable(true)
    dragBehavior:SetPostDrop(function(contextData)
        local newOrder = {}
        for _, elementData in contextData.dataProvider:EnumerateEntireRange() do
            tinsert(newOrder, elementData.stat)
        end
        PGV.SetStatOrderForEditingSpec(newOrder)

        local resetRow = SettingsPanel:GetSettingsList().ScrollBox:FindFrameByPredicate(isStatOrderResetRow)
        if resetRow then
            resetRow:EvaluateState()
        end
    end)
end

-- Called by Settings on every assignment (new or reused)
function PGVStatOrderListMixin:Init(initializer)
    PGV.StatOrderList = self
    PGV.RefreshStatOrderList()
end

function PGVStatOrderListMixin:SetOrder(statOrder)
    local dataProvider = CreateDataProvider()
    for _, stat in ipairs(statOrder) do
        dataProvider:Insert({ stat = stat })
    end
    self.ScrollBox:SetDataProvider(dataProvider)
end

function PGV.RefreshStatOrderList()
    if not PGV.StatOrderList then
        return
    end
    local specID = PGV.GetSpecAndRoleForSelectedCharacterStatsOption()
    PGV.InitializeCustomSpecStatOrderDB(specID)
    PGV.StatOrderList:SetOrder(PGV.db.characterStats.customSpecStatOrders[specID] or {})
end
