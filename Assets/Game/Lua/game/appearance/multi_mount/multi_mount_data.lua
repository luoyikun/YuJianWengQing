MultiMountData = MultiMountData or BaseClass()

-- local GRADE_DAN_ID = 27702  --双骑进阶丹
function MultiMountData:__init()
	if MultiMountData.Instance ~= nil then
		ErrorLog("[MultiMountData] attempt to create singleton twice!")
		return
	end

	MultiMountData.Instance = self
	self.multi_mount_cfg = ConfigManager.Instance:GetAutoConfig("multi_mount_auto")
	self.mount_info_cfg = self.multi_mount_cfg.mount_info
	self.grade_cfg = ListToMap(self.multi_mount_cfg.grade, "mount_id", "grade")
	self.special_img_cfg = self.multi_mount_cfg.special_img_cfg
	self.special_img_grade_cfg = ListToMap(self.multi_mount_cfg.special_img_uplevel, "special_img_id", "grade")
	self.equip_cfg = self.multi_mount_cfg.equip

	self.special_grade_max_level = self:CalcSpecialImgMaxLevel()

	self.grade_bless_list = {[0] = 0, 0, 0, 0, 0}
	self.huanhua_data = {}
	self.is_init = true
	self.multi_mount_special_image_level_list = {}
	self.multi_mount_data_list = {}
	RemindManager.Instance:Register(RemindName.MultiMount, BindTool.Bind(self.GetMultiMountRemind, self))
	RemindManager.Instance:Register(RemindName.MultiMountHuanHua, BindTool.Bind(self.CalcHuanHuaRemind, self))	-- 双骑幻化红点
end

function MultiMountData:__delete()
	RemindManager.Instance:UnRegister(RemindName.MultiMount)
	RemindManager.Instance:UnRegister(RemindName.MultiMountHuanHua)
	MultiMountData.Instance = nil
end

function MultiMountData:SetMultiMountAllInfo(protocol)
	self.cur_use_mount_id = protocol.cur_use_mount_id or 0
	self.multi_mount_data_list = protocol.mount_list or {}

	if self.is_init and nil ~= next(self.multi_mount_data_list) then
		self.is_init = false
		for i = 1, GameEnum.MULTIMOUNT_MAX_ID do
			self.grade_bless_list[i] = self.multi_mount_data_list[i].grade_bless
		end
	end

	self.huanhua_data.used_special_img_id = protocol.cur_use_special_image_id
	self.huanhua_data.active_special_img_flag = protocol.special_img_active_flag
	self.huanhua_data.special_img_lv_list = protocol.special_img_lv_list

	self.equip_level_list = protocol.equip_level_list or {}

	self.multi_mount_special_image_level_list = protocol.special_image_level_list or {}
end

function MultiMountData:SetMultiMountChangeNotifyInfo(protocol)
	self.notify_type = protocol.notify_type
	self.param_1 = protocol.param_1
	self.param_2 = protocol.param_2
	self.param_3 = protocol.param_3

	if self.notify_type == MULTI_MOUNT_CHANGE_NOTIFY_TYPE.MULTI_MOUNT_CHANGE_NOTIFY_TYPE_SELECT_MOUNT then
		self.cur_use_mount_id = self.param_1
	elseif self.notify_type == MULTI_MOUNT_CHANGE_NOTIFY_TYPE.MULTI_MOUNT_CHANGE_NOTIFY_TYPE_UPGRADE then
		self.multi_mount_data_list[self.param_1].grade = self.param_2
		self.multi_mount_data_list[self.param_1].grade_bless = self.param_3
	elseif self.notify_type == MULTI_MOUNT_CHANGE_NOTIFY_TYPE.MULTI_MOUNT_CHANGE_NOTIFY_TYPE_ACTIVE_SPECIAL_IMG then
		local special_img_active_flag = {}
		local temp_flag = bit:d2b(self.param_1)						-- 特殊坐骑激活标志，0未激活，1激活
		for i = 1, 10 do
			special_img_active_flag[i] = temp_flag[32-i]
		end
		self.huanhua_data.active_special_img_flag = special_img_active_flag
		self.huanhua_data.special_img_lv_list[self.param_2] = self.param_3
	elseif self.notify_type == MULTI_MOUNT_CHANGE_NOTIFY_TYPE.MULTI_MOUNT_CHANGE_NOTIFY_TYPE_USE_SPECIAL_IMG then
		self.huanhua_data.used_special_img_id = self.param_1
	elseif self.notify_type == MULTI_MOUNT_CHANGE_NOTIFY_TYPE.MULTI_MOUNT_CHANGR_NOTIFY_TYPE_UPGRADE_EQUIP then
		self.equip_level_list[self.param_1] = self.param_2
	elseif self.notify_type == MULTI_MOUNT_CHANGE_NOTIFY_TYPE.MULTI_MOUNT_CHANGE_NOTIFY_TYPE_UPLEVEL_SPECIAL_IMG then
		if self.huanhua_data.special_img_lv_list then
			self.huanhua_data.special_img_lv_list[protocol.param_1] = protocol.param_2
		end
	end
