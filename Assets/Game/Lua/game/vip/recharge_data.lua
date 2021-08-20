PHONE_TYPE = {
	ANDROID = 0,
	IPHONE = 1,
	WINDOW = 2
}

RechargeData = RechargeData or BaseClass()

RechargeData.SPEC_ID = -1
RechargeData.InVaildId = -99
function RechargeData:__init()
	if RechargeData.Instance then
		print_error("[RechargeData] Attemp to create a singleton twice !")
	end
	RechargeData.Instance = self
	if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.Android then
		self.platform = PHONE_TYPE.ANDROID
	elseif UnityEngine.Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then
		self.platform = PHONE_TYPE.IPHONE
	elseif UnityEngine.Application.platform == UnityEngine.RuntimePlatform.OSXEditor or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsEditor  then
		self.platform = PHONE_TYPE.IPHONE
	elseif UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsPlayer then
		self.platform = PHONE_TYPE.WINDOW
	end
	
	self.chongzhi_7day_reward_fetch_day = 0
	self.chongzhi_7day_reward_timestamp = 0
	self.chongzhi_7day_reward_is_fetch  = 0
	self.today_recharge = 0
	RemindManager.Instance:Register(RemindName.Recharge, BindTool.Bind(self.GetRechargeRemind, self))
	RemindManager.Instance:Register(RemindName.SupremeMembers, BindTool.Bind(self.GetSupremeMembersRemind, self))
end

function RechargeData:__delete()
	RemindManager.Instance:UnRegister(RemindName.Recharge)
	RemindManager.Instance:UnRegister(RemindName.SupremeMembers)
	
	RechargeData.Instance = nil
end

function RechargeData:SetChongZhi7DayFetchReward(protocol)
	self.chongzhi_7day_reward_fetch_day = protocol.chongzhi_7day_reward_fetch_day
	self.chongzhi_7day_reward_timestamp = protocol.chongzhi_7day_reward_timestamp
	self.chongzhi_7day_reward_is_fetch  = protocol.chongzhi_7day_reward_is_fetch
	self.today_recharge  = protocol.today_recharge
end

function RechargeData:IsCanGetReward()
	if self:GetSupremeMembersRemind() > 0 then
		return true
	end
	return self:HasBuy7DayChongZhi() and self.chongzhi_7day_reward_is_fetch == 0
end

function RechargeData:GetSupremeMembersRemind()
	local is_remind = RemindManager.Instance:RemindToday(RemindName.SupremeMembers)
	if not is_remind then
		return 1
	end
	if self:HasBuy7DayChongZhi() and self.chongzhi_7day_reward_is_fetch == 0 then
		return 1
	end
	return 0
end

-- 充值18元档 七天返利达成时间
function RechargeData:GetChongZhi7DayRewardDay()
	return self.chongzhi_7day_reward_fetch_day
end

-- 充值18元档 今天是否已领取
function RechargeData:GetChongZhi7DayRewardIsFetch()
	return self.chongzhi_7day_reward_is_fetch
end

function RechargeData:DayRechangeCanReward()
	return self.chongzhi_7day_reward_timestamp > 0 and self.chongzhi_7day_reward_fetch_day < 7 and self.chongzhi_7day_reward_is_fetch == 0
end

function RechargeData:GetTodayRecharge()
	return self.today_recharge
end

-- Mainui_view 充值红点专用
function RechargeData:MainuiViewDayRechangeCanReward()
	if self:DayRechangeCanReward() == true then
		return 1
	else
		return 0
	end
end

-- 充值98元档 是否购买(由之前18元7天档，改为98元永久档)
function RechargeData:HasBuy7DayChongZhi()
	return self.chongzhi_7day_reward_timestamp > 0
end

--获取安卓充值配置
function RechargeData:GetAnroidRechargeCfg()
	return ConfigManager.Instance:GetAutoConfig("recharge_auto").recharge_list
end

--获取苹果充值配置
function RechargeData:GetIPhoneRechargeCfg()
	return ConfigManager.Instance:GetAutoConfig("rechargeappstore_auto").recharge_list
end

--获取充值奖励配置
function RechargeData:GetChongzhiRewardCfg()
	return ConfigManager.Instance:GetAutoConfig("chongzhireward_auto").reward
end

--获取某个充值奖励配置
function RechargeData:GetChongzhiRewardCfgById(recharge_id)
	local data = self:GetRechargeInfo(recharge_id)
	if nil == data then return end
	for k,v in pairs( ConfigManager.Instance:GetAutoConfig("chongzhireward_auto").reward) do
		if v.chongzhi == data.gold then
			return v
		end
	end
	return nil
end

--获取18元档次充值奖励配置
function RechargeData:GetChongzhi18YuanRewardCfg()
	return ConfigManager.Instance:GetAutoConfig("chongzhireward_auto").other[1]
end

