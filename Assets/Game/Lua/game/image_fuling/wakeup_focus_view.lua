WakeUpFocusView = WakeUpFocusView or BaseClass(BaseView)

local GroupNumber = 4
local focus_number = 0
function WakeUpFocusView:__init()
	self.ui_config = {
		{"uis/views/commonwidgets_prefab", "BaseThreePanel"},
		{"uis/views/imagefuling_prefab", "WakeUpFocusView"},
	}
	self.is_modal = true
	self.is_any_click_close = true
	self.open_tween = UITween.ShowFadeUp
	self.close_tween = UITween.HideFadeUp
end

function WakeUpFocusView:__delete()

end

function WakeUpFocusView:LoadCallBack()
	self.node_list["Bg"].rect.sizeDelta = Vector3(690, 650, 0)
	self.node_list["Txt"].text.text = Language.ImageFuLing.SkillShow
	self.node_list["BtnClose"].button:AddClickListener(BindTool.Bind(self.Close, self))
	self.role_cell_list = {}
	local list_delegate = self.node_list["List"].list_simple_delegate
	list_delegate.NumberOfCellsDel = BindTool.Bind(self.NumberOfCells, self)
	list_delegate.CellRefreshDel = BindTool.Bind(self.CellRefresh, self)
end

function WakeUpFocusView:ReleaseCallBack()
	focus_number = 0
	for k,v in pairs(self.role_cell_list) do
		v:DeleteMe()
		v = nil
	end
	self.role_cell_list = nil
end

function WakeUpFocusView:OpenCallBack()

end

function WakeUpFocusView:CloseCallBack()

end

function WakeUpFocusView:OnFlush()

end

function WakeUpFocusView:NumberOfCells()
	return WakeUpFocusData.Instance:GetSkillListTypeNum()
end

function WakeUpFocusView:CellRefresh(cell, cell_index)
	cell_index = cell_index + 1
	local item_cell = self.role_cell_list[cell]
	local skill_list = WakeUpFocusData.Instance:GetSkillCfg()
	if not item_cell then
		item_cell = WakeUpFocusGroup.New(cell.gameObject)
		self.role_cell_list[cell] = item_cell
	end
	item_cell:SetIndex(cell_index)
	local right_index = WakeUpFocusData.Instance:GetCorrectIndex(cell_index)
	if skill_list[right_index] then
		item_cell:SetData(skill_list[right_index])
	end
end

-----------------------------------------------------------------------------------------------------------------------

WakeUpFocusCell = WakeUpFocusCell or BaseClass(BaseCell)

function WakeUpFocusCell:__init()
	self.item_cell = ItemCell.New()
	self.item_cell:SetInstanceParent(self.node_list["ItemCell"])
	self.node_list["toggle"].toggle:AddValueChangedListener(BindTool.Bind(self.ToggleChange, self))
end

function WakeUpFocusCell:__delete()
	if nil ~= self.item_cell then
		self.item_cell:DeleteMe()
		self.item_cell = nil
	end
end

function WakeUpFocusCell:OnFlush()
	if nil == self.data then
		return
	end
	local item_name = ItemData.Instance:GetItemName(self.data.book_id)
	self.item_cell:SetData({item_id = self.data.book_id})
	self.node_list["TextName"].text.text = item_name
	self.node_list["toggle"].toggle.isOn = WakeUpFocusData.Instance:IsFocus(self.data.skill_id)
end

function WakeUpFocusCell:ToggleChange(ison)
	if ison then
		if focus_number == TALENT_ATTENTION_SKILL_MAX_SAVE_NUM then
			focus_number = focus_number + 1
			self.node_list["toggle"].toggle.isOn = false
			TipsCtrl.Instance:ShowSystemMsg(Language.FocusTips.MostFocus)
			return
		end
	end
	self.is_focus = ison
	if ison then
		focus_number = focus_number + 1
	else
		focus_number = focus_number - 1
	end
	if WakeUpFocusData.Instance:IsFocus(self.data.skill_id) ~= ison then
		local oper_type = ison and TALENT_OPERATE_TYPE.TALENT_OPERATE_TYPE_SKILL_FOCUS or TALENT_OPERATE_TYPE.TALENT_OPERATE_TYPE_SKILL_CANCLE_FOCUS
		ImageFuLingCtrl.Instance:SendTalentOperaReq(oper_type, self.data.skill_id)
	end
end

WakeUpFocusGroup = WakeUpFocusGroup or BaseClass(BaseCell)

function WakeUpFocusGroup:__init()
	self.cell = {}
	for i = 1, 4 do
		self.cell[i] = WakeUpFocusCell.New(self.node_list["ItemCell" .. i])
	end
end

function WakeUpFocusGroup:__delete()
	for k,v in pairs(self.cell) do
		v:DeleteMe()
		v = nil
	end
end

function WakeUpFocusGroup:OnFlush()
	if nil == self.data then
		return
	end
	
	for i = 1, 4 do
		self.cell[i]:SetData(self.data[i - 1])
	end
end