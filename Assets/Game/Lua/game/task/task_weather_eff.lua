TaskWeatherEff = TaskWeatherEff or BaseClass()

-- 触发随机天气系统的等级
local TRIGGER_LEVEL = 170
local Effect_Name =
{
	[1] = {bundle_name = "effects/prefab/environment/tongyong/tianqi_guangshu_prefab", assst_name = "tianqi_guangshu"},
	[2] = {bundle_name = "effects/prefab/environment/tongyong/xiayu_prefab", assst_name = "xiayu", voice = "thunder"},
	[3] = {bundle_name = "effects/prefab/environment/tongyong/xddt01_xeu_prefab", assst_name = "Xddt01_xeu"},
	[4] = {bundle_name = "effects/prefab/environment/tongyong/dalei_prefab", assst_name = "dalei", voice = "thunder"},
}

function TaskWeatherEff:__init()
	self.task_change = GlobalEventSystem:Bind(OtherEventType.TASK_CHANGE, BindTool.Bind(self.OnTaskChange, self))
	self.change_scene_handle = GlobalEventSystem:Bind(SceneEventType.SCENE_LOADING_STATE_QUIT, BindTool.Bind1(self.OnSceneChangeComplete, self))
	self.scene_quit_handle = GlobalEventSystem:Bind(SceneEventType.SCENE_LOADING_STATE_ENTER, BindTool.Bind1(self.RemoveWeatherEff, self))
	self.close_weather_change = GlobalEventSystem:Bind(SettingEventType.CLOSE_WEATHWE, BindTool.Bind1(self.OnCloseWeatherChanged, self))
end

function TaskWeatherEff:__delete()
	if self.task_change then
		GlobalEventSystem:UnBind(self.task_change)
		self.task_change = nil
	end
	if self.change_scene_handle then
		GlobalEventSystem:UnBind(self.change_scene_handle)
		self.change_scene_handle = nil
	end
	if self.scene_quit_handle then
		GlobalEventSystem:UnBind(self.scene_quit_handle)
		self.scene_quit_handle = nil
	end
	if self.close_weather_change then
		GlobalEventSystem:UnBind(self.close_weather_change)
		self.close_weather_change = nil
	end

	GlobalTimerQuest:CancelQuest(self.time_quest)
	self.time_quest = nil

	self:RemoveWeatherEff()
end


function TaskWeatherEff:OnTaskChange(task_event_type, task_id)
	local is_show, name, asset, voice = self:CheckTask()
	if is_show then
		self:RemoveWeatherEff()
		self:ShowWeatherEff(is_show, name, asset, voice)
	else
		local level = PlayerData.Instance:GetRoleVo().level
		if level < TRIGGER_LEVEL then
			self:ShowWeatherEff(false)
		end
	end
end

function TaskWeatherEff:OnSceneChangeComplete()
	self:CheckCanShowEff()
end

function TaskWeatherEff:CheckCanShowEff()
	local is_show, name, asset, voice = self:CheckTask()
	if is_show then
		self:ShowWeatherEff(is_show, name, asset, voice)
	else
		local level = PlayerData.Instance:GetRoleVo().level
		local effect_list = FuBenData.Instance:RandWeather(Scene.Instance:GetSceneId())
		if level >= TRIGGER_LEVEL and #effect_list > 0 then
			if math.random() <= 0.3 then
				self:RemoveWeatherEff()
				if #effect_list > 0 then
					local index = effect_list[math.random(1,#effect_list)]
					local asset = Effect_Name[index]
					self:ShowWeatherEff(true, asset.assst_name, asset.bundle_name, asset.voice)
				end
			end
		else
			self:ShowWeatherEff(false)
		end
	end
end

function TaskWeatherEff:CheckTask()
	local zhu_task_list = TaskData.Instance:GetTaskListIdByType(TASK_TYPE.ZHU)
	if zhu_task_list[1] then
		return TaskData.Instance:ShowWeatherEff(zhu_task_list[1])
	else
		return false
	end
end

local weather_eff_name = nil
local show_voice = nil
function TaskWeatherEff:ShowWeatherEff(is_show, name, asset, voice)
	if IsLowMemSystem then
		return
	end
	if IS_AUDIT_VERSION then
		return
	end
	show_voice =voice
	if is_show and voice and voice ~= "" then
		if nil == self.time_quest then
			self.time_quest = GlobalTimerQuest:AddRunQuest(BindTool.Bind(self.ShowVioce, self, voice), 8)
		end
	elseif self.time_quest then
		GlobalTimerQuest:CancelQuest(self.time_quest)
		self.time_quest = nil
	end
	if IsNil(MainCamera) or nil == MainCamera.transform  then
		print_warning("MainCamera not exist", asset, name)
		return
	end
	weather_eff_name = is_show and name or nil
	if weather_eff_name and (IsNil(self.weather_eff) or weather_eff_name ~= name) then
		ResPoolMgr:GetDynamicObjAsyncInQueue(asset, name, function(obj)
			if nil == obj or IsNil(MainCamera) or nil == MainCamera.transform then
				print_warning("obj not exist", asset, name)
				return
			end
			if IsNil(MainCamera) or nil == MainCamera.transform  then
				print_warning("MainCamera not exist", asset, name)
				return
			end
			if self.weather_eff then
				self:RemoveWeatherEff()
			end
			local transform = obj.transform
			transform:SetParent(MainCamera.transform, false)
			self.weather_eff = obj
			self:CheckWeatherSetting()
		end)
	elseif not weather_eff_name then
		self:RemoveWeatherEff()
	end
end

function TaskWeatherEff:ShowVioce()
	local flag = SettingData.Instance:GetSettingData(SETTING_TYPE.CLOSE_WEATHWE)
	if not flag and show_voice and show_voice ~= "" then
		AudioManager.PlayAndForget("audios/sfxs/other", show_voice)
	end
end

function TaskWeatherEff:RemoveWeatherEff()
	if not IsNil(self.weather_eff) then
		ResPoolMgr:Release(self.weather_eff)
	end
	self.weather_eff = nil
end

function TaskWeatherEff:OnCloseWeatherChanged()
	self:CheckWeatherSetting()
end

function TaskWeatherEff:CheckWeatherSetting()
	local flag = SettingData.Instance:GetSettingData(SETTING_TYPE.CLOSE_WEATHWE)
	if not IsNil(self.weather_eff) then
		self.weather_eff:SetActive(not flag)
	end
end

function TaskWeatherEff:SetGuideFbEff(index)
	self:RemoveWeatherEff()
	local asset = Effect_Name[index]
	self:ShowWeatherEff(true, asset.assst_name, asset.bundle_name, asset.voice)
end