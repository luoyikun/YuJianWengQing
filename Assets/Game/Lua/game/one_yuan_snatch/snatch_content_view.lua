SnatchContentView = SnatchContentView or BaseClass(BaseRender)
	
local EXCHANGE_TIME = 1

function SnatchContentView:__init(instance)

	self.cell_list = {}
	self.toggle_index = 1
	self.node_list["TxtTicket"].text.text = 0
	for i = 1, 4 do
		self.node_list["toggle" .. i].toggle:AddClickListener(BindTool.Bind(self.OnClickTab, self, i))
	end
	self.node_list["toggle" .. self.toggle_index].isOn = true

	local scroller_delegate = self.node_list["ListView"].list_simple_delegate
	scroller_delegate.NumberOfCellsDel = BindTool.Bind(self.GetNumberOfCells, self)
	scroller_delegate.CellRefreshDel = BindTool.Bind(self.RefreshCell, self)

	self.node_list["BtnTitle"].button:AddClickListener(BindTool.Bind(self.HintClick, self))

	self:InitPanel()
end

function SnatchContentView:__delete()
	if self.cell_list then
		for k, v in pairs(self.cell_list) do
			if v then
				v:DeleteMe()
				v = nil
			end
		end
		self.cell_list = nil
	end
end

function SnatchContentView:CloseCallBack()

end

function SnatchContentView:OpenCallBack()
	OneYuanSnatchCtrl.Instance:SendOperate(RA_CLOUDPURCHASE_OPERA_TYPE.RA_CLOUDPURCHASE_OPERA_TYPE_INFO)
	self:Flush()
end

function SnatchContentView:OnFlush()
	if self.node_list["ListView"] and self.node_list["ListView"].scroller then
		self.node_list["ListView"].scroller:RefreshAndReloadActiveCellViews(false)
	end

	local user_info = OneYuanSnatchData.Instance:GetCloudPurchaseUserInfo()
	if user_info then
		self.node_list["TxtTicket"].text.text = user_info.ticket_num or 0
	end
end

function SnatchContentView:InitPanel()
	local buy_copies_cfg = OneYuanSnatchData.Instance:GetCopiesCfg()
	if buy_copies_cfg then
		for i = 1, 4 do
			if buy_copies_cfg[i] then
				self.node_list["TxtBuy" .. i].text.text = string.format(Language.OneYuanSnatch.Fen,  buy_copies_cfg[i].buy_copies or 1)
			end
		end
	end
end

function SnatchContentView:GetNumberOfCells()
	return OneYuanSnatchData.Instance:GetSnatchNum() or 0
end

function SnatchContentView:RefreshCell(cell, data_index)
	data_index = data_index + 1
	local cfg = OneYuanSnatchData.Instance:GetSnatchGroupIndexCfg(data_index)
	local the_cell = self.cell_list[cell]

	if cfg then
		if the_cell == nil then
			the_cell = SnatchCellGroup.New(cell.gameObject)
			self.cell_list[cell] = the_cell
		end
		the_cell:SetIndex(data_index)
		the_cell.parent_view = self
		the_cell.view_type = "snatch"
		the_cell:SetData(cfg)
	end
end

function SnatchContentView:HintClick()
	TipsCtrl.Instance:ShowHelpTipView(TipsOtherHelpData.Instance:GetTipsTextById(320))
end

function SnatchContentView:OnClickTab(index)
	self.toggle_index = index or 1
end

function SnatchContentView:GetBuyCount()
	local buy_copies_cfg = OneYuanSnatchData.Instance:GetCopiesCfg()
	local i = self.toggle_index

	return buy_copies_cfg and buy_copies_cfg[i].buy_copies or 1
end





------------------------------------
SnatchCellGroup = SnatchCellGroup or BaseClass(BaseCell)

function SnatchCellGroup:__init()
	self.view_type = "ticket"
	self.cell_list = {}

	for i = 1, 4 do
		self.cell_list[i] = SnatchCell.New(self.node_list["cell" .. i])
		self.cell_list[i]:SetIndex(i)
		self.cell_list[i].parent_view = self	
	end
end

function SnatchCellGroup:__delete()
	if self.cell_list then
		for i = 1, 4 do
			if self.cell_list[i] then
				self.cell_list[i]:DeleteMe()
				self.cell_list[i] = nil
			end
		end

		self.cell_list = nil
	end
end

function SnatchCellGroup:FlushCell()
	local num = #self.data or 0

	if num > 0 then
		for i = 1, 4 do
			if self.cell_list and self.cell_list[i] and self.cell_list[i].root_node then
				self.cell_list[i].root_node:SetActive(i <= num)

				if i <= num then
					self.cell_list[i].view_type = self.view_type
					self.cell_list[i]:SetData(self.data[i])
				end
			end
		end
	end

end

function SnatchCellGroup:OnFlush()
	if self.data then
		self:FlushCell()
	end
end

function SnatchCellGroup:GetBugCount()
	if self.parent_view and self.view_type == "snatch" then
		return self.parent_view:GetBuyCount()
	end
	return 0
end


-------------------------------------
SnatchCell = SnatchCell or BaseClass(BaseCell)

