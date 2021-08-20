HOT_KEY ={
	SYS_SETTING_3 = 0,								-- 系统设置3
	SYS_SETTING_1 = 1,								-- 系统设置1
	SYS_SETTING_2 = 2,								-- 系统设置2
	SYS_SETTING_DROPDOWN_1 = 3,						-- 系统设置存储DROPDOWN值
	SYS_SETTING_AUTO_OPERATE = 4,					-- 系统自动操作
	SYS_SETTING_DROPDOWN_2 = 5,						-- 系统设置存储DROPDOWN值
	MARRY_EQUIP = 6,								-- 情缘装备
	FB_ENTER_FLAG1 = 7,								-- 活动副本进入标记
	FB_ENTER_FLAG2 = 8,								-- 活动副本进入标记2
	FB_ENTER_FLAG3 = 9,								-- 活动副本进入标记3
	FB_ENTER_FLAG4 = 10,							-- 活动副本进入标记4
	FB_ENTER_FLAG5 = 11,							-- 活动副本进入标记5
	GUIDE_KEY_FLAG1 = 12,							-- 功能引导标记1
	GUIDE_KEY_FLAG2 = 13,							-- 功能引导标记2
	CAMERA_KEY_FLAG = 14,							-- 摄像机镜头
	CAMERA_ROTATION_X = 15,							-- 摄像机镜头参数-RotationX
	CAMERA_ROTATION_Y = 16,							-- 摄像机镜头参数-RotationY
	CAMERA_DISTANCE = 17,							-- 摄像机镜头参数-Distance
	FEIXINA_EQUIP = 18,								-- 自动拾取飞仙装备
	APPERANCE = 19,									-- 外观(面饰、头饰、麒麟臂等)
	Common_EQUIP = 20,								-- 自动拾取普通装备
	ADVANCE_TYPE = 21,								-- 屏蔽进阶类型
	AUTO_USE_SKILL = 22,							-- 技能是否自动释放
	FB_WEAPON_LEVELSWITCH = 23,						-- 武器副本关卡是否切换过标志
}

SETTING_TYPE = {
	SHIELD_OTHERS 		= 1,						--屏蔽其他玩家
	SELF_SKILL_EFFECT	= 2,						--屏蔽自己技能特效
	SHIELD_SAME_CAMP 	= 3,						--屏蔽友方玩家
	SKILL_EFFECT 		= 4,						--屏蔽他人技能特效
	CLOSE_BG_MUSIC 		= 5,						--关闭背景音乐
	CLOSE_SOUND_EFFECT	= 6,						--关闭音效
	FLOWER_EFFECT		= 7,						--屏蔽送花特效
	FRIEND_REQUEST 		= 8,						--拒绝好友邀请
	STRANGER_CHAT 		= 9,						--拒绝陌生私聊
	CLOSE_TITLE			= 10,   					--屏蔽称号显示
	CLOSE_HEARSAY		= 11,						--屏蔽传闻
	CLOSE_GODDESS		= 12,						--屏蔽女神
	AUTO_RELEASE_SKILL	= 13,						--自动释放技能
	AUTO_RELEASE_ANGER	= 14,						--自动释放怒气技能
	CLOSE_SHOCK_SCREEN	= 15,						--关闭震屏效果
	AUTO_PICK_PROPERTY	= 16,						--自动拾取道具
	AUTO_RECYCLE_EQUIP	= 17,						--自动回收装备
	-- USE_NOTBLIND_EQUIP	= 18,					--只消耗非绑定装备
	SHIELD_ENEMY  = 18,								--屏蔽怪物
	SHIELD_SPIRIT = 19,								--屏蔽精灵

	
	AUTO_LUCK_SCREEN = 25,							--自动上锁 (设置面板对应20号toggle)
	CLOSE_WEATHWE = 26,								--关闭天气
	AUTO_RELEASE_GODDESS_SKILL = 27,				--自动释放女神技能 (22)

	AUTO_USE_FLY_SHOE = 28,							--使用小飞鞋 (23)
	SHIELD_LINGCHONG = 29,							--屏蔽灵童
	SHIELD_FLYPET = 30,								--屏蔽飞宠
	AUTO_MOJIE_SKILL = 31,							--自动使用特戒技能
	AUTO_USE_SHENMO = 32,							--自动变身
	AUTO_USE_HIGH_FPS = 33,							--使用高帧率

	AUTO_PICK_COLOR		= 101,
	AUTO_RECYCLE_COLOR	= 102,
}

-- 注意：最大只能存16个！
SETTING_APPERANCE_TYPE = {
	SHIELD_OTHER_TOUSHI = 1,						-- 屏蔽他人头饰
	SHIELD_OTHER_MIANSHI = 2,						-- 屏蔽他人面饰
	SHIELD_OTHER_QILINBI = 3,						-- 屏蔽他人麒麟臂
	SHIELD_OTHER_LINGZHU = 4,						-- 屏蔽他人灵珠
	SHIELD_OTHER_YAOSHI = 5,						-- 屏蔽他人腰饰
}

RolePartApperanceSettingType = {
	[SceneObjPart.TouShi] = SETTING_APPERANCE_TYPE.SHIELD_OTHER_TOUSHI,
	[SceneObjPart.Waist] = SETTING_APPERANCE_TYPE.SHIELD_OTHER_YAOSHI,
	[SceneObjPart.QilinBi] = SETTING_APPERANCE_TYPE.SHIELD_OTHER_QILINBI,
	[SceneObjPart.Mask] = SETTING_APPERANCE_TYPE.SHIELD_OTHER_MIANSHI,
	[SceneObjPart.TouShi] = SETTING_APPERANCE_TYPE.SHIELD_OTHER_TOUSHI,
}

-- 帧率相关的控制
local fps_sampler_time = 5 		-- 帧率采样时间
local lower_fps_times = 4 		-- 低帧率连续出现次数
local auto_setting_fps = 30 	-- 低于多少帧率启动自动屏弊
SYSTEM_AUTO_OPERATE = {}

function InitFpsSetting()
	if GAME_FPS <= 30 then
		auto_setting_fps = 25

		SYSTEM_AUTO_OPERATE =
		{
			[SETTING_TYPE.SHIELD_OTHERS] = {fps = 25, index = 32},
			[SETTING_TYPE.SHIELD_SAME_CAMP] = {fps = 25, index = 31},
			[SETTING_TYPE.SKILL_EFFECT] = {fps = 25, index = 30},
			[SETTING_TYPE.FLOWER_EFFECT] = {fps = 25, index = 29},
			[SETTING_TYPE.CLOSE_TITLE] = {fps = 25, index = 28},
			[SETTING_TYPE.CLOSE_GODDESS] = {fps = 25, index = 27},
			[SETTING_TYPE.CLOSE_SHOCK_SCREEN] = {fps = 25, index = 26},
			[SETTING_TYPE.SHIELD_ENEMY] = {fps = 25, index = 25},
			[SETTING_TYPE.SHIELD_SPIRIT] = {fps = 25, index = 24},
			[SETTING_TYPE.CLOSE_WEATHWE] = {fps = 30, index = 23},
			[SETTING_TYPE.SHIELD_LINGCHONG] = {fps = 25, index = 22},
			[SETTING_TYPE.SHIELD_FLYPET] = {fps = 25, index = 21},
		}
	else
		auto_setting_fps = 28

		SYSTEM_AUTO_OPERATE =
		{
			[SETTING_TYPE.SHIELD_OTHERS] = {fps = 25, index = 32},
			[SETTING_TYPE.SHIELD_SAME_CAMP] = {fps = 30, index = 31},
			[SETTING_TYPE.SKILL_EFFECT] = {fps = 30, index = 30},
			[SETTING_TYPE.FLOWER_EFFECT] = {fps = 25, index = 29},
			[SETTING_TYPE.CLOSE_TITLE] = {fps = 25, index = 28},
			[SETTING_TYPE.CLOSE_GODDESS] = {fps = 30, index = 27},
			[SETTING_TYPE.CLOSE_SHOCK_SCREEN] = {fps = 30, index = 26},
			[SETTING_TYPE.SHIELD_ENEMY] = {fps = 25, index = 25},
			[SETTING_TYPE.SHIELD_SPIRIT] = {fps = 25, index = 24},
			[SETTING_TYPE.CLOSE_WEATHWE] = {fps = 30, index = 23},
			[SETTING_TYPE.SHIELD_LINGCHONG] = {fps = 25, index = 22},
			[SETTING_TYPE.SHIELD_FLYPET] = {fps = 25, index = 21},
		}
	end
