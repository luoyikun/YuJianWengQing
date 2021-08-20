HunQiData = HunQiData or BaseClass()

HunQiData.SHENZHOU_WEAPON_MAX_SAVE_COUNT = 24
HunQiData.SHENZHOU_WEAPON_COUNT = 8								--魂器格子数量
HunQiData.SHENZHOU_WEAPON_SLOT_COUNT = 8						--魂器最大八卦牌数量
HunQiData.SHENZHOU_ELEMET_MAX_TYPE = 4							--魂器炼魂最大类型
HunQiData.SLOT_MAX_LEVEL = 100									--八卦牌最大等级
HunQiData.SHENZHOU_WEAPON_BOX_HELP_MAX_CONUT = 4				--最大协助数量
HunQiData.SHENZHOU_HUNYIN_MAX_SLOT = 8							--魂器镶嵌魂印数量
HunQiData.BAOZANG_HELP_NUM = 4									--魂器宝藏最大协助人数
HunQiData.SHENZHOU_XIlIAN_MAX_SLOT = 8							--魂器洗练最大个数
local LingShuMaxLevel = 100	  -- 魂石最大等级

SHENZHOU_REQ_TYPE = {
	SHENZHOU_REQ_TYPE_INFO_REQ = 0,											-- 请求所有信息
	SHENZHOU_REQ_TYPE_BUY_GATHER_TIME = 1,									-- 购买采集次数
	SHENZHOU_REQ_TYPE_EXCHANGE_IDENTIFY_EXP = 2,							-- 兑换鉴定经验
	SHENZHOU_REQ_TYPE_INDENTIFY = 3,										-- 鉴定物品 param1 背包物品下标, param2 鉴定数量
	SHENZHOU_REQ_TYPE_UPGRADE_WEAPON_SLOT = 4,								-- 提升魂器部件等级， param1 魂器类型，param2 魂器部位
	SHENZHOU_REQ_TYPE_GATHER_INFO_REQ = 5,									-- 请求采集信息
	SHENZHOU_REQ_TYPE_HELP_OTHER_BOX = 6,									-- 协助别人的宝箱    param_1 对方的uid
	SHENZHOU_REQ_TYPE_OPEN_BOX = 7,											-- 打开宝箱 param_1 开几次
	SHENZHOU_REQ_TYPE_BOX_INFO = 8,											-- 请求宝箱信息
	SHENZHOU_REQ_TYPE_PUT_BOX = 9,											-- 放入宝箱
	SHENZHOU_REQ_TYPE_UPLEVEL_ELEMENT = 10,									-- 提升元素等级， param1 魂器类型，param2 元素类型
	SHENZHOU_REQ_TYPE_UPLEVEL_LINGSHU = 11,									-- 提升灵枢等级， param1 魂器类型， param2 魂印槽
	SHENZHOU_REQ_TYPE_HUNYIN_INLAY = 12,									-- 镶嵌魂印， param1 魂器类型， param2 魂印槽， param3背包索引
	SHENZHOU_REQ_TYPE_INVITE_HELP_OTHER_BOX = 13,							-- 邀请协助宝箱
	SHENZHOU_REQ_TYPE_REMOVE_HELP_BOX = 14,									-- 清除协助
	SHENZHOU_REQ_TYPE_XILIAN_OPEN_SLOT = 15,                                -- 开启洗练槽，param1 魂器类型， param2 属性槽
	SHENZHOU_REQ_TYPE_XILIAN_REQ = 16,                                      -- 请求洗练，param1 魂器类型， param2锁定槽0-7位表示1-8位属性, param3洗练材料类型,param4 是否自动购买, param5 是否免费
	SHENSHOU_REQ_TYPE_OPEN_HUNYIN_SLOT = 17,								-- 开启魂印槽， param1 魂器类型， param2 魂印槽		
	SHENZHOU_REQ_TYPE_AUTO_UPLEVEL_LINGSHU = 18,							-- 一键提升灵枢等级， param1 魂器类型
}

HunQiData.ElementItemList = {27501, 27502, 27503, 27504}

HunQiData.XiLianStuffColor = {
	FREE = 0,               -- 免费
	BLUE = 1,               -- 蓝
	PURPLE = 2,				-- 紫
	ORANGE = 3,				-- 橙
	RED = 4, 				-- 红
}

HunQiData.EFFECT_PATH = {
	"UI_yihuo_slxh",
	"UI_yihuo_hysy",
	"UI_yihuo_ylxy",
	"UI_yihuo_sqyy",
	"UI_yihuo_gllh",
	"UI_yihuo_hlyh",
	"UI_yihuo_007",
	"UI_yihuo_008",
	"UI_yihuo_009",
	"UI_yihuo_010",
	"UI_yihuo_011",
}

