MarriageData = MarriageData or BaseClass()

MarriageData.QINGYUAN_COUPLE_HALO_MAX_TYPE = 16				--光环最大类型

QINGYUAN_COUPLE_HALO_REQ_TYPE = {
	QINGYUAN_COUPLE_REQ_TYPE_INFO = 0,						-- 请求信息
	QINGYUAN_COUPLE_REQ_TYPE_USE = 1,						-- 装备光环 param_1光环类型
	QINGYUAN_COUPLE_REQ_TYPE_UP_LEVEL = 2,					-- 光环升级 param_1光环类型 param_2是否自动购买
}

MARRIAGE_SELECT_TYPE = {
	MARRIAGE_SELECT_TYPE_SWEET = {index = 1, name = ViewName.WeddingTipsOne},			-- 温馨婚礼
	MARRIAGE_SELECT_TYPE_FESTIVA = {index = 2, name = ViewName.WeddingTipsTwo},			-- 喜庆婚礼
	MARRIAGE_SELECT_TYPE_LUXURY = {index = 3, name = ViewName.WeddingTipsThree},		-- 豪华婚礼
}

WEDDING_TIPS_POWER_TYPE = {
	RING = 0,
	SECONDGEAR = 1,
	THIRDGEAR = 2,
}

INVITE_TYPE = {
	FRIEND = 0,		--好友
	GUILD = 1,		--盟友
	OTHER = 2,		--其他
}

MarrGatherId = 6021002	--酒席id
WEDDING_ACTIVITY_LEVEL = 80

local person_position = {
	["loliCommon"] = {position = Vector3(0, 1.3, 3.52), rotation = Vector3(8.12, 180, 0)},				--萝莉普通
	["personCommon"] = {position = Vector3(0, 2.32, 3.76), rotation = Vector3(16.75, 180, 0)},			--普通
	["personHalo"] = {position = Vector3(0, 2.33, 3.9), rotation = Vector3(13.76, 180, 0)},				--普通光环界面
	["loliHalo"] = {position = Vector3(0, 1.43, 3.4), rotation = Vector3(5.24, 180, 0)},				--l萝莉光环界面
}

local DISABLE_TIME = 120  --多少秒提醒一次（策划改成只提醒一次）
local DISABLE_TIME2 = 10

function MarriageData:__init()
	if MarriageData.Instance then
		print_error("[MarriageData] Attempt to create singleton twice!")
		return
	end
	self.red_point_list = {
		["honeymoon_group"] = {
			["Ring"] = false,
			["Bless"] = false,
			["love_content"] = false,
			["Party"] = false,
		},
		["interact_group"] = {
			["halo_content"] = false,
			["love_tree"] = false,
		},
	}

	MarriageData.Instance = self
	self:SetCfg()
	self:GetMarriageConditions()
	self.get_invite_data = {}
	self.marryuser_list = {}
	self.wedding_by_info = {}
	self.yuyue_list_info = {}
	self.has_gather_list = {}
	self.yuyue_list_info = {}
	self.lover_level = 0
	self.lover_star = 0
	self.lover_ring_item_id = 0
	self.ring_item_id = 0
	self.self_hunyan_state = 0				--自己的婚宴状态
	self.today_putong_hunyan_times = 0				--今天开启的普通婚宴次数
	self.today_total_open_hunyan_times = 0			--今天开启的婚宴次数
	self.can_open = 0
	self.fuben_view_state = false
	self.fb_count = 0
	self.today_gather_times = 0				--今天采集酒席的次数
	self.active_state = 0
	self.is_show_eff = false
	self.is_show_bubble = false

	self.love_tree_state = 0
	self.love_tree_info = {}
	self.wedding_info = {}
	self.tuodan_list = {}
	self.qingyuan_fb = {}
	self.good_time_list = {}				--记录示好冷却时间
	self.send_tuo_dan_time = 0				--记录发送脱单宣言的时间
	self.select_time_seq = -1

	self.xunyou_pos = {
		is_own = 0,
		x = 0,
		y = 0,
		obj_id = 0,
		scene_id = 0,
	}
	self.role_msg_info = {
		marry_type = 0,
		marry_count = 0,
		marry_state = 0,
		param_ch4 = 0,
		param_ch5 = 0,
	}

	self.xunyou_info = {
		throw_count = 0,
		buy_throw_count = 0,
		flower_count = 0,
		buy_flower_count = 0,
		get_red_count = 0,
	}
	self.yuyue_info = {
		role_id = 0,
		role_name = "",
		lover_role_id = 0,
		lover_role_name = "",
		role_prof = 0,
		lover_role_prof = 0,
		wedding_type = 0,
		have_invite_num = 0,
		have_max_num = 20,
		wedding_yuyue_seq = 0,
		wedding_index =  0,
		count = 0,
		data = {},
	}
	self.hunyan_info = {
		role_id = 0,
		role_name = "",
		lover_role_id = 0,
		lover_role_name = "",
		role_prof = nil,
		lover_role_prof = nil,
		cur_wedding_seq =  0,
		wedding_index =  0,
		count = 0,
		guests_uid = {},
	}

	self.task_info_list = {}

	self.love_contract_info = {				-- 爱情契约信息数据
		self_love_contract_reward_flag = {},
		can_receive_day_num = -1,
		lover_love_contract_timestamp = 0,
		leaveword_list = {},
	}
	-- self.n_refresh_yanhua_time = 0 			--下次天降烟花时间
	self.is_use_bind_diamond = -1
	self.equiped_couple_halo_type = -1
	self.lover_couple_halo_level_list = {}

	self.applicant_info = {}

	self.blessing_info = {}					-- 祝福

	self.wedding_role_info = {}				-- 婚礼个人信息

	self.qingyuan_fb_rewardinfo = {
		reward_list = {},
	}		-- 情缘副本结果
	self.hunyan_time = 0
	self.xunyou_objid_list = {}

	self.is_today_buy_tejia_halo = 0

	RemindManager.Instance:Register(RemindName.MarryAffection, BindTool.Bind(self.GetMarryAffectionRemind, self))
	RemindManager.Instance:Register(RemindName.MarryRing, BindTool.Bind(self.GetRingRemind, self))
	RemindManager.Instance:Register(RemindName.MarryLoveContent, BindTool.Bind(self.GetQingyuanLoveContractReward, self))
	RemindManager.Instance:Register(RemindName.MarryParty, BindTool.Bind(self.GetMarryPartyRemind, self))
	RemindManager.Instance:Register(RemindName.MarryFuBen, BindTool.Bind(self.GetFuBenRemind, self))
	RemindManager.Instance:Register(RemindName.MarryShengDi, BindTool.Bind(self.GetShengDiRemind, self))
	RemindManager.Instance:Register(RemindName.MarryCoupHalo, BindTool.Bind(self.GetCoupleHaloRemind, self))
end

function MarriageData:__delete()
	RemindManager.Instance:UnRegister(RemindName.MarryAffection)
	RemindManager.Instance:UnRegister(RemindName.MarryRing)
	RemindManager.Instance:UnRegister(RemindName.MarryLoveContent)
	RemindManager.Instance:UnRegister(RemindName.MarryParty)
	RemindManager.Instance:UnRegister(RemindName.MarryFuBen)
	RemindManager.Instance:UnRegister(RemindName.MarryShengDi)
	RemindManager.Instance:UnRegister(RemindName.MarryCoupHalo)
	MarriageData.Instance = nil
	self:CancelCoutDown()
	self:CancelCoutDown2()
	self:CancelBubbleCoutDown()
end

function MarriageData:GetMarryNpcCfg()
	local data = {}
	data.marry_npc_id = self.marriage_condition.marry_npc_id
	data.marry_npc_scene_id = self.marriage_condition.marry_npc_scene_id
	return data
end

--是否已婚
function MarriageData:CheckIsMarry()
	local main_role_vo = GameVoManager.Instance:GetMainRoleVo()
	if main_role_vo.lover_uid ~= nil and main_role_vo.lover_uid ~= 0 then
		return true
	end
	return false
end

function MarriageData:SetActiveState(state)
	self.active_state = state
end

function MarriageData:GetActiveState()
	return self.active_state
end

--处理情缘
function MarriageData:GetMarryAffectionRemind()
	--欧式婚礼半折活动红点
	local main_role_id = GameVoManager.Instance:GetMainRoleVo().role_id
	local cur_day = TimeCtrl.Instance:GetCurOpenServerDay()
	local remind_day = PlayerPrefsUtil.GetInt("MarriageHoneymoonView" .. main_role_id) or cur_day
	local is_marry = self:CheckIsMarry()
	local is_open = ActivityData.Instance:GetActivityIsOpen(ACTIVITY_TYPE.RAND_ACTIVITY_TYPE_WEST_WEDDING)
	if cur_day ~= -1 and cur_day ~= remind_day and is_marry and is_open then
		return 1
	end	
	return 0
end

--处理戒指红点
function MarriageData:GetRingRemind()
	local flag = self:GetRingInfo()
	local main_role_vo = GameVoManager.Instance:GetMainRoleVo()
	if main_role_vo.lover_uid <= 0 then
		flag = 0
	end
	if flag > 1 then
		flag = 0
	end
	return flag
end

--获得相关红点
function MarriageData:GetRedPointByKey(key)
	local flag = false
	local temp_list = self.red_point_list[key]
	if temp_list then
		for k, v in pairs(temp_list) do
			if v then
				flag = true
				break
			end
		end
	else
		for _, v in pairs(self.red_point_list) do
			local temp_flag = v[key]
			if temp_flag ~= nil then
				flag = temp_flag
				break
			end
		end
	end
	return flag
end

--处理红点
function MarriageData:HandleRedPoint(key, value)
	for _, v in pairs(self.red_point_list) do
		if v[key] ~= nil then
			v[key] = value
			break
		end
	end
end

function MarriageData:SetCoutDown()
	self:CancelCoutDown()

	self.tiptime_cut_down = GlobalTimerQuest:AddDelayTimer(BindTool.Bind(self.CoutDown, self), DISABLE_TIME)

end

function MarriageData:CoutDown()
	self:CancelCoutDown()
	self.is_show_bubble = true
	MarriageCtrl.Instance:FlushMainViewBubble(true)
	self:SetCoutDown2()