end

SettingData = SettingData or BaseClass()
SettingData.MAX_INDEX = 33

SEND_CUSTOM_TYPE =
{
	SUGGEST = 1,
	SUBMIT_BUG = 2,
	COMPLAINT = 3,
}

SettingPanel1 =
{
	SETTING_TYPE.SHIELD_OTHERS,
	SETTING_TYPE.SHIELD_ENEMY,
	SETTING_TYPE.SELF_SKILL_EFFECT,
	SETTING_TYPE.SHIELD_SAME_CAMP,
	SETTING_TYPE.SKILL_EFFECT,
	SETTING_TYPE.FLOWER_EFFECT,
	SETTING_TYPE.CLOSE_TITLE,
	SETTING_TYPE.CLOSE_HEARSAY,
	SETTING_TYPE.CLOSE_GODDESS,
	SETTING_TYPE.SHIELD_SPIRIT,
	SETTING_TYPE.CLOSE_WEATHWE,
	SETTING_TYPE.SHIELD_LINGCHONG,
	SETTING_TYPE.SHIELD_FLYPET,
	SETTING_TYPE.AUTO_USE_HIGH_FPS,
}

SettingPanel2 =
{
	SETTING_TYPE.CLOSE_BG_MUSIC,
	SETTING_TYPE.CLOSE_SOUND_EFFECT,
	SETTING_TYPE.CLOSE_SHOCK_SCREEN,
	SETTING_TYPE.FRIEND_REQUEST,
	SETTING_TYPE.STRANGER_CHAT,
	SETTING_TYPE.AUTO_RELEASE_SKILL,
	SETTING_TYPE.AUTO_PICK_PROPERTY,
	SETTING_TYPE.AUTO_RELEASE_ANGER,
	SETTING_TYPE.AUTO_RECYCLE_EQUIP,
	SETTING_TYPE.AUTO_LUCK_SCREEN,
	SETTING_TYPE.AUTO_RELEASE_GODDESS_SKILL,
	SETTING_TYPE.AUTO_USE_FLY_SHOE,
	SETTING_TYPE.AUTO_MOJIE_SKILL,
	SETTING_TYPE.AUTO_USE_SHENMO,
}

FixBugSettting = {
	SETTING_TYPE.AUTO_RELEASE_SKILL,
	SETTING_TYPE.AUTO_RELEASE_ANGER,
	SETTING_TYPE.AUTO_PICK_PROPERTY,
	SETTING_TYPE.AUTO_LUCK_SCREEN,
	SETTING_TYPE.AUTO_RELEASE_GODDESS_SKILL,
	SETTING_TYPE.AUTO_MOJIE_SKILL,
	SETTING_TYPE.AUTO_USE_SHENMO,
}

local GameRoot = GameObject.Find("GameRoot")

function SettingData:__init()
	if SettingData.Instance then
		print_error("[SettingData] Attemp to create a singleton twice !")
	end
	SettingData.Instance = self
	self:BindFps()
	self.setting_list = {}
	self.is_first = true
	self.reward_info = ConfigManager.Instance:GetAutoConfig("updatenotice_auto").other[1]
	self.server_version = 0
	self.fetch_reward_version = 0
	self.main_ui_is_open = false
	self.system_is_setting = false
	self.system_is_setting_t = {}
	self.has_setting = {}
	self.set_data_list = {}
	self.fb_enter_flag1 = {}
	self.fb_enter_flag2 = {}
	self.fb_enter_flag3 = {}
	self.fb_enter_flag4 = {}
	self.fb_enter_flag5 = {}
	self.feixian_list = {}
	self.advance_list = {}
	self.auto_use_skill_list = {}
	self.common_equip_list = {}
	self.mainui_open_complete_handle = GlobalEventSystem:Bind(MainUIEventType.MAINUI_OPEN_COMLETE, BindTool.Bind1(self.MainuiOpenCreate, self))
	RemindManager.Instance:Register(RemindName.Setting, BindTool.Bind(self.GetSettingRemind, self))
	self.screen_bright = 0
	self.fight_toggle_state = false

	self.is_bugfixed_on_first_recv = false
	self.need_luck_view = false
	self.low_fps_count = 0
	self.bugfix_record_t = {}
	self.recommend_quality = self:CheckRecommendQuality()

	self.value_1 = 0
	self.value_2 = 0
	self.value_3 = 0

	-- 记录不再提示Toggle值
	self.commontip_key_list = {}

	self:CalcGameDefaultFps()
	InitFpsSetting()
	self.tlks_time = Status.NowTime
end

function SettingData:__delete()
	RemindManager.Instance:UnRegister(RemindName.Setting)
	GlobalEventSystem:UnBind(self.mainui_open_complete_handle)

	self.commontip_key_list = {}

	SettingData.Instance = nil
	self:UnbindFps()
end

function SettingData:CalcGameDefaultFps()
end

function SettingData:GetSettingDataListByKey(key)
	local set_data = {}
	set_data = self.set_data_list[key] or {}
	return set_data
end

function SettingData:SetSettingDataListByKey(key, item_id, _type)
	local set_data = {}
	set_data = self.set_data_list[key] or {}
	set_data.item_id = item_id or 0
	set_data.type = _type or 0
end

