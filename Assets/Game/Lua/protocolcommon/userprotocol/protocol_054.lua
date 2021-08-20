-- 副本通用 失败显示BOSS剩余血量
SCFBPassOrFailedNotice = SCFBPassOrFailedNotice or BaseClass(BaseProtocolStruct)
function SCFBPassOrFailedNotice:__init()
	self.msg_type = 5429
end

function SCFBPassOrFailedNotice:Decode()
	self.monster_id = MsgAdapter.ReadUShort()
	self.hp_percent = MsgAdapter.ReadShort()
end

--蜜月祝福信息
SCQingyuanBlessInfo = SCQingyuanBlessInfo or BaseClass(BaseProtocolStruct)
function SCQingyuanBlessInfo:__init()
	self.msg_type = 5438

	self.is_fetch_bless_reward = 0
	self.bless_days = 0
	self.lover_bless_days = 0
end

function SCQingyuanBlessInfo:Decode()
	self.is_fetch_bless_reward = MsgAdapter.ReadInt()
	self.bless_days = MsgAdapter.ReadInt()
	self.lover_bless_days = MsgAdapter.ReadInt()
end

--婚宴被邀请列表
SCQingyuanHunyanInviteInfo = SCQingyuanHunyanInviteInfo or BaseClass(BaseProtocolStruct)
function SCQingyuanHunyanInviteInfo:__init()
	self.msg_type = 5439
end

function SCQingyuanHunyanInviteInfo:DecodeInvite()
	local data = {}
	data.man_name = MsgAdapter.ReadStrN(32)
	data.women_name = MsgAdapter.ReadStrN(32)
	data.yanhui_fb_key = MsgAdapter.ReadInt()
	data.hunyan_type = MsgAdapter.ReadInt()
	data.garden_num = MsgAdapter.ReadInt()			--已采集次数
	return data
end

function SCQingyuanHunyanInviteInfo:Decode()
	local count = MsgAdapter.ReadInt()
	self.invite_list = {}
	for i = 1, count do
		self.invite_list[i] = self:DecodeInvite()
	end
end

--经验副本
--领取奖励
CSExpFBFetchChapterReward = CSExpFBFetchChapterReward or BaseClass(BaseProtocolStruct)
function CSExpFBFetchChapterReward:__init()
	self.msg_type = 5452

	self.seq = 0
end

function CSExpFBFetchChapterReward:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteShort(self.seq)
	MsgAdapter.WriteShort(0)
end

---------------------------------------
--剧情本
---------------------------------------
--请求剧情本信息
CSStoryFBGetInfo = CSStoryFBGetInfo or BaseClass(BaseProtocolStruct)
function CSStoryFBGetInfo:__init()
	self.msg_type = 5400
end

function CSStoryFBGetInfo:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
end

local function DecodeStoryFBInfo()
	local t = {}
	t.is_pass = MsgAdapter.ReadShort()
	t.today_times = MsgAdapter.ReadShort()

	return t
end

--剧情本信息返回
SCStoryFBInfo = SCStoryFBInfo or BaseClass(BaseProtocolStruct)
function SCStoryFBInfo:__init()
	self.msg_type = 5401
end

function SCStoryFBInfo:Decode()
	self.info_list = {}
	for i = 0, GameEnum.FB_STORY_MAX_COUNT - 1 do
		self.info_list[i] = DecodeStoryFBInfo()
	end
end

-- --剧情本场景信息
-- SCStoryFBInfo = SCStoryFBInfo or BaseClass(BaseProtocolStruct)
-- function SCStoryFBInfo:__init()
-- 	self.msg_type = 5402
-- end

-- function SCStoryFBInfo:Decode()
-- 	self.is_finish = MsgAdapter.ReadChar()
-- 	self.pass_level = MsgAdapter.ReadChar()
-- 	self.is_pass = MsgAdapter.ReadChar()
-- 	self.is_active_leave_fb = MsgAdapter.ReadChar()				-- 主动退出副本 1为主动
-- 	self.pass_time_s = MsgAdapter.ReadInt()
-- 	self.coin = MsgAdapter.ReadInt()
-- 	self.exp = MsgAdapter.ReadInt()
-- end

--剧情本界面信息
SCStoryFBRoleInfo = SCStoryFBRoleInfo or BaseClass(BaseProtocolStruct)
function SCStoryFBRoleInfo:__init()
	self.msg_type = 5403
end

function SCStoryFBRoleInfo:Decode()
	self.open_chapter = MsgAdapter.ReadShort()  --开启到的副本章节,从0开始
	self.open_level = MsgAdapter.ReadShort()	--开启到的副本章节中的等级,从0开始
	MsgAdapter.ReadShort()
	local max_count = MsgAdapter.ReadShort()
	local count = 0

	self.chapter_list = {}
	for i = 0, DailyData.GetStoryFbCfgMaxChapter() do
		self.chapter_list[i] = {}
		self.chapter_list[i].chapter = i
		self.chapter_list[i].level_list = {}
		for j = 0, DailyData.GetStoryCfgMaxLevel() - 1 do
			count = count + 1
			if count <= max_count then
				self.chapter_list[i].level_list[j] = {}
				self.chapter_list[i].level_list[j].max_star = MsgAdapter.ReadChar()
				self.chapter_list[i].level_list[j].day_times = MsgAdapter.ReadChar()
				self.chapter_list[i].level_list[j].buy_times = MsgAdapter.ReadShort()
				self.chapter_list[i].level_list[j].min_time = MsgAdapter.ReadShort()
				self.chapter_list[i].level_list[j].global_min_time = MsgAdapter.ReadShort()
				self.chapter_list[i].level_list[j].winner_name = MsgAdapter.ReadStrN(32)
				self.chapter_list[i].level_list[j].level = j
			end
		end
	end
end

--剧情本本奖池
SCStoryRollPool = SCStoryRollPool or BaseClass(BaseProtocolStruct)
function SCStoryRollPool:__init()
	self.msg_type = 5405

	self.roll_list = {}
end

function SCStoryRollPool:Decode()
	self.roll_list = {}
	for i = 1, 4 do
		local roll_item = {}
		roll_item.item_id = MsgAdapter.ReadShort()
		roll_item.is_bind = MsgAdapter.ReadChar()
		roll_item.num = MsgAdapter.ReadChar()
		table.insert(self.roll_list, roll_item)
	end
end

--剧情本翻牌信息
SCStoryRollInfo = SCStoryRollInfo or BaseClass(BaseProtocolStruct)
function SCStoryRollInfo:__init()
	self.msg_type = 5406
end

function SCStoryRollInfo:Decode()
	self.reason = MsgAdapter.ReadShort()
	self.star = MsgAdapter.ReadChar()
	self.hit_seq = MsgAdapter.ReadChar()				--真正命中的数据

	self.clint_click_index = MsgAdapter.ReadShort()		--玩家点击的索引（翻这张位置的牌，但真实数据用hit_seq）
	MsgAdapter.ReadShort()
end

---------------------------------------
--日常副本
---------------------------------------
-- 请求日常副本信息
CSDailyFBGetRoleInfo = CSDailyFBGetRoleInfo or BaseClass(BaseProtocolStruct)
function CSDailyFBGetRoleInfo:__init()
	self.msg_type = 5410
end

function CSDailyFBGetRoleInfo:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
end

