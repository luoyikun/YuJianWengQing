-- require("game/forge/forge_base")
require("game/forge/forge_view")
require("game/forge/forge_data")
require("game/forge/forge_gem_list_view")
require("game/forge/forge_jade_list_view")
require("game/forge/forge_clear_item_list_view")
require("game/forge/forge_jade_bag_view")
require("game/forge/forge_jade_bag_fenjie_view")
require("game/forge/convert_jade_view")
require("game/forge/forge_exchange_equip_list_view")

ForgeCtrl = ForgeCtrl or BaseClass(BaseController)

function ForgeCtrl:__init()
	if nil ~= ForgeCtrl.Instance then
		print_error("[ForgeCtrl] attempt to create singleton twice!")
		return
	end
	ForgeCtrl.Instance = self
	self.forge_view = ForgeView.New(ViewName.Forge)
	self.forge_data = ForgeData.New()
	self.forge_gem_list_view = ForgeGemListView.New()
	self.forge_jade_list_view = ForgeJadeListView.New()
	self.forge_clear_item_list_view = ForgeClearItemListView.New()
	self.forge_jade_bag_view = ForgeJadeBagView.New(ViewName.ForgeJadeBag)
	self.forge_convert_jade_view = ConvertJadeBagView.New(ViewName.ForgeConvertJade)
	self.forge_jade_bag_fenjie_view = ForgeJadeBagFenJieView.New(ViewName.ForgeJadeBagFenJie)
	self.forge_compose_equip_lsit_view = ForgeExchangeEquipListView.New()
	self:RegisterAllProtocols()
	self:BindGlobalEvent(OtherEventType.OPERATE_RESULT, BindTool.Bind1(self.OnOperateResult, self), result)
	-- GlobalEventSystem:Bind(MainUIEventType.MAINUI_OPEN_COMLETE, BindTool.Bind1(self.MainOpenComplete, self))

	self.score_change_callback = BindTool.Bind1(self.ScoreDataChange, self)
	ExchangeCtrl.Instance:NotifyWhenScoreChange(self.score_change_callback)

	
end

function ForgeCtrl:__delete()
	if nil ~= self.forge_view then
		self.forge_view:DeleteMe()
		self.forge_view = nil
	end

	if nil ~= self.forge_data then
		self.forge_data:DeleteMe()
		self.forge_data = nil
	end

	if self.score_change_callback then
		ExchangeCtrl.Instance:UnNotifyWhenScoreChange(self.score_change_callback)
		self.score_change_callback = nil
	end

	if self.forge_gem_list_view then
		self.forge_gem_list_view:DeleteMe()
		self.forge_gem_list_view = nil
	end

	if self.forge_jade_list_view then
		self.forge_jade_list_view:DeleteMe()
		self.forge_jade_list_view = nil
	end

	if self.forge_clear_item_list_view then
		self.forge_clear_item_list_view:DeleteMe()
		self.forge_clear_item_list_view = nil
	end

	if self.forge_jade_bag_view then
		self.forge_jade_bag_view:DeleteMe()
		self.forge_jade_bag_view = nil
	end

	if self.forge_convert_jade_view then
		self.forge_convert_jade_view:DeleteMe()
		self.forge_convert_jade_view = nil
	end

	if self.forge_jade_bag_fenjie_view then
		self.forge_jade_bag_fenjie_view:DeleteMe()
		self.forge_jade_bag_fenjie_view = nil
	end

	if self.forge_compose_equip_lsit_view then
		self.forge_compose_equip_lsit_view:DeleteMe()
		self.forge_compose_equip_lsit_view = nil
	end

	ForgeCtrl.Instance = nil
end