--只在首次打开面板时调用全球通知
function SettingData:OnSettingInfo(set_data)
	self.set_data_list = set_data
	if #set_data == 0 then
		self.set_data_list = self:SetDefaultSettingList()
		PlayerPrefsUtil.SetInt("quality_level", self.recommend_quality)
	else
		for k,v in pairs(HOT_KEY) do
			if self.set_data_list[v] == nil then
				if v == HOT_KEY.CAMERA_KEY_FLAG then
					self.set_data_list[v] = {index = v, type = 1, item_id = 1}
				else
					self.set_data_list[v] = {index = v, type = 1, item_id = 0}
				end
			end
		end
	end
	local set_data_list = self.set_data_list
	local system_setting_list = {}
	for k, v in pairs(set_data_list) do
		local item_id_list = bit:d2b(v.item_id)
		if v.index == HOT_KEY.SYS_SETTING_1 then
			for i = 1, 16 do
				if not self.system_is_setting and self:CheckSystemAuto(i) then
					self.setting_list[i] = false
					item_id_list[33 - i] = 0
				else
					self.setting_list[i] = (item_id_list[33 - i] == 1 and true or false)
				end
				self:FirstGlobleSetting(i, self.setting_list[i])
			end
			if not self.system_is_setting and set_data_list[4].item_id ~= 0 then
				local value = bit:b2d(item_id_list)
				SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.SYS_SETTING_1, value)
				SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.SYS_SETTING_AUTO_OPERATE, 0)
			end
		elseif v.index == HOT_KEY.SYS_SETTING_2 then
			for i=17, 32 do
				if not self.system_is_setting and self:CheckSystemAuto(i) then
					self.setting_list[i] = false
					item_id_list[33 - i + 16] = 0
				else
					self.setting_list[i] = (item_id_list[33 - i + 16] == 1 and true or false)
				end
				self:FirstGlobleSetting(i, self.setting_list[i])
			end
			if not self.system_is_setting and set_data_list[4].item_id ~= 0 then
				local value = bit:b2d(item_id_list)
				SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.SYS_SETTING_2, value)
				SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.SYS_SETTING_AUTO_OPERATE, 0)
			end
		elseif v.index == HOT_KEY.SYS_SETTING_3 then
			for i=33, SettingData.MAX_INDEX do
				if not self.system_is_setting and self:CheckSystemAuto(i) then
					self.setting_list[i] = false
					item_id_list[65 - i] = 0
				else
					self.setting_list[i] = (item_id_list[65 - i] == 1 and true or false)
				end
				self:FirstGlobleSetting(i, self.setting_list[i])
			end
			if not self.system_is_setting and set_data_list[4].item_id ~= 0 then
				local value = bit:b2d(item_id_list)
				SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.SYS_SETTING_3, value)
				SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.SYS_SETTING_AUTO_OPERATE, 0)
			end
		elseif v.index == HOT_KEY.SYS_SETTING_DROPDOWN_1 then
			self:SetPickLimitValue(v.item_id)
		elseif v.index == HOT_KEY.SYS_SETTING_DROPDOWN_2 then
			self:SetRecycleLimitValue(v.item_id)
		elseif v.index == HOT_KEY.CAMERA_KEY_FLAG then
			GlobalEventSystem:Fire(SettingEventType.MAIN_CAMERA_MODE_CHANGE, v.item_id)
		elseif v.index == HOT_KEY.ADVANCE_TYPE then
			GlobalEventSystem:Fire(SettingEventType.SHIELD_ADVANCE)
		elseif v.index == HOT_KEY.AUTO_USE_SKILL then
			GlobalEventSystem:Fire(SettingEventType.AUTO_USE_SKILL)
		end
	end
	self.is_first = false
	if not self.system_is_setting and set_data_list[4].item_id ~= 0 then
		SettingCtrl.Instance:SendHotkeyInfoReq()
	end

	self.fb_enter_flag1 = bit:d2b(set_data_list[HOT_KEY.FB_ENTER_FLAG1].item_id)
	self.fb_enter_flag2 = bit:d2b(set_data_list[HOT_KEY.FB_ENTER_FLAG2].item_id)
	self.fb_enter_flag3 = bit:d2b(set_data_list[HOT_KEY.FB_ENTER_FLAG3].item_id)
	self.fb_enter_flag4 = bit:d2b(set_data_list[HOT_KEY.FB_ENTER_FLAG4].item_id)
	self.fb_enter_flag5 = bit:d2b(set_data_list[HOT_KEY.FB_ENTER_FLAG5].item_id)
	self.feixian_list = bit:d2b(set_data_list[HOT_KEY.FEIXINA_EQUIP].item_id)
	self.advance_list = bit:d2b(set_data_list[HOT_KEY.ADVANCE_TYPE].item_id)
	self.auto_use_skill_list = bit:d2b(set_data_list[HOT_KEY.AUTO_USE_SKILL].item_id)

	self.common_equip_list = bit:d2b(set_data_list[HOT_KEY.Common_EQUIP].item_id)
	self.marry_guaji_index = set_data_list[HOT_KEY.MARRY_EQUIP].item_id
end

function SettingData:SetHasSetting(index)
	self.has_setting[index] = true
end

function SettingData:GetSettingList()
	return self.setting_list
end

function SettingData:OnUpdateNoticeInfo(protocol)
	self.server_version = protocol.server_version
	self.fetch_reward_version = protocol.fetch_reward_version
end

function SettingData:GetSettingData(setting_type)
	if IsLowMemSystem and setting_type == SETTING_TYPE.SKILL_EFFECT then
		return true
	end
	return self.setting_list[setting_type]
end

--首次全球通知
function SettingData:FirstGlobleSetting(setting_type, value)
	if self.is_first then
		GlobalEventSystem:Fire(self:GetGlobleType(setting_type), self:FixBugValueOnFire(setting_type, value))
	end
end

--每次改变状态时调用
function SettingData:SetSettingData(setting_type, value, is_hot_key)
	self.setting_list[setting_type] = value
	GlobalEventSystem:Fire(self:GetGlobleType(setting_type), self:FixBugValueOnFire(setting_type, value))
	if setting_type == SETTING_TYPE.AUTO_PICK_PROPERTY and self.setting_list[SETTING_TYPE.AUTO_PICK_PROPERTY] then
		GlobalEventSystem:Fire(SettingEventType.AUTO_PICK_COLOR, self.setting_list[SETTING_TYPE.AUTO_PICK_COLOR])
	elseif setting_type == SETTING_TYPE.AUTO_RECYCLE_EQUIP and self.setting_list[SETTING_TYPE.AUTO_RECYCLE_EQUIP] then
		GlobalEventSystem:Fire(SettingEventType.AUTO_RECYCLE_COLOR, self.setting_list[SETTING_TYPE.AUTO_RECYCLE_COLOR])
	end
	if is_hot_key then
		self:HotKeyToSetting()
	end
end

--快捷方式进行设置
function SettingData:HotKeyToSetting()
	local temp_list_1 = {}
	local temp_list_2 = {}
	local temp_list_3 = {}
	for i = 1, 32 do
		temp_list_1[i] = 0
		temp_list_2[i] = 0
		temp_list_3[i] = 0
	end
	for i = 1, SettingData.MAX_INDEX do
		if i <= 16 then
			temp_list_1[33 - i] = self.setting_list[i] and 1 or 0
		elseif i > 16 and i <= 32 then
			temp_list_2[33 - i + 16] = self.setting_list[i] and 1 or 0
		else
			temp_list_3[65 - i] = self.setting_list[i] and 1 or 0
		end
	end
	local value_1 = bit:b2d(temp_list_1)
	local value_2 = bit:b2d(temp_list_2)
	local value_3 = bit:b2d(temp_list_3)
	local value_4 = self.setting_list[SETTING_TYPE.AUTO_PICK_COLOR]
	local value_5 = self.setting_list[SETTING_TYPE.AUTO_RECYCLE_COLOR]
	SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.SYS_SETTING_1, value_1)
	SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.SYS_SETTING_2, value_2)
	SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.SYS_SETTING_3, value_3)
	SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.SYS_SETTING_DROPDOWN_1, value_4)
	SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.SYS_SETTING_DROPDOWN_2, value_5)
	SettingCtrl.Instance:SendHotkeyInfoReq()
end

function SettingData:SetPickLimitValue(limit_pick_color_value)
	self.setting_list[SETTING_TYPE.AUTO_PICK_COLOR] = limit_pick_color_value
	if self.setting_list[SETTING_TYPE.AUTO_PICK_PROPERTY] then
		GlobalEventSystem:Fire(SettingEventType.AUTO_PICK_COLOR, limit_pick_color_value)
	end
end

function SettingData:SetRecycleLimitValue(limit_recycle_color_value)
	self.setting_list[SETTING_TYPE.AUTO_RECYCLE_COLOR] = limit_recycle_color_value
	if self.setting_list[SETTING_TYPE.AUTO_RECYCLE_EQUIP] then
		GlobalEventSystem:Fire(SettingEventType.AUTO_RECYCLE_COLOR, limit_recycle_color_value)
	end
end

