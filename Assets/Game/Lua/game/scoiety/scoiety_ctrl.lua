require("game/scoiety/scoiety_data")
require("game/scoiety/scoiety_view")
require("game/scoiety/near_team_view")
require("game/scoiety/invite_view")
require("game/scoiety/friendrec_view")
require("game/scoiety/quickdel_view")
require("game/scoiety/operate_list")
require("game/scoiety/scoiety_black_view")
require("game/scoiety/friend_list_view")
require("game/scoiety/apply_view")
require("game/scoiety/gift_record_view")

-- 社交
ScoietyCtrl = ScoietyCtrl or BaseClass(BaseController)
function ScoietyCtrl:__init()
	if ScoietyCtrl.Instance then
		print_error("[ScoietyCtrl] Attemp to create a singleton twice !")
	end
	ScoietyCtrl.Instance = self

	self.send_team_invite_interval = 30					--发送世界组队邀请间隔时间（创建队伍时使用的）
	self.last_send_team_time = 0						--最后发送邀请时间

	self.wait_opera_role_name = ""

	self.scoiety_data = ScoietyData.New()
	self.scoiety_view = ScoietyView.New(ViewName.Scoiety)

	-- 附近队伍弹窗
	self.near_team_view = NearTeamView.New(ViewName.NearTeamView)

	-- 邀请弹窗
	self.invite_view = InviteView.New(ViewName.InviteView)

	-- 批量添加
	self.friendrandom_view = FriendRandomView.New(ViewName.FriendRec)

	-- 批量删除
	self.delete_view = QuickDelView.New(ViewName.FriendDeleteView)

	-- 请求列表
	self.apply_view = ApplyView.New(ViewName.ApplyView)

	-- 列表详情
	self.operate_list = OperateListView.New(ViewName.OperateList)

	-- 黑名单
	self.scoiety_black_view = ScoietyBlackView.New(ViewName.BlackView)

	-- 好友列表
	self.friend_list_view = FriendListView.New(ViewName.FriendListView)

	--收礼记录
	self.gift_record_view = GiftRecordView.New(ViewName.GiftRecord)

	self:RegisterAllProtocols()
	self.friend_request = GlobalEventSystem:Bind(SettingEventType.FRIEND_REQUEST, BindTool.Bind(self.ChangeFriendRequest, self))
	self.connect_login_server = GlobalEventSystem:Bind(LoginEventType.LOGIN_SERVER_CONNECTED, BindTool.Bind(self.OnConnectLoginServer, self))
	self.enter_game_server_succ = GlobalEventSystem:Bind(LoginEventType.ENTER_GAME_SERVER_SUCC, BindTool.Bind(self.EnterGameServerSucc, self))
	self.mainui_open = GlobalEventSystem:Bind(MainUIEventType.MAINUI_OPEN_COMLETE, BindTool.Bind(self.MainuiOpen, self))
	--玩家上下线通知
	self.role_online = GlobalEventSystem:Bind(OtherEventType.ROLE_ONLINE_CHANGE, BindTool.Bind(self.RoleOnLineChange, self))

	self.role_name_info = GlobalEventSystem:Bind(OtherEventType.ROLE_NAME_INFO, BindTool.Bind(self.RoleNameInfoReturn, self))

	-- self:BindGlobalEvent(OtherEventType.RoleInfo, BindTool.Bind(self.SetRoleInfo, self))
	--玩家等级改变
	self.paly_listen_callback = BindTool.Bind(self.RoleDataChange, self)
	PlayerData.Instance:ListenerAttrChange(self.paly_listen_callback)
end

function ScoietyCtrl:__delete()
	ScoietyCtrl.Instance = nil

	if self.scoiety_view then
		--self.scoiety_view:DeleteMe()
		self.scoiety_view = nil
	end

	if self.scoiety_data then
		self.scoiety_data:DeleteMe()
		self.scoiety_data = nil
	end

	if self.near_team_view then
		self.near_team_view:DeleteMe()
		self.near_team_view = nil
	end

	if self.invite_view then
		self.invite_view:DeleteMe()
		self.invite_view = nil
	end

	if self.friendrandom_view then
		self.friendrandom_view:DeleteMe()
		self.friendrandom_view = nil
	end

	if self.delete_view then
		self.delete_view:DeleteMe()
		self.delete_view = nil
	end

	if self.apply_view then
		self.apply_view:DeleteMe()
		self.apply_view = nil
	end

	if self.operate_list then
		self.operate_list:DeleteMe()
		self.operate_list = nil
	end

	if self.scoiety_black_view then
		self.scoiety_black_view:DeleteMe()
		self.scoiety_black_view = nil
	end

	if self.friend_list_view then
		self.friend_list_view:DeleteMe()
		self.friend_list_view = nil
	end

	if self.gift_record_view then
		self.gift_record_view:DeleteMe()
		self.gift_record_view = nil
	end

	if self.friend_request then
		GlobalEventSystem:UnBind(self.friend_request)
		self.friend_request = nil
	end

	if self.connect_login_server then
		GlobalEventSystem:UnBind(self.connect_login_server)
		self.connect_login_server = nil
	end

	if self.enter_game_server_succ then
		GlobalEventSystem:UnBind(self.enter_game_server_succ)
		self.enter_game_server_succ = nil
	end

	if self.mainui_open then
		GlobalEventSystem:UnBind(self.mainui_open)
		self.mainui_open = nil
	end

	if self.role_online then
		GlobalEventSystem:UnBind(self.role_online)
		self.role_online = nil
	end

	if self.role_name_info then
		GlobalEventSystem:UnBind(self.role_name_info)
		self.role_name_info = nil
	end

	if self.paly_listen_callback then
		PlayerData.Instance:UnlistenerAttrChange(self.paly_listen_callback)
		self.paly_listen_callback = nil
	end