--获得需要加载的id
function RechargeData:GetRechargeIdList()
	if self.recharge_data_list == nil then
		local rechange_cfg = {}
		self.recharge_data_list = {}

		if self.platform== PHONE_TYPE.ANDROID then
			rechange_cfg = self:GetAnroidRechargeCfg()
		elseif self.platform == PHONE_TYPE.IPHONE then
			local is_enforce_cfg = GLOBAL_CONFIG.param_list.is_enforce_cfg
			local agent_id = GLOBAL_CONFIG.package_info.config.agent_id
			local pos_first_word = nil
			if agent_id then
				pos_first_word = string.find(agent_id, "i")
			end
			-- 强制用1安卓的配置(用于ios越狱)
			-- 字母i开头的渠道id都是ios正版（剑南说的）
			if is_enforce_cfg == 1 or pos_first_word ~= 1 then
				rechange_cfg = self:GetAnroidRechargeCfg()
			else
				rechange_cfg = self:GetIPhoneRechargeCfg()
			end
		elseif self.platform == PHONE_TYPE.WINDOW then
			rechange_cfg = self:GetAnroidRechargeCfg()
		end
		
		for k,v in pairs(rechange_cfg) do
			local is_show = v.show_ui == 1
			-- if v.id == RechargeData.SPEC_ID and IS_AUDIT_VERSION then
			-- 	is_show = false
			-- end
			if is_show then
				if v.spid_limit_show and v.spid_limit_show ~= "" then
					local limit_list = Split(v.spid_limit_show, ",")
					local can_add = true
					for k1,v1 in pairs(limit_list) do
						if v1 == GLOBAL_CONFIG.package_info.config.agent_id then
							can_add = false
							break
						end
					end
					if can_add then
						self.recharge_data_list[#self.recharge_data_list + 1] = v.id
					end
				else
					self.recharge_data_list[#self.recharge_data_list + 1] = v.id
				end
			end
		end
		function sortfun(a, b)
			return a < b
		end
		table.sort(self.recharge_data_list, sortfun)
	end
	return self.recharge_data_list
end

--获取充值ID对应一列信息
function RechargeData:GetRechargeInfo(rechange_id)
	local rechange_cfg = {}
	local is_enforce_cfg = GLOBAL_CONFIG.param_list.is_enforce_cfg
	local agent_id = GLOBAL_CONFIG.package_info.config.agent_id
	local pos_first_word = nil
	if agent_id then
		pos_first_word = string.find(agent_id, "i")
	end
	-- 强制用1安卓的配置(用于ios越狱)
	-- 字母i开头的渠道id都是ios正版（剑南说的）
	if self.platform == PHONE_TYPE.ANDROID then
		rechange_cfg = self:GetAnroidRechargeCfg()
	elseif self.platform == PHONE_TYPE.IPHONE then
		local is_enforce_cfg = GLOBAL_CONFIG.param_list.is_enforce_cfg
		local agent_id = GLOBAL_CONFIG.package_info.config.agent_id
		local pos_first_word = nil
		if agent_id then
			pos_first_word = string.find(agent_id, "i")
		end
		-- 强制用1安卓的配置(用于ios越狱)
		-- 字母i开头的渠道id都是ios正版（剑南说的）
		if is_enforce_cfg == 1 or pos_first_word ~= 1 then
			rechange_cfg = self:GetAnroidRechargeCfg()
		else
			rechange_cfg = self:GetIPhoneRechargeCfg()
		end
	elseif self.platform == PHONE_TYPE.WINDOW then
		rechange_cfg = self:GetAnroidRechargeCfg()
	end
	for k,v in pairs(rechange_cfg) do
		if v.id == rechange_id then
			return v
		end
	end
end

-- 获取18元档次配置
function RechargeData:GetRecharge18Info(rechange_id)
	for k,v in pairs(self:GetChongzhi18YuanRewardCfg()) do
		if v.id == rechange_id then
			return v
		end
	end
end

--通过索引获得需要加载该索引的集合
function RechargeData:GetRechargeListByIndex(cell_index)
	local all_id_list = self:GetRechargeIdList()
	local recharge_id_list = {}
	if cell_index == 1 then
		for i = 1, 3 do
			if all_id_list[i] ~= nil then
				recharge_id_list[#recharge_id_list + 1] = all_id_list[i]
			else
				recharge_id_list[#recharge_id_list + 1] = RechargeData.InVaildId
			end
		end
		return recharge_id_list
	end
	for i = 1, 3 do
		if all_id_list[(cell_index - 1) * 3 + i] == nil then
			all_id_list[(cell_index - 1) * 3 + i] = RechargeData.InVaildId
		end
		recharge_id_list[#recharge_id_list + 1] = all_id_list[(cell_index - 1) * 3 + i]
	end
	return recharge_id_list
end

function RechargeData:GetRechargeRemind()
	return self:DayRechangeCanReward() and 1 or 0
end