function SettingData:GetGlobleType(setting_type)
	if setting_type == SETTING_TYPE.SHIELD_OTHERS then
		return SettingEventType.SHIELD_OTHERS
	elseif setting_type == SETTING_TYPE.SELF_SKILL_EFFECT then
		return SettingEventType.SELF_SKILL_EFFECT
	elseif setting_type == SETTING_TYPE.SHIELD_SAME_CAMP then
		return SettingEventType.SHIELD_SAME_CAMP
	elseif setting_type == SETTING_TYPE.SKILL_EFFECT then
		return SettingEventType.SKILL_EFFECT
	elseif setting_type == SETTING_TYPE.CLOSE_BG_MUSIC then
		return SettingEventType.CLOSE_BG_MUSIC
	elseif setting_type == SETTING_TYPE.CLOSE_SOUND_EFFECT then
		return SettingEventType.CLOSE_SOUND_EFFECT
	elseif setting_type == SETTING_TYPE.FLOWER_EFFECT then
		return SettingEventType.FLOWER_EFFECT
	elseif setting_type == SETTING_TYPE.FRIEND_REQUEST then
		return SettingEventType.FRIEND_REQUEST
	elseif setting_type == SETTING_TYPE.STRANGER_CHAT then
		return SettingEventType.STRANGER_CHAT
	elseif setting_type == SETTING_TYPE.CLOSE_TITLE then
		return SettingEventType.CLOSE_TITLE
	elseif setting_type == SETTING_TYPE.CLOSE_HEARSAY then
		return SettingEventType.CLOSE_HEARSAY
	elseif setting_type == SETTING_TYPE.CLOSE_GODDESS then
		return SettingEventType.CLOSE_GODDESS
	elseif setting_type == SETTING_TYPE.AUTO_RELEASE_SKILL then
		return SettingEventType.AUTO_RELEASE_SKILL
	elseif setting_type == SETTING_TYPE.AUTO_RELEASE_ANGER then
		return SettingEventType.AUTO_RELEASE_ANGER
	elseif setting_type == SETTING_TYPE.CLOSE_SHOCK_SCREEN then
		return SettingEventType.CLOSE_SHOCK_SCREEN
	elseif setting_type == SETTING_TYPE.AUTO_PICK_PROPERTY then
		return SettingEventType.AUTO_PICK_PROPERTY
	elseif setting_type == SETTING_TYPE.AUTO_RECYCLE_EQUIP then
		return SettingEventType.AUTO_RECYCLE_EQUIP
	-- elseif setting_type == SETTING_TYPE.USE_NOTBLIND_EQUIP then
	-- 	return SettingEventType.USE_NOTBLIND_EQUIP
	elseif setting_type == SETTING_TYPE.SHIELD_ENEMY then
		return SettingEventType.SHIELD_ENEMY
	elseif setting_type == SETTING_TYPE.SHIELD_SPIRIT then
		return SettingEventType.SHIELD_SPIRIT
	elseif setting_type == SETTING_TYPE.AUTO_LUCK_SCREEN then
		return SettingEventType.AUTO_LUCK_SCREEN
	elseif setting_type == SETTING_TYPE.AUTO_RELEASE_GODDESS_SKILL then
		return SettingEventType.AUTO_RELEASE_GODDESS_SKILL
	elseif setting_type == SETTING_TYPE.AUTO_MOJIE_SKILL then
		return SettingEventType.AUTO_MOJIE_SKILL
	elseif setting_type == SETTING_TYPE.AUTO_USE_SHENMO then
		return SettingEventType.AUTO_USE_SHENMO
	elseif setting_type == SETTING_TYPE.AUTO_USE_HIGH_FPS then
		return SettingEventType.AUTO_USE_HIGH_FPS
	elseif setting_type == SETTING_TYPE.AUTO_USE_FLY_SHOE then
		return SettingEventType.AUTO_USE_FLY_SHOE
	elseif setting_type == HOT_KEY.CAMERA_ROTATION_X or setting_type == HOT_KEY.CAMERA_ROTATION_Y or setting_type == HOT_KEY.CAMERA_DISTANCE then
		return SettingEventType.MAIN_CAMERA_SETTING_CHANGE
	elseif setting_type == SETTING_TYPE.CLOSE_WEATHWE then
		return SettingEventType.CLOSE_WEATHWE
	elseif setting_type == SETTING_TYPE.SHIELD_LINGCHONG then
		return SettingEventType.SHIELD_LINGCHONG
	elseif setting_type == SETTING_TYPE.SHIELD_FLYPET then
		return SettingEventType.SHIELD_FLYPET
	end
	return ""
end

function SettingData:SetDefaultSettingList()
	local auto_setting = {
		SETTING_TYPE.AUTO_RELEASE_SKILL,
		SETTING_TYPE.AUTO_RELEASE_ANGER,
		SETTING_TYPE.AUTO_PICK_PROPERTY,
		SETTING_TYPE.AUTO_LUCK_SCREEN,
		SETTING_TYPE.AUTO_RELEASE_GODDESS_SKILL,
		SETTING_TYPE.AUTO_MOJIE_SKILL,
		SETTING_TYPE.AUTO_USE_SHENMO,
	}
	for k,v in pairs(auto_setting) do
		self.setting_list[v] = true
	end
	
	if self.recommend_quality == 0 then
		self.setting_list[SETTING_TYPE.AUTO_USE_HIGH_FPS] = true
	end

	-- ios审核版本默认关闭音效
	if IS_AUDIT_VERSION then
		self.setting_list[SETTING_TYPE.CLOSE_BG_MUSIC] = true
		self.setting_list[SETTING_TYPE.CLOSE_SOUND_EFFECT] = true
	end

	local temp_list_1 = {}
	local temp_list_2 = {}
	local temp_list_3 = {}
	local temp_list_4 = {}
	local temp_list_5 = {}
	local temp_list_6 = {}
	for i = 1, 32 do
		temp_list_1[i] = 0
		temp_list_2[i] = 0
		temp_list_3[i] = i == 32 and 1 or 0
		temp_list_4[i] = 0
		temp_list_5[i] = 1
		temp_list_6[i] = 0
	end
	for i = 1, SettingData.MAX_INDEX do
		if i <= 16 then
			temp_list_1[33 - i] = self.setting_list[i] and 1 or 0
		elseif i > 16 and i <= 32 then
			temp_list_2[33 - i + 16] = self.setting_list[i] and 1 or 0
		else
			temp_list_6[65 - i] = self.setting_list[i] and 1 or 0
		end
	end
	local value_1 = bit:b2d(temp_list_1)
	local value_2 = bit:b2d(temp_list_2)
	local value_3 = bit:b2d(temp_list_3)
	local value_4 = bit:b2d(temp_list_4)
	local value_5 = bit:b2d(temp_list_5)
	local value_6 = bit:b2d(temp_list_6)
	local set_data_list = {
		[HOT_KEY.SYS_SETTING_1] = {index = HOT_KEY.SYS_SETTING_1, type = 1, item_id = value_1},
		[HOT_KEY.SYS_SETTING_2] = {index = HOT_KEY.SYS_SETTING_2, type = 1, item_id = value_2},
		[HOT_KEY.SYS_SETTING_3] = {index = HOT_KEY.SYS_SETTING_3, type = 1, item_id = value_6},
		[HOT_KEY.FEIXINA_EQUIP] = {index = HOT_KEY.FEIXINA_EQUIP, type = 1, item_id = value_3},
		[HOT_KEY.Common_EQUIP] = {index = HOT_KEY.Common_EQUIP, type = 1, item_id = value_3},
		[HOT_KEY.ADVANCE_TYPE] = {index = HOT_KEY.ADVANCE_TYPE, type = 1, item_id = value_4},
		[HOT_KEY.AUTO_USE_SKILL] = {index = HOT_KEY.AUTO_USE_SKILL, type = 1, item_id = value_5},
	}
	for k,v in pairs(HOT_KEY) do
		if set_data_list[v] == nil then
			set_data_list[v] = {index = v, type = 1, item_id = 0}
		end
	end
	SettingCtrl.Instance:SendChangeHotkeyReq(set_data_list[HOT_KEY.SYS_SETTING_1].index, set_data_list[HOT_KEY.SYS_SETTING_1].item_id, set_data_list[HOT_KEY.SYS_SETTING_1].type)
	SettingCtrl.Instance:SendChangeHotkeyReq(set_data_list[HOT_KEY.SYS_SETTING_2].index, set_data_list[HOT_KEY.SYS_SETTING_2].item_id, set_data_list[HOT_KEY.SYS_SETTING_2].type)
	SettingCtrl.Instance:SendChangeHotkeyReq(set_data_list[HOT_KEY.SYS_SETTING_3].index, set_data_list[HOT_KEY.SYS_SETTING_3].item_id, set_data_list[HOT_KEY.SYS_SETTING_3].type)
	SettingCtrl.Instance:SendChangeHotkeyReq(set_data_list[HOT_KEY.FEIXINA_EQUIP].index, set_data_list[HOT_KEY.FEIXINA_EQUIP].item_id, set_data_list[HOT_KEY.FEIXINA_EQUIP].type)
	SettingCtrl.Instance:SendChangeHotkeyReq(set_data_list[HOT_KEY.ADVANCE_TYPE].index, set_data_list[HOT_KEY.ADVANCE_TYPE].item_id, set_data_list[HOT_KEY.ADVANCE_TYPE].type)
	SettingCtrl.Instance:SendChangeHotkeyReq(set_data_list[HOT_KEY.AUTO_USE_SKILL].index, set_data_list[HOT_KEY.AUTO_USE_SKILL].item_id, set_data_list[HOT_KEY.AUTO_USE_SKILL].type)
	SettingCtrl.Instance:SendChangeHotkeyReq(set_data_list[HOT_KEY.Common_EQUIP].index, set_data_list[HOT_KEY.Common_EQUIP].item_id, set_data_list[HOT_KEY.Common_EQUIP].type)
	SettingCtrl.Instance:SendChangeHotkeyReq(set_data_list[HOT_KEY.SYS_SETTING_DROPDOWN_1].index, set_data_list[HOT_KEY.SYS_SETTING_DROPDOWN_1].item_id, set_data_list[HOT_KEY.SYS_SETTING_DROPDOWN_1].type)
	SettingCtrl.Instance:SendChangeHotkeyReq(set_data_list[HOT_KEY.SYS_SETTING_AUTO_OPERATE].index, set_data_list[HOT_KEY.SYS_SETTING_AUTO_OPERATE].item_id, set_data_list[HOT_KEY.SYS_SETTING_AUTO_OPERATE].type)
	SettingCtrl.Instance:SendHotkeyInfoReq()
	return set_data_list