end
function ScoietyCtrl:RegisterAllProtocols()
	--组队
	self:RegisterProtocol(CSCreateTeam)					--玩家申请创建队伍
	self:RegisterProtocol(CSInviteUser)					--邀请加入队伍
	self:RegisterProtocol(CSInviteUserTransmitRet)		--回复邀请
	self:RegisterProtocol(CSReqJoinTeamRet)				--队长回复申请加入队伍审核
	self:RegisterProtocol(CSReqJoinTeam)				--玩家申请加入某队伍
	self:RegisterProtocol(CSKickOutOfTeam)				--踢出队友
	self:RegisterProtocol(CSChangeTeamLeader)			--换队长
	self:RegisterProtocol(CSExitTeam)					--玩家退出队伍
	self:RegisterProtocol(CSTeamListReq)				--请求附近队伍
	self:RegisterProtocol(CSChangeMustCheck)			--改变队伍加入是否是要队长通过
	self:RegisterProtocol(CSChangeAssignMode)			--改变队伍分配模式
	self:RegisterProtocol(CSChangeMemberCanInvite)		--改变队伍是否普通队员可邀请
	self:RegisterProtocol(CSChangeTeamLimit)			--改变队伍限制条件
	self:RegisterProtocol(CSAutoHaveTeam)				--快速组队
	self:RegisterProtocol(CSAutoApplyJoinTeam)			--自动答应加入队伍
	self:RegisterProtocol(CSOfflineFriendAutoDecFlag)	--自动清除3天不在线好友
	self:RegisterProtocol(CSInviteUniqueUser)			--邀请跨服唯一角色入队

	self:RegisterProtocol(SCTeamInfo, "OnTeamInfo")							--发送队伍信息给玩家
	self:RegisterProtocol(SCOutOfTeam, "OnOutOfTeam")						--通知队员离开了队伍
	self:RegisterProtocol(SCInviteUserTransmit, "OnInviteUserTransmit")		--通知被邀请
	self:RegisterProtocol(SCReqJoinTeamTransmit, "OnReqJoinTeamTransmit")	--通知队长有人申请加入队伍
	self:RegisterProtocol(SCTeamListAck, "OnTeamListAck")					--请求所在场景队伍列表回复
	self:RegisterProtocol(SCJoinTeam, "OnJoinTeam")							--通知玩家加入了队伍
	self:RegisterProtocol(SCRoleTeamInfo, "OnRoleTeamInfo")					--角色相关的队伍信息
	self:RegisterProtocol(SCTeamRollDropRet, "OnTeamRollDropRet")			--组队掉落摇点
	self:RegisterProtocol(SCTeamLeaderChange, "OnTeamLeaderChange")			--通知队长发生变更

	--好友
	self:RegisterProtocol(CSFriendInfoReq)			--请求好友列表
	self:RegisterProtocol(CSAddFriendReq)			--请求添加好友
	self:RegisterProtocol(CSAddFriendRet)			--是否接受加好友
	self:RegisterProtocol(CSDeleteFriend)			--发送删除好友请求
	self:RegisterProtocol(CSAddBlackReq)			--添加到黑名单
	self:RegisterProtocol(CSDeleteBlackReq)			--删除黑名单
	self:RegisterProtocol(CSGetRandomRoleList)		--请求随机在线玩家列表
	self:RegisterProtocol(CSFriendSongGift)			--送礼请求
	-- self:RegisterProtocol(CSFriendGiftAllInfoReq)	--收礼记录请求

	self:RegisterProtocol(SCFriendInfoAck, "OnFriendInfoAck")					--接收好友列表
	self:RegisterProtocol(SCAddFriendRoute, "OnAddFriendRoute")					--好友请求
	self:RegisterProtocol(SCChangeFriend, "OnChangeFriend")						--接收好友改变
	self:RegisterProtocol(SCAddFriendRet, "OnAddFriendRet")						--接收对方是否同意添加好友请求
	self:RegisterProtocol(SCChangeBlacklist, "OnChangeBlacklist")				--服务器通知客户端黑名单改变
	self:RegisterProtocol(SCBlacklistsACK, "OnBlacklistsACK")					--返回黑名单
	self:RegisterProtocol(SCRandomRoleListRet, "OnRandomRoleListRet")			--返回随机在线玩家列表
	self:RegisterProtocol(SCFriendGiftAllInfo, "OnFriendGiftAllInfo")			--返回收礼记录
	self:RegisterProtocol(SCFriendGiftShouNotice, "OnSCFriendGiftShouNotice")	--收到礼物的提示

	--仇人
	self:RegisterProtocol(CSEnemyDelete)		--请求删除仇人

	self:RegisterProtocol(SCEnemyListACK, "OnEnemyListACK")		--返回仇人列表
	self:RegisterProtocol(SCChangeEnemy, "OnChangeEnemy")		--服务器通知客户端仇人改变

	--邮件
	self:RegisterProtocol(CSMailSend)					--发送邮件
	self:RegisterProtocol(CSMailDelete)					--删除邮件
	self:RegisterProtocol(CSMailGetList)				--获取邮件列表
	self:RegisterProtocol(CSMailRead)					--读取邮件
	self:RegisterProtocol(CSMailFetchAttachment)		--获取附件
	self:RegisterProtocol(CSMailClean)					--清空邮件
	self:RegisterProtocol(CSMailOneKeyFetchAttachment)	--一键提取附件

	self:RegisterProtocol(SCMailSendAck, "OnMailSendAck")				--发邮件返回
	self:RegisterProtocol(SCMailDeleteAck, "OnMailDeleteAck")			--删除邮件返回
	self:RegisterProtocol(SCMailLockAck, "OnMailLockAck")				--锁邮件返回
	self:RegisterProtocol(SCMailUnlockAck, "OnMailUnlockAck")			--解锁邮件返回
	self:RegisterProtocol(SCMailListAck, "OnMailListAck")				--邮件列表返回
	self:RegisterProtocol(SCMailDetailAck, "OnMailDetailAck")			--邮件详细信息
	self:RegisterProtocol(SCFetchAttachmentAck, "OnFetchAttachmentAck")	--提取邮件附件返回
	self:RegisterProtocol(SCRecvNewMail, "OnRecvNewMail")				--新邮件通知
	self:RegisterProtocol(SCHasUnReadMail, "OnHasUnReadMail")			--上线时有未读邮件通知
end

function ScoietyCtrl:RoleDataChange(key, new_value, old_value)
	if key == "level" then
		if (new_value >= 130 and old_value < 130) or (new_value >= 155 and old_value < 155) then
			self.scoiety_data:SetShowOneKeyRemind(true)
			RemindManager.Instance:Fire(RemindName.ScoietyOneKeyFriend)
		end
	end
end

