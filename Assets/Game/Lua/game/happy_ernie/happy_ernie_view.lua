HappyErnieView = HappyErnieView or BaseClass(BaseView)

local MAX_RARE_SHOW_NUM = 6
local MAX_BUTTON_NUM = 3

local HAPPYERNIE_OPERATE_PARAM = {
	[1] = RA_HAPPYERNIE_CHOU_TYPE.RA_HAPPYERNIE_CHOU_TYPE_1,
	[2] = RA_HAPPYERNIE_CHOU_TYPE.RA_HAPPYERNIE_CHOU_TYPE_10,
	[3] = RA_HAPPYERNIE_CHOU_TYPE.RA_HAPPYERNIE_CHOU_TYPE_30,
}
local HAPPYERNIE_CHESTSHOP_MODE = {
	[1] = CHEST_SHOP_MODE.CHEST_HAPPY_ERNIE_MODE_1,
	[2] = CHEST_SHOP_MODE.CHEST_HAPPY_ERNIE_MODE_10,
	[3] = CHEST_SHOP_MODE.CHEST_HAPPY_ERNIE_MODE_30,
}

function HappyErnieView:__init()
	self.ui_config = {
		{"uis/views/commonwidgets_prefab", "BaseActivityPanelFour"},
		{"uis/views/serveractivity/happyernie_prefab", "HappyErnie"}
	}
	self.is_modal = true
	self.open_tween = UITween.ShowFadeUp
	self.close_tween = UITween.HideFadeUp
	self.play_audio = true
end

function HappyErnieView:__delete()

end

function HappyErnieView:Open()
	if not ActivityData.Instance:GetActivityIsOpen(ACTIVITY_TYPE.RAND_ACTIVITY_TYPE_HAPPYERNIE) then
		SysMsgCtrl.Instance:ErrorRemind(Language.Activity.HuoDongWeiKaiQi)
		return
	end
	BaseView.Open(self)
end

--加载回调
function HappyErnieView:LoadCallBack()
	self.diamond_num_list = {}
	self.draw_lot_ani = {}
	self.is_have_key = false
	self.node_list["Name"].text.text = Language.HappyErnie.Name

	self.node_list["FreeTxt"].text.text = Language.HappyErnie.TreasureHunt[1]
	self.node_list["LeiJiTxt"].text.text = Language.HappyErnie.LeiJi
	self.node_list["StoreBtnTxt"].text.text = Language.Activity.WareHose
	self.node_list["LuckTxt"].text.text = Language.Activity.Lucker

	self.node_list["MianFeiTime"].gameObject:SetActive(false)
	self.node_list["FreeTxt"].gameObject:SetActive(false)
	-- 保底奖励
	self.reward_list = self.node_list["ListView"]
	local list_delegate = self.reward_list.list_simple_delegate
	list_delegate.NumberOfCellsDel = BindTool.Bind(self.GetLengthsOfCell, self)
	list_delegate.CellRefreshDel = BindTool.Bind(self.RefreshCell, self)
	self.happy_ernie_reward_item_list = {}

	-- 珍稀展示
	self.rare_reward_list = {}
	for i = 1, MAX_RARE_SHOW_NUM do
		self.rare_reward_list[i] = ItemCell.New()
		self.rare_reward_list[i]:SetInstanceParent(self.node_list["Point"..i].gameObject)
		self.rare_reward_list[i]:SetIndex(i)
	end

	for i = 1, MAX_BUTTON_NUM do
		self.node_list["Button" .. i].button:AddClickListener(BindTool.Bind(self.OnClickDraw, self, i))
		self.node_list["BtnTxt" .. i].text.text = Language.HappyErnie.TreasureHunt[51 + i]
	end
	self.node_list["BtnClose"].button:AddClickListener(BindTool.Bind(self.OnCloseClick, self))
	self.node_list["StoreBtn"].button:AddClickListener(BindTool.Bind(self.OnWareHoseClick, self))
	self.node_list["LuckyBtn"].button:AddClickListener(BindTool.Bind(self.OnClickLucker, self))
end

--打开界面的回调
function HappyErnieView:OpenCallBack()
	HappyErnieData.Instance:SetIsOpen()
	HappyErnieData.Instance:FlushHallRedPoindRemind()
	-- KaifuActivityCtrl.Instance:SendGetKaifuActivityInfo(ACTIVITY_TYPE.RAND_ACTIVITY_TYPE_HAPPYERNIE,RA_HAPPYERNIE_OPERA_TYPE.RA_HAPPYERNIE_OPERA_TYPE_QUERY_INFO)
	self:Flush()
end

--关闭界面的回调
function HappyErnieView:CloseCallBack()
	-- override
end

