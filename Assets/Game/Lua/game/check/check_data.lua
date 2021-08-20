CheckData = CheckData or BaseClass()

CHECK_TAB_NEW_TYPE = {
	JUE_SE = 1, 		-- 角色
	APPEARANCE = 2, 	-- 外观
}

CHECK_TAB_TYPE =
{
	JUE_SE = 1, 		-- 角色
	MOUNT = 2,			-- 坐骑
	WING = 3,			-- 羽翼
	SHIZHUANG = 4, 		-- 时装
	SPIRIT = 5,			-- 精灵
	SHENBING = 6, 		-- 神兵
	FABAO = 7, 			-- 法宝
	FOOT = 8, 			-- 足印
	HALO = 9, 			-- 光环
	FIGHT_MOUNT = 10, 	-- 战斗坐骑
	CLOAK = 11, 		-- 披风
	LINGREN = 12, 		-- 灵刃
	TOUSHI = 13, 		-- 头饰
	MASK = 14, 			-- 面具
	YAOSHI = 15, 		-- 腰饰
	QILINBI = 16, 		-- 麒麟臂
	SHEN_GONG = 17, 	-- 仙环
	SHEN_YI = 18, 		-- 仙阵
	GODDESS = 19, 		-- 仙女
	LINGZHU = 20, 		-- 灵珠
	XIANBAO = 21, 		-- 仙宝
	LINGTONG = 22, 		-- 灵童
	LINGGONG = 23, 		-- 灵弓
	LINGQI = 24,		-- 灵骑
	WEIYAN = 25, 		-- 尾焰
	SHOUHUAN = 26, 		-- 手环
	TAIL = 27, 			-- 尾巴
	FLYPET = 28, 		-- 飞宠
}

CheckData.TweenPosition = {
	Up = Vector3(-560, 480, 0),
	Left = Vector3(207, 0, 0),
	Right = Vector3(729, -10, 0),
	Down = Vector3(0, -432, 0),
	RightFrame = Vector3(195, 0, 0),
	SkillPanel = Vector3(-200, -432, 0),
}


ADVANCE_IMAGE_ID_CHAZHI = 1000 -- 形象的差值，幻化了image_id需要减1000
function CheckData:__init()
	if CheckData.Instance then
		print_error("[CheckData] Attemp to create a singleton twice !")
	end
	CheckData.Instance = self
	self.current_user_id = -1
	self.role_info = {}
	self.is_ming_ren = false
	self.cur_minren_index = 0
	self.check_type_list =
	{
	CHECK_TAB_TYPE.JUE_SE,
	CHECK_TAB_TYPE.MOUNT,
	CHECK_TAB_TYPE.WING,
	CHECK_TAB_TYPE.HALO,
	CHECK_TAB_TYPE.FIGHT_MOUNT,
	CHECK_TAB_TYPE.SPIRIT,
	CHECK_TAB_TYPE.GODDESS,
	CHECK_TAB_TYPE.SHEN_GONG,
	CHECK_TAB_TYPE.SHEN_YI,
	CHECK_TAB_TYPE.FOOT,
	CHECK_TAB_TYPE.CLOAK,
	CHECK_TAB_TYPE.FABAO,
	CHECK_TAB_TYPE.SHIZHUANG,
	}
end

function CheckData:__delete()
	CheckData.Instance = nil
	if self.role_info_event then
		GlobalEventSystem:UnBind(self.role_info_event)
		self.role_info_event = nil
	end
end

function CheckData:GetRoleInfo()
	return self.role_info
end

function CheckData:GetCheckTypeList()
	return self.check_type_list
end

function CheckData:SetMingrenFlag(flag)
	self.is_ming_ren = flag
end

function CheckData:GetRoleId()
	return self.role_info.role_id or 0
end

function CheckData:RoleInfoChange(info)
	self.role_info = TableCopy(info)
end

-- 设置魅力值
function CheckData:SetAllCharm(all_charm)
	self.role_info.all_charm = all_charm
end

function CheckData:SetCurrentUserId(current_user_id)
	self.current_user_id = current_user_id
end

function CheckData:GetCurrentUserId()
	return self.current_user_id
end

-- 当前高亮的user_id
function CheckData:SetCurrentHLUserId(current_hl_user_id, current_hl_plat_type)
	self.current_hl_user_id = current_hl_user_id
	self.current_hl_plat_type = current_hl_plat_type
end

function CheckData:GetCurrentHLUserId()
	return self.current_hl_user_id, self.current_hl_plat_type
end

