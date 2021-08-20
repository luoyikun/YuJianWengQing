VIPPOWER =
{
	SCENE_FLY 						= 0,			-- 传送
	KEY_DIALY_TASK 					= 1,			-- 一键日常
	HUSONG_BUY_TIMES 				= 2,			-- 购买护送次数
	VIP_LEVEL_REWARD				= 3,			-- VIP等级礼包
	QIANGHUA_SUC					= 4,			-- 强化成功率
	DAGUAI_EXP_PLUS					= 5,			-- 打怪经验加成
	GO_BOSS_HOME					= 6,			-- 进入BOSS之家
	BUY_LOCK_TOWER_COUNT			= 7,			-- 购买锁妖塔次数
	BUY_YAOSHOU_COUNT				= 8,			-- 购买妖兽广场次数
	VIP_REVIVE 						= 9, 			-- VIP免费复活
	BODY_WAREHOUSE					= 10,			-- 随身仓库
	BODY_DRUGSTORE					= 11,			-- 随身药店
	FOUR_OUTLINE_EXP				= 12,			-- 离线4倍经验领取
	EXP_FB_BUY_TIMES				= 13,			-- 经验本扫荡次数
	COIN_FB_BUY_TIMES				= 14,			-- 铜币本扫荡次数
	BUY_ARENA_CHALLENGE_COUNT		= 15,			-- 购买竞技场挑战次数
	JINGLING_CATCH					= 16, 			-- 精灵捕获
	DAOJU_FB_BUY_TIMES				= 17, 			-- 道具副本购买次数
	CLEAN_MERDIAN_CD 				= 18,			-- 清除经脉CD
	LINGYU_FB_BUY_TIMES 			= 19,			-- 灵玉挑战副本可购买次数
	GUILD_BOX_COUNT 				= 20,			-- 公会宝箱数量
	VAT_FB_STORY_COUNT 				= 21,			-- 剧情副本购买次数
	VAT_FB_PHASE_COUNT 				= 22,			-- 阶段副本购买次数
	HOTSPRING_EXTRA_EXP 			= 23,			-- 温泉活动额外经验万分比
	TEAM_EQUIP_COUNT 				= 24,			-- 组队装备副本购买掉落次数
	BUY_JINGYING_COUNT				= 25,			-- 购买精英BOSS疲劳值
	TOWER_DEFEND_COUNT				= 27,			-- 购买个人塔防挑战次数
	AUTO_SHENGWU_CHOU				= 28,			-- 圣物自动回收碎片
	AUTO_SHENGWU_TEN				= 29,			-- 圣物10次回收
	MINING_CHALLENGE 				= 30, 			-- 决斗场 挑衅
	PUSH_COMMON 					= 31, 			-- 购买元素试炼挑战次数
	PUSH_SPECIAL					= 32, 			-- 购买炼狱试炼挑战次数
	MINING_MINE 					= 33, 			-- 决斗场 挖矿购买次数
	MINING_SEA 						= 34, 			-- 决斗场 航海购买次数
	build_tower_fb_buy_times		= 36, 			-- 塔防副本购买次数
	BUY_ACTIVE_COUNT 				= 25, 			-- 购买活跃BOSS疲劳值(和精英共用一套)
	BABYBOSS_ENTER_TIMES			= 37,			-- 宝宝boss进入次数
	SG_ENTER_TIMES					= 39,			-- 上古BOSS进入次数
	SG_TIRE_TIMES					= 40,			-- 上古BOSS额外疲劳值
	PERSONAL_ENTER_TIMES			= 41,			-- 个人BOSS挑战次数
	KF1V1_TIMES						= 42,			-- 跨服1v1挑战次数
	DABAO_TIMES						= 43,			-- 打宝BOSS进入次数
	PERSON_BOSS_TIMES				= 45,			-- 个人BOSS进入次数
	QUALITY_FB_TIMES				= 46,			-- 品质副本购买次数
	KEY_GUILD_TASK					= 47,			-- 一键仙盟任务权限
	KEY_HUAN_TASK					= 48,			-- 一键跑环任务权限
}