end

--计算特殊形象等级上限
function MultiMountData:CalcSpecialImgMaxLevel()
	local level_limit = 0
	for k, v in pairs(self.special_img_grade_cfg) do
		for k2, v2 in pairs(v) do
			if v2.grade > level_limit then
				level_limit = v2.grade
			end
		end
		break
	end

	return level_limit
end

function MultiMountData:GetMultiMountChangeNotify()
	return {notify_type = self.notify_type, param_1 = self.param_1, param_2 = self.param_2, param_3 = self.param_3}
end

function MultiMountData:GetMultiMountInfoCfg()
	return self.mount_info_cfg or {}
end

function MultiMountData:GetMaxGradeByIndex(index)
	return #(self.grade_cfg[index] or {})
end

function MultiMountData:GetBigGrade(index, grade)
	if self.grade_cfg[index] and self.grade_cfg[index][grade] then
		return self.grade_cfg[index][grade].client_grade
	end
	return 0
end

function MultiMountData:GetMaxIndex()
	return #self.mount_info_cfg
end

-- 获取进阶丹id
function MultiMountData:GetGradeDanId(index, grade)
	if self.grade_cfg and self.grade_cfg[index] and self.grade_cfg[index][grade] then
		return self.grade_cfg[index][grade].upgrade_stuff_id
	end
end

function MultiMountData:GetMountIdByItemId(item_id)
	if self.multi_mount_cfg and self.multi_mount_cfg.grade then
		for k,v in pairs(self.multi_mount_cfg.grade) do
			if v and v.upgrade_stuff_id == item_id then
				return v.mount_id
			end
		end
	end
	return 0
end

function MultiMountData:GetCurUseMountId()
	return self.cur_use_mount_id or 1
end

function MultiMountData:GetCurMulitMountResId()
	local huanhua_resid = self:GetMultiMountHuanhuaResId()

	if self.cur_use_mount_id > 0 and huanhua_resid > 0 then
		return huanhua_resid
	end

	local mount_cfg = self.mount_info_cfg[self.cur_use_mount_id]
	return nil ~= mount_cfg and mount_cfg.res_id or 0
end

--获取对应的幻化image_id是否已使用
function MultiMountData:GetHuanHuaIdIsUsed(image_id)
	if nil == self.huanhua_data then
		return false
	end

	return self.huanhua_data.used_special_img_id == image_id
end

function MultiMountData:GetMulitMountResId(mount_id)
	local mount_cfg = self.mount_info_cfg[mount_id]
	return nil ~= mount_cfg and mount_cfg.res_id or 0
end


function MultiMountData:GetMultiMultiMountData()
	return self.multi_mount_data_list or {}
end

function MultiMountData:GetMultiMountAllCfg()
	return self.multi_mount_cfg or {}
end

function MultiMountData:GetMountLevelByIndex(index)
	if nil == self.multi_mount_data_list or nil == self.multi_mount_data_list[index] then return 0 end

	return self.multi_mount_data_list[index].grade or 0
end

function MultiMountData:GetMountInfoByIndex(index)
	return self.multi_mount_data_list[index]
end

