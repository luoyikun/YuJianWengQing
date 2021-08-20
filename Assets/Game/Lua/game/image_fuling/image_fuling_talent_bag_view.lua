local BAG_PAGE_NUM = 5

ImageFulingTalentBagView = ImageFulingTalentBagView or BaseClass(BaseView)
function ImageFulingTalentBagView:__init()
	self.ui_config = {
		{"uis/views/commonwidgets_prefab", "BaseThreePanel"},
		{"uis/views/imagefuling_prefab", "FuLingTalentBagView"},
	}
	self.is_modal = true
	self.is_any_click_close = true
	self.open_tween = UITween.ShowFadeUp
	self.close_tween = UITween.HideFadeUp
	self.play_audio = true
end

function ImageFulingTalentBagView:__delete()

end

function ImageFulingTalentBagView:LoadCallBack()
	self.node_list["Bg"].rect.sizeDelta = Vector3(520, 580, 0)
	self.node_list["Txt"].text.text = Language.ImageFuLing.TianFuPackage
	self.node_list["BtnClose"].button:AddClickListener(BindTool.Bind(self.Close, self))

	self.last_flush_window_time = Status.NowTime
	self:InitScrollerWindow()
	self.window_item_list = {}
	self.add_function = BindTool.Bind(self.OnSelectItem, self)
end

function ImageFulingTalentBagView:ReleaseCallBack()
	self:RemoveWindowDelayTime()

	for k,v in pairs(self.cell_window_list) do
		v:DeleteMe()
	end
	self.cell_window_list = {}

	self.window_toggle_group = nil
	self.window_enhanced_cell_type = nil
	self.window_list_view_delegate = nil
	self.page_toggle_list = {}
end

function ImageFulingTalentBagView:InitScrollerWindow()
	self.cell_window_list = {}

	self.window_toggle_group = self.node_list["ListView"]:GetComponent("ToggleGroup")

	local ListViewDelegate = ListViewDelegate
	self.window_list_view_delegate = ListViewDelegate()
	local res_async_loader = AllocResAsyncLoader(self, "item_res_async_loader")
	res_async_loader:Load("uis/views/imagefuling_prefab", "ItemCellPanel", nil,function (prefab)
		if nil == prefab then
			return
		end
		local enhanced_cell_type = prefab:GetComponent(typeof(EnhancedUI.EnhancedScroller.EnhancedScrollerCellView))
		
		self.window_enhanced_cell_type = enhanced_cell_type
		self.node_list["ListView"].scroller.Delegate = self.window_list_view_delegate

		self.window_list_view_delegate.numberOfCellsDel = BindTool.Bind(self.GetWindowNumberOfCells, self)
		self.window_list_view_delegate.cellViewSizeDel = BindTool.Bind(self.GetCellSize, self)
		self.window_list_view_delegate.cellViewDel = BindTool.Bind(self.GetWindowCellView, self)
	end)

	self.page_toggle_list = {}
	for i = 1, BAG_PAGE_NUM do
		self.page_toggle_list[i] = self.node_list["PageToggle" .. i].toggle
	end
end

function ImageFulingTalentBagView:OpenCallBack()
	if self.item_data_event == nil then
		self.item_data_event = BindTool.Bind1(self.ItemDataChangeCallback, self)
		ItemData.Instance:NotifyDataChangeCallBack(self.item_data_event)
	end

	--打开翻到第一页
	self.node_list["ListView"].scroller:JumpToDataIndexForce(0)
	self.page_toggle_list[1].isOn = true
end

function ImageFulingTalentBagView:CloseCallBack()
	self.select_info = nil

	if self.item_data_event ~= nil then
		ItemData.Instance:UnNotifyDataChangeCallBack(self.item_data_event)
		self.item_data_event = nil
	end
end

function ImageFulingTalentBagView:ItemDataChangeCallback()
	self:OnFlushItemWindow()
end

function ImageFulingTalentBagView:OnFlush(param_t)
	for k,v in pairs(param_t) do
		if "equip_talent" == k then
			self.select_info = v
		end
	end

	self:OnFlushItemWindow()
end

function ImageFulingTalentBagView:CloseWindow()
	self:Close()
end

function ImageFulingTalentBagView:GetWindowNumberOfCells()
	return 20
end

function ImageFulingTalentBagView:GetCellSize(data_index)
	return 96
end

function ImageFulingTalentBagView:GetWindowCellView(scroller, data_index, cell_index)
	local cell_view = scroller:GetCellView(self.window_enhanced_cell_type)
	local cell = self.cell_window_list[cell_view]
	if cell == nil then
		self.cell_window_list[cell_view] = ImageFulingTalentBagCell.New(cell_view)
		cell = self.cell_window_list[cell_view]
		cell:SetClickFunc(self.add_function)
	end
	local data = self:GetItemPanelData(self.window_item_list, data_index + 1, 4, 4)
	cell:SetData(data)
	return cell_view
end

