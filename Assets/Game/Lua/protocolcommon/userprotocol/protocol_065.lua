local function DecodeShenyiEquipInfo()
	local t = {}
	t.equip_id = MsgAdapter.ReadUShort()
	t.level = MsgAdapter.ReadShort()
	t.exp = MsgAdapter.ReadInt()
	t.attr_list = {}
	for i = 0, GameEnum.MOUNT_EQUIP_ATTR_COUNT - 1 do
		t.attr_list[i] = MsgAdapter.ReadInt()
	end
	return t
end

--神翼信息
SCShenyiInfo =  SCShenyiInfo or BaseClass(BaseProtocolStruct)
function SCShenyiInfo:__init()
	self.msg_type = 6500
end

--单个神翼信息返回
function SCShenyiInfo:Decode()
	self.star_level = MsgAdapter.ReadShort()
	self.shenyi_level = MsgAdapter.ReadShort()
	self.grade = MsgAdapter.ReadShort()
	self.used_imageid = MsgAdapter.ReadShort()
	self.grade_bless_val = MsgAdapter.ReadInt()		-- 祝福值
	self.shuxingdan_count = MsgAdapter.ReadShort()
	self.chengzhangdan_count = MsgAdapter.ReadShort()
	
	self.active_image_flag = {}							-- 形象激活标记
	for i = 0, GameEnum.UPGRADE_MAX_IMAGE_BYTE - 1 do 					
		self.active_image_flag[i] = MsgAdapter.ReadUChar()
	end

	self.active_special_image_flag = {}						-- 特殊形象激活标记
	for i = 0, GameEnum.UPGRADE_MAX_IMAGE_BYTE - 1 do 					
		self.active_special_image_flag[i] = MsgAdapter.ReadUChar()
	end
	
	self.clear_upgrade_time = MsgAdapter.ReadUInt()
	self.equip_skill_level = MsgAdapter.ReadInt()

	self.equip_level_list = {}
	for i = 0, GameEnum.MOUNT_EQUIP_COUNT - 1 do
		self.equip_level_list[i] = MsgAdapter.ReadShort()
	end

	self.skill_level_list = {}
	for i = 0, GameEnum.MOUNT_SKILL_COUNT - 1 do
		self.skill_level_list[i] = MsgAdapter.ReadShort()
	end

	self.special_img_grade_list = {}
	for i = 0, GameEnum.MAX_MOUNT_SPECIAL_IMAGE_ID_TWO - 1  do
		self.special_img_grade_list[i] = MsgAdapter.ReadChar()
	end
end

--神翼外观改变
SCShenyiAppeChange = SCShenyiAppeChange or BaseClass(BaseProtocolStruct)
function SCShenyiAppeChange:__init()
	self.msg_type = 6501
end

function SCShenyiAppeChange:Decode()
	self.objid = MsgAdapter.ReadUShort()
	self.shenyi_appeid = MsgAdapter.ReadUShort()
end

--神翼进阶
CSUpgradeShenyi = CSUpgradeShenyi or BaseClass(BaseProtocolStruct)
function CSUpgradeShenyi:__init()
	self.msg_type = 6502
	self.repeat_times = 0
	self.auto_buy = 0
end

function CSUpgradeShenyi:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteShort(self.repeat_times)
	MsgAdapter.WriteShort(self.auto_buy)
end

--神翼形象使用
CSUseShenyiImage = CSUseShenyiImage or BaseClass(BaseProtocolStruct)
function CSUseShenyiImage:__init()
	self.msg_type = 6503
	self.reserve_sh = 0
	self.image_id = 0
end

function CSUseShenyiImage:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteShort(self.reserve_sh)
	MsgAdapter.WriteShort(self.image_id)
end

-- 请求神翼信息协议
CSShenyiGetInfo = CSShenyiGetInfo or BaseClass(BaseProtocolStruct)
function CSShenyiGetInfo:__init()
	self.msg_type = 6504
end

function CSShenyiGetInfo:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
end

--神翼升级装备请求
CSShenyiUplevelEquip = CSShenyiUplevelEquip or BaseClass(BaseProtocolStruct)
function CSShenyiUplevelEquip:__init()
	self.msg_type = 6505
	self.equip_index = 0
end

function CSShenyiUplevelEquip:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteChar(self.equip_index)
	MsgAdapter.WriteShort(0)
end

--神翼技能升级请求
CSShenyiSkillUplevelReq = CSShenyiSkillUplevelReq or BaseClass(BaseProtocolStruct)
function CSShenyiSkillUplevelReq:__init()
	self.msg_type = 6506
	self.skill_idx = 0
	self.auto_buy = 0
