-- 仙盟创建结果
SCCreateGuild = SCCreateGuild or BaseClass(BaseProtocolStruct)
function SCCreateGuild:__init()
	self.msg_type = 9800
end

function SCCreateGuild:Decode()
	self.ret = MsgAdapter.ReadInt()
	self.guild_id = MsgAdapter.ReadInt()
	self.guild_name = MsgAdapter.ReadStrN(32)
end

-- 申请加入仙盟结果
SCApplyForJoinGuild = SCApplyForJoinGuild or BaseClass(BaseProtocolStruct)
function SCApplyForJoinGuild:__init()
	self.msg_type = 9802
end

function SCApplyForJoinGuild:Decode()
	self.guild_id = MsgAdapter.ReadInt()
	self.ret = MsgAdapter.ReadInt()
end

-- 仙盟消息通知
SCNotifyGuildSuper = SCNotifyGuildSuper or BaseClass(BaseProtocolStruct)
function SCNotifyGuildSuper:__init()
	self.msg_type = 9803
end

function SCNotifyGuildSuper:Decode()
	self.notify_type = MsgAdapter.ReadInt()
	self.notify_param = MsgAdapter.ReadInt()
	self.notify_param1 = MsgAdapter.ReadInt()
end

-- 退出仙盟结果
SCQuitGuild = SCQuitGuild or BaseClass(BaseProtocolStruct)
function SCQuitGuild:__init()
	self.msg_type = 9804
end

function SCQuitGuild:Decode()
	self.ret = MsgAdapter.ReadInt()
end

-- 邀请加入军团 返回
SCInviteGuild = SCInviteGuild or BaseClass(BaseProtocolStruct)
function SCInviteGuild:__init()
	self.msg_type = 9805
end

function SCInviteGuild:Decode()
	self.ret = MsgAdapter.ReadInt()
end

-- 邀请加入军团 通知
SCInviteNotify = SCInviteNotify or BaseClass(BaseProtocolStruct)
function SCInviteNotify:__init()
	self.msg_type = 9806
end

function SCInviteNotify:Decode()
	self.guild_id = MsgAdapter.ReadInt()
	self.invite_uid = MsgAdapter.ReadInt()
	self.invite_name = MsgAdapter.ReadStrN(32)
	self.guild_name = MsgAdapter.ReadStrN(32)
end

-- 踢出仙盟结果
SCKickoutGuild = SCKickoutGuild or BaseClass(BaseProtocolStruct)
function SCKickoutGuild:__init()
	self.msg_type = 9807
end

function SCKickoutGuild:Decode()
	self.bekick_uid = MsgAdapter.ReadInt()
	self.ret = MsgAdapter.ReadInt()
end

-- 任命结果返回
SCAppointGuild = SCAppointGuild or BaseClass(BaseProtocolStruct)
function SCAppointGuild:__init()
	self.msg_type = 9809
end

function SCAppointGuild:Decode()
	self.guild_id = MsgAdapter.ReadInt()
	self.beappoint_uid = MsgAdapter.ReadInt()
	self.post = MsgAdapter.ReadInt()
	self.ret = MsgAdapter.ReadInt()
end

-- 修改仙盟公告结果返回
SCChangeNotice = SCChangeNotice or BaseClass(BaseProtocolStruct)
function SCChangeNotice:__init()
	self.msg_type = 9811
end

function SCChangeNotice:Decode()
	self.guild_id = MsgAdapter.ReadInt()
	self.ret = MsgAdapter.ReadInt()
end

-- 邮件发送结果返回
SCGuildMailAll = SCGuildMailAll or BaseClass(BaseProtocolStruct)
function SCGuildMailAll:__init()
	self.msg_type = 9812
end

function SCGuildMailAll:Decode()
	self.guild_id = MsgAdapter.ReadInt()
	self.ret = MsgAdapter.ReadInt()
end

-- 所有仙盟信息列表
SCAllGuildBaseInfo = SCAllGuildBaseInfo or BaseClass(BaseProtocolStruct)
function SCAllGuildBaseInfo:__init()
	self.msg_type = 9813
	self.info_list = {}
end