function ImageFulingTalentBagView:GetItemPanelData(item_list, index, row, column)
	if not item_list then return end
	local index1 = math.floor(index / column)
	local index2 = index % column
	if index2 == 0 then
		index1 = index1 - 1
		index2 = column
	end
	local num = index1 * row * column
	local list = {}
	for i = 1, row do
		local index3 = index2 + (i - 1) * column + num
		list[i] = item_list[index3] or {}
	end
	return list
end

function ImageFulingTalentBagView:OnFlushItemWindow()
	if self.last_flush_window_time + 0.1 <= Status.NowTime then
		self.last_flush_window_time = Status.NowTime

		self.window_item_list = ImageFuLingData.Instance:GetTalentBagList(self.select_info)
		if self.node_list["ListView"].scroller.isActiveAndEnabled then
			self.node_list["ListView"].scroller:RefreshAndReloadActiveCellViews(true)
		end
	else
		self.last_flush_window_time = Status.NowTime
		self:RemoveWindowDelayTime()
		self.window_delay_time = GlobalTimerQuest:AddDelayTimer(function() self:OnFlushItemWindow() end, 0.2)
	end
end

function ImageFulingTalentBagView:RemoveWindowDelayTime()
	if self.window_delay_time then
		GlobalTimerQuest:CancelQuest(self.window_delay_time)
		self.window_delay_time = nil
	end
end

function ImageFulingTalentBagView:OnSelectItem(data, switch)
	if data == nil then return end
	local item_cfg, big_type = ItemData.Instance:GetItemConfig(data.item_id)
	if nil == item_cfg then
		return
	end
	local from_view = nil ~= self.select_info and TipsFormDef.FROM_TALENT_EQUIP or nil
	local param_t = nil ~= self.select_info and {talent_type = self.select_info.talent_type, grid_index = self.select_info.grid_index} or nil
	local close_call_back = function() self:FlushHighLight() end
	TipsCtrl.Instance:OpenItem(data, from_view, param_t, close_call_back)
end

function ImageFulingTalentBagView:FlushHighLight()
	for k,v in pairs(self.cell_window_list) do
		v:FlushHighLight()
	end
end

-------------------------------------------------------- ImageFulingTalentBagCell ----------------------------------------------------------

ImageFulingTalentBagCell = ImageFulingTalentBagCell or BaseClass(BaseCell)

function ImageFulingTalentBagCell:__init()
	self.root_node.list_cell.refreshCell = BindTool.Bind(self.Flush, self)

	self.item_list = {}
	for i = 1, 4 do
		self.item_list[i] = {}
		self.item_list[i].cell = ItemCell.New()
		self.item_list[i].cell:SetInstanceParent(self.node_list["ItemCell" .. i])
		self.item_list[i].cell:IsDestroyEffect(true)
		local func = function ()
			if self.data[i].item_id == nil then
				self.item_list[i].cell:SetHighLight(false)
				return
			end
			TipsCtrl.Instance:OpenItem(self.data[i], self.form_type, nil, function() self.item_list[i].cell:SetHighLight(false) end)
		end
		self.item_list[i].cell:ListenClick(func)
	end
end

function ImageFulingTalentBagCell:__delete()
	for k,v in pairs(self.item_list) do
		if v.cell then
			v.cell:DeleteMe()
		end
	end
	self.item_list = {}
end

function ImageFulingTalentBagCell:SetToggleGroup(toggle_group)
	for i = 1, 4 do
		self.item_list[i].cell:SetToggleGroup(toggle_group)
	end
end

function ImageFulingTalentBagCell:OnFlush()
	for i = 1, 4 do
		local data = self.data[i]
		self:FLushCell(i, data)
	end
end

function ImageFulingTalentBagCell:FLushCell(i, data)
	self.item_list[i].cell:SetData(data)
	local item_cfg = ItemData.Instance:GetItemConfig(data.item_id)
	local gamevo = GameVoManager.Instance:GetMainRoleVo()

	if data.item_id == nil and not data.locked then
		self.item_list[i].cell:SetInteractable(false)
	else
		self.item_list[i].cell:SetInteractable(true)
	end

	if self.data[i].is_select then
		self.item_list[i].cell:SetHighLight(true)
	else
		self.item_list[i].cell:SetHighLight(false)
	end
end

function ImageFulingTalentBagCell:SetClickFunc(func)
	if func then
		for i = 1, 4 do
			local cell = self.item_list[i].cell
			cell:ListenClick(BindTool.Bind(self.SelectFunc, self, i, func))
		end
	end
end

function ImageFulingTalentBagCell:SelectFunc(i, func)
	if self.data[i].item_id then
		func(self.data[i], self.data[i].is_select)
	end
end

function ImageFulingTalentBagCell:FlushHighLight()
	for i = 1, 4 do
		local data = self.data[i]
		if data and data.is_select then
			self.item_list[i].cell:SetHighLight(true)
		else
			self.item_list[i].cell:SetHighLight(false)
		end
	end
end