end

function CSShenyiSkillUplevelReq:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteShort(self.skill_idx)
	MsgAdapter.WriteShort(self.auto_buy)
end

--神翼特殊形象进阶
CSShenyiSpecialImgUpgrade = CSShenyiSpecialImgUpgrade or BaseClass(BaseProtocolStruct)
function CSShenyiSpecialImgUpgrade:__init()
	self.msg_type = 6507
	self.special_image_id = 0
	self.reserve_sh = 0
end

function CSShenyiSpecialImgUpgrade:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteShort(self.special_image_id)
	MsgAdapter.WriteShort(self.reserve_sh)
end

--神翼升星
CSShenyiUpStarLevel = CSShenyiUpStarLevel or BaseClass(BaseProtocolStruct)
function CSShenyiUpStarLevel:__init()
	self.msg_type = 6508
	self.stuff_index = 0
	self.is_auto_buy = 0
	self.loop_times = 0
end

function CSShenyiUpStarLevel:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteShort(self.stuff_index)
	MsgAdapter.WriteShort(self.is_auto_buy)
	MsgAdapter.WriteInt(self.loop_times)
end

--请求取消神翼使用形象
CSUnUseShenyiImage = CSUnUseShenyiImage or BaseClass(BaseProtocolStruct)
function CSUnUseShenyiImage:__init()
	self.msg_type = 6059
	self.image_id = 0
	self.reserve_sh = 0
end

function CSUnUseShenyiImage:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteShort(self.image_id)
	MsgAdapter.WriteShort(self.reserve_sh)
end

--打宝boss信息
SCDabaoBossInfo = SCDabaoBossInfo or BaseClass(BaseProtocolStruct)
function SCDabaoBossInfo:__init()
	self.msg_type = 6551
	self.dabao_angry_value = 0
	self.dabao_enter_count = 0
end

function SCDabaoBossInfo:Decode()
	self.dabao_angry_value = MsgAdapter.ReadShort()
	self.dabao_enter_count = MsgAdapter.ReadShort()
	self.kick_time = MsgAdapter.ReadUInt()
end

--boss之家boss信息
SCFamilyBossInfo = SCFamilyBossInfo or BaseClass(BaseProtocolStruct)
function SCFamilyBossInfo:__init()
	self.msg_type = 6552
	self.scene_id = 0
	self.boss_list = {}
end

function SCFamilyBossInfo:Decode()
	self.boss_list = {}
	self.scene_id = MsgAdapter.ReadInt()
	local count = MsgAdapter.ReadInt()
	for i = 1, count do
		local vo = {}
		vo.boss_id = MsgAdapter.ReadInt()
		vo.status = MsgAdapter.ReadInt()
		vo.next_refresh_time = MsgAdapter.ReadUInt()
		self.boss_list[i] = vo
	end
end

--秘窟boss信息
SCMikuBossInfo = SCMikuBossInfo or BaseClass(BaseProtocolStruct)
function SCMikuBossInfo:__init()
	self.msg_type = 6553
	self.scene_id = 0
	self.miku_boss_weary = 0
	self.boss_list = {}
end

function SCMikuBossInfo:Decode()
	self.miku_boss_weary =MsgAdapter.ReadShort()
	MsgAdapter.ReadShort()
	self.boss_list = {}
	local count = MsgAdapter.ReadInt()
	self.scene_id = MsgAdapter.ReadInt()
	self.elite_count = MsgAdapter.ReadInt()
	for i = 1, count do
		local vo = {}
		vo.boss_id = MsgAdapter.ReadInt()
		vo.status = MsgAdapter.ReadInt()
		vo.next_refresh_time = MsgAdapter.ReadUInt()
		self.boss_list[i] = vo
	end
end

--秘窟精英怪物信息（在场景内才会收到该协议，数量对应场景）
SCMikuMonsterInfo = SCMikuMonsterInfo or BaseClass(BaseProtocolStruct)
function SCMikuMonsterInfo:__init()
	self.msg_type = 6561
	self.elite_count = 0
end

function SCMikuMonsterInfo:Decode()
	self.elite_count = MsgAdapter.ReadInt()
end

--秘窟疲劳值
SCBossRoleInfo = SCBossRoleInfo or BaseClass(BaseProtocolStruct)
function SCBossRoleInfo:__init()
	self.msg_type = 6554
	self.miku_boss_weary = 0
end

function SCBossRoleInfo:Decode()
	self.miku_boss_weary =MsgAdapter.ReadShort()
	MsgAdapter.ReadShort()
end