OPEN_VIP_RECHARGE_TYPE =
{
	NONE = 0,
	RECHANRGE = 1,
	LEVEL_INVEST = 2,
	MONTH_INVEST = 3,
	VIP = 4,
}

VipData = VipData or BaseClass()
function VipData:__init()
	if VipData.Instance ~= nil then
		print_error("[VipData] Attemp to create a singleton twice !")
	end
	VipData.Instance = self
	self.vip_info = {}
	self.is_show_temp_vip = false					--是否已经展示过限时vip
	self.is_in_temp_vip = false
	self.open_type = OPEN_VIP_RECHARGE_TYPE.RECHANRGE
	RemindManager.Instance:Register(RemindName.Vip, BindTool.Bind(self.GetVipRemind, self))
	RemindManager.Instance:Register(RemindName.RechargeAndVIP, BindTool.Bind(self.GetIsGetVipRewardFlag, self))
end

function VipData:__delete()
	RemindManager.Instance:UnRegister(RemindName.Vip)
	RemindManager.Instance:UnRegister(RemindName.RechargeAndVIP)
	VipData.Instance = nil
end

function VipData:SetOpenType(open_type)
	self.open_type = open_type
end

function VipData:GetOpenType()
	return self.open_type
end

--vip等级信息变化
function VipData:OnVipInfo(protocol)
	self.fetch_level_reward_flag = protocol.fetch_level_reward_flag
	if self.vip_info.vip_level ~= protocol.vip_level then
		GlobalEventSystem:Fire(ObjectEventType.VIP_CHANGE)
	end
	self.vip_info.vip_level = protocol.vip_level
	self.vip_info.last_free_buyyuanli_timestamp = protocol.last_free_buyyuanli_timestamp
	self.vip_info.fetch_qifu_buyxianhun_reward_flag = protocol.fetch_qifu_buyxianhun_reward_flag
	self.vip_info.fetch_qifu_buycoin_reward_flag = protocol.fetch_qifu_buycoin_reward_flag
	self.vip_info.gold_buyxianhun_times = gold_buyxianhun_times
	self.vip_info.fetch_qifu_buyyuanli_reward_flag = protocol.fetch_qifu_buyyuanli_reward_flag
	self.vip_info.vip_exp = protocol.vip_exp
	self.vip_info.last_free_buyxianhun_timestamp = protocol.last_free_buyxianhun_timestamp
	self.vip_info.last_free_buycoin_timestamp = protocol.last_free_buycoin_timestamp
	self.vip_info.gold_buycoin_times = protocol.gold_buycoin_times
	self.vip_info.free_buyyuanli_times = protocol.free_buyyuanli_times
	self.vip_info.gold_buyyuanli_times = protocol.gold_buyyuanli_times
	self.vip_info.obj_id = protocol.obj_id
	self.vip_info.reward_flag_list = bit:d2b(protocol.fetch_level_reward_flag)
	self.vip_info.free_buyxianhun_times = protocol.free_buyxianhun_times
	self.vip_info.free_buycoin_times = protocol.free_buycoin_times
	self.vip_info.vip_week_gift_resdiue_times = protocol.vip_week_gift_resdiue_times
	self.vip_info.time_temp_vip_time = protocol.time_temp_vip_time					--限时vip结束时间

	if self.vip_info.time_temp_vip_time > 0 then
		self.is_show_temp_vip = true
	end

	if self:IsInTempVip() then
		self.vip_info.vip_level = 0
		self.is_in_temp_vip = true
	else
		self.is_in_temp_vip = false
	end

	RemindManager.Instance:Fire(RemindName.Vip)
end

function VipData:GetTempVipEndTime()
	return self.vip_info.time_temp_vip_time or 0
end

function VipData:GetVipRemind()
	return self:GetVipRewardFetchFlag() and 1 or 0
end

