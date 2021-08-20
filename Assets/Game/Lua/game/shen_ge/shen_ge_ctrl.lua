require("game/shen_ge/shen_ge_data")
require("game/shen_ge/shen_ge_view")
require("game/shen_ge/shen_ge_shen_ge_view")
require("game/shen_ge/shen_ge_bless_view")
require("game/shen_ge/shen_ge_godbody_view")
require("game/shen_ge/shen_ge_group_view")
require("game/shen_ge/shen_ge_inlay_view")
require("game/shen_ge/shen_ge_compose_view")
require("game/shen_ge/shen_ge_select_view")
require("game/shen_ge/shen_ge_operate_view")
require("game/shen_ge/shen_ge_attr_view")
require("game/shen_ge/shen_ge_upgrade_view")
require("game/shen_ge/shen_ge_decompose_view")
require("game/shen_ge/shen_ge_decompose_detail_view")
require("game/shen_ge/shen_ge_bless_prop_tip")
require("game/shen_ge/shen_ge_zhangkong_view")
require("game/shen_ge/shen_ge_preview_view")
require("game/shen_ge/shen_ge_item_tips")
require("game/shen_ge/shen_ge_fenjie")


ShenGeCtrl = ShenGeCtrl or BaseClass(BaseController)

function ShenGeCtrl:__init()
	if nil ~= ShenGeCtrl.Instance then
		return
	end

	ShenGeCtrl.Instance = self

	self.data = ShenGeData.New()
	self.view = ShenGeView.New(ViewName.ShenGeView)
	self.compose_view = ShenGeComposeView.New(ViewName.ShenGeComposeView)
	self.select_view = ShenGeSelectView.New(ViewName.ShenGeSelectView)
	self.operate_view = ShenGeOperateView.New(ViewName.ShenGeOperateView)
	self.attr_view = ShenGeAttrView.New(ViewName.ShenGeAttrView)
	self.upgrade_view = ShenGeUpgradeView.New(ViewName.ShenGeUpgradeView)
	self.decompose_view = ShenGeDecomposeView.New(ViewName.ShenGeDecomposeView)
	self.decompose_detail_view = ShenGeDecomposeDetailView.New(ViewName.ShenGeDecomposeDetailView)
	self.bless_prop_view = ShenGePropTipView.New(ViewName.ShenGePropTipView)
	self.pre_view = ShenGePreviewView.New(ViewName.ShenGePreview)
	self.tips_view = ShenGeItemTips.New(ViewName.ShenGeItemTips)
	self.fenjie_view = ShenGeFenJie.New(ViewName.ShenGeFenJie)
	self:RegisterAllProtocols()
end

function ShenGeCtrl:RegisterAllProtocols()
	self:RegisterProtocol(SCShengeSystemBagInfo, "OnShengeSystemBagInfo") 	--	神格信息
	self:RegisterProtocol(SCShengeZhangkongInfo,"OnShengeZhangkongTotalInfo")   --	神格掌控总信息
	self:RegisterProtocol(SCZhangkongSingleChange,"OnShengeZhangkongSingleInfo")	--	神格掌控单个信息
	self:RegisterProtocol(SCShengeShenquAllInfo,"OnShengeShenquAllInfo")	--	神格神躯所有信息
	self:RegisterProtocol(SCShengeShenquInfo,"OnShengeShenquInfo")	--	神格神躯单个信息
	self:RegisterProtocol(SCShenggeSuitInfo,"OnShenggeSuitInfo")	--	神格品质信息
end

function ShenGeCtrl:__delete()
	self:CacleDelayTime()
	self:CacleSendDelayTime()
	ShenGeCtrl.Instance = nil

	self.view:DeleteMe()
	self.view = nil

	self.data:DeleteMe()
	self.data = nil

	self.fenjie_view:DeleteMe()
	self.fenjie_view = nil

	self.compose_view:DeleteMe()
	self.compose_view = nil

	self.select_view:DeleteMe()
	self.select_view = nil

	self.operate_view:DeleteMe()
	self.operate_view = nil

	self.attr_view:DeleteMe()
	self.attr_view = nil

	self.upgrade_view:DeleteMe()
	self.upgrade_view = nil

	self.decompose_view:DeleteMe()
	self.decompose_view = nil

	self.decompose_detail_view:DeleteMe()
	self.decompose_detail_view = nil

	self.bless_prop_view:DeleteMe()
	self.bless_prop_view = nil

	if self.tips_view ~= nil then
		self.tips_view:DeleteMe()
		self.tips_view = nil
	end
end