function HunQiData:__init()
	if nil ~= HunQiData.Instance then
		return
	end
	HunQiData.Instance = self

	local hunqi_system_cfg = ConfigManager.Instance:GetAutoConfig("shenzhou_weapon_auto")
	self.hunqi_slot_level_cfg = ListToMapList(hunqi_system_cfg.hunqi_slot_level_attr, "hunqi", "slot", "level")
	self.identify_level_cfg = ListToMapList(hunqi_system_cfg.identify_level, "level", "star_level")
	self.hunqi_skill_cfg = hunqi_system_cfg.hunqi_skill
	self.hunqi_name_cfg = hunqi_system_cfg.hunqi_name
	self.identify_item_cfg = hunqi_system_cfg.identify_item_cfg
	self.exchange_identify_exp_cfg = hunqi_system_cfg.exchange_identify_exp
	self.box_cfg = hunqi_system_cfg.box[1]
	self.box_reward_count_cfg = hunqi_system_cfg.box_reward_count_cfg
	self.other_cfg = hunqi_system_cfg.other[1]
	self.box_reward_cfg = hunqi_system_cfg.box_reward
	self.element_cfg = ListToMapList(hunqi_system_cfg.element_cfg, "hunqi", "element_type", "element_level")
	self.element_name_cfg = hunqi_system_cfg.element_name
	self.hunyin_info = ListToMapList(hunqi_system_cfg.hunyin, "hunyin_id")
	self.hunyin_suit_cfg = hunqi_system_cfg.hunyin_suit
	self.hunyin_all = hunqi_system_cfg.hunyin_all
	self.lingshu_info = ListToMapList(hunqi_system_cfg.lingshu, "hunqi_id", "hunyin_slot", "slot_level")
	self.hunyin_get = hunqi_system_cfg.hunyin_get
	self.hunyin_slot_open = hunqi_system_cfg.hunyin_slot_open
	self.all_item_cfg = ConfigManager.Instance:GetAutoConfig("item/other_auto")
	self.gift_item_cfg = ConfigManager.Instance:GetAutoConfig("item/gift_auto")

	self.xilian_open_cfg = ListToMapList(hunqi_system_cfg.xilian_open, "hunqi_id", "slot_id")
	self.xilian_shuxing_type = ListToMapList(hunqi_system_cfg.xilian_shuxing_type, "hunqi_id", "shuxing_type")
	self.xilian_lock_comsume = hunqi_system_cfg.lock_comsume
	self.xilian_xilian_comsume = hunqi_system_cfg.xilian_comsume
	self.xilian_suit = ListToMapList(hunqi_system_cfg.xilian_suit, "hunqi_id")
	self.xilian_stuff_list = {}
	self:InItXiLianStuffId()

	self.today_gather_times = 0
	self.today_buy_gather_times = 0
	self.today_exchange_identify_exp_times = 0
	self.identify_level = 0
	self.identify_star_level = 0
	self.identify_exp = 0
	self.hunqi_jinghua = 0
	self.box_id = 0
	self.today_open_free_box_times = 0
	self.last_open_free_box_timestamp = 0
	self.today_help_box_num = 0
	self.curent_open_box_type = 1

	self.current_lingshu_exp = 0
	self.current_lingshu_update_need = 0
	self.current_select_hunqi = 1
	self.hunyin_is_inlay = true

	self.day_free_xilian_times = 0
	self.xilian_data = {}
	self.is_show_xilian_red = true
	self.is_shield = false

	RemindManager.Instance:Register(RemindName.HunQi_HunQi, BindTool.Bind(self.CalcHunQiRedPoint, self))
	RemindManager.Instance:Register(RemindName.HunQi_DaMo, BindTool.Bind(self.CalcDaMoRedPoint, self))
	RemindManager.Instance:Register(RemindName.HunQi_HunYin, BindTool.Bind(self.CalcaHunYinRedPoint, self))
	RemindManager.Instance:Register(RemindName.HunQi_BaoZang, BindTool.Bind(self.CalcBaoZangRedPoint, self))
	RemindManager.Instance:Register(RemindName.HunQi_XiLian, BindTool.Bind(self.CalcHunQiXiLianShuRedPoint, self))

	self.item_data_event = BindTool.Bind1(self.ItemDataChangeCallback, self)
	ItemData.Instance:NotifyDataChangeCallBack(self.item_data_event)
end

function HunQiData:__delete()
	RemindManager.Instance:UnRegister(RemindName.HunQi_HunQi)
	RemindManager.Instance:UnRegister(RemindName.HunQi_DaMo)
	RemindManager.Instance:UnRegister(RemindName.HunQi_HunYin)
	RemindManager.Instance:UnRegister(RemindName.HunQi_BaoZang)
	RemindManager.Instance:UnRegister(RemindName.HunQi_XiLian)
	
	if nil ~= HunQiData.Instance then
		HunQiData.Instance = nil
	end

	if self.item_data_event ~= nil and ItemData.Instance then
		ItemData.Instance:UnNotifyDataChangeCallBack(self.item_data_event)
		self.item_data_event = nil
	end
end

function HunQiData:SetCurentOpenBoxType(type)
	self.curent_open_box_type = type
end

function HunQiData:GetCurentOpenBoxType()
	return self.curent_open_box_type
end

function HunQiData:SetIdentifyRewardList(reward_list)
	self.identify_reward_list = reward_list
end

function HunQiData:GetIdentifyRewardList()
	return self.identify_reward_list
end

function HunQiData:SetHunQiAllInfo(protocol)
	self.today_gather_times = protocol.today_gather_times											--今日采集总数
	self.today_buy_gather_times = protocol.today_buy_gather_times									--今日购买采集总次数
	self.today_exchange_identify_exp_times = protocol.today_exchange_identify_exp_times				--今日兑换鉴定经验次数
	self.identify_level = protocol.identify_level												 	--鉴定等级
	self.identify_star_level = protocol.identify_star_level											--鉴定星级
	self.identify_exp = protocol.identify_exp														--鉴定经验
	self.hunqi_jinghua = protocol.hunqi_jinghua														--魂器精华
	self.lingshu_exp = protocol.lingshu_exp

	self.day_free_xilian_times = protocol.day_free_xilian_times                                     --今日已免费洗练次数
	self.xilian_data = protocol.xilian_data                                                         --洗练信息
	self.hunqi_list = protocol.all_weapon_level_list												--魂器信息列表
end

function HunQiData:SetBaoZangInfo(protocol)
	self.box_id = protocol.box_id
	self.today_open_free_box_times = protocol.today_open_free_box_times								--今天免费开启的宝箱次数
	self.last_open_free_box_timestamp = protocol.last_open_free_box_timestamp						--今天最后免费开启宝箱的时间
	self.today_help_box_num = protocol.today_help_box_num											--今天协助次数
	
	self.box_help_uid_list = protocol.box_help_uid_list												--已协助列表
end

function HunQiData:GetBoxId()
	return self.box_id
end

function HunQiData:GetTodayOpenFreeBoxNum()
	return self.today_open_free_box_times
end

function HunQiData:GetLastOpenFreeBoxTimeStamp()
	return self.last_open_free_box_timestamp
end

function HunQiData:GetTodayCanHelpBoxNum()
	local times = 0
	if nil == self.other_cfg then
		return times
	end
	local max_help_times = self.other_cfg.box_help_num_limit
	times = max_help_times - self.today_help_box_num
	return times
end

--获取宝箱最大免费开启次数
function HunQiData:GetMaxFreeBoxTimes()
	local times = 0
	if nil == self.other_cfg then
		return times
	end
	return self.other_cfg.box_free_times
end

function HunQiData:GetReplaceID()
	local replacement_id = 0
	if nil == self.other_cfg then
		return replacement_id
	end
	return self.other_cfg.replacement_id
end

function HunQiData:GetTenReplaceID()
	local open_box_10_use_itemid = 0
	if nil == self.other_cfg then
		return open_box_10_use_itemid
	end
	return self.other_cfg.open_box_10_use_itemid
end

--获取宝箱免费开启的cd时间
function HunQiData:GetFreeBoxCD()
	local cd = 0
	if nil == self.other_cfg then
		return cd
	end
	return self.other_cfg.box_free_times_cd
end

function HunQiData:GetBoxHelpList()
	return self.box_help_uid_list
end

