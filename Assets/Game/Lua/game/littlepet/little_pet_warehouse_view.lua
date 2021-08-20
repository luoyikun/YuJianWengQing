LittlePetWarehouseView = LittlePetWarehouseView or BaseClass(BaseView)

-- 常量定义
local MAX_GRID_NUM = 320
local ROW = 5
local COLUMN = 8
local MAX_PAGE_COUNT = 8
function LittlePetWarehouseView:__init()
	self.ui_config = {
    {"uis/views/commonwidgets_prefab", "BaseThreePanel"},
    {"uis/views/littlepetview_prefab","LittlePetWareHouseView"}
}
    self.is_modal = true
    self.is_any_click_close = true
    self.open_tween = UITween.ShowFadeUp
    self.close_tween = UITween.HideFadeUp

end

function LittlePetWarehouseView:__delete()

end

function LittlePetWarehouseView:LoadCallBack()
    self.node_list["Bg"].rect.sizeDelta = Vector3(903,684,0)
    self.node_list["BtnClose"].button:AddClickListener(BindTool.Bind(self.CloseView, self))
    self.node_list["Txt"].text.text = Language.LittlePet.WareHouse

	self.cell_list = {}
	self.data_list = {}
	--self.page_count = self:FindVariable("PageCount")

	self.list_view = self.node_list["ListView"]
	local list_delegate = self.list_view.list_simple_delegate
	list_delegate.NumberOfCellsDel = BindTool.Bind(self.GetNumOfCells, self)
	list_delegate.CellRefreshDel = BindTool.Bind(self.RefreshCell, self)

	self.node_list["BtnTakeOut"].button:AddClickListener(BindTool.Bind(self.OnClickTakeOut, self))
end

function LittlePetWarehouseView:ReleaseCallBack()
   	if self.cell_list ~= nil then
		for k, v in pairs(self.cell_list) do
			v:DeleteMe()
		end
		self.cell_list = nil
	end
	
	self.list_view = nil
	--self.page_count = nil
end

function LittlePetWarehouseView:OpenCallBack()
	self:GetItemData()
	local num = self:GetNumOfCells()
	local count = math.ceil(num / COLUMN)
	for i = 1, MAX_PAGE_COUNT do
        if count < i then 
            self.node_list["PageToggle" .. i]:SetActive(false)
        else
            self.node_list["PageToggle" .. i]:SetActive(true)
        end
    end
	self.list_view.list_page_scroll:SetPageCount(count)
	self.list_view.scroller:ReloadData(0)
end

function LittlePetWarehouseView:CloseCallBack()

end

function LittlePetWarehouseView:CloseView()
	self:Close()
end

function LittlePetWarehouseView:GetItemData()
	self.data_list = LittlePetData.Instance:GetLittlePetWarehouseList()
end

function LittlePetWarehouseView:GetNumOfCells() 
	local diff = #self.data_list - MAX_GRID_NUM
	local more_then_num = ((diff > 0)) and (math.ceil(diff / ROW / COLUMN)) or 0
	return (MAX_GRID_NUM + more_then_num * ROW * COLUMN) / ROW
end

function LittlePetWarehouseView:RefreshCell(cell, data_index)
	local group = self.cell_list[cell]
	if group == nil then
		group = LittlePetItemGroup.New(cell.gameObject)
		group:SetToggleGroup(self.list_view.toggle_group)
		self.cell_list[cell] = group
	end

	local page = math.floor(data_index / COLUMN)
	local column = data_index - page * COLUMN
	local grid_count = COLUMN * ROW
	for i = 1, ROW do
		local index = (i - 1) * COLUMN + column + (page * grid_count)
		local data = self.data_list[index + 1]
		data = data or {}
		if data.index == nil then
			data.index = index
		end
		group:SetData(i, data)
		group:ListenClick(i, BindTool.Bind(self.OnClickCell, self, data, group, i))
		group:SetInteractable(i, nil ~= data.item_id)
		group:SetHighLight(i, false)
	end
end

function LittlePetWarehouseView:OnClickCell(data, group, group_index)
	self.cur_index = data.index
	local close_call_back = function()
		self.cur_index = nil
		group:ShowHighLight(group_index, false)
	end
	TipsCtrl.Instance:OpenItem(data, TipsFormDef.FORM_CHONG_WU_WAREHOUSE, nil, close_call_back)
	group:ShowHighLight(group_index, false)
end

function LittlePetWarehouseView:OnClickTakeOut()
	if #self.data_list <= 0 then return end
	TreasureCtrl.Instance:SendQuchuItemReq(0, CHEST_SHOP_TYPE.CHEST_SHOP_TYPE_EQUIP, 1)
end

function LittlePetWarehouseView:OnFlush()
	self:GetItemData()
	self.list_view.scroller:RefreshAndReloadActiveCellViews(true)
end

-------------------------------------------------------------------
LittlePetItemGroup = LittlePetItemGroup or BaseClass(BaseRender)

function LittlePetItemGroup:__init(instance)
	self.cells = {}
	for i = 1, ROW do
		self.cells[i] = ItemCell.New()
		self.cells[i]:SetInstanceParent(self.node_list["Item"..i])
	end
end

function LittlePetItemGroup:__delete()
	if self.cells then
		for k, v in pairs(self.cells) do
			v:DeleteMe()
		end
		self.cells = {}
	end
end

function LittlePetItemGroup:SetData(i, data)
	self.cells[i]:SetData(data)
end

function LittlePetItemGroup:ListenClick(i, handler)
	self.cells[i]:ListenClick(handler)
end

function LittlePetItemGroup:SetToggleGroup(toggle_group)
	self.cells[1]:SetToggleGroup(toggle_group)
	self.cells[2]:SetToggleGroup(toggle_group)
	self.cells[3]:SetToggleGroup(toggle_group)
	self.cells[4]:SetToggleGroup(toggle_group)
end

function LittlePetItemGroup:SetHighLight(i, enable)
	self.cells[i]:SetHighLight(false)
end

function LittlePetItemGroup:ShowHighLight(i, enable)
	if self.cells and self.cells[i] then
		self.cells[i]:ShowHighLight(enable)
	end
end

function LittlePetItemGroup:SetInteractable(i, enable)
	self.cells[i]:SetInteractable(enable)
end

function LittlePetItemGroup:SetToggle(i, enable)
	self.cells[i]:SetToggle(enable)
end

function LittlePetItemGroup:OnClickSingleCell(i)
	-- self.cells[i].data.index
end