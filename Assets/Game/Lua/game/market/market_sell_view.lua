MarketSellView = MarketSellView or BaseClass(BaseRender)

local ListViewDelegate = ListViewDelegate

MARKET_ROW = 6
MARKET_COLUMN = 5
MARKET_PAGE = 14

function MarketSellView:__init(instance)
	if instance == nil then
		return
	end
	--滚动条
	self.cell_list = {}
	self:InitScroller()
	self.scroller_select_number = 1
	self.current_page = 1
	self.last_index = 0

	self.select_cell = ItemCell.New()
	self.select_cell:SetFromView(TipsFormDef.FROM_MARKET_JISHOU)
	self.select_cell:SetInstanceParent(self.node_list["SelectCell"])
	self.select_cell:SetFromView(TipsFormDef.FROM_MARKET_JISHOU)

	self.node_list["BtnSell"].button:AddClickListener(BindTool.Bind(self.OnSell, self))
	self.node_list["BtnMax"].button:AddClickListener(BindTool.Bind(self.OnSellAll, self))
	self.node_list["NodeCount"].button:AddClickListener(BindTool.Bind(self.OnClickCount, self))
	self.node_list["NodeTotalPrice"].button:AddClickListener(BindTool.Bind(self.OnClickTotalPrice, self))
	self.node_list["BtnHelp"].button:AddClickListener(BindTool.Bind(self.OnClickHelp, self))
	self.node_list["BtnAdd"].button:AddClickListener(BindTool.Bind(self.OnClickAdd, self))

	self.node_list["TxtItemCount"].text.text = 0
	self.node_list["TxtTotalPrice"].text.text = 0
	self.count = 0
	self.total_price = 0

	self.node_list["TxtTax"].text.text = string.format(Language.Market.Tax, "0%")
end

function MarketSellView:__delete()
	for k,v in pairs(self.cell_list) do
		v:DeleteMe()
	end
	self.cell_list = {}
	if self.select_cell then
		self.select_cell:DeleteMe()
		self.select_cell = nil
	end
end

function MarketSellView:Flush()
	if self:IsOpen() then
		MarketData.Instance.item_list = ItemData.Instance:GetBagNoBindItemList()
		self:ClearSelectCell()
		for k, v in pairs(self.cell_list) do
			v:Flush()
		end
		MarketCtrl.Instance:SendPublicSaleGetUserItemListReq()
		local vo = GameVoManager.Instance:GetMainRoleVo()
		local gold = vo.gold
		self.node_list["TxtGold"].text.text = CommonDataManager.ConverMoney(gold)
	end
end

function MarketSellView:ClickItemById()
	local item_id = MarketData.Instance:GetItemId()
	if item_id ~= 0 then
		local item_list = MarketData.Instance.item_list
		if item_list then
			for i = 1, #item_list do
				if item_list[i].item_id == item_id then
					self:SelectItem(i)
					break
				end
			end
		end
	end
	MarketData.Instance:SetItemId(0)
end

--初始化滚动条
function MarketSellView:InitScroller()
	self.scroller_data = {}
	self.number_of_cells = MARKET_PAGE * MARKET_COLUMN
	for i = 0,self.number_of_cells - 1 do
		local data = {}
		data.value = i
		self.scroller_data[i] = data
	end

	self.list_view_delegate = ListViewDelegate()
	self.toggle_group = self.node_list["Scroller"]:GetComponent("ToggleGroup")

	local res_async_loader = AllocResAsyncLoader(self, "item_res_async_loader")
	res_async_loader:Load("uis/views/market_prefab", "ItemGroup", nil, function (obj)
		if nil == obj then
			return
		end

		self.enhanced_cell_type = obj:GetComponent(typeof(EnhancedUI.EnhancedScroller.EnhancedScrollerCellView))
		self.node_list["Scroller"].scroller.Delegate = self.list_view_delegate

		self.list_view_delegate.numberOfCellsDel = BindTool.Bind(self.GetNumberOfCells, self)
		self.list_view_delegate.cellViewSizeDel = BindTool.Bind(self.GetCellSize, self)
		self.list_view_delegate.cellViewDel = BindTool.Bind(self.GetCellView, self)
	end)
end

--滚动条数量
function MarketSellView:GetNumberOfCells()
	local item_list_length = #MarketData.Instance.item_list
	local page_count = math.ceil(item_list_length / (MARKET_ROW * MARKET_COLUMN))
	page_count = page_count < 1 and 1 or page_count
	self.node_list["Scroller"].list_page_scroll:SetPageCount(page_count)
	for i = 1, MARKET_PAGE do
		self.node_list["PageToggle" .. i]:SetActive(i <= page_count)
	end
	return page_count * MARKET_COLUMN