--获取协助人数
function HunQiData:GetHelpCount()
	local count = 0
	if nil == self.box_help_uid_list then
		return count
	end

	for _, v in ipairs(self.box_help_uid_list) do
		if v > 0 then
			count = count + 1
		end
	end
	return count
end

function HunQiData:GetBoxRewardCfg()
	return self.box_reward_cfg
end

--获取宝藏配置表
function HunQiData:GetBoxCfg()
	return self.box_cfg
end

function HunQiData:GetBoxRewardCountCfg()
	if nil == self.box_reward_count_cfg then
		return nil
	end
	local role_level = GameVoManager.Instance:GetMainRoleVo().level
	local cfg = nil
	for k, v in ipairs(self.box_reward_count_cfg) do
		if role_level >= v.level then
			cfg = v
		end
	end
	return cfg
end

--获取魂器红点
function HunQiData:CalcHunQiRedPoint()
	if not OpenFunData.Instance:CheckIsHide("hunqi") then
		return 0
	end
	local goal_info =  self:GetGoalInfo()
	if goal_info ~= nil and goal_info.active_flag ~= nil and goal_info.fetch_flag ~= nil then
		if (goal_info.active_flag[0] == 1 and goal_info.fetch_flag[0] == 0) or (goal_info.fetch_flag[0] == 1 and goal_info.active_flag[1] == 1 and goal_info.fetch_flag[1] == 0) then
			return 1
		end
	end

	local flag = 0
	if nil == self.hunqi_list then
		return flag
	end
	--判断材料是否足够
	for k, v in ipairs(self.hunqi_list) do
		if flag == 1 then
			break
		end
		local hunqi_level = v.weapon_level
		if hunqi_level < HunQiData.SLOT_MAX_LEVEL then
			local kapai_level_list = v.weapon_slot_level_list
			for i, j in ipairs(kapai_level_list) do
				if j < HunQiData.SLOT_MAX_LEVEL then
					local kapai_data = self:GetSlotAttrByLevel(k-1, i-1, j)
					if nil ~= kapai_data then
						kapai_data = kapai_data[1]
						local up_level_item_data = kapai_data.up_level_item
						local now_item_num = ItemData.Instance:GetItemNumInBagById(up_level_item_data.item_id)
						if now_item_num >= up_level_item_data.num then
							flag = 1
							break
						end
					end
				end
			end
		end

		--判断炼魂红点
		local element_level_list = v.element_level_list
		for i, j in ipairs(element_level_list) do
			local next_attr_info = HunQiData.Instance:GetSoulAttrInfo(k-1, i-1, j+1)
			if nil ~= next_attr_info then
				local attr_info = HunQiData.Instance:GetSoulAttrInfo(k-1, i-1, j)
				attr_info = attr_info[1]
				local limit_level = attr_info.huqi_level_limit
				if hunqi_level >= limit_level then
					local up_level_item = attr_info.up_level_item
					local have_num = ItemData.Instance:GetItemNumInBagById(up_level_item.item_id)
					if have_num >= up_level_item.num then
						flag = 1
						break
					end
				end
			end
		end
	end
	return flag
end

--获取打磨红点
function HunQiData:CalcDaMoRedPoint()
	if not OpenFunData.Instance:CheckIsHide("hunqi_damo") then
		return 0
	end
	local flag = 0
	--判断是否存在可以打磨的物品
	local damo_list = self:GetIdentifyItemList()
	if nil == damo_list then
		return flag
	end
	for k, v in ipairs(damo_list) do
		local item_id = v.consume_item_id
		local have_num = ItemData.Instance:GetItemNumInBagById(item_id)
		if have_num > 0 then
			flag = 1
			break
		end
	end
	return flag
end

function HunQiData:CalcaHunYinRedPoint()
	if not OpenFunData.Instance:CheckIsHide("hunyin") then
		return 0
	end

	local flag = 0
	for i = 1, HunQiData.SHENZHOU_WEAPON_COUNT do
		if self:CalcHunQiBtnRedPoint(i) then
			flag = 1
			break
		end
	end

	return flag
	
end

--获取宝藏红点
function HunQiData:CalcBaoZangRedPoint()
	if not OpenFunData.Instance:CheckIsHide("hunqi_bao") then
		return 0
	end

	-- 寻宝仓库按钮红点
	local xunbao_cangku = TreasureData.Instance:GetChestItemInfo()
	if next(xunbao_cangku) then
		return 1
	end

	local replacement_id = self:GetReplaceID()
	local item_count = ItemData.Instance:GetItemNumInBagById(replacement_id)
	if item_count > 0 then
		return 1
	end

	local open_box_10_use_itemid = self:GetTenReplaceID()
	local item_count_10 = ItemData.Instance:GetItemNumInBagById(open_box_10_use_itemid)
	if item_count_10 > 0 then
		return 1
	end	

	local flag = 0
	--先判断是否有免费次数
	if self.today_open_free_box_times < self:GetMaxFreeBoxTimes() then
		local server_time = TimeCtrl.Instance:GetServerTime()
		local times = server_time - self.last_open_free_box_timestamp
		--再判断是否在cd时间内
		if times >= self:GetFreeBoxCD() then
			flag = 1
		end
	end
	return flag
end

--是否已经查看过一次宝箱红点消息
function HunQiData:SetIsCheckBoxRemind(state)
	self.is_check_box_remind = state
end

function HunQiData:GetIsCheckBoxRemind()
	return self.is_check_box_remind
end

--获取对应魂器的战斗力
function HunQiData:GetHunQiCapability(hunqi_index)
	local capability = 0
	if nil == self.hunqi_list then
		return capability
	end
	local kapai_data_list = self.hunqi_list[hunqi_index].weapon_slot_level_list
	if nil == kapai_data_list then
		return capability
	end
	local attr_info = CommonStruct.Attribute()
	for k, v in ipairs(kapai_data_list) do
		local attr_data = self:GetSlotAttrByLevel(hunqi_index-1, k-1, v)
		if nil ~= attr_data then
			attr_data = attr_data[1]
			attr_data = CommonDataManager.GetAttributteByClass(attr_data)
			attr_info = CommonDataManager.AddAttributeAttr(attr_info, attr_data)
		end
	end
	capability = CommonDataManager.GetCapabilityCalculation(attr_info)
	return capability
end