function MultiMountData:GetMountNameByIndex(index)
	return self.mount_info_cfg[index] and self.mount_info_cfg[index].mount_name or ""
end

function MultiMountData:GetMountInfoCfgByIndex(index)
	return self.mount_info_cfg[index]
end

-- 获取坐骑是否可以进阶
function MultiMountData:GetMountCanJinJieByIndex(index)
	return self.multi_mount_data_list[index] and self.multi_mount_data_list[index].is_mount_active or 0
end

function MultiMountData:GetMountBlessValByIndex(index)
	return self.grade_bless_list[index] or 0
end

-- 获取坐骑激活需进阶的阶数
function MultiMountData:GetMountActiveLevel()
	local active_list = {}

	for i,v in ipairs(self.grade_cfg) do
		for i1,v1 in ipairs(v) do
			if v1.is_active_image == 1 then
				active_list[i] = v1.grade
				break
			end
		end
	end

	return active_list
end

function MultiMountData:GetMountIsActiveByIndex(index)
	local active_level_list = self:GetMountActiveLevel()
	if self.multi_mount_data_list[index] and self.multi_mount_data_list[index].grade > 0 then
		return true
	end
	return false
end

function MultiMountData:GetCurMountActiveCfg(index)
	local grade = 0
	local name = ""

	for k, v in pairs(self.grade_cfg[index] or {}) do
		if v.active_mount_id > 0 then
			grade = v.grade
			break
		end
	end

	for k, v in pairs(self.mount_info_cfg) do
		if v.mount_id == index then
			name = v.mount_name
		end
	end

	return grade, name
end

function MultiMountData:GetMountCfgByIdAndLevel(mount_id, level)
	if nil == mount_id or nil == level then return end

	local cfg = nil
	if self.grade_cfg[mount_id] and self.grade_cfg[mount_id][level] then
		cfg = self.grade_cfg[mount_id][level]
	end

	return cfg
end

function MultiMountData:GetAttrByIdAndLevel(mount_id, level)
	if nil == mount_id or nil == level then return end

	local attr = CommonStruct.Attribute()
	if self.grade_cfg[mount_id] and self.grade_cfg[mount_id][level] then
		local v = self.grade_cfg[mount_id][level]
		attr = CommonDataManager.GetAttributteByClass(v)
		attr.move_speed = v.move_speed
	end

	return attr
end


--双人坐骑幻化
function MultiMountData:GetMultiMountHuanhuaData()
	return self.huanhua_data
end

-- 获取双人坐骑幻化配置
function MultiMountData:GetMultiMountHuanhuaCfg()
	return self.special_img_cfg
end

-- 获取双人坐骑幻化配置
function MultiMountData:GetMultiMountHuanhuaCfgByIndex(index)
	return self.special_img_cfg[index]
end

-- 获取双人坐骑幻化配置
function MultiMountData:GetSpecialImageUpgradeCfg()
	return self.special_img_grade_cfg
end

-- 获取双人坐骑幻化配置
function MultiMountData:GetMultiMountHuanhuaId()
	return self.huanhua_data.used_special_img_id or 0
end

--获取对应幻化等级
function MultiMountData:GetHuanHuaGrade(image_id)
	if nil == self.huanhua_data.special_img_lv_list then
		return 0
	end

	return self.huanhua_data.special_img_lv_list[image_id] or 0
end

--获取对应幻化信息
function MultiMountData:GetHuanHuaCfgInfo(image_id, grade)
	grade = grade or self:GetHuanHuaGrade(image_id)

	if self.special_img_grade_cfg[image_id] then
		return self.special_img_grade_cfg[image_id][grade]
	end

	return nil
end

-- 获取双人坐骑幻化总属性(已激活)
function MultiMountData:GetMultiMountAllAttr()
	local special_img_cfg = self:GetMultiMountHuanhuaCfg()
	local m_attribute = CommonStruct.Attribute()
	for k,v in pairs(special_img_cfg) do
		if self:IsMultiMountImageActive(v.image_id) then
			local attr_list = CommonDataManager.GetAttributteByClass(v)
			m_attribute = CommonDataManager.AddAttributeAttr(m_attribute, attr_list)
		end
	end
	return m_attribute