end

function SettingData:GetRewardInfo()
	return self.reward_info
end

--获得当前版本号
function SettingData:GetServerVersion()
	return self.server_version
end

--获得已领取的版本号
function SettingData:FetchRewardVersion()
	return self.fetch_reward_version
end

--获取领取奖励红点状态
function SettingData:GetSettingRemind()
	if GameVoManager.Instance:GetMainRoleVo().level < 130 then
		return 0
	end
	return self:GetRedPointState() and 1 or 0
end

--获取领取奖励红点状态
function SettingData:GetRedPointState()
	return self.fetch_reward_version < self.server_version
end

function SettingData:BindFps()
	if nil == self.sampler_obj then
		local async_loader = AllocAsyncLoader(self, "fps_sample_loader")
		async_loader:Load("misc_prefab", "FpsSampler", function(obj)
			if IsNil(obj) then
				return
			end

			self.sampler_obj = obj
			self.sampler_obj.transform:SetParent(GameRoot.transform)

			self.fpsHandler = BindTool.Bind1(self.FpsCallBack, self)
			local fpsSampler = self.sampler_obj:GetOrAddComponent(typeof(FPSSampler))
			fpsSampler.SamplePeriod = fps_sampler_time
			fpsSampler.ThresholdDeltaTime = 0.1
			fpsSampler.FPSEvent = fpsSampler.FPSEvent + self.fpsHandler
		end)
	end
end

function SettingData:UnbindFps()
	if self.fpsHandler ~= nil and nil ~= self.sampler_obj then
		local fpsSampler = self.sampler_obj:GetComponent(typeof(FPSSampler))
		if fpsSampler ~= nil then
			fpsSampler.FPSEvent = fpsSampler.FPSEvent - self.fpsHandler
			self.fpsHandler = nil
			self.sampler_obj.transform:SetParent(GameRoot.transform)
			ResMgr:Destroy(self.sampler_obj)
		end
	end
end

function SettingData:FpsCallBack(value)
	if not self.main_ui_is_open then
		return
	end

	if not Scene.Instance:GetSceneLogic():IsCanSystemAutoSetting() then
		return
	end

	GlobalEventSystem:Fire(OtherEventType.FPS_SAMPLE_RESULT, value)

	if value <= auto_setting_fps then
		self.low_fps_count = self.low_fps_count + 1
	else
		self:ResetAllAutoShield()
		self.low_fps_count = 0
	end

	if self.low_fps_count < lower_fps_times then
		return
	end

	-- if not RenderBudget.Instance:IsInBudget(value) then
	-- 	RenderBudget.Instance:SetBudgetByFps(value)
	-- 	return
	-- end

	-- if self.system_is_setting == true then
	-- 	return
	-- end
	if not self.system_is_setting and value <= auto_setting_fps then
		TipsCtrl.Instance:ShowSystemMsg(Language.Common.DetectionFrameLow)
	end
	self:SystemAutoSetting(value)
end

function SettingData:MainuiOpenCreate()
	self.main_ui_is_open = true
end

