ChatSystemView = ChatSystemView or BaseClass(BaseRender)

function ChatSystemView:__init()
	self.cell_list = {}
	self.system_list = {}
	self.is_show = true
	local transform = self.root_node.transform:FindHard("ChatList")
	if transform ~= nil then
		self.chat_list_view = U3DObject(transform.gameObject, transform, self)
	end
	local scroller_delegate = self.chat_list_view.list_simple_delegate
	scroller_delegate.CellSizeDel = BindTool.Bind(self.GetCellSizeDel, self)
	scroller_delegate.NumberOfCellsDel = BindTool.Bind(self.GetNumberOfCells, self)
	scroller_delegate.CellRefreshDel = BindTool.Bind(self.RefreshCell, self)

	self.chat_list_view.scroller.scrollerScrolled = function()
		local position = self.chat_list_view.scroller.ScrollPosition
		position = position < 0 and 0 or position
		position = math.floor(position)
		local scroll_size = self.chat_list_view.scroller.ScrollSize
		if scroll_size < 10 then
			return
		end
		if position >= scroll_size then
			ChatCtrl.Instance:ChangeLockState(false)
		else
			ChatCtrl.Instance:ChangeLockState(true)
		end

		if self.is_show then
			self.chat_list_view.scroller:ReloadData(1)
			self.is_show = false
		end
	end
end

function ChatSystemView:__delete()
	print("ChatSystemView.Release")
	for k, v in pairs(self.cell_list) do
		if v then
			v:DeleteMe()
		end
	end
	self.cell_list = {}
end

function ChatSystemView:FlushSystemView()
	local chat_list = ChatData.Instance:GetChannel(CHANNEL_TYPE.SYSTEM) or {}
	self.system_list = chat_list.msg_list or {}

	if not self.chat_list_view.gameObject.activeInHierarchy then
		return
	end

	local is_lock = ChatData.Instance:GetIsLockState()
	if is_lock then
		self.chat_list_view.scroller:RefreshAndReloadActiveCellViews(true)
	else
		self.chat_list_view.scroller:ReloadData(1)
	end
end

function ChatSystemView:GetCellSizeDel(data_index)
	data_index = data_index + 1
	local system_list = self.system_list[data_index]
	local height = ChatData.Instance:GetChannelItemHeight(CHANNEL_TYPE.SYSTEM, system_list.msg_id)
	if height <= 0 then
		height = ChatCtrl.Instance:CaleChatHeight(CHANNEL_TYPE.SYSTEM, system_list)
	end
	return height
end

function ChatSystemView:GetNumberOfCells()
	return #self.system_list or 0
end

function ChatSystemView:RefreshCell(cell, data_index)
	data_index = data_index + 1
	local system_cell = self.cell_list[cell]
	if system_cell == nil then
		system_cell = ChatCell.New(cell.gameObject)
		system_cell.parent = self
		self.cell_list[cell] = system_cell
	end

	system_cell:SetIndex(data_index)
	system_cell:SetData(self.system_list[data_index])
	system_cell:SetMainChatFlag()
end