--打宝boss怪物刷新
SCDabaoBossNextFlushInfo = SCDabaoBossNextFlushInfo or BaseClass(BaseProtocolStruct)
function SCDabaoBossNextFlushInfo:__init()
	self.msg_type = 6555
	self.count = 0
	self.scene_id = 0
end

function SCDabaoBossNextFlushInfo:Decode()
	self.scene_id = MsgAdapter.ReadInt()
	self.count = MsgAdapter.ReadInt()
	self.boss_list = {}
	for i = 1, self.count do
		self.boss_list[i] = {}
		self.boss_list[i].boss_id = MsgAdapter.ReadInt()
		self.boss_list[i].next_refresh_time = MsgAdapter.ReadUInt()
	end
end

--boss广播信息
SCBossInfoToAll = SCBossInfoToAll or BaseClass(BaseProtocolStruct)
function SCBossInfoToAll:__init()
	self.msg_type = 6556
	self.boss_type = 0
	self.boss_id = 0
	self.scene_id = 0
	self.status = 0
	self.next_refresh_time = 0
	self.killer_uid = 0
	self.notify_reason = 0
end

function SCBossInfoToAll:Decode()
	self.notify_reason = MsgAdapter.ReadInt()
	self.boss_type = MsgAdapter.ReadInt()
	self.boss_id = MsgAdapter.ReadInt()
	self.scene_id = MsgAdapter.ReadInt()
	self.status = MsgAdapter.ReadInt()
	self.next_refresh_time = MsgAdapter.ReadUInt()
	self.killer_uid = MsgAdapter.ReadInt()
end

--boss击杀列表信息
local KILLER_LIST_MAX_COUNT = 5
SCBossKillerList = SCBossKillerList or BaseClass(BaseProtocolStruct)
function SCBossKillerList:__init()
	self.msg_type = 6557
	self.killer_info_list = {}
end

function SCBossKillerList:Decode()
	for i = 1, KILLER_LIST_MAX_COUNT do
		self.killer_info_list[i] = {}
		self.killer_info_list[i].killer_uid = MsgAdapter.ReadInt()
		self.killer_info_list[i].killier_time = MsgAdapter.ReadUInt()
		self.killer_info_list[i].killer_name = MsgAdapter.ReadStrN(32)
	end
end

--boss关注列表信息
local KILLER_LIST_MAX_COUNT = 5
SCFollowBossInfo = SCFollowBossInfo or BaseClass(BaseProtocolStruct)
function SCFollowBossInfo:__init()
	self.msg_type = 6558
	self.follow_boss_list = {}
end

function SCFollowBossInfo:Decode()
	local count = MsgAdapter.ReadInt()
	self.follow_boss_list = {}
	for i = 1, count do
		self.follow_boss_list[i] = {}
		self.follow_boss_list[i].boss_id = MsgAdapter.ReadShort()
		self.follow_boss_list[i].boss_type = MsgAdapter.ReadChar()
		MsgAdapter.ReadChar()
		self.follow_boss_list[i].scene_id = MsgAdapter.ReadInt()
	end
end

--活跃boss刷新时间信息
local MAX_BOSS_COUNT = 100
SCActiveBossNextFlushInfo = SCActiveBossNextFlushInfo or BaseClass(BaseProtocolStruct)
function SCActiveBossNextFlushInfo:__init()
	self.msg_type = 6559
	self.scene_id = 0
	self.boss_list = {}
end

function SCActiveBossNextFlushInfo:Decode()
	self.scene_id = MsgAdapter.ReadInt()
	local count = MsgAdapter.ReadInt()
	self.boss_list = {}
	for i = 1, count do
		self.boss_list[i] = {}
		self.boss_list[i].boss_id = MsgAdapter.ReadInt()
		self.boss_list[i].next_refresh_time = MsgAdapter.ReadUInt()
	end
end

--活跃boss信息
local MAX_BOSS_COUNT = 100
SCActiveBossInfo = SCActiveBossInfo or BaseClass(BaseProtocolStruct)
function SCActiveBossInfo:__init()
	self.msg_type = 6560
	self.enter_count = 0
	self.active_boss_weary = 0
end

function SCActiveBossInfo:Decode()
	self.enter_count = MsgAdapter.ReadShort()
	self.active_boss_weary = MsgAdapter.ReadShort()
end

--请求世界boss信息
CSFollowBossReq = CSFollowBossReq or BaseClass(BaseProtocolStruct)
function CSFollowBossReq:__init()
	self.msg_type = 6570
	self.opera_type = 0
	self.boss_type = 0
	self.boss_id = 0
	self.scene_id = 0
end

