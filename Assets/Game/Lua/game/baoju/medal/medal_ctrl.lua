require("game/baoju/medal/medal_data")

MedalCtrl = MedalCtrl or BaseClass(BaseController)

function MedalCtrl:__init()
	if MedalCtrl.Instance then
		print_error("[MedalCtrl] 尝试创建第二个单例模式")
		return
	end
	MedalCtrl.Instance = self

	self.data = MedalData.New()
	self.view = nil

	self:RegisterAllProtocols()
end

function MedalCtrl:RegisterView(view)
	self.view = view
end

function MedalCtrl:UnRegisterView()
	self.view = nil
end

function MedalCtrl:__delete()
	self.data:DeleteMe()
	self.data = nil
	MedalCtrl.Instance = nil
end

function MedalCtrl:RegisterAllProtocols()
	self:RegisterProtocol(SCAllXunZhangInfo, "SyncMedalInfo")
end

function MedalCtrl:SyncMedalInfo(protocol)
	self.data:SetMedalInfo(protocol)
	if self.view ~= nil then
		--self.view:FlushScroller()
		--self.view:FlushEffect()
		self.view:SelectIcon()
		self.view:NewFlushNowData()
		self.view:IsRedPointShow()
	end
end

function MedalCtrl:ShowCurrentIcon()
	if self.view ~= nil then
		self.view:ShowCurrentIcon()
	end
end

--升级勋章
function MedalCtrl:SendMedalUpgrade(medal_id, is_only_use_bind)
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSXunZhangUplevelReq)
	send_protocol.xunzhang_id= medal_id
	send_protocol.is_only_bind = is_only_use_bind
	print("发送升级勋章",'xunzhang_id',send_protocol.xunzhang_id,'is_only_bind',send_protocol.is_only_bind)
	send_protocol:EncodeAndSend()
end