-- 经验本首通奖励领取
CSExpFBRetchFirstRewardReq = CSExpFBRetchFirstRewardReq or BaseClass(BaseProtocolStruct)
function CSExpFBRetchFirstRewardReq:__init()
	self.msg_type = 5554
	self.fetch_reward_wave = 0
end

function CSExpFBRetchFirstRewardReq:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteInt(self.fetch_reward_wave)
end

--日常副本信息（属于场景逻辑那块）
SCDailyFBInfo = SCDailyFBInfo or BaseClass(BaseProtocolStruct)
function SCDailyFBInfo:__init()
	self.msg_type = 5412
end

function SCDailyFBInfo:Decode()
	self.dailyfb_type = MsgAdapter.ReadChar()
	self.is_finish = MsgAdapter.ReadChar()
	self.is_pass = MsgAdapter.ReadChar()
	self.is_active_leave_fb = MsgAdapter.ReadChar()

	self.pass_time_s = MsgAdapter.ReadInt()
	self.m_reward_exp = MsgAdapter.ReadInt()
	self.m_reward_coin = MsgAdapter.ReadInt()

	--经验本： param1 = 波数
	--铜币本： param1 = 波数  param2 = 刷下波的时间
	self.param1 = MsgAdapter.ReadInt()
	self.param2 = MsgAdapter.ReadInt()
end

---------------------------------------
--爬塔副本
---------------------------------------
-- 请求爬塔副本信息
CSPataFbAllInfo = CSPataFbAllInfo or BaseClass(BaseProtocolStruct)
function CSPataFbAllInfo:__init()
	self.msg_type = 5420
end

function CSPataFbAllInfo:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
end

--返回爬塔副本所有信息
SCPataFbAllInfo = SCPataFbAllInfo or BaseClass(BaseProtocolStruct)
function SCPataFbAllInfo:__init()
	self.msg_type = 5421
end

-- local function DecodePataFBInfo()
-- 	local t = {}
-- 	t.pass_level = MsgAdapter.ReadShort()
-- 	t.today_level = MsgAdapter.ReadShort()

-- 	return t
-- end

function SCPataFbAllInfo:Decode()
	-- self.info_list = {}
	-- for i = 0, GameEnum.FB_TOWER_MAX_COUNT - 1 do
		-- self.info_list[i] = DecodePataFBInfo()
	-- end
	self.pass_level = MsgAdapter.ReadShort()
	self.today_level = MsgAdapter.ReadShort()
end

--请求VIP副本信息
CSVipFbAllInfoReq = CSVipFbAllInfoReq or BaseClass(BaseProtocolStruct)
function CSVipFbAllInfoReq:__init()
	self.msg_type = 5422
end

function CSVipFbAllInfoReq:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
end

--返回VIP副本信息
SCVipFbAllInfo = SCVipFbAllInfo or BaseClass(BaseProtocolStruct)
function SCVipFbAllInfo:__init()
	self.msg_type = 5423
end

function SCVipFbAllInfo:Decode()
	self.is_pass_flag = MsgAdapter.ReadInt()

	self.info_list = {}
	for i = 0, GameEnum.FB_VIP_MAX_COUNT - 1 do
		self.info_list[i] = {today_times = MsgAdapter.ReadChar()}
	end
end

-- 请求下一波
CSTeamTowerDefendNextWave = CSTeamTowerDefendNextWave or BaseClass(BaseProtocolStruct)
function CSTeamTowerDefendNextWave:__init()
	self.msg_type = 5432
end

function CSTeamTowerDefendNextWave:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
end

-- 组队装备副本掉落拾取信息
SCFbPickItemInfo = SCFbPickItemInfo or BaseClass(BaseProtocolStruct)
function SCFbPickItemInfo:__init()
	self.msg_type = 5443
	self.item_count = 0
	self.item_list = {}
end

function SCFbPickItemInfo:Decode()
	self.item_count = MsgAdapter.ReadInt()
	self.item_list = {}
	for i = 1, self.item_count do
		self.item_list[i] = ProtocolStruct.ReadItemDataWrapper()
	end
end

---------------------------------------
--单人塔防副本
---------------------------------------
SCTowerDefendInfo = SCTowerDefendInfo or BaseClass(BaseProtocolStruct)
function SCTowerDefendInfo:__init()
	self.msg_type = 5413
end

function SCTowerDefendInfo:Decode()
	self.reason = MsgAdapter.ReadShort()
	MsgAdapter.ReadShort()

	self.time_out_stamp = MsgAdapter.ReadUInt()
	self.is_finish = MsgAdapter.ReadShort()
	self.is_pass = MsgAdapter.ReadShort()
	self.pass_time_s = MsgAdapter.ReadInt()

	self.life_tower_left_hp = MsgAdapter.ReadLL()
	self.life_tower_left_maxhp = MsgAdapter.ReadLL()
	self.curr_wave = MsgAdapter.ReadShort()
	self.curr_level = MsgAdapter.ReadShort()
	self.next_wave_refresh_time = MsgAdapter.ReadInt()
	self.clear_wave_count = MsgAdapter.ReadShort()
	self.death_count = MsgAdapter.ReadShort()

	-- self.last_perform_time_list = {}
	-- for i = 1, 2 do
	-- 	table.insert(self.last_perform_time_list, MsgAdapter.ReadUInt())
	-- end

	-- 打怪的掉落，可用在结算面板中
	self.get_coin = MsgAdapter.ReadInt()
	local get_item_count = MsgAdapter.ReadInt()
	self.pick_drop_list = {}

	for i = 1, get_item_count do
		local drop_obj = {}
		drop_obj.num = MsgAdapter.ReadShort()
		drop_obj.item_id = MsgAdapter.ReadUShort()

		table.insert(self.pick_drop_list, drop_obj)
	end
end

---------------------------------------
--情缘副本购买BUFF
---------------------------------------
-- CSQingYuanBuyFBBuff = CSQingYuanBuyFBBuff or BaseClass(BaseProtocolStruct)
-- function CSQingYuanBuyFBBuff:__init()
-- 	self.msg_type = 5440
-- end

-- function CSQingYuanBuyFBBuff:Encode()
-- 	MsgAdapter.WriteBegin(self.msg_type)
-- end

---------// 5440 婚宴场景个人信息
SCWeddingRoleInfo = SCWeddingRoleInfo or BaseClass(BaseProtocolStruct)
function SCWeddingRoleInfo:__init()
	self.msg_type = 5440

	self.wedding_liveness = 0           -- 热度
	self.is_baitang = 0                	-- 婚礼拜堂状态
	self.is_in_red_bag_fulsh_time = 0   -- 红包刷新状态
	self.has_gather_num = 0				-- 宴席采集次数
	self.has_gather_red_bag = 0         -- 红包采集次数
	self.total_exp = 0                  -- 获得经验
	self.hunyan_food_id_count = 0 		-- 已采婚宴酒席数
	self.hunyan_food_id_list = {}		-- 婚宴酒席objid列表
end

