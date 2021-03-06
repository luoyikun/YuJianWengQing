FishingView = FishingView or BaseClass(BaseRender)

local WatchFishPosList = {
	[1] = {x = 397, y = -245},
	[2] = {x = 515, y = -194},
}

function FishingView:__init()
	self.enter_time = 0
	self.create_cd = 0.5
	self.is_play_reward_effect = false

	self.normal_fish_list = {}
	self.protect_fish_list = {}
	self.watch_fish_list = {}
	self.bullet_list = {}

	self.uicamera = GameObject.Find("GameRoot/UICamera"):GetComponent(typeof(UnityEngine.Camera))

	self.paotai_animator = self.node_list["Pillar"].animator
	self.enter_animator = self.root_node.animator

	self.bullet_delete_call_back = BindTool.Bind(self.BulletDeleteCallBack, self)
	self.touch_call_back = BindTool.Bind(self.TouchCallBack, self)

	self.node_list["ClickRange"].event_trigger_listener:AddPointerDownListener(BindTool.Bind(self.FireBullet, self))
	self.node_list["BtnRecord"].button:AddClickListener(BindTool.Bind(self.ClickFishRecord, self))
	self.node_list["BtnFriendFish"].button:AddClickListener(BindTool.Bind(self.OpenFishPondList, self))
	self.node_list["BtnAdd"].button:AddClickListener(BindTool.Bind(self.ClickAddBullet, self))
	self.node_list["BtnFarmFish"].button:AddClickListener(BindTool.Bind(self.ClickFarmFish, self))
	self.node_list["BtnAdd2"].button:AddClickListener(BindTool.Bind(self.ClickAddFishTimes, self))
	self.node_list["BtnTips"].button:AddClickListener(BindTool.Bind(self.OpenTips, self))
	self.node_list["BtnQuick"].button:AddClickListener(BindTool.Bind(self.OnClickQuick, self))

	self.remind_change = BindTool.Bind(self.RemindChangeCallBack, self)

	self.red_point_list = {
		[RemindName.Fishing_CanGet] = self.node_list["ImgRedPoint"],
		[RemindName.Fishing_BeSteal] = self.node_list["ImgRemind"],
		[RemindName.Fishing_CanSteal] = self.node_list["ImgRedPoint2"],
	}

	for k in pairs(self.red_point_list) do
		RemindManager.Instance:Bind(self.remind_change, k)
	end
end

function FishingView:__delete()
	self:ClearFish()
	self:ClearCountDown()
	self:RemoveDelayTime()

	if RemindManager.Instance then
		RemindManager.Instance:UnBind(self.remind_change)
	end
end

function FishingView:ClearFish()
	for _, v in ipairs(self.normal_fish_list) do
		v:DeleteMe()
	end
	self.normal_fish_list = {}

	for _, v in ipairs(self.protect_fish_list) do
		v:DeleteMe()
	end
	self.protect_fish_list = {}

	for _, v in ipairs(self.watch_fish_list) do
		v:DeleteMe()
	end
	self.watch_fish_list = {}
end

function FishingView:InitView()
	self.is_self = true
	FishingData.Instance:SetNowFishPondUid(GameVoManager.Instance:GetMainRoleVo().role_id)
	FishingData.Instance:SetNowFishList(FishingData.Instance:GetMyFishList())
	self:StartCreateFish()
	self:FlushTitleDes()
	self:FlushCommon()
	self:FlushInfo()
end

function FishingView:RemindChangeCallBack(remind_name, num)
	if nil ~= self.red_point_list[remind_name] then
		local is_active = num > 0
		if RemindName.Fishing_CanGet == remind_name then
			is_active = is_active and self.is_self
		end
		self.red_point_list[remind_name]:SetActive(is_active)
	end
end

--?????????????????????
function FishingView:CloseCallBack()
	for k, v in pairs(self.bullet_list) do
		v:DeleteMe()
	end
	self.bullet_list = {}
	self:ClearFish()
	self:ClearCountDown()
	self:RemoveDelayTime()
	if self.is_play_reward_effect then
		self:ShowRewardView()
	end