--判斷是否有vip獎勵可以領取
function VipData:GetVipRewardFetchFlag()
	if nil ~= self.vip_info.vip_level and self.vip_info.vip_level > 0 then
		local total_gift_num = 0
		for i = 0, self.vip_info.vip_level-1 do
			total_gift_num = total_gift_num + self:GetVipRewardCfg()[i].reward_item.num
		end
		local vip_week_num = total_gift_num - self.vip_info.vip_week_gift_resdiue_times
		for i = 1, self.vip_info.vip_level do
			if self.vip_info.reward_flag_list and self.vip_info.reward_flag_list[33-i] == 0 then
				return true
			end
		end
	end
	return false
end

function VipData:IsInTempVip()
	local is_in = false
	local server_time = TimeCtrl.Instance:GetServerTime()
	local main_vo = GameVoManager.Instance:GetMainRoleVo()
	if main_vo.vip_level > 0 and next(self.vip_info) and self.vip_info.time_temp_vip_time > server_time then
		is_in = true
	end
	return is_in
end

--获取是否处于限时vip中
function VipData:GetIsInTempVip()
	return self.is_in_temp_vip
end

--检查临时Vip是否结束
function VipData:CheckTempTimeIsEnd()
	local is_end = false
	local server_time = TimeCtrl.Instance:GetServerTime()
	local main_vo = GameVoManager.Instance:GetMainRoleVo()
	if main_vo.vip_level <= 0 and next(self.vip_info) and self.vip_info.time_temp_vip_time <= server_time then
		is_end = true
	end
	return is_end
end

function VipData:GetIsVipRewardByVipLevel(level)
	if level > self.vip_info.vip_level then
		return false
	end
	if level > 0 then
		if self.vip_info.reward_flag_list and self.vip_info.reward_flag_list[33-level] == 0 then
			return true
		else
			return false
		end
	end

	return false
end

--判断是否有VIP周礼包可领
function VipData:GetVipWeekRewardFetchFlag()
	if nil ~= self.vip_info.vip_level and self.vip_info.vip_level > 0 then
		local total_gift_num = 0
		for i = 0, self.vip_info.vip_level-1 do
			total_gift_num = total_gift_num + self:GetVipRewardCfg()[i].reward_item.num
		end
		local vip_week_num = total_gift_num - self.vip_info.vip_week_gift_resdiue_times
		if vip_week_num > 0 then
			return true
		end
	end
	return false
end

-- 获取当前可领取的周礼包数量
function VipData:GetVipWeekRewardNum()
	if nil ~= self.vip_info.vip_level and self.vip_info.vip_level > 0 then
		local total_gift_num = 0
		for i = 0, self.vip_info.vip_level-1 do
			total_gift_num = total_gift_num + self:GetVipRewardCfg()[i].reward_item.num
		end
		local vip_week_num = total_gift_num - self.vip_info.vip_week_gift_resdiue_times
		return vip_week_num
	end
	return 0
end

--获取列表中第一个可以领取奖励的vip等级
function VipData:GetFirstCanFetchGiftVip(exclude_vip)
	if nil ~= self.vip_info.vip_level and self.vip_info.vip_level > 0 then
		for i = 1, self.vip_info.vip_level do
			if exclude_vip ~= i and self.vip_info.reward_flag_list and self.vip_info.reward_flag_list[33-i] == 0 then
				return i
			end
		end
	end
end

function VipData:GetVipInfo()
	return self.vip_info
end

function VipData:GetCurrentVipExp()
	local vip_exp = 0
	if self.vip_info == nil or next(self.vip_info) == nil then 
		return vip_exp 
	end

	local passlevel_consume = self:GetVipExp(self.vip_info.vip_level - 1)
	vip_exp = self.vip_info.vip_exp + passlevel_consume
	
	return vip_exp
end

function VipData:GetVipBuffCfg(vip_level)
	return ConfigManager.Instance:GetAutoConfig("vip_auto").vipbuff[vip_level]
end

function VipData:GetVipLevelCfg()
	return ConfigManager.Instance:GetAutoConfig("vip_auto").level
end

function VipData:GetVipRewardCfg()
	return ConfigManager.Instance:GetAutoConfig("vip_auto").level_reward
end

function VipData:GetVipUpLevelCfg()
	return ConfigManager.Instance:GetAutoConfig("vip_auto").uplevel