--获取总属性列表
function HunQiData:GetAllAttrInfo()
	local all_attr_info = CommonStruct.Attribute()
	if nil == self.hunqi_list then
		return all_attr_info
	end
	for k, v in ipairs(self.hunqi_list) do
		local kapai_data_list = v.weapon_slot_level_list
		for i, j in ipairs(kapai_data_list) do
			local attr_data = self:GetSlotAttrByLevel(k-1, i-1, j)
			if nil ~= attr_data then
				attr_data = attr_data[1]
				attr_data = CommonDataManager.GetAttributteByClass(attr_data)
				all_attr_info = CommonDataManager.AddAttributeAttr(all_attr_info, attr_data)
			end
		end
	end
	return all_attr_info
end

--获取对应魂器八卦牌的属性
function HunQiData:GetSlotAttrByLevel(hunqi, slot, level)
	if nil == self.hunqi_slot_level_cfg or nil == self.hunqi_slot_level_cfg[hunqi] or nil == self.hunqi_slot_level_cfg[hunqi][slot] then
		return nil
	end
	return self.hunqi_slot_level_cfg[hunqi][slot][level]
end

function HunQiData:GetidentifyLevelInfo(level, star_level)
	if nil == self.identify_level_cfg or nil == self.identify_level_cfg[level] then
		return nil
	end
	return self.identify_level_cfg[level][star_level]
end

--获取魂器名字和颜色
function HunQiData:GetHunQiNameAndColorByIndex(hunqi_index)
	local name = ""
	local color = GameEnum.ITEM_COLOR_WHITE
	if nil == self.hunqi_name_cfg then
		return name, color
	end
	for k, v in ipairs(self.hunqi_name_cfg) do
		if v.hunqi == hunqi_index then
			if self:IsActiveSpecial(hunqi_index+1) then
				name = v.other_name or ""
			else
				name = v.name or ""
			end
			color = v.color or GameEnum.ITEM_COLOR_WHITE
			break
		end
	end
	return name, color
end

--获取技能名字
function HunQiData:GetHunQiSkillByIndex(hunqi_index)
	local skill_name = ""
	if nil == self.hunqi_name_cfg then
		return skill_name
	end
	for k, v in ipairs(self.hunqi_name_cfg) do
		if v.hunqi == hunqi_index then
			skill_name = v.skill_name or ""
			break
		end
	end
	return skill_name
end

--获取魂器的资源id
function HunQiData:GetHunQiResIdByIndex(hunqi_index)
	local res_id = 0
	if nil == self.hunqi_name_cfg then
		return res_id
	end
	for k, v in ipairs(self.hunqi_name_cfg) do    
		if v.hunqi == hunqi_index then
			res_id = v.res_id or 0
			break
		end
	end
	return res_id
end

function HunQiData:GetHunQiSkillResIdByIndex(hunqi_index)
	local res_id = 0
	if nil == self.hunqi_name_cfg then
		return res_id
	end
	for k, v in ipairs(self.hunqi_name_cfg) do
		if v.hunqi == hunqi_index then
			res_id = v.skill_img or 0
			break
		end
	end
	return res_id
end

--获取对应的技能信息
function HunQiData:GetSkillInfoByIndex(hunqi_index, level, is_next)
	if nil == self.hunqi_skill_cfg then
		return nil
	end

	for k, v in ipairs(self.hunqi_skill_cfg) do
		if hunqi_index == v.hunqi then
			if level == v.level then
				if is_next then
					local skill_info = self.hunqi_skill_cfg[k+1]
					if skill_info and skill_info.hunqi ~= hunqi_index then
						skill_info = nil
					end
					return skill_info
				else
					return v
				end
			elseif level < v.level then
				if is_next then
					return v
				else
					return self.hunqi_skill_cfg[k-1]
				end
			end
		end
	end
end

--返回魂器图标名称等信息表
function HunQiData:GetHunQiNameTable()
	return self.hunqi_name_cfg
end

--获取对应的魂器等级
function HunQiData:GetHunQiLevelByIndex(hunqi_index)
	local level = 0
	if nil == self.hunqi_list then
		return level
	end
	if nil == self.hunqi_list[hunqi_index + 1] then
		return level
	end
	level = self.hunqi_list[hunqi_index + 1].weapon_level or 0
	return  level
end

--获取打磨需要消耗的物品列表
function HunQiData:GetIdentifyItemList()
	return self.identify_item_cfg
end

function HunQiData:GetIdentifyLevel()
	return self.identify_level
end

function HunQiData:GetIdentifyStarLevel()
	return self.identify_star_level
end

function HunQiData:GetHunQiList()
	return self.hunqi_list
end

--获取已兑换经验次数
function HunQiData:GetExChangeTimes()
	return self.today_exchange_identify_exp_times
end

function HunQiData:GetExChangeCfg()
	return self.exchange_identify_exp_cfg
end

--获取当前经验
function HunQiData:GetNowExp()
	return self.identify_exp
end

function HunQiData:GetTodayLeftGatherTimes()
	local left_times = 0
	if nil == self.other_cfg then
		return left_times
	end
	local total_count = self.other_cfg.role_day_gather_num + self.today_buy_gather_times
	left_times = total_count - self.today_gather_times
	return left_times
end

--获取单个魂魄的属性列表
function HunQiData:GetSoulAttrInfo(hunqi, element_type, element_level)
	if nil == self.element_cfg or nil == self.element_cfg[hunqi] or nil == self.element_cfg[hunqi][element_type] then
		return nil
	end
	return self.element_cfg[hunqi][element_type][element_level]
end

--获取下一个有增加属性百分比的属性列表
function HunQiData:GetNextAddAttrInfo(hunqi, element_type, element_level)
	if nil == self.element_cfg or nil == self.element_cfg[hunqi] or nil == self.element_cfg[hunqi][element_type] then
		return nil
	end
	for k, v in pairs(self.element_cfg[hunqi][element_type]) do
		if k > element_level then
			local attr_info = self.element_cfg[hunqi][element_type][element_level]
			if attr_info then
				attr_info = attr_info[1]
				local now_attr_add_per = attr_info.attr_add_per
				local attr_add_per = v[1].attr_add_per
				if attr_add_per > now_attr_add_per then
					return v
				end
			end
		end
	end
	return nil
end

--是否已激活了特殊属性(用于魂器特殊展示使用)hunqi_index从1开始
function HunQiData:IsActiveSpecial(hunqi_index)
	local is_active_special = false
	if nil == self.hunqi_list then
		return is_active_special
	end
	local hunqi_data = self.hunqi_list[hunqi_index]
	if nil == hunqi_data then
		return is_active_special
	end
	local element_level_list = hunqi_data.element_level_list
	local active_count = 0
	for k, v in ipairs(element_level_list) do
		if v > 0 then
			active_count = active_count + 1
		end
	end
	if active_count >= HunQiData.SHENZHOU_ELEMET_MAX_TYPE then
		is_active_special = true
	end
	return is_active_special