function CSFollowBossReq:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteInt(self.opera_type)
	MsgAdapter.WriteInt(self.boss_type)
	MsgAdapter.WriteInt(self.boss_id)
	MsgAdapter.WriteInt(self.scene_id)
end

---------------------足迹系统-----------------------

--接收足迹
SCFootPrintInfo = SCFootPrintInfo or BaseClass(BaseProtocolStruct)
function SCFootPrintInfo:__init()
	self.msg_type = 6520
end

function SCFootPrintInfo:Decode()

	self.footprint_level = MsgAdapter.ReadShort()		       -- 等级
	self.grade = MsgAdapter.ReadShort()						   -- 阶
	self.star_level = MsgAdapter.ReadShort()				   -- 星级
	self.used_imageid = MsgAdapter.ReadShort()				   -- 使用的形象
	self.shuxingdan_count = MsgAdapter.ReadShort()			   -- 属性丹数量
	self.chengzhangdan_count = MsgAdapter.ReadShort()		   -- 成长丹数量
	self.grade_bless_val = MsgAdapter.ReadInt()				   -- 进阶祝福值

	self.active_image_flag = {}           						-- 激活的形象列表  & (1 << imageid) != MsgAdapter.ReadInt() 0，则激活imageid
	for i = 0, GameEnum.UPGRADE_MAX_IMAGE_BYTE - 1 do 					
		self.active_image_flag[i] = MsgAdapter.ReadUChar()
	end

	self.active_special_image_flag = {}							-- 特殊形象激活标记
	for i = 0, GameEnum.UPGRADE_MAX_IMAGE_BYTE - 1 do 					
		self.active_special_image_flag[i] = MsgAdapter.ReadUChar()
	end

	self.clear_upgrade_time = MsgAdapter.ReadUInt()			   -- 清空祝福值的时间
	self.equip_skill_level = MsgAdapter.ReadInt()			   -- 装备技能等级
	self.equip_level_list = {}                                 -- 装备信息
	for i = 0, GameEnum.MOUNT_EQUIP_COUNT - 1 do
		self.equip_level_list[i] = MsgAdapter.ReadShort()
	end

	self.skill_level_list = {}                                  -- 技能等级
	for i = 0, GameEnum.MOUNT_SKILL_COUNT - 1 do
		self.skill_level_list[i] = MsgAdapter.ReadShort()
	end
	
	self.special_img_grade_list = {}                           -- 特殊形象阶数
	for i = 0, GameEnum.MAX_MOUNT_SPECIAL_IMAGE_ID_TWO - 1  do
		self.special_img_grade_list[i] = MsgAdapter.ReadChar()
	end
end

--发送足迹信息
CSFootprintOperate = CSFootprintOperate or BaseClass(BaseProtocolStruct)
function CSFootprintOperate:__init()
	self.msg_type = 6521
	self.operate_type = 0
	self.param_1 = 0
	self.param_2 = 0
	self.param_3 = 0
end


function CSFootprintOperate:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteShort(self.operate_type)
	MsgAdapter.WriteShort(self.param_1)
	MsgAdapter.WriteShort(self.param_2)
	MsgAdapter.WriteShort(self.param_3)
end

---------------------------------------

SCCloakInfo =  SCCloakInfo or BaseClass(BaseProtocolStruct)
function SCCloakInfo:__init()
	self.msg_type = 6525
end

--披风信息返回
function SCCloakInfo:Decode()
	self.cloak_level = MsgAdapter.ReadInt()
	self.cur_exp = MsgAdapter.ReadInt()
	self.used_imageid = MsgAdapter.ReadInt()
	-- self.shuxingdan_count = MsgAdapter.ReadInt()
	self.active_image_flag = MsgAdapter.ReadInt()
	self.active_special_image_flag = MsgAdapter.ReadLL()
	self.equip_skill_level = MsgAdapter.ReadInt()

	self.shuxingdan_list = {}							-- 属性丹列表
	for i=0, GameEnum.JINJIE_SHUXINGDAN_MAX_TYPE - 1 do
		self.shuxingdan_list[i] = MsgAdapter.ReadShort()
	end

	self.equip_level_list = {}
	for i = 0, GameEnum.MOUNT_EQUIP_COUNT - 1 do
		self.equip_level_list[i] = MsgAdapter.ReadShort()
	end

	self.skill_level_list = {}
	for i = 0, GameEnum.MOUNT_SKILL_COUNT - 1 do
		self.skill_level_list[i] = MsgAdapter.ReadShort()
	end

	self.special_img_grade_list = {}
	for i = 0, GameEnum.MAX_MOUNT_SPECIAL_IMAGE_ID - 1 do
		self.special_img_grade_list[i] = MsgAdapter.ReadChar()
	end