function ShenGeCtrl:OnShengeSystemBagInfo(protocol)
	-- 右下角漂浮文本
	if SHENGE_SYSTEM_INFO_TYPE.SHENGE_SYSTEM_INFO_TYPE_ALL_MARROW_SCORE_INFO == protocol.info_type then
		self:ShowFloatText(protocol)
	end

	self.data:SetShenGeSystemBagInfo(protocol)
	if self.fenjie_view:IsOpen() then 
		self.fenjie_view:Flush()
	end
	RemindManager.Instance:Fire(RemindName.ShenGe_Bless)
	RemindManager.Instance:Fire(RemindName.ShenGe_ShenGe)
	self.view:Flush()
	-- 弹出恭喜获得UI
	local temp_data = {}
	if SHENGE_SYSTEM_INFO_TYPE.SHENGE_SYSTEM_INFO_TYPE_COMPOSE_SHENGE_INFO == protocol.info_type then
		for i = 1, #protocol.bag_list do
			local bag_index = i - 1
			temp_data[i] = {}
			temp_data[i].item_id = self.data:GetShenGeItemId(protocol.bag_list[bag_index].type, protocol.bag_list[bag_index].quality)
			temp_data[i].num = 1
			temp_data[i].shen_ge_data = protocol.bag_list[bag_index]
			local shenge_attr_ibute_cfg = self.data:GetShenGeAttributeCfg(protocol.bag_list[bag_index].type, protocol.bag_list[bag_index].quality, protocol.bag_list[bag_index].level)
			temp_data[i].shen_ge_kind = shenge_attr_ibute_cfg and shenge_attr_ibute_cfg.kind or 0
		end
		local is_succe = protocol.param1 == 1
		if is_succe then 
		TipsCtrl.Instance:OpenGuildRewardView(temp_data, is_succe)
			GlobalTimerQuest:AddDelayTimer(function()
				TipsCtrl.Instance:CloseGuildRewardView()
				self:AutomaticComposeAction()
				end,1)

		return 
		end
		GlobalTimerQuest:AddDelayTimer(function()
			--self.compose_view:HeChengitem(temp_data)
			self:AutomaticComposeAction()
		end,0.1)
	end
end

-- 神格操作请求
function ShenGeCtrl:SendShenGeSystemReq(info_type, param1, param2, param3, count, virtual_inde_list, select_slot_list)
	local send_protocol = ProtocolPool.Instance:GetProtocol(CSShengeSystemReq)
	send_protocol.info_type = info_type or 0
	send_protocol.param1 = param1 or 0
	send_protocol.param2 = param2 or 0
	send_protocol.param3 = param3 or 0
	send_protocol.param4 = 0

	local param4 = bit:d2b(0)
	if nil ~= select_slot_list and next(select_slot_list) then
		for i = 1, 3 do
			param4[32 - i + 1] = select_slot_list[i]
		end
		send_protocol.param4 = bit:b2d(param4)
	end

	send_protocol.count = count or 0
	send_protocol.virtual_inde_list = virtual_inde_list or {}

	send_protocol:EncodeAndSend()
end

function ShenGeCtrl:SendShenquReq(param1, param2, param3, select_slot_list)
	self:SendShenGeSystemReq(SHENGE_SYSTEM_REQ_TYPE.SHENGE_SYSTEM_REQ_TYPE_XILIAN, param1, param2, param3, nil, nil, select_slot_list)
end

-- 右下角漂浮文本
function ShenGeCtrl:ShowFloatText(protocol)
	local info = self.data:GetShenGeSystemBagInfo(SHENGE_SYSTEM_INFO_TYPE.SHENGE_SYSTEM_INFO_TYPE_ALL_MARROW_SCORE_INFO)
	if nil == info then return end

	local old_fragments = info.param3
	if old_fragments < protocol.param3 then
		local diff = protocol.param3 - old_fragments
		TipsCtrl.Instance:ShowFloatingLabel(string.format(Language.ShenGe.FloatText, diff))
	end
end

function ShenGeCtrl:ShowSelectView(call_back, data_list, from_view , have_data)
	self.select_view:SetSelectCallBack(call_back)
	self.select_view:SetHadSelectData(data_list)
	self.select_view:SetFromView(from_view, have_data)
	self.select_view:Open()
end

function ShenGeCtrl:ShowOperateView(data, is_from_bag, close_call_back)
	self.operate_view:SetIsFromBag(is_from_bag)
	self.operate_view:SetCallBack(close_call_back)
	self.operate_view:SetData(data)
end

function ShenGeCtrl:ShowUpgradeView(data, is_from_bag, close_call_back)
	self.upgrade_view:SetIsFromBag(is_from_bag)
	self.upgrade_view:SetCallBack(close_call_back)
	self.upgrade_view:SetData(data)
end

function ShenGeCtrl:ShowDecomposeDetail(quality, call_back, is_select)
	self.decompose_detail_view:SetQuality(quality)
	self.decompose_detail_view:SetCallBack(call_back)
	self.decompose_detail_view:SetIsSelect(is_select)

	self.decompose_detail_view:Open()
end

function ShenGeCtrl:ShowBlessPropTip(data)
	self.bless_prop_view:SetData(data)
end

------神格掌控协议----
function ShenGeCtrl:OnShengeZhangkongTotalInfo(protocol)
	self.data:SetZhangkongTotalInfo(protocol)
	self.view:Flush()
end

function ShenGeCtrl:OnShengeZhangkongSingleInfo(protocol)
	self.data:SetZhangkongSingleInfo(protocol)
	self.view.zhangkong_view:DataFlush()
	self.view:Flush()
