
-- 创建角色返回
SCCreateRoleAck = SCCreateRoleAck or BaseClass(BaseProtocolStruct)
function SCCreateRoleAck:__init()
	self.msg_type = 7100
end

function SCCreateRoleAck:Decode()
	self.result = MsgAdapter.ReadInt()
	self.role_id = MsgAdapter.ReadInt()
	self.role_name = MsgAdapter.ReadStrN(32)
	self.avatar = MsgAdapter.ReadChar()
	self.sex = MsgAdapter.ReadChar()
	self.prof = MsgAdapter.ReadChar()
	MsgAdapter.ReadChar()
	self.level = MsgAdapter.ReadInt()
	self.create_time = MsgAdapter.ReadUInt()
end

-- 创建角色请求
CSCreateRoleReq = CSCreateRoleReq or BaseClass(BaseProtocolStruct)
function CSCreateRoleReq:__init()
	self.msg_type = 7150

	self.plat_name = ""
	self.role_name = ""
	self.login_time = 0
	self.key = ""
	self.plat_server_id = 0
	self.plat_fcm = 0
	self.avatar = 0
	self.sex = 0
	self.prof = 0
	self.plat_spid = ""
end

function CSCreateRoleReq:Encode()
	MsgAdapter.WriteBegin(self.msg_type)
	MsgAdapter.WriteStrN(self.plat_name, 64)
	MsgAdapter.WriteStrN(self.role_name, 32)
	MsgAdapter.WriteUInt(self.login_time)
	MsgAdapter.WriteStrN(self.key, 32)
	MsgAdapter.WriteShort(self.plat_server_id)
	MsgAdapter.WriteChar(self.plat_fcm)
	MsgAdapter.WriteChar(self.avatar)
	MsgAdapter.WriteChar(self.sex)
	MsgAdapter.WriteChar(self.prof)
	MsgAdapter.WriteShort(0)
	MsgAdapter.WriteStrN(self.plat_spid, 4)
end


--------------------------人物天赋请求--------------------------------------------- 
CSRoleTelentOperate = CSRoleTelentOperate or BaseClass(BaseProtocolStruct)
function CSRoleTelentOperate:__init()
	self.msg_type = 7260
end

function CSRoleTelentOperate:Encode()
	MsgAdapter.WriteBegin(self.msg_type)

	MsgAdapter.WriteInt(self.opera_type)
	MsgAdapter.WriteInt(self.param_1)
end


-- 人物天赋信息
SCRoleTelentInfo = SCRoleTelentInfo or BaseClass(BaseProtocolStruct)
function SCRoleTelentInfo:__init()
	self.msg_type = 7261
end

function SCRoleTelentInfo:Decode()
	self.talent_level_list = {}
	for zu = 1, GameEnum.MAX_TELENT_TYPE_COUT do
		self.talent_level_list[zu] = {}
		for i = 1,GameEnum.MAX_TELENT_INDEX_COUT do
			self.talent_level_list[zu][i] = MsgAdapter.ReadChar()
		end
	end
	self.talent_point = MsgAdapter.ReadInt()
end