end

function HunQiData:GetElementNameByType(element_type)
	local name = ""
	if nil == self.element_name_cfg then
		return name
	end

	for k, v in ipairs(self.element_name_cfg) do
		if v.element_type == element_type then
			name = v.element_name
			break
		end
	end
	return name
end

--获取魂器聚魂总属性(包括特殊属性)hunqi_index从1开始
function HunQiData:GetAllElementAttrInfo(hunqi_index)
	if nil == self.hunqi_list then
		return nil
	end

	local attr_list = CommonStruct.Attribute()
	local special = 0
	for k1, v1 in ipairs(self.hunqi_list) do
		if hunqi_index == k1 then
			local element_level_list = v1.element_level_list
			for k2, v2 in ipairs(element_level_list) do
				local attr_info = self:GetSoulAttrInfo(k1-1, k2-1, v2)
				if nil ~= attr_info then
					attr_info = attr_info[1]
					special = special + attr_info.attr_add_per
					attr_info = CommonDataManager.GetAttributteByClass(attr_info)
					attr_list = CommonDataManager.AddAttributeAttr(attr_list, attr_info)
				end
			end
		end
	end
	attr_list.special = special
	return attr_list
end

--获取魂器信息
function HunQiData:GetHunQiInfoList()
	return self.hunqi_list
end

--通过索引获取魂器的魂印列表信息
function HunQiData:GetHunYinListByIndex(hunqi_index)
	local hunyin_slot_list = {}
	if nil ~= self.hunqi_list and nil ~= self.hunqi_list[hunqi_index] and nil ~= self.hunqi_list[hunqi_index].hunyin_slot_list then
		hunyin_slot_list = self.hunqi_list[hunqi_index].hunyin_slot_list
	end
	return hunyin_slot_list
end

--灵枢经验
function HunQiData:GetLingshuExp()
	return self.lingshu_exp or 0
end

function HunQiData:GetCurrentHunYinSuitLevel(hunqi_index)
	return self.hunqi_list[hunqi_index].hunyin_suit_level or 0
end

function HunQiData:GetHunQiInfo()
	return self.hunyin_info or {}
end

function HunQiData:IsHunyinItem(item_id)
 	return nil ~= self.hunyin_info[item_id]
end

function HunQiData:GetHunYinSuitCfgByIndex(index)
	local data = {}
	if nil ~= self.hunyin_suit_cfg then
		for k,v in pairs(self.hunyin_suit_cfg) do
			if v.hunqi_id == index then
			 table.insert(data, v)  
			end
		end
	end
	return data
end

function HunQiData:GetHunYinAllInfo()
	return self.hunyin_all or {}
end

--根据等级 魂器ID取得灵枢属性
function HunQiData:GetLingshuAttrByIndex(hunqi, solt, level)
	local cfg = self.lingshu_info[hunqi]
	if cfg and cfg[solt] and cfg[solt][level] and cfg[solt][level][1] then
		return cfg[solt][level][1]
	end
	return {}
end

function HunQiData:GetHunYinGet()
	return self.hunyin_get or {}
end

function HunQiData:IsHunYinLockAndNeedLevel(hunqi_id, hunyin_id)
	if not hunqi_id then return end
	
	hunqi_id = hunqi_id - 1
	local current_hunyin_open_list = {}
	for k,v in pairs(self.hunyin_slot_open) do
	 	if hunqi_id == v.hunqi then
	 		table.insert(current_hunyin_open_list, v)
	 	end
	end
	if current_hunyin_open_list[hunyin_id] then
		local need_level = current_hunyin_open_list[hunyin_id].open_hunqi_level
		return self:GetHunQiLevelByIndex(hunqi_id) < need_level, need_level
	end
	return false, 0
end

function HunQiData:GetSoltOpenCfg(hunqi_id, hunyin_slot)
	hunqi_id = hunqi_id - 1
	for k,v in pairs(self.hunyin_slot_open) do
	 	if hunqi_id == v.hunqi and hunyin_slot == v.hunyin_slot then
	 		return v
	 	end
	end
end

--获取魂印对应icon
function HunQiData:GetHunYinItemIconId(item_id)
	if nil ~= self.all_item_cfg[item_id] then
		return self.all_item_cfg[item_id].icon_id
	else
		return 0
	end
end

function HunQiData:GetGiftItemIconId(item_id)
	if nil ~= self.gift_item_cfg[item_id] then
		return self.gift_item_cfg[item_id].icon_id
	else
		return 0
	end
end

function HunQiData:GetHunQiHunYinOpenLevel(hunqi_index)
	for k,v in pairs(self.hunyin_slot_open) do
		if v.hunqi == hunqi_index then
			return v.open_hunqi_level or 0
		end
	end
	return 0
end

--设置灵枢经验以及当前灵枢需要的经验
function HunQiData:SetLingShuExpAndCurrentNeed(current, need)
	self.current_lingshu_exp = current or 0
	self.current_lingshu_update_need = need or 0
end

function HunQiData:GetLingShuExpAndCurrentNeed()
	return self.current_lingshu_exp, self.current_lingshu_update_need
end

--设置当前选择的魂器
function HunQiData:SetCurrenSelectHunqi(current_select_hunqi)
	self.current_select_hunqi = current_select_hunqi or 1
end

function HunQiData:GetCurrenSelectHunqi()
	return self.current_select_hunqi or 1
end

--获取当前魂印列表
function HunQiData:GetCurrentHunYinListInfo()
	return self:GetHunYinListByIndex(self.current_select_hunqi)
end

function HunQiData:SetIsInlayOrUpdate(state)
	self.hunyin_is_inlay = state
end

-- 计算镶嵌红点, 根据当前选中的异火
function HunQiData:CalcHunYinInlayRedPoint(hunqi_index)
	for i = 1, HunQiData.SHENZHOU_HUNYIN_MAX_SLOT do
		if self:CalcShenglingInlayCellInlayRedPoint(i, hunqi_index) then
			return true
		end
	end

	return false
end

-- 计算魂石升级红点, 根据当前选中的异火
function HunQiData:CalcHunYinLingShuRedPoint(hunqi_index)
	for i = 1, HunQiData.SHENZHOU_HUNYIN_MAX_SLOT do
	 	if self:ShowLingShuUpdateRep(i, hunqi_index) then
	 		return true
	 	end
	end

	return false
end