end

CSCloakOperate = CSCloakOperate or BaseClass(BaseProtocolStruct)
function CSCloakOperate:__init()
	self.msg_type = 6526
end

function CSCloakOperate:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteShort(self.operate_type)
	MsgAdapter.WriteShort(self.param_1)
	MsgAdapter.WriteShort(self.param_2)
	MsgAdapter.WriteShort(self.param_3)
end

SCPreciousBossTaskInfo = SCPreciousBossTaskInfo or BaseClass(BaseProtocolStruct)
function SCPreciousBossTaskInfo:__init()
	self.msg_type = 6562
end

function SCPreciousBossTaskInfo:Decode()
	self.count = MsgAdapter.ReadInt()
	self.task_list = {}
	for i = 1, self.count do
		self.task_list[i] = {}
		self.task_list[i].task_condition = MsgAdapter.ReadShort()
		self.task_list[i].task_type = MsgAdapter.ReadShort()
		self.task_list[i].is_finish = MsgAdapter.ReadInt()	
	end
end

SCPreciousBossInfo = SCPreciousBossInfo or BaseClass(BaseProtocolStruct)
function SCPreciousBossInfo:__init()
	self.msg_type = 6563
end

function SCPreciousBossInfo:Decode()
	self.count = MsgAdapter.ReadInt()
	self.boss_list = {}
	for i = 1, self.count do
		self.boss_list[i] = {}
		self.boss_list[i].boss_id = MsgAdapter.ReadInt()
		self.boss_list[i].next_refresh_time = MsgAdapter.ReadUInt()
	end
end

CSPreciousPosReq = CSPreciousPosReq	 or BaseClass(BaseProtocolStruct)
function CSPreciousPosReq:__init()
	self.msg_type = 6564
	self.type = 0
	self.param = 0
	self.param_2 = 0
end

function CSPreciousPosReq:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteInt(self.type)
	MsgAdapter.WriteInt(self.param)
	MsgAdapter.WriteInt(self.param_2)
end

SCPreciousPosInfo = SCPreciousPosInfo or BaseClass(BaseProtocolStruct)
function SCPreciousPosInfo:__init()
	self.msg_type = 6565
end

function SCPreciousPosInfo:Decode()
	self.pos_x = MsgAdapter.ReadInt()
	self.pos_y = MsgAdapter.ReadInt()
	self.param = MsgAdapter.ReadInt()
end

--活跃BOSS伤害排行
SCActiveBossHurtRank = SCActiveBossHurtRank or BaseClass(BaseProtocolStruct)
function SCActiveBossHurtRank:__init()
	self.msg_type = 6566
end

function SCActiveBossHurtRank:Decode()
	self.monster_id = MsgAdapter.ReadInt()
	self.my_hurt = MsgAdapter.ReadLL()
	self.my_rank = MsgAdapter.ReadShort()
	self.rank_count = MsgAdapter.ReadShort()
	self.rank_list = {}
	for i=1, self.rank_count do
		local v = {}
		v.name = MsgAdapter.ReadStrN(32)
		v.hurt = MsgAdapter.ReadLL()
		self.rank_list[i] = v
	end
end

--离开活跃boss伤害信息区域
SCActiveBossLeaveInfo = SCActiveBossLeaveInfo or BaseClass(BaseProtocolStruct)
function SCActiveBossLeaveInfo:__init()
	self.msg_type = 6567
end

function SCActiveBossLeaveInfo:Decode()

end

SCMikuBossHurtRankInfo = SCMikuBossHurtRankInfo or BaseClass(BaseProtocolStruct)
function SCMikuBossHurtRankInfo:__init()
	self.msg_type = 6568
end

function SCMikuBossHurtRankInfo:Decode()
	self.monster_id = MsgAdapter.ReadInt()
	self.my_hurt = MsgAdapter.ReadLL()
	self.my_rank = MsgAdapter.ReadShort()
	self.rank_count = MsgAdapter.ReadShort()
	self.rank_list = {}
	for i=1, self.rank_count do
		local v = {}
		v.name = MsgAdapter.ReadStrN(32)
		v.hurt = MsgAdapter.ReadLL()
		self.rank_list[i] = v
	end
end

--离开困难boss伤害信息区域
SCMikuBossLeaveInfo = SCMikuBossLeaveInfo or BaseClass(BaseProtocolStruct)
function SCMikuBossLeaveInfo:__init()
	self.msg_type = 6569
end

function SCMikuBossLeaveInfo:Decode()

end