--组队协议返回begin-----------------------
function ScoietyCtrl:OnTeamInfo(protocol)
	self.scoiety_data:SetTeamInfo(protocol)
	--判断之前是否有队伍
	-- local team_state = self.scoiety_data:GetTeamState()
	self.scoiety_data:SetTeamState(true)
	-- if not team_state then
		--之前不存在队伍

		local team_index_list = self.scoiety_data:GetReqTeamIndexList()
		local req_team_type = team_index_list[protocol.team_index]
		if req_team_type == ScoietyData.InviteOpenType.ManyFuBen then
			ViewManager.Instance:Open(ViewName.FuBen, TabIndex.fb_many_people)
		elseif req_team_type == ScoietyData.InviteOpenType.ExpFuBen then
			ViewManager.Instance:Open(ViewName.FuBen, TabIndex.fb_exp)
		elseif req_team_type == ScoietyData.InviteOpenType.EquipTeamFbNew then
			FuBenData.Instance:SetDefaultChoose(ScoietyData.InviteOpenType.EquipTeamFbNew)
			ViewManager.Instance:Open(ViewName.FuBen, TabIndex.fb_team_tower)
		elseif req_team_type == ScoietyData.InviteOpenType.TeamTowerDefend then
			FuBenData.Instance:SetDefaultChoose(ScoietyData.InviteOpenType.TeamTowerDefend)
			ViewManager.Instance:Open(ViewName.FuBen, TabIndex.fb_team_tower)
		end

		--添加聊天对象
		ChatData.Instance:AddNormalChatList({role_id = SPECIAL_CHAT_ID.TEAM})
		GlobalEventSystem:Fire(ChatEventType.SPECIAL_CHAT_TARGET_CHANGE, SPECIAL_CHAT_ID.TEAM, true)
	-- end
	self.scoiety_data:ClearReqTeamIndexList()
	if protocol.team_type == FuBenTeamType.TEAM_TYPE_EQUIP_TEAM_FB or protocol.team_type == FuBenTeamType.TEAM_TYPE_TEAM_TOWERDEFEND then
		self:TeamJoinFlag()
	end
	if protocol.team_type == FuBenTeamType.TEAM_TYPE_TEAM_DAILY_FB then
		self:ExpTeamJoinFlag()
	end


	if ViewManager.Instance:IsOpen(ViewName.ChatGuild) then
		ViewManager.Instance:FlushView(ViewName.ChatGuild, "flush_team_view")
	end

	if ViewManager.Instance:IsOpen(ViewName.KuaFu3v3) then
		ViewManager.Instance:FlushView(ViewName.KuaFu3v3, "MainPanel")
	end

	local is_send_zhuagui_invite = ActivityData.Instance:IsSendZhuaGuiInvite()
	if is_send_zhuagui_invite then
		---[[秘境降魔特殊处理
		ActivityData.Instance:SetSendZhuaGuiInvite(false)

		local main_role_id = GameVoManager.Instance:GetMainRoleVo().role_id
		if self.scoiety_data:IsLeaderById(main_role_id) then
			local team_index = self.scoiety_data:GetTeamIndex()
			local act_info = ActivityData.Instance:GetClockActivityByID(ACTIVITY_TYPE.ZHUAGUI)
			local invite_str = string.format(Language.Society.ZhuaGuiTeamInvite, team_index, act_info.min_level or 0, "")
			ChatCtrl.SendChannelChat(CHANNEL_TYPE.WORLD, invite_str, CHAT_CONTENT_TYPE.TEXT)
			SysMsgCtrl.Instance:ErrorRemind(Language.Society.WorldInvite)
		end
		--]]
	else
		--判断能否发送世界邀请
		if not IS_ON_CROSSSERVER and self.can_send_world_chat and (Status.NowTime - self.send_team_invite_interval > self.last_send_team_time) then
			self.last_send_team_time = Status.NowTime
			local team_index = self.scoiety_data:GetTeamIndex()
			local invite_str = string.format(Language.Society.SomeOneTeamInvite, team_index, 0, "")
			ChatCtrl.SendChannelChat(CHANNEL_TYPE.WORLD, invite_str, CHAT_CONTENT_TYPE.TEXT)
			SysMsgCtrl.Instance:ErrorRemind(Language.Society.WorldInvite)
		end
		self.can_send_world_chat = false
	end

	if self.scoiety_view:IsOpen() then
		self.scoiety_view:Flush("team")
	end

	self:BossFightViewFlush()

	ViewManager.Instance:FlushView(ViewName.TipsEnterFbView)

	local member_count = self.scoiety_data.member_count or 0
	--如果已满关闭申请界面
	if member_count >= 4 then
		if self.apply_view:IsOpen() and self.apply_view.open_type == APPLY_OPEN_TYPE.TEAM then
			self.apply_view:Close()
		end
		MainUICtrl.Instance:FlushTipsIcon(MainUIViewChat.IconList.JOIN_REQ, false)
	end
	MainUICtrl.Instance:FlushView("team_list")
	ViewManager.Instance:FlushView(ViewName.TombExploreFBView, "flush_team")
	local fu_ben_view = FuBenCtrl.Instance:GetFuBenView()
	if fu_ben_view:IsOpen() then
		fu_ben_view:Flush("exp")
		fu_ben_view:Flush("team")
	end
	local cross_button_view = FuBenCtrl.Instance:GetCrossButtonView()
	if cross_button_view:IsOpen() then
		cross_button_view:Flush()
	end
	FuBenCtrl.Instance:FlushManyPeopleView()
	if member_count == protocol.member_count then
		return
	end
	self.scoiety_data:SetMenberCount(protocol.member_count)
end

function ScoietyCtrl:TeamJoinFlag()
	local info = ScoietyData.Instance:GetTeamInfo()
	local is_show = FuBenData.Instance:GetTeamJoinFlag()
	if #info.team_member_list == 3 and is_show and ScoietyData.Instance:IsLeaderById(GameVoManager.Instance:GetMainRoleVo().role_id) then
		FuBenData.Instance:SetTeamJoinFlag(false)
		local is_online = true
		for k,v in pairs(info.team_member_list) do
			if v.is_online == 0 then
				is_online = false
			end
		end
		if not is_online then
			return SysMsgCtrl.Instance:ErrorRemind(Language.FuBen.NotOnlieEnterFuben)
		else
			self:OnClickTeamEnter()
		end
	elseif #info.team_member_list < 3 and not is_show then
		FuBenData.Instance:SetTeamJoinFlag(true)
	end
end

function ScoietyCtrl:ExpTeamJoinFlag()
	local info = ScoietyData.Instance:GetTeamInfo()
	local is_show = FuBenData.Instance:GetExpTeamJoinFlag()
	if #info.team_member_list == 3 and is_show and ScoietyData.Instance:IsLeaderById(GameVoManager.Instance:GetMainRoleVo().role_id) then
		FuBenData.Instance:SetExpTeamJoinFlag(false)
		local is_online = true
		for k,v in pairs(info.team_member_list) do
			if v.is_online == 0 then
				is_online = false
			end
		end
		if not is_online then
			return SysMsgCtrl.Instance:ErrorRemind(Language.FuBen.NotOnlieEnterFuben)
		else
			self:OnClickExpTeamEnter()
		end
	elseif #info.team_member_list < 3 and not is_show then
		FuBenData.Instance:SetExpTeamJoinFlag(true)
	end
end

function ScoietyCtrl:OnClickExpTeamEnter()
	local info = ScoietyData.Instance:GetTeamInfo()
	local open_level = FuBenData.Instance:GetExpOpenLevel()
	if info and info.team_member_list and open_level then
		for k,v in pairs(info.team_member_list) do
			if v and v.level < open_level then
				return SysMsgCtrl.Instance:ErrorRemind(Language.FuBen.NotEnterFuBen)
			end
		end
	end
	local exp_fb_info = FuBenData.Instance:GetExpFBInfo()
	local item_id = FuBenData.Instance:GetExpFBOtherCfg().item_stuff.item_id
	local item_num = FuBenData.Instance:GetBagRewardNum()
	local func = function(item_id2, item_num, is_bind, is_use, is_buy_quick)
			MarketCtrl.Instance:SendShopBuy(item_id2, item_num, is_bind, is_use)
		end
	if item_num == 0 and exp_fb_info.expfb_history_enter_times > 0 then
		TipsCtrl.Instance:ShowCommonBuyView(func, item_id, nil, 1)
		return
	end
	FuBenCtrl.Instance:SendTeamFbRoomOperateReq(TeamFuBenOperateType.START_ROOM)
end

function ScoietyCtrl:OnClickTeamEnter()
	local cur_choose = FuBenData.Instance:GetDefaultChoose()
	local info = ScoietyData.Instance:GetTeamInfo()
	local open_list = FuBenData.Instance:GetOpenList()
	if info and info.team_member_list and open_list then
		for k,v in pairs(info.team_member_list) do
			if v and v.level < open_list[cur_choose] then
				return SysMsgCtrl.Instance:ErrorRemind(Language.FuBen.NotEnterFuBen)
			end
		end
	end
	if Scene.Instance:GetSceneType() ~= SceneType.Common then
		return SysMsgCtrl.Instance:ErrorRemind(Language.Map.DontEnterFBTwo)
	end
	ViewManager.Instance:CloseAll()
	FuBenCtrl.Instance:SendTeamFbRoomOperateReq(TeamFuBenOperateType.START_ROOM)

end