end

function VipData:GetVipWeekGiftCfg()
	return ConfigManager.Instance:GetAutoConfig("vip_auto").other[1]
end

function VipData:GetTempVipTime()
	return ConfigManager.Instance:GetAutoConfig("vip_auto").other[1].time_limit_vip_time
end

function VipData:GetVipPowerList(vip_id)
	local vip_cfg = self:GetVipLevelCfg()
	local power_list = {}
	for k,v in pairs(VIPPOWER) do
		if vip_cfg[v] ~= nil then
			power_list[v] = vip_cfg[v]["param_"..vip_id]
		end
	end
	return power_list
end

function VipData:GetVipPowerListIsByIndex(is_get_num)
	local vip_cfg = self:GetVipLevelCfg()
	local power_list = {}
	local index = 1
	for k,v in pairs(vip_cfg) do
		power_list[index] = v
		index = index + 1
	end
	if is_get_num then
		return index - 1
	end
	return power_list
end

--返回所有当前vip的主要权限描述
function VipData:GetVipPowerDesc(vip_id)
	return "待定"
end

function VipData:GetVipRewardFlag(vip_id)
	if not self.vip_info.reward_flag_list then return false end
	local flag = self.vip_info.reward_flag_list[33 - vip_id]

	if flag == 0 then
		return false
	else
		return true
	end
end

function VipData:GetIsGetVipRewardFlag()
	local cfg = ConfigManager.Instance:GetAutoConfig("vip_auto").uplevel
	if cfg then
		for k,v in pairs(cfg) do
			if k > 1 then
				if self.vip_info.reward_flag_list and self.vip_info.reward_flag_list[33 - k + 1] == 0 then
					if self.vip_info.vip_level >= v.level then
						return 1
					end
				end
			end
		end
	end
	return 0
end

function VipData:GetVipType(auth_type)
	for k, v in pairs(self:GetVipLevelCfg()) do
		if v.auth_type == auth_type then
			return v
		end
	end
end

function VipData:GetFBSaodangCount(auth_type, vip_level)
	local main_vo = GameVoManager.Instance:GetMainRoleVo()
	if not auth_type  then return end
	local vip_level = vip_level or main_vo.vip_level
	for k, v in pairs(self:GetVipLevelCfg()) do
		if k == auth_type then
			return v["param_"..vip_level]
		end
	end
	return 0
end

function VipData:GetFBSaodangMaxCount(auth_type)
	if not auth_type  then return end

	local max_count = 0
	for k, v in pairs(self:GetVipLevelCfg()) do
		if k == auth_type then
			for m, n in pairs(v) do
				if string.find(m, "param_") and max_count < n then
					max_count = n
				end
			end
		end
	end
	return max_count
end

-- --返回指定类型的权限描述
-- function VipData:GetVipPowerDesc(auth_type)
-- 	return self:GetVipLevelCfg()[auth_type].power_desc
-- end