-- 计算洗练红点
function HunQiData:CalcHunQiXiLianShuRedPoint()
	if not OpenFunData.Instance:CheckIsHide("hunqi_xilian") then
		return 0
	end
	local has_item = false
 
	for i,v in ipairs(self.xilian_xilian_comsume) do
		if 0 ~= v.consume_item.item_id then
			local item_num = ItemData.Instance:GetItemNumInBagById(v.consume_item.item_id)
			if item_num > 0 then
				has_item = true
				break
			end
		end 
	end

	local num = (self.is_show_xilian_red and has_item) and 1 or 0
	return num
end

function HunQiData:CalcHunQiXiLianShuRedPointById(hunqi_id)
	return 0
end

--计算魂器按钮红点
function HunQiData:CalcHunQiBtnRedPoint(hunqi_index)
	for i = 1, 8 do
		if self:CalcShenglingInlayCellInlayRedPoint(i, hunqi_index) or self:CalcShenglingInlayCellUpdateRedPoint(i, hunqi_index) then
			return true
		end
	end
	return false
end

function HunQiData:CalcShenglingInlayCellInlayRedPoint(index, hunqi_index)
	--index 1-8 -1为当前solt_index
	if nil == hunqi_index then
		hunqi_index = self.current_select_hunqi
	end
	local current_hunqi_data = self:GetHunYinListByIndex(hunqi_index)
	--先判断当前魂器是否开启
	local level = self:GetHunQiLevelByIndex(hunqi_index - 1)
	local open_level = self:GetHunQiHunYinOpenLevel(hunqi_index - 1)
	--未开启直接返回false
	if level < open_level then
		return false
	end
	local current_shengling_data = current_hunqi_data[index]

	if nil == current_shengling_data then
		return false
	end
		-- 没开槽
	if current_shengling_data.is_lock == 0 then
		return false
	end
	local current_hunyin_id = current_shengling_data.hunyin_id
	local bag_hunyin_info = {}
	local item_id_list = {}
	for k,v in pairs(self.hunyin_info) do
		table.insert(item_id_list, k)
	end
	for k, v in pairs(item_id_list) do
		local count = ItemData.Instance:GetItemNumInBagById(v)
		local solt_index = self.hunyin_info[v][1].inlay_slot + 1
		if count > 0 and solt_index == index then
			table.insert(bag_hunyin_info, {item_id = v, solt_index = solt_index, })
		end
	end
	if current_hunyin_id == 0 then
		--未镶嵌
		for k,v in pairs(bag_hunyin_info) do
			--如果有可镶嵌在当前槽的魂印
			if v.solt_index == index then
				return true
			end
		end
	else
		--已镶嵌
		for k,v in pairs(bag_hunyin_info) do
			--如果有可镶嵌在当前槽的魂印	
			if self.hunyin_info[v.item_id] and self.hunyin_info[current_hunyin_id] then		
				if v.solt_index == index and self.hunyin_info[v.item_id][1].hunyin_color > self.hunyin_info[current_hunyin_id][1].hunyin_color then
					return true
				end
			end
		end
	end
	return false
end

--计算魂石升级界面下魂器按钮的红点
function HunQiData:CalcShenglingInlayCellUpdateRedPoint(index, hunqi_index)
	--index 1-8 -1为当前solt_index
	if nil == hunqi_index then
		hunqi_index = self.current_select_hunqi
	end
	if self:ShowLingShuUpdateRep(index, hunqi_index) then
		return true
	end
	return false
end

--显示灵枢升级按钮红点
function HunQiData:ShowLingShuUpdateRep(shengling_index, hunqi_index)
	if nil == hunqi_index then
		hunqi_index = self.current_select_hunqi
	end
	--判断魂器是否开启
	local is_lock = self:IsHunYinLockAndNeedLevel(hunqi_index, shengling_index)
	if is_lock then
		return false
	end
	--判断魂石是否镶嵌魂印
	local current_lingshu_exp = self:GetLingshuExp()
	local current_lingshu_info = self:GetHunYinListByIndex(hunqi_index)[shengling_index]
	if nil == current_lingshu_info then
		return false
	end

	local lingshu_level = current_lingshu_info.lingshu_level
	local hunyin_id = current_lingshu_info.hunyin_id
	if hunyin_id == 0 or nil == self.hunyin_info[hunyin_id] then
		return false
	end
	local hunyin_color = self.hunyin_info[hunyin_id][1].hunyin_color
	--是否达到魂石升级上限
	if lingshu_level >= LingShuMaxLevel then
		return false
	end
	local lingshu_attr_cfg = self:GetLingshuAttrByIndex(hunqi_index - 1, shengling_index - 1,lingshu_level)
	if lingshu_attr_cfg and next(lingshu_attr_cfg) ~= nil then
		local current_lingshu_update_need = lingshu_attr_cfg.up_level_exp
		if current_lingshu_exp ~= 0 then
			if current_lingshu_exp >= current_lingshu_update_need then
				return true
			end
		end
	end
	return false
end

function HunQiData:GetOtherCfg()
	return self.other_cfg
end

function HunQiData:GetHunQiXiLianOpenCfg(hunqi_id, slot_id)
	return self.xilian_open_cfg[hunqi_id][slot_id][1]
end

function HunQiData:GetHunQiXiLianShuXingType(hunqi_id, shuxing_type)
	if self.xilian_shuxing_type[hunqi_id][shuxing_type] then
		return self.xilian_shuxing_type[hunqi_id][shuxing_type][1]
	end
	return {}
end

function HunQiData:GetHunQiXiLianLockConsume(num)
	return self.xilian_lock_comsume[num + 1]
end

function HunQiData:GetHunQiXiLianLockConsumeByLockNumAndLockComsumeID(lock_num, lock_comsume_ID)
	lock_num = lock_num or 0
	lock_comsume_ID = lock_comsume_ID or self.xilian_lock_comsume[lock_num].lock_comsume_ID
	return self.xilian_lock_comsume[lock_num][lock_comsume_ID]
end

function HunQiData:GetHunQiXiLianFreeTimes()
	return self.day_free_xilian_times
end

function HunQiData:GetHunQiXiLianInfoById(hunqi_id)
	return self.xilian_data[hunqi_id]
end

function HunQiData:GetHunQiXiLianShuXingRange(hunqi_id, shuxing_type, shuxing_star)
	local cfg = self:GetHunQiXiLianShuXingType(hunqi_id, shuxing_type)
	local min_value = cfg["star_min_" .. shuxing_star - 1]
	local max_value = cfg["star_max_" .. shuxing_star - 1]
	return min_value, max_value
end