function SettingData:GetSystemAutoSettingTypeList(item_id)
	local the_list = bit:d2b(item_id)
	local auto_setting_type_list = {}
	if the_list[32] == 1 then auto_setting_type_list[#auto_setting_type_list + 1] = SETTING_TYPE.SHIELD_OTHERS end
	if the_list[31] == 1 then auto_setting_type_list[#auto_setting_type_list + 1] = SETTING_TYPE.SHIELD_SAME_CAMP end
	if the_list[30] == 1 then auto_setting_type_list[#auto_setting_type_list + 1] = SETTING_TYPE.SKILL_EFFECT end
	if the_list[29] == 1 then auto_setting_type_list[#auto_setting_type_list + 1] = SETTING_TYPE.FLOWER_EFFECT end
	if the_list[28] == 1 then auto_setting_type_list[#auto_setting_type_list + 1] = SETTING_TYPE.CLOSE_TITLE end
	if the_list[27] == 1 then auto_setting_type_list[#auto_setting_type_list + 1] = SETTING_TYPE.CLOSE_GODDESS end
	if the_list[26] == 1 then auto_setting_type_list[#auto_setting_type_list + 1] = SETTING_TYPE.CLOSE_SHOCK_SCREEN end
	if the_list[25] == 1 then auto_setting_type_list[#auto_setting_type_list + 1] = SETTING_TYPE.SHIELD_ENEMY end
	if the_list[24] == 1 then auto_setting_type_list[#auto_setting_type_list + 1] = SETTING_TYPE.SHIELD_SPIRIT end
	return auto_setting_type_list
end

--检测是否为系统自动选择
function SettingData:CheckSystemAuto(system_type)
	if self.set_data_list[4].item_id == 0 then
		return false
	end
	local system_setting_type_list = self:GetSystemAutoSettingTypeList(self.set_data_list[4].item_id)
	for k,v in pairs(system_setting_type_list) do
		if v == system_type then
			return true
		end
	end
	return false
end

function SettingData:ResetAutoShieldRole()
	if next(self.set_data_list) == nil then return end
	local temp_list_1 = bit:d2b(self.set_data_list[1].item_id)
	local temp_list = bit:d2b(self.set_data_list[4].item_id)
	local other_auto = SYSTEM_AUTO_OPERATE[SETTING_TYPE.SHIELD_OTHERS]
	local same_camp_auto = SYSTEM_AUTO_OPERATE[SETTING_TYPE.SHIELD_SAME_CAMP]
	if other_auto then
		temp_list[other_auto.index] = 0
		if not self.has_setting[SETTING_TYPE.SHIELD_OTHERS] then
			temp_list_1[33 - SETTING_TYPE.SHIELD_OTHERS] = 0
			self.setting_list[SETTING_TYPE.SHIELD_OTHERS] = false
			self.system_is_setting_t[SETTING_TYPE.SHIELD_OTHERS] = false
			GlobalEventSystem:Fire(self:GetGlobleType(SETTING_TYPE.SHIELD_OTHERS), self:FixBugValueOnFire(SETTING_TYPE.SHIELD_OTHERS, false))
		end
	end
	if same_camp_auto then
		temp_list[same_camp_auto.index] = 0
		if not self.has_setting[SETTING_TYPE.SHIELD_SAME_CAMP] then
			temp_list_1[33 - SETTING_TYPE.SHIELD_SAME_CAMP] = 0
			self.setting_list[SETTING_TYPE.SHIELD_SAME_CAMP] = false
			self.system_is_setting_t[SETTING_TYPE.SHIELD_SAME_CAMP] = false
			GlobalEventSystem:Fire(self:GetGlobleType(SETTING_TYPE.SHIELD_SAME_CAMP), self:FixBugValueOnFire(SETTING_TYPE.SHIELD_SAME_CAMP, false))
		end
	end
	local value_1 = bit:b2d(temp_list_1)
	local value_2 = bit:b2d(temp_list)
	SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.SYS_SETTING_1, value_1)
	SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.SYS_SETTING_AUTO_OPERATE, value_2)
	SettingCtrl.Instance:SendHotkeyInfoReq()
end

function SettingData:ResetAllAutoShield()
	if nil == self.set_data_list[1] then
		return
	end

	local temp_list_1 = bit:d2b(self.set_data_list[1].item_id)
	local temp_list_2 = bit:d2b(self.set_data_list[2].item_id)
	local temp_list_3 = bit:d2b(self.set_data_list[0].item_id)
	local temp_list = bit:d2b(self.set_data_list[4].item_id)

	for k,v in pairs(SYSTEM_AUTO_OPERATE) do
		if temp_list[v.index] == 1 then
			temp_list[v.index] = 0
			if not self.has_setting[k] then
				if k > 16 and k <= 32 then
					temp_list_2[33 - k + 16] = 0
				elseif k <= 16 then
					temp_list_1[33 - k] = 0
				else
					temp_list_3[65 - k] =0
				end
				self.setting_list[k] = false
				self.system_is_setting_t[k] = false
				GlobalEventSystem:Fire(self:GetGlobleType(k), self:FixBugValueOnFire(k, false))
			end
		end
	end

	local value_1 = bit:b2d(temp_list_1)
	local value_2 = bit:b2d(temp_list_2)
	local value_3 = bit:b2d(temp_list_3)
	local value_4 = bit:b2d(temp_list)
	if value_1 ~= self.value_1 or value_2 ~= self.value_2 or value_3 ~= self.value_3 and value_4 ~= self.value_4 then
		self.value_1 = value_1
		self.value_2 = value_2
		self.value_3 = value_3
		self.value_4 = value_3
		SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.SYS_SETTING_1, self.value_1)
		SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.SYS_SETTING_2, self.value_2)
		SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.SYS_SETTING_3, self.value_3)
		SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.SYS_SETTING_AUTO_OPERATE, self.value_4)
		SettingCtrl.Instance:SendHotkeyInfoReq()
	end
end

function SettingData:SystemAutoSetting(value)
	if #self.set_data_list <= 0 then
		return
	end

	if value <= auto_setting_fps then
		self.system_is_setting = true
	end
	local temp_list_1 = bit:d2b(self.set_data_list[1].item_id)
	local temp_list_2 = bit:d2b(self.set_data_list[2].item_id)
	local temp_list_3 = bit:d2b(self.set_data_list[0].item_id)
	local system_change_list = {}
	for i = 1, 32 do
		system_change_list[i] = 0
	end
	local temp_list = bit:d2b(self.set_data_list[4].item_id)

	for k,v in pairs(SYSTEM_AUTO_OPERATE) do
		if not self.has_setting[k] then
			if self.setting_list[k] == false and not self.system_is_setting_t[k] and value < v.fps then
				system_change_list[v.index] = 1
				self.system_is_setting_t[k] = true
			end
			if self.setting_list[k] and self.system_is_setting_t[k] and value < v.fps then
				system_change_list[v.index] = 1
			end
		end
	end

	for i = 1, 16 do
		for k,v in pairs(SYSTEM_AUTO_OPERATE) do
			if i == k then
				if system_change_list[v.index] == 1 and self.setting_list[k] == false then
					temp_list_1[33 - i] = 1
					self.setting_list[i] = true
					GlobalEventSystem:Fire(self:GetGlobleType(i), self:FixBugValueOnFire(i, true))
				elseif system_change_list[v.index] == 0 and temp_list[v.index] == 1 and self.setting_list[k] then
					self.system_is_setting_t[k] = false
					temp_list_1[33 - i] = 0
					self.setting_list[i] = false
					GlobalEventSystem:Fire(self:GetGlobleType(i), self:FixBugValueOnFire(i, false))
				end
				break
			end
		end
	end
	for i=17, 32 do
		for k,v in pairs(SYSTEM_AUTO_OPERATE) do
			if i == k then
				if system_change_list[v.index] == 1 and self.setting_list[k] == false then
					temp_list_2[33 - i + 16] = 1
					self.setting_list[i] = true
					GlobalEventSystem:Fire(self:GetGlobleType(i), self:FixBugValueOnFire(i, true))
				elseif system_change_list[v.index] == 0 and temp_list[v.index] == 1 and self.setting_list[k] then
					self.system_is_setting_t[k] = false
					temp_list_2[33 - i + 16] = 0
					self.setting_list[i] = false
					GlobalEventSystem:Fire(self:GetGlobleType(i), self:FixBugValueOnFire(i, false))
				end
				break
			end
		end
	end

	for i=33, SettingData.MAX_INDEX do
		for k,v in pairs(SYSTEM_AUTO_OPERATE) do
			if i == k then
				if system_change_list[v.index] == 1 and self.setting_list[k] == false then
					temp_list_3[65 - i] = 1
					self.setting_list[i] = true
					GlobalEventSystem:Fire(self:GetGlobleType(i), self:FixBugValueOnFire(i, true))
				elseif system_change_list[v.index] == 0 and temp_list[v.index] == 1 and self.setting_list[k] then
					self.system_is_setting_t[k] = false
					temp_list_3[65 - i] = 0
					self.setting_list[i] = false
					GlobalEventSystem:Fire(self:GetGlobleType(i), self:FixBugValueOnFire(i, false))
				end
				break
			end
		end
	end

	local value_1 = bit:b2d(temp_list_1)
	local value_2 = bit:b2d(temp_list_2)
	local value_3 = bit:b2d(temp_list_3)
	local value_4 = bit:b2d(system_change_list)
	if value_1 ~= self.value_1 or value_2 ~= self.value_2 or value_3 ~= self.value_3 and value_4 ~= self.value_4 then
		self.value_1 = value_1
		self.value_2 = value_2
		self.value_3 = value_3
		self.value_4 = value_4
		SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.SYS_SETTING_1, self.value_1)
		SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.SYS_SETTING_2, self.value_2)
		SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.SYS_SETTING_3, self.value_3)
		SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.SYS_SETTING_AUTO_OPERATE, self.value_4)
		SettingCtrl.Instance:SendHotkeyInfoReq()
	end