function SCWeddingRoleInfo:Decode()
	self.wedding_liveness = MsgAdapter.ReadShort()
	self.is_baitang = MsgAdapter.ReadChar()
	self.is_in_red_bag_fulsh_time = MsgAdapter.ReadChar()
	self.has_gather_num = MsgAdapter.ReadShort()
	self.has_gather_red_bag = MsgAdapter.ReadShort()
	self.total_exp = MsgAdapter.ReadLL()
	self.hunyan_food_id_count = MsgAdapter.ReadShort()
	self.hunyan_food_id_list = {}
	if self.hunyan_food_id_count > 0 then
		for i = 1, self.hunyan_food_id_count do
			local obj_id = MsgAdapter.ReadUShort()
			self.hunyan_food_id_list[obj_id] = obj_id
		end
	end
end

---------------------------------------
--副本组队房间
---------------------------------------

-- 副本房间进入确认通知
SCTeamFbRoomEnterAffirm = SCTeamFbRoomEnterAffirm or BaseClass(BaseProtocolStruct)
function SCTeamFbRoomEnterAffirm:__init()
	self.msg_type = 5448
end

function SCTeamFbRoomEnterAffirm:Decode()
	self.team_type = MsgAdapter.ReadInt()
	self.mode = MsgAdapter.ReadInt()
	self.layer = MsgAdapter.ReadInt()
end

--副本房间列表
SCTeamFbRoomList = SCTeamFbRoomList or BaseClass(BaseProtocolStruct)
function SCTeamFbRoomList:__init()
	self.msg_type = 5449
end

function SCTeamFbRoomList:Decode()
	self.team_type = MsgAdapter.ReadInt()
	self.room_list = {}
	self.count = MsgAdapter.ReadInt()
	for i = 1, self.count do
		local room = {}
		room.team_index = MsgAdapter.ReadInt()
		room.leader_name = MsgAdapter.ReadStrN(32)
		room.leader_capability = MsgAdapter.ReadInt()
		room.limit_capability = MsgAdapter.ReadInt()
		room.avatar_key_big = MsgAdapter.ReadUInt()
		room.avatar_key_small = MsgAdapter.ReadUInt()
		room.menber_num = MsgAdapter.ReadChar()
		room.mode = MsgAdapter.ReadChar()
		room.leader_sex = MsgAdapter.ReadChar()
		room.leader_prof = MsgAdapter.ReadChar()
		room.leader_uid = MsgAdapter.ReadInt()
		room.layer = MsgAdapter.ReadChar()
		room.assign_mode = MsgAdapter.ReadChar()
		room.is_must_check = MsgAdapter.ReadChar()
		room.reserve_2 = MsgAdapter.ReadChar()
		room.flag = room.menber_num >= 3 and 1 or 0
		table.insert(self.room_list, room)
	end
end

-- 组队副本房间请求操作
CSTeamFbRoomOperate = CSTeamFbRoomOperate or BaseClass(BaseProtocolStruct)
function CSTeamFbRoomOperate:__init()
	self.msg_type = 5450
end

function CSTeamFbRoomOperate:Encode()
	MsgAdapter.WriteBegin(self.msg_type)

	MsgAdapter.WriteInt(self.operate_type)
	MsgAdapter.WriteInt(self.param1)
	MsgAdapter.WriteInt(self.param2)
	MsgAdapter.WriteInt(self.param3)
	MsgAdapter.WriteInt(self.param4)
	MsgAdapter.WriteInt(self.param5)
end

---------------------------------------
--迷宫仙府副本
---------------------------------------
--接触到假的传送点时，发这个协议。服务端会判断是否角色在这个传送点附近
CSMgxfTeamFbTouchDoor = CSMgxfTeamFbTouchDoor or BaseClass(BaseProtocolStruct)
function CSMgxfTeamFbTouchDoor:__init()
	self.msg_type = 5445

	self.layer = -1
	self.door_index = - 1
end

function CSMgxfTeamFbTouchDoor:Encode()
	MsgAdapter.WriteBegin(self.msg_type)

	MsgAdapter.WriteShort(self.layer)
	MsgAdapter.WriteShort(self.door_index)
end

SCMgxfTeamFbSceneLogicInfo = SCMgxfTeamFbSceneLogicInfo or BaseClass(BaseProtocolStruct)
function SCMgxfTeamFbSceneLogicInfo:__init()
	self.msg_type = 5446
end

function SCMgxfTeamFbSceneLogicInfo:Decode()
	self.time_out_stamp = MsgAdapter.ReadUInt()
	self.is_finish = MsgAdapter.ReadShort()
	self.is_pass = MsgAdapter.ReadShort()
	self.pass_time_s = MsgAdapter.ReadInt()
	self.mode = MsgAdapter.ReadInt()
	self.layer = MsgAdapter.ReadShort() --玩家自己所处的层
	self.kill_hide_boos_num = MsgAdapter.ReadChar()
	self.kill_end_boss_num = MsgAdapter.ReadChar()

	--传送点当前状态，请改为常量，可根据自己需要重新定义结构。。。by bzw
	self.door_status_list = {}
	for layer = 0, 6 do   	  			--每层
		self.door_status_list[layer] = {}
		for index = 0, 4 do  			--传送点
			local door_obj = {}
			door_obj.layer = layer  	--层从0算起
			door_obj.index = index  	--每次传送点从0算起
			door_obj.status = MsgAdapter.ReadInt()
			self.door_status_list[layer][index] = door_obj
		end
	end
end

--=========================挑战副本品质材料=========================--
--挑战副本购买次数
CSChallengeFBBuyJoinTimes = CSChallengeFBBuyJoinTimes or BaseClass(BaseProtocolStruct)
function CSChallengeFBBuyJoinTimes:__init()
	self.msg_type = 5451
	self.level = 0
end

function CSChallengeFBBuyJoinTimes:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteShort(self.level)
	MsgAdapter.WriteShort(0)
end

--请求挑战副本信息
CSChallengeReqInfo = CSChallengeReqInfo or BaseClass(BaseProtocolStruct)
function CSChallengeReqInfo:__init()
	self.msg_type = 5456
end

function CSChallengeReqInfo:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
end

--挑战副本信息返回
SCChallengeFBInfo = SCChallengeFBInfo or BaseClass(BaseProtocolStruct)
function SCChallengeFBInfo:__init()
	self.msg_type = 5407
end

function SCChallengeFBInfo:Decode()
	self.enter_count = MsgAdapter.ReadInt()
	self.buy_count = MsgAdapter.ReadInt()
	self.is_auto = MsgAdapter.ReadShort()
	MsgAdapter.ReadShort()
	self.level_list = {}
	for i = 0, COMMON_CONSTS.LEVEL_MAX_COUNT - 1 do
		local lev_vo = {}
		lev_vo.is_pass = MsgAdapter.ReadChar()
		lev_vo.fight_layer = MsgAdapter.ReadChar()
		lev_vo.state = MsgAdapter.ReadShort()
		lev_vo.history_max_reward = MsgAdapter.ReadShort()
		lev_vo.is_continue = MsgAdapter.ReadShort()
		lev_vo.use_count = MsgAdapter.ReadChar()
		MsgAdapter.ReadChar()
		MsgAdapter.ReadShort()
		self.level_list[i] = lev_vo
	end
end

--挑战副本结束
SCChallengePassLevel = SCChallengePassLevel or BaseClass(BaseProtocolStruct)
function SCChallengePassLevel:__init()
	self.msg_type = 5408
	self.info = {}
end