-- ????????????
function ForgeCtrl:RegisterAllProtocols()
	self:RegisterProtocol(CSEquipCompound)
	--self:RegisterProtocol(SCEquipCompoundRet, "OnEquipCompoundRet")
	self:RegisterProtocol(SCStoneInfo, "OnGemInfo")
	self:RegisterProtocol(SCNoticeWuqiColor, "OnSCNoticeWuqiColor")
	self:RegisterProtocol(SCDuanzaoSuitInfo, "OnDuanzaoSuitInfo")
	self:RegisterProtocol(SCFeixianEquipInfo,"OnFeixianEquip")
	
	-- ?????????
	self:RegisterProtocol(CSBaizhanEquipOpera)
	self:RegisterProtocol(SCBaizhanEquipAllInfo,"OnSCBaizhanEquipAllInfo")

	-- ?????????
	self:RegisterProtocol(SCZhuanzhiEquipInfo,"OnSCZhuanzhiEquipInfo")
	self:RegisterProtocol(SCZhuanzhiStoneInfo,"OnSCZhuanzhiStoneInfo")
	self:RegisterProtocol(SCZhuanzhiSuitInfo,"OnSCZhuanzhiSuitInfo")
	self:RegisterProtocol(SCEquipBaptizeAllInfo,"OnSCEquipBaptizeAllInfo")

	-- ??????
	self:RegisterProtocol(SCZhuanzhiEquipAwakeningAllInfo,"OnSCZhuanzhiEquipAwakeningAllInfo")
	self:RegisterProtocol(SCZhuanzhiEquipAwakeningInfo,"OnSCZhuanzhiEquipAwakeningInfo")

	self:RegisterProtocol(SCZhuanzhiEquipComposeSucceed,"OnSCZhuanzhiEquipComposeSucceed")
end

function ForgeCtrl:OpenViewToIndex(index, sub_type)
	if not OpenFunData.Instance:CheckIsHide("forge_strengthen") then
		SysMsgCtrl.Instance:ErrorRemind(Language.Forge.FunOpenTip)
		return
	end
	if EquipData.Instance:IsZhuanzhiEquipType(sub_type) then
		self.forge_view:Open(TabIndex.forge_up_star)
	else
		self.forge_view:Open()
	end
	-- self.forge_view:SetTargetEquipIndex(index)
end

--????????????????????????
function ForgeCtrl:OnSCNoticeWuqiColor(protocol)
	local obj = Scene.Instance:GetObj(protocol.obj_id)
	if nil == obj then
		return
	end
	obj:SetAttr("wuqi_color", protocol.wuqi_color)
	if obj:IsMainRole() then
		GlobalEventSystem:Fire(OtherEventType.EQUIP_DATA_CHANGE)
	end
end


-- ??????????????????
function ForgeCtrl:SendEquipJinjie(equi_index)
	local protocol_send = ProtocolPool.Instance:GetProtocol(CSEquipCompound)
	protocol_send.equi_index = equi_index or 0
	protocol_send:EncodeAndSend()
end

-- -- ????????????
-- function ForgeCtrl:OnEquipCompoundRet(protocol)
-- 	self.forge_data:SetIsComposeSucc(protocol.is_succ)
-- 	RemindManager.Instance:Fire(RemindName.Forge)
-- 	if self.forge_view:IsOpen() then
-- 		self.forge_view:Flush("after_compose")
-- 	end
-- end

--??????????????????
function ForgeCtrl:SendUpStarReq(equip_index)
	local protocol = ProtocolPool.Instance:GetProtocol(CSEquipUpStar)
	protocol.equip_index = equip_index
	protocol:EncodeAndSend()
end



function ForgeCtrl:FlushRedPoint()
	-- self.forge_view:FlushRedPoint()
end

function ForgeCtrl:MainOpenComplete()
	-- self.forge_data:SetAllRedPoint()
	-- RemindManager.Instance:Fire(RemindName.Forge)
end

function ForgeCtrl:ScoreDataChange()
	-- self.forge_data:SetAllRedPoint()
	-- RemindManager.Instance:Fire(RemindName.Forge)
	-- if self.forge_view:IsOpen() then
	-- 	self:FlushRedPoint()
	-- end
end

--?????????????????????????????????????????????
-- function ForgeCtrl:OnSCEquipmentItemChange(protocol)
-- 	self.forge_view:Flush("up_base_quality")
-- 	RemindManager.Instance:Fire(RemindName.ForgeBaseEquip)
-- end

--????????????
function ForgeCtrl:OnDuanzaoSuitInfo(protocol)
	-- self.forge_data:SetForgeSuitInfo(protocol)
	-- RemindManager.Instance:Fire(RemindName.ForgeSuit)
	-- if self.forge_view:IsOpen() then
	-- 	self.forge_view:OnSuitStrengthenCallBack()
	-- end
end