function ScoietyCtrl:OnOutOfTeam(protocol)
	local main_role = Scene.Instance:GetMainRole()
	if protocol.user_id == main_role:GetRoleId() then
		self.scoiety_data:SetMenberCount(0)
		self.scoiety_data:OutOfTeamInfo(protocol)
		ChatData.Instance:ClearTeamUnreadMsg()
		--移除聊天对象
		ChatData.Instance:RemoveNormalChatList(SPECIAL_CHAT_ID.TEAM)
		GlobalEventSystem:Fire(ChatEventType.SPECIAL_CHAT_TARGET_CHANGE, SPECIAL_CHAT_ID.TEAM, false)
	else
		self.scoiety_data:RemoveRoleVo(protocol.user_id)
	end
	MainUICtrl.Instance:FlushView("team_list")
	ViewManager.Instance:FlushView(ViewName.TombExploreFBView, "flush_team")
	local fu_ben_view = FuBenCtrl.Instance:GetFuBenView()
	if fu_ben_view:IsOpen() then
		fu_ben_view:Flush("exp")
		fu_ben_view:Flush("team")
	end
	FuBenCtrl.Instance:FlushManyPeopleView()

	if self.scoiety_view:IsOpen() then
		self.scoiety_view:Flush("team")
	end

	if ViewManager.Instance:IsOpen(ViewName.ChatGuild) then
		ViewManager.Instance:FlushView(ViewName.ChatGuild, "flush_team_view")
	end

	if ViewManager.Instance:IsOpen(ViewName.KuaFu3v3) then
		ViewManager.Instance:FlushView(ViewName.KuaFu3v3, "MainPanel")
	end

	local cross_button_view = FuBenCtrl.Instance:GetCrossButtonView()
	if cross_button_view:IsOpen() then
		cross_button_view:Flush()
	end
	self:BossFightViewFlush()

	FuBenCtrl.Instance:FlushManyPeopleView()

	local is_kf_pvp_open = ActivityData.Instance:GetActivityIsOpen(ACTIVITY_TYPE.KF_PVP)
	if is_kf_pvp_open then
		KuafuPVPCtrl.Instance:SendCrossMultiuserChallengeGetBaseSelfSideInfo()
	end
end

function ScoietyCtrl:OnInviteUserTransmit(protocol)
	if not self.scoiety_data:IsBlack(protocol.inviter) then
		self.scoiety_data:AddInviteInfo(protocol)
		MainUICtrl.Instance:FlushTipsIcon(MainUIViewChat.IconList.TEAM_REQ, true)
	end
end

function ScoietyCtrl:OnReqJoinTeamTransmit(protocol)
	self.scoiety_data:AddJoinTeamInfo(protocol)
	MainUICtrl.Instance:FlushTipsIcon(MainUIViewChat.IconList.JOIN_REQ, true)
end

function ScoietyCtrl:OnTeamListAck(protocol)
	self.scoiety_data:SetTeamListAck(protocol)
	self.near_team_view:Flush()
end

function ScoietyCtrl:OnJoinTeam(protocol)
	local main_role = Scene.Instance:GetMainRole()
	local name = protocol.user_name
	if protocol.user_id == main_role:GetRoleId() then
		name = Language.Society.You
	end
	MainUICtrl.Instance:FlushTipsIcon(MainUIViewChat.IconList.JOIN_REQ, false)
	SysMsgCtrl.Instance:ErrorRemind(string.format(Language.Society.JoinTeam, name))
	if ScoietyCtrl.Instance.near_team_view:IsOpen() then
		ScoietyCtrl.Instance.near_team_view:Close()
	end

	local is_kf_pvp_open = ActivityData.Instance:GetActivityIsOpen(ACTIVITY_TYPE.KF_PVP)
	if is_kf_pvp_open then
		KuafuPVPCtrl.Instance:SendCrossMultiuserChallengeGetBaseSelfSideInfo()
	end

	if ViewManager.Instance:IsOpen(ViewName.KuaFu3v3) then
		ViewManager.Instance:FlushView(ViewName.KuaFu3v3, "MainPanel")
	end
end

function ScoietyCtrl:OnRoleTeamInfo(protocol)
	self.scoiety_data:SetIsAutoJoinTeam(protocol.is_auto_apply_join_team)
	local fu_ben_view = FuBenCtrl.Instance:GetFuBenView()
	if fu_ben_view:IsOpen() then
		fu_ben_view:Flush("exp")
		fu_ben_view:Flush("team")
	end
	if ViewManager.Instance:IsOpen(ViewName.KuaFu3v3) then
		ViewManager.Instance:FlushView(ViewName.KuaFu3v3, "MainPanel")
	end
end

function ScoietyCtrl:OnTeamRollDropRet(protocol)
	print("组队掉落摇点")
end

function ScoietyCtrl:OnTeamLeaderChange(protocol)
	local des = string.format(Language.Society.LeaderChangeDes, protocol.user_name)
	SysMsgCtrl.Instance:ErrorRemind(des)

	if ViewManager.Instance:IsOpen(ViewName.KuaFu3v3) then
		ViewManager.Instance:FlushView(ViewName.KuaFu3v3, "MainPanel")
	end
end
--组队协议返回end-----------------------

--好友协议返回begin--------------------------
function ScoietyCtrl:OnFriendInfoAck(protocol)
	local friend_list = protocol.friend_list or {}
	for k, v in ipairs(friend_list) do
		--记录头像参数
		AvatarManager.Instance:SetAvatarKey(v.user_id, v.avatar_key_big, v.avatar_key_small)
	end

	self.scoiety_data:SetFriendInfo(protocol)

	if self.scoiety_view:IsOpen() then
		self.scoiety_view:Flush("friend")
	end

	if self.friend_list_view:IsOpen() then
		self.friend_list_view:Flush()
	end

	GlobalEventSystem:Fire(OtherEventType.FRIEND_INFO_CHANGE)
	RemindManager.Instance:Fire(RemindName.ScoietyOtherFriend)

end

function ScoietyCtrl:OnAddFriendRoute(protocol)
	--记录头像参数
	AvatarManager.Instance:SetAvatarKey(protocol.req_user_id, protocol.avatar_key_big, protocol.avatar_key_small)

	if self.scoiety_data:GetAddFriendState() then
		local param_t = {}
		param_t.req_user_id = protocol.req_user_id
		param_t.req_gamename = protocol.req_gamename
		param_t.is_accept = 0
		param_t.req_sex = protocol.req_sex
		param_t.req_prof = protocol.req_prof

		self:AddFriendRet(param_t)
		return
	end
	self.scoiety_data:SetFriendRoute(protocol)
	self.scoiety_data:AddFirendApplyList(protocol)
	self.scoiety_data:SetFriendRectFlag(true)
	MainUICtrl.Instance:FlushTipsIcon(MainUIViewChat.IconList.FRIEND_REC, true)
	-- MainUICtrl.Instance:FlushTipsIcon(MainUIViewChat.IconList.FRIEND_REC, true)
end

function ScoietyCtrl:OnChangeFriend(protocol)
	local friend_info = protocol.friend_info
	--记录头像参数
	if protocol.changestate == 0 then			--0是添加1是删除
		AvatarManager.Instance:SetAvatarKey(friend_info.user_id, friend_info.avatar_key_big, friend_info.avatar_key_small)
	end
	self.scoiety_data:ChangeFriendInfo(protocol)

	if self.scoiety_view:IsOpen() then
		self.scoiety_view:Flush("friend")
	end

	if self.friend_list_view:IsOpen() then
		self.friend_list_view:Flush()
	end
	ChatCtrl.Instance:FulsHaoGanDu()
	RemindManager.Instance:Fire(RemindName.ScoietyOtherFriend)
	GlobalEventSystem:Fire(OtherEventType.FRIEND_INFO_CHANGE, friend_info.user_id)