function SCChallengePassLevel:Decode()
	self.info = {}
	self.info.level = MsgAdapter.ReadShort()
	self.info.is_pass = MsgAdapter.ReadChar()  					-- 0失败 1通关 2副本中更新
	self.info.fight_layer = MsgAdapter.ReadChar()
	self.info.is_active_leave_fb = MsgAdapter.ReadChar()		-- 是否主动退出 1为主动
	self.info.reward_flag = MsgAdapter.ReadChar()
	MsgAdapter.ReadShort()
	self.info.pass_time = MsgAdapter.ReadUInt()
end

--挑战副本每一层的消息
SCChallengeLayerInfo = SCChallengeLayerInfo or BaseClass(BaseProtocolStruct)
function SCChallengeLayerInfo:__init()
	self.msg_type = 5419
	self.info = {}
end

function SCChallengeLayerInfo:Decode()
	self.info.is_pass = MsgAdapter.ReadChar()
	self.info.is_finish = MsgAdapter.ReadChar()
	MsgAdapter.ReadShort()
	self.info.time_out_stamp = MsgAdapter.ReadUInt()  				--副本超时结束时间戳（可用于倒计时）
end

--=========================阶段副本商城道具=========================--
--请求阶段副本信息
CSPhaseFBInfoReq = CSPhaseFBInfoReq or BaseClass(BaseProtocolStruct)
function CSPhaseFBInfoReq:__init()
	self.msg_type = 5465
	self.operate_type = 0
	self.fb_index = 0
end

function CSPhaseFBInfoReq:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteShort(self.operate_type)
	MsgAdapter.WriteShort(self.fb_index)
end

local function DecodePhaseFBInfo()
	local t = {}
	t.is_pass = MsgAdapter.ReadChar()					-- 已经通过了第几层
	t.today_buy_times = MsgAdapter.ReadChar()			-- 今日购买的副本次数
	t.today_times = MsgAdapter.ReadShort()				-- 今日副本次数
	return t
end

--Boss击杀列表信息请求
CSBossKillerInfoReq = CSBossKillerInfoReq or BaseClass(BaseProtocolStruct)
function CSBossKillerInfoReq:__init()
	self.msg_type = 5466
	self.boss_type = 0
	self.boss_id = 0
	self.scene_id = 0
end

function CSBossKillerInfoReq:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteInt(self.boss_type)
	MsgAdapter.WriteInt(self.boss_id)
	MsgAdapter.WriteInt(self.scene_id)
end

--阶段副本信息返回
SCPhaseFBInfo = SCPhaseFBInfo or BaseClass(BaseProtocolStruct)
function SCPhaseFBInfo:__init()
	self.msg_type = 5418
end

function SCPhaseFBInfo:Decode()
	self.info_list = {}
	for i = 0, GameEnum.FB_PHASE_MAX_COUNT - 1 do
		self.info_list[i] = DecodePhaseFBInfo()
	end
end

--所有副本扫荡结果
SCAutoFBRewardDetail = SCAutoFBRewardDetail or BaseClass(BaseProtocolStruct)
function SCAutoFBRewardDetail:__init()
	self.msg_type = 5417
end

function SCAutoFBRewardDetail:Decode()
	self.fb_type = MsgAdapter.ReadShort()
	MsgAdapter.ReadShort()
	self.reward_coin = MsgAdapter.ReadInt()
	self.reward_exp = MsgAdapter.ReadLL()
	self.reward_xianhun = MsgAdapter.ReadInt()
	self.reward_yuanli = MsgAdapter.ReadInt()
	self.item_count = MsgAdapter.ReadInt()

	self.item_list = {}
	for i= 1, self.item_count do
		self.item_list[i] = {}
		self.item_list[i].item_id = MsgAdapter.ReadUShort()
		self.item_list[i].num = MsgAdapter.ReadShort()
		self.item_list[i].is_bind = MsgAdapter.ReadChar()
		MsgAdapter.ReadChar()
		MsgAdapter.ReadShort()
	end
end

	----------------------品质本--------------------------

-- 品质本 请求
CSChallengeFBOP = CSChallengeFBOP or BaseClass(BaseProtocolStruct)
function CSChallengeFBOP:__init()
	self.msg_type = 5467
	self.type = 0
	self.level = 0
end

function CSChallengeFBOP:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteShort(self.type)				-- 0扫荡，1重置关卡，2请求发送协议
	MsgAdapter.WriteShort(self.level)				-- 0,1关卡索引  2, 3发0
end

-- 品质本信息


--------------情缘-----------------

-- 情缘副本基本信息下发
SCQingyuanInfo = SCQingyuanInfo or BaseClass(BaseProtocolStruct)
function SCQingyuanInfo:__init()
	self.msg_type = 5425
	self.join_fb_times = 0
	self.buy_fb_join_times = 0
	self.is_hunyan_already_open = 0
	self.qingyuan_value = 0
	self.yanhui_fb_key = 0
end

function SCQingyuanInfo:Decode()
	self.join_fb_times = MsgAdapter.ReadChar()
	self.buy_fb_join_times = MsgAdapter.ReadChar()
	self.is_hunyan_already_open = MsgAdapter.ReadChar()
	MsgAdapter.ReadChar()
	self.qingyuan_value = MsgAdapter.ReadInt()
	self.yanhui_fb_key = MsgAdapter.ReadInt()
end

-- 情缘副本场景信息下发
SCQingyuanFBInfo = SCQingyuanFBInfo or BaseClass(BaseProtocolStruct)
function SCQingyuanFBInfo:__init()
	self.msg_type = 5426
	self.curr_wave = 0
	self.max_wave_count = 0
	self.is_pass = 0
	self.is_finish = 0
	self.next_refresh_monster_time = 0
	self.add_qingyuan_value = 0
	self.buy_buff_times = 0
	self.buff_out_timestamp = 0
	self.per_wave_remain_time = 0
	self.total_get_uplevel_stuffs = 0
	self.exp = 0
	self.kick_out_timestamp = 0
	self.male_is_buy = 0
	self.female_is_buy = 0
end

function SCQingyuanFBInfo:Decode()
	self.curr_wave = MsgAdapter.ReadChar()
	self.max_wave_count = MsgAdapter.ReadChar()
	self.is_pass = MsgAdapter.ReadChar()
	self.is_finish = MsgAdapter.ReadChar()
	self.next_refresh_monster_time = MsgAdapter.ReadInt()
	self.add_qingyuan_value = MsgAdapter.ReadShort()
	self.buy_buff_times = MsgAdapter.ReadShort()
	self.buff_out_timestamp = MsgAdapter.ReadInt()
	self.per_wave_remain_time = MsgAdapter.ReadInt()
	self.total_get_uplevel_stuffs = MsgAdapter.ReadInt()
	self.exp = MsgAdapter.ReadLL()
	self.kick_out_timestamp = MsgAdapter.ReadInt()
	self.male_is_buy = MsgAdapter.ReadChar()
	self.female_is_buy = MsgAdapter.ReadChar()
	MsgAdapter.ReadShort()
end

-- 情缘装备信息
SCQingyuanEuipmentInfo = SCQingyuanEuipmentInfo or BaseClass(BaseProtocolStruct)
function SCQingyuanEuipmentInfo:__init()
	self.msg_type = 5427
end