-- ????????????
function ForgeCtrl:OnFeixianEquip(protocol)
	-- print_error(protocol)
	self.forge_data:SetFeixianInfo(protocol)
	-- if nil ~= self.forge_view.fly_immed_view and self.forge_view.fly_immed_view:IsOpen() then 
	-- 	self.forge_view.fly_immed_view:SetFeixianNeed() 
	-- 	self.forge_view.fly_immed_view:CleanState()
	-- 	self.forge_view.fly_immed_view:Flush()
	-- end
end
-- ????????????(???????????????/????????????????????????param1)
function ForgeCtrl:SendFeixianEquipReq(operate_type , param1 , param2 , param3)
	local protocol = ProtocolPool.Instance:GetProtocol(CSFeixianEquipOpe)
	protocol.operate_type = operate_type
	protocol.param1 = param1 or 0
	protocol.param2 = param2 or 0
	protocol.param3 = param3 or 0
	protocol:EncodeAndSend()
end
function ForgeCtrl:FeixianOrangeCallBack(protocol)
	if nil ~= self.forge_view.fly_immed_view and self.forge_view.fly_immed_view:IsOpen() then 
		self.forge_view.fly_immed_view:Flush()
		if nil ~= self.forge_view.fly_immed_view.panel_succ and protocol.result == 1 then
			self.forge_view.fly_immed_view:ShowSucc(protocol,"Orange")
		end
	end
end
function ForgeCtrl:FeixianRedCallBack(protocol)
	if nil ~= self.forge_view.fly_immed_view and self.forge_view.fly_immed_view:IsOpen() then 
		self.forge_view.fly_immed_view:Flush()
		if nil ~= self.forge_view.fly_immed_view.panel_succ and protocol.result == 1 then
			self.forge_view.fly_immed_view:ShowSucc(protocol,"Red")
		end
	end
end
--????????????
function ForgeCtrl:SendSuitStrengthReq(operate_type, equip_index)
	local protocol = ProtocolPool.Instance:GetProtocol(CSDuanzaoSuitReq)
	protocol.operate_type = operate_type
	protocol.equip_index = equip_index
	protocol:EncodeAndSend()
end

function ForgeCtrl:SendUseFaZhenReq(eternity_level)
	local protocol = ProtocolPool.Instance:GetProtocol(CSEquipUseEternityLevel)
	protocol.eternity_level = eternity_level or 0
	protocol:EncodeAndSend()
end

function ForgeCtrl:FlushView()
	self.forge_view:Flush()
end

function ForgeCtrl:PlaySuccedEffet()
	self.forge_view:PlaySuccedEffet()
end

---------------------------------
-----------------??????
function ForgeCtrl:SendUpLevelReq(equip_index, is_auto_buy, use_lucky_item_num)
	local protocol_send = ProtocolPool.Instance:GetProtocol(CSEquipUpLevel)
	protocol_send.equip_index = equip_index
	protocol_send.is_auto_buy = is_auto_buy or 0
	protocol_send.use_lucky_item= use_lucky_item_num or 0
	protocol_send.is_puton = 1
	protocol_send.select_bind_first = 1
	protocol_send:EncodeAndSend()
end

function ForgeCtrl:FLushAdvanceView()
	self.forge_view:Flush("advance")
	RemindManager.Instance:Fire(RemindName.ForgeAdvance)
end


---------------------------------
-----------------??????
--????????????
function ForgeCtrl:SendQianghua(equip_index, is_auto_buy, use_lucky_item)
	local protocol = ProtocolPool.Instance:GetProtocol(CSEquipStrengthen)
	protocol.equip_index = equip_index
	protocol.is_auto_buy = is_auto_buy
	protocol.use_lucky_item = use_lucky_item
	protocol.is_puton = 1
	protocol:EncodeAndSend()
	-- print("????????????",'equip_index', protocol.equip_index, 'is_auto_buy', protocol.is_auto_buy, 'use_lucky_item', protocol.use_lucky_item)
end