function HunQiData:GetHunQiXiLianTotalStarNumById(hunqi_id)
	local num = 0
	if not self.xilian_data[hunqi_id] then
		return num
	end
	for i,v in ipairs(self.xilian_data[hunqi_id].xilian_shuxing_star) do
		num = num + v
	end
	return num
end

function HunQiData:GetHunQiXiLianOpenConsume(hunqi_id, slot_id)
	if not self.xilian_data[hunqi_id] then
		return
	end
	local open_list = {}
	local cfg = self.xilian_open_cfg[hunqi_id - 1]
	local open_flag_info = self.xilian_data[hunqi_id].xilian_slot_open_falg
	local yet_open = -1
	for i,v in ipairs(open_flag_info) do
		if v == 1 then
			yet_open = 32 - i
			break
		end
	end
	local total_consume = 0
	for i = yet_open + 2, slot_id do
		total_consume = total_consume + cfg[i - 1][1].gold_cost
		table.insert(open_list, cfg[i - 1][1].slot_id)
	end
	return slot_id - (yet_open + 1), total_consume, open_list
end

function HunQiData:GetHunQiXiLianConsumeCfg()
	return self.xilian_xilian_comsume
end

function HunQiData:GetHunQiXiLianDefaultInfo()
	local stuff_cfg = {}
	local consume_cfg = self.xilian_xilian_comsume
	for i,v in ipairs(consume_cfg) do
		if v.comsume_color ~= HunQiData.XiLianStuffColor.FREE then
			local stuff_num = ItemData.Instance:GetItemNumInBagById(v.consume_item.item_id)
			if stuff_num > 0 then
				stuff_cfg = v
			end
		end
	end
	if not next(stuff_cfg) then
		stuff_cfg = consume_cfg[HunQiData.XiLianStuffColor.BLUE + 1]
	end
	return stuff_cfg
end

function HunQiData:GetHunQiXiLianStuffList()
	local consume_list = {}
	local consume_cfg = self.xilian_xilian_comsume
	for i,v in ipairs(consume_cfg) do
		if v.comsume_color ~= HunQiData.XiLianStuffColor.FREE then
			table.insert(consume_list, v)
		end
	end
	return consume_list
end

function HunQiData:GetHunQiXiLianSuitAttrById(hunqi_id)
	local star_num = self:GetHunQiXiLianTotalStarNumById(hunqi_id + 1)
	local cfg = self.xilian_suit[hunqi_id]
	if not cfg then return end
	local suit_index = 0
	for i,v in ipairs(cfg) do
		if star_num >= v.need_start_count then
			suit_index = i
		end
	end
	local cur_attr = {}
	local next_attr = {}
	if 0 == suit_index then
		cur_attr = nil
		next_attr = cfg[suit_index + 1]
	elseif #cfg == cur_attr then
		cur_attr = cfg[suit_index]
		next_attr = nil
	else
		cur_attr = cfg[suit_index]
		next_attr = cfg[suit_index + 1]
	end
	return cur_attr, next_attr
end

function HunQiData:GetHunQiXiLianHasRareById(hunqi_id)
	local has_rare = false
	local num = 0
	if not self.xilian_data[hunqi_id] then
		return has_rare
	end
	for i,v in ipairs(self.xilian_data[hunqi_id].xilian_shuxing_star) do
		if v >= 7 and not self:GetXiLianContentView():GetIsLockByIndex(i) then
			has_rare = true
			num = num + 1
		end 
	end
	return has_rare, num
end

-- 洗练战力计算
function HunQiData:GetHunQiXiLianCapability(hunqi_id)
	local capability = 0
	local xilian_info = self.xilian_data[hunqi_id]
	if not xilian_info then
		return capability
	end

	local attr_base_list = {}
	local attr_hunqi_list = {}
	local attr_jianding_list = {}
	local suit_attr = {}
	for i = 1, HunQiData.SHENZHOU_XIlIAN_MAX_SLOT do
		local attr_open = xilian_info.xilian_slot_open_falg[33 - i]
		local attr_type = xilian_info.xilian_shuxing_type[i]
		local attr_value = xilian_info.xilian_shuxing_value[i]
		if 1 == attr_open then
			local attr_cfg = self:GetHunQiXiLianShuXingType(hunqi_id - 1, attr_type)
			local attr_name = Language.HunQi.XiLianAttr[attr_type]
			if not attr_name then
				return 0
			end
			if 1 == attr_cfg.shuxing_classify then
				if attr_base_list[attr_name] then
					attr_base_list[attr_name] = attr_base_list[attr_name] + attr_value
				else
					attr_base_list[attr_name] = attr_value
				end
			elseif 2 == attr_cfg.shuxing_classify then
				if attr_hunqi_list[attr_name] then
					attr_hunqi_list[attr_name] = attr_hunqi_list[attr_name] + attr_value
				else
					attr_hunqi_list[attr_name] = attr_value
				end
			else
				if attr_jianding_list[attr_name] then
					attr_jianding_list[attr_name] = attr_jianding_list[attr_name] + attr_value
				else
					attr_jianding_list[attr_name] = attr_value
				end
			end
		end
	end

	-- 基础属性
	attr_base_list = CommonDataManager.GetAttributteByClass(attr_base_list)
	-- 魂器百分比属性
	attr_hunqi_list = self:GetHunQiXiCapability(hunqi_id, attr_hunqi_list)
	-- 鉴定百分比属性
	attr_jianding_list = self:GetHunQiJianDingCapability(hunqi_id, attr_jianding_list)
    --套装属性
	suit_attr = self:GetHunQiXiLianSuitCapability(hunqi_id)

	local total_attr = CommonDataManager.AddAttributeAttr(attr_base_list, attr_hunqi_list)
	local total_attr2 = CommonDataManager.AddAttributeAttr(total_attr, attr_jianding_list)
	local total_attr3 = CommonDataManager.AddAttributeAttr(total_attr2, suit_attr)
	capability = CommonDataManager.GetCapability(total_attr3)
	return capability
end
-- 魂器属性计算
function HunQiData:GetHunQiXiCapability(hunqi_id, attr_hunqi_list)
	attr_hunqi_list = CommonDataManager.GetAttributteByClass(attr_hunqi_list)
	-- 魂器百分比属性
	if nil == self.hunqi_list then
		return attr_hunqi_list
	end

	local kapai_data_list = self.hunqi_list[hunqi_id].weapon_slot_level_list
	if nil == kapai_data_list then
		return attr_hunqi_list
	end

	local hunqi_attr_info = self:GetAllAttrInfo()

	for k,v in pairs(attr_hunqi_list) do
		if v > 0 then
			attr_hunqi_list[k] = hunqi_attr_info[k] * v / 10000
		end
	end
	return attr_hunqi_list