end

function ScoietyCtrl:OnAddFriendRet(protocol)
	print("接收对方是否同意添加好友请求")
end

function ScoietyCtrl:OnChangeBlacklist(protocol)
	--记录头像参数
	if protocol.changestate == 0 then --0 update 1 del
		AvatarManager.Instance:SetAvatarKey(protocol.user_id, protocol.avatar_key_big, protocol.avatar_key_small)
	end

	self.scoiety_data:ChangeBlackList(protocol)
	self.scoiety_black_view:Flush()

	--刷新聊天数据
	ChatData.Instance:DelChannelList()
	ChatData.Instance:RemovePrivateObjIsBlack()
	ChatCtrl.Instance.view:Flush()

	GlobalEventSystem:Fire(OtherEventType.BLACK_LIST_CHANGE, protocol.user_id)
end

function ScoietyCtrl:OnBlacklistsACK(protocol)
	local blacklist = protocol.blacklist or {}
	--记录头像参数
	for k, v in ipairs(blacklist) do
		AvatarManager.Instance:SetAvatarKey(v.user_id, v.avatar_key_big, v.avatar_key_small)
	end

	self.scoiety_data:SetBlackList(protocol)
	self.scoiety_black_view:Flush()
end

function ScoietyCtrl:OnRandomRoleListRet(protocol)
	local auto_addfriend_list = protocol.auto_addfriend_list or {}
	--记录头像参数
	for k, v in ipairs(auto_addfriend_list) do
		AvatarManager.Instance:SetAvatarKey(v.user_id, v.avatar_key_big, v.avatar_key_small)
	end

	self.scoiety_data:SetRandomRoleList(protocol)
	if self.friendrandom_view:IsOpen() then
		self.friendrandom_view:Flush()
	end
end

function ScoietyCtrl:OnFriendGiftAllInfo(protocol)
	self.scoiety_data:SetSendGiftTimes(protocol.song_gift_count)
	self.scoiety_data:SetGetGiftTimes(protocol.shou_gift_count)
	self.scoiety_data:SetGiftRecordList(protocol.gift_record_list)

	if self.gift_record_view:IsOpen() then
		self.gift_record_view:Flush()
	end
end

function ScoietyCtrl:OnSCFriendGiftShouNotice()
	MainUICtrl.Instance:FlushTipsIcon(MainUIViewChat.IconList.GIFT_BTN, true)
end
--好友协议返回end--------------------------

function ScoietyCtrl:SetScoietyViewFlush()
	if self.scoiety_view:IsOpen() then
		self.scoiety_view:Flush("enemy")
	end
end

-- function ScoietyCtrl:SetRoleInfo(role_id, role_info)
-- 	self.scoiety_data:SetEnemyListData(role_info)
-- end

--仇人协议返回begin------------------------
function ScoietyCtrl:OnEnemyListACK(protocol)
	local enemy_list = protocol.enemy_list or {}
	self.scoiety_data:SetEnemyList(protocol)
	--记录头像参数
	for k, v in ipairs(enemy_list) do
		-- CheckCtrl.Instance:SendCrossQueryRoleInfo(v.plat_type, v.user_id)

		PlayerCtrl.Instance:SendFindRoleByUUID(v.plat_type, v.user_id, 1)
	end
end

function ScoietyCtrl:OnChangeEnemy(protocol)
	self.scoiety_data:ChangeEnemyList(protocol)
	if protocol.changestate == 0 then			--0是添加1是删除
		--记录头像参数
		local enemy_info = protocol.enemy_info or {}
		-- CheckCtrl.Instance:SendCrossQueryRoleInfo(enemy_info.plat_type, enemy_info.user_id)
		PlayerCtrl.Instance:SendFindRoleByUUID(enemy_info.plat_type, enemy_info.user_id, 1)
	end
end
--仇人协议返回end------------------------

--邮件协议返回begin------------------------
function ScoietyCtrl:OnMailSendAck(protocol)
	if protocol.ret == 0 then
		SysMsgCtrl.Instance:ErrorRemind(Language.Society.MailSendSuccess)
	end
end

function ScoietyCtrl:OnMailDeleteAck(protocol)
	if protocol.ret == 0 then
		self.scoiety_data:DelMailInfo(protocol.mail_index)
		if self.scoiety_view:IsOpen() then
			self.scoiety_view:Flush("mail_all")
		end
	end
end

function ScoietyCtrl:OnMailLockAck(protocol)
	print("锁邮件返回")
end

function ScoietyCtrl:OnMailUnlockAck(protocol)
	print("解锁邮件返回")
end

function ScoietyCtrl:OnMailListAck(protocol)
	self.scoiety_data:SetMailList(protocol)

	local state = self.scoiety_data:IsAllRead() and self.scoiety_data:IsAllGet()

	MainUICtrl.Instance:FlushTipsIcon(MainUIViewChat.IconList.MAIL_REC, not state)
	-- MainUICtrl.Instance:FlushTipsIcon(MainUIViewChat.IconList.MAIL_REC, not state)

	self.scoiety_data:ChangeMailState(not state)

	if self.scoiety_view:IsOpen() then
		self.scoiety_view:Flush("mail_all")
	end

	RemindManager.Instance:Fire(RemindName.ScoietyMail)
end

function ScoietyCtrl:OnMailDetailAck(protocol)
	self.scoiety_data:SetMailDetail(protocol)

	local state = self.scoiety_data:IsAllRead() and self.scoiety_data:IsAllGet()
	MainUICtrl.Instance:FlushTipsIcon(MainUIViewChat.IconList.MAIL_REC, not state)
	-- MainUICtrl.Instance:FlushTipsIcon(MainUIViewChat.IconList.MAIL_REC, not state)
	self.scoiety_data:ChangeMailState(not state)

	if self.scoiety_view:IsOpen() then
		self.scoiety_view:Flush("mail_right")
	end

	RemindManager.Instance:Fire(RemindName.ScoietyMail)
end

function ScoietyCtrl:OnFetchAttachmentAck(protocol)
	self.scoiety_data:ChangeMailList(protocol)
	local state = self.scoiety_data:IsAllRead() and self.scoiety_data:IsAllGet()
	MainUICtrl.Instance:FlushTipsIcon(MainUIViewChat.IconList.MAIL_REC, not state)
	-- MainUICtrl.Instance:FlushTipsIcon(MainUIViewChat.IconList.MAIL_REC, not state)
	self.scoiety_data:ChangeMailState(not state)

	if self.scoiety_view:IsOpen() then
		self.scoiety_view:Flush("mail_fetch")
	end

	RemindManager.Instance:Fire(RemindName.ScoietyMail)
end

function ScoietyCtrl:OnRecvNewMail(protocol)
	self.scoiety_data:AddMailInfo(protocol.mail_brief)
	MainUICtrl.Instance:FlushTipsIcon(MainUIViewChat.IconList.MAIL_REC, true)
	-- MainUICtrl.Instance:FlushTipsIcon(MainUIViewChat.IconList.MAIL_REC, true)
	self.scoiety_data:ChangeMailState(true)
	RemindManager.Instance:Fire(RemindName.ScoietyMail)
	if self.scoiety_view:IsOpen() then
		self.scoiety_view:Flush("mail_left")
	end
end

function ScoietyCtrl:OnHasUnReadMail(protocol)
	print("上线时有未读邮件通知")