end

function MarriageData:CancelCoutDown()
	if self.tiptime_cut_down ~= nil then
		GlobalTimerQuest:CancelQuest(self.tiptime_cut_down)
		self.tiptime_cut_down = nil
	end
end

function MarriageData:SetCoutDown2()
	self:CancelCoutDown2()

	self.tiptime_cut_down2 = GlobalTimerQuest:AddDelayTimer(BindTool.Bind(self.CoutDown2, self), DISABLE_TIME2)
end

function MarriageData:CoutDown2()
	self:CancelCoutDown2()
	self.is_show_bubble = false
	MarriageCtrl.Instance:FlushMainViewBubble(true)
	self:SetCoutDown()
end

function MarriageData:CancelCoutDown2()
	if self.tiptime_cut_down2 ~= nil then
		GlobalTimerQuest:CancelQuest(self.tiptime_cut_down2)
		self.tiptime_cut_down2 = nil
	end
end

function MarriageData:SetIsShowEff(bool)
	self.is_show_eff = bool
end

function MarriageData:GetIsShowEff()
	return self.is_show_eff
end

function MarriageData:SetIsShowBubble(bool)
	self.is_show_bubble = bool
	if bool then
		self:SetBubbleCountDown()
	else
		self:CancelBubbleCoutDown()
	end
end

function MarriageData:GetIsShowBubble()
	return self.is_show_bubble
end

function MarriageData:SetBubbleCountDown()
	self.bubble_count_down = GlobalTimerQuest:AddDelayTimer(function ()
		self:CancelBubbleCoutDown()
		MarriageData.Instance:SetIsShowBubble(false)
		if HUNYAN_STATUS.CLOSE ~= self:GetActiveState() then
			MainUICtrl.Instance:FlushTipsIcon(MainUIViewChat.IconList.WEEDING_GET_INVITE, true)
		end
	end, DISABLE_TIME2)
end

function MarriageData:CancelBubbleCoutDown()
	if self.bubble_count_down ~= nil then
		GlobalTimerQuest:CancelQuest(self.bubble_count_down)
		self.bubble_count_down = nil
	end
end

function MarriageData:SetCfg()
	local marriage_cfg = ConfigManager.Instance:GetAutoConfig("qingyuanconfig_auto")
	self.honeymoon_reward = marriage_cfg.honeymoon_reward
	self.marriage_condition = marriage_cfg.other[1]
	self.ring_upgrade_item = marriage_cfg.uplevel_stuff[1]
	self.wedding_type_cfg = marriage_cfg.marry_cfg
	self.hunli_cfg = marriage_cfg.hunli_type
	self.ring_cfg = marriage_cfg.uplevel
	self.honeymoon_reward = marriage_cfg.honeymoon_reward[1]
	self.bless_price = marriage_cfg.bless_price[1]
	self.divorce_cost = marriage_cfg.other[1].divorce_coin_cost						--强制离婚所需的花费的钻石
	self.decompose_item = marriage_cfg.other[1].hunjie_decompose_item
	self.divorce_intimacy_dec = marriage_cfg.other[1].divorce_intimacy_dec			--离婚会扣除的亲密度
	self.qingyuan_fb_buff = marriage_cfg.qingyuan_fb_buff[1]
	self.hunyan_activity = marriage_cfg.hunyan_activity[1]
	self.hunyan_cfg = marriage_cfg.hunyan_cfg[1]
	self.qingyuan_fb_reward = marriage_cfg.qingyuan_fb_reward
	self.tuodan_cfg = marriage_cfg.tuodan_list
	self.bless_cfg = marriage_cfg.wedding_blessing
	self.xunyou_cfg = marriage_cfg.hunyan_xunyou
	self.biaobai_cfg = marriage_cfg.profess_grade
	self.couple_halo_cfg = ListToMap(marriage_cfg.couple_halo_cfg, "halo_type", "level")
	self.xunyou_path = marriage_cfg.hunyan_xunyou_path

	local love_tree_cfg = ConfigManager.Instance:GetAutoConfig("lovetreeconfig_auto")
	self.love_tree_level_cfg = love_tree_cfg.love_tree_level_cfg
	self.love_tree_other_cfg = love_tree_cfg.other_cfg

	local sheng_di_cfg = ConfigManager.Instance:GetAutoConfig("qingyuanshengdiconfig_auto")
	self.sheng_di_other = sheng_di_cfg.other[1]
	self.sheng_di_layer = sheng_di_cfg.layer
	self.sheng_di_task2 = ListToMap(sheng_di_cfg.task, "task_id")
	self.sheng_di_task = sheng_di_cfg.task
	self.sheng_di_monster = ListToMap(sheng_di_cfg.monster, "layer", "pos_type", "monster_id")
	self.sheng_di_pos = ListToMapList(sheng_di_cfg.pos, "pos_type")
	self.sheng_di_gather = sheng_di_cfg.gather

	self.ring_target_cfg = ListToMap(self.ring_cfg, "target_id")
end

------------------巡游路径-------------------------
function MarriageData:GetXunYouPath()
	return self.xunyou_path
end
------------------婚礼-------------------------------
function MarriageData:GetHunLiData()
	return self.hunli_cfg
end

function MarriageData:GetHunliInfoByType(hunli_type)
	local hunli_info = {}
	for k, v in ipairs(self.hunli_cfg) do
		if hunli_type == v.hunli_type then
			hunli_info = v
			break
		end
	end
	return hunli_info
end

function MarriageData:CostEnoughByHunliType(hunli_type)
	local cost_enough = false
	local is_bind_gold = false
	local main_vo = GameVoManager.Instance:GetMainRoleVo()
	for k, v in ipairs(self.hunli_cfg) do
		if v.hunli_type == hunli_type then
			if v.need_bind_gold > 0 then
				local bind_gold = main_vo.bind_gold
				cost_enough = (bind_gold >= v.need_bind_gold)
				is_bind_gold = true
			else
				local gold = main_vo.gold
				if ActivityData.Instance:GetActivityIsOpen(ACTIVITY_TYPE.RAND_ACTIVITY_TYPE_WEST_WEDDING) and v.activity_price and v.hunli_style == 2 then
					cost_enough = (gold >= v.activity_price)
				else
					cost_enough = (gold >= v.need_gold)
				end
			end
			break
		end
	end
	return cost_enough, is_bind_gold
end

function MarriageData:GetMarryLevelLimit()
	return self.marriage_condition.marry_limit_level or 0
end

function MarriageData:GetMarryIntimacyLimit()
	return self.marriage_condition.marry_limit_intimacy or 0
end

function MarriageData:GetMarryTitleShow()
	return self.marriage_condition.title_show
end

function MarriageData:GetMarryGoldPeople()
	return self.marriage_condition.wedding_buy_guest_price_1
end

function MarriageData:GetHunliEquipReward()
	return self.marriage_condition.hunjie_item
end
--重复求婚奖励
function MarriageData:GetAgainHunliEquipReward()
	return self.marriage_condition.hunjie_item2
end

--设置求婚者信息
function MarriageData:SetReqWeddingInfo(protocol)
	self.wedding_by_info = protocol
end

function MarriageData:GetReqWeddingInfo()
	return self.wedding_by_info
end

function MarriageData:SetWeddingTargetInfo(marry_type, uid)
	self.wedding_target_info = {}
	self.wedding_target_info.wedding_type = marry_type
	self.wedding_target_info.target_id = uid
end

function MarriageData:GetWeddingTargetInfo()
	return self.wedding_target_info
end

-----------------结婚/离婚---------------------------
--获取结婚条件
function MarriageData:GetMarriageConditions()
	return self.marriage_condition
end

--获取强制离婚需要花费的钻石
function MarriageData:GetDivorceCost()
	return self.divorce_cost or 0
end

--获取离婚会扣除的亲密度
function MarriageData:GetIntimacyCost()
	return self.divorce_intimacy_dec
end

--------------------蜜月祝福--------------------
--同步祝福信息
function MarriageData:SyncBlessInfo(protocol)
	self.had_get_bless_reward = protocol.is_fetch_bless_reward
	self.bless_days = protocol.bless_days
	self.lover_bless_days = protocol.lover_bless_days
end

--获取祝福的Cfg
function MarriageData:GetBlessCfg()
	return self.bless_price
end

--获取祝福的每日奖励
function MarriageData:GetHoneymoonReward()
	return self.honeymoon_reward
end

--获取自己祝福有效时间
function MarriageData:GetSelfBlessDays()
	return self.bless_days
end

--获取伴侣祝福有效时间
function MarriageData:GetLoverBlessDays()
	return self.lover_bless_days
end

--是否已领取每日祝福奖励
function MarriageData:GetHadGetBlessReward()
	if self.had_get_bless_reward == 1 then
		return true
	else
		return false
	end
end

--获取剩余的祝福日子
function MarriageData:GetBlessDay()
	return self.bless_days
end

--获取祝福信息
function MarriageData:GetBlessInfo()
	local had_buy = false
	local flag = -1
	if self.bless_days > 0 then
		--购买了祝福奖励
		had_buy = true
		if self.had_get_bless_reward == 1 then
			--已领取奖励
			flag = 0
		else
			--未领取奖励-可领取
			flag = 1
		end
	else
		--未购买祝福奖励
		if self.lover_bless_days > 0 then
			--伴侣有买祝福
			flag = 2
		else
			--伴侣没有买祝福
			flag = 3
		end
	end
	return had_buy, flag
end

--------------------蜜月戒指--------------------
--同步戒指信息
function MarriageData:SyncRingInfo(protocol)
	self.sonsume_num = protocol.consume_num
	self.baoji_num = protocol.baoji_num
	self.ring_exp = protocol.exp
	self.ring_star = protocol.star
	self.lover_level = protocol.lover_level or 0
	self.lover_ring_item_id = protocol.lover_ring_item_id or 0
	self.ring_item_id = protocol.ring_item_id or 0
	self.lover_star = protocol.lover_star or 0
	self.lover_prof = protocol.lover_prof or 0
end