end

-- 鉴定属性计算
function HunQiData:GetHunQiJianDingCapability(hunqi_id, attr_jianding_list)
	attr_jianding_list = CommonDataManager.GetAttributteByClass(attr_jianding_list)
	local big_level = self:GetIdentifyLevel()
	local small_level = self:GetIdentifyStarLevel()
	local jian_ding_attr_info = HunQiData.Instance:GetidentifyLevelInfo(big_level, small_level)
	if nil == jian_ding_attr_info then
		return attr_jianding_list
	end
	jian_ding_attr_info = CommonDataManager.GetAttributteByClass(jian_ding_attr_info[1])

	for k,v in pairs(attr_jianding_list) do
		if v > 0 and jian_ding_attr_info[k] then
			attr_jianding_list[k] = jian_ding_attr_info[k] * v / 10000
		end
	end
	return attr_jianding_list
end

-- 魂器洗练套装属性计算
function HunQiData:GetHunQiXiLianSuitCapability(hunqi_id)
	local cur_attr, next_attr = HunQiData.Instance:GetHunQiXiLianSuitAttrById(hunqi_id - 1)
	local cur_add_per = 0
	if cur_attr then
		cur_add_per = cur_attr.add_per / 100
	end
	local total_attribute = CommonStruct.Attribute()
	for i = 1, HunQiData.SHENZHOU_WEAPON_COUNT  do
		local hunyin_data = self:GetHunYinListByIndex(i)
		for k, v in ipairs(hunyin_data) do
			-- 灵枢部分加成
			local data = self:GetLingshuAttrByIndex(i - 1, k - 1, v.lingshu_level)
			local attribute = CommonDataManager.MulAttribute(CommonDataManager.GetAttributteByClass(data), (cur_add_per / 100))
			total_attribute = CommonDataManager.AddAttributeAttr(total_attribute, attribute)
			-- 魂印部分加成
			local hunyin_cfg = self.hunyin_info[v.hunyin_id]
			if hunyin_cfg then
				hunyin_cfg = hunyin_cfg[1]
				attribute = CommonDataManager.MulAttribute(CommonDataManager.GetAttributteByClass(hunyin_cfg), (cur_add_per / 100))
				total_attribute = CommonDataManager.AddAttributeAttr(total_attribute, attribute)
			end
		end
	end
	return total_attribute
end

function HunQiData:SetXiLianRedPoint(value)
	self.is_show_xilian_red = value
end

function HunQiData:GetXiLianRedPoint()
	return self.is_show_xilian_red
end

function HunQiData:InItXiLianStuffId()
	for i,v in ipairs(self.xilian_xilian_comsume) do
		if 0 ~= v.consume_item.item_id then
			self.xilian_stuff_list[v.consume_item.item_id] = v.consume_item.item_id
		end 
	end
end

function HunQiData:ItemDataChangeCallback(item_id, index, reason, put_reason, old_num, new_num)
	if self.xilian_stuff_list[item_id] then
		if new_num > old_num then
			self.is_show_xilian_red = true
			RemindManager.Instance:Fire(RemindName.HunQi_XiLian)
		end
	end

	local replacement_id = self:GetReplaceID()
	if item_id == replacement_id then
		RemindManager.Instance:Fire(RemindName.HunQi_BaoZang)
	end

	local open_box_10_use_itemid = self:GetTenReplaceID()
	if item_id == open_box_10_use_itemid then
		RemindManager.Instance:Fire(RemindName.HunQi_BaoZang)
	end	
end

function HunQiData:SetXiLianContentView(view)
	self.XiLianContentView = view
end

function HunQiData:GetXiLianContentView()
	return self.XiLianContentView
end

function HunQiData:GetIsShield()
	return self.is_shield
end

function HunQiData:SetIsShield(is_shield)
	self.is_shield = is_shield
end

function HunQiData:SetGoalInfo(protocol)
	self.goal_info = {}
	self.goal_info.open_system_timestamp = protocol.open_system_timestamp
	self.goal_info.active_flag = protocol.active_flag
	self.goal_info.fetch_flag = protocol.fetch_flag
	self.goal_info.active_special_attr_flag = protocol.active_special_attr_flag
end

function HunQiData:GetGoalInfo()
	return self.goal_info
end

function HunQiData:GetLookCfg()
	return ConfigManager.Instance:GetAutoConfig("shenzhou_weapon_auto").box_look or {}
end


function HunQiData:GetTaoZhuangAttr(hunqi_index)
	local cfg = self:GetHunYinSuitCfgByIndex(hunqi_index - 1)
	local hunqi_info = self:GetHunYinListByIndex(hunqi_index) 
	local hunyin_info = self:GetHunQiInfo()
	local color_list = {} 	--4代表橙色, 5红色
	for k, v in pairs(hunqi_info) do
		if v.hunyin_id > 0 and hunyin_info[v.hunyin_id] and hunyin_info[v.hunyin_id][1] and hunyin_info[v.hunyin_id][1].hunyin_color then
			local color_index = hunyin_info[v.hunyin_id][1].hunyin_color
			color_list[color_index] = color_list[color_index] or 0
			color_list[color_index] = color_list[color_index] + 1
		end
	end

	if color_list[5] ~= nil or color_list[6] ~= nil then
		color_list[5] = (color_list[5] or 0) + (color_list[6] or 0)
	end

	local attribute = CommonStruct.AttributeNoUnderline()
	if not cfg or not hunqi_info then 
		return attribute
	end

	for k, v in pairs(cfg) do
		if v.suit_color == 4 then
			if color_list[4] and color_list[4] >= v.same_qulitily_count then
				local temp_attribute = CommonDataManager.GetAttributteNoUnderline(v)
				local per_attribute = CommonDataManager.GetRolePercentAttrNoUnderline(v)
				attribute = CommonDataManager.AddAttributeAttrNoUnderLine(attribute, temp_attribute)
				attribute = CommonDataManager.AddAttributeAttrNoUnderLine(attribute, per_attribute)
			end
		else
			if color_list[5] and color_list[6] and color_list[5] + color_list[6] >= v.same_qulitily_count then
				local temp_attribute = CommonDataManager.GetAttributteNoUnderline(v)
				local per_attribute = CommonDataManager.GetRolePercentAttrNoUnderline(v)
				attribute = CommonDataManager.AddAttributeAttrNoUnderLine(attribute, temp_attribute)
				attribute = CommonDataManager.AddAttributeAttrNoUnderLine(attribute, per_attribute)
			end
		end
	end

	return attribute
end