function SnatchCell:__init()
	self.item_cell = ItemCell.New()
	self.item_cell:SetInstanceParent(self.node_list["item_cell"])
	self.node_list["BtnBuy"].button:AddClickListener(BindTool.Bind(self.OnBuyClick, self))
	self.buy_type = 0
end

function SnatchCell:__delete()
	if self.item_cell then
		self.item_cell:DeleteMe()
		self.item_cell = nil
	end

end

function SnatchCell:OnFlush()

	if self.data then
		local item_data = nil
		local item_id = 0
		local item_name = ""
		local cell_index = 0

		self.view_type = self.view_type or "ticket"

		if self.view_type == "ticket" then

			item_data = OneYuanSnatchData.Instance:ParseIntergralItemId(self.data.qianggou_ticket_item_id or 0)
			item_id = item_data and item_data.item_id or 0
			cell_index = self.index
			self.node_list["TxtBuyCount"].text.text = string.format(Language.OneYuanSnatch.BuyCount, self.data.rmb_price or 0)
		elseif self.view_type == "snatch" then

			item_data = self.data.reward_item

			if self.data.reward_item then
				item_id = self.data.reward_item.item_id or 0
			end

			cell_index = self.index + ((self.parent_view.index or 1) - 1) * 3

			self.node_list["TxtButton"].text.text = Language.OneYuanSnatch.QiangGou
			UI:SetButtonEnabled(self.node_list["BtnBuy"], true)

			local pur_chase_info = OneYuanSnatchData.Instance:GetCloudPurchaseInfoByIndex(cell_index)
			local cell_timestamp = OneYuanSnatchData.Instance:GetCanBuyTimeStampByIndex(cell_index) or 0
			local gap_time = 0

			if cell_timestamp > 0 then
				gap_time = cell_timestamp - TimeCtrl.Instance:GetServerTime()
				if gap_time > 0 then
					OneYuanSnatchCtrl.Instance:SetCellCountDown(gap_time)
				end
			end

			if pur_chase_info and pur_chase_info.total_buy_times then
				self.node_list["TxtNum"].text.text = string.format(Language.OneYuanSnatch.GetNum, pur_chase_info.total_buy_times or 0, self.data.need_count or 0)
				if (self.data.need_count and pur_chase_info.total_buy_times >= self.data.need_count) or (gap_time > 0) then
					self.node_list["TxtButton"].text.text = Language.OneYuanSnatch.isReward
					UI:SetButtonEnabled(self.node_list["BtnBuy"], false)
				end
				local num1 = ((self.data.need_count and pur_chase_info.total_buy_times >= self.data.need_count) or (gap_time > 0)) and self.data.need_count or pur_chase_info.total_buy_times
				self.node_list["TxtNum"].text.text = string.format(Language.OneYuanSnatch.GetNum, num1 or 0, self.data.need_count or 0)
			end

		elseif self.view_type == "integral" then

			if self.data.item_id then
				item_data = OneYuanSnatchData.Instance:ParseIntergralItemId(self.data.item_id)
			end
			item_id = item_data and item_data.item_id or 0

			cell_index = self.index + ((self.parent_view.index or 1) - 1) * 3

			self.node_list["TxtExchangeTimes"].text.text = string.format(Language.OneYuanSnatch.ExchangeLimint, self.data.convert_count_limit or 0)
			self.node_list["TxtNeedScore"].text.text = string.format(Language.OneYuanSnatch.IntergralNeedScore , self.data.cost_score or 0)

			self.node_list["TxtButton"].text.text = Language.OneYuanSnatch.ExChange
			UI:SetButtonEnabled(self.node_list["BtnBuy"], true)

			local item_info = OneYuanSnatchData.Instance:PurchaseConvertInfoByItemId(item_id)

			if item_info and item_info.convert_count and self.data.convert_count_limit and item_info.convert_count >= self.data.convert_count_limit then
				self.node_list["TxtButton"].text.text = Language.OneYuanSnatch.isExChange
				UI:SetButtonEnabled(self.node_list["BtnBuy"], false)
			end
		end
 
		local cfg = OneYuanSnatchData.Instance:GetItemIdCfg(item_id)
		item_name = cfg and cfg.name or "" 

		self.node_list["TxtName"].text.text = item_name
		self.item_cell:SetData(item_data)
	end
end

function SnatchCell:OnBuyClick()
	if not self.data then return end

	if self.view_type == "ticket" then
	
		if self.data.rmb_price then
			RechargeCtrl.Instance:Recharge(self.data.rmb_price)
		end

	elseif self.view_type == "snatch" then
		self:OnQiangGouClick()

	elseif self.view_type == "integral" then
		self:OnDuiHuanClick()
	end
end

function SnatchCell:OnQiangGouClick()
	if self.parent_view and self.data.seq then
		local buy_count = self.parent_view:GetBugCount() or 1
		OneYuanSnatchCtrl.Instance:SendOperate(RA_CLOUDPURCHASE_OPERA_TYPE.RA_CLOUDPURCHASE_OPERA_TYPE_BUY , self.data.seq, buy_count)
	end
end

function SnatchCell:OnDuiHuanClick()
	if self.data.seq then
		OneYuanSnatchCtrl.Instance:SendOperate(RA_CLOUDPURCHASE_OPERA_TYPE.RA_CLOUDPURCHASE_OPERA_TYPE_CONVERT, self.data.seq, 1)
	end
end