--同步伴侣信息
function MarriageData:OnQingyuanLoverInfo(protocol)
	self.lover_level = protocol.lover_level or 0
	self.lover_ring_item_id = protocol.lover_ring_item_id or 0
	self.lover_star = protocol.lover_star or 0
end

--获取强化后返回的信息
function MarriageData:GetRingUpgradeInfo()
	local info = {}
	local upgrade_item = self.ring_upgrade_item
	local item_cfg = ItemData.Instance:GetItemConfig(upgrade_item.stuff_id)
	info.name = item_cfg.name
	info.num = self.sonsume_num
	info.baoji_num = self.baoji_num
	return info
end

--获取戒指是否激活
function MarriageData:GetRingHadActive()
	return self.ring_item_id ~= 0
end

--获取戒指经验
function MarriageData:GetRingExp()
	return self.ring_exp
end

--获取戒指升级材料
function MarriageData:GetRingUpgradeItem()
	return self.ring_upgrade_item
end

--是否有足够的钱升级婚戒
function MarriageData:EnoughMoneyToUpRing()
	local can_up_level = false
	local main_vo = GameVoManager.Instance:GetMainRoleVo()
	local item_id = self.ring_upgrade_item.stuff_id
	local shop_item_info = ShopData.Instance:GetShopItemCfg(item_id)
	if not shop_item_info then
		return can_up_level
	end
	if shop_item_info.gold > 0 and main_vo.gold > shop_item_info.gold then
		can_up_level = true
	elseif shop_item_info.bind_gold > 0 and main_vo.bind_gold > shop_item_info.bind_gold then
		can_up_level = true
	end
	return can_up_level
end

--获取1级戒指Cfg
function MarriageData:GetLevelOneRingCfg()
	return self.ring_cfg[1]
end

function MarriageData:GetShowRingTargetData(target_id, ring_level)
	local temp_tab = {}
	local count = 1
	for i = 0, #self.ring_target_cfg do
		if self.ring_target_cfg[i].target_id < target_id then
			temp_tab[count] = self.ring_target_cfg[i]
			count = count + 1
		elseif self.ring_target_cfg[i].target_id == target_id then
			temp_tab[count] = self.ring_target_cfg[i]
			count = count + 1
			if self.ring_target_cfg[i + 1] and ring_level == self.ring_target_cfg[i].level then
				temp_tab[count] = self.ring_target_cfg[i + 1]
			end
		end
	end
	return temp_tab
end

function MarriageData:GetRingTargetCfgByLevel(target_id)
	return self.ring_target_cfg[target_id]
end

--获取伴侣职业
function MarriageData:GetLoverProf()
	return self.lover_prof % 10
end

--获取戒指Cfg和戒指是否满级
function MarriageData:GetRingCfg()
	local is_max = true
	local match_cfg = nil
	for k,v in pairs(self.ring_cfg) do
		if match_cfg == nil then
			if self.ring_star == v.star and self.ring_item_id == v.equip_id then
				match_cfg = v
			end
		else
			is_max = false
			break
		end
	end
	return match_cfg, is_max
end

function MarriageData:GetNextRingCfg()
	local match_cfg = nil
	for k,v in pairs(self.ring_cfg) do
		if v.equip_id == self.ring_item_id then
			if v.star > self.ring_star then
				match_cfg = v
				break
			end
		elseif v.equip_id > self.ring_item_id then
			if v.star == 1 and self.ring_star == 10 then
				match_cfg = v
				break
			end
		end
	end
	return match_cfg
end

--获取戒指信息
function MarriageData:GetRingInfo()
	if self.ring_item_id ~= 0 then
		--戒指已激活
		local had_num = ItemData.Instance:GetItemNumInBagById(self.ring_upgrade_item.stuff_id)
		if had_num > 0 then
			--够材料
			local ring_cfg, is_max = self:GetRingCfg()
			if is_max then
				--满级
				return 0
			else
				--未满级-可升级
				return 1
			end
		else
			--不够材料
			return 2, self.ring_upgrade_item.stuff_id
		end
	else
		--戒指未激活
		return 3
	end
end

--获取伴侣等级
function MarriageData:GetLoverLevel()
	return self.lover_level or 0
end

--获取伴侣戒指等级
function MarriageData:GetLoverStar()
	local level = 0
	local lover_star = self.lover_star
	if lover_star < 0 then
		lover_star = 0
	end

	local _, big_lev = math.modf(self.lover_ring_item_id/10)
	big_lev = string.format("%.2f", big_lev or 0) * 100
	level = big_lev + tonumber(lover_star)

	return level
end

--------------------婚宴--------------------
--同步婚宴信息
function MarriageData:OnWeddingInfo(protocol)
	self.is_first = protocol.is_first_diamond
	self.guest_list = protocol.guest_list
	self.hunyan_state = protocol.hunyan_state
	self.next_state_timestmp = protocol.next_state_timestmp
	self.fb_key = protocol.fb_key
	-- self.paohuaqiu_times = protocol.paohuaqiu_times
	self.today_gather_times = protocol.today_gather_times
	self.yanhui_type = protocol.yanhui_type
	self.is_self_hunyan = protocol.is_self_hunyan
	self.marryuser_list = protocol.marryuser_list
	self.wedding_info = protocol
	self:ChangeHunYanState()
end

function MarriageData:GetHunYanCfg()
	return self.hunyan_cfg
end

function MarriageData:GetMarryUserList()
	return self.marryuser_list
end

function MarriageData:GetWeddingInfo()
	return self.wedding_info
end

function MarriageData:ChangeHunYanState()
	if self.is_self_hunyan == 1 then
		self.self_hunyan_state = self.hunyan_state
	end
end

function MarriageData:GetIsFirstDiamond()
	return (self.is_first == 1)
end

--是否婚宴主人
function MarriageData:IsMarryUser()
	local main_role_vo = GameVoManager.Instance:GetMainRoleVo()
	for k, v in ipairs(self.marryuser_list) do
		if main_role_vo.role_id == v.marry_uid then
			return true
		end
	end
	if self.xunyou_pos.is_own and self.xunyou_pos.is_own ~= 0 then
		return true
	end
	return false
end

--是否婚宴主人
function MarriageData:IsMarryUserCompareId(role_id)
	for k, v in ipairs(self.marryuser_list) do
		if role_id == v.marry_uid then
			return true
		end
	end
	return false
end

--获取婚宴配偶uid
function MarriageData:GetMarryOhterUser()
	local main_role_vo = GameVoManager.Instance:GetMainRoleVo()
	for k, v in ipairs(self.marryuser_list) do
		if main_role_vo.role_id ~= v.marry_uid then
			return v.marry_uid
		end
	end
	return nil
end


function MarriageData:GetFbKey()
	return self.fb_key
end

function MarriageData:GetYanHuiType()
	return self.role_msg_info.marry_type
end

--获取婚宴持续时间
function MarriageData:GetWeedingTime()
	return self.next_state_timestmp and (self.next_state_timestmp - TimeCtrl.Instance:GetServerTime()) or 0
end

function MarriageData:GetWeddingCfgByType(marry_type)
	for k,v in pairs(self.wedding_type_cfg) do
		if v.marry_type == marry_type then
			return v
		end
	end
end

local function Sort_InviteList(a, b)
	if a.garden_num < b.garden_num then
		return true
	end
end

--设置被邀请数据
function MarriageData:SetGetInviteData(protocol)
	self.get_invite_data = protocol.invite_list
	table.sort(self.get_invite_data, Sort_InviteList)
end

--获取被邀请数据
function MarriageData:GetGetInviteData()
	return self.get_invite_data
end

--获取婚宴行为数据
function MarriageData:GetActivityCfg()
	return self.hunyan_activity
end

--获取婚宴列表是否存在采集次数
function MarriageData:HaveGatherTimesInHunYanList()
	local max_num = 0
	local hunyan_cfg = self:GetHunYanCfg()
	local hunyan_act_cfg = self:GetActivityCfg()

	if self.today_gather_times >= hunyan_act_cfg.hunyan_gather_day_max_stuff_num then
		return false
	end

	for _, v in ipairs(self.get_invite_data) do
		if v.hunyan_type == 1 then
			max_num = hunyan_cfg.bind_gold_gather_max or 0
		else
			max_num = hunyan_cfg.gather_max or 0
		end
		if v.garden_num < max_num then
			return true
		end
	end
	return false
end

function MarriageData:GetMaxPickTimesOnDay()
	return self.hunyan_activity and self.hunyan_activity.hunyan_gather_day_max_stuff_num or 0
end

--是否正在举办婚宴
function MarriageData:GetIsHoldingWeeding()
	return self.self_hunyan_state == 2
end

--获取所有参与婚宴客人的ID
function MarriageData:GetAllGuests()
	return self.guest_list
end

--获取已开启的婚宴副本编号
function MarriageData:GetFuBenKey()
	return self.fb_key
end

function MarriageData:GetHunYanReward(is_bind)
	local reward_data = {}
	if is_bind then
		reward_data = self.marriage_condition.bind_gold_hy_reward_item
	else
		reward_data = self.marriage_condition.gold_hy_reward_item
	end
	return reward_data
end

--------------------情缘副本--------------------
--接受情缘副本信息
function MarriageData:SetQingYuanFBInfo(data)
	self.qingyaun_fb_info = data
	self.yanhui_fb_key = data.yanhui_fb_key
	self.fb_count = data.join_fb_times
end

--获取情缘副本信息
function MarriageData:GetQingYuanFBInfo()
	return self.qingyaun_fb_info
end

--同步祝福信息
function MarriageData:SyncBlessInfo(protocol)
	self.had_get_bless_reward = protocol.is_fetch_bless_reward
	self.bless_days = protocol.bless_days
	self.lover_bless_days = protocol.lover_bless_days
end

--情缘副本信息
function MarriageData:SetQingYuanFB(protocol)
	self.qingyuan_fb = protocol
end

function MarriageData:GetQingYuanFB()
	return self.qingyuan_fb
end

--获取情缘副本Buff信息
function MarriageData:GetQingYuanFBBuffInfo()
	return self.qingyuan_fb_buff
end