end

--滚动条大小 89
function MarketSellView:GetCellSize(data_index)
	return 89
end

--滚动条刷新
function MarketSellView:GetCellView(scroller, data_index, cell_index)
	local cell_view = scroller:GetCellView(self.enhanced_cell_type)

	local cell = self.cell_list[cell_view]
	if cell == nil then
		self.cell_list[cell_view] = MarketSellViewScrollCell.New(cell_view)
		cell = self.cell_list[cell_view]
		cell.sell_view = self
		cell:ListenAllEvent()
		cell:SetToggleGroup(self.toggle_group)
	end
	local data = self.scroller_data[data_index]
	data.data_index = data_index
	cell:SetData(data)
	return cell_view
end

-- 滚动条翻页
function MarketSellView:JumpPage(page)
	local jump_index = (page - 1) * MARKET_COLUMN
	local scrollerOffset = 0
	local cellOffset = 0
	local useSpacing = false
	local scrollerTweenType = self.node_list["Scroller"].scroller.snapTweenType
	local scrollerTweenTime = 0.2
	local scroll_complete = function()
		self.current_page = page
	end
	self.node_list["Scroller"].scroller:JumpToDataIndex(
		jump_index, scrollerOffset, cellOffset, useSpacing, scrollerTweenType, scrollerTweenTime, scroll_complete)
end