end

--??????????????????
function FishingView:FlushInfo()
	self:FlushBulletNum()
	self:FlushFarmFishTimes()

	local  level  = PlayerData.Instance:GetRoleVo().level
	local min_level = FishingData.Instance:GetSkipCfgByType(0).limit_level
	
	local farm_fish_times = FishingData.Instance:GetFarmFishTimes()
	local bullet_num = FishingData.Instance:GetLeftBulletNum()

	self.node_list["BtnQuick"]:SetActive(level >= min_level and (farm_fish_times > 0 or bullet_num > 0))
end

--??????????????????
function FishingView:FlushFish()
	local fish_list = FishingData.Instance:GetMyFishList()
	if nil == fish_list then
		return
	end
	if #self.normal_fish_list <= 0 then
		--???????????????
		local fish_info = FishingData.Instance:GetFishInfoByQuality(fish_list.fish_quality)
		if nil == fish_info then
			return
		end
		for i = 1, fish_list.fish_num do
			local fish = Fish.New(fish_info, false)

			fish:SetParent(self.node_list["FishRangeContent"])
			table.insert(self.normal_fish_list, fish)
		end
	end

	if not self.is_play_reward_effect then
		self:CheckDeleteNormalFish()
	end
	FishingData.Instance:SetNowFishPondUid(GameVoManager.Instance:GetMainRoleVo().role_id)
	FishingData.Instance:SetNowFishList(FishingData.Instance:GetMyFishList())
	self:FlushTitleDes()
end

--??????????????????
function FishingView:CheckDeleteNormalFish()
	local fish_list = FishingData.Instance:GetMyFishList()
	if nil == fish_list then
		return
	end
	local now_count = #self.normal_fish_list
	local diff_count = now_count - fish_list.fish_num
	if diff_count > 0 then
		--?????????????????????
		for i = now_count, fish_list.fish_num + 1, -1 do
			self.normal_fish_list[i]:DeleteMe()
			table.remove(self.normal_fish_list, i)
		end
	end
end

--??????????????????
function FishingView:FlushBulletNum()
	local bullet_num = FishingData.Instance:GetLeftBulletNum()
	self.node_list["TxtBulletCount"].text.text = bullet_num
end

--??????????????????
function FishingView:FlushFarmFishTimes()
	local farm_fish_times = FishingData.Instance:GetFarmFishTimes()
	self.node_list["TxtLeftTimeDes"].text.text = string.format(Language.Fishpond.TimesCount, farm_fish_times)
end

--??????????????????
function FishingView:FlushTitleDes()
	self:ClearCountDown()
	--??????????????????????????????
	local uid = FishingData.Instance:GetNowFishPondUid()
	local main_vo = GameVoManager.Instance:GetMainRoleVo()
	local fish_list = FishingData.Instance:GetNowFishList()
	if nil == fish_list then
		return
	end
	local title_desc = ""
	if main_vo.role_id == uid then
		--??????????????????
		local normal_des = string.format(Language.Fishpond.FishPondTitleDes, main_vo.name)
		local fang_fish_time = fish_list.fang_fish_time
		if fang_fish_time <= 0 then
			--????????????
			title_desc = normal_des
			self.can_harvest = false
			self.node_list["TxtTitle"].text.text = title_desc
			self:FlushCommon()
			return
		end
		local server_times = TimeCtrl.Instance:GetServerTime()
		local fish_info = FishingData.Instance:GetFishInfoByQuality(fish_list.fish_quality)
		if nil == fish_info then
			title_desc = normal_des
			self.node_list["TxtTitle"].text.text = title_desc
			return
		end
		local need_times = fish_info.need_time
		local left_time = need_times - (server_times - fang_fish_time)
		if left_time <= 0 then
			--????????????
			title_desc = normal_des
			self.can_harvest = true
		else
			local function time_func(elapse_time, total_time)
				if elapse_time >= total_time then
					self:ClearCountDown()
					--????????????
					title_desc = normal_des
					self.can_harvest = true
					self.node_list["TxtTitle"].text.text = title_desc
					return
				end
				local times = math.floor(total_time - elapse_time)
				local time_str = TimeUtil.FormatSecond(times)
				local des = string.format(Language.Fishpond.GetFishTimeDes, time_str)
				self.node_list["TxtTitle"].text.text = des
			end
			self.count_down = CountDown.Instance:AddCountDown(left_time, 1, time_func)
			local time_str = TimeUtil.FormatSecond(left_time)
			local des = string.format(Language.Fishpond.GetFishTimeDes, time_str)
			title_desc = des
			self.can_harvest = false
		end
		self:FlushCommon()
	else
		title_desc = string.format(Language.Fishpond.FishPondTitleDes, fish_list.owner_name)
	end

	self.node_list["TxtTitle"].text.text = title_desc