--获取情缘副本奖励
function MarriageData:GetQingYuanFBReward()
	-- local list = {}
	-- for k,v in pairs(self.qingyuan_fb_reward) do
	-- 	if list[v.stuff_id] == nil then
	-- 		list[v.stuff_id] = v
	-- 	end
	-- end
	-- return list
	return self.qingyuan_fb_reward
end

--------------------光环--------------------

function MarriageData:GetHaloScrollerData()
	local marriage_cfg = ConfigManager.Instance:GetAutoConfig("qingyuanconfig_auto")
	local data = {}
	for k,v in pairs(marriage_cfg.couplehalo_cfg) do
		if data[v.halo_type] == nil then
			local tmp = TableCopy(v)
			tmp.is_active = self:GetHaloIsAvtive(v.halo_type)
			tmp.level = 99--ToDo目前不用等级
			tmp.is_wearing = (self.halo_info.equiped_couple_halo_type == v.halo_type)
			data[tmp.halo_type] = tmp
		end
	end
	return data
end

function MarriageData:GetHaloSpiritData(halo_type)
	local marriage_cfg = ConfigManager.Instance:GetAutoConfig("qingyuanconfig_auto")
	local data = {}
	for k,v in pairs(marriage_cfg.couplehalo_cfg) do
		if v.halo_type == halo_type then
			local tmp = TableCopy(v)
			local halo_tbl = self.halo_info.couple_halo_activate_status_list[halo_type] or {}
			local spirit_activite_value = halo_tbl[v.icon_index + 1] or 0
			tmp.is_active = spirit_activite_value == 1
			tmp.can_upgrade = (ItemData.Instance:GetItemNumInBagById(v.stuff_id) > 0)
			table.insert(data, tmp)
		end
	end
	return data
end

function MarriageData:OnHaloInfo(protocol)
	self.halo_info = protocol
end

function MarriageData:GetHaloIsAvtive(halo_type)
	local halo_tbl = self.halo_info.couple_halo_activate_status_list[halo_type] or {}
	for k,v in pairs(halo_tbl) do
		if v == 0 then
			return false
		end
	end
	return true
end

function MarriageData:GetHaloIsWearing(halo_type)
	return (self.halo_info.equiped_couple_halo_type == halo_type)
end

function MarriageData:GetSpiritIsAvtive(halo_type, spirit_index)
	local halo_tbl = self.halo_info.couple_halo_activate_status_list[halo_type] or {}
	local spirit_activite_value = halo_tbl[spirit_index] or 0
	return spirit_activite_value == 1
end

function MarriageData:GetSpiritActiveUseNum(halo_type, spirit_index)
	for k,v in pairs(self.halo_info.use_item_num_list) do
		if v.halo_id == halo_type and v.spirit_id == spirit_index then
			return v.active_num
		end
	end
end

function MarriageData:GetSpiritPower(halo_type, spirit_index)
	local marriage_cfg = ConfigManager.Instance:GetAutoConfig("qingyuanconfig_auto")
	for k,v in pairs(marriage_cfg.couplehalo_cfg) do
		if v.halo_type == halo_type then
			if (v.icon_index + 1) == spirit_index then
				local power = CommonDataManager.GetCapabilityCalculation(v)
				return power
			end
		end
	end
end

function MarriageData:GetHaloTotalAttr()
	local marriage_cfg = ConfigManager.Instance:GetAutoConfig("qingyuanconfig_auto")
	local total_attr = CommonStruct.Attribute()
	for k,v in pairs(self.halo_info.couple_halo_activate_status_list) do
		for k2,v2 in pairs(v) do
			if v2 == 1 then
				for k3,v3 in pairs(marriage_cfg.couplehalo_cfg) do
					if v3.halo_type == k and (v3.icon_index + 1) == k2 then
						local attr = CommonDataManager.GetAttributteByClass(v3)
						total_attr = CommonDataManager.AddAttributeAttr(total_attr, attr)
					end
				end
			end
		end
	end
	for k in pairs(total_attr) do
		if k == "bao_ji" or k == "jian_ren" then
			total_attr[k] = -1
		end
	end
	return total_attr
end

--处理光环红点
function MarriageData:ChangeHaloRedPoint()

end

------------------------相思树----------------------------------
function MarriageData:GetTreeInfo(level)
	local tree_info = {}
	for k, v in ipairs(self.love_tree_level_cfg) do
		if level == v.tree_star then
			tree_info = v
			break
		end
	end
	return tree_info
end

function MarriageData:GetLoverTreeLevelFristInfo()
	return self.love_tree_level_cfg[1]
end

function MarriageData:GetTreeCfg()
	return self.love_tree_other_cfg[1]
end

--获取树的归属
function MarriageData:GetTreeState()
	return self.love_tree_state
end

--设置相思树的信息
function MarriageData:SetLoveTreeInfo(protocol)
	self.love_tree_info = protocol
	self.love_tree_state = protocol.is_self 				--设置树的归属
end

function MarriageData:GetLoveTreeInfo()
	return self.love_tree_info
end

--处理相思树红点
function MarriageData:SetLoveTreeRedPoint()
	local state = false
	--检测功能是否开启
	local is_open = OpenFunData.Instance:CheckIsHide("marriage_love_tree")
	if not is_open then
		self:HandleRedPoint("love_tree", false)
		return
	end

	local main_vo = GameVoManager.Instance:GetMainRoleVo()
	local self_free_water_time = self.love_tree_other_cfg[1].self_free_water_time
	local assist_free_water_time = self.love_tree_other_cfg[1].assist_free_water_time

	local free_water_self = self.love_tree_info.free_water_self
	local free_water_other = self.love_tree_info.free_water_other

	local self_item_data = {}
	local self_item_id = 0
	local self_num = 0

	local other_item_data = {}
	local other_item_id = 0
	local other_num = 0

	if self.love_tree_state == 1 then
		self_item_data = self:GetTreeInfo(self.love_tree_info.love_tree_star_level)
		other_item_data = self:GetTreeInfo(self.love_tree_info.other_love_tree_star_level)
	else
		self_item_data = self:GetTreeInfo(self.love_tree_info.other_love_tree_star_level)
		other_item_data = self:GetTreeInfo(self.love_tree_info.love_tree_star_level)
	end

	local self_up_star_item_data = self_item_data.female_up_star_item or {}
	local other_up_star_item_data = other_item_data.male_up_star_item or {}

	self_item_id = self_up_star_item_data.item_id or 0
	self_num = self_up_star_item_data.num or 0

	other_item_id = other_up_star_item_data.item_id or 0
	other_num = other_up_star_item_data.num or 0

	if main_vo.sex == 1 then
		self_up_star_item_data = self_item_data.male_up_star_item or {}
		other_up_star_item_data = other_item_data.female_up_star_item or {}

		self_item_id = self_up_star_item_data.item_id or 0
		self_num = self_up_star_item_data.num or 0

		other_item_id = other_up_star_item_data.item_id or 0
		other_num = other_up_star_item_data.num or 0
	end

	local self_item_num = ItemData.Instance:GetItemNumInBagById(self_item_id)
	local other_item_num = ItemData.Instance:GetItemNumInBagById(other_item_id)

	if free_water_self and free_water_self < self_free_water_time then			--先判断自己是否有免费次数
		state = true
	elseif self_item_num >= self_num then										--再判断自己所需物品是否足够
		state = true
	elseif main_vo.lover_uid <= 0 then											--没结婚不考虑伴侣
		state = false
	elseif free_water_other and free_water_other < assist_free_water_time then	--先判断是否可以帮伴侣免费浇水
		state = true
	elseif other_item_num >= other_num then										--再判断伴侣所需的物品是否足够
		state = true
	end
	self:HandleRedPoint("love_tree", state)
end

--是否相思树所需要消耗的物品
function MarriageData:IsLoverTreeItemById(item_id)
	if item_id == self.love_tree_level_cfg[1].male_up_star_item.item_id or item_id == self.love_tree_level_cfg[1].female_up_star_item.item_id then
		return true
	end
end

-------------------我要脱单-----------------------------
function MarriageData:SetAllTuoDanList(protocol)
	self.tuodan_list = protocol.tuodan_list
end

function MarriageData:ChangeTuoDanList(protocol)
	local tuodan_info = protocol.tuodan_info
	if not next(tuodan_info) then
		return
	end
	if protocol.operate_type == TUODAN_OPERA_TYPE.TUODAN_INSERT then
		local up_date = false
		for k, v in ipairs(self.tuodan_list) do
			if v.uid == tuodan_info.uid then
				self.tuodan_list[k] = tuodan_info
				up_date = true
				break
			end
		end
		if not up_date then
			table.insert(self.tuodan_list, tuodan_info)
		end
	else
		local uid = tuodan_info.uid
		for k, v in ipairs(self.tuodan_list) do
			if uid == v.uid then
				table.remove(self.tuodan_list, k)
			end
		end
	end
end

function MarriageData:RemoveTuoDanInfoMySelf()
	local main_vo = GameVoManager.Instance:GetMainRoleVo()
	for k, v in ipairs(self.tuodan_list) do
		if main_vo.role_id == v.uid then
			table.remove(self.tuodan_list, k)
		end
	end
end

function MarriageData:GetAllTuoDanList(is_other_sex)
	local temp_tuodan_list = {}
	local main_vo = GameVoManager.Instance:GetMainRoleVo()
	local my_dec = nil
	for k, v in ipairs(self.tuodan_list) do
		if main_vo.role_id == v.uid then
			my_dec = v
		else
			if is_other_sex then
				if main_vo.sex ~= v.sex then
					table.insert(temp_tuodan_list, v)
				end
			else
				table.insert(temp_tuodan_list, v)
			end
		end
	end
	if my_dec then
		table.insert(temp_tuodan_list, 1, my_dec)
	end
	return temp_tuodan_list
end

function MarriageData:IsInTuoDanList()
	local main_vo = GameVoManager.Instance:GetMainRoleVo()
	for k, v in ipairs(self.tuodan_list) do
		if main_vo.role_id == v.uid then
			return true
		end
	end
	return false
end

--获取随机示好消息
function MarriageData:GetTuoDanDes()
	local count = #self.tuodan_cfg
	local index = math.random(1, count)
	return self.tuodan_cfg[index].des
end