--关闭界面释放回调
function HappyErnieView:ReleaseCallBack()

	for i = 1, MAX_BUTTON_NUM do
		self.diamond_num_list[i] = nil
		self.draw_lot_ani[i] = nil
	end
	self.diamond_num_list = {}
	self.draw_lot_ani = {}

	for k, v in pairs(self.rare_reward_list) do
		v:DeleteMe()
	end
	self.rare_reward_list = {}

	for k, v in pairs(self.happy_ernie_reward_item_list) do
		v:DeleteMe()
	end
	self.happy_ernie_reward_item_list = {}
	self.reward_list = {}

	if self.time_quest then
		GlobalTimerQuest:CancelQuest(self.time_quest)
		self.time_quest = nil
	end

	--释放计时器
	if CountDown.Instance:HasCountDown(self.count_down) then
		CountDown.Instance:RemoveCountDown(self.count_down)
		self.count_down = nil
	end

	self:ClearClickDelay()
end

function HappyErnieView:GetLengthsOfCell()
	return #HappyErnieData.Instance:GetHappyErnieRewardItemConfig()
end

--刷新奖励格子
function HappyErnieView:RefreshCell(cell, cell_index)
	local item_cell = self.happy_ernie_reward_item_list[cell]
	if nil == item_cell then
		item_cell = HappyErnieRewardItem.New(cell.gameObject, self)
		self.happy_ernie_reward_item_list[cell] = item_cell
	end
	
	local data_list = HappyErnieData.Instance:GetHappyErnieRewardItemConfig()
	item_cell:SetIndex(cell_index)
	item_cell:SetData(data_list[cell_index + 1])
end

--刷新
function HappyErnieView:OnFlush()
	--刷新时间
	if self.time_quest == nil then
		self.time_quest = GlobalTimerQuest:AddRunQuest(BindTool.Bind(self.FlushNextTime, self), 1)
		self:FlushNextTime()
	end

	--读取珍稀展示配置
	local ernie_rare_show = HappyErnieData.Instance:GetHappyErnieCfgByList()
	for i = 1, MAX_RARE_SHOW_NUM do
		if nil == ernie_rare_show[i] then
			break
		end
		self.rare_reward_list[i]:SetData(ernie_rare_show[i].reward_item )
	end

	self.reward_list.scroller:ReloadData(0)

	--释放计时器
	if CountDown.Instance:HasCountDown(self.count_down) then
		CountDown.Instance:RemoveCountDown(self.count_down)
		self.count_down = nil
	end

	--抽奖次数进度
	self.node_list["NumTxt"].text.text = HappyErnieData.Instance:GetChouTimes() or 0
	-- self.total_count:SetValue(draw_times)

	local key_num, key_cfg = HappyErnieData.Instance:GetHappyErnieKeyNum()
	if nil ~= key_cfg and key_num ~= nil then
		self.is_have_key = key_num > 0
		-- local key_color = key_cfg.color
		-- local key_name = key_cfg.name
		-- local key_str = ToColorStr(key_num, SOUL_NAME_COLOR[key_color])
		self.node_list["Keys"].text.text = key_num
		-- self.key_num = key_str
	end

	--下次免费时间
	local next_free_tao_timestamp = HappyErnieData.Instance:GetNextFreeTaoTimestamp()
	if next_free_tao_timestamp == nil or next_free_tao_timestamp == 0 then
		self.next_free_time = false
		self.node_list["MianFeiTime"].gameObject:SetActive(false)
		self.is_free = false
		self.red_point = false
	else
		self.next_free_time = true
		-- self.next_free_time:SetValue(true)
		local server_time = TimeCtrl.Instance:GetServerTime()
		if server_time - next_free_tao_timestamp >= 0 then
			self:FlushFreeTime(true)
		else
			self.count_down = CountDown.Instance:AddCountDown(next_free_tao_timestamp - server_time, 1, BindTool.Bind(self.FlushCountDown, self))
		end
	end

	--读取消费价格
	local draw_gold_list = HappyErnieData.Instance:GetHappyErnieDrawCost()
	if nil ~= draw_gold_list then
		self.node_list["Text1"].text.text = draw_gold_list.once_gold
		self.node_list["Text1"].gameObject:SetActive(not self.is_free)
		self.node_list["FreeTxt"].gameObject:SetActive(self.is_free)
		self.node_list["FreeRemind"].gameObject:SetActive(self.is_free)
		self.node_list["Text2"].text.text = draw_gold_list.tenth_gold
		self.node_list["Text3"].text.text = draw_gold_list.thirtieth_gold
		self.node_list["Text3"].gameObject:SetActive(not self.is_have_key)
		self.node_list["Keys"].gameObject:SetActive(self.is_have_key)
		self.node_list["KeyRemind"].gameObject:SetActive(self.is_have_key)
	end
end

--计时器
function HappyErnieView:FlushCountDown(elapse_time, total_time)
	local time_interval = total_time - elapse_time
	if time_interval > 0 then
		self:FlushFreeTime(false)
		self.node_list["MianFeiTime"].text.text = TimeUtil.FormatSecond2HMS(time_interval) .. Language.HappyErnie.FreeTime
	else
		self:FlushFreeTime(true)
	end