end

function SettingData:AfterSystemAutoSetting(setting_type)
	if not self.system_is_setting then
		return
	end
	local temp_list = bit:d2b(self.set_data_list[4].item_id)
	if self:CheckSystemAuto(setting_type) then
		for k,v in pairs(SYSTEM_AUTO_OPERATE) do
			if k == setting_type then
				temp_list[v.index] = 0
			end
		end
		local value = bit:b2d(temp_list)
		SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.SYS_SETTING_AUTO_OPERATE, value)
	end
end

--返回品质
function SettingData:GetQualityName(quality_value)
	local name_list = Language.Setting.QualityName
	return name_list[quality_value] or ""
end

function SettingData:GetIssueTypeName(issue_type)
	local name = ""
	if issue_type == SEND_CUSTOM_TYPE.SUGGEST then
		name = Language.Common.Setting.SettingSendType[1]
	elseif issue_type == SEND_CUSTOM_TYPE.SUBMIT_BUG then
		name = Language.Common.Setting.SettingSendType[2]
	elseif issue_type == SEND_CUSTOM_TYPE.COMPLAINT then
		name = Language.Common.Setting.SettingSendType[3]
	end
	return name
end

function SettingData:SetFbEnterFlag(scene_type, value, scene_id)
	if scene_type == 0 then
		if BossData.Instance:IsWorldBossScene(scene_id) then
			self.fb_enter_flag5[32] = value and 1 or 0
		elseif BossData.Instance:IsDabaoBossScene(scene_id) then
			self.fb_enter_flag5[31] = value and 1 or 0
		elseif BossData.Instance:IsFamilyBossScene(scene_id) then
			self.fb_enter_flag5[30] = value and 1 or 0
		elseif BossData.Instance:IsMikuBossScene(scene_id) then
			self.fb_enter_flag5[29] = value and 1 or 0
		elseif BossData.Instance:IsCrossBossScene(scene_id) then
			self.fb_enter_flag5[28] = value and 1 or 0
		elseif BossData.Instance:IsActiveBossScene(scene_id) then
			self.fb_enter_flag5[27] = value and 1 or 0
		elseif AncientRelicsData.IsAncientRelics(scene_id) then
			self.fb_enter_flag5[26] = value and 1 or 0
		elseif BossData.Instance:IsSecretBossScene(scene_id) then
			self.fb_enter_flag5[25] = value and 1 or 0
		end
	elseif scene_type < 17 then
		self.fb_enter_flag1[scene_type + 16] = value and 1 or 0
	elseif scene_type < 33 then
		self.fb_enter_flag2[scene_type] = value and 1 or 0
	elseif scene_type < 49 then
		self.fb_enter_flag3[scene_type - 16] = value and 1 or 0
	elseif scene_type < 65 then
		self.fb_enter_flag4[scene_type - 32] = value and 1 or 0
	end
	local value = bit:b2d(self.fb_enter_flag1)
	SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.FB_ENTER_FLAG1, value)
	value = bit:b2d(self.fb_enter_flag2)
	SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.FB_ENTER_FLAG2, value)
	value = bit:b2d(self.fb_enter_flag3)
	SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.FB_ENTER_FLAG3, value)
	value = bit:b2d(self.fb_enter_flag4)
	SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.FB_ENTER_FLAG4, value)
	value = bit:b2d(self.fb_enter_flag5)
	SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.FB_ENTER_FLAG5, value)
end

function SettingData:HasEnterFb(scene_type, scene_id)
	if next(self.fb_enter_flag1) == nil  then return true end
	if scene_type == 0 then
		if BossData.Instance:IsWorldBossScene(scene_id) then
			return self.fb_enter_flag5[32] == 1
		elseif BossData.Instance:IsDabaoBossScene(scene_id) then
			return self.fb_enter_flag5[31] == 1
		elseif BossData.Instance:IsFamilyBossScene(scene_id) then
			return self.fb_enter_flag5[30] == 1
		elseif BossData.Instance:IsMikuBossScene(scene_id) then
			return self.fb_enter_flag5[29] == 1
		elseif BossData.Instance:IsCrossBossScene(scene_id) then
			return self.fb_enter_flag5[28] == 1
		elseif BossData.Instance:IsActiveBossScene(scene_id) then
			return self.fb_enter_flag5[27] == 1
		elseif AncientRelicsData.IsAncientRelics(scene_id) then
			return self.fb_enter_flag5[26] == 1
		elseif BossData.Instance:IsSecretBossScene(scene_id) then
			return self.fb_enter_flag5[25] == 1
		end
	elseif scene_type < 17 then
		return self.fb_enter_flag1[scene_type + 16] == 1
	elseif scene_type < 33 then
		return self.fb_enter_flag2[scene_type] == 1
	elseif scene_type < 49 then
		return self.fb_enter_flag3[scene_type - 16] == 1
	elseif scene_type < 65 then
		return self.fb_enter_flag4[scene_type - 32] == 1
	end
	return true
end

function SettingData:SetMarryEquipIndex(marry_guaji_index)
	self.marry_guaji_index = marry_guaji_index
	SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.MARRY_EQUIP, marry_guaji_index)
end

function SettingData:GetMarryEquipIndex()
	return self.marry_guaji_index
end

function SettingData:SetScreenBright(value)
	self.screen_bright = value
end

function SettingData:GetScreenBright()
	return self.screen_bright
end

function SettingData:SetFightToggleState(value)
	self.fight_toggle_state = value
end

function SettingData:GetFightToggleState()
	return self.fight_toggle_state
end

function SettingData:SetBugFixRecordValue(setting_type, setting_value)
	if true == setting_value then setting_value = 1 end
	if false == setting_value then setting_value = 0 end

	self.bugfix_record_t[setting_type] = setting_value
end

function SettingData:GetBugFixRecordValue(setting_type)
	if nil ~= self.bugfix_record_t[setting_type] then
		return self.bugfix_record_t[setting_type]
	end

	return 1
end

function SettingData:FixBugValueOnFire(setting_type, value)
	if nil ~= self.bugfix_record_t[setting_type] then
		return 1 == self:GetBugFixRecordValue(setting_type)
	end

	return value
end

function SettingData:FixBugOnSend(index, value)
	if index == HOT_KEY.SYS_SETTING_1 then
		local list = bit:d2b(value)
		for i = 1, 16 do
			if nil ~= self.bugfix_record_t[i] then
				list[33 - i] = self:GetBugFixRecordValue(i)
			end
		end
		value = bit:b2d(list)
	end

	if index == HOT_KEY.SYS_SETTING_2 then
		local list = bit:d2b(value)
		for i=17, 32 do
			if nil ~= self.bugfix_record_t[i] then
				list[33 - i + 16] = self:GetBugFixRecordValue(i)
			end
		end
		value = bit:b2d(list)
	end

	if index == HOT_KEY.SYS_SETTING_3 then
		local list = bit:d2b(value)
		for i=33, SettingData.MAX_INDEX do
			if nil ~= self.bugfix_record_t[i] then
				list[65 - i] = self:GetBugFixRecordValue(i)
			end
		end
		value = bit:b2d(list)
	end

	return index, value