--设置示好冷却时间
function MarriageData:AddSendGoodTimeList(role_id)
	local server_time = TimeCtrl.Instance:GetServerTime()
	self.good_time_list[role_id] = server_time
end

function MarriageData:GetSendGoodTime(role_id)
	return self.good_time_list[role_id]
end

function MarriageData:SetSendTuoDanTime()
	self.send_tuo_dan_time = TimeCtrl.Instance:GetServerTime()
end

function MarriageData:GetSendTuoDanTime()
	return self.send_tuo_dan_time
end

---------------------爱情契约------------------------------------
function MarriageData:SetQingyuanLoveContractInfo(protocol)
	self.love_contract_info.info_type = protocol.info_type
	self.love_contract_info.self_love_contract_reward_flag = protocol.self_love_contract_reward_flag
	self.love_contract_info.can_receive_day_num = protocol.can_receive_day_num
	self.love_contract_info.lover_love_contract_timestamp = protocol.lover_love_contract_timestamp

	self.love_contract_info.leaveword_list = {}
	local leaveword_list = {}
	-- 自己
	local my_name = GameVoManager.Instance:GetMainRoleVo().name or ""
	for k,v in pairs(protocol.self_notice_list) do
		v.user_name = my_name
		table.insert(leaveword_list, v)
	end

	-- 情侣
	local love_name = GameVoManager.Instance:GetMainRoleVo().lover_name or ""
	for k,v in pairs(protocol.lover_notice_list) do
		v.user_name = love_name
		table.insert(leaveword_list, v)
	end
	SortTools.SortAsc(leaveword_list, "day")
	self.love_contract_info.leaveword_list = leaveword_list

	MainUICtrl.Instance:FlushTipsIcon(MainUIViewChat.IconList.LOVE_CONTENT, true)
end

function MarriageData:GetQingyuanLoveContractInfo()
	return self.love_contract_info
end

function MarriageData:GetQingyuanLoveContractRewardFlag(index)
	if not OpenFunData.Instance:CheckIsHide("marriage") then
		return 0
	end

	local temp_flag_t = self.love_contract_info.self_love_contract_reward_flag
	return temp_flag_t[32 - index] or 0
end

function MarriageData:SetLoveContractSelectIndex(index)
	if index then
		self.love_contract_select_index = index
	end
end

function MarriageData:GetLoveContractSelectIndex()
	return self.love_contract_select_index or 1
end

function MarriageData:GetQingyuanLoveContractCfg()
	return ConfigManager.Instance:GetAutoConfig("qingyuanconfig_auto").love_contract or {}
end

function MarriageData:GetQingyuanLoveContractCfgByDay(day)
	local love_contract_cfg = self:GetQingyuanLoveContractCfg()
	for k, v in pairs(love_contract_cfg) do
		if day == v.day then
			return v
		end
	end
end

-- 爱情契约价格
function MarriageData:GetQingyuanLoveContractPrice()
	return self.marriage_condition.lovecontract_price or 0
end

-- 获取爱情契约是否有奖励可以领取
function MarriageData:GetQingyuanLoveContractReward()
	-- 爱情契约功能是否开启
	local flag = 0
	local can_receive_day_num = self:GetQingyuanLoveContractInfo().can_receive_day_num
	for k,v in pairs(self:GetQingyuanLoveContractCfg()) do
		local reward_flag = self:GetQingyuanLoveContractRewardFlag(v.day)
		if v.day <= can_receive_day_num and reward_flag == 0 and self:CheckIsMarry() then
			flag = 1
			break
		end
	end
	return flag
end

-- 获取爱情契约领取了多少绑元
function MarriageData:GetQingyuanLoveContractReturnGold()
	local number = 0
	for i = 0, 6 do
		local return_gold = self:GetQingyuanLoveContractCfgByDay(i).reward_gold_bind
		number = number + return_gold
	end
	return number
end

-- 获取爱情契约句子
function MarriageData:GetQingyuanLoveContractString()
	return ConfigManager.Instance:GetAutoConfig("qingyuanconfig_auto").love_contract_sentence
end

function MarriageData:SetPutongHunyanTimes(times)
	self.today_putong_hunyan_times = times
end

function MarriageData:SetTodayOpenHunYanTimes(times)
	self.today_total_open_hunyan_times = times
end

function MarriageData:SetCanOpen(times)
	self.can_open = times
end

-- 当天普通婚宴次数
function MarriageData:GetPutongHunyanTimes()
	return self.today_putong_hunyan_times
end

function MarriageData:GetMarryPartyRemind()
	local flag = 0
	local main_role_vo = GameVoManager.Instance:GetMainRoleVo()
	local max_open_times = self.marriage_condition.open_times or 0
	if main_role_vo.lover_uid > 0 then
		if self.today_total_open_hunyan_times < max_open_times and self.today_putong_hunyan_times < 1 then
			flag = 1
		end
	end

	self.red_point_list.honeymoon_group.Party = flag == 1
	return flag
end

function MarriageData:SetFuBenOpenState(state)
	self.fuben_view_state = state
end

function MarriageData:GetFuBenRemind()
	local flag = 0
	
	if not OpenFunData.Instance:CheckIsHide("marriage_fuben") then return flag end

	-- local main_role_vo = GameVoManager.Instance:GetMainRoleVo()
	-- if main_role_vo.lover_uid > 0 then
		-- 没有打开过结婚副本界面
	if RemindManager.Instance:RemindToday(RemindName.MarryFuBen) then
		return 0
	end

	if self.qingyaun_fb_info ~= nil then
		if self.qingyaun_fb_info.join_fb_times <= 0 or self.qingyaun_fb_info.buy_fb_join_times >= self.qingyaun_fb_info.join_fb_times then
			flag = 1
		end
	end

	-- end
	return flag
end

function MarriageData:GetShengDiRemind()
	if ClickOnceRemindList[RemindName.MarryShengDi] and ClickOnceRemindList[RemindName.MarryShengDi] == 0 then
		return 0
	end

	local flag = 0
	local task_list = self:GetTaskList()
	for k,v in pairs(task_list) do
		if v.flag == 0 and v.is_fetched_reward == 0 then
			flag = 1
			return flag
		end

		local task_cfg = self:GetOneShengDiTaskById(v.task_id)
		if v.param < task_cfg.param1 then
			flag = 1
		end
	end
	if self:GetIsOtherBtnShow() == true then
		flag = 1
	end

	return flag
end

function MarriageData:GetCoupleHaloRemind()
	local main_role_id = GameVoManager.Instance:GetMainRoleVo().role_id
	local cur_day = TimeCtrl.Instance:GetCurOpenServerDay()
	local remind_day = PlayerPrefsUtil.GetInt("MarriageHaloBuyView" .. main_role_id) or cur_day
	if cur_day ~= -1 and cur_day ~= remind_day and self:IsShowSaleRemind() then
		return 1
	end	

	local flag = 0
	local main_role_vo = GameVoManager.Instance:GetMainRoleVo()
	local item_id_key = main_role_vo.sex == 1 and "stuff_id" or "stuff_id_woman"
	if nil == self.couple_halo_level_list then
		return 0
	end
	for k, v in ipairs(self.couple_halo_level_list) do
		local halo_type = k - 1
		local halo_info = self:GetHaloInfo(halo_type, v)
		--先判断前置光环是否达到条件
		local above_level_enough = true
		if nil ~= halo_info then
			local pre_halo_level = halo_info.pre_halo_level
			if pre_halo_level > 0 then
				local above_halo_type = halo_type - 1
				local above_halo_level = self:GetHaloLevelByType(above_halo_type)
				if above_halo_level < pre_halo_level then
					above_level_enough = false
				end
			end
		end

		--如果存在前置光环等级没达到的话直接退出循环
		if above_level_enough then
			--判断光环是否满级
			local next_halo_info = self:GetHaloInfo(halo_type, v + 1)
			if nil ~= next_halo_info then				--判断是否存在下一级光环属性
				--检查物品是否足够
				local item_id = halo_info[item_id_key]
				local num = ItemData.Instance:GetItemNumInBagById(item_id)
				if next_halo_info.stuff_count and num >= next_halo_info.stuff_count then
					flag = 1
					break
				end
			end
		end
	end

	return flag
end

--记录使用中的夫妻光环
function MarriageData:SetEquipCoupleHaloType(halo_type)
	self.equiped_couple_halo_type = halo_type
end

function MarriageData:GetEquipCoupleHaloType()
	return self.equiped_couple_halo_type
end

function MarriageData:SetCoupleHaloLevelList(list)
	self.couple_halo_level_list = list
end

function MarriageData:GetCoupleHaloLevelList()
	return self.couple_halo_level_list
end

function MarriageData:GetCoupleHaloLevelBuyList()
	if self.couple_halo_level_list then
		local buy_list = {}
		for k, v in ipairs(self.couple_halo_level_list) do
		 	if k ~= 1 then
		 		table.insert(buy_list,v)
		 	end
		end
		local has_create_role_day = MarriageData.Instance:GetHasCreateDay()
		if has_create_role_day >= 0 then
			local select_index = MarriageData.Instance:GetIsHasBuyTeJiaHalo()
			local final_list = {}
			for i = 1, select_index do
				table.insert(final_list, buy_list[i])
			end
			return final_list
		else
			return buy_list
		end
	else
		return {}
	end
end