--?????????????????????
function ForgeCtrl:OnOperateResult(operate, result, param1, param2)
	if operate == MODULE_OPERATE_TYPE.OP_EQUIP_STRENGTHEN then
		-- print_log("?????????????????????",result)

		-- ????????????????????????
		if self.forge_view and self.forge_view:GetStrengthenView() then
			self.forge_view:GetStrengthenView():ShowStrengthenEffect(result)
		end

		self.forge_view:Flush("strengthen")
		RemindManager.Instance:Fire(RemindName.ForgeStrengthen)
		if 1 == result then
			GlobalEventSystem:Fire(OtherEventType.EQUIP_DATA_CHANGE)
			RemindManager.Instance:Fire(RemindName.ForgeStrengthen)
			if ActivityData.Instance:GetActivityIsOpen(RA_OPEN_SERVER_ACTIVITY_TYPE.RAND_ACTIVITY_TYPE_EQUIP_STRENGHTEN) then
				KaifuActivityCtrl.Instance:SendGetKaifuActivityInfo(RA_OPEN_SERVER_ACTIVITY_TYPE.RAND_ACTIVITY_TYPE_EQUIP_STRENGHTEN,
					RA_OPEN_SERVER_OPERA_TYPE.RA_OPEN_SERVER_OPERA_TYPE_REQ_INFO)
			end
			CompetitionActivityCtrl.Instance:SendGetBipinInfo()
		end
	end
end

function ForgeCtrl:FLushStrengthView()
	self.forge_view:Flush("strengthen")
	RemindManager.Instance:Fire(RemindName.ForgeStrengthen)
end
---------------------------------
-----------------??????
-- ????????????,??????/?????????????????????
function ForgeCtrl:OnGemInfo(protocol)
	self.forge_data:SetGemInfo(protocol)
	if self.forge_view:IsOpen() then
		self.forge_view:Flush("gem")
	end
	RemindManager.Instance:Fire(RemindName.ForgeBaoshi)

	if ActivityData.Instance:GetActivityIsOpen(RA_OPEN_SERVER_ACTIVITY_TYPE.RAND_ACTIVITY_TYPE_UPGRADE_GEMSTONE) then
		KaifuActivityCtrl.Instance:SendGetKaifuActivityInfo(RA_OPEN_SERVER_ACTIVITY_TYPE.RAND_ACTIVITY_TYPE_UPGRADE_GEMSTONE,
			RA_OPEN_SERVER_OPERA_TYPE.RA_OPEN_SERVER_OPERA_TYPE_REQ_INFO)
	end
	CompetitionActivityCtrl.Instance:SendGetBipinInfo()
end

--??????????????????
function ForgeCtrl:SendStoneInfo()
	local protocol = ProtocolPool.Instance:GetProtocol(SCReqStoneInfo)
	protocol:EncodeAndSend()
end

--????????????	(?????????????????????????????????)
function ForgeCtrl:SendStoneUpgrade(equip_index ,stone_slot, uplevel_type)
	local protocol = ProtocolPool.Instance:GetProtocol(CSStoneUpgrade)
	protocol.equip_part = equip_index
	protocol.stone_slot = stone_slot
	protocol.uplevel_type = uplevel_type
	protocol.reserve = 0
	protocol:EncodeAndSend()
end

--????????????   (???????????????????????????????????? ???????????????????????????, is_inlay 0.??????  1.??????)
function ForgeCtrl:SendStoneInlay(equip_index, stone_slot, stone_index, is_inlay)
	local protocol = ProtocolPool.Instance:GetProtocol(CSStoneInlay)
	protocol.equip_part = equip_index
	protocol.stone_slot = stone_slot
	protocol.stone_index = stone_index
	protocol.is_inlay = is_inlay
	protocol:EncodeAndSend()
end

function ForgeCtrl:SendBaiZhanOpera(operate, param1, param2)
	local protocol = ProtocolPool.Instance:GetProtocol(CSBaizhanEquipOpera)
	protocol.operate = operate or 0
	protocol.param1 = param1 or 0
	protocol.param2 = param2 or 0
	protocol:EncodeAndSend()
end

function ForgeCtrl:FLushGemView()
	self.forge_view:Flush("gem")
	RemindManager.Instance:Fire(RemindName.ForgeBaoshi)
end

function ForgeCtrl:OpenGemListView(data_list)
	self.forge_gem_list_view:SetGemListData(data_list)
end

