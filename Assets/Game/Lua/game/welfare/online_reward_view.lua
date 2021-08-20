OnLineRewardView = OnLineRewardView or BaseClass(BaseView)

function OnLineRewardView:__init()
	self.ui_config = {{"uis/views/welfare_prefab", "OnlineRewardView"}}
	self.play_audio = true
	-- self.view_layer = UiLayer.Pop
	self.can_get = false			--是否可领取

	self.is_modal = true
	self.is_any_click_close = true
	self.open_tween = UITween.ShowFadeUp
	self.close_tween = UITween.HideFadeUp

	self.item_list = {}
end

function OnLineRewardView:ReleaseCallBack()
	for k, v in ipairs(self.item_list) do
		v.cell:DeleteMe()
	end
	self.item_list = {}
end

function OnLineRewardView:LoadCallBack()
	self.item_list = {}
	for i = 1, 3 do
		local item_obj = self.node_list["ItemCell" .. i]
		local item_cell = ItemCell.New()
		item_cell:SetInstanceParent(item_obj)
		item_cell:SetData(nil)
		table.insert(self.item_list, {obj = item_obj, cell = item_cell })
	end

	self.node_list["BtnClose"].button:AddClickListener(BindTool.Bind(self.CloseWindow, self))
	self.node_list["BtnClickBtn"].button:AddClickListener(BindTool.Bind(self.ClickBtn, self))
end

function OnLineRewardView:CloseCallBack()
	self:StopCountDown()

	self.uicamera = nil
	self.uilayer = nil
end

function OnLineRewardView:OpenCallBack()
	self.auto_close = false
	self:Flush()
end

function OnLineRewardView:StartMove()
	local main_view = MainUICtrl.Instance:GetView()
	if nil == main_view then
		return
	end
	local target_obj = main_view:GetPackageBtn()
	if nil == target_obj then
		return
	end
	for k, v in ipairs(self.item_list) do
		local item_obj = v.obj
		local item_cell = v.cell
		if item_obj.gameObject.activeInHierarchy then
			local item_data = item_cell:GetData()
			TipsCtrl.Instance:OpenMoveItemView(item_data, item_obj, target_obj, 1, true, PUT_REASON_TYPE.PUT_REASON_ONLINE_REWARD)
		end
	end
end

function OnLineRewardView:StopCountDown()
	if self.count_down then
		CountDown.Instance:RemoveCountDown(self.count_down)
		self.count_down = nil
	end
end

function OnLineRewardView:StarCountDown(time)
	local function timer_func(elapse_time, total_time)
		if not self:IsOpen() then
			self:StopCountDown()
			return
		end
		
		if elapse_time >= total_time then
			self:StopCountDown()
			self.can_get = true
			self.node_list["TxtTimeText"].text.text = ""
			self.node_list["TxtBtnText"].text.text = Language.Common.LingQuJiangLi
			return
		end

		local diff_sec = math.ceil(total_time - elapse_time)
		local time_str = ""
		if diff_sec >= 3600 then
			--大于一小时的三位数
			time_str = TimeUtil.FormatSecond(diff_sec)
		else
			time_str = TimeUtil.FormatSecond(diff_sec, 2)
		end
		local des = string.format(Language.Welfare.TimeToReward, time_str)
		self.node_list["TxtTimeText"].text.text = des
	end
	self.count_down = CountDown.Instance:AddCountDown(time, 1, timer_func)
end

function OnLineRewardView:OnFlush(param_t)
	if param_t.start_move then
		self:StartMove()
	end
	self:StopCountDown()

	local reward_data, is_all_get = WelfareData.Instance:GetOnlineReward()
	local online_time = WelfareData.Instance:GetTotalOnlineTime()
	local reward_item_data = reward_data.reward_item
	if not reward_item_data or not next(reward_item_data) then
		return
	end

	local des = ""
	local btn_text = ""
	if is_all_get then
		btn_text = Language.Common.IsAllGet
		self.can_get = false
		self:Close()
	else
		local reward_need_sec = (reward_data.minutes) * 60
		local diff_sec = online_time - reward_need_sec

		if diff_sec > 0 then
			self.can_get = true
			btn_text = Language.Common.LingQuJiangLi
		else
			if self.auto_close then
				self:Close()
			end
			self.can_get = false
			diff_sec = math.abs(diff_sec)
			self:StarCountDown(diff_sec)

			local time_str = ""
			if diff_sec >= 3600 then
				--大于一小时的三位数
				time_str = TimeUtil.FormatSecond(diff_sec)
			else
				time_str = TimeUtil.FormatSecond(diff_sec, 2)
			end
			des = string.format(Language.Welfare.TimeToReward, time_str)
			btn_text = Language.Common.AfterLater
		end
	end
	self.node_list["TxtTimeText"].text.text = des
	self.node_list["TxtBtnText"].text.text = btn_text

	for k, v in ipairs(self.item_list) do
		local item_data = reward_item_data[k-1]
		if item_data then
			v.obj:SetActive(true)
			v.cell:SetData(item_data)
		else
			v.obj:SetActive(false)
		end
	end
end

function OnLineRewardView:CloseWindow()
	self:Close()
end

function OnLineRewardView:ClickBtn()
	if self.can_get then
		local reward_data = WelfareData.Instance:GetOnlineReward()
		local seq = reward_data.seq
		self.auto_close = true
		WelfareCtrl.Instance:SendGetOnlineReward(seq)
	else
		self:Close()
	end
end