function MarriageData:GetRewardCfgByType(halo_type)
	local marriage_cfg = ConfigManager.Instance:GetAutoConfig("qingyuanconfig_auto").halo_sale
	if marriage_cfg then
		for k, v in pairs(marriage_cfg) do
			if halo_type == v.halo_type then
				return v
			end
		end
		return marriage_cfg[#marriage_cfg]
	else
		return {}
	end
end

function MarriageData:GetMaxNum()
	local marriage_cfg = ConfigManager.Instance:GetAutoConfig("qingyuanconfig_auto").halo_sale
	return #marriage_cfg or 6
end

function MarriageData:GetMaxDay()
	local marriage_cfg = ConfigManager.Instance:GetAutoConfig("qingyuanconfig_auto").halo_sale
	return marriage_cfg[#marriage_cfg].create_role_day_open or 6
end

function MarriageData:GetIsSaling(halo_type, create_role_day_open)
	-- local marriage_cfg = ConfigManager.Instance:GetAutoConfig("qingyuanconfig_auto").halo_sale
	-- if marriage_cfg then
	-- 	for k, v in pairs(marriage_cfg) do
	-- 		if halo_type == v.halo_type and create_role_day_open == v.create_role_day_open then
	-- 			return true
	-- 		end
	-- 	end
	-- 	return false
	-- else
	-- 	return false
	-- end
	return halo_type == self.is_today_buy_tejia_halo
end

function MarriageData:SetIsHasBuyTeJiaHalo(is_today_buy_tejia_halo)
	self.is_today_buy_tejia_halo = is_today_buy_tejia_halo
end

function MarriageData:GetIsHasBuyTeJiaHalo()
	return self.is_today_buy_tejia_halo
end

function MarriageData:SetHaloBuyInvalidTime(tejie_halo_invalid_time)
	self.tejie_halo_invalid_time = tejie_halo_invalid_time
end

function MarriageData:GetHaloBuyInvalidTime()
	return self.tejie_halo_invalid_time
end

function MarriageData:IsShowSaleRemind()
	-- if self.is_today_buy_tejia_halo == 0 and self:GetHasCreateDay() + 1 <= self:GetMaxDay() then
	-- 	return true
	-- end
	if self:GetHasCreateDay() > 0 then
		return true
	end
	return false
end

function MarriageData:GetHasCreateDay()
	local buy_time = self.tejie_halo_invalid_time or 0
	local server_time = TimeCtrl.Instance:GetServerTime()
	return buy_time - server_time
end

function MarriageData:SetCoupleHaloExpList(list)
	self.couple_halo_exp_list = list
end

function MarriageData:GetHaloExpByType(halo_type)
	if nil == self.couple_halo_exp_list then
		return 0
	end

	return self.couple_halo_exp_list[halo_type + 1] or 0
end

function MarriageData:GetHaloLevelByType(halo_type)
	if nil == self.couple_halo_level_list then
		return 0
	end

	return self.couple_halo_level_list[halo_type + 1] or 0
end

function MarriageData:GetBiaoBaiCfgByLevel(level)
	for _,v in pairs(self.biaobai_cfg) do
		if v.level == level then
			return v
		end
	end
	return nil
end

function MarriageData:GetMaxBiaoBaiLevel()
	local cfg = self.biaobai_cfg[#self.biaobai_cfg]
	return cfg.level
end

function MarriageData:GetHaloInfo(halo_type, level)
	if nil == self.couple_halo_cfg or nil == self.couple_halo_cfg[halo_type] or nil == self.couple_halo_cfg[halo_type][level] then
		return nil
	end

	return self.couple_halo_cfg[halo_type][level]
end

--获取光环的激活等级
function MarriageData:GetActiveHaloLevel(halo_type)
	local level = 0
	if nil == self.couple_halo_cfg or nil == self.couple_halo_cfg[halo_type] then
		return level
	end

	local cfg = self.couple_halo_cfg[halo_type]
	while cfg[level] do
		local is_active = cfg[level].is_active_image
		if is_active == 1 then
			break
		end
		level = level + 1
	end
	return level
end

---------------------------情缘圣地------------------------------
function MarriageData:GetShengDiOtherCfg()
	return self.sheng_di_other
end
function MarriageData:GetShengDiLayerCfg()
	return self.sheng_di_layer
end
function MarriageData:GetShengDiTaskCfg()
	return self.sheng_di_task
end

function MarriageData:SetQingYuanShengDiTaskInfo(protocol)
	self.is_fetched_task_other_reward = protocol.is_fetched_task_other_reward
	self.lover_is_all_task_complete = protocol.lover_is_all_task_complete
	self.task_info_list = protocol.task_info_list
end

function MarriageData:GetIsOtherBtnShow()
	local is_fetched_reward_num = 0
	for k,v in pairs(self.task_info_list) do
		if v.is_fetched_reward == 1 then
			is_fetched_reward_num = is_fetched_reward_num + 1
		end
	end
	if is_fetched_reward_num > 0 and is_fetched_reward_num == #self.task_info_list and self.is_fetched_task_other_reward == 0 
		and self.lover_is_all_task_complete == 1 then
		return true
	end
	return false
end

function MarriageData:GetTaskList()
	 shengdi_task_list = TableCopy(self.task_info_list)
	 for k,v in ipairs(shengdi_task_list) do
	 	local cfg = self:GetOneShengDiTaskById(v.task_id)
	 	if v.param >= cfg.param1 then
	 		v.flag = 0
	 	else
	 		v.flag = 1
	 	end
 	end
 	table.sort(shengdi_task_list, self:CommonSorters("is_fetched_reward","flag","index"))
    return shengdi_task_list
end

--未完成任务数量
function MarriageData:GetTaskNum()
	local num = 0
	for k,v in ipairs(self:GetTaskList()) do
		if v.flag == 1 then
			num = num  + 1
		end
	end
	return num
end

function MarriageData:CommonSorters(sort_key_name1, sort_key_name4, sort_key_name5)
    return function(a, b)
        local order_a = 10000
        local order_b = 10000
        if a[sort_key_name1] > b[sort_key_name1] then
            order_a = order_a + 10000
        elseif a[sort_key_name1] < b[sort_key_name1] then
            order_b = order_b + 10000
        end

        if nil == sort_key_name4 then return order_a < order_b end

        if a[sort_key_name4] > b[sort_key_name4] then
            order_a = order_a + 100
        elseif a[sort_key_name4] < b[sort_key_name4] then
            order_b = order_b + 100
        end

        if nil == sort_key_name5 then return order_a < order_b end

        if a[sort_key_name5] > b[sort_key_name5] then
            order_a = order_a + 10
        elseif a[sort_key_name5] < b[sort_key_name5] then
            order_b = order_b + 10
        end
        return order_a < order_b
    end
end


function MarriageData:GetOneShengDiTaskById(task_id)
	for k,v in pairs(self.sheng_di_task) do
		if task_id == v.task_id then
			return v
		end
	end
	return nil
end

function MarriageData:SetQingYuanShengDiBossInfo(protocol)
	self.boss_count = protocol.boss_count
	self.boss_list = protocol.boss_list
end

function MarriageData:GetTaskInfoList()
	return self.task_info_data
end

function MarriageData:GetBossInfoList()
	return self.boss_list
end

function MarriageData:SetSceneId(layer)
	for k,v in pairs(self.sheng_di_layer) do
		if layer == v.layer then
			self.boss_scene_id = v.scene_id
		end
	end
end

function MarriageData:SetNowShendiLayer(layer)
	self.shendi_layer = layer
end

function MarriageData:GetNowShendiLayer()
	return self.shendi_layer
end

function MarriageData:GetLayerCfgByLayer(layer)
	for k,v in pairs(self.sheng_di_layer) do
		if layer == v.layer then
			return v
		end
	end
end

function MarriageData:GetLayerCfgByLevel(level)
	local  data = {}
	for k,v in pairs(self.sheng_di_layer) do
		if level >= v.enter_level and (data.enter_level == nil or data.enter_level < v.enter_level) then
			data = v
		end
	end
	return data
end

function MarriageData:GetSceneId()
	return self.boss_scene_id
end

--获取对应位置类型的怪物列表
function MarriageData:GetShengDiMosterList(layer, pos_type)
	if self.sheng_di_monster[layer] == nil or self.sheng_di_monster[layer][pos_type] == nil then
		return nil
	end

	return self.sheng_di_monster[layer][pos_type]
end

function MarriageData:GetShengDiPosByPosType(pos_type)
	if self.sheng_di_pos[pos_type] == nil or self.sheng_di_pos[pos_type][1] == nil then
		return 0, 0
	end

	local pos_info = self.sheng_di_pos[pos_type][1]

	return pos_info.pos_x, pos_info.pos_y
end

function MarriageData:IsShengDIScene()
	local scene_id = Scene.Instance:GetSceneId()
	for k,v in pairs(self.sheng_di_layer) do
		if v.scene_id == scene_id then
			return true
		end
	end
	return false
end

function  MarriageData:SetTaskId(task_id)
	self.task_id = task_id
end

function MarriageData:IsGatherTimesLimit()
	local  task_cfg = {}
	local data = {}
	for k,v in pairs(self:GetTaskList()) do
		if self.sheng_di_task2[v.task_id] ~= nil and self.sheng_di_task2[v.task_id].task_type == 5 then
			task_cfg = self.sheng_di_task2[v.task_id]
			data = v
			break
		end
	end
	if task_cfg.param1 <= data.param then
		return true
	end
	return false
end

function MarriageData:IsShowShengDiFuBen()
	if self:IsShengDIScene() and not self:IsGatherTimesLimit() then
		return true
	end
	return false
end

function MarriageData:SetHunYanTime(time)
	self.hunyan_time = time
end
--活动时间
function MarriageData:GetHunYanTime()
	return self.hunyan_time
end

function MarriageData:GetGatherCfg()
	return self.sheng_di_gather
end

function MarriageData:GetDisplayPosition(index)
	return person_position[index or "loliCommon"]
end

--摁手印消息接收
function MarriageData:Gethandprint(protocol)
	self.hand_print = protocol
end

function MarriageData:Sethandprint()
	return self.hand_print
end

-------------------预约婚宴--------------------------
function MarriageData:SetYuYueRoleInfo(protocol)
	self.role_msg_info.marry_type = protocol.param_ch1 			--婚宴类型
	self.role_msg_info.marry_count = protocol.param_ch2 				--是否有婚礼次数
	self.role_msg_info.marry_state = protocol.param_ch3				--婚宴状态
	self.role_msg_info.param_ch4 = protocol.param_ch4 			--婚礼预约seq
	self.role_msg_info.param_ch5 = protocol.param_ch5			--婚礼领取标记
end

function MarriageData:GetYuYueRoleInfo()
	return self.role_msg_info
end

--------------------巡游界面--------------------------
function MarriageData:SetXunYouInfo(protocol)
	self.xunyou_info.throw_count = protocol.param_ch1			--撒红包次数
	self.xunyou_info.buy_throw_count = protocol.param_ch2		--买红包次数
	self.xunyou_info.flower_count = protocol.param_ch3			--送花次数
	self.xunyou_info.buy_flower_count = protocol.param_ch4		--买花次数
	self.xunyou_info.get_red_count = protocol.param_ch5			--采集红包次数
	self.xunyou_info.hunyan_type = protocol.param_ch6			--婚宴类型
end

function MarriageData:GetXunYouInfo()
	return self.xunyou_info
end

function MarriageData:GetXunYouCfg()
	return self.xunyou_cfg
end
------------------------预约时间-----------------------
-- 获取预约时间配置信息
function MarriageData:GetMarryYuYueCfg()
	local yuyue_cfg = {}

	local wedding_yuyue_time = ConfigManager.Instance:GetAutoConfig("qingyuanconfig_auto").wedding_yuyue_time
	if wedding_yuyue_time == nil then
		return
	end

	for k,v in ipairs(wedding_yuyue_time) do
		local time_table = os.date("*t", TimeCtrl.Instance:GetServerTime())
		local data = TableCopy(v)
		local time = os.time({year=time_table.year, month=time_table.month, day=time_table.day, hour=math.floor(v.apply_time / 100), min=v.apply_time % 100, sec=0})
		-- data.is_yuyue = self:GetYuYueListInfo(v.seq)
		if self:GetYuYueListInfo(v.seq) > 0 then
			data.is_yuyue = TimeCtrl.Instance:GetServerTime() > time and 0 or 1
		else
			data.is_yuyue = 0
		end
		data.yuyue_time = TimeCtrl.Instance:GetServerTime() > time and 1 or 0
		yuyue_cfg[#yuyue_cfg + 1] = data
	end
	table.sort(yuyue_cfg, self:MarryYuYueListSorters("yuyue_time", "is_yuyue", "seq"))
	return yuyue_cfg
end

function MarriageData:MarryYuYueListSorters(sort_key_name1, sort_key_name2, sort_key_name3)
	return function(a, b)
		local order_a = 100000
		local order_b = 100000
		if a[sort_key_name1] > b[sort_key_name1] then
			order_a = order_a + 10000
		elseif a[sort_key_name1] < b[sort_key_name1] then
			order_b = order_b + 10000
		end

		if nil == sort_key_name2 then  return order_a < order_b end

		if a[sort_key_name2] < b[sort_key_name2] then
			order_a = order_a + 1000
		elseif a[sort_key_name2] > b[sort_key_name2] then
			order_b = order_b + 1000
		end

		if nil == sort_key_name3 then  return order_a < order_b end

		if a[sort_key_name3] > b[sort_key_name3] then
			order_a = order_a + 100
		elseif a[sort_key_name3] < b[sort_key_name3] then
			order_b = order_b + 100
		end

		return order_a < order_b
	end
end

-- 设置结婚时间段索引
function MarriageData:SetMarryTimeSeq(seq)
	self.select_time_seq = seq
end

-- 获取结婚时间段
function MarriageData:GetMarryTimeSeq()
	return self.select_time_seq
end

function MarriageData:GetShowTime(seq)
	local yuyue_cfg = MarriageData.Instance:GetMarryYuYueCfg()
	local str = ""
	for _,v in pairs(yuyue_cfg) do
		if v.seq == seq then
			local begin_str = tostring(v.apply_time)
			local end_str = tostring(v.end_time)
			for i = 1, 4 do
				-- 补0
				if string.len(begin_str) == i then
					for j = 1, 4 - i do
						begin_str = "0" .. begin_str
					end
				end
				if string.len(end_str) == i then
					for j = 1, 4 - i do
						end_str = "0" .. end_str
					end
				end				
			end
			-- 截字符串
			str = string.sub(begin_str, 1, 2) .. ":" .. string.sub(begin_str, 3, 4) .. "-" .. string.sub(end_str, 1, 2) .. ":" .. string.sub(end_str, 3, 4)
		end
	end
	return str
end

function MarriageData:GetShowXuyouTime(seq)
	local yuyue_cfg = MarriageData.Instance:GetMarryYuYueCfg()
	for _,v in pairs(yuyue_cfg) do
		if v.seq == seq then
			local begin1, begin2 = math.modf(v.begin_time / 100)
			local end1, end2 = math.modf(v.xunyou_end_time / 100)
			local begin_time = begin1 .. ":" .. begin2 * 100
			local end_time = end1 .. ":" .. string.format("%02d", end2 * 100 > 5 and math.floor(end2 * 100) or math.ceil(end2 * 100))
			local str = begin_time .. "-" .. end_time
			return str
		end
	end
	return ""
end

--设置情缘副本结果
function MarriageData:SetQingYuanFBRewardInfo(protocol)
	self.qingyuan_fb_rewardinfo = protocol
end

function MarriageData:GetQingYuanFBRewardInfo()
	return self.qingyuan_fb_rewardinfo
end

function MarriageData:SetYuYueListInfo(protocol)
	self.my_wedding_type = protocol.param_ch1
	self.yuyue_list_info = bit:d2b(protocol.param5)
	self.role_yuyue_info = {}			-- 婚礼预约标记
	local param_ch6_1 = bit:d2b(protocol.param6_1)
	local param_ch6_2 = bit:d2b(protocol.param6_2)
	for i = 1, 32 do
		self.yuyue_list_info[i + 32] = param_ch6_1[i]
		self.yuyue_list_info[i] = param_ch6_2[i]
	end
end

function MarriageData:GetYuYueInfo()
	return self.yuyue_list_info
end

function MarriageData:GetYuYueListInfo(seq)
	return self.yuyue_list_info[32 - seq] or -1
end

function MarriageData:SetYanHuiType(type)
	self.is_use_bind_diamond = type
end

function MarriageData:GetSelectYanHuiType()
	return self.is_use_bind_diamond
end

--已结过婚
function MarriageData:IsMarred()
	local info = self:GetYuYueRoleInfo().param_ch5
	local reward = bit:d2b(info)
	for i=0,2 do
		if reward[32 - i] == 1 then
			return true
		end
	end
	return false
end
------------------获取婚礼礼包数据---------------------
function MarriageData:GetRewardItemData(seq)
	local reward_item_list = {}
	local marry_cfg = ListToMap(ConfigManager.Instance:GetAutoConfig("qingyuanconfig_auto").marry_cfg, "marry_type")
	return marry_cfg[seq] and marry_cfg[seq].reward_item or nil
end

function MarriageData:GetYuYueTime(seq)
	local wedding_cfg = {}
	for k,v in pairs(ConfigManager.Instance:GetAutoConfig("qingyuanconfig_auto").wedding_yuyue_time) do
		if seq == v.seq then
			wedding_cfg = v
		end
	end
	return wedding_cfg
end

function MarriageData:GetinviteList(tab_type)
	local InviteList = {}
	local vo = GameVoManager.Instance:GetMainRoleVo()
	
	if tab_type == INVITE_TYPE.FRIEND then
		InviteList = ScoietyData.Instance:GetFriendInfo()
	elseif tab_type == INVITE_TYPE.GUILD then
		InviteList = TableCopy(GuildDataConst.GUILD_MEMBER_LIST.list)
		for k,v in pairs(InviteList) do
			if v.uid == vo.role_id then
				table.remove(InviteList, k)
				break
			end
		end
	else
		InviteList = self:GetHaveApplicantInfo()
	end
	return InviteList
end

function MarriageData:SetHunYanYuYueInfo(protocol)
	self.yuyue_info.role_id = protocol.role_id or 0 						--// 被求婚玩家id
	self.yuyue_info.role_name = protocol.role_name or ""					--// 被求婚玩家名字
	self.yuyue_info.lover_role_id = protocol.lover_role_id or 0 			--// 求婚玩家id
	self.yuyue_info.lover_role_name= protocol.lover_role_name or "" 		--// 求婚玩家名字
	self.yuyue_info.wedding_type = protocol.wedding_type or 0 				--// 结婚类型
	self.yuyue_info.have_invite_num = protocol.has_invite_guests_num or 0 	--// 已邀请宾客数量
	self.yuyue_info.have_max_num = protocol.can_invite_guest_num or 20 		--// 能够邀请的宾客最大数
	self.yuyue_info.wedding_yuyue_seq = protocol.wedding_yuyue_seq or 0 	--// 婚宴预约时间段
	self.yuyue_info.role_prof = protocol.role_prof or 0 					--// 被求婚玩家职业
	self.yuyue_info.lover_role_prof = protocol.lover_role_prof or 0 		--// 求婚玩家职业
	self.yuyue_info.wedding_index = protocol.wedding_index or 0 			--// 全服第几对情侣
	self.yuyue_info.count = protocol.count or 0
	self.yuyue_info.data = protocol.guests_list or {} 						--// 宾客列表
end

function MarriageData:SetBiaoBaiInfo(protocol)
	self.biaobai_role_info = protocol
end

function MarriageData:GetBiaoBaiInfo()
	return self.biaobai_role_info
end

function MarriageData:GetHunYanYuYueInfo()
	return self.yuyue_info
end

function MarriageData:GetYuYueGuestId()
	return self.yuyue_info.data
end


function MarriageData:SetHunYanCurWeddingInfo(protocol)
	self.hunyan_info.role_id = protocol.role_id or 0 						--// 被求婚玩家id
	self.hunyan_info.role_name = protocol.role_name or ""					--// 被求婚玩家名字
	self.hunyan_info.lover_role_id = protocol.lover_role_id or 0 			--// 求婚玩家id
	self.hunyan_info.lover_role_name = protocol.lover_role_name or "" 		--// 求婚玩家名字
	self.hunyan_info.role_prof = protocol.role_prof or 0 					--// 被求婚玩家职业
	self.hunyan_info.lover_role_prof = protocol.lover_role_prof or 0 		--// 求婚玩家职业
	self.hunyan_info.cur_wedding_seq = protocol.cur_wedding_seq or 0 		--// 婚宴时间段序号
	self.hunyan_info.wedding_index = protocol.wedding_index or 0 			--// 全服第几对情侣
	self.hunyan_info.count = protocol.count or 0
	self.hunyan_info.guests_uid = protocol.guests_uid or {} 				--// 宾客列表
end

function MarriageData:GetHunYanCurAllInfo()
	return self.hunyan_info
end

function MarriageData:GetHunYanGuestsId()
	return self.hunyan_info.guests_uid
end
	--刷新好友申请列表
function MarriageData:FlushInviteListData(data)
	local friend_list = ScoietyData.Instance:GetFriendInfo()
	local lover_id = GameVoManager.Instance:GetMainRoleVo().lover_uid
	local friend_data = {}
	for k,v in pairs(friend_list) do
		if v.is_online == 1 and lover_id ~= v.user_id then
			v.list_type = 1
			table.insert(friend_data, v)
		end
	end

	if data and next(data) then
		for k = #friend_data, 1, -1 do
			for k2,v2 in pairs(data) do
				if friend_data[k] then
					if friend_data[k].user_id == v2.user_id then
						table.remove(friend_data, k)
					end
				end
			end
		end
	end
	return friend_data
end

function MarriageData:FlushGuildListData(data)
	local guild_list = GuildDataConst.GUILD_MEMBER_LIST.list
	local lover_id = GameVoManager.Instance:GetMainRoleVo().lover_uid
	local role_id = GameVoManager.Instance:GetMainRoleVo().role_id
	local guild_data = {}
	for k,v in pairs(guild_list) do
		if v.uid ~= role_id and v.is_online == 1 and v.uid ~= lover_id then
			v.list_type = 2
			table.insert(guild_data, v)
		end
	end
	if data and next(data) then
		for k = #guild_data, 1, -1 do
			for k2,v2 in pairs(data) do
				if guild_data[k] then
					if guild_data[k].uid == v2.user_id then
						table.remove(guild_data, k)
					end
				end
			end
		end
	end
	return guild_data
end

function MarriageData:FlushApplyListData(data)
	local invite_list = self:GetHaveApplicantInfo()
	local lover_id = GameVoManager.Instance:GetMainRoleVo().lover_uid
	local role_id = GameVoManager.Instance:GetMainRoleVo().role_id
	local invite_data = {}
	for k,v in pairs(invite_list) do
		if v.user_id ~= role_id and v.user_id ~= lover_id then
			v.list_type = 3
			table.insert(invite_data, v)
		end
	end

	if data and next(data) then
		for k = #invite_data, 1, -1 do
			for k2,v2 in pairs(data) do
				if invite_data[k] then
					if invite_data[k].user_id == v2.user_id then
						table.remove(invite_data, k)
					end
				end
			end
		end
	end

	return invite_data
end

---------------------设置坐标-------------------------
function MarriageData:SetXunYouPos(protocol)
	self.xunyou_pos.is_own = protocol.param_ch1
	self.xunyou_pos.x = protocol.param2
	self.xunyou_pos.y = protocol.param3
	self.xunyou_pos.obj_id = protocol.param4
	self.xunyou_pos.scene_id = protocol.param5
end

function MarriageData:GetXunYouPos()
	return self.xunyou_pos
end
---------------------设置祝福-------------------------
function MarriageData:SetBlessingRecordInfo(protocol)
	self.blessing_info = protocol.applicant_list
end

function MarriageData:GetBlessingRecordInfo()
	table.sort(self.blessing_info, SortTools.KeyUpperSorter("timestamp"))
	return self.blessing_info
end

function MarriageData:SetHaveApplicantInfo(protocol)
	self.applicant_info = protocol.applicant_list
end

function MarriageData:GetHaveApplicantInfo()
	return self.applicant_info
end

function MarriageData:GetBlessingListCfg(param)
	for k,v in pairs(self.bless_cfg) do
		if v.param == param then
			return v
		end
	end
end

--得到婚礼祝福元宝配置
function MarriageData:GetBlessMoneyCfg(i)
	for _,v in pairs(self.bless_cfg) do
		if v.blessing_type == 0 and v.seq == i then
			return v
		end
	end
	return nil
end

--得到婚礼祝福鲜花配置
function MarriageData:GetBlessFlowerCfg(i)
	for _,v in pairs(self.bless_cfg) do
		if v.blessing_type == 1 and v.seq == i then
			return v
		end
	end
	return nil
end

--得到婚宴祝福物品列表
function MarriageData:GetBlessHunYanItemList()
	local tab = {}
	for _,v in pairs(self.bless_cfg) do
		if v.blessing_type == 2 then
			tab[v.seq + 1] = v.param
		end
	end
	return tab
end

---------------------获取婚礼玩家个人信息-------------------------
function MarriageData:SetWeddingRoleInfo(protocol)
	self.wedding_role_info.wedding_liveness = protocol.wedding_liveness
	self.wedding_role_info.is_baitang = protocol.is_baitang
	self.wedding_role_info.time = protocol.is_in_red_bag_fulsh_time
	self.wedding_role_info.has_gather_num = protocol.has_gather_num
	self.wedding_role_info.has_gather_red_bag = protocol.has_gather_red_bag
	self.wedding_role_info.total_exp = protocol.total_exp

	self.has_gather_list = protocol.hunyan_food_id_list
end

-- 是否采集过
function MarriageData:GetIsHasGather(id)
	for k,v in pairs(self.has_gather_list) do
		if v == id then
			return true
		end
	end
	return false
end

function MarriageData:GetWeddingRoleInfo()
	return self.wedding_role_info
end

--婚礼热度
function MarriageData:GetHunYanCfgByReDu(liveness)
	local marry_cfg = ConfigManager.Instance:GetAutoConfig("qingyuanconfig_auto").wedding_liveness
	for k,v in pairs(marry_cfg) do
		if liveness < v.liveness_var then
			return v
		end
	end
	return marry_cfg[#marry_cfg]
end

-- 是否可以领取婚宴奖励
function MarriageData:IsCanGetHunliReward(hunli_type)
	local reward_info = MarriageData.Instance:GetYuYueRoleInfo().param_ch5
	local reward = bit:d2b(reward_info)
	return reward[32 - hunli_type] == 0
end

--中式婚礼战斗力
function MarriageData:GetMarriageTipPower(index, power_type)
	local wedding_info = self:GetHunliInfoByType(index)
	if next(wedding_info) == nil then
		return 0
	end

	-- 戒指战力
	local ring_cfg = ItemData.Instance:GetItemConfig(wedding_info.reward_item[0].item_id)
	if ring_cfg == nil then
		return 0
	end
	local ring_power = CommonDataManager.GetCapability(ring_cfg) or 0

	-- 第一档战力
	if power_type == WEDDING_TIPS_POWER_TYPE.RING then
		return ring_power
	else
		-- 称号战力
		local title_cfg = TitleData.Instance:GetTitleCfg(wedding_info.title_id)
		if title_cfg == nil then
			return 0
		end
		local title_power = CommonDataManager.GetCapabilityCalculation(title_cfg) or 0

		-- 第二档战力
		if power_type == WEDDING_TIPS_POWER_TYPE.SECONDGEAR then
			local fashion_cfg = FashionData.Instance:GetFashionCfg(wedding_info.reward_item[1].item_id)
			if next(fashion_cfg) == nil then
				return 0
			end
			local fashion_power = CommonDataManager.GetCapabilityCalculation(fashion_cfg) or 0
			return ring_power + title_power + fashion_power
		-- 第三档战力
		elseif power_type == WEDDING_TIPS_POWER_TYPE.THIRDGEAR then
			local fashion_cfg = FashionData.Instance:GetFashionCfg(wedding_info.reward_item[1].item_id)
			local weapon_cfg = FashionData.Instance:GetWeaponCfg(wedding_info.reward_item[3].item_id)
			if next(fashion_cfg) == nil or next(weapon_cfg) == nil then
				return 0
			end
			local fashion_power = CommonDataManager.GetCapabilityCalculation(fashion_cfg) or 0
			local weapon_power = CommonDataManager.GetCapabilityCalculation(weapon_cfg) or 0
			
			return title_power + fashion_power + weapon_power + ring_power
		end
	end
	return 0
end

-- 欧式婚礼提示框战力
function MarriageData:GetEuropeanMarriageTipPower(wedding_type)
	if wedding_type == nil then
		return 0
	end

	local reward_cfg = self:GetHunliInfoByType(wedding_type)
	if next(reward_cfg) == nil then
		return 0
	end

	-- 称号战力
	local title_cfg =  TitleData.Instance:GetTitleCfg(reward_cfg.title_id) -- TitleData.Instance:GetUpgradeCfg(reward_cfg.title_id)
	if title_cfg == nil then
		return 0
	end
	local title_power = CommonDataManager.GetCapabilityCalculation(title_cfg) or 0

	-- 时装战力
	local fashion_power = 0
	for k,v in pairs(reward_cfg.reward_type) do
		local fashion_cfg = FashionData.Instance:GetFashionCfg(v.item_id)
		fashion_power = fashion_power + CommonDataManager.GetCapabilityCalculation(fashion_cfg)
	end

	local wuqi_power = 0
	for k,v in pairs(reward_cfg.reward_type) do
		local fashion_cfg = FashionData.Instance:GetWeaponCfg(v.item_id)
		wuqi_power = wuqi_power + CommonDataManager.GetCapabilityCalculation(fashion_cfg)
	end

	return title_power + fashion_power + wuqi_power
end

-- 获取当前自己是否在巡游
function MarriageData:GetOwnIsXunyou()
	local activity_info = ActivityData.Instance:GetActivityStatuByType(ACTIVITY_TYPE.WEDDING)
	if activity_info and activity_info.status == HUNYAN_STATUS.XUNYOU and self:IsMarryUser() then
		return true
	end
	return false
end

-- 巡游状态变更
function MarriageData:SetXunYouingObjId(protocol)
	if protocol.param == 1 then
		self.is_show_eff = true
		-- self:SetCoutDown()
		self.xunyou_objid_list[protocol.obj_id] = true
	else
		self.is_show_eff = false
		MarriageCtrl.Instance:FlushMainViewBubble(false)
		self:CancelCoutDown()
		self:CancelCoutDown2()
		self.xunyou_objid_list[protocol.obj_id] = nil
	end
end

function MarriageData:GetObjIdIsXunYouing(obj_id)
	return self.xunyou_objid_list[obj_id]
end