end

function FishingView:FishNumChange(is_succ)
	self:CheckDeleteFish(is_succ)
end

--??????????????????
function FishingView:RefreshView(is_enter_other)
	if is_enter_other then
		if self.is_play_reward_effect then
			self:RemoveDelayTime()
			self:ShowRewardView()
		end
		local fish_list = FishingData.Instance:GetNowFishList()
		if nil ~= fish_list then
			self.node_list["TxtEnterTips"].text.text = string.format(Language.Fishpond.EnterPond, fish_list.owner_name)
			if self.enter_animator then
				self.enter_animator:SetTrigger("enter")
			end
		end
	end
	self.is_self = false
	self:StartCreateFish()
	self:FlushTitleDes()
	self:FlushCommon()
end

function FishingView:FlushCommon()
	if self.is_self then
		if self.can_harvest then
			self.node_list["Btn_txt"].text.text = Language.Fishpond.Harvest
		else
			self.node_list["Btn_txt"].text.text = Language.Fishpond.YangYu
		end
	else
		self.node_list["Btn_txt"].text.text = Language.Fishpond.FanHuiYuTang
	end
	-- self.node_list["ImgRedPoint"]:SetActive(self.is_self)
	-- self.node_list["EffectHarvest"]:SetActive(self.can_harvest and self.is_self) --??????????????????????????????
	self.node_list["ImgLeftTimeDesBG"]:SetActive(self.is_self)
	self.node_list["TxtLeftTimeDes"]:SetActive(self.is_self)
end

function FishingView:ClearCountDown()
	if self.count_down then
		CountDown.Instance:RemoveCountDown(self.count_down)
		self.count_down = nil
	end
end

function FishingView:StartCreateFish()
	if Status.NowTime - self.enter_time < self.create_cd then
		return
	end
	self.enter_time = Status.NowTime

	--?????????????????????
	self:ClearFish()
	FishingData.Instance:ClearWaitDeleteList()

	--????????????
	for i = 1, 2 do
		for j = 1, 2 do
			local data = {quality = i + 4}
			local fish = Fish.New(data, false)
			fish:SetParent(self.node_list["FishRangeContent"])
			table.insert(self.watch_fish_list, fish)
		end
	end

	for i = 1, 2 do
		local data = {quality = 7}
		local fish = Fish.New(data, false)
		fish:SetParent(self.node_list["FishRangeContent"])
		fish:SetPosition(WatchFishPosList[i])
		fish:SetDelfaultSpeed(0)
		table.insert(self.watch_fish_list, fish)
	end

	local fish_list = FishingData.Instance:GetNowFishList()
	if nil == fish_list then
		return
	end

	local fish_info = FishingData.Instance:GetFishInfoByQuality(fish_list.fish_quality)
	if nil == fish_info then
		return
	end
	--????????????
	for i = 1, fish_list.fish_num do
		local fish = Fish.New(fish_info, false)

		fish:SetParent(self.node_list["FishRangeContent"])
		table.insert(self.normal_fish_list, fish)
	end

	--????????????
	local protectfish_num = FishingData.Instance:GetProtectFishNum()
	for i = 1, protectfish_num do
		local fish = Fish.New(fish_info, true)

		fish:SetParent(self.node_list["FishRangeContent"])
		table.insert(self.protect_fish_list, fish)
	end
end