-- --返回需要全部权限描述
-- function VipData:GetVipAllPowerDesc(vip_id)
-- 	local desc_list = {}
-- 	local power_list = self:GetVipPowerList(vip_id)
-- 	if vip_id == 1 then
-- 		for k,v in pairs(power_list) do
-- 			if v ~= 0 then
-- 				desc_list[#desc_list + 1] = self:GetDescPostfix(k, v)
-- 			end
-- 		end
-- 	else
-- 		local power_list_before = self:GetVipPowerList(vip_id - 1)
-- 		desc_list[1] = "享受VIP ".. (vip_id - 1).."全部特权并且:"
-- 		for k,v in pairs(power_list) do
-- 			if v ~= power_list_before[k] then
-- 				desc_list[#desc_list + 1] = self:GetDescPostfix(k, v)
-- 			end
-- 		end
-- 	end
-- 	return desc_list
-- end

-- --返回描述后缀
-- function VipData:GetDescPostfix(auth_type,value)
-- 	local show_type = self:GetVipLevelCfg()[auth_type].show_type
-- 	local text = self:GetVipPowerDesc(auth_type)
-- 	if show_type == 2 then
-- 		text = text ..":"..value
-- 	elseif show_type == 3 then
-- 		text =  text.."%" .. value
-- 	end
-- 	return text
-- end

--返回总描述集合
function VipData:GetVipPowerDescList(vip_id)
	local cfg = self:GetVipUpLevelCfg()
	for k,v in pairs(cfg) do
		if v.level == vip_id then
			return Split(v.desc, ",")
		end
	end
end

--获取当前VIP特权描述
function VipData:GetVipCurDescList(index)
	local cfg = ConfigManager.Instance:GetAutoConfig("vip_auto").uplevel
	for k,v in pairs(cfg) do
		if v.level == index then
			return v
		end
	end
end

--获取当前VIP信息
function VipData:GetVipInfoList(vip_level)
	local vip_info = self:GetVipRewardCfg()
	for k,v in pairs(vip_info) do
		if v.level == vip_level  then
			return v
		end
	end
end


--获取当前vip的奖励领取list
function VipData:GetRewardList(vip_id)
	vip_id = vip_id or 0
	if vip_id == 0 then
		vip_id = 1
	end
	local gift_cfg = ItemData.Instance:GetItemConfig(self:GetVipRewardCfg()[vip_id - 1].reward_item.item_id)
	local reward_list = {}
	for i = 1, 8 do
		reward_list[i] = {}
		if i<= gift_cfg.item_num then
			reward_list[i].item_id = gift_cfg["item_" .. i .. "_id"]
			reward_list[i].item_num = gift_cfg["item_" .. i .. "_num"]
		else
			reward_list[i].item_id = 0
			reward_list[i].item_num = 0
		end
	end
	return reward_list
end

--返回当前vip的exp总值
function VipData:GetVipExp(vip_id)
	local total_gold = 0
	for i,v in ipairs(self:GetVipUpLevelCfg()) do
		total_gold = total_gold + v.need_gold
		if v.level == vip_id then
			return total_gold
		end
	end
	return 0
end

-- 是否可以传送
function VipData:GetIsCanFly(vip_level)
	vip_level = vip_level or 0
	local config = self:GetVipLevelCfg()
	if config then
		local auth_config = config[VIPPOWER.SCENE_FLY]
		if auth_config then
			if auth_config["param_" .. vip_level] == 1 then
				return true
			end
		end
	end
	return false
end

--是否可展示限时vip界面
function VipData:CanShowTempVipView()
	local flag = false
	local main_vo = GameVoManager.Instance:GetMainRoleVo()
	local vip_level = main_vo.vip_level
	if next(self.vip_info) and vip_level <= 0 and not self.is_show_temp_vip then
		flag = true
	end
	return flag
end

--记录是否自己主动发送请求限时vip
function VipData:SetIsSendLimitVip()
	self.is_send_temp_vip = true
end

function VipData:GetIsSendTempVip()
	return self.is_send_temp_vip
end

function VipData:GetGiftEffectCfgById(vip_id)
	vip_id = vip_id or 1
	return self:GetVipRewardCfg()[vip_id - 1].item_effect
end

function VipData:GetBabyBossEnterTimes(auth_type, vip_level)
	local main_vo = GameVoManager.Instance:GetMainRoleVo()
	if not auth_type  then return end
	local vip_level = vip_level or main_vo.vip_level
	for k, v in pairs(self:GetVipLevelCfg()) do
		if k == auth_type then
			return v["param_"..vip_level]
		end
	end
	return 0
end

function VipData:GetVipMaxLevel()
	local max_cfg = {}
	for i,v in ipairs(self:GetVipUpLevelCfg()) do
		max_cfg = v
	end
	if max_cfg.level then
		return max_cfg.level
	end
	return 0
end

function VipData:GetShowVipData()
	local num = 15
	if self.vip_info.vip_level then
		local max_vip_level = self:GetVipMaxLevel()
		if self.vip_info.vip_level >= 15 then
			num = self.vip_info.vip_level + 1 > max_vip_level and max_vip_level or self.vip_info.vip_level + 1
		end
	end
	return num
end