end

function HappyErnieView:FlushFreeTime(isfree)
	self.is_free = isfree
	self.red_point = isfree
	self.node_list["MianFeiTime"].gameObject:SetActive(not isfree)
	self.node_list["FreeTxt"].gameObject:SetActive(isfree)
	self.node_list["FreeRemind"].gameObject:SetActive(isfree)
	self.node_list["Text1"].gameObject:SetActive(not isfree)
end

function HappyErnieView:FlushNextTime()
	local time = ActivityData.Instance:GetActivityResidueTime(ACTIVITY_TYPE.RAND_ACTIVITY_TYPE_HAPPYERNIE)
	if time <= 0 then
		if self.time_quest then
			GlobalTimerQuest:CancelQuest(self.time_quest)
			self.time_quest = nil
		end
	end

	local time_str = ""
	local timer = TimeUtil.Format2TableDHMS(time)
	if timer.day > 0 then
		time_str = string.format(Language.Activity.ActivityTime8, timer.day, timer.hour)
	else
		time_str = string.format(Language.Activity.ActivityTime9, timer.hour, timer.min, timer.s)
	end
	self.node_list["TxtTime"].text.text = time_str
end


function HappyErnieView:OnCloseClick()
	self:Close()
end

function HappyErnieView:OnWareHoseClick()
	ViewManager.Instance:Open(ViewName.TipsTreasureWarehouseView)
end

function HappyErnieView:ClearClickDelay()
	if self.send_delay then
		GlobalTimerQuest.CancelQuest(self.send_delay)
		self.send_delay = nil
	end
end

function HappyErnieView:OnClickDraw(index)
	local activity_type = ACTIVITY_TYPE.RAND_ACTIVITY_TYPE_HAPPYERNIE
	local operate_type = RA_HUANLE_YAOJIANG_OPERA_TYPE.RA_HUANLEYAOJIANG_OPERA_TYPE_TAO
	local param_1 = HAPPYERNIE_OPERATE_PARAM[index]
	HappyErnieData.Instance:SetChestShopMode(HAPPYERNIE_CHESTSHOP_MODE[index])
	self.node_list["Anim" .. index].animator:SetTrigger("draw")

	self:ClearClickDelay()
	self.send_delay = GlobalTimerQuest:AddDelayTimer(function ()
		KaifuActivityCtrl.Instance:SendGetKaifuActivityInfo(activity_type, operate_type, param_1)
		end, 0.4)
end

function HappyErnieView:OnClickLucker()
	ActivityCtrl.Instance:SendActivityLogSeq(ACTIVITY_TYPE.RAND_ACTIVITY_TYPE_HAPPYERNIE)
end


-------------------------------------------保底奖励-------------------------------------------------------
HappyErnieRewardItem = HappyErnieRewardItem or BaseClass(BaseCell)
function HappyErnieRewardItem:__init()
	self.item_cell = ItemCell.New()
	self.item_cell:SetInstanceParent(self.node_list["Item"])
	self.item_cell:ListenClick(BindTool.Bind(self.OnClickReward, self))
	self.item_cell:ShowHighLight(false)

	self.is_got = false
	self.can_get = false

	self.seq = 0
end

function HappyErnieRewardItem:__delete()
	if self.item_cell then
		self.item_cell:DeleteMe()
		self.item_cell = nil
	end
end

function HappyErnieView:SetIndex(index)
	self.index = index
end

function HappyErnieRewardItem:SetData(data)
	if nil == data then return end
	self.item_cell:SetData(data.reward_item)
	self.seq = data.index
	local is_got = HappyErnieData.Instance:GetIsFetchFlag(self.seq)
	local can_get_times = HappyErnieData.Instance:GetCanFetchFlagByIndex(self.seq)
	local draw_times = HappyErnieData.Instance:GetChouTimes()
	self.is_got = is_got
	self.can_get = draw_times >= can_get_times and not is_got
	self.node_list["Effect"].gameObject:SetActive(self.can_get)
	self.node_list["Gou"].gameObject:SetActive(self.is_got)
	self.node_list["Text"].text.text = can_get_times..Language.Common.TimesNumber
end

function HappyErnieRewardItem:OnClickReward()
	if self.can_get or self.is_got then
		KaifuActivityCtrl.Instance:SendGetKaifuActivityInfo(ACTIVITY_TYPE.RAND_ACTIVITY_TYPE_HAPPYERNIE,RA_HUANLE_YAOJIANG_OPERA_TYPE.RA_HUANLEYAOJIANG_OPERA_TYPE_FETCH_REWARD, self.seq)
	else
		if self.item_cell then
			self.item_cell:OnClickItemCell()
		end
	end
end