function FishingView:FireBullet()
	--???????????????????????????????????????
	local fish_list = FishingData.Instance:GetNowFishList()
	if nil == fish_list then
		print_error("fish_list is nil!!!!!!!!!!!!!!!!")
		return
	end

	local rect = self.node_list["ClickRange"].rect
	local _, local_pos_tbl = UnityEngine.RectTransformUtility.ScreenPointToLocalPointInRectangle(rect, UnityEngine.Input.mousePosition, self.uicamera, Vector2(0, 0))
	local abs_x = math.abs(local_pos_tbl.x)
	local abs_y = math.abs(local_pos_tbl.y)
	local angle = math.deg(math.atan2(abs_x, abs_y))
	if local_pos_tbl.x > 0 then
		angle = -angle
	end
	local rotation = Quaternion.Euler(0, 0, angle)
	self.node_list["Pillar"].rect.localRotation = rotation

	--??????????????????????????????
	if fish_list.owner_uid == GameVoManager.Instance:GetMainRoleVo().role_id then
		SysMsgCtrl.Instance:ErrorRemind(Language.Fishpond.NotGetSelfFish)
		return
	end

	local fish_quality = fish_list.fish_quality
	local fish_info = FishingData.Instance:GetFishInfoByQuality(fish_quality)
	if nil == fish_info then
		print_error("fish_info is nil!!!!!!!!!!!!!!!!")
		return
	end
	if #self.normal_fish_list <= fish_info.steal_limit then
		SysMsgCtrl.Instance:ErrorRemind(Language.Fishpond.NotEnoughFishDes)
		return
	end

	--???????????????????????????
	local bullet_num = FishingData.Instance:GetLeftBulletNum()
	if bullet_num <= 0 then
		SysMsgCtrl.Instance:ErrorRemind(Language.Fishpond.NotBulletNum)
		return
	end

	--????????????????????????
	if self.paotai_animator then
		self.paotai_animator:SetTrigger("scale")
	end

	--?????????????????????????????????
	local screen_pos_tbl = UnityEngine.RectTransformUtility.WorldToScreenPoint(self.uicamera, self.node_list["BulletStartPos"].rect.position)

	--?????????????????????????????????
	rect = self.node_list["BulletRange"].rect
	local _, local_bullet_start_pos_tbl = UnityEngine.RectTransformUtility.ScreenPointToLocalPointInRectangle(rect, screen_pos_tbl, self.uicamera, Vector2(0, 0))

	--??????????????????
	local bullet = Bullet.New()
	bullet:SetParent(self.node_list["BulletRange"].transform)
	bullet:SetRange(self.node_list["BulletRange"].rect.sizeDelta.x/2, self.node_list["BulletRange"].rect.sizeDelta.y)
	bullet:SetStartPosTbl(local_bullet_start_pos_tbl)
	bullet:SetLocalRotation(rotation)
	bullet:SetDeleteCallBack(self.bullet_delete_call_back)
	bullet:SetTouchCallBack(self.touch_call_back)
	for _, v in ipairs(self.protect_fish_list) do
		local bind_func = BindTool.Bind(v.BulletPositionChange, v)
		bullet:AddPositionChangeListen(bind_func)
	end
	bullet:CreateBulletObj()
	self.bullet_list[bullet] = bullet
end

function FishingView:BulletDeleteCallBack(bullet)
	if self.bullet_list[bullet] then
		self.bullet_list[bullet]:DeleteMe()
		self.bullet_list[bullet] = nil
	end
end

