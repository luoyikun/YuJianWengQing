FastFlipView = FastFlipView or BaseClass(BaseView)

local COLUMN = 2

function FastFlipView:__init()
	self.ui_config = {
		{"uis/views/commonwidgets_prefab", "BaseThreePanel"},
		{"uis/views/randomact/puzzle_prefab", "FastFlipFlushView"}
	}
	self.play_audio = true
	self.is_modal = true
	self.is_any_click_close = true
	self.open_tween = UITween.ShowFadeUp
	self.close_tween = UITween.HideFadeUp
end

function FastFlipView:__delete()
	
end

function FastFlipView:LoadCallBack()
	self.list_data = {}
	self.cell_list = {}

	self.node_list["Bg"].rect.sizeDelta = Vector3(695, 545, 0)
	self.node_list["Txt"].text.text = Language.Puzzle.BtnText[1]
	self.node_list["BtnClose"].button:AddClickListener(BindTool.Bind(self.CloseWindow, self))
	self.node_list["BtnCancel"].button:AddClickListener(BindTool.Bind(self.CloseWindow, self))
	self.node_list["BtnStart"].button:AddClickListener(BindTool.Bind(self.ClickStart, self))

	self:SetListData()
	local list_delegate = self.node_list["List"].list_simple_delegate
	list_delegate.NumberOfCellsDel = BindTool.Bind(self.GetNumberOfCells, self)
	list_delegate.CellRefreshDel = BindTool.Bind(self.RefreshCell, self)
end

function FastFlipView:ReleaseCallBack()
	-- self.list = nil
	self.list_data = {}

	for k,v in pairs(self.cell_list) do
		v:DeleteMe()
	end
	self.cell_list = nil
end

function FastFlipView:OpenCallBack()
	self.cur_select_list = {}
	self:SetListData()
	self.node_list["List"].scroller:ReloadData(0)
	local list = {}
	PuzzleData.Instance:SetSelectWordList(list)
end

function FastFlipView:CloseCallBack()
	self:CloseAllHL()
	self.cur_select_list = {}
end

function FastFlipView:SetListData()
	self.list_data = PuzzleData.Instance:GetWordList() or {}
end

function FastFlipView:GetNumberOfCells()
	return math.ceil(#self.list_data / COLUMN) or 0
end

function FastFlipView:RefreshCell(cell, data_index)
	local cell_group = self.cell_list[cell]
	if nil == cell_group then
		cell_group = FastFlipGroup.New(cell.gameObject)
		self.cell_list[cell] = cell_group
	end

	for i = 1, COLUMN do
		local index = (data_index) * COLUMN + i
		local data = self.list_data[index]
		cell_group:SetIndex(i, index)
		cell_group:SetActive(i, (data ~= nil))
		cell_group:SetParent(i, self)
		cell_group:SetData(i, data)
	end
end

function FastFlipView:CloseWindow()
	self:Close()
end

function FastFlipView:ClickStart()
	local is_enough = PuzzleData.Instance:GoldIsEnough()
	if not is_enough then
		TipsCtrl.Instance:ShowLackDiamondView()
		return 
	end

	local is_filp = PuzzleData.Instance:GetIsFilp()
	local cur_word_seq = PuzzleData.Instance:GetCurWrodGroupIndex()
	if nil == next(self.cur_select_list) then
		SysMsgCtrl.Instance:ErrorRemind(Language.Puzzle.SelectSeq)
		return
	end

	if is_filp then
		for k,v in pairs(self.cur_select_list) do
			if v == cur_word_seq then
				SysMsgCtrl.Instance:ErrorRemind(Language.Puzzle.HasSelectSeq)
				return
			end
		end
	end
	PuzzleData.Instance:SetSelectWordList(self.cur_select_list)
	PuzzleCtrl.Instance:BeginFastFilp()
	self:Close()
end

function FastFlipView:CheckSelectSeq(seq)
	if self.cur_select_list[seq] then
		self.cur_select_list[seq] = nil
	else
		self.cur_select_list[seq] = seq
	end
end

function FastFlipView:IsSelectSeq(seq)
	return self.cur_select_list[seq]
end

function FastFlipView:CloseAllHL()
	for k,v in pairs(self.cell_list) do
		v:ClearState()
	end
end
------------------------------------------------------------
FastFlipGroup = FastFlipGroup or BaseClass(BaseRender)

function FastFlipGroup:__init( )
	self.item_list = {}
	for i = 1,COLUMN do
		local filp_item = FastFlipItem.New(self.node_list["item" .. i])
		table.insert(self.item_list, filp_item)
	end
end

function FastFlipGroup:__delete()
	for k, v in ipairs(self.item_list) do
		v:DeleteMe()
	end
	self.item_list = {}
end

function FastFlipGroup:SetActive(i, state)
	self.item_list[i]:SetActive(state)
end

function FastFlipGroup:SetParent(i, parent)
	self.item_list[i]:SetParent(parent)
end

function FastFlipGroup:SetData(i, data)
	self.item_list[i]:SetData(data)
end

function FastFlipGroup:SetIndex(i, index)
	self.item_list[i]:SetIndex(index)
end

function FastFlipGroup:IsShowHL(state)
	for i = 1, COLUMN do
		self.item_list[i]:IsShowHL(state)
	end
end

function FastFlipGroup:ClearState()
	for i = 1, COLUMN do
		self.item_list[i]:ClearState()
	end
end

------------------------------------------------------------
FastFlipItem = FastFlipItem or BaseClass(BaseCell)

function FastFlipItem:__init()
	self.seq = -1
	self.cell = ItemCell.New()
	self.cell:SetInstanceParent(self.node_list["ItemCell"])
	self.node_list["ToggleImg"].toggle:AddClickListener(BindTool.Bind(self.OnClick,self))
end

function FastFlipItem:__delete()
	if self.cell then
		self.cell:DeleteMe()
	end
	self.item_cell = nil
	self.parent = nil
	self.seq = -1
end

function FastFlipItem:SetData(data)
	if nil == data then return end 
	self.data = data
	self:Flush()
end

function FastFlipItem:SetIndex(index)
	self.index = index
end

function FastFlipItem:OnClick()
	self.parent:CheckSelectSeq(self.seq)
	self:IsShowHL(self.parent:IsSelectSeq(self.seq))
end

function FastFlipItem:SetParent(parent)
	self.parent = parent
end

function FastFlipItem:IsShowHL(state)
	if self.node_list["ImgHL"] then
		self.node_list["ImgHL"]:SetActive(state and true or false)
	end
end

function FastFlipItem:ClearState()
	self:IsShowHL(false)
	self.seq = -1
end

function FastFlipItem:OnFlush()
	if nil == self.data or nil == self.data.index then return end

	local word_info = PuzzleData.Instance:GetWrodInfo(self.data.index)
	if word_info == nil then return end

	for i = 1, GameEnum.RA_FANFAN_LETTER_COUNT_PER_WORD do
		local bundle, asset = "uis/views/randomact/puzzle/images_atlas", "PuzzleWord" .. (self.data.index * 4 + i)
		self.node_list["ImgWord" .. i].image:LoadSprite(bundle, asset, function()
			self.node_list["ImgWord" .. i].image:SetNativeSize()
		end)
	end
	self.seq = word_info.seq
	self:IsShowHL(self.parent:IsSelectSeq(self.seq))
	self.cell:SetData(word_info.exchange_item)
end