end
--邮件协议返回end------------------------

--组队请求begin--------------------------
function ScoietyCtrl:CreateTeamReq(param_t, is_send)
	--判断组队功能是否开启
	local can_open = OpenFunData.Instance:CheckIsHide("scoiety")
	if not can_open then
		return
	end
	--是否可以发送世界邀请
	self.can_send_world_chat = is_send
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSCreateTeam)
	send_protocol.must_check = param_t.must_check or 0
	send_protocol.assign_mode = param_t.assign_mode or 1
	send_protocol.member_can_invite = param_t.member_can_invite or 0
	send_protocol.team_type = param_t.team_type or 0
	send_protocol:EncodeAndSend()
end

function ScoietyCtrl:InviteUserReq(role_id)
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSInviteUser)
	send_protocol.role_id = role_id or 0
	send_protocol:EncodeAndSend()
end

function ScoietyCtrl:InviteUniqueUserReq(role_id, plat_type)
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSInviteUniqueUser)
	send_protocol.role_id = role_id or 0
	send_protocol.plat_type = plat_type or 0
	send_protocol:EncodeAndSend()
end

function ScoietyCtrl:InviteUserTransmitRet(inviter, result)
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSInviteUserTransmitRet)
	send_protocol.inviter = inviter or 0
	send_protocol.result = result or 0
	send_protocol:EncodeAndSend()
end

function ScoietyCtrl:ReqJoinTeamRet(req_role_id, result)
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSReqJoinTeamRet)
	send_protocol.req_role_id = req_role_id or 0
	send_protocol.result = result or 0
	send_protocol:EncodeAndSend()
end

function ScoietyCtrl:JoinTeamReq(team_index, is_call_in_ack)
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSReqJoinTeam)
	send_protocol.team_index = team_index or 0
	send_protocol.is_call_in_ack = is_call_in_ack or 0
	send_protocol:EncodeAndSend()
end

function ScoietyCtrl:KickOutOfTeamReq(role_id)
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSKickOutOfTeam)
	send_protocol.role_id = role_id or 0
	send_protocol:EncodeAndSend()
end

function ScoietyCtrl:ChangeTeamLeaderReq(role_id)
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSChangeTeamLeader)
	send_protocol.role_id = role_id or 0
	send_protocol:EncodeAndSend()
end

function ScoietyCtrl:ExitTeamReq()
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSExitTeam)
	send_protocol:EncodeAndSend()
end

function ScoietyCtrl:TeamListReq()
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSTeamListReq)
	send_protocol:EncodeAndSend()
end

function ScoietyCtrl:ChangeMustCheckReq(must_check)
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSChangeMustCheck)
	send_protocol.must_check = must_check or 0
	send_protocol:EncodeAndSend()
end

function ScoietyCtrl:ChangeAssignModeReq(assign_mode)
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSChangeAssignMode)
	send_protocol.assign_mode = assign_mode or 0
	send_protocol:EncodeAndSend()
end

function ScoietyCtrl:ChangeMemberCanInvite(member_can_invite)
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSChangeMemberCanInvite)
	send_protocol.member_can_invite = member_can_invite or 0
	send_protocol:EncodeAndSend()
end

function ScoietyCtrl:ChangeTeamLimit(limit_capability, limit_level)
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSChangeTeamLimit)
	send_protocol.limit_capability = limit_capability or 0
	send_protocol.limit_level = limit_level or 0
	send_protocol:EncodeAndSend()
end

function ScoietyCtrl:AutoHaveTeamReq()
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSAutoHaveTeam)
	send_protocol:EncodeAndSend()
end

function ScoietyCtrl:AutoApplyJoinTeam(is_auto_join_team)
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSAutoApplyJoinTeam)
	send_protocol.is_auto_join_team = is_auto_join_team or 0
	send_protocol:EncodeAndSend()
end

--组队请求end--------------------------

--好友请求begin------------------------
function ScoietyCtrl:FriendInfoReq()
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSFriendInfoReq)
	send_protocol:EncodeAndSend()
end

function ScoietyCtrl:AddFriendReq(friend_user_id, is_yi_jian)
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSAddFriendReq)
	send_protocol.friend_user_id = friend_user_id or 0
	send_protocol.is_yi_jian = is_yi_jian or 0
	send_protocol:EncodeAndSend()
end


function ScoietyCtrl:AddFriendRet(param_t)
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSAddFriendRet)
	send_protocol.req_user_id = param_t.req_user_id or 0
	send_protocol.req_gamename = param_t.req_gamename or ""
	send_protocol.is_accept = param_t.is_accept or 0
	send_protocol.reserved = param_t.reserved or 0
	send_protocol.req_sex = param_t.req_sex or 0
	send_protocol.req_prof = param_t.req_prof or 0
	send_protocol:EncodeAndSend()
end

function ScoietyCtrl:DeleteFriend(user_id, is_silence)
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSDeleteFriend)
	send_protocol.user_id = user_id or 0
	send_protocol.is_silence = is_silence or 0
	send_protocol:EncodeAndSend()
end

function ScoietyCtrl:AddBlackReq(user_id)
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSAddBlackReq)
	send_protocol.user_id = user_id or 0
	send_protocol:EncodeAndSend()
end

function ScoietyCtrl:DeleteBlackReq(user_id)
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSDeleteBlackReq)
	send_protocol.user_id = user_id or 0
	send_protocol:EncodeAndSend()
end

function ScoietyCtrl:RandomRoleListReq()
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSGetRandomRoleList)
	send_protocol:EncodeAndSend()
end

function ScoietyCtrl:SendGiftReq(target_id, is_yi_jian, is_return)
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSFriendSongGift)
	send_protocol.target_id = target_id or 0
	send_protocol.is_yi_jian = is_yi_jian or 0
	send_protocol.is_return = is_return or 0
	send_protocol:EncodeAndSend()
end
--好友请求end------------------------

--仇人请求begin--------------------
function ScoietyCtrl:EnemyDeleteReq(plat_type, user_id)
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSEnemyDelete)
	send_protocol.plat_type = plat_type or 0
	send_protocol.user_id = user_id or 0
	send_protocol:EncodeAndSend()
end
--仇人请求end--------------------

--邮件请求begin--------------------
function ScoietyCtrl:MailSendReq(param_t)
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSMailSend)
	send_protocol.recver_uid = param_t.recver_uid or 0
	send_protocol.gold = param_t.gold or 0
	send_protocol.coin = param_t.coin or 0
	send_protocol.item_count = param_t.item_count or 0
	send_protocol.item_knapindex_list = param_t.item_knapindex_list or {0, 0, 0}
	send_protocol.item_comsume_num = param_t.item_comsume_num or {0, 0, 0}
	send_protocol.subject = param_t.subject or ""
	send_protocol.contenttxt = param_t.contenttxt or ""
	send_protocol:EncodeAndSend()
end

function ScoietyCtrl:MailDeleteReq(mail_index)
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSMailDelete)
	send_protocol.mail_index = mail_index or 0
	send_protocol:EncodeAndSend()
end

function ScoietyCtrl:MailGetListReq()
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSMailGetList)
	send_protocol:EncodeAndSend()
end

function ScoietyCtrl:MailReadReq(mail_index)
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSMailRead)
	send_protocol.mail_index = mail_index or 0
	send_protocol:EncodeAndSend()
end