function SCQingyuanEuipmentInfo:Decode()
	self.consume_num = MsgAdapter.ReadInt()
	self.baoji_num = MsgAdapter.ReadInt()
	self.exp = MsgAdapter.ReadInt()
	self.star = MsgAdapter.ReadInt()
	self.lover_level = MsgAdapter.ReadInt()
	self.lover_ring_item_id = MsgAdapter.ReadShort()
	self.ring_item_id = MsgAdapter.ReadShort()
	self.lover_star = MsgAdapter.ReadShort()
	self.lover_prof = MsgAdapter.ReadShort()
end

-- 伴侣情缘值下发
SCQingyuanMateValueSend = SCQingyuanMateValueSend or BaseClass(BaseProtocolStruct)
function SCQingyuanMateValueSend:__init()
	self.msg_type = 5428
end

function SCQingyuanMateValueSend:Decode()
	self.mate_qingyuan_value = MsgAdapter.ReadInt()
end

-- 伴侣信息下发
SCQingyuanLoverInfo = SCQingyuanLoverInfo or BaseClass(BaseProtocolStruct)
function SCQingyuanLoverInfo:__init()
	self.msg_type = 5441
end

function SCQingyuanLoverInfo:Decode()
	self.lover_level = MsgAdapter.ReadInt()
	self.lover_ring_item_id = MsgAdapter.ReadShort()
	self.lover_star = MsgAdapter.ReadShort()
end

SCQingyuanFBRewardRecordInfo = SCQingyuanFBRewardRecordInfo or BaseClass(BaseProtocolStruct)
function SCQingyuanFBRewardRecordInfo:__init()
	self.msg_type = 5442
end

function SCQingyuanFBRewardRecordInfo:Decode()
	local item_count = MsgAdapter.ReadInt()
	self.reward_list = {}
	for i = 1, item_count do
		local reward_data = {}
		reward_data.item_id = MsgAdapter.ReadShort()
		reward_data.num = MsgAdapter.ReadShort()
		-- 服务端说直接写死
		reward_data.is_bind = 1
		table.insert(self.reward_list, reward_data)
	end
end

-- 请求打宝boss信息
CSGetBossInfoReq = CSGetBossInfoReq or BaseClass(BaseProtocolStruct)
function CSGetBossInfoReq:__init()
	self.msg_type = 5463
	self.enter_type = 0
end

function CSGetBossInfoReq:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteInt(self.enter_type)
end

-- 请求情缘副本基本信息
CSQingyuanFBOperaReq = CSQingyuanFBOperaReq or BaseClass(BaseProtocolStruct)
function CSQingyuanFBOperaReq:__init()
	self.msg_type = 5469
	self.opera_type = 0
	self.param_1 = 0
end

function CSQingyuanFBOperaReq:Encode()
	MsgAdapter.WriteBegin(self.msg_type)

	MsgAdapter.WriteShort(self.opera_type)
	MsgAdapter.WriteShort(self.param_1)
end

-- 购买情缘副本进入次数
CSQingyuanBuyJoinTimes = CSQingyuanBuyJoinTimes or BaseClass(BaseProtocolStruct)
function CSQingyuanBuyJoinTimes:__init()
	self.msg_type = 5470
end

function CSQingyuanBuyJoinTimes:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
end

-- 情缘装备升级
CSQingyuanUpLevel = CSQingyuanUpLevel or BaseClass(BaseProtocolStruct)

function CSQingyuanUpLevel:__init()
	self.msg_type = 5471
	self.stuff_id = 0
	self.repeat_tiems = 1
	self.is_auto_buy = 0
end

function CSQingyuanUpLevel:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteUShort(self.stuff_id)
	MsgAdapter.WriteShort(self.repeat_tiems)
	MsgAdapter.WriteInt(self.is_auto_buy)
end

-- 取下情缘装备
CSQingyuanTakeOffEquip = CSQingyuanTakeOffEquip or BaseClass(BaseProtocolStruct)

function CSQingyuanTakeOffEquip:__init()
	self.msg_type = 5472
end

function CSQingyuanTakeOffEquip:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	print_log("#################CSQingyuanTakeOffEquip")
end

-- 情缘装备信息请求
CSQingyuanReqEquipInfo = CSQingyuanReqEquipInfo or BaseClass(BaseProtocolStruct)

function CSQingyuanReqEquipInfo:__init()
	self.msg_type = 5473
end

function CSQingyuanReqEquipInfo:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
end

-- 请求伴侣情缘值查询
CSQingyuanMateValueQuery = CSQingyuanMateValueQuery or BaseClass(BaseProtocolStruct)

function CSQingyuanMateValueQuery:__init()
	self.msg_type = 5474
end

function CSQingyuanMateValueQuery:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
end

-- 请求离婚协议
CSQingyuanDivorceReqCS = CSQingyuanDivorceReqCS or BaseClass(BaseProtocolStruct)

function CSQingyuanDivorceReqCS:__init()
	self.msg_type = 5475
	self.is_forced_divorce= 0
end

function CSQingyuanDivorceReqCS:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteInt(self.is_forced_divorce)
end

-- 副本请求下一关
CSFBReqNextLevel = CSFBReqNextLevel or BaseClass(BaseProtocolStruct)

function CSFBReqNextLevel:__init()
	self.msg_type = 5476
end

function CSFBReqNextLevel:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
end


--------------BOSS-----------------

-- 进入Boss之家请求
CSEnterBossFamily = CSEnterBossFamily or BaseClass(BaseProtocolStruct)

function CSEnterBossFamily:__init()
	self.msg_type = 5477

	self.enter_type = 0
	self.scene_id = 0
	self.is_buy_dabao_times = 0
end

function CSEnterBossFamily:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteInt(self.enter_type)
	MsgAdapter.WriteInt(self.scene_id)
	MsgAdapter.WriteChar(self.is_buy_dabao_times)
	MsgAdapter.WriteChar(0)
	MsgAdapter.WriteShort(0)
end

--仙盟
SCGuildFBInfo = SCGuildFBInfo or BaseClass(BaseProtocolStruct)
function SCGuildFBInfo:__init()
	self.msg_type = 5478

	self.notify_reason = 0
	self.curr_wave = 0
	self.next_wave_time = 0
	self.wave_enemy_count = 0
	self.wave_enemy_max = 0
	self.is_pass = 0
	self.is_finish = 0
	self.hp = 0
	self.max_hp = 0
	self.kick_role_time = 0
	self.rank_count = 0
end

function SCGuildFBInfo:Decode()
	self.notify_reason = MsgAdapter.ReadShort()
	self.curr_wave =  MsgAdapter.ReadShort()
	self.next_wave_time =  MsgAdapter.ReadUInt()
	self.wave_enemy_count =  MsgAdapter.ReadShort()
	self.wave_enemy_max =  MsgAdapter.ReadShort()
	self.is_pass =  MsgAdapter.ReadShort()
	self.is_finish =  MsgAdapter.ReadShort()
	self.hp = MsgAdapter.ReadLL()
	self.max_hp = MsgAdapter.ReadLL()
	self.kick_role_time = MsgAdapter.ReadUInt()
	self.my_rank_pos = MsgAdapter.ReadInt()
	self.my_hurt_val = MsgAdapter.ReadLL()

	self.rank_count = MsgAdapter.ReadInt()
	local MAX_ITEM_COUNT = 20
	self.temp_rank_info_list = {}
	for i = 1, MAX_ITEM_COUNT do
		self.temp_rank_info_list[i] = {}
		self.temp_rank_info_list[i].user_id = MsgAdapter.ReadInt()
		self.temp_rank_info_list[i].user_name = MsgAdapter.ReadStrN(32)
		self.temp_rank_info_list[i].hurt_val = MsgAdapter.ReadLL()
	end
	self.rank_info_list = {}
	for j = 1, self.rank_count do
		table.insert(self.rank_info_list, self.temp_rank_info_list[j])
	end
