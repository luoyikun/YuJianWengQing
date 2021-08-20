require("game/open_fun/open_fun_data")
OpenFunCtrl = OpenFunCtrl or BaseClass(BaseController)

function OpenFunCtrl:__init()
	if OpenFunCtrl.Instance then
		print_error("[OpenFunCtrl] Attemp to create a singleton twice !")
	end
	OpenFunCtrl.Instance = self
	self.data = OpenFunData.New()
	self:RegisterAllProtocols()
end

function OpenFunCtrl:__delete()
	self.data:DeleteMe()
	OpenFunCtrl.Instance = nil
end

function OpenFunCtrl:RegisterAllProtocols()
	self:RegisterProtocol(SCAdvanceNoticeInfo, "OnAdvanceNoticeInfo")
end

function OpenFunCtrl:OnAdvanceNoticeInfo(protocol)
	if protocol.notice_type == ADVANCE_NOTICE_TYPE.ADVANCE_NOTICE_TYPE_DAY then
		self.data:SetDayTrailerLastRewardId(protocol.notice_day_fectch_flag_list)
		MainUICtrl.Instance:FlushView("icon_group_1")
	else
		self.data:SetTrailerLastRewardId(protocol.last_fecth_id)
		ViewManager.Instance:FlushView(ViewName.Main, "trailerview")
	end
end

function OpenFunCtrl:SendAdvanceNoitceOperate(operate_type, param_1)
	local protocol = ProtocolPool.Instance:GetProtocol(CSAdvanceNoitceOperate)
	protocol.operate_type = operate_type
	protocol.param_1 = param_1 or 0
	protocol:EncodeAndSend()
end