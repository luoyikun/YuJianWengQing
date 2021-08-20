require("game/lucky_chess/lucky_chess_data")
require("game/lucky_chess/lucky_chess_view")

LuckyChessCtrl = LuckyChessCtrl or BaseClass(BaseController)

function LuckyChessCtrl:__init()
	if LuckyChessCtrl.Instance then
		print_error("[LuckyChessCtrl]:Attempt to create singleton twice!")
	end
	LuckyChessCtrl.Instance = self

	self.view = LuckyChessView.New(ViewName.LuckyChessView)
	self.data = LuckyChessData.New()

	self.activity_call_back = BindTool.Bind(self.ActivityCallBack, self)
	ActivityData.Instance:NotifyActChangeCallback(self.activity_call_back)

	self.remind_change = BindTool.Bind(self.RemindChangeCallBack, self)
	RemindManager.Instance:Bind(self.remind_change, RemindName.RemindLuckyChess)

	self:RegisterAllProtocols()
end

function LuckyChessCtrl:__delete()
	if self.view then
		self.view:DeleteMe()
		self.view = nil
	end

	if self.data then
		self.data:DeleteMe()
		self.data = nil
	end

	if self.activity_call_back then
		ActivityData.Instance:UnNotifyActChangeCallback(self.activity_call_back)
		self.activity_call_back = nil
	end

	if self.remind_change then
		RemindManager.Instance:UnBind(self.remind_change)
		self.remind_change = nil
	end

	LuckyChessCtrl.Instance = nil
end

function LuckyChessCtrl:RegisterAllProtocols()
	self:RegisterProtocol(SCPromotingPositionAllInfo, "OnPromotingPositionAllInfo")		--步步高升
	self:RegisterProtocol(SCPromotingPositionRewardInfo, "OnPromotingPositionRewardInfo")
end

--打开步步高升
function LuckyChessCtrl:Open()
	self.data:SetDayDayUpShowData()
	self.view:Open()
end

function LuckyChessCtrl:Flush(param)
	self.view:Flush(param)
end

function LuckyChessCtrl:OpenDayDayUpShowView()
	if self.day_day_up_show_view:IsOpen() then
		self.day_day_up_show_view:Flush()
	else
		self.day_day_up_show_view:Open()
		self.day_day_up_show_view:Flush()
	end
end

function LuckyChessCtrl:OnPromotingPositionAllInfo(protocol)
	self.timer = Status.NowTime + 10
	self.data:SetPromotingPositionAllInfo(protocol)
	if nil ~= self.view then 
		self.view:FlushLeftContent()
	end
	RemindManager.Instance:Fire(RemindName.RemindLuckyChess)
end

function LuckyChessCtrl:OnPromotingPositionRewardInfo(protocol)
	self.data:ClearTreasureViewShowList()
	self.data:SetPromotingPositionRewardInfo(protocol)
	if #self.data:GetTreasureViewShowList() >= 3 then
		TipsCtrl.Instance:ShowTreasureView(CHEST_SHOP_MODE.CHEST_RANK_LUCK_CHESS_10)
		self:SendAllInfoReq()
	end
	self.view:Flush()
	RemindManager.Instance:Fire(RemindName.RemindLuckyChess)
end

function LuckyChessCtrl:SendAllInfoReq()
	KaifuActivityCtrl.Instance:SendGetKaifuActivityInfo(ACTIVITY_TYPE.RAND_ACTIVITY_TYPE_DAY_DAY_UP, 
														RA_PROMOTING_POSITION_OPERA_TYPE.RA_PROMOTING_POSITION_OPERA_TYPE_ALL_INFO)
end

function LuckyChessCtrl:ActivityCallBack(activity_type, status)
	if activity_type == ACTIVITY_TYPE.RAND_ACTIVITY_TYPE_DAY_DAY_UP and status == ACTIVITY_STATUS.OPEN then
		self:SendAllInfoReq()
	end 
end

function LuckyChessCtrl:RemindChangeCallBack(remind_name, num)
	if remind_name == RemindName.RemindLuckyChess then
		ActivityData.Instance:SetActivityRedPointState(ACTIVITY_TYPE.RAND_ACTIVITY_TYPE_DAY_DAY_UP, num > 0)
	end
end