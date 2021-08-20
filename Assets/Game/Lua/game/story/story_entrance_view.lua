StoryEntranceView = StoryEntranceView or BaseClass(BaseView)

function StoryEntranceView:__init()
	self.ui_config = {{"uis/views/story_prefab", "StoryEntranceView"}}
	self.enter_callback = nil
	self.remain_time = 0
	self.close_time_stamp = 0
	self.guide_fb_type = 0

	self.guide_fb_type_map = {}
	self.guide_fb_type_map[GUIDE_FB_TYPE.ROBERT_BOSS] = "BossEntrance"
	self.guide_fb_type_map[GUIDE_FB_TYPE.BE_ROBERTED_BOSS] = "BossEntrance"
	self.guide_fb_type_map[GUIDE_FB_TYPE.GONG_CHENG_ZHAN] = "GongchengEntrance"
	self.guide_fb_type_map[GUIDE_FB_TYPE.SHUIJING] = "ShuijingEntrance"
end

function StoryEntranceView:__delete()

end

function StoryEntranceView:SetEnterCallback(enter_callback)
	self.enter_callback = enter_callback
end

function StoryEntranceView:SetGuideFbType(guide_fb_type)
	self.guide_fb_type = guide_fb_type
end

function StoryEntranceView:ReleaseCallBack()
	
end

function StoryEntranceView:LoadCallBack()

	self.node_list["BtnClose"].button:AddClickListener(BindTool.Bind(self.OnClickClose,self))
	self.node_list["BtnClose2"].button:AddClickListener(BindTool.Bind(self.OnClickClose,self))
	self.node_list["BtnClose3"].button:AddClickListener(BindTool.Bind(self.OnClickClose,self))
	self.node_list["BtnGo"].button:AddClickListener(BindTool.Bind(self.OnClickEnterFb,self))
	self.node_list["BtnGo2"].button:AddClickListener(BindTool.Bind(self.OnClickEnterFb,self))
	self.node_list["BtnGo3"].button:AddClickListener(BindTool.Bind(self.OnClickEnterFb,self))

end

function StoryEntranceView:OpenCallBack()
	self.remain_time = 10
	local time_txt = string.format(Language.Story.AutoTimeEnter, self.remain_time)
	self:SetTimeShow(time_txt)
	self.count_down = CountDown.Instance:AddCountDown(self.remain_time, 1, BindTool.Bind(self.UpdateTime, self))

	for _, v in pairs(self.guide_fb_type_map) do
		self.node_list[v]:SetActive(false)
	end

	local act_name = self.guide_fb_type_map[self.guide_fb_type]
	if nil ~= act_name then
		self.node_list[act_name]:SetActive(true)
	end
end

function StoryEntranceView:CloseCallBack()
	self:RemoveCountDown()
	self.close_time_stamp = Status.NowTime
end

function StoryEntranceView:GetCloseTimeStamp()
	return self.close_time_stamp
end

function StoryEntranceView:UpdateTime(elapse_time, total_time)
	self.remain_time = total_time - elapse_time
	local time_txt = string.format(Language.Story.AutoTimeEnter, math.ceil(self.remain_time))
	self:SetTimeShow(time_txt)

	if self.remain_time <= 0 then
		self.remain_time = 0
		self:RemoveCountDown()
		self:OnClickEnterFb()
	end
end

function StoryEntranceView:RemoveCountDown()
	if self.count_down then
		CountDown.Instance:RemoveCountDown(self.count_down)
		self.count_down = nil
	end
end

function StoryEntranceView:OnClickEnterFb()
	self:Close()

	if nil ~= self.enter_callback then
		self.enter_callback()
	end
end

function StoryEntranceView:OnClickClose()
	self:Close()
end

--设置时间Txt显示
function StoryEntranceView:SetTimeShow(time_txt)
	self.node_list["Txt_time"].text.text = time_txt
	self.node_list["Txt_time2"].text.text = time_txt
	self.node_list["Txt_time2"].text.text = time_txt
end