function CheckData:UpdateAttrView()
	if self.role_info == nil or not next(self.role_info) or nil == self.role_info.role_id then return {} end
	local role_info = self.role_info
	local zhanli_attr = {
		max_hp = role_info.maxhp,
		gong_ji = role_info.gongji,
		fang_yu = role_info.fangyu,
		ming_zhong = role_info.mingzhong,
		shan_bi = role_info.shanbi,
		bao_ji = role_info.baoji,
		jian_ren = role_info.jianren,
		per_baoji = 0,
		per_pofang = 0,
		per_mianshang = 0,
		per_jingzhun = 0
	}

	local zhanli = CommonDataManager.GetCapability(zhanli_attr)
	local present_attr = {
		role_id = role_info.role_id,
		level = role_info.level,
		all_charm = role_info.all_charm,
		prof = role_info.prof,
		lover_name = role_info.lover_name,
		guild_name = role_info.guild_name,
		zhan_li = zhanli,
		role_name = role_info.role_name,
		shen_equip_part_list = role_info.shen_equip_part_list,
		jingjie = role_info.jingjie
	}

	local info_attr = {}
	info_attr.capability = role_info.capability
	info_attr.shengming = role_info.max_hp
	info_attr.gongji = role_info.gongji
	info_attr.fangyu = role_info.fangyu
	info_attr.mingzhong = role_info.mingzhong
	info_attr.shanbi = role_info.shanbi
	info_attr.baoji = role_info.baoji
	info_attr.kangbao = role_info.jianren
	info_attr.fujia_shanghai = role_info.fujia_shanghai
	info_attr.dikang_shanghai = role_info.dikang_shanghai
	info_attr.evil_val = role_info.evil_val

	info_attr.per_jingzhun = role_info.per_jingzhun
	info_attr.per_baoji = role_info.per_baoji
	info_attr.per_kangbao = role_info.per_kangbao
	info_attr.per_pofang = role_info.per_pofang
	info_attr.per_mianshang = role_info.per_mianshang

	info_attr.max_hp =role_info.max_hp
	info_attr.gong_ji = role_info.gongji
	info_attr.fang_yu = role_info.fangyu
	info_attr.ming_zhong = role_info.mingzhong
	info_attr.shan_bi = role_info.shanbi
	info_attr.bao_ji = role_info.baoji
	info_attr.jian_ren = role_info.jianren

	info_attr.base_max_hp = role_info.max_hp
	info_attr.base_gongji = role_info.gongji							-- 基础攻击
	info_attr.base_fangyu = role_info.fangyu							-- 基础防御
	info_attr.base_mingzhong = role_info.mingzhong						-- 基础命中
	info_attr.base_shanbi = role_info.shanbi							-- 基础闪避
	info_attr.base_baoji = role_info.baoji							-- 基础暴击
	info_attr.base_jianren = role_info.jianren							-- 基础坚韧
	info_attr.base_fujia_shanghai = role_info.fujia_shanghai
	info_attr.base_dikang_shanghai = role_info.dikang_shanghai
	info_attr.base_per_jingzhun = role_info.per_jingzhun
	info_attr.base_per_baoji = role_info.per_baoji
	info_attr.base_per_kangbao = role_info.per_kangbao
	info_attr.base_per_pofang = role_info.per_pofang
	info_attr.base_per_mianshang = role_info.per_mianshang
	info_attr.base_constant_zengshang = role_info.constant_zengshang
	info_attr.base_constant_mianshang = role_info.constant_mianshang
	info_attr.pvp_zengshang = role_info.pvp_zengshang
	info_attr.pvp_jianshang = role_info.pvp_jianshang
	info_attr.pve_zengshang = role_info.pve_zengshang
	info_attr.pve_jianshang = role_info.pve_jianshang
	info_attr.base_huixinyiji = role_info.huixinyiji
	info_attr.base_huixinyiji_hurt_per = role_info.huixinyiji_hurt_per
	info_attr.base_per_baoji_hurt = role_info.per_baoji_hurt
	info_attr.base_per_kangbao_hurt = role_info.per_kangbao_hurt
	info_attr.base_zhufuyiji_per = role_info.zhufuyiji_per
	info_attr.base_gedang_per = role_info.gedang_per
	info_attr.base_gedang_dikang_per = role_info.gedang_dikang_per
	info_attr.base_gedang_jianshang = role_info.gedang_jianshang
	info_attr.base_skill_zengshang = role_info.skill_zengshang
	info_attr.base_skill_jianshang = role_info.skill_jianshang
	info_attr.base_mingzhong_per = role_info.mingzhong_per
	info_attr.base_shanbi_per = role_info.shanbi_per

	info_attr.other_capability = 0
	info_attr.base_move_speed = 0
	info_attr.move_speed = 0
	info_attr.level = role_info.level
	local equip_attr = role_info.equipment_info

	local temp_halo_info = role_info.halo_info or {}
	local halo_info = {
		halo_level = temp_halo_info.level,
		grade = temp_halo_info.grade,
		grade_bless_val = 0,
		clear_upgrade_time = 0,
		used_imageid = temp_halo_info.used_imageid,
		shuxingdan_count = temp_halo_info.shuxingdan_count,
		chengzhangdan_count = temp_halo_info.chengzhangdan_count,
		active_image_flag = 0,
		equip_info_list = temp_halo_info.equip_info_list,
		skill_level_list = temp_halo_info.skill_level_list,
		special_img_grade_list = {},
		star_level = temp_halo_info.star_level,
		active_special_image_flag = bit:uc2b(temp_halo_info.active_special_image_flag),
	}
	
	local h_attr = HaloData.Instance:GetHaloAttrSum(halo_info)
	local halo_attr = {}
	halo_attr.capability = temp_halo_info.capability
	if h_attr == 0 then
		halo_attr.gong_ji = 0
		halo_attr.fang_yu = 0
		halo_attr.max_hp = 0
		halo_attr.ming_zhong = 0
		halo_attr.shan_bi = 0
		halo_attr.bao_ji = 0
		halo_attr.jian_ren = 0
		halo_attr.per_pofang = 0
		halo_attr.per_mianshang = 0
		halo_attr.client_grade = 0
		halo_attr.used_imageid = 0
		halo_attr.halo_level = halo_info.halo_level
	else
		local h_attr_2 = HaloData.Instance:GetHaloEquipAttrSum(halo_info)
		halo_attr.gong_ji = h_attr.gong_ji
		halo_attr.fang_yu = h_attr.fang_yu
		halo_attr.max_hp = h_attr.max_hp
		halo_attr.ming_zhong = h_attr.ming_zhong
		halo_attr.shan_bi = h_attr.shan_bi
		halo_attr.bao_ji = h_attr.bao_ji
		halo_attr.jian_ren = h_attr.jian_ren
		halo_attr.per_pofang = h_attr_2.per_pofang
		halo_attr.per_mianshang = h_attr_2.per_mianshang
		halo_attr.client_grade = (halo_info.grade or 0) - 1
		halo_attr.used_imageid = halo_info.used_imageid
		halo_attr.halo_level = halo_info.halo_level
	end

	local temp_foot_info = role_info.foot_info or {}
	local foot_info = {
		footprint_level = temp_foot_info.level,
		grade = temp_foot_info.grade,
		grade_bless_val = 0,
		clear_upgrade_time = 0,
		used_imageid = temp_foot_info.used_imageid,
		shuxingdan_count = temp_foot_info.shuxingdan_count,
		chengzhangdan_count = temp_foot_info.chengzhangdan_count,
		active_image_flag = 0,
		equip_info_list = temp_foot_info.equip_info_list,
		skill_level_list = temp_foot_info.skill_level_list,
		special_img_grade_list = {},
		star_level = temp_foot_info.star_level,
		active_special_image_flag = bit:uc2b(temp_foot_info.active_special_image_flag)
	}
	
	local h_attr = FootData.Instance:GetFootAttrSum(foot_info)
	if h_attr == nil then
		return
	end
	local foot_attr = {}
	foot_attr.capability = temp_foot_info.capability
	if h_attr == 0 then
		foot_attr.gong_ji = 0
		foot_attr.fang_yu = 0
		foot_attr.max_hp = 0
		foot_attr.ming_zhong = 0
		foot_attr.shan_bi = 0
		foot_attr.bao_ji = 0
		foot_attr.jian_ren = 0
		foot_attr.per_pofang = 0
		foot_attr.per_mianshang = 0
		foot_attr.client_grade = 0
		foot_attr.used_imageid = 0
		foot_attr.footprint_level = foot_info.footprint_level
	else
		local h_attr_2 = FootData.Instance:GetFootEquipAttrSum(foot_info)
		foot_attr.gong_ji = h_attr.gong_ji
		foot_attr.fang_yu = h_attr.fang_yu
		foot_attr.max_hp = h_attr.max_hp
		foot_attr.ming_zhong = h_attr.ming_zhong
		foot_attr.shan_bi = h_attr.shan_bi
		foot_attr.bao_ji = h_attr.bao_ji
		foot_attr.jian_ren = h_attr.jian_ren
		foot_attr.per_pofang = h_attr_2.per_pofang
		foot_attr.per_mianshang = h_attr_2.per_mianshang
		foot_attr.client_grade = (foot_info.grade or 0) - 1
		foot_attr.used_imageid = foot_info.used_imageid
		foot_attr.footprint_level = foot_info.footprint_level
	end


	local temp_fabao_info = role_info.fabao_info or {}
	local fabao_info = {
		fabao_level = temp_fabao_info.level,
		grade = temp_fabao_info.grade,
		grade_bless_val = 0,
		clear_upgrade_time = 0,
		used_imageid = temp_fabao_info.used_imageid,
		shuxingdan_count = temp_fabao_info.shuxingdan_count,
		chengzhangdan_count = temp_fabao_info.chengzhangdan_count,
		active_image_flag = 0,
		equip_info_list = temp_fabao_info.equip_info_list,
		skill_level_list = temp_fabao_info.skill_level_list,
		special_img_grade_list = {},
		star_level = temp_fabao_info.star_level,
		active_special_image_flag = bit:uc2b(temp_fabao_info.active_special_image_flag),
	}
	
	local h_attr = FaBaoData.Instance:GetFaBaoAttrSum(fabao_info)
	local fabao_attr = {}
	fabao_attr.capability = temp_fabao_info.capability
	if h_attr == 0 then
		fabao_attr.gong_ji = 0
		fabao_attr.fang_yu = 0
		fabao_attr.max_hp = 0
		fabao_attr.ming_zhong = 0
		fabao_attr.shan_bi = 0
		fabao_attr.bao_ji = 0
		fabao_attr.jian_ren = 0
		fabao_attr.per_pofang = 0
		fabao_attr.per_mianshang = 0
		fabao_attr.client_grade = 0
		fabao_attr.used_imageid = 0
		fabao_attr.fabao_level = fabao_info.fabao_level
	else
		local h_attr_2 = FaBaoData.Instance:GetFaBaoEquipAttrSum(fabao_info)
		fabao_attr.gong_ji = h_attr.gong_ji
		fabao_attr.fang_yu = h_attr.fang_yu
		fabao_attr.max_hp = h_attr.max_hp
		fabao_attr.ming_zhong = h_attr.ming_zhong
		fabao_attr.shan_bi = h_attr.shan_bi
		fabao_attr.bao_ji = h_attr.bao_ji
		fabao_attr.jian_ren = h_attr.jian_ren
		fabao_attr.per_pofang = h_attr_2.per_pofang
		fabao_attr.per_mianshang = h_attr_2.per_mianshang
		fabao_attr.client_grade = (fabao_info.grade or 0) - 1
		fabao_attr.used_imageid = fabao_info.used_imageid
		fabao_attr.fabao_level = fabao_info.fabao_level
	end

	if role_info.shizhuang_part_list == nil then
		return
	end
	-- 时装
	local temp_fashion_info = role_info.shizhuang_part_list[2] or {}

	local fashion_info = {
		fashion_level = temp_fashion_info.level,
		grade = temp_fashion_info.grade,
		grade_bless_val = 0,
		clear_upgrade_time = 0,
		used_imageid = temp_fashion_info.use_id,
		shuxingdan_count = temp_fashion_info.shuxingdan_count,
		chengzhangdan_count = temp_fashion_info.chengzhangdan_count,
		active_image_flag = 0,
		active_special_image_flag = temp_fashion_info.active_special_image_flag,
		equip_info_list = temp_fashion_info.equip_info_list,
		skill_level_list = temp_fashion_info.skill_level_list,
		special_img_grade_list = {},
		star_level = temp_fashion_info.star_level
	}
	local h_attr = FashionData.Instance:GetFashionAttrNum(fashion_info)
	local fashion_attr = {}
	fashion_attr.capability = temp_fashion_info.capability
	if h_attr == 0 then
		fashion_attr.gong_ji = 0
		fashion_attr.fang_yu = 0
		fashion_attr.max_hp = 0
		fashion_attr.ming_zhong = 0
		fashion_attr.shan_bi = 0
		fashion_attr.bao_ji = 0
		fashion_attr.jian_ren = 0
		fashion_attr.per_pofang = 0
		fashion_attr.per_mianshang = 0
		fashion_attr.client_grade = 0
		fashion_attr.used_imageid = 0
		fashion_attr.fashion_level = fashion_info.fashion_level
	else
		local h_attr_2 = FashionData.Instance:GetShizhuangEquipAttrSum(fashion_info)

		fashion_attr.gong_ji = h_attr.gong_ji
		fashion_attr.fang_yu = h_attr.fang_yu
		fashion_attr.max_hp = h_attr.max_hp
		fashion_attr.ming_zhong = h_attr.ming_zhong
		fashion_attr.shan_bi = h_attr.shan_bi
		fashion_attr.bao_ji = h_attr.bao_ji
		fashion_attr.jian_ren = h_attr.jian_ren
		fashion_attr.per_pofang = h_attr_2.per_pofang
		fashion_attr.per_mianshang = h_attr_2.per_mianshang
		fashion_attr.client_grade = (fashion_info.grade or 0) - 1
		fashion_attr.used_imageid = fashion_info.used_imageid
		fashion_attr.fashion_level = fashion_info.fashion_level
	end

	-- 神兵
	local temp_shenbing_info = role_info.shizhuang_part_list[1] or {}

	local shenbing_info = {
		level = temp_shenbing_info.level,
		grade = temp_shenbing_info.grade,
		grade_bless_val = 0,
		clear_upgrade_time = 0,
		used_imageid = temp_shenbing_info.use_id,
		shuxingdan_count = temp_shenbing_info.shuxingdan_count,
		chengzhangdan_count = temp_shenbing_info.chengzhangdan_count,
		active_image_flag = 0,
		active_special_image_flag = temp_shenbing_info.active_special_image_flag,
		equip_info_list = temp_shenbing_info.equip_info_list,
		skill_level_list = temp_shenbing_info.skill_level_list,
		special_img_grade_list = {},
		star_level = temp_shenbing_info.star_level
	}
	local h_attr = FashionData.Instance:GetWuQiAttrNum(shenbing_info)
	local shenbing_attr = {}
	shenbing_attr.capability = temp_shenbing_info.capability
	if h_attr == 0 then
		shenbing_attr.gong_ji = 0
		shenbing_attr.fang_yu = 0
		shenbing_attr.max_hp = 0
		shenbing_attr.ming_zhong = 0
		shenbing_attr.shan_bi = 0
		shenbing_attr.bao_ji = 0
		shenbing_attr.jian_ren = 0
		shenbing_attr.per_pofang = 0
		shenbing_attr.per_mianshang = 0
		shenbing_attr.client_grade = 0
		shenbing_attr.used_imageid = 0
		shenbing_attr.level = shenbing_info.level
	else
		local h_attr_2 = FashionData.Instance:GetShizhuangEquipAttrSum(shenbing_info)

		shenbing_attr.gong_ji = h_attr.gong_ji
		shenbing_attr.fang_yu = h_attr.fang_yu
		shenbing_attr.max_hp = h_attr.max_hp
		shenbing_attr.ming_zhong = h_attr.ming_zhong
		shenbing_attr.shan_bi = h_attr.shan_bi
		shenbing_attr.bao_ji = h_attr.bao_ji
		shenbing_attr.jian_ren = h_attr.jian_ren
		shenbing_attr.per_pofang = h_attr_2.per_pofang
		shenbing_attr.per_mianshang = h_attr_2.per_mianshang
		shenbing_attr.client_grade = (shenbing_info.grade or 0) - 1
		shenbing_attr.used_imageid = shenbing_info.used_imageid
		shenbing_attr.level = shenbing_info.level
	end

	local temp_mount_info = role_info.mount_info or {}
	local mount_info = {
		mount_flag = 0,
		mount_level = temp_mount_info.level,
		grade = temp_mount_info.grade,
		grade_bless_val = 0,
		clear_upgrade_time = 0,
		used_imageid = temp_mount_info.used_imageid,
		shuxingdan_count = temp_mount_info.shuxingdan_count,
		chengzhangdan_count = temp_mount_info.chengzhangdan_count,
		active_image_flag = 0,
		equip_info_list = temp_mount_info.equip_info_list,
		skill_level_list = temp_mount_info.skill_level_list,
		special_img_grade_list = {},
		star_level = temp_mount_info.star_level,
		active_special_image_flag = bit:uc2b(temp_mount_info.active_special_image),
	}
	
	local m_attr = MountData.Instance:GetMountAttrSum(mount_info)
	local mount_attr = {}
	mount_attr.capability = temp_mount_info.capability

	if m_attr == 0 then
		mount_attr.gong_ji = 0
		mount_attr.fang_yu = 0
		mount_attr.max_hp = 0
		mount_attr.ming_zhong = 0
		mount_attr.shan_bi = 0
		mount_attr.bao_ji = 0
		mount_attr.jian_ren = 0
		mount_attr.per_pofang = 0
		mount_attr.per_mianshang = 0
		mount_attr.client_grade = 0
		mount_attr.used_imageid = 0
		mount_attr.mount_level = mount_info.mount_level
	else
		local m_attr_2 = MountData.Instance:GetMountEquipAttrSum(mount_info)
		mount_attr.gong_ji = m_attr.gong_ji
		mount_attr.fang_yu = m_attr.fang_yu
		mount_attr.max_hp = m_attr.max_hp
		mount_attr.ming_zhong = m_attr.ming_zhong
		mount_attr.shan_bi = m_attr.shan_bi
		mount_attr.bao_ji = m_attr.bao_ji
		mount_attr.jian_ren = m_attr.jian_ren
		mount_attr.per_pofang = m_attr_2.per_pofang
		mount_attr.per_mianshang = m_attr_2.per_mianshang
		mount_attr.client_grade = (mount_info.grade or 0) - 1
		mount_attr.used_imageid = mount_info.used_imageid
		mount_attr.mount_level = mount_info.mount_level
	end

	local temp_wing_info = role_info.wing_info or {}
	local wing_info = {
		wing_level = temp_wing_info.level,
		grade = temp_wing_info.grade,
		grade_bless_val = 0,
		used_imageid = temp_wing_info.used_imageid,
		shuxingdan_count = temp_wing_info.shuxingdan_count,
		chengzhangdan_count = temp_wing_info.chengzhangdan_count,
		active_image_flag = 0,
		clear_upgrade_time = 0,
		equip_info_list = temp_wing_info.equip_info_list,
		skill_level_list = temp_wing_info.skill_level_list,
		special_img_grade_list = {},
		star_level = temp_wing_info.star_level,
		active_special_image_flag = bit:uc2b(temp_wing_info.active_special_image),
	}

	local w_attr = WingData.Instance:GetWingAttrSum(wing_info)
	local wing_attr = {}

	wing_attr.capability = temp_wing_info.capability

	if w_attr == 0 then
		wing_attr.gong_ji = 0
		wing_attr.fang_yu = 0
		wing_attr.max_hp = 0
		wing_attr.ming_zhong = 0
		wing_attr.shan_bi = 0
		wing_attr.bao_ji = 0
		wing_attr.jian_ren = 0
		wing_attr.per_pofang = 0
		wing_attr.client_grade = 0
		wing_attr.client_grade = 0
		wing_attr.used_imageid = 0
		wing_attr.wing_level = wing_info.wing_level
	else
		local w_attr_2 = WingData.Instance:GetWingEquipAttrSum(wing_info)
		wing_attr.gong_ji = w_attr.gong_ji
		wing_attr.fang_yu = w_attr.fang_yu
		wing_attr.max_hp = w_attr.max_hp
		wing_attr.ming_zhong = w_attr.ming_zhong
		wing_attr.shan_bi = w_attr.shan_bi
		wing_attr.bao_ji = w_attr.bao_ji
		wing_attr.jian_ren = w_attr.jian_ren
		wing_attr.per_pofang = w_attr_2.per_pofang
		wing_attr.per_mianshang = w_attr_2.per_mianshang
		wing_attr.client_grade = (wing_info.grade or 0) - 1
		wing_attr.used_imageid = wing_info.used_imageid
		wing_attr.wing_level = wing_info.wing_level
	end

	local temp_shengong_info = role_info.shengong_info or {}
	local shengong_client_grade = (temp_shengong_info.grade or 0) - 1
	local shengong_info = {
		shengong_level = temp_shengong_info.level,
		grade = temp_shengong_info.grade,
		grade_bless_val = 0,
		used_imageid = temp_shengong_info.used_imageid,
		shuxingdan_count = temp_shengong_info.shuxingdan_count,
		chengzhangdan_count = temp_shengong_info.chengzhangdan_count,
		active_image_flag = 0,
		active_special_image_flag = bit:uc2b(temp_shengong_info.active_special_image_flag),
		clear_upgrade_time = 0,
		equip_info_list = temp_shengong_info.equip_info_list,
		skill_level_list = temp_shengong_info.skill_level_list,
		star_level = temp_shengong_info.star_level,
		special_img_grade_list = {},
		client_grade = shengong_client_grade,
		capability = temp_shengong_info.capability,
	}
	local shengong_attr = shengong_info
	-- local s_attr = ShengongData.Instance:GetShengongAttrSum(shengong_info)
	-- local shengong_attr = {}
	-- shengong_attr.capability = temp_shengong_info.capability
	-- if s_attr == 0 then
	-- 	shengong_attr.gong_ji = 0
	-- 	shengong_attr.fang_yu = 0
	-- 	shengong_attr.max_hp = 0
	-- 	shengong_attr.ming_zhong = 0
	-- 	shengong_attr.shan_bi = 0
	-- 	shengong_attr.bao_ji = 0
	-- 	shengong_attr.jian_ren = 0
	-- 	shengong_attr.per_pofang = 0
	-- 	shengong_attr.per_mianshang = 0
	-- 	shengong_attr.client_grade = 0
	-- 	shengong_attr.used_imageid = 0
	-- 	shengong_attr.shengong_level = shengong_info.shengong_level
	-- else
	-- 	local s_attr_2 = ShengongData.Instance:GetShengongEquipAttrSum(shengong_info)
	-- 	shengong_attr.gong_ji = s_attr.gong_ji
	-- 	shengong_attr.fang_yu = s_attr.fang_yu
	-- 	shengong_attr.max_hp = s_attr.max_hp
	-- 	shengong_attr.ming_zhong = s_attr.ming_zhong
	-- 	shengong_attr.shan_bi = s_attr.shan_bi
	-- 	shengong_attr.bao_ji = s_attr.bao_ji
	-- 	shengong_attr.jian_ren = s_attr.jian_ren
	-- 	shengong_attr.per_pofang = s_attr_2.per_pofang
	-- 	shengong_attr.per_mianshang = s_attr_2.per_mianshang
	-- 	shengong_attr.client_grade = (shengong_info.grade or 0) - 1
	-- 	shengong_attr.used_imageid = shengong_info.used_imageid
	-- 	shengong_attr.shengong_level = shengong_info.shengong_level
	-- end

	local temp_shenyi_info = role_info.shenyi_info or {}
	local shenyi_client_grade = (temp_shenyi_info.grade or 0) - 1
	local shenyi_info = {
		shenyi_level = temp_shenyi_info.level,
		grade = temp_shenyi_info.grade,
		grade_bless_val = 0,
		used_imageid = temp_shenyi_info.used_imageid,
		shuxingdan_count = temp_shenyi_info.shuxingdan_count,
		chengzhangdan_count = temp_shenyi_info.chengzhangdan_count,
		active_image_flag = 0,
		active_special_image_flag = bit:uc2b(temp_shenyi_info.active_special_image_flag),
		star_level = temp_shenyi_info.star_level,
		clear_upgrade_time = 0,
		equip_info_list = temp_shenyi_info.equip_info_list,
		skill_level_list = temp_shenyi_info.skill_level_list,
		special_img_grade_list = {},
		client_grade = shenyi_client_grade,
		capability = temp_shenyi_info.capability,
	}
	local shenyi_attr = shenyi_info
	-- local sy_attr = ShenyiData.Instance:GetShenyiAttrSum(shenyi_info)
	-- local shenyi_attr = {}
	-- shenyi_attr.capability = temp_shenyi_info.capability
	-- if sy_attr == 0 then
	-- 	shenyi_attr.gong_ji = 0
	-- 	shenyi_attr.fang_yu = 0
	-- 	shenyi_attr.max_hp = 0
	-- 	shenyi_attr.ming_zhong = 0
	-- 	shenyi_attr.shan_bi = 0
	-- 	shenyi_attr.bao_ji = 0
	-- 	shenyi_attr.jian_ren = 0
	-- 	shenyi_attr.per_pofang = 0
	-- 	shenyi_attr.per_mianshang = 0
	-- 	shenyi_attr.client_grade = 0
	-- 	shenyi_attr.used_imageid = 0
	-- 	shenyi_attr.shenyi_level = shenyi_info.shenyi_level
	-- else
	-- 	local sy_attr_2 = ShenyiData.Instance:GetShenyiEquipAttrSum(shenyi_info)
	-- 	shenyi_attr.gong_ji = sy_attr.gong_ji
	-- 	shenyi_attr.fang_yu = sy_attr.fang_yu
	-- 	shenyi_attr.max_hp = sy_attr.max_hp
	-- 	shenyi_attr.ming_zhong = sy_attr.ming_zhong
	-- 	shenyi_attr.shan_bi = sy_attr.shan_bi
	-- 	shenyi_attr.bao_ji = sy_attr.bao_ji
	-- 	shenyi_attr.jian_ren = sy_attr.jian_ren
	-- 	shenyi_attr.per_pofang = sy_attr_2.per_pofang
	-- 	shenyi_attr.per_mianshang = sy_attr_2.per_mianshang
	-- 	shenyi_attr.client_grade = (shenyi_info.grade or 0) - 1
	-- 	shenyi_attr.used_imageid = shenyi_info.used_imageid
	-- 	shenyi_attr.shenyi_level = shenyi_info.shenyi_level
	-- end

	local temp_fight_mount_info = role_info.fight_mount_info or {}
	local fight_mount_info = {
		mount_level = temp_fight_mount_info.mount_level,
		grade = temp_fight_mount_info.grade,
		grade_bless_val = 0,
		used_imageid = temp_fight_mount_info.used_imageid,
		shuxingdan_count = temp_fight_mount_info.shuxingdan_count,
		chengzhangdan_count = temp_fight_mount_info.chengzhangdan_count,
		active_image_flag = 0,
		clear_upgrade_time = 0,
		equip_info_list = temp_fight_mount_info.equip_info_list,
		skill_level_list = temp_fight_mount_info.skill_level_list,
		special_img_grade_list = {},
		star_level = temp_fight_mount_info.star_level,
		active_special_image_flag = bit:uc2b(temp_fight_mount_info.active_special_image),
	}

	local fm_attr = FightMountData.Instance:GetMountAttrSum(fight_mount_info)
	local fight_mount_attr = {}
	fight_mount_attr.capability = temp_fight_mount_info.capability
	if fm_attr == 0 then
		fight_mount_attr.gong_ji = 0
		fight_mount_attr.fang_yu = 0
		fight_mount_attr.max_hp = 0
		fight_mount_attr.ming_zhong = 0
		fight_mount_attr.shan_bi = 0
		fight_mount_attr.bao_ji = 0
		fight_mount_attr.jian_ren = 0

		fight_mount_attr.client_grade = 0
		fight_mount_attr.used_imageid = 0
		fight_mount_attr.level = fight_mount_info.level
	else
		fight_mount_attr.gong_ji = fm_attr.gong_ji
		fight_mount_attr.fang_yu = fm_attr.fang_yu
		fight_mount_attr.max_hp = fm_attr.max_hp
		fight_mount_attr.ming_zhong = fm_attr.ming_zhong
		fight_mount_attr.shan_bi = fm_attr.shan_bi
		fight_mount_attr.bao_ji = fm_attr.bao_ji
		fight_mount_attr.jian_ren = fm_attr.jian_ren
		fight_mount_attr.client_grade = (fight_mount_info.grade or 0) - 1
		fight_mount_attr.used_imageid = fight_mount_info.used_imageid
		fight_mount_attr.level = fight_mount_info.shenyi_level
	end

	local temp_cloak_info = role_info.cloak_info or {}
	local cloak_info = {
		cloak_level = temp_cloak_info.level,
		grade = 0,
		grade_bless_val = 0,
		used_imageid = temp_cloak_info.used_imageid,
		shuxingdan_count = temp_cloak_info.shuxingdan_count,
		chengzhangdan_count = temp_cloak_info.chengzhangdan_count,
		active_image_flag = 0,
		active_special_image_flag = temp_cloak_info.active_special_image_flag,
		clear_upgrade_time = 0,
		equip_info_list = temp_cloak_info.equip_info_list,
		skill_level_list = temp_cloak_info.skill_level_list,
		special_img_grade_list = {},
		star_level = temp_cloak_info.star_level,
	}

	local cl_attr = CloakData.Instance:GetCloakAttrSum(cloak_info)
	local cloak_attr = {}
	cloak_attr.capability = temp_cloak_info.capability
	if cl_attr == 0 then
		cloak_attr.gong_ji = 0
		cloak_attr.fang_yu = 0
		cloak_attr.max_hp = 0
		cloak_attr.ming_zhong = 0
		cloak_attr.shan_bi = 0
		cloak_attr.bao_ji = 0
		cloak_attr.jian_ren = 0
		cloak_attr.per_pofang = 0
		cloak_attr.client_grade = 0
		cloak_attr.client_grade = 0
		cloak_attr.used_imageid = 0
		cloak_attr.cloak_level = cloak_info.cloak_level
	else
		local cl_attr_2 = CloakData.Instance:GetCloakEquipAttrSum(cloak_info)
		cloak_attr.gong_ji = cl_attr.gong_ji
		cloak_attr.fang_yu = cl_attr.fang_yu
		cloak_attr.max_hp = cl_attr.max_hp
		cloak_attr.ming_zhong = cl_attr.ming_zhong
		cloak_attr.shan_bi = cl_attr.shan_bi
		cloak_attr.bao_ji = cl_attr.bao_ji
		cloak_attr.jian_ren = cl_attr.jian_ren
		cloak_attr.per_pofang = cl_attr_2.per_pofang
		cloak_attr.per_mianshang = cl_attr_2.per_mianshang
		cloak_attr.client_grade = (cloak_info.grade or 0) - 1
		cloak_attr.used_imageid = cloak_info.used_imageid
		cloak_attr.cloak_level = cloak_info.cloak_level
	end

	local toushi_attr = role_info.head_info
	local mask_attr = role_info.mask_info
	local yaoshi_attr = role_info.waist_info
	local qilinbi_attr = role_info.arm_info
	local lingzhu_attr = role_info.upgrade_sys_info[UPGRADE_TYPE.LING_ZHU]
	local xianbao_attr = role_info.upgrade_sys_info[UPGRADE_TYPE.XIAN_BAO]
	local lingtong_attr = role_info.upgrade_sys_info[UPGRADE_TYPE.LING_TONG]
	local linggong_attr = role_info.upgrade_sys_info[UPGRADE_TYPE.LING_GONG]
	local lingqi_attr = role_info.upgrade_sys_info[UPGRADE_TYPE.LING_QI]
	local weiyan_attr = role_info.upgrade_sys_info[UPGRADE_TYPE.WEI_YAN]
	local shouhuan_attr = role_info.upgrade_sys_info[UPGRADE_TYPE.SHOU_HUAN]
	local tail_attr = role_info.upgrade_sys_info[UPGRADE_TYPE.TAIL]
	local flypet_attr = role_info.upgrade_sys_info[UPGRADE_TYPE.FLY_PET]

	local xiannv_attr = role_info.xiannv_info
	local spirit_attr = role_info.jingling_info
	local impguard_attr = role_info.imp_guard_info_list
	local mojie_attr = role_info.mojie_list
	local zhuanzhi_capability = role_info.zhuanzhi_capability
	local baizhan_capability = role_info.baizhan_capability
	local baizhan_equiplist = role_info.baizhan_equiplist
	local baizhan_order_equiplist = role_info.baizhan_order_equiplist
	local baizhan_order_count_list = role_info.baizhan_order_count_list
	local zhuanzhi_equip_list = role_info.zhuanzhi_equip_list
	local zhuanzhi_suit_type_list = role_info.zhuanzhi_suit_type_list
	local zhuanzhi_order_list = role_info.zhuanzhi_order_list
	local lingren_attr = role_info.lingren_info
	local check_attr = {}
	check_attr.present_attr = present_attr
	check_attr.halo_attr = halo_attr
	check_attr.foot_attr = foot_attr
	check_attr.mount_attr = mount_attr
	check_attr.equip_attr = equip_attr
	check_attr.wing_attr = wing_attr
	check_attr.info_attr = info_attr
	check_attr.shengong_attr = shengong_attr
	check_attr.shenyi_attr = shenyi_attr
	check_attr.xiannv_attr = xiannv_attr
	check_attr.spirit_attr = spirit_attr
	check_attr.fight_attr = fight_mount_attr
	check_attr.cloak_attr = cloak_attr
	check_attr.impguard_attr = impguard_attr
	check_attr.mojie_attr = mojie_attr
	check_attr.toushi_attr = toushi_attr
	check_attr.mask_attr = mask_attr
	check_attr.yaoshi_attr = yaoshi_attr
	check_attr.qilinbi_attr = qilinbi_attr
	check_attr.lingzhu_attr = lingzhu_attr
	check_attr.xianbao_attr = xianbao_attr
	check_attr.lingtong_attr = lingtong_attr
	check_attr.linggong_attr = linggong_attr
	check_attr.lingqi_attr = lingqi_attr
	check_attr.weiyan_attr = weiyan_attr
	check_attr.shouhuan_attr = shouhuan_attr
	check_attr.tail_attr = tail_attr
	check_attr.flypet_attr = flypet_attr
	check_attr.zhuanzhi_capability = zhuanzhi_capability
	check_attr.baizhan_capability = baizhan_capability
	check_attr.baizhan_equiplist = baizhan_equiplist
	check_attr.baizhan_order_equiplist = baizhan_order_equiplist
	check_attr.baizhan_order_count_list = baizhan_order_count_list

	check_attr.zhuanzhi_equip_list = zhuanzhi_equip_list
	check_attr.zhuanzhi_suit_type_list = zhuanzhi_suit_type_list
	check_attr.zhuanzhi_order_list = zhuanzhi_order_list

	check_attr.fabao_attr = fabao_attr
	check_attr.shenbing_attr = shenbing_attr
	check_attr.fashion_attr = fashion_attr
	check_attr.lingren_attr = lingren_attr
	return check_attr