end

function SettingData:IsFixSettingBugType(setting_type)
	for _, v2 in pairs(FixBugSettting) do
		if v2 == setting_type then
			return true
		end
	end

	return false
end

function SettingData:FixBugOnFirstRecv(set_data_list)
	if self.is_bugfixed_on_first_recv then
		return
	end

	self.is_bugfixed_on_first_recv = true

	 -- 新玩家
	if #set_data_list == 0 then
		self:SetBugFixRecordValue(SETTING_TYPE.AUTO_RELEASE_SKILL, 1) --1是默认勾上
		self:SetBugFixRecordValue(SETTING_TYPE.AUTO_RELEASE_ANGER, 1)
		self:SetBugFixRecordValue(SETTING_TYPE.AUTO_PICK_PROPERTY, 1)
		self:SetBugFixRecordValue(SETTING_TYPE.AUTO_LUCK_SCREEN, 1)
		self:SetBugFixRecordValue(SETTING_TYPE.AUTO_RELEASE_GODDESS_SKILL, 1)
		self:SetBugFixRecordValue(SETTING_TYPE.AUTO_MOJIE_SKILL, 1)
		self:SetBugFixRecordValue(SETTING_TYPE.AUTO_USE_SHENMO, 1)
		return
	end

	-- 旧玩家
	for _, v in pairs(set_data_list) do
		if v.index == HOT_KEY.SYS_SETTING_1 then
			local item_id_list = bit:d2b(v.item_id)
			for i = 1, 16 do
				if self:IsFixSettingBugType(i) then
					self:SetBugFixRecordValue(i, item_id_list[33 - i])
				end
			end
		elseif v.index == HOT_KEY.SYS_SETTING_2 then
			local item_id_list = bit:d2b(v.item_id)
			for i=17, 32 do
				if self:IsFixSettingBugType(i) then
					self:SetBugFixRecordValue(i, item_id_list[33 - i + 16])
				end
			end
		elseif v.index == HOT_KEY.SYS_SETTING_3 then
			local item_id_list = bit:d2b(v.item_id)
			for i=33, SettingData.MAX_INDEX do
				if self:IsFixSettingBugType(i) then
					self:SetBugFixRecordValue(i, item_id_list[65 - i])
				end
			end
		end
	end
end

function SettingData:SetNeedLuckView(value)
	self.need_luck_view = value
end

function SettingData:GetNeedLuckView()
	return self.need_luck_view
end

function SettingData:GetRecommendQuality()
	return self.recommend_quality
end

function SettingData:CheckRecommendQuality()
	local sysInfo = UnityEngine.SystemInfo
	-- 特殊型号, 直接low品质
	for _, device_name in ipairs(LOW_QUALITY_DEVICE) do
		if device_name == sysInfo.deviceName then
			return 3
		end
	end

	for _, graphics_id in ipairs(LOW_QUALITY_GRAPHICS) do
		if graphics_id == sysInfo.graphicsDeviceID then
			return 3
		end
	end

	-- 不支持特定功能，直接low品质
	if not sysInfo.supportsImageEffects or
		not sysInfo.supportsRenderToCubemap or
		not sysInfo.supportsShadows or
		not sysInfo.graphicsMultiThreaded then
		return 3
	end

	-- 模拟器直接最高配
	if rawget(getmetatable(DeviceTool), "IsEmulator") and DeviceTool.IsEmulator() then
		return 0
	end

	if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then
		-- 5=1000, 5s=1300, 6=1400, 6s=1800, 7=2330
		local frequency = UnityEngine.SystemInfo.processorFrequency
		if frequency <= 1500 then -- 超低配
			return 3
		else
			return 0
		end
	else
		-- 高配
		if sysInfo.supportedRenderTargetCount >= 4 and
			sysInfo.systemMemorySize >= 3072 and
			sysInfo.graphicsMemorySize >= 500 and
			sysInfo.processorCount >= 4 and
			sysInfo.processorFrequency > 2200 then
			return 0
		end

		-- 中配
		if sysInfo.supportedRenderTargetCount >= 2 and
			sysInfo.systemMemorySize >= 2000 and
			sysInfo.graphicsMemorySize >= 400 and
			sysInfo.processorCount >= 2 and
			sysInfo.processorFrequency > 2000 then
			return 1
		end

		-- 低配
		if sysInfo.supportedRenderTargetCount >= 2 and
			sysInfo.systemMemorySize >= 1500 and
			sysInfo.graphicsMemorySize >= 256 and
			sysInfo.processorCount >= 2 and
			sysInfo.processorFrequency > 1500 then
			return 2
		end

		-- 超低配
		return 3
	end
end

function SettingData:SetCommonTipkey(key, value)
	self.commontip_key_list[key] = value
end

function SettingData:GetCommonTipkey(key)
	if nil == key or "" == key then
		return false
	end

	return self.commontip_key_list[key]
end

----------------
-- 普通装备
function SettingData:SetCommonRecycleFlag(index, flag)
	index = index - 1
	self.common_equip_list[32 - index] = flag
	value = bit:b2d(self.common_equip_list)
	SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.Common_EQUIP, value)
end

function SettingData:GetCommonRecycleFlag(index)
	index = index - 1
	local value = self.common_equip_list[32 - index]
	return value or 0
end

function SettingData:GetCommonRecycleTable()
	return self.common_equip_list or nil
end
----------------
-- 转职装备
function SettingData:SetRecycleFlag(index, flag)
	index = index - 1
	self.feixian_list[32 - index] = flag
	local value = bit:b2d(self.feixian_list)
	SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.FEIXINA_EQUIP, value)
end

function SettingData:GetRecycleFlag(index)
	index = index - 1
	local value = self.feixian_list[32 - index]
	return value or 0
end

function SettingData:GetRecycleTable()
	return self.feixian_list or nil
end

function SettingData:SetAdvanceTypeHideFlag(index, flag)
	index = index - 1
	self.advance_list[32 - index] = flag
	local value = bit:b2d(self.advance_list)
	SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.ADVANCE_TYPE, value)
end

function SettingData:GetAdvanceTypeHideFlag(index)
	index = index - 1
	local value = self.advance_list[32 - index]
	return value or 0
end

---------------
--自动释放技能
function SettingData:SetAutoUseSkillFlag(index, flag)
	index = index - 1
	self.auto_use_skill_list[32 - index] = flag
	local value = bit:b2d(self.auto_use_skill_list)
	SettingCtrl.Instance:SendChangeHotkeyReq(HOT_KEY.AUTO_USE_SKILL, value)
end

function SettingData:GetAutoUseSkillFlag(index)
	index = index - 1
	local value = self.auto_use_skill_list[32 - index]
	return value or 0
end
----------END


function SettingData:IsShieldOtherRole(scene_id)
	-- if CgManager.Instance:IsCgIng() or (LevelShieldOtherSceneId[scene_id] and GameVoManager.Instance:GetMainRoleVo().level < GameEnum.SHIELD_OTHER_LEVEL) then
	-- 	return true
	-- end

	if CgManager.Instance:IsCgIng() then
		return true
	end
	return false
end

function SettingData:SetTlksClickTime()
	self.tlks_time = Status.NowTime + 60
end

function SettingData:GetTlksClickTime()
	return self.tlks_time
end

function SettingData:SetNoticData(data)
	self.notic_data = data
end

function SettingData:GetNoticData()
	return self.notic_data or {}
end