function SCAllGuildBaseInfo:Decode()
	self.free_create_guild_times = MsgAdapter.ReadInt()
	self.is_first = MsgAdapter.ReadInt()
	local count = MsgAdapter.ReadInt()
	if 1 == self.is_first then
		self.info_list = {}
	end
	for i = 1, count do
		local info_item = ProtocolStruct.ReadAllGuildInfo()
		table.insert(self.info_list, info_item)
	end
	self.count = #self.info_list
end

--申请加入仙盟列表
SCGuildGetApplyForList = SCGuildGetApplyForList or BaseClass(BaseProtocolStruct)
function SCGuildGetApplyForList:__init()
	self.msg_type = 9814
end

function SCGuildGetApplyForList:Decode()
	self.count = MsgAdapter.ReadInt()
	self.apply_list = {}
	for i = 1, self.count do
		local apply_item = ProtocolStruct.ReadGuildApplyItem()
		self.apply_list[i] = apply_item
	end
end

-- 仙盟事件列表
SCGuildEventList = SCGuildEventList or BaseClass(BaseProtocolStruct)
function SCGuildEventList:__init()
	self.msg_type = 9815
end

function SCGuildEventList:Decode()
	self.count = MsgAdapter.ReadInt()
	self.event_list = {}
	for i = 1, self.count do
		local event_item = ProtocolStruct.ReadGuildEventItem()
		self.event_list[i] = event_item
	end
end

-- 仙盟成员列表
SCGuildMemberList = SCGuildMemberList or BaseClass(BaseProtocolStruct)
function SCGuildMemberList:__init()
	self.msg_type = 9816
end

function SCGuildMemberList:Decode()
	self.guild_id = MsgAdapter.ReadInt()
	self.count = MsgAdapter.ReadInt()
	self.member_list = {}
	for i = 1, self.count do
		local member_item = ProtocolStruct.ReadGuildMemberItem()
		self.member_list[i] = member_item
	end
end

-- 仙盟基本信息
SCGuildBaseInfo = SCGuildBaseInfo or BaseClass(BaseProtocolStruct)
function SCGuildBaseInfo:__init()
	self.msg_type = 9817
end

function SCGuildBaseInfo:Decode()
	self.guild_id = MsgAdapter.ReadInt()
	self.guild_name = MsgAdapter.ReadStrN(32)

	self.guild_level = MsgAdapter.ReadInt()
	self.guild_exp = MsgAdapter.ReadInt()
	self.guild_max_exp = MsgAdapter.ReadInt()

	self.totem_level = MsgAdapter.ReadInt()
	self.totem_exp = MsgAdapter.ReadInt()

	self.cur_member_count = MsgAdapter.ReadInt()
	self.max_member_count = MsgAdapter.ReadInt()

	self.tuanzhang_uid = MsgAdapter.ReadInt()
	self.tuanzhang_name = MsgAdapter.ReadStrN(32)
	self.create_time = MsgAdapter.ReadUInt()
	self.camp = MsgAdapter.ReadChar()
	self.vip_level = MsgAdapter.ReadChar()
	self.applyfor_setup = MsgAdapter.ReadUShort()

	self.guild_notice = MsgAdapter.ReadStrN(256)

	self.auto_kickout_setup = MsgAdapter.ReadInt()

	self.applyfor_need_capability = MsgAdapter.ReadInt()
	self.applyfor_need_level = MsgAdapter.ReadInt()
	self.callin_times = MsgAdapter.ReadInt()
	self.my_lucky_color = MsgAdapter.ReadInt()					--运势星星等级
	self.active_degree = MsgAdapter.ReadInt()

	self.total_capability = MsgAdapter.ReadInt()
	self.rank = MsgAdapter.ReadInt()
	self.totem_exp_today = MsgAdapter.ReadInt()
	self.is_auto_clear = MsgAdapter.ReadShort()
	self.avater_changed = MsgAdapter.ReadChar()
	self.is_today_biaoche_start = MsgAdapter.ReadChar()
	self.guild_avatar_key_big = MsgAdapter.ReadUInt()
	self.guild_avatar_key_small = MsgAdapter.ReadUInt()	
	self.guild_total_gongzi = MsgAdapter.ReadInt()
end

