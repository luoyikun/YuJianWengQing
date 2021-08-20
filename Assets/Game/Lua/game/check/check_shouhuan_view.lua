CheckShouHuanView = CheckShouHuanView or BaseClass(BaseRender)
function CheckShouHuanView:__init(instance)
	self.fight_text = CommonDataManager.FightPower(self, self.node_list["TxtZhanli"])
end

function CheckShouHuanView:__delete()
	self.shouhuan_attr = nil
	self.fight_text = nil
end


function CheckShouHuanView:DoPanelTweenPlay()
	UITween.MoveShowPanel(self.node_list["RightFrame"], CheckData.TweenPosition.RightFrame , TWEEN_TIME, DG.Tweening.Ease.InOutSine)
end


function CheckShouHuanView:OnFlush()
	if self.shouhuan_attr then
		local grade_info = LingZhuData.Instance:GetLingZhuGradeCfgInfoByGrade(self.shouhuan_attr.grade)
		if nil == grade_info then return end
		local image_info = LingZhuData.Instance:GetLingZhuImageCfgInfoByImageId(grade_info.image_id)
		if nil == image_info then return end
		self.node_list["TxtName"].text.text = ToColorStr((grade_info.gradename .."·" .. image_info.image_name), SOUL_NAME_COLOR[image_info.colour])

		local attr = LingZhuData.Instance:UseChengZhandDanAddBaseAttr(grade_info)
		local switch_attr_list = CommonDataManager.SwitchAttri(attr)

		local zi_zhi_cfg = AppearanceData.Instance:GetZiZhiCfg(ShouHuanShuXingDanCfgType.Type)
		if zi_zhi_cfg == nil then return end
		local shuxingdan_count = self.shouhuan_attr.shuxingdan_list[0]
		local zizhi_hp = zi_zhi_cfg.maxhp * shuxingdan_count 
		local zizhi_gongji = zi_zhi_cfg.gongji * shuxingdan_count
		local zizhi_fangyu = zi_zhi_cfg.fangyu * shuxingdan_count

		self.node_list["TxtGongji"].text.text = (switch_attr_list.gong_ji or 0) + zizhi_gongji
		self.node_list["TxtFangyu"].text.text = (switch_attr_list.fang_yu or 0) + zizhi_fangyu
		self.node_list["TxtShengming"].text.text = (switch_attr_list.max_hp or 0) + zizhi_hp
		self.node_list["TxtMingzhong"].text.text = switch_attr_list.ming_zhong or 0 
		self.node_list["TxtShanbi"].text.text = switch_attr_list.shan_bi or 0 
		self.node_list["TxtBaoji"].text.text = switch_attr_list.bao_ji or 0
		self.node_list["TxtKangbao"].text.text = switch_attr_list.jian_ren or 0 
		self.node_list["TxtZengshang"].text.text = switch_attr_list.per_pofang or 0 
		self.node_list["TxtMianshang"].text.text = switch_attr_list.per_mianshang or 0 

		self.node_list["GongJi"]:SetActive(switch_attr_list.gong_ji and switch_attr_list.gong_ji + zizhi_gongji > 0)
		self.node_list["FangYu"]:SetActive(switch_attr_list.fang_yu and switch_attr_list.fang_yu + zizhi_fangyu > 0)
		self.node_list["ShengMing"]:SetActive(switch_attr_list.max_hp and switch_attr_list.max_hp + zizhi_hp > 0)
		self.node_list["MingZhong"]:SetActive(switch_attr_list.ming_zhong and switch_attr_list.ming_zhong > 0)
		self.node_list["ShanBi"]:SetActive(switch_attr_list.shan_bi and switch_attr_list.shan_bi > 0)
		self.node_list["BaoJi"]:SetActive(switch_attr_list.bao_ji and switch_attr_list.bao_ji > 0)
		self.node_list["KangBao"]:SetActive(switch_attr_list.jian_ren and switch_attr_list.jian_ren > 0)
		if self.fight_text and self.fight_text.text then
			self.fight_text.text.text = self.shouhuan_attr.capability
		end

		self:SetModle(grade_info)
	end
end

function CheckShouHuanView:SetAttr()
	local check_attr = CheckData.Instance:UpdateAttrView()
	if check_attr and check_attr.shouhuan_attr then
		self.shouhuan_attr = check_attr.shouhuan_attr
		self:Flush()
	end
end

function CheckShouHuanView:SetModle(grade_info)
	local call_back = function(model, obj)
		if obj then
			obj.gameObject.transform.localRotation = Quaternion.Euler(0, 90, 0)
		end
	end
	UIScene:SetModelLoadCallBack(call_back)

	local role_info = CheckData.Instance:GetRoleInfo()
	local info = {}
	info.prof = role_info.prof
	info.sex = role_info.sex
	info.appearance = {}
	info.appearance.shouhuan_used_imageid = grade_info.image_id
	local fashion_info = role_info.shizhuang_part_list[2]
	local is_used_special_img = fashion_info.use_special_img
	info.is_normal_fashion = is_used_special_img == 0
	local fashion_id = is_used_special_img == 0 and fashion_info.use_id or fashion_info.use_special_img
	info.appearance.fashion_body = fashion_id
	UIScene:SetRoleModelResInfo(info, true, true, true, true, false, true)
end

