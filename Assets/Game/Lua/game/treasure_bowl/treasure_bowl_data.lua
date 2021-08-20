TreasureBowlData = TreasureBowlData or BaseClass()

TREASURE_BOWL_ITEM_TYPE =
{
	MOUNT = 1,
	WORLD_BOSS = 2,
	DAILY_TASK = 3,
	GUILD_TASK = 4,
	MANY_FUBEN = 5,
	HUSONG = 6,
	KF1V1 = 7,
	ADVANCE_FUBEN = 8,
}

function TreasureBowlData:__init()
	if TreasureBowlData.Instance then
		print_error("[TreasureBowlData] Attemp to create a singleton twice !")
	end
	TreasureBowlData.Instance = self
	-- self.task_cfg = ServerActivityData.Instance:GetCurrentRandActivityConfig().new_cornucopia
	-- self.total_reward_cfg = ServerActivityData.Instance:GetCurrentRandActivityConfig().new_cornucopia_total
	-- self.other_cfg = ServerActivityData.Instance:GetCurrentRandActivityConfig().other
end

function TreasureBowlData:__delete()
	TreasureBowlData.Instance = nil
end

function TreasureBowlData:IsProtocolReach()
	return (self.treasure_bowl_info ~= nil)
end

function TreasureBowlData:GetActivityLeftDays()
	return (6 - self.treasure_bowl_info.cornucopia_day_index)
end

--同步服务器信息
function TreasureBowlData:OnTreasureBowlInfo(protocol)
	if self.task_cfg == nil then
		self.task_cfg = ServerActivityData.Instance:GetCurrentRandActivityConfig().new_cornucopia
	end
	if self.total_reward_cfg == nil then
		self.total_reward_cfg = ServerActivityData.Instance:GetCurrentRandActivityConfig().new_cornucopia_total
	end

	self.treasure_bowl_info = protocol
	self.scroller_data = {}

	--滚动条信息
	local open_day = self.treasure_bowl_info.cornucopia_day_index
	for i = 1, #self.task_cfg do
		local task = {}
		for k,v in pairs(self.task_cfg[i]) do
			task[k] = v
		end
		if open_day == task.opengame_day then
			table.insert(self.scroller_data, task)
		else
			break
		end
	end

	local sever_task_list = protocol.task_list
	for k,v in pairs(self.scroller_data) do
		if k == 1 then
			v.process_value = sever_task_list[v.task_type + 1] - 1
		else
			v.process_value = sever_task_list[v.task_type + 1]
		end
	end
	--箱子信息
	self.box_data = {}
	for k,v in pairs(self.total_reward_cfg) do
		local data = {}
		for m,n in pairs(v) do
			data[m] = n
		end
		local get_flag = self.treasure_bowl_info.cornucopia_total_reward_flag
		data.have_got = (bit:_and(get_flag, bit:_lshift(1, data.seq)) ~= 0)
		data.can_get = (self.treasure_bowl_info.total_cornucopia_value >= data.cornucopia_value)
		table.insert(self.box_data, data)
	end
end

--获取服务器信息
function TreasureBowlData:GetTreasureBowlInfo()
	return self.treasure_bowl_info
end

--获取全服聚宝值奖励信息
function TreasureBowlData:GetTotalJuBaoRewardInfo()
	return self.box_data
end

--获取充值返利加成(未除百分比)
function TreasureBowlData:GetChongzhiFanli()
	if self.other_cfg == nil then
		self.other_cfg = ServerActivityData.Instance:GetCurrentRandActivityConfig().other
	end
	local open_day = self.treasure_bowl_info.cornucopia_day_index
	if open_day <= self.other_cfg[1].opengame_day then
		return self.other_cfg[1].new_cornucopia_percent
	end

	for k,v in pairs(self.other_cfg) do
		if v.opengame_day >= open_day then
			return v.new_cornucopia_percent
		end
	end
end

--获取钻石加成
function TreasureBowlData:GetDiamondPercent()
	local percent_count = 0
	for k,v in pairs(self.scroller_data) do
		if k == 1 then
			if v.process_value >= v.task_value - 1 then
				percent_count = percent_count + v.add_percent
			end
		else
			if v.process_value >= v.task_value then
				percent_count = percent_count + v.add_percent
			end
		end

	end
	return percent_count
end

function TreasureBowlData:GetMaxTotalJuBaoValue()
	if self.total_reward_cfg == nil then
		self.total_reward_cfg = ServerActivityData.Instance:GetCurrentRandActivityConfig().new_cornucopia_total
	end
	local max_value = 0
	for k,v in pairs(self.total_reward_cfg) do
		if v.cornucopia_value > max_value then
			max_value = v.cornucopia_value
		end
	end
	return max_value
end

--获取滚动条数据
function TreasureBowlData:GetTaskScrollerData()
	return self.scroller_data
end

-- 通过任务类型获取数据
function TreasureBowlData:GetDataByType(task_type)
	local data = {}
	for k,v in pairs(self.task_cfg) do
		if task_type == v.task_type then
			table.insert(data,v)
		end
	end

	return data[1]
end

function TreasureBowlData:GetOpenViewName(index)
	local list = {}
	if index == TREASURE_BOWL_ITEM_TYPE.MOUNT then
		list.view_name = ViewName.Advance
		list.tab_index = TabIndex.mount_jinjie
	elseif index == TREASURE_BOWL_ITEM_TYPE.WORLD_BOSS then
		list.view_name = ViewName.Boss
		list.tab_index = TabIndex.world_boss
	elseif index == TREASURE_BOWL_ITEM_TYPE.MANY_FUBEN then
		list.view_name = ViewName.FuBen
	elseif index == TREASURE_BOWL_ITEM_TYPE.SINGLE_FUNBEN then
		list.view_name = ViewName.Boss
		list.tab_index = TabIndex.world_boss
	elseif index == TREASURE_BOWL_ITEM_TYPE.KF1V1 then
		list.view_name = ViewName.Activity
		list.tab_index = TabIndex.activity_battle
	elseif index == TREASURE_BOWL_ITEM_TYPE.ADVANCE_FUBEN then
		list.view_name = ViewName.FuBen
	end
	return list
end