-- 回复加入申请通知
SCApplyForJoinGuildAck = SCApplyForJoinGuildAck or BaseClass(BaseProtocolStruct)
function SCApplyForJoinGuildAck:__init()
	self.msg_type = 9819
end

function SCApplyForJoinGuildAck:Decode()
	self.result = MsgAdapter:ReadInt()
	self.guild_id = MsgAdapter.ReadInt()
	self.guild_name = MsgAdapter.ReadStrN(32)
end

-- 军团成员求救通知
SCGuildMemberSos = SCGuildMemberSos or BaseClass(BaseProtocolStruct)
function SCGuildMemberSos:__init()
	self.msg_type = 9821
end

function SCGuildMemberSos:Decode()
	self.sos_type =  MsgAdapter.ReadInt()
	self.member_uid =  MsgAdapter.ReadInt()
	self.member_name =  MsgAdapter.ReadStrN(32)
	self.member_scene_id =  MsgAdapter.ReadInt()
	self.member_pos_x =  MsgAdapter.ReadShort()
	self.member_pos_y =  MsgAdapter.ReadShort()
	self.enemy_uid =  MsgAdapter.ReadInt()
	self.enemy_name =  MsgAdapter.ReadStrN(32)
	self.enemy_camp =  MsgAdapter.ReadInt()
	self.enemy_guild_id =  MsgAdapter.ReadInt()
	self.enemy_guild_name =  MsgAdapter.ReadStrN(32)
end

-- 公会改名
SCGuildResetName = SCGuildResetName or BaseClass(BaseProtocolStruct)
function SCGuildResetName:__init()
	self.msg_type = 9823
end

function SCGuildResetName:Decode()
	self.guild_id =  MsgAdapter.ReadInt()
	self.old_name =  MsgAdapter.ReadStrN(32)
	self.new_name =  MsgAdapter.ReadStrN(32)
end

-- 检查是否能够弹劾盟主结果返回 0 不能 1能
SCGuildCheckCanDelateAck = SCGuildCheckCanDelateAck or BaseClass(BaseProtocolStruct)
function SCGuildCheckCanDelateAck:__init()
	self.msg_type = 9824
end

function SCGuildCheckCanDelateAck:Decode()
	self.can_delate = MsgAdapter:ReadInt()
end

-- 军团操作成功返回
SCGuildOperaSucc = SCGuildOperaSucc or BaseClass(BaseProtocolStruct)
function SCGuildOperaSucc:__init()
	self.msg_type = 9825
end

function SCGuildOperaSucc:Decode()
	self.opera_type = MsgAdapter:ReadShort()
	self.reserve_sh = MsgAdapter:ReadShort()
end

-- 角色的公会信息
SCGuildRoleGuildInfo = SCGuildRoleGuildInfo or BaseClass(BaseProtocolStruct)
function SCGuildRoleGuildInfo:__init()
	self.msg_type = 9826
end

function SCGuildRoleGuildInfo:Decode()
	self.skill_level_list = {}
	self.exchange_t = {}

	self.guild_gongxian = MsgAdapter:ReadInt()

	local reward_flag = MsgAdapter:ReadShort()
	self.territorywar_reward_flag = {}
	local mask_t = bit:d2b(reward_flag)
	for i = 1, 4 do
		self.territorywar_reward_flag[i] = 0 ~= mask_t[33 - i]
	end
	self.territorywar_reward_flag[5] = 0 ~= mask_t[32 - 8]

	self.reserve = MsgAdapter:ReadShort()
	self.daily_guild_gongxian = MsgAdapter:ReadInt()
	self.day_juanxian_gold = MsgAdapter:ReadInt()

	for i = 1, 7 do
		local skill = MsgAdapter.ReadShort()
		self.skill_level_list[i] = skill
	end

	local item_count = MsgAdapter:ReadShort()
	for i = 1,item_count do
		local item_id = MsgAdapter.ReadUShort()
		local item_num = MsgAdapter.ReadShort()
		self.exchange_t[item_id] = item_num
	end
end

-- 公会当前最大成员数量
SCGuildMemberNum = SCGuildMemberNum or BaseClass(BaseProtocolStruct)
function SCGuildMemberNum:__init()
	self.msg_type = 9827
	self.max_guild_member_num = 0
end