-- 从包裹中选择物体上架
function MarketSellView:SelectItem(index)
	if(self.last_index ~= index and index <= #MarketData.Instance.item_list) then
		self:ChangeSelectCell(index)
		local tax = MarketData.Instance:GetTax(2)
		self.node_list["TxtTax"].text.text = string.format(Language.Market.Tax, tax .. "%")
	else
		self:ClearSelectCell()
	end
end

-- 改变上架栏的图标
function MarketSellView:ChangeSelectCell(index)
	self.item_data = MarketData.Instance.item_list[index]
	local item_cfg, big_type = ItemData.Instance:GetItemConfig(self.item_data.item_id)
	if not item_cfg then return end 

	self.node_list["ItemName"].text.text = ToColorStr(item_cfg.name, ITEM_COLOR[item_cfg.color])
	self.select_cell:SetData(self.item_data)
	self.select_cell:SetInteractable(true)
	self.select_item_count = self.item_data.num

	self.count = 1
	self.node_list["TxtItemCount"].text.text = 1
	self.total_price = 10
	self.node_list["TxtTotalPrice"].text.text = self.total_price
	self.last_index = index
end

-- 清空上架栏的图标
function MarketSellView:ClearSelectCell()
	if self:IsOpen() then
		self.node_list["ItemName"].text.text = ""
		self.select_cell:SetData()
		self.select_cell:SetInteractable(false)
		self.select_item_count = nil
		self.count = 0
		self.node_list["TxtItemCount"].text.text = 0
		self.node_list["TxtTotalPrice"].text.text = 0
		self.total_price = 0
		self.last_index = 0
		self.node_list["TxtTax"].text.text = string.format(Language.Market.Tax, "0%")
	end
end

function MarketSellView:OnClickHelp()
	TipsCtrl.Instance:ShowOtherHelpTipView(100)
end

-- 最大数量
function MarketSellView:OnSellAll()
	if self.select_item_count ~= nil then
		self.count = self.select_item_count
		self.node_list["TxtItemCount"].text.text = self.count
		self:OnCountChanged()
	end
end

-- 充值金币
function MarketSellView:OnClickAdd()
	VipData.Instance:SetOpenType(OPEN_VIP_RECHARGE_TYPE.RECHANRGE)
	ViewManager.Instance:Open(ViewName.VipView)
end

-- 点击数量输入框
function MarketSellView:OnClickCount()
	if self.select_item_count == nil then
		return
	end
	TipsCtrl.Instance:OpenCommonInputView(nil, BindTool.Bind(self.CountInputEnd, self))
end

-- 点击总价输入框
function MarketSellView:OnClickTotalPrice()
	if(self.select_item_count == nil) then
		return
	end
	TipsCtrl.Instance:OpenCommonInputView(nil, BindTool.Bind(self.OnTotalPriceEnd, self), nil, MarketData.MaxPriceGold)
end

function MarketSellView:CountInputEnd(str)
	local count = tonumber(str)
	if count < 1 then
		count = 1
	elseif count > self.select_item_count then
		count = self.select_item_count
	end
	self.count = count
	self.node_list["TxtItemCount"].text.text = count
	self:OnCountChanged()
end

-- 数量改变时
function MarketSellView:OnCountChanged()
	self.node_list["TxtItemCount"].text.text = self.count
end

-- 总价输入完成后
function MarketSellView:OnTotalPriceEnd(str)
	local price = tonumber(str)
	if price < 10 then
		price = 10
	elseif price > MarketData.MaxPriceGold then
		price = MarketData.MaxPriceGold
	end
	self.total_price = price
	self.node_list["TxtTotalPrice"].text.text = self.total_price
	local tax = MarketData.Instance:GetTax(price)
	self.node_list["TxtTax"].text.text = string.format(Language.Market.Tax, tax .. "%")
end

-- 出售
function MarketSellView:OnSell()
	local sale_index = MarketData.Instance:GetValidIndex()

	local sale_num = self.count
	local sale_price = self.total_price
	if nil == sale_num or nil == sale_price then
		return
	end
	if 0 == sale_num and 0 == sale_price then
		SysMsgCtrl.Instance:ErrorRemind(Language.Market.OtherErrors)
		return
	end
	if 0 == sale_num and 0 ~= sale_price then
		SysMsgCtrl.Instance:ErrorRemind(Language.Market.OtherErrors1)
		return
	end
	if 0 ~= sale_num and 0 == sale_price then
		SysMsgCtrl.Instance:ErrorRemind(Language.Market.OtherErrors2)
		return
	end
	if sale_index < 0 then
		SysMsgCtrl.Instance:ErrorRemind(Language.Market.JiShouCountLimit)
		return
	end
	local price_type = MarketData.PriceTypeGold
	MarketCtrl.Instance:SendAddPublicSaleItemReq(sale_index, self.item_data.index, sale_num, sale_price, price_type)
end

----------------------------------------------------------------------------
--MarketSellViewScrollCell	拍卖行出售列表
----------------------------------------------------------------------------

MarketSellViewScrollCell = MarketSellViewScrollCell or BaseClass(BaseCell)

function MarketSellViewScrollCell:__init()
	self.root_node.list_cell.refreshCell = BindTool.Bind(self.Flush, self)

	self.item_list = {}
	for i = 1, 6 do
		self.item_list[i] = ItemCell.New()
		self.item_list[i]:SetFromView(TipsFormDef.FROM_MARKET_JISHOU)
		self.item_list[i]:SetInstanceParent(self.node_list["Item" .. i])
		self.item_list[i]:SetFromView(TipsFormDef.FROM_MARKET_JISHOU)
	end
	
end

function MarketSellViewScrollCell:SetToggleGroup(toggle_group)
	for i = 1, 6 do
		self.item_list[i]:SetToggleGroup(toggle_group)
	end
end

function MarketSellViewScrollCell:__delete()
	for k,v in pairs(self.item_list) do
		if v then
			v:DeleteMe()
		end
	end
	self.item_list = {}
end

function MarketSellViewScrollCell:Flush()
	for i = 1, 6 do
		local index = self:GetIndex(i)
		if(index > #MarketData.Instance.item_list) then    -- 如果超出可出售物品的数量，则此格子不显示
			self.item_list[i]:SetData(nil)
		else                                          	 -- 否则，显示该物品的信息
			local data = MarketData.Instance.item_list[index]
			self.item_list[i]:SetData(data)
		end
		if index == self.sell_view.last_index then
			self.item_list[i]:SetHighLight(true)
		else
			self.item_list[i]:SetHighLight(false)
		end
		
	end
end

-- 根据格子的编号获得在包裹栏中对应的索引值
function MarketSellViewScrollCell:GetIndex(index)
	local current_page = self.data.data_index / MARKET_COLUMN
	current_page = math.floor(current_page)
	local column = self.data.data_index % MARKET_COLUMN
	return (index - 1) * MARKET_COLUMN + column + current_page * MARKET_ROW * MARKET_COLUMN + 1
end

-- 根据在包裹栏中的索引值获得在格子的编号
function MarketSellViewScrollCell:GetCellIndex(index)
	local current_page = math.floor(index / (MARKET_ROW * MARKET_COLUMN))
	local column = index - current_page * MARKET_ROW * MARKET_COLUMN
	column = column % MARKET_COLUMN
	if(column == 0) then
		column = MARKET_COLUMN
	end
	return column
end

function MarketSellViewScrollCell:ListenAllEvent()
	for i = 1, 6 do
	self.item_list[i]:ListenClick(
		function()
			self.sell_view:SelectItem(self:GetIndex(i))
		end)
	end
end