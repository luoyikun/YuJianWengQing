require("game/recharge_rank/recharge_rank_view")
require("game/recharge_rank/recharge_rank_data")

RechargeRankCtrl = RechargeRankCtrl or BaseClass(BaseController)
function RechargeRankCtrl:__init()
	if RechargeRankCtrl.Instance then
		print_error("[RechargeRankCtrl] Attemp to create a singleton twice !")
	end
	RechargeRankCtrl.Instance = self

	self.recharge_rank_data = RechargeRankData.New()
	self.recharge_rank_view = RechargeRankView.New(ViewName.RechargeRank)

	self:RegisterAllProtocols()
	self.main_view_complete = GlobalEventSystem:Bind(MainUIEventType.MAINUI_OPEN_COMLETE, BindTool.Bind(self.MianUIOpenComlete, self))
end

function RechargeRankCtrl:__delete()
	RechargeRankCtrl.Instance = nil

	if self.recharge_rank_view then
		self.recharge_rank_view:DeleteMe()
		self.recharge_rank_view = nil
	end
	if self.recharge_rank_data then
		self.recharge_rank_data:DeleteMe()
		self.recharge_rank_data = nil
	end

	if self.main_view_complete then
    	GlobalEventSystem:UnBind(self.main_view_complete)
        self.main_view_complete = nil
    end
end

function RechargeRankCtrl:RegisterAllProtocols()
	self:RegisterProtocol(SCRAChongzhiRankInfo, "OnRAChongzhiRankInfo")
end

function RechargeRankCtrl:OnRAChongzhiRankInfo(protocol)
	RemindManager.Instance:Fire(RemindName.RechargeRankRemind)
	self.recharge_rank_data:SetRandActRecharge(protocol.chongzhi_num)
	self.recharge_rank_view:Flush()
end

function RechargeRankCtrl:MianUIOpenComlete()
	local is_open = ActivityData.Instance:GetActivityIsOpen(ACTIVITY_TYPE.RAND_CHONGZHI_RANK)
	if is_open then
		-- 请求活动信息
	 	KaifuActivityCtrl.Instance:SendGetKaifuActivityInfo(ACTIVITY_TYPE.RAND_CHONGZHI_RANK)
	end
end

function RechargeRankCtrl:RemindChangeCallBack(remind_name, num)
	if remind_name == RemindName.RechargeRankRemind then
		ActivityData.Instance:SetActivityRedPointState(ACTIVITY_TYPE.RAND_CHONGZHI_RANK, num > 0)
	end
end