function ScoietyCtrl:MailFetchAttachmentReq(param_t)
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSMailFetchAttachment)
	send_protocol.mail_index = param_t.mail_index or 0
	send_protocol.item_index = param_t.item_index or -1
	send_protocol.is_last = param_t.is_last or 0
	send_protocol:EncodeAndSend()
end

function ScoietyCtrl:MailCleanReq()
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSMailClean)
	send_protocol:EncodeAndSend()
end

function ScoietyCtrl:MailOneKeyFetchAttachmentReq()
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSMailOneKeyFetchAttachment)
	send_protocol:EncodeAndSend()
end
--邮件请求end--------------------

function ScoietyCtrl:ShowWriteMailView()
	-- self.scoiety_view:ShowWriteMailView()
end

function ScoietyCtrl:ShowMailView()
	self.scoiety_view:ShowMailView()
end

function ScoietyCtrl:ShowNearTeamView()
	self:TeamListReq()
	self.near_team_view:Open()
end

function ScoietyCtrl:ShowInviteView(value)
	self.scoiety_data:SetInviteType(value)
	self.invite_view:Open()
end

function ScoietyCtrl:ShowFriendRecView()
	self:RandomRoleListReq()
	self.friendrandom_view:Open()
end

function ScoietyCtrl:ShowDeleteView()
	self.delete_view:Open()
end

function ScoietyCtrl:CloseOperaList()
	if self.operate_list then
		if self.operate_list:IsOpen() then
			self.operate_list:Close()
		end
	end
end

-- 跨服查看角色信息
function ScoietyCtrl:ShowOperateListGlobal(open_type, uuid, click_obj, colse_call_back, click_btn_close_callback, main_chat_flag)
	if type(uuid) ~= "table" or nil == next(uuid) then
		return
	end

	if nil ~= self.wait_opera_uuid and uuid.plat_type == self.wait_opera_uuid.plat_type and uuid.role_id == self.wait_opera_uuid.role_id then
		if self.operate_list:IsOpen() then
			self.operate_list:Close()
		end
		return
	end

	if self.operate_list:IsOpen() then
		self.operate_list:Close()
	end

	if click_obj then
		self.operate_list:SetClickObj(click_obj)
	end

	if colse_call_back then
		self.operate_list:SetCloseCallBack(colse_call_back)
	end

	if click_btn_close_callback then
		self.operate_list:SetBtnCloseCallBack(click_btn_close_callback)
	end

	if not open_type then
		open_type = ScoietyData.DetailType.Default
	end

	if main_chat_flag then
		open_type = ScoietyData.DetailType.MainChat
	end

	self.operate_list:SetRoleName("")
	self.scoiety_data:SetOpenDetailType(open_type)

	self.wait_opera_uuid = uuid
	PlayerCtrl.Instance:SendFindRoleByUUID(uuid.plat_type, uuid.role_id)
end

--click_obj为该obj的可穿透区域
function ScoietyCtrl:ShowOperateList(open_type, name, click_obj, colse_call_back, click_btn_close_callback, main_chat_flag)
	if not name or name == "" then
		print_error("ERROR NAME TO FIND！")
		return
	end

	-- if IS_ON_CROSSSERVER then
	-- 	SysMsgCtrl.Instance:ErrorRemind(Language.Society.CanNotInCross)
	-- 	return
	-- end
	if name == self.operate_list.role_name then
		if self.operate_list:IsOpen() then
			self.operate_list:Close()
		end
		return
	end

	if self.operate_list:IsOpen() then
		self.operate_list:Close()
	end

	if click_obj then
		self.operate_list:SetClickObj(click_obj)
	end

	if colse_call_back then
		self.operate_list:SetCloseCallBack(colse_call_back)
	end

	if click_btn_close_callback then
		self.operate_list:SetBtnCloseCallBack(click_btn_close_callback)
	end

	if not open_type then
		open_type = ScoietyData.DetailType.Default
	end

	if main_chat_flag then
		open_type = ScoietyData.DetailType.MainChat
	end

	self.operate_list:SetRoleName(name)
	self.scoiety_data:SetOpenDetailType(open_type)

	self.wait_opera_role_name = name
	PlayerCtrl.Instance:CSFindRoleByName(name)
end

function ScoietyCtrl:FlushOperateList(info)
	if self.wait_opera_uuid ~= nil and info and info.role_id ~= 0 then
		if self.wait_opera_uuid.plat_type == info.plat_type and self.wait_opera_uuid.role_id == info.role_id then
			self.scoiety_data:SetSelectRoleInfo(info)
			local function open()
				self.operate_list:Open()
			end
			if self.operate_list:IsOpen() then
				--这种情况是关闭动画没有播放完毕，做个延迟
				GlobalTimerQuest:AddDelayTimer(open, 0.25)
			else
				open()
			end
		end
		self.wait_opera_uuid = nil
	elseif self.wait_opera_role_name ~= "" and info and info.role_id ~= 0 and self.wait_opera_role_name == info.role_name then
		self.scoiety_data:SetSelectRoleInfo(info)
		local function open()
			-- if IS_ON_CROSSSERVER then
			-- 	TipsCtrl.Instance:ShowSystemMsg(Language.Common.CantOpenInCross)
			-- 	return
			-- end
			self.wait_opera_role_name = ""
			self.operate_list:Open()
		end
		if self.operate_list:IsOpen() then
			--这种情况是关闭动画没有播放完毕，做个延迟
			GlobalTimerQuest:AddDelayTimer(open, 0.25)
		else
			open()
		end
	end

	if info and info.role_id ~= 0 and self.purchase_wait_opera_id == info.role_id then
		self:ShowSingerChat(info)
		self.purchase_wait_opera_id = 0
		self.purchase_item_id = 0
		self.is_purchase_wait_opera = ""
	end
end