---------------------------------
-----------------??????
--?????????????????????
function ForgeCtrl:SendUpQualityReq(equip_index)
	local protocol_send = ProtocolPool.Instance:GetProtocol(CSEquipUpQuality)
	protocol_send.equip_index = equip_index
	protocol_send.is_puton = 1 
	--??????????????????????????????
	protocol_send.select_bind_first = 1
	protocol_send:EncodeAndSend()
end

function ForgeCtrl:FLushQualityView()
	self.forge_view:Flush("quality")
	RemindManager.Instance:Fire(RemindName.ForgeQuality)
end

---------------------------------
-----------------??????(??????)

function ForgeCtrl:SendEquipUpEternityReq(equip_index, is_auto_buy)
	local protocol = ProtocolPool.Instance:GetProtocol(CSEquipUpEternity)
	protocol.equip_index = equip_index or 0
	protocol.is_auto_buy = is_auto_buy or 0
	protocol:EncodeAndSend()
end

function ForgeCtrl:FlushYongHengView()
	if self.forge_view:IsOpen() then
		self.forge_view:Flush("yongheng")
		RemindManager.Instance:Fire(RemindName.ForgeYongheng)
	end
end

---------------------------------
----------------??????????????????
--????????????
function ForgeCtrl:SendCast(index)
	local protocol = ProtocolPool.Instance:GetProtocol(CSEquipShenZhu)
	protocol.equip_index = index
	protocol.is_puton = 1
	protocol:EncodeAndSend()
end

-- ??????????????????
function ForgeCtrl:FlushShenZhuView()
	if self.forge_view:IsOpen() then
		self.forge_view:Flush("cast")
		RemindManager.Instance:Fire(RemindName.ForgeCast)
	end
end

------------------------------
------ ?????????
-- ?????? p1: part_index
-- ?????? p1: part_index
-- ?????? p1: part_index
-- ???????????? p1: part_index p2: slot_index p3: bag_index
-- ???????????? p1: part_index p2: slot_index 
-- ????????????	p1: part_index p2: slot_index 
-- ???????????? p1: part_index p2: seq p3: is_autobuy
-- ????????????	p1: suit_index p2: part_index
function ForgeCtrl:SendCSZhuanzhiEquipOpe(operate_type, param_1, param_2, param_3, param_4, param_5)
	local protocol = ProtocolPool.Instance:GetProtocol(CSZhuanzhiEquipOpe)
	protocol.operate_type = operate_type
	protocol.param_1 = param_1 or 0
	protocol.param_2 = param_2 or 0
	protocol.param_3 = param_3 or 0
	protocol.param_4 = param_4 or 0
	protocol.param_5 = param_5 or 0
	protocol:EncodeAndSend()
end

-- ??????????????????
function ForgeCtrl:OnSCZhuanzhiEquipInfo(protocol)
	self.forge_data:SetZhuanzhiEquipInfo(protocol)
	self:FlushUpStarView()
	-- self:FlushDeityIntersifyView()
end

-- ??????????????????
function ForgeCtrl:OnSCBaizhanEquipAllInfo(protocol)
	self.forge_data:SetBaiZhanEquipInfo(protocol)
end

---------------------------------
----------------??????
-- ??????????????????
function ForgeCtrl:FlushUpStarView()
	if self.forge_view:IsOpen() then
		self.forge_view:Flush("up_star")
		RemindManager.Instance:Fire(RemindName.ForgeUpStar)
	end
end

---------------------------------
----------------??????
-- ??????????????????
function ForgeCtrl:OnSCZhuanzhiStoneInfo(protocol)
	self.forge_data:SetZhuanzhiStoneInfo(protocol)
	if self.forge_view:IsOpen() then
		self.forge_view:Flush("jade")
	end
	RemindManager.Instance:Fire(RemindName.ForgeJade)

	self:FlushJadeRefineView()

	if self.forge_jade_bag_view and self.forge_jade_bag_view:IsOpen() then
		self.forge_jade_bag_view:Flush()
	end

	if self.forge_convert_jade_view and self.forge_convert_jade_view:IsOpen() then
		self.forge_convert_jade_view:Flush()
	end
	
	if self.forge_jade_bag_fenjie_view and self.forge_jade_bag_fenjie_view:IsOpen() then
		self.forge_jade_bag_fenjie_view:Flush()
	end
end