end

function ShenGeCtrl:SetTipsData(data)
	self.tips_view:SetData(data)
end

function ShenGeCtrl:SetTipsCallBack(callback)
	self.tips_view:SetCloseCallBack(callback)
end

-----------神躯---------
function ShenGeCtrl:OnShengeShenquAllInfo(protocol)
	self.data:SetShenquAllInfo(protocol)
	self.view:Flush()
	RemindManager.Instance:Fire(RemindName.ShenGe_Godbody)
end

function ShenGeCtrl:OnShengeShenquInfo(protocol)
	self.data:SetShenquSingleInfo(protocol)
	self.view:Flush()
end

function ShenGeCtrl:OnShenggeSuitInfo(protocol)
	self.data:SetShengGeSuitInfo(protocol)
end

function ShenGeCtrl:OnShenQuChange(value)
	if value == 0 then 
		self.view:Flush("shenqu_info")
	elseif value == 1 then 
		ShenGeData.Instance:SetShenGeZhangKongState(true)
	end
end
----------------------------------神格自动合成------------------------------------------
function ShenGeCtrl:AutomaticComposeAction()
	self:CacleSendDelayTime()
	local flag = self.data:GetAutomaticComposeFlag()

	if flag == SHENGE_AUTOMATIC_COMPOSE_FLAG.NO_START then
		self:RecoverData()
	elseif flag == SHENGE_AUTOMATIC_COMPOSE_FLAG.COMPOSE_REQUIRE then
		self:BeginComposeRequire()
	elseif flag == SHENGE_AUTOMATIC_COMPOSE_FLAG.COMPOSE_CONTINUE then
		self:ComposeContinue()
	else
		self:RecoverData()
	end
end

function ShenGeCtrl:BeginComposeRequire()
	if nil == self.compose_view or not self.compose_view:IsOpen() then
		self:RecoverData()
		return
	end

	local max_select_num = self.data:GetMaxComposeNum()	-- 最大合成数量
	local select_compose_list = self.data:GetCompouseIndexList()
	if 0 == max_select_num or 0 == #select_compose_list or #select_compose_list < max_select_num then
		TipsCtrl.Instance:ShowSystemMsg(Language.ShenGe.MaterialNoEnough) -- 材料不足
		self:RecoverData() -- 取消状态
		return
	end

	self.data:SetAutomaticComposeFlag(SHENGE_AUTOMATIC_COMPOSE_FLAG.COMPOSE_CONTINUE) -- 合成结束
	self:CacleSendDelayTime() -- 取消计时器
	self.delay_send_time = GlobalTimerQuest:AddDelayTimer(BindTool.Bind2(self.RecoverData, self), 5) -- 添加计时器
	--self:SendShenGeSystemReq(SHENGE_SYSTEM_REQ_TYPE.SHENGE_SYSTEM_REQ_TYPE_COMPOSE, select_compose_list[1], select_compose_list[2], select_compose_list[3])
	self.compose_view:OnClickYes();
	-- 发送神格请求
	if self.compose_view and self.compose_view:IsOpen() then
		--self.compose_view:PlayUpStarEffect()		-- 特效动作
		self.compose_view:FlushComposeButton(true) -- 刷新按钮
	end
end
-- 判断是否可以合成
function ShenGeCtrl:ComposeContinue()
	if nil == self.compose_view or not self.compose_view:IsOpen() then
		self:RecoverData()
		return
	end

	local is_continue = self.data:IsCanAutomaticComposeContiue() -- 是否可以继续合成
	if not is_continue then
		self:RecoverData()
		return
	end

	if self.compose_view and self.compose_view:IsOpen() then
		self.compose_view:SetDataSameItem()		-- 添加计时器
	end
	-- 可以合成时，调用合成代码
	self:CacleDelayTime()		-- 移除计时器（并添加新的计时器）
	self.delay_time = GlobalTimerQuest:AddDelayTimer(function()
		self.data:SetAutomaticComposeFlag(SHENGE_AUTOMATIC_COMPOSE_FLAG.COMPOSE_REQUIRE) -- 
		self:BeginComposeRequire()
	end, 0.4)
end
-- 清除数据
function ShenGeCtrl:RecoverData()
	local list = {}
	self.data:SetSelectComposeList(list)
	self.data:SetAutomaticComposeFlag(SHENGE_AUTOMATIC_COMPOSE_FLAG.NO_START)
	self:CacleDelayTime()
	self:CacleSendDelayTime()

	if self.compose_view and self.compose_view:IsOpen() then
		self.compose_view:FlushComposeButton(false)
		self.compose_view:CacleDelayTime()
		self.compose_view:HideProb(false)
	end
end

function ShenGeCtrl:CacleDelayTime()
	if self.delay_time then
		GlobalTimerQuest:CancelQuest(self.delay_time)
		self.delay_time = nil
	end
end

function ShenGeCtrl:CacleSendDelayTime()
	if self.delay_send_time then
		GlobalTimerQuest:CancelQuest(self.delay_send_time)
		self.delay_send_time = nil
	end
end