end

-- 请求怪物生成点列表信息
CSReqMonsterGeneraterList = CSReqMonsterGeneraterList or BaseClass(BaseProtocolStruct)

function CSReqMonsterGeneraterList:__init()
	self.msg_type = 5479

	self.scene_id = 0
end

function CSReqMonsterGeneraterList:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteInt(self.scene_id)
end

-- 下发当前场景怪物生成点列表信息
SCMonsterGeneraterList = SCMonsterGeneraterList or BaseClass(BaseProtocolStruct)

function SCMonsterGeneraterList:__init()
	self.msg_type = 5480

	self.boss_list = {}
end

function SCMonsterGeneraterList:Decode()
	local boss_count = MsgAdapter.ReadInt()
	self.boss_list = {}
	for i = 1, boss_count do
		local vo = {}
		vo.boss_id = MsgAdapter.ReadInt()
		vo.next_refresh_time = MsgAdapter.ReadUInt()
		self.boss_list[i] = vo
	end
end

-- 请求妖兽广场状态
CSGetYaoShouGuangChangState = CSGetYaoShouGuangChangState or BaseClass(BaseProtocolStruct)

function CSGetYaoShouGuangChangState:__init()
	self.msg_type = 5481
end

function CSGetYaoShouGuangChangState:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
end

-- 下发妖兽广场状态
SCYaoShouGuangChangState = SCYaoShouGuangChangState or BaseClass(BaseProtocolStruct)

function SCYaoShouGuangChangState:__init()
	self.msg_type = 5482

	self.status = 0
	self.next_status_time = 0
	self.next_standby_time = 0
	self.next_stop_time = 0
	self.syt_max_score = 0
	self.datais_valid = 0
	self.quanfu_topscore = 0
	self.quanfu_topscore_uid = 0
	self.quanfu_topscore_name = 0
	self.next_freetimes_invalid_time = 0
end

function SCYaoShouGuangChangState:Decode()
	self.status = MsgAdapter.ReadInt()
	self.next_status_time = MsgAdapter.ReadUInt()
	self.next_standby_time = MsgAdapter.ReadUInt()
	self.next_stop_time = MsgAdapter.ReadUInt()
	self.datais_valid = MsgAdapter.ReadInt()
	self.syt_max_score = MsgAdapter.ReadInt()
	self.quanfu_topscore = MsgAdapter.ReadInt()
	self.quanfu_topscore_uid = MsgAdapter.ReadInt()
	self.quanfu_topscore_name = MsgAdapter.ReadStrN(32)

end

-- 下发妖兽广场副本信息
SCYaoShouGuangChangFBInfo = SCYaoShouGuangChangFBInfo or BaseClass(BaseProtocolStruct)

function SCYaoShouGuangChangFBInfo:__init()
	self.msg_type = 5483

	self.reason = 0
	self.wave_index = 0
	self.fb_lv = 0
	self.user_list = {}
end

function SCYaoShouGuangChangFBInfo:Decode()
	self.reason = MsgAdapter.ReadInt()
	self.wave_index = MsgAdapter.ReadInt()
	self.fb_lv = MsgAdapter.ReadInt()
	self.role_num = MsgAdapter.ReadInt()
	self.monster_num = MsgAdapter.ReadInt()
	user_count = MsgAdapter.ReadInt()
	self.user_list = {}
	for i = 1, user_count do
		self.user_list[i] = {}
		self.user_list[i].uid = MsgAdapter.ReadInt()
		self.user_list[i].score = MsgAdapter.ReadInt()
	end
end

-- 请求妖兽广场奖励
CSGetYaoShouGuangChangReward = CSGetYaoShouGuangChangReward or BaseClass(BaseProtocolStruct)

function CSGetYaoShouGuangChangReward:__init()
	self.msg_type = 5484
	self.times = 0
end

function CSGetYaoShouGuangChangReward:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteInt(self.times)
end

-- 下发妖兽广场奖励
SCNotifyYaoShouGuangChangReward = SCNotifyYaoShouGuangChangReward or BaseClass(BaseProtocolStruct)

function SCNotifyYaoShouGuangChangReward:__init()
	self.msg_type = 5485

	self.score = 0
	self.exp = 0
	self.bind_coin = 0
end

function SCNotifyYaoShouGuangChangReward:Decode()
	self.score = MsgAdapter.ReadUInt()
	self.exp = MsgAdapter.ReadUInt()
	self.bind_coin = MsgAdapter.ReadUInt()
end

-- 请求进入妖兽广场
CSEnterYaoShouGuangChang = CSEnterYaoShouGuangChang or BaseClass(BaseProtocolStruct)

function CSEnterYaoShouGuangChang:__init()
	self.msg_type = 5486
	self.is_buy_times = 0
end

function CSEnterYaoShouGuangChang:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteInt(self.is_buy_times)
end

-- 捉鬼副本状态
SCZhuaGuiFbInfo = SCZhuaGuiFbInfo or BaseClass(BaseProtocolStruct)

function SCZhuaGuiFbInfo:__init()
	self.msg_type = 5487
end

function SCZhuaGuiFbInfo:Decode()
	self.reason = MsgAdapter.ReadInt()
	self.monster_count = MsgAdapter.ReadInt()
	self.ishave_boss = MsgAdapter.ReadShort()
	self.boss_isdead = MsgAdapter.ReadShort()
	self.kick_time = MsgAdapter.ReadUInt()

	self.zhuagui_info_list = {}
	for i = 1, GameEnum.MAX_TEAM_MEMBER_NUM do
		local vo = {}
		vo.uid = MsgAdapter.ReadInt()
		vo.get_hunli = MsgAdapter.ReadInt()
		vo.get_mojing = MsgAdapter.ReadInt()
		vo.kill_boss_count = MsgAdapter.ReadInt()
		self.zhuagui_info_list[i] = vo
	end

	self.enter_role_num = MsgAdapter.ReadShort()
	self.item_count = MsgAdapter.ReadShort()

	self.zhuagui_item_list = {}
	for i = 1, self.item_count do
		local vo = {}
		vo.item_id = MsgAdapter.ReadUShort()
		vo.is_bind = MsgAdapter.ReadChar()
		vo.is_first = MsgAdapter.ReadChar()
		vo.num = MsgAdapter.ReadInt()
		self.zhuagui_item_list[i] = vo
	end
end

-- 请求锁妖塔状态
CSGetSuoYaoTaState = CSGetSuoYaoTaState or BaseClass(BaseProtocolStruct)

function CSGetSuoYaoTaState:__init()
	self.msg_type = 5490
end

function CSGetSuoYaoTaState:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
end

-- 下发锁妖塔状态
SCSuoYaoTaState = SCSuoYaoTaState or BaseClass(BaseProtocolStruct)

