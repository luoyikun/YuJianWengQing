ChatTeamView = ChatTeamView or BaseClass(BaseRender)

function ChatTeamView:__init()
	self.cell_list = {}
	self.team_list = {}
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
	end
end

function ChatTeamView:__delete()
	for k, v in pairs(self.cell_list) do
		v:DeleteMe()
	end
	self.cell_list = {}
end

function ChatTeamView:FlushTeamView()
	local chat_list = ChatData.Instance:GetChannel(CHANNEL_TYPE.TEAM) or {}
	self.team_list = chat_list.msg_list or {}
	local is_lock = ChatData.Instance:GetIsLockState()
	if is_lock then
		self.chat_list_view.scroller:RefreshAndReloadActiveCellViews(true)
	else
		self.chat_list_view.scroller:ReloadData(1)
	end
end

function ChatTeamView:FlushUnreadState()
	if self.chat_list_view then
		self.chat_list_view.scroller:ReloadData(1)
	end
end

function ChatTeamView:GetCellSizeDel(data_index)
	data_index = data_index + 1
	local team_list = self.team_list[data_index]
	local height = ChatData.Instance:GetChannelItemHeight(CHANNEL_TYPE.TEAM, team_list.msg_id)
	if height <= 0 then
		height = ChatCtrl.Instance:CaleChatHeight(CHANNEL_TYPE.TEAM, team_list)
	end
	return height
end

function ChatTeamView:GetNumberOfCells()
	return #self.team_list or 0
end

function ChatTeamView:RefreshCell(cell, data_index)
	data_index = data_index + 1
	local chat_cell = self.cell_list[cell]
	if chat_cell == nil then
		chat_cell = ChatCell.New(cell.gameObject)
		self.cell_list[cell] = chat_cell
	end

	chat_cell:SetIndex(data_index)
	chat_cell:SetData(self.team_list[data_index])
	chat_cell:SetMainChatFlag()
	ChatData.Instance:RemoveChatChannelUnreadMsgByMsgId(self.team_list[data_index].msg_id, CHANNEL_TYPE.TEAM)
	if self.call_back then
		self.call_back()
	end
end

function ChatTeamView:SetListenerCallBack(call_back)
	self.call_back = call_back
end