function FishingView:TouchCallBack(bullet, obj)
	--??????????????????????????????
	for _, v in ipairs(self.protect_fish_list) do
		if v:GetObj() == obj then
			--????????????
			local position = bullet:GetPosition()
			local bundle_name, asset_name = ResPath.GetUiXEffect("UI_buyuzidan_sj")
			EffectManager.Instance:PlayAtTransform(bundle_name, asset_name, self.node_list["BulletRange"].transform, 2, position)

			--????????????
			self.bullet_list[bullet]:DeleteMe()
			self.bullet_list[bullet] = nil

			--?????????????????????
			local uid = FishingData.Instance:GetNowFishPondUid()
			local now_fish_list = FishingData.Instance:GetNowFishList()
			if nil == now_fish_list then
				print_error("now_fish_list is nil!!!!!!!!!!!!!!!!")
				return
			end
			YuLeCtrl.Instance:SendFishPoolStealFish(uid, now_fish_list.is_fake_pool, now_fish_list.fish_quality, FISH_TYPE.PROTECT_FISH)

			SysMsgCtrl.Instance:ErrorRemind(Language.Fishpond.ProtectFishNotFarm)
			return
		end
	end

	for k, v in ipairs(self.normal_fish_list) do
		if v:GetObj() == obj then
			--???????????????
			if v:IsDead() then
				return
			end

			--????????????
			local position = bullet:GetPosition()
			local bundle_name, asset_name = ResPath.GetUiXEffect("UI_buyuzidan_sj")
			EffectManager.Instance:PlayAtTransform(bundle_name, asset_name, self.node_list["BulletRange"].transform, 2, position)

			--????????????
			self.bullet_list[bullet]:DeleteMe()
			self.bullet_list[bullet] = nil

			local wait_delete_list = FishingData.Instance:GetWaitDeleteList()
			if nil ~= wait_delete_list then
				for _, v2 in ipairs(wait_delete_list) do
					if v2 == v then
						--???????????????????????????????????????
						return
					end
				end
			end

			--??????????????????
			FishingData.Instance:AddWaitDeleteList(v)

			--?????????????????????
			local uid = FishingData.Instance:GetNowFishPondUid()
			local now_fish_list = FishingData.Instance:GetNowFishList()
			if nil == now_fish_list then
				print_error("now_fish_list is nil!!!!!!!!!!!!!!!!")
				return
			end
			YuLeCtrl.Instance:SendFishPoolStealFish(uid, now_fish_list.is_fake_pool, now_fish_list.fish_quality, FISH_TYPE.NORMAL_FISH)
			return
		end
	end
end

--?????????????????????
function FishingView:CheckDeleteFish(is_succ)
	local wait_delete_list = FishingData.Instance:GetWaitDeleteList()
	if nil == wait_delete_list then
		return
	end
	local last_index = #wait_delete_list
	if last_index == 0 then
		return
	end

	local fish = wait_delete_list[last_index]
	if not fish:IsDead() then
		if is_succ then
			--??????????????????????????????????????????
			fish:PlayToBeTake()
			for k, v in ipairs(self.normal_fish_list) do
				if fish:GetObj() == v:GetObj() then
					table.remove(self.normal_fish_list, k)
					break
				end
			end
		else
			fish:SetDelfaultSpeed(2)
			fish:SetIsRun(true)
		end
	end

	wait_delete_list[last_index] = nil
end

--?????????????????????
function FishingView:ClickFishRecord()
	YuLeCtrl.Instance:SendFishPoolQueryReq(FISH_POOL_QUERY_TYPE.FISH_POOL_QUERY_TYPE_STEAL_GENERAL_INFO)
	ViewManager.Instance:Open(ViewName.BeStealRecordView)
end

-- ??????????????????
function FishingView:OpenFishPondList()
	-- 30??????????????????
	ClickOnceRemindList[RemindName.Fishing_CanSteal] = 0
	RemindManager.Instance:CreateIntervalRemindTimer(RemindName.Fishing_CanSteal)

	YuLeCtrl.Instance:SendFishPoolQueryReq(FISH_POOL_QUERY_TYPE.FISH_POOL_QUERY_TYPE_WORLD_GENERAL_INFO)
end

--?????????????????????
function FishingView:ClickAddBullet()
	if not FishingData.Instance:CanBuyBulletTimes() then
		SysMsgCtrl.Instance:ErrorRemind(Language.Fishpond.NotTimesBuyBullet)
		return
	end

	local other_cfg = FishingData.Instance:GetOtherCfg()
	if nil == other_cfg then
		return
	end
	local bullet_buy_times = FishingData.Instance:GetTodayBulletBuyTimes()
	local gold = FishingData.Instance:GetGoldByBuyBulletTimes(bullet_buy_times + 1)
	local give_bullet_per_buy = other_cfg.give_bullet_per_buy				--???????????????????????????
	local des = string.format(Language.Fishpond.BuyBulletNumDes, gold, give_bullet_per_buy)

	local function ok_callback()
		YuLeCtrl.Instance:SendFishPoolBuyBulletReq()
	end
	TipsCtrl.Instance:ShowCommonAutoView("bullt_num", des, ok_callback)