function SCSuoYaoTaState:__init()
	self.msg_type = 5491

	self.status = 0
	self.next_status_time = 0
	self.next_standby_time = 0
	self.next_stop_time = 0
	self.syt_max_score = 0
	self.datais_valid = 0
	self.quanfu_topscore = 0
	self.quanfu_topscore_uid = 0
	self.quanfu_topscore_name = 0
	self.next_freetimes_invalid_time = 0
end

function SCSuoYaoTaState:Decode()
	self.status = MsgAdapter.ReadInt()
	self.next_status_time = MsgAdapter.ReadUInt()
	self.next_standby_time = MsgAdapter.ReadUInt()
	self.next_stop_time = MsgAdapter.ReadUInt()
	self.datais_valid = MsgAdapter.ReadInt()
	self.syt_max_score = MsgAdapter.ReadInt()
	self.quanfu_topscore = MsgAdapter.ReadInt()
	self.quanfu_topscore_uid = MsgAdapter.ReadInt()
	self.quanfu_topscore_name = MsgAdapter.ReadStrN(32)
end

-- 下发锁妖塔副本信息
SCSuoYaoTaFBInfo = SCSuoYaoTaFBInfo or BaseClass(BaseProtocolStruct)

function SCSuoYaoTaFBInfo:__init()
	self.msg_type = 5492

	self.reason = 0
	self.wave_index = 0
	self.fb_lv = 0
	self.task_list = {}
	self.user_list = {}
end

function SCSuoYaoTaFBInfo:Decode()
	self.reason = MsgAdapter.ReadInt()
	self.fb_lv = MsgAdapter.ReadInt()
	self.task_list = {}
	for i = 1, GameEnum.SUOYAOTA_TASK_MAX do
		self.task_list[i] = {}
		self.task_list[i].task_index = i
		self.task_list[i].task_type = MsgAdapter.ReadInt()
		self.task_list[i].param_id = MsgAdapter.ReadInt()
		self.task_list[i].param_num = MsgAdapter.ReadInt()
		self.task_list[i].param_max = MsgAdapter.ReadInt()
	end
	local user_count = MsgAdapter.ReadInt()
	self.user_list = {}
	for i = 1, user_count do
		self.user_list[i] = {}
		self.user_list[i].uid = MsgAdapter.ReadInt()
		self.user_list[i].score = MsgAdapter.ReadInt()
	end
end

-- 请求锁妖塔奖励
CSGetSuoYaoTaReward = CSGetSuoYaoTaReward or BaseClass(BaseProtocolStruct)

function CSGetSuoYaoTaReward:__init()
	self.msg_type = 5493
	self.times = 0
end

function CSGetSuoYaoTaReward:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteInt(self.times)
end

-- 下发锁妖塔奖励
SCNotifySuoYaoTaReward = SCNotifySuoYaoTaReward or BaseClass(BaseProtocolStruct)

function SCNotifySuoYaoTaReward:__init()
	self.msg_type = 5494

	self.score = 0
	self.exp = 0
	self.bind_coin = 0
end

function SCNotifySuoYaoTaReward:Decode()
	self.score = MsgAdapter.ReadUInt()
	self.exp = MsgAdapter.ReadUInt()
	self.bind_coin = MsgAdapter.ReadUInt()
end

-- 请求进入锁妖塔
CSEnterSuoYaoTa = CSEnterSuoYaoTa or BaseClass(BaseProtocolStruct)

function CSEnterSuoYaoTa:__init()
	self.msg_type = 5495
	self.is_buy_times = 0
end

function CSEnterSuoYaoTa:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteInt(self.is_buy_times)
end

-- 请求仙盟副本守卫位置
CSGetGuildFBGuardPos = CSGetGuildFBGuardPos or BaseClass(BaseProtocolStruct)

function CSGetGuildFBGuardPos:__init()
	self.msg_type = 5496
end

function CSGetGuildFBGuardPos:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
end

-- 下发仙盟副本守卫位置
SCGuildFBGuardPos = SCGuildFBGuardPos or BaseClass(BaseProtocolStruct)

function SCGuildFBGuardPos:__init()
	self.msg_type = 5497

	self.scene_id = 0
	self.pos_x = 0
	self.pos_y = 0
end

function SCGuildFBGuardPos:Decode()
	self.scene_id = MsgAdapter.ReadInt()
	self.pos_x = MsgAdapter.ReadInt()
	self.pos_y = MsgAdapter.ReadInt()
end

-- Boss死亡广播
SCWorldBossDead = SCWorldBossDead or BaseClass(BaseProtocolStruct)

function SCWorldBossDead:__init()
	self.msg_type = 5488

	self.boss_id = 0
end

function SCWorldBossDead:Decode()
	self.boss_id = MsgAdapter.ReadInt()
end

--秘境降魔抓鬼个人信息
SCZhuaguiAddPerInfo = SCZhuaguiAddPerInfo or BaseClass(BaseProtocolStruct)

function SCZhuaguiAddPerInfo:__init()
	self.msg_type = 5489

	self.couple_hunli_add_per = 0
	self.couple_boss_add_per = 0
	self.team_hunli_add_per = 0
	self.team_boss_add_per = 0
end

function SCZhuaguiAddPerInfo:Decode()
	self.couple_hunli_add_per = MsgAdapter.ReadShort()
	self.couple_boss_add_per = MsgAdapter.ReadShort()
	self.team_hunli_add_per = MsgAdapter.ReadShort()
	self.team_boss_add_per = MsgAdapter.ReadShort()
end

---------------------------------------
--副本通用
---------------------------------------
-- 跨服组队本信息
SCCrossTeamFbInfo = SCCrossTeamFbInfo or BaseClass(BaseProtocolStruct)
function SCCrossTeamFbInfo:__init()
	self.msg_type = 5498

	self.user_count = 0
	self.user_info = {}
end

function SCCrossTeamFbInfo:Decode()
	self.user_info = {}
	self.user_count = MsgAdapter.ReadInt()
	for i = 1, self.user_count do
		self.user_info[i] = {}
		self.user_info[i].user_name = MsgAdapter.ReadStrN(32)
		self.user_info[i].dps = MsgAdapter.ReadLL()
	end
end

--副本逻辑同步信息
SCFBSceneLogicInfo = SCFBSceneLogicInfo or BaseClass(BaseProtocolStruct)
function SCFBSceneLogicInfo:__init()
	self.msg_type = 5499

	self.param1 = 0
	self.param2 = 0
	self.param3 = 0
end

function SCFBSceneLogicInfo:Decode()
	self.time_out_stamp = MsgAdapter.ReadUInt()  				--副本超时结束时间戳（可用于倒计时）
	self.flush_timestamp = MsgAdapter.ReadUInt()				--怪物刷新世界戳（倒计时怪物的刷新）
	self.kick_timestamp = MsgAdapter.ReadUInt()					--角色提出副本世界戳（可用于倒计时）

	self.scene_type = MsgAdapter.ReadChar()						--场景类型
	self.is_finish = MsgAdapter.ReadChar()						--是否结束
	self.is_pass = MsgAdapter.ReadChar()						--是否通关
	self.is_active_leave_fb = MsgAdapter.ReadChar()				--是否主动退出

	self.total_boss_num = MsgAdapter.ReadShort()				--boss总数量
	self.total_allmonster_num = MsgAdapter.ReadShort()			--怪物总数量（包括普通怪和boss)
	self.kill_boss_num = MsgAdapter.ReadShort()					--已击杀boss数量
	self.kill_allmonster_num = MsgAdapter.ReadShort()			--已击杀怪物总数量（包括普通怪和boss)

	self.pass_time_s = MsgAdapter.ReadInt()						--进入副本到目前经过的时间（少）
	self.coin = MsgAdapter.ReadInt()							--铜币
	self.exp = MsgAdapter.ReadLL()								--经验

	self.next_change_star_time = MsgAdapter.ReadLL()			--下个星级的时间截
	self.cur_star_level = MsgAdapter.ReadInt()					--当前星级
	self.param3 = MsgAdapter.ReadInt()
