ArenaRewardPreview = ArenaRewardPreview or BaseClass(BaseView)

function ArenaRewardPreview:__init()
	self.ui_config = {{"uis/views/arena_prefab", "ArenaRankRewardView"}}
	self.view_layer = UiLayer.Pop
	self.cell_list = {}
	self.is_modal = true
end

function ArenaRewardPreview:__delete()

end

function ArenaRewardPreview:LoadCallBack()
	self.node_list["BtnClose"].button:AddClickListener(BindTool.Bind(self.Close, self))
	local list_delegate = self.node_list["list_view"].list_simple_delegate
	list_delegate.NumberOfCellsDel = BindTool.Bind(self.GetNumberOfCells, self)
	list_delegate.CellRefreshDel = BindTool.Bind(self.RefreshCell, self)
	self.node_list["list_view"].scroller:ReloadData(0)
end

function ArenaRewardPreview:GetNumberOfCells()
	return 8
end

function ArenaRewardPreview:RefreshCell(cell, cell_index)
	local the_cell = self.cell_list[cell]
	if the_cell == nil then
		the_cell = ArenaRankRewardCell.New(cell.gameObject, self)
		self.cell_list[cell] = the_cell
		the_cell:SetToggleGroup(self.node_list["list_view"].toggle_group)
	end
	cell_index = cell_index + 1
	the_cell:SetRank(cell_index)
	the_cell:Flush()
end

function ArenaRewardPreview:OpenCallBack()

end

function ArenaRewardPreview:ReleaseCallBack()
	self.list_view = nil
	for k,v in pairs(self.cell_list) do
		v:DeleteMe()
	end
	self.cell_list = {}
end
--------------------------------------ArenaRankRewardCell-----------------------------------------

ArenaRankRewardCell = ArenaRankRewardCell or BaseClass(BaseCell)

function ArenaRankRewardCell:__init()
	self.item_cell_list = {}
	for i = 1, 2 do
		self.item_cell_list[i] = ItemCell.New()
		self.item_cell_list[i]:SetInstanceParent(self.node_list["ItemCell" .. i])
	end

end

function ArenaRankRewardCell:__delete()
	for k,v in pairs(self.item_cell_list) do
		v:DeleteMe()
	end
	self.item_cell_list = {}
	self.rank_desc = nil
	self.rank_img = nil
	self.show_img = nil
end

function ArenaRankRewardCell:SetRank(rank)
	self.rank = rank
end

function ArenaRankRewardCell:SetToggleGroup(toggle_group)
	self.root_node.toggle.group = toggle_group
end

function ArenaRankRewardCell:OnFlush()
	local server_open_day = TimeCtrl.Instance:GetCurOpenServerDay()
	local cfg = ArenaData.Instance:GetRankRewardData(server_open_day)
	local data = cfg[self.rank]
	local reward_data = data.reward_item

	if self.rank <= 3 then
		self.node_list["TxtRank"]:SetActive(false)
		self.node_list["ImgRanImage"]:SetActive(true)
		local bundle, asset = ResPath.GetRankIcon(self.rank)
		self.node_list["ImgRanImage"].image:LoadSprite(bundle, asset .. ".png")
		self.node_list["ImgRanImage"].image:SetNativeSize()
	else
		self.node_list["TxtRank"]:SetActive(true)
		self.node_list["ImgRanImage"]:SetActive(false)
	end

	if data then
		self.item_cell_list[1]:SetParentActive(false)
		self.item_cell_list[2]:SetParentActive(false)
		local data1 = reward_data[0]
		if data then
			self.item_cell_list[1]:SetData(data1)
			self.item_cell_list[1]:SetParentActive(true)
			self.item_cell_list[2]:SetData({is_bind = 1, item_id = 90015, num = data.reward_guanghui})
			self.item_cell_list[2]:SetParentActive(true)
		end
		self.node_list["TxtRank"].text.text = Language.Field1v1.PreviewDesc[self.rank]
	end
end