end

--???????????????(??????)
function FishingView:ClickFarmFish()
	local uid = FishingData.Instance:GetNowFishPondUid()
	if uid == GameVoManager.Instance:GetMainRoleVo().role_id then
		local fish_list = FishingData.Instance:GetNowFishList()
		if nil == fish_list then
			return
		end
		local fang_fish_time = fish_list.fang_fish_time
		if fang_fish_time > 0 then
			local server_times = TimeCtrl.Instance:GetServerTime()
			local fish_info = FishingData.Instance:GetFishInfoByQuality(fish_list.fish_quality)
			if nil == fish_info then
				return
			end
			local need_times = fish_info.need_time
			local left_time = need_times - (server_times - fang_fish_time)
			if left_time <= 0 then
				--?????????
				self.is_play_reward_effect = false
				self.can_harvest = false
				self:FlushCommon()
				YuLeCtrl.Instance:SendFishPoolHarvest()
			else
				ViewManager.Instance:Open(ViewName.YangFishView)
			end
		else
			ViewManager.Instance:Open(ViewName.YangFishView)
		end
	else
		FishingData.Instance:SetNowFishPondUid(GameVoManager.Instance:GetMainRoleVo().role_id)
		FishingData.Instance:SetNowFishList(FishingData.Instance:GetMyFishList())
		self.is_self = true
		self:StartCreateFish()
		self:FlushTitleDes()
		self:FlushCommon()
	end
end

function FishingView:OpenTips()
	TipsCtrl.Instance:ShowHelpTipView(193)
end

function FishingView:OnClickQuick()
	TipsCtrl.Instance:ShowQuickCompletionView("", false, nil, nil,nil,false,SKIP_TYPE.SKIP_TYPE_FISH,nil,nil)
end

--???????????????????????????
function FishingView:ClickAddFishTimes()
	if not FishingData.Instance:CanBuyFarmFishTimes() then
		SysMsgCtrl.Instance:ErrorRemind(Language.Fishpond.NotTimesBuyFarmFish)
		return
	end
	local today_buy_fang_fish_tims = FishingData.Instance:GetTodayFarmFishBuyTimes()
	local gold = FishingData.Instance:GetGoldByBuyFangFishTimes(today_buy_fang_fish_tims + 1)
	local des = string.format(Language.Fishpond.BuyFarmFishTimesDes, gold)

	local function ok_callback()
		YuLeCtrl.Instance:SendFishPoolQueryReq(FISH_POOL_QUERY_TYPE.FISH_POOL_BUY_FANG_FISH_TIMES)
	end
	TipsCtrl.Instance:ShowCommonAutoView("fish_count", des, ok_callback)
end

-- ??????????????????
function FishingView:PlayRewardEffect()
	self.is_play_reward_effect = true
	for k,v in pairs(self.normal_fish_list) do
		local position = v:GetPosition()
		local bundle_name, asset_name = ResPath.GetUiXEffect("UI_buyuzidan_sj")
		EffectManager.Instance:PlayAtTransform(bundle_name, asset_name, self.node_list["BulletRange"].transform, 2, position)
		v:PlayToBeTake()
	end
	self.normal_fish_list = {}
	self:RemoveDelayTime()
	self.delay_time = GlobalTimerQuest:AddDelayTimer(function() self:ShowRewardView() end, 1)
end

function FishingView:RemoveDelayTime()
	if self.delay_time then
		GlobalTimerQuest:CancelQuest(self.delay_time)
		self.delay_time = nil
	end
end

function FishingView:ShowRewardView()
	self.is_play_reward_effect = false
	ViewManager.Instance:Open(ViewName.HarvestRecordView)
end