end

-- 经验副本所有信息
SCDailyFBRoleInfo = SCDailyFBRoleInfo or BaseClass(BaseProtocolStruct)
function SCDailyFBRoleInfo:__init()
	self.msg_type = 5411
end

function SCDailyFBRoleInfo:Decode()
	self.expfb_today_pay_times = MsgAdapter.ReadShort()  				--今天购买次数
	self.expfb_today_enter_times = MsgAdapter.ReadShort()				--今天进入次数
	self.last_enter_fb_time = MsgAdapter.ReadUInt()						--最后一次进入时间
	self.max_exp = MsgAdapter.ReadLL()									--最大经验
	self.max_wave = MsgAdapter.ReadShort()								--最大波数
	self.expfb_history_enter_times = MsgAdapter.ReadUShort()			--历史进入次数
end

--------------------------------------
--个人塔防
--------------------------------------

-- 个人塔防角色信息
SCTowerDefendRoleInfo = SCTowerDefendRoleInfo or BaseClass(BaseProtocolStruct)
function SCTowerDefendRoleInfo:__init()
	self.msg_type = 5404
	self.join_times = 0
	self.buy_join_times = 0
	self.max_pass_level = 0
	self.auto_fb_free_times = 0
	self.item_buy_join_times = 0
end

function SCTowerDefendRoleInfo:Decode()
	self.join_times = MsgAdapter.ReadChar()
	self.buy_join_times = MsgAdapter.ReadChar()
	self.max_pass_level = MsgAdapter.ReadChar()
	self.auto_fb_free_times = MsgAdapter.ReadChar()
	self.item_buy_join_times = MsgAdapter.ReadShort()
	self.personal_last_level_star = MsgAdapter.ReadShort()
end

-- 个人塔防扫荡奖励返回
SCAutoFBRewardDetail2 = SCAutoFBRewardDetail2 or BaseClass(BaseProtocolStruct)
function SCAutoFBRewardDetail2:__init()
	self.msg_type = 5417
	self.fb_type = 0
	self.reward_coin = 0
	self.reward_exp = 0
	self.reward_xianhun = 0
	self.reward_yuanli = 0
	self.item_list = {}
end

function SCAutoFBRewardDetail2:Decode()
	self.fb_type = MsgAdapter.ReadShort()
	MsgAdapter.ReadShort()
	self.reward_coin = MsgAdapter.ReadInt()
	self.reward_exp = MsgAdapter.ReadInt()
	self.reward_xianhun = MsgAdapter.ReadInt()
	self.reward_yuanli = MsgAdapter.ReadInt()
	local count = MsgAdapter.ReadInt()
	self.item_list = {}
	for i = 1, count do
		self.item_list[i] = {}
		self.item_list[i].item_id = MsgAdapter.ReadUShort()
		self.item_list[i].num = MsgAdapter.ReadShort()
		self.item_list[i].is_bind = MsgAdapter.ReadChar()
		MsgAdapter.ReadChar()
		MsgAdapter.ReadShort()
	end
end

-- 个人塔防购买次数
CSTowerDefendBuyJoinTimes = CSTowerDefendBuyJoinTimes or BaseClass(BaseProtocolStruct)

function CSTowerDefendBuyJoinTimes:__init()
	self.msg_type = 5454
end

function CSTowerDefendBuyJoinTimes:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
end

-- 个人塔防警告
SCTowerDefendWarning = SCTowerDefendWarning or BaseClass(BaseProtocolStruct)
function SCTowerDefendWarning:__init()
	self.msg_type = 5431
	self.warning_type = 0
	self.percent = 0
end

function SCTowerDefendWarning:Decode()
	self.warning_type = MsgAdapter.ReadShort()
	self.percent = MsgAdapter.ReadShort()
end

-- 个人塔防结果
SCTowerDefendResult = SCTowerDefendResult or BaseClass(BaseProtocolStruct)
function SCTowerDefendResult:__init()
	self.msg_type = 5433
	self.is_passed = 0
	self.clear_wave_count = 0
end

function SCTowerDefendResult:Decode()
	self.is_passed = MsgAdapter.ReadChar()
	self.clear_wave_count = MsgAdapter.ReadChar()
	self.use_time = MsgAdapter.ReadShort()
	self.have_pass_reward = MsgAdapter.ReadShort() --// 0 无，帮人打，1 有，有门票
	MsgAdapter.ReadShort()
end

--------------------------组队爬塔
CSEquipFBGetInfo = CSEquipFBGetInfo or BaseClass(BaseProtocolStruct)
function CSEquipFBGetInfo:__init()
	self.msg_type = 5457
	self.is_personal = 0
end

function CSEquipFBGetInfo:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteInt(self.is_personal)
end

SCEquipFBResult = SCEquipFBResult or BaseClass(BaseProtocolStruct)
function SCEquipFBResult:__init()
	self.msg_type = 5409
end

function SCEquipFBResult:Decode()
	self.is_finish = MsgAdapter.ReadChar()			--当前层结束
	self.is_passed = MsgAdapter.ReadChar()			--当前层通关
	self.can_jump = MsgAdapter.ReadChar()			--跳层
	self.is_all_over = MsgAdapter.ReadChar()		--是否全部通关
	self.use_time = MsgAdapter.ReadInt()			--闯过副本时间
	self.have_pass_reward = MsgAdapter.ReadShort()	--// 0 无，帮人打， 1 有，有门票
	self.is_leave = MsgAdapter.ReadChar()
	local item_count = MsgAdapter.ReadChar()
	self.item_list = {}
	for i = 1, item_count do
		self.item_list[i] = {}
		self.item_list[i].item_id = MsgAdapter.ReadUShort()
		self.item_list[i].num = MsgAdapter.ReadShort()
		self.item_list[i].item_color = MsgAdapter.ReadShort()
		MsgAdapter.ReadShort()
	end

end

SCEquipFBTotalPassExp = SCEquipFBTotalPassExp or BaseClass(BaseProtocolStruct)
function SCEquipFBTotalPassExp:__init()
	self.msg_type = 5412
end

function SCEquipFBTotalPassExp:Decode()
	self.total_pass_exp = MsgAdapter.ReadLL()
end

SCEquipFBInfo = SCEquipFBInfo or BaseClass(BaseProtocolStruct)
function SCEquipFBInfo:__init()
	self.msg_type = 5414
end

function SCEquipFBInfo:Decode()
	-- self.is_personal = MsgAdapter.ReadInt()
	self.max_layer_today_entered = MsgAdapter.ReadShort()
	self.flag = MsgAdapter.ReadShort()
	self.mysterylayer_list = {}
	for i = 1, GameEnum.FB_EQUIP_MAX_GOODS_SEQ do
		self.mysterylayer_list[i] = MsgAdapter.ReadChar()
	end
end