end

-- 通过位运算，判断双人坐骑特殊形象是否激活
function MultiMountData:IsMultiMountImageActive(img_id)
	local huanhua_data = self:GetMultiMountHuanhuaData()
	if nil == huanhua_data.active_special_img_flag then return false end

	if 0 ~= huanhua_data.active_special_img_flag[img_id] then
		return true
	else
		return false
	end
end

-- 通过幻化id获取坐骑幻化配置
function MultiMountData:GetHuanhuaCfgByImageId(image_id)
	local special_img = self.special_img_cfg
	if special_img == nil then return nil end

	for i,v in pairs(special_img) do
		if v.image_id == image_id then
			return v
		end
	end
	return nil
end

function MultiMountData:GetMultiMountHuanhuaResId()
	if nil ~= self.huanhua_data and nil ~= self.huanhua_data.used_special_img_id and self.huanhua_data.used_special_img_id > 0 then
		local huanhuacfg = self:GetHuanhuaCfgByImageId(self.huanhua_data.used_special_img_id)
		return huanhuacfg and huanhuacfg.res_id or 0
	end
	return 0
end

function MultiMountData:GetMountImgIdByResID(res_id)
	for k,v in pairs(self.mount_info_cfg or {}) do
		if v.res_id == res_id then
			return v.mount_id
		end
	end
	return 1
end

--双人坐骑幻化物品展示
function MultiMountData:GetMultiMountResByItemId(item_id)
	if nil == item_id then return nil end
	for k,v in pairs(self.special_img_cfg) do
		if v.item_id == item_id then
			return v.res_id, v
		end
	end
	return nil
end

function MultiMountData:CanHuanhuaUpgrade()
	if self.huanhua_data.special_img_lv_list == nil then return nil end

	for i, v in pairs(self.special_img_grade_cfg) do
		local cur_grade = self.huanhua_data.special_img_lv_list[i] or 1
		if cur_grade < #v and v[cur_grade] and v[cur_grade].stuff_num <= ItemData.Instance:GetItemNumInBagById(v[cur_grade].stuff_id) then
			return v[cur_grade].special_img_id
		end
	end

	return nil
end

function MultiMountData:GetMaxSpecialImage()
	return #self.special_img_grade_cfg
end

-- 获取当前点击坐骑特殊形象的配置
function MultiMountData:GetSpecialImageUpgradeInfo(index, grade, is_next)
	if (index == 0) or self.huanhua_data.special_img_lv_list == nil then
		return
	end
	local grade = grade or self.huanhua_data.special_img_lv_list[index] or 0

	if is_next or grade == 0 then
		grade = grade + 1
	end

	if self.special_img_grade_cfg[index] then
		return self.special_img_grade_cfg[index][grade]
	end

	return nil
end

-- 获取幻化最大等级
function MultiMountData:GetSpecialImageMaxUpLevelById(image_id)
	if not image_id then return 0 end
	return #(self.special_img_grade_cfg[image_id] or {})
end


-- /坐骑幻化


 -- 坐骑战甲 
function MultiMountData:GetMuoutEquipLvlBySeq(seq)
	return self.equip_level_list[seq] or 0
end

function MultiMountData:GetMountEquipCfgBySeq(seq)
	local cfg = {}
	for k, v in pairs(self.equip_cfg) do
		if v.equip_type == seq then
			cfg = v
		end
	end

	return cfg
end

function MultiMountData:GetMountEquipCfgByItemId(item_id)
	local cfg = {}
	for k, v in pairs(self.equip_cfg) do
		if v.upgrade_need_stuff == item_id then
			cfg = v
		end
	end

	return cfg
end

function MultiMountData:GetMountZhanjiaGridShowData()
	local item_list = {}
	local index = 0

	for k, v in pairs(self.equip_cfg) do
		local item = {}
		item.seq = v.equip_type
		item.item_id = v.upgrade_need_stuff
		item.is_bind = 0
		item.upgrade_stuff_count = v.upgrade_stuff_count
		item.max_level = v.max_level
		item_list[index] = item
		index = index + 1
	end

	return item_list
end