function ScoietyCtrl:ShowSingerChat(info)
	local role_info = info
	if not next(role_info) then
		return
	end
	if nil == ChatData.Instance:GetPrivateObjByRoleId(role_info.role_id) then
		private_obj = ChatData.CreatePrivateObj()
		private_obj.plat_type = role_info.plat_type
		private_obj.role_id = role_info.role_id
		private_obj.username = role_info.role_name
		private_obj.sex = role_info.sex
		private_obj.camp = role_info.camp
		private_obj.prof = role_info.prof
		private_obj.avatar_key_small = role_info.avatar_key_small
		private_obj.level = role_info.level
		private_obj.create_time = TimeCtrl.Instance:GetServerTime()
		ChatData.Instance:AddPrivateObj(private_obj.role_id, private_obj)
	end
	ChatData.Instance:SetCurrentId(role_info.role_id)
	
	local rank = 1
	local content = ""
	if self.is_purchase_wait_opera ~= "fall_msg" then
	-- 	rank = math.random(1, #Language.Market.GuildRareLogSingerText)
	-- 	content = string.format(Language.Market.GuildRareLogSingerText[rank], self.purchase_item_id or 0)
	-- else
		rank = math.random(1, 2)
		content = string.format(Language.Market.MarketPurchaseSingerText[rank], self.purchase_item_id or 0)
	end

	local msg_info = ChatData.CreateMsgInfo()
	local main_vo = GameVoManager.Instance:GetMainRoleVo()
	msg_info.from_uid = main_vo.role_id
	local real_role_id = CrossServerData.Instance:GetRoleId()				--获取真实id，防止在跨服聊天出问题
	real_role_id = real_role_id > 0 and real_role_id or main_vo.role_id
	msg_info.plat_id = main_vo.plat_type
	msg_info.role_id = real_role_id
	msg_info.username = main_vo.name
	msg_info.sex = main_vo.sex
	msg_info.camp = main_vo.camp
	msg_info.prof = main_vo.prof
	msg_info.authority_type = main_vo.authority_type
	msg_info.avatar_key_small = main_vo.avatar_key_small
	msg_info.level = main_vo.level
	msg_info.vip_level = main_vo.vip_level
	msg_info.channel_type = CHANNEL_TYPE.PRIVATE
	msg_info.content = content
	msg_info.send_time_str = TimeUtil.FormatTable2HMS(TimeCtrl.Instance:GetServerTimeFormat())
	msg_info.content_type = CHAT_CONTENT_TYPE.TEXT
	msg_info.tuhaojin_color = CoolChatData.Instance:GetTuHaoJinCurColor() or 0			--土豪金
	msg_info.channel_window_bubble_type = CoolChatData.Instance:GetSelectSeq()					--气泡框
	msg_info.is_read = 1

	if self.is_purchase_wait_opera ~= "fall_msg" then
		local current_id = ChatData.Instance:GetCurrentId()
		ChatData.Instance:AddPrivateMsg(current_id, msg_info)

		ChatCtrl.SendSingleChat(role_info.role_id, content, CHAT_CONTENT_TYPE.TEXT)
	end
	
	if ViewManager.Instance:IsOpen(ViewName.ChatGuild) then
		ViewManager.Instance:PopViewToFront(ViewName.ChatGuild)
		ViewManager.Instance:FlushView(ViewName.ChatGuild, "select_traget", {true})
	else
		ViewManager.Instance:Open(ViewName.ChatGuild)
	end
end

function ScoietyCtrl:SetWaitOperaName(uuid, item_id, enabled)
	self.purchase_wait_opera_id = uuid
	self.purchase_item_id = item_id
	self.is_purchase_wait_opera = enabled or ""
end

function ScoietyCtrl:ShowBlackListView()
	self.scoiety_black_view:Open()
end

--sex为只显示什么性别的好友
function ScoietyCtrl:ShowFriendListView(callback, sex)
	self.friend_list_view:SetCallBack(callback)
	self.friend_list_view:SetSex(sex)
	self.friend_list_view:Open()
end

function ScoietyCtrl:ShowFriendRecordView()
	self.gift_record_view:Open()
end

function ScoietyCtrl:ChangeFriendRequest(value)
	self.scoiety_data:ChangeAddFriendState(value)
end

function ScoietyCtrl:ShowApplyView(open_type)
	self.apply_view:SetOpenType(open_type)
	self.apply_view:Open()
	self.apply_view:Flush()
end

function ScoietyCtrl:ClearTeamInfo()
	MainUICtrl.Instance:FlushTipsIcon(MainUIViewChat.IconList.JOIN_REQ, false)
	self.scoiety_data:ClearTeamInfo()
	ChatData.Instance:ClearTeamUnreadMsg()
	--移除聊天对象
	ChatData.Instance:RemoveNormalChatList(SPECIAL_CHAT_ID.TEAM)
	GlobalEventSystem:Fire(ChatEventType.SPECIAL_CHAT_TARGET_CHANGE, SPECIAL_CHAT_ID.TEAM, false)

	MainUICtrl.Instance:FlushView("team_list")
	ViewManager.Instance:FlushView(ViewName.TombExploreFBView, "flush_team")
	local fu_ben_view = FuBenCtrl.Instance:GetFuBenView()
	if fu_ben_view:IsOpen() then
		fu_ben_view:Flush("exp")
		fu_ben_view:Flush("team")
	end
	FuBenCtrl.Instance:FlushManyPeopleView()
	if self.scoiety_view:IsOpen() then
		self.scoiety_view:Flush("team")
	end

	self:BossFightViewFlush()

end

--断线重连后进行操作
function ScoietyCtrl:OnConnectLoginServer(is_succ)
	if is_succ then
		self:ClearTeamInfo()
	end
end

--进入游戏服成功
function ScoietyCtrl:EnterGameServerSucc()
	-- 获取邮件列表
	self:MailGetListReq()
end

--主界面加载完毕后操作
function ScoietyCtrl:MainuiOpen()
	-- 获取邮件列表
	self:MailGetListReq()
end

--角色信息返回（通过名字查询的）
function ScoietyCtrl:RoleNameInfoReturn(protocol)
	if protocol.msg_identify == 1 then
		self.scoiety_data:SetEnemyListData(protocol)
		return
	end
	self:FlushOperateList(protocol)
end

--玩家上下线处理
function ScoietyCtrl:RoleOnLineChange(role_id, is_online)
	local is_friend = self.scoiety_data:IsFriendById(role_id)
	local is_enemy = self.scoiety_data:IsEnemy(role_id)
	if is_friend then
		local friend_info = self.scoiety_data:GetFriendInfoById(role_id)
		if is_online == 1 then
			local des = string.format(Language.Society.FriendOnlineDes, friend_info.gamename or "")
			TipsCtrl.Instance:ShowFloatingName(des)
		end

		self.scoiety_data:ChangeFriendIsOnlineState(role_id, is_online)
		if self.scoiety_view:IsOpen() then
			self.scoiety_view:Flush("friend")
		end

		if self.friend_list_view:IsOpen() then
			self.friend_list_view:Flush()
		end
		RemindManager.Instance:Fire(RemindName.ScoietyOtherFriend)
		GlobalEventSystem:Fire(OtherEventType.FRIEND_INFO_CHANGE)
	end

	if is_enemy then
		self.scoiety_data:ChangeEnemyOnlineState(role_id, is_online)
		if self.scoiety_view:IsOpen() then
			self.scoiety_view:Flush("enemy")
		end
	end
	ChatData.Instance:ChangeIsOnlineInPrivite(role_id, is_online)
	--通知有玩家上下线变化
	GlobalEventSystem:Fire(OtherEventType.ROLE_ISONLINE_CHANGE, role_id, is_online)
end

function ScoietyCtrl:SendOfflineFriendAutoDecFlag(is_auto_dec)
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSOfflineFriendAutoDecFlag)
	send_protocol.is_auto_dec = is_auto_dec or 0
	send_protocol:EncodeAndSend()
end

function ScoietyCtrl:BossFightViewFlush()
	local boss_fam_fight_view = BossCtrl.Instance.boss_family_fight_view
	if boss_fam_fight_view:IsOpen() then
		boss_fam_fight_view:Flush("team_type")
	end

	local boss_dabao_fight_view = BossCtrl.Instance.dabao_fam_fight_view
	if boss_dabao_fight_view:IsOpen() then
		boss_dabao_fight_view:Flush("team_type")
	end

	local boss_world_fight_view = BossCtrl.Instance.world_boss_fight_view
	if boss_world_fight_view:IsOpen() then
		boss_world_fight_view:Flush("team_type")
	end

	local baby_boss_fight_view = BossCtrl.Instance.baby_boss_fight_view
	if baby_boss_fight_view:IsOpen() then
		baby_boss_fight_view:Flush("team_type")
	end

	local shanggu_fight_view = BossCtrl.Instance.shanggu_fight_view
	if shanggu_fight_view:IsOpen() then
		shanggu_fight_view:Flush("team_type")
	end

	local godmagic_fight_view = ShenYuBossCtrl.Instance.godmagic_fight_view
	if godmagic_fight_view:IsOpen() then
		godmagic_fight_view:Flush("team_type")
	end
end