function SCGuildMemberNum:Decode()
	self.max_guild_member_num = MsgAdapter.ReadInt()
end

-- 公会迷宫操作请求
CSGuildMazeOperate = CSGuildMazeOperate or BaseClass(BaseProtocolStruct)
function CSGuildMazeOperate:__init()
	self.msg_type = 9831
end

function CSGuildMazeOperate:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteInt(self.operate_type)
	MsgAdapter.WriteInt(self.param1)
	MsgAdapter.WriteInt(self.param2)
end

-- 公会成员迷宫信息
SCGuildMemberMazeInfo = SCGuildMemberMazeInfo or BaseClass(BaseProtocolStruct)
function SCGuildMemberMazeInfo:__init()
	self.msg_type = 9832
end

function SCGuildMemberMazeInfo:Decode()
	self.reason = MsgAdapter.ReadInt()
	self.layer = MsgAdapter.ReadInt()
	self.complete_time = MsgAdapter.ReadUInt()
	self.cd_end_time = MsgAdapter.ReadUInt()
	self.max_layer = MsgAdapter.ReadInt()
end

-- 公会迷宫排行信息
SCGuildMazeRankInfo = SCGuildMazeRankInfo or BaseClass(BaseProtocolStruct)
function SCGuildMazeRankInfo:__init()
	self.msg_type = 9833
end

function SCGuildMazeRankInfo:Decode()
	self.rank_count = MsgAdapter.ReadInt()
	self.rank_list = {}
	for i = 1, self.rank_count do
		self.rank_list[i] = {}
		self.rank_list[i].uid = MsgAdapter.ReadInt()
		self.rank_list[i].user_name = MsgAdapter.ReadStrN(32)
		self.rank_list[i].complete_time = MsgAdapter.ReadUInt()
	end
end

-- 请求公会签到信息
CSGuildSinginReq = CSGuildSinginReq or BaseClass(BaseProtocolStruct)
function CSGuildSinginReq:__init()
	self.msg_type = 9834
end

function CSGuildSinginReq:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteShort(self.req_type)
	MsgAdapter.WriteShort(self.param1)
end

-- 公会签到信息
SCGuildSinginAllInfo = SCGuildSinginAllInfo or BaseClass(BaseProtocolStruct)
function SCGuildSinginAllInfo:__init()
	self.msg_type = 9835
end

function SCGuildSinginAllInfo:Decode()
	self.is_signin_today = MsgAdapter.ReadInt()						-- 今天是否已签到
	self.signin_count_month = MsgAdapter.ReadChar()					-- 月签到次数
	self.guild_signin_fetch_reward_flag = MsgAdapter.ReadChar()		-- 工会总签到
	self.guild_signin_count_today = MsgAdapter.ReadShort()			-- 工会总签到次
end

CSGuildChangeAvatar = CSGuildChangeAvatar or BaseClass(BaseProtocolStruct)
function CSGuildChangeAvatar:__init()
	self.msg_type = 9836

	self.avatar_key_big = 0
	self.avatar_key_small = 0
end

function CSGuildChangeAvatar:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteUInt(self.avatar_key_big)
	MsgAdapter.WriteUInt(self.avatar_key_small)
end

SCGuildSendAppearance = SCGuildSendAppearance or BaseClass(BaseProtocolStruct)
function SCGuildSendAppearance:__init()
	self.msg_type = 9837

	self.obj_id = 0
	self.guild_name = ""
	self.guild_avatar_key_big = 0
	self.guild_avatar_key_small = 0
end

function SCGuildSendAppearance:Decode()
	self.obj_id = MsgAdapter.ReadUShort()
	MsgAdapter.ReadUShort()
	self.guild_name = MsgAdapter.ReadStrN(32)
	self.guild_avatar_key_big = MsgAdapter.ReadUInt()
	self.guild_avatar_key_small = MsgAdapter.ReadUInt()
end

CSBiaoCheOpera = CSBiaoCheOpera or BaseClass(BaseProtocolStruct)
function CSBiaoCheOpera:__init()
	self.msg_type = 9838

	self.opera_type = 0
	self.param_1 = 0
end

function CSBiaoCheOpera:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteUInt(self.opera_type)
	MsgAdapter.WriteUInt(self.param_1)
end