end

function CheckData:GetEquipItemCfg(item_id)
	return ConfigManager.Instance:GetAutoItemConfig("equipment_auto")[item_id]
end

function CheckData:GetGradeName(grade)
	return CommonDataManager.GetDaXie(grade)..Language.Common.Jie
end

--获得默认装备id
function CheckData:DefalutEquip(index)
	local equip_id = 0
	if index == 1 then
		equip_id = 8100
	elseif index == 2 then
		equip_id = 100
	elseif index == 3 then
		equip_id = 9100
	elseif index == 4 then
		equip_id = 9100
	elseif index == 5 then
		equip_id = 6100
	elseif index == 6 then
		equip_id = 1100
	elseif index == 7 then
		equip_id = 5100
	elseif index == 8 then
		equip_id = 2100
	elseif index == 9 then
		equip_id = 3100
	elseif index == 10 then
		equip_id = 4100
	end
	return equip_id
end

function CheckData:GetTabName(tab_index)
	return Language.Common.CheckTabName[tab_index] or ""
end

function CheckData:GetTabAsset(tab_index)
	local asset, name = "", ""
	if tab_index == CHECK_TAB_TYPE.JUE_SE then
		asset = "uis/views/player/images_atlass"
		name = "left_icon_info"
	elseif tab_index == CHECK_TAB_TYPE.MOUNT then
		asset = "uis/views/advanceview/images_atlas"
		name = "left_icon_mount"
	elseif tab_index == CHECK_TAB_TYPE.WING then
		asset = "uis/views/advanceview/images_atlas"
		name = "left_icon_wing"
	elseif tab_index == CHECK_TAB_TYPE.HALO then
		asset = "uis/views/advanceview_/images_atlas"
		name = "left_icon_guanghuan"
	elseif tab_index == CHECK_TAB_TYPE.FOOT then
		asset = "uis/views/advanceview/images_atlas"
		name = "left_icon_foot"
	elseif tab_index == CHECK_TAB_TYPE.SPIRIT then
		asset = "uis/views/spiritview/images_atlas"
		name = "left_icon_jingling"
	elseif tab_index == CHECK_TAB_TYPE.GODDESS then
		asset = "uis/views/rank/images_atlas"
		name = "left_icon_nvshen"
	elseif tab_index == CHECK_TAB_TYPE.SHEN_GONG then
		asset = "uis/views/goddess/images_atlas"
		name = "left_icon_gong"
	elseif tab_index == CHECK_TAB_TYPE.SHEN_YI then
		asset = "uis/views/advanceview/images_atlas"
		name = "left_icon_wing"
	elseif tab_index == CHECK_TAB_TYPE.FIGHT_MOUNT then
		asset = "uis/views/advanceview/images_atlas"
		name = "left_icon_zd_mount"
	elseif tab_index == CHECK_TAB_TYPE.CLOAK then
		asset = "uis/views/advanceview/images_atlas"
		name = "left_icon_zd_cloak"
	end
	return asset, name
end

function CheckData:GetTabIsOpen(tab_index)
	if self.role_info then

		if tab_index == CHECK_TAB_TYPE.MOUNT then
			if not OpenFunData.Instance:CheckIsHide("rank_mount")then
				return false
			end
			if not self.role_info.mount_info then
				return false
			end
			if self.role_info.mount_info.capability <= 0 then
				return false
			end
		elseif tab_index == CHECK_TAB_TYPE.WING then
			if not OpenFunData.Instance:CheckIsHide("rank_wing")then
				return false
			end
			if not self.role_info.wing_info then
				return false
			end
			if self.role_info.wing_info.capability <= 0 then
				return false
			end
		elseif tab_index == CHECK_TAB_TYPE.HALO then
			if not OpenFunData.Instance:CheckIsHide("rank_halo")then
				return false
			end
			if not self.role_info.halo_info then
				return false
			end
			if self.role_info.halo_info.grade == 1 then
				return false
			end
			if self.role_info.halo_info.capability <= 0 then
				return false
			end
		elseif tab_index == CHECK_TAB_TYPE.FOOT then
			if not OpenFunData.Instance:CheckIsHide("rank_foot")then
				return false
			end
			if not self.role_info.foot_info then
				return false
			end
			if self.role_info.foot_info.grade == 1 then
				return false
			end
			if self.role_info.foot_info.capability <= 0 then
				return false
			end
		elseif tab_index == CHECK_TAB_TYPE.SPIRIT then
			if not OpenFunData.Instance:CheckIsHide("rank_spirit")then
				return false
			end
			return self:CheckSpiritTabIsOpen()
		elseif tab_index == CHECK_TAB_TYPE.GODDESS then
			if not OpenFunData.Instance:CheckIsHide("rank_goddess")then
				return false
			end
			if not self.role_info.xiannv_info then
				return false
			end
			if self.role_info.xiannv_info.active_xiannv_flag <= 0 then
				return false
			end
		elseif tab_index == CHECK_TAB_TYPE.SHEN_GONG then
			if not OpenFunData.Instance:CheckIsHide("rank_goddesshalo")then
				return false
			end
			if not self.role_info.xiannv_info then
				return false
			end
			if self.role_info.xiannv_info.active_xiannv_flag <= 0 then
				return false
			end
			if not self.role_info.shengong_info then
				return false
			end
			if self.role_info.shengong_info.capability <= 0 then
				return false
			end
		elseif tab_index == CHECK_TAB_TYPE.SHEN_YI then
			if not OpenFunData.Instance:CheckIsHide("rank_goddesszhen")then
				return false
			end
			if not self.role_info.xiannv_info then
				return false
			end
			if self.role_info.xiannv_info.active_xiannv_flag <= 0 then
				return false
			end
			if not self.role_info.shenyi_info then
				return false
			end
			if self.role_info.shenyi_info.capability <= 0 then
				return false
			end
		elseif tab_index == CHECK_TAB_TYPE.FIGHT_MOUNT then
			if not OpenFunData.Instance:CheckIsHide("rank_fightmount")then
				return false
			end
			if not self.role_info.fight_mount_info then
				return false
			end
			if self.role_info.fight_mount_info.capability <= 0 then
				return false
			end
		elseif tab_index == CHECK_TAB_TYPE.CLOAK then
			if not OpenFunData.Instance:CheckIsHide("rank_cloat")then
				return false
			end
			if not self.role_info.cloak_info then
				return false
			end
			if self.role_info.cloak_info.capability <= 0 then
				return false
			end
			local cloak_level_cfg = CloakData.Instance:GetCloakLevelCfg(self.role_info.cloak_info.level)
			if cloak_level_cfg and cloak_level_cfg.active_image <= 0 then
				return false
			end

		elseif tab_index == CHECK_TAB_TYPE.LINGREN then
			return false
			-- if not self.role_info.lingren_info then
			-- 	return false
			-- end
			-- if self.role_info.lingren_info.capability <= 0 then
			-- 	return false
			-- end
		elseif tab_index == CHECK_TAB_TYPE.FABAO then
			if not OpenFunData.Instance:CheckIsHide("rank_fabao")then
				return false
			end
			if not self.role_info.fabao_info then
				return false
			end
			if self.role_info.fabao_info.capability <= 0 then
				return false
			end
		elseif tab_index == CHECK_TAB_TYPE.SHIZHUANG then
			if not OpenFunData.Instance:CheckIsHide("rank_shizhuan")then
				return false
			end
			if not self.role_info.shizhuang_part_list then
				return false
			end
			if self.role_info.shizhuang_part_list[2].grade == 1 then
				return false
			end
			if not self.role_info.shizhuang_part_list[2] then
				return false
			end
			if self.role_info.shizhuang_part_list[2].capability <= 0 then
				return false
			end
		elseif tab_index == CHECK_TAB_TYPE.SHENBING then
			if not OpenFunData.Instance:CheckIsHide("rank_shenbing")then
				return false
			end
			if not self.role_info.shizhuang_part_list then
				return false
			end
			if not self.role_info.shizhuang_part_list[1] then
				return false
			end
			if self.role_info.shizhuang_part_list[1].grade == 1 then
				return false
			end
			if self.role_info.shizhuang_part_list[1].capability <= 0 then
				return false
			end
		elseif tab_index == CHECK_TAB_TYPE.TOUSHI then
			if not OpenFunData.Instance:CheckIsHide("rank_toushi")then
				return false
			end
			if not self.role_info.head_info then
				return false
			end
			if self.role_info.head_info.capability <= 0 then
				return false
			end
		elseif tab_index == CHECK_TAB_TYPE.MASK then
			if not OpenFunData.Instance:CheckIsHide("rank_mask")then
				return false
			end
			if not self.role_info.mask_info then
				return false
			end
			if self.role_info.mask_info.capability <= 0 then
				return false
			end
		elseif tab_index == CHECK_TAB_TYPE.YAOSHI then
			if not OpenFunData.Instance:CheckIsHide("rank_yaoshi")then
				return false
			end
			if not self.role_info.waist_info then
				return false
			end
			if self.role_info.waist_info.capability <= 0 then
				return false
			end
		elseif tab_index == CHECK_TAB_TYPE.QILINBI then
			if not OpenFunData.Instance:CheckIsHide("rank_qilinbi")then
				return false
			end
			if not self.role_info.arm_info then
				return false
			end
			if self.role_info.arm_info.capability <= 0 then
				return false
			end
		elseif tab_index == CHECK_TAB_TYPE.LINGZHU then
			if not OpenFunData.Instance:CheckIsHide("rank_lingzhu")then
				return false
			end
			if not self.role_info.upgrade_sys_info then
				return false
			end			
			if not self.role_info.upgrade_sys_info[UPGRADE_TYPE.LING_ZHU] then
				return false
			end
			if self.role_info.upgrade_sys_info[UPGRADE_TYPE.LING_ZHU].capability <= 0 then
				return false
			end
		elseif tab_index == CHECK_TAB_TYPE.XIANBAO then
			if not OpenFunData.Instance:CheckIsHide("rank_xianbao")then
				return false
			end
			if not self.role_info.upgrade_sys_info then
				return false
			end			
			if not self.role_info.upgrade_sys_info[UPGRADE_TYPE.XIAN_BAO] then
				return false
			end
			if self.role_info.upgrade_sys_info[UPGRADE_TYPE.XIAN_BAO].capability <= 0 then
				return false
			end
		elseif tab_index == CHECK_TAB_TYPE.LINGTONG then
			if not OpenFunData.Instance:CheckIsHide("rank_lingtong")then
				return false
			end
			if not self.role_info.upgrade_sys_info then
				return false
			end			
			if not self.role_info.upgrade_sys_info[UPGRADE_TYPE.LING_TONG] then
				return false
			end
			if self.role_info.upgrade_sys_info[UPGRADE_TYPE.LING_TONG].capability <= 0 then
				return false
			end
		elseif tab_index == CHECK_TAB_TYPE.LINGGONG then
			if not OpenFunData.Instance:CheckIsHide("rank_linggong")then
				return false
			end
			if not self.role_info.upgrade_sys_info then
				return false
			end			
			if not self.role_info.upgrade_sys_info[UPGRADE_TYPE.LING_GONG] then
				return false
			end
			if self.role_info.upgrade_sys_info[UPGRADE_TYPE.LING_GONG].capability <= 0 then
				return false
			end
		elseif tab_index == CHECK_TAB_TYPE.LINGQI then
			if not OpenFunData.Instance:CheckIsHide("rank_lingqi")then
				return false
			end
			if not self.role_info.upgrade_sys_info then
				return false
			end			
			if not self.role_info.upgrade_sys_info[UPGRADE_TYPE.LING_QI] then
				return false
			end
			if self.role_info.upgrade_sys_info[UPGRADE_TYPE.LING_QI].capability <= 0 then
				return false
			end
		elseif tab_index == CHECK_TAB_TYPE.WEIYAN then
			if not OpenFunData.Instance:CheckIsHide("rank_weiyan")then
				return false
			end
			if not self.role_info.upgrade_sys_info then
				return false
			end			
			if not self.role_info.upgrade_sys_info[UPGRADE_TYPE.WEI_YAN] then
				return false
			end
			if self.role_info.upgrade_sys_info[UPGRADE_TYPE.WEI_YAN].capability <= 0 then
				return false
			end
		elseif tab_index == CHECK_TAB_TYPE.SHOUHUAN then
			if not OpenFunData.Instance:CheckIsHide("rank_shouhuan")then
				return false
			end
			if not self.role_info.upgrade_sys_info then
				return false
			end			
			if not self.role_info.upgrade_sys_info[UPGRADE_TYPE.SHOU_HUAN] then
				return false
			end
			if self.role_info.upgrade_sys_info[UPGRADE_TYPE.SHOU_HUAN].capability <= 0 then
				return false
			end
		elseif tab_index == CHECK_TAB_TYPE.TAIL then
			if not OpenFunData.Instance:CheckIsHide("rank_tail")then
				return false
			end
			if not self.role_info.upgrade_sys_info then
				return false
			end
			if not self.role_info.upgrade_sys_info[UPGRADE_TYPE.TAIL] then
				return false
			end
			if self.role_info.upgrade_sys_info[UPGRADE_TYPE.TAIL].capability <= 0 then
				return false
			end
		elseif tab_index == CHECK_TAB_TYPE.FLYPET then
			if not OpenFunData.Instance:CheckIsHide("rank_flypet")then
				return false
			end
			if not self.role_info.upgrade_sys_info then
				return false
			end
			if not self.role_info.upgrade_sys_info[UPGRADE_TYPE.FLY_PET] then
				return false
			end
			if self.role_info.upgrade_sys_info[UPGRADE_TYPE.FLY_PET].capability <= 0 then
				return false
			end
		end
	else
		return false
	end
	return true
end

function CheckData:CheckSpiritTabIsOpen()
	if not self.role_info.jingling_info then
		return false
	end
	for k,v in pairs(self.role_info.jingling_info.jingling_item_list) do
		if v.jingling_id ~= 0 then
			return true
		end
	end
	return false
end

function CheckData:GetShowTabIndex()
	local show_list = {}
	for k,v in pairs(CHECK_TAB_TYPE) do
		if self:GetTabIsOpen(v) then
			table.insert(show_list, v)
		end
	end

	function sortfun (a, b) --其他
		if a < b then
			return true
		else
			return false
		end
	end
	table.sort(show_list, sortfun)
	return show_list
end

function CheckData:GetShowJingLingAttr()
	if not self.role_info.jingling_info then
		return false
	end
	local jingling_item = nil
	for k,v in pairs(self.role_info.jingling_info.jingling_item_list) do
		if v.jingling_id == self.role_info.jingling_info.use_jingling_id then
			jingling_item = v
			break
		end
	end
	if jingling_item == nil then
		jingling_item = self.role_info.jingling_info.jingling_item_list[1]
	end
	return jingling_item
end

function CheckData:GetName(rank_type)
	local name = ""
	if rank_type == PERSON_RANK_TYPE.PERSON_RANK_TYPE_MOUNT then
		if not self.role_info.mount_info then
			return name
		end

		local image_id = self.role_info.mount_info.used_imageid
		if image_id >= GameEnum.MOUNT_SPECIAL_IMA_ID then
			local cfg = MountData.Instance:GetSpecialImagesCfg()[image_id - GameEnum.MOUNT_SPECIAL_IMA_ID]
			if cfg then
				name = cfg.image_name
			end
		else
			local cfg = MountData.Instance:GetMountImageCfg()[image_id]
			if cfg then
				name = cfg.image_name
			end
		end
	elseif rank_type == PERSON_RANK_TYPE.PERSON_RANK_TYPE_XIANNV_CAPABILITY then
		if not self.role_info.xiannv_info then
			return name
		end

		local xiannv_info = self.role_info.xiannv_info
		if xiannv_info.xiannv_name ~= "" then
			name = xiannv_info.xiannv_name
		else
			if xiannv_info.pos_list[1] ~= -1 then
				local cfg = GoddessData.Instance:GetXianNvCfg(xiannv_info.pos_list[1])
				if cfg then
					name = cfg.name
				end
			end
		end
	elseif rank_type == PERSON_RANK_TYPE.PERSON_RANK_TYPE_SHENGONG then
		if not self.role_info.shengong_info then
			return name
		end

		local image_id = self.role_info.shengong_info.used_imageid
		if image_id >= GameEnum.MOUNT_SPECIAL_IMA_ID then
			local cfg = ShengongData.Instance:GetSpecialImagesCfg()[image_id - GameEnum.MOUNT_SPECIAL_IMA_ID]
			if cfg then
				name = cfg.image_name
			end
		else
			local cfg = ShengongData.Instance:GetShengongImageCfg()[image_id]
			if cfg then
				name = cfg.image_name
			end
		end
	elseif rank_type == PERSON_RANK_TYPE.PERSON_RANK_TYPE_SHENYI then
		if not self.role_info.shenyi_info then
			return name
		end

		local image_id = self.role_info.shenyi_info.used_imageid
		if image_id >= GameEnum.MOUNT_SPECIAL_IMA_ID then
			local cfg = ShenyiData.Instance:GetSpecialImagesCfg()[image_id - GameEnum.MOUNT_SPECIAL_IMA_ID]
			if cfg then
				name = cfg.image_name
			end
		else
			local cfg = ShenyiData.Instance:GetShenyiImageCfg()[image_id]
			if cfg then
				name = cfg.image_name
			end
		end
	elseif rank_type == PERSON_RANK_TYPE.PERSON_RANK_TYPE_CAPABILITY_JINGLING then
		if not self.role_info.jingling_info then
			return name
		end

		local jingling_info = self.role_info.jingling_info
		if jingling_info.phantom_imgageid ~= -1 then
			local cfg = SpiritData.Instance:GetSpecialSpiritImageCfg(jingling_info.phantom_imgageid)
			if cfg then
				name = cfg.image_name
			end
		else
			if jingling_info.use_jingling_id ~= 0 then
				local cfg = SpiritData.Instance:GetSpiritResIdByItemId(jingling_info.use_jingling_id)
				if cfg then
					name = cfg.name
				end
			end
		end
	elseif rank_type == PERSON_RANK_TYPE.PERSON_RANK_TYPE_WING then
		if not self.role_info.wing_info then
			return name
		end

		local image_id = self.role_info.wing_info.used_imageid
		if image_id >= GameEnum.MOUNT_SPECIAL_IMA_ID then
			local cfg = WingData.Instance:GetSpecialImagesCfg()[image_id - GameEnum.MOUNT_SPECIAL_IMA_ID]
			if cfg then
				name = cfg.image_name
			end
		else
			local cfg = WingData.Instance:GetWingImageCfg()[image_id]
			if cfg then
				name = cfg.image_name
			end
		end
	elseif rank_type == PERSON_RANK_TYPE.PERSON_RANK_TYPE_HALO then
		if not self.role_info.halo_info then
			return name
		end

		local image_id = self.role_info.halo_info.used_imageid
		if image_id >= GameEnum.MOUNT_SPECIAL_IMA_ID then
			local cfg = HaloData.Instance:GetSpecialImagesCfg()[image_id - GameEnum.MOUNT_SPECIAL_IMA_ID]
			if cfg then
				name = cfg.image_name
			end
		else
			local cfg = HaloData.Instance:GetHaloImageCfg()[image_id]
			if cfg then
				name = cfg.image_name
			end
		end
	else
		name = self.role_info.role_name
	end
	return name
end