function MultiMountData:GetMountEquipTotalAttr()
	local total_attr = CommonStruct.Attribute()
	for k, v in pairs(self.equip_level_list) do
		local cfg = CommonDataManager.GetAttributteByClass(self:GetMountEquipCfgBySeq(k))
		local attr = CommonDataManager.MulAttribute(cfg, v)
		total_attr = CommonDataManager.AddAttributeAttr(total_attr, attr)
	end

	return total_attr
end

-- /坐骑战甲

 -- 双人化形进阶
function MultiMountData:GetSepcialMultiMountLevelByImageId(image_id)
	return self.multi_mount_special_image_level_list[image_id]
end

function MultiMountData:GetSepcialMultiMountUpgradeCfg(image_id, level)
	for k,v in pairs(self.multi_mount_cfg.image_upgrade) do
		if v.level == level and v.image_id == image_id then
			return v
		end
	end
end

function MultiMountData:CanJinjie()
	for i,v in ipairs(self.grade_cfg) do
		if self:MountCanJinjie(i) then
			return true
		end
	end
	return false
end

function MultiMountData:MountCanJinjie(index)
	local is_act = self:GetMountIsActiveByIndex(index)
	local grade = self:GetMountLevelByIndex(index)
	local v = self.grade_cfg[index]
	local mount_info = MultiMountData.Instance:GetMountInfoByIndex(index)
	if mount_info and next(mount_info) then
		local max_grade = self:GetMaxGradeByIndex(index)
	-- if v and (index == 1 or is_act or self:GetMountIsActiveByIndex(index - 1)) and grade < #v then
		local stuff_item_id = v[grade].upgrade_stuff_id
		if stuff_item_id then
			if v[grade].upgrade_stuff_num <= ItemData.Instance:GetItemNumInBagById(stuff_item_id) and mount_info.grade < max_grade then
				return true
			end
		end
	-- end
	end
	return false
end

function MultiMountData:GetMultiMountRemind()
	if self:CanJinjie() then
		return 1
	elseif self:CanHuanhuaUpgrade() ~= nil then
		return 1
	end
	return 0
end

function MultiMountData:GetMultiMountSitTypeByResid(res_id)
	for k,v in pairs(self.mount_info_cfg) do
		if v.res_id == res_id then
			return v.sit_1, v.sit_2
		end
	end
	for k,v in pairs(self.special_img_cfg) do
		if v.res_id == res_id then
			return v.sit_1, v.sit_2
		end
	end
	return 0, 0
end

--获取特殊形象等级上限
function MultiMountData:GetSpecialImgMaxLevel()
	return self.special_grade_max_level
end

--计算幻化形象红点
function MultiMountData:CalcHuanHuaRemind()
	if nil == self.huanhua_data.special_img_lv_list then
		return 0
	end

	--判断是否有幻化形象可激活或可升级
	local grade_list = nil				--对应资源的等级列表
	local grade_info = nil				--对应等级相关数据
	local img_info = nil				--对应资源相关数据
	local have_num = 0
	local open_server_day = TimeCtrl.Instance:GetCurOpenServerDay()
	local main_vo = GameVoManager.Instance:GetMainRoleVo()
	for k, v in ipairs(self.huanhua_data.special_img_lv_list) do
		grade_list = self.special_img_grade_cfg[k]
		img_info = self.special_img_cfg[k]

		--达到对应开服天数, 人物等级达到要求, 当前等级数据存在且下一级数据也存在则进入物品数量判断
		if img_info
			and open_server_day >= img_info.open_day
			and main_vo.level >= img_info.lvl
			and grade_list
			and grade_list[v]
			and grade_list[v + 1] then

			grade_info = grade_list[v]
			have_num = ItemData.Instance:GetItemNumInBagById(grade_info.stuff_id)
			if have_num >= grade_info.stuff_num then
				return 1
			end
		end
	end

	return 0
end

function MultiMountData:GetHuanHuaSpecialAttrActiveType(grade, index)
	local grade = grade or self:GetHuanHuaGrade(index) or 0
	return AppearanceData.Instance:GetSpecialAttrActiveType(self.multi_mount_cfg.special_img_uplevel, grade, index)
end