-- open_type 1:???????????? 2???????????????
function ForgeCtrl:OpenJadeBag(open_type)
	if self.forge_jade_bag_view and open_type == 1 then
		self.forge_jade_bag_view:SetOpenTypeData(open_type)
	elseif open_type == 2 then
		if self.forge_convert_jade_view:IsOpen() then
			self.forge_convert_jade_view:Flush()
		else
			self.forge_convert_jade_view:Open()
		end
	end

end

function ForgeCtrl:OpenJadeListView(data_list)
	self.forge_jade_list_view:SetJadeListData(data_list)
end

---------------------------------
----------------????????????
-- ????????????????????????
function ForgeCtrl:FlushJadeRefineView()
	if self.forge_view:IsOpen() then
		self.forge_view:Flush("jade_refine")
		RemindManager.Instance:Fire(RemindName.ForgeJadeRefine)
	end
end

---------------------------------
----------------??????/??????
function ForgeCtrl:SendCSEquipBaptizeOperaReq(operate_type, param_1, param_2, param_3)
	local protocol = ProtocolPool.Instance:GetProtocol(CSEquipBaptizeOperaReq)
	protocol.operate_type = operate_type
	protocol.param_1 = param_1 or 0
	protocol.param_2 = param_2 or 0
	protocol.param_3 = param_3 or 0
	protocol:EncodeAndSend()
end

-- ??????????????????
function ForgeCtrl:OnSCEquipBaptizeAllInfo(protocol)
	-- print_error(protocol)
	self.forge_data:SetSCEquipBaptizeAllInfo(protocol)
	if self.forge_view:IsOpen() then
		self.forge_view:Flush("deity_intersify")
		RemindManager.Instance:Fire(RemindName.ForgeDeityIntersify)
	end	
end

function ForgeCtrl:OpenClearItemListView(call_back)
	self.forge_clear_item_list_view:SetListData(call_back)
end

-- function ForgeCtrl:FlushDeityIntersifyView()
-- 	if self.forge_view:IsOpen() then
-- 		self.forge_view:Flush("deity_intersify")
-- 		RemindManager.Instance:Fire(RemindName.ForgeDeityIntersify)
-- 	end	
-- end

--------------------------------
------------- ????????????
function ForgeCtrl:OnSCZhuanzhiSuitInfo(protocol)
	self.forge_data:SetZhuanzhiSuitInfo(protocol)
	if self.forge_view:IsOpen() then
		self.forge_view:Flush("deity_suit")
		RemindManager.Instance:Fire(RemindName.ForgeDeitySuit)
	end
end


--------------????????????---------------
function ForgeCtrl:OnSCZhuanzhiEquipAwakeningAllInfo(protocol)
	self.forge_data:SetZhuanzhiEquipAwakeningAllInfo(protocol)
	if self.forge_view:IsOpen() then
		self.forge_view:Flush("jue_xing")
		RemindManager.Instance:Fire(RemindName.ForgeJueXing)
	end
end

function ForgeCtrl:OnSCZhuanzhiEquipAwakeningInfo(protocol)
	self.forge_data:SetZhuanzhiEquipAwakeningInfo(protocol)
	if self.forge_view:IsOpen() then
		self.forge_view:Flush("jue_xing")
		RemindManager.Instance:Fire(RemindName.ForgeJueXing)
	end
end
-------------------------------------

-------------????????????
function ForgeCtrl:SendCSZhuanzhiEquipCompose(item_id, xianpin_num, bag_index_count, bag_index_list)
	local protocol = ProtocolPool.Instance:GetProtocol(CSZhuanzhiEquipCompose)
	protocol.item_id = item_id or 0
	protocol.xianpin_num = xianpin_num or 0
	protocol.bag_index_count = bag_index_count or 0
	protocol.bag_index_list = bag_index_list or 0
	protocol:EncodeAndSend()
end

function ForgeCtrl:OnSCZhuanzhiEquipComposeSucceed(protocol)
	self.forge_data:SetExchangeEquipIsSucc(protocol.is_succeed)
	if self.forge_view:IsOpen() then
		self.forge_view:Flush("exchange")
	end
end

function ForgeCtrl:OpenExchangeEquipListView(data)
	self.forge_compose_equip_lsit_view:SetListData(data)
end