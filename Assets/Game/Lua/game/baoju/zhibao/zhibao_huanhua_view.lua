ZhiBaoHuanHuaView = ZhiBaoHuanHuaView or BaseClass(BaseView)

local attr_name_list = {
	ShengMing = "max_hp",
	GongJi = "gong_ji",
	FangYu = "fang_yu",
	ShanBi = "shan_bi",
	MingZhong = "ming_zhong",
	BaoJi = "bao_ji",
	JianRen = "jian_ren",
}

function ZhiBaoHuanHuaView:__init()
	self.ui_config = {{"uis/views/baoju_prefab", "ZhiBaoHuanHuaView"}}

	self.prefab_preload_id = 0

	self.cell_list = {}
end

function ZhiBaoHuanHuaView:LoadCallBack()

	self.node_list["BtnClose"].button:AddClickListener(BindTool.Bind(self.OnClickClose, self))
	self.node_list["BtnActivate"].button:AddClickListener(BindTool.Bind(self.ActivateClick, self))
	self.item_cell = ItemCell.New()
	self.item_cell:SetInstanceParent(self.node_list["ItemCell"])
	self.node_list["UseImageButton"].button:AddClickListener(BindTool.Bind(self.UseImageClick, self))
	self.need_item_text ="0"
	self.have_item_text ="0"

	self.attr_list = {}
	local item_manager = self.node_list["ItemManager"]
	local child_number = item_manager.transform.childCount
	for i = 0, child_number - 1 do
		local attr_pair = U3DObject(item_manager.transform:GetChild(i).gameObject)
		local data = {}

		data.name = item_manager.transform:GetChild(i).gameObject.name
		data.attr_name = attr_pair.transform:FindHard("Label")
		data.attr_value = attr_pair.transform:FindHard("Value")
		self.attr_list[i + 1] = data
	end

	self.select_index = 1
	self.cell_list = {}
	self.scroller_data = ZhiBaoData.Instance:GetZhiBaoHuanHuaCfg()
	local list_delegate = self.node_list["ListView"].list_simple_delegate
	list_delegate.NumberOfCellsDel = BindTool.Bind(self.GetNumberOfCells, self)
	list_delegate.CellRefreshDel = BindTool.Bind(self.CellRefresh, self)

	self.init_flag = true

	self:InitEquipModel()
end

function ZhiBaoHuanHuaView:InitEquipModel()
	if not self.equip_model then
		self.equip_model = RoleModel.New()
		self.equip_model:SetDisplay(self.node_list["CenterDisplay"].ui3d_display)
	end
end

function ZhiBaoHuanHuaView:SetModelData()
	local index = self.select_index - 1
	local res_id = ZhiBaoData.Instance:GetSpecialResId(index)
	local bubble, asset = ResPath.GetFaBaoModel(res_id)

	PrefabPreload.Instance:StopLoad(self.prefab_preload_id)

	local load_list = {{bubble, asset}}
	self.prefab_preload_id = PrefabPreload.Instance:LoadPrefables(load_list, function()
			self.equip_model:SetMainAsset(bubble, asset)
			self.equip_model:SetLoopAnimal("bj_rest", "rest_stop")
		end)
end

function ZhiBaoHuanHuaView:ReleaseCallBack()
	self.init_flag = false

	if self.item_cell then
		self.item_cell:DeleteMe()
		self.item_cell = nil
	end

	if self.equip_model then
		self.equip_model:DeleteMe()
		self.equip_model = nil
	end

	for k, v in pairs(self.cell_list) do
		v:DeleteMe()
	end
	self.cell_list = {}

	PrefabPreload.Instance:StopLoad(self.prefab_preload_id)

	-- 清理变量和对象
	self.use_image_button = nil
	self.image_name = nil
	self.is_show_using_icon = nil
	self.power = nil
	self.need_item_text = nil
	self.have_item_text = nil
	self.button_name = nil
	self.level = nil
	self.is_show_max_level_tips = nil
	self.attr_list = nil
	self.list_view = nil
	self.center_display = nil
end

function ZhiBaoHuanHuaView:FlushScroller()
	if self:IsLoaded() then
		self.node_list["ListView"].scroller:RefreshActiveCellViews()
	end
end

function ZhiBaoHuanHuaView:OpenCallBack()
	local use_image = ZhiBaoData.Instance:GetZhiBaoImage()
	if use_image >= 1000 then
		self.select_index = use_image - 999
	else
		self.select_index = 1
	end
	self:Flush()
	self:SetModelData()
end

function ZhiBaoHuanHuaView:OnFlush()
	if not self.init_flag then
		return
	end
	local data_type = self.scroller_data[self.select_index]
	local data = ZhiBaoData.Instance:GetHuanHuaLevelCfg(data_type.huanhua_type)
	if data == nil or next(data) == nil then
		print_error("error in page:145")
		return
	end

	local huanhua_level = ZhiBaoData.Instance:GetHuanHuaLevelByType(data.huanhua_type)
	--已激活
	if huanhua_level > 0 then
		self.node_list["TxtActivateBtn"].text.text = Language.BaoJu.HuanHuaJinJie
		--是否使用中
		local using_image = ZhiBaoData.Instance:GetZhiBaoImage()
		if using_image >= 1000 and using_image - 1000 == data.huanhua_type then
			self.node_list["ImgUseImage"]:SetActive(true)
			self.node_list["UseImageButton"]:SetActive(false)
		else
			self.node_list["ImgUseImage"]:SetActive(false)
			self.node_list["UseImageButton"]:SetActive(true)
		end
		--升阶材料
		local next_level_cfg = ZhiBaoData.Instance:GetHuanHuaLevelCfg(data.huanhua_type, true)
		if next_level_cfg == nil then
			--升到最高级
			self.node_list["PanelTipExchange"]:SetActive(false)
			self.node_list["TxtMaxLevelTips"]:SetActive(true)
		else
			self.node_list["PanelTipExchange"]:SetActive(true)
			self.node_list["TxtMaxLevelTips"]:SetActive(false)
			self:SetMaterial(next_level_cfg.stuff_id, next_level_cfg.stuff_count)
		end
		self.node_list["TxtLevel"].text.text = 'Lv.'..(huanhua_level)
	--未激活
	else
		self.node_list["PanelTipExchange"]:SetActive(true)
		self.node_list["TxtMaxLevelTips"]:SetActive(false)
		self.node_list["TxtLevel"].text.text = ""
		self.node_list["TxtActivateBtn"].text.text = Language.BaoJu.Activate
		self.node_list["UseImageButton"]:SetActive(false)
		self.node_list["ImgUseImage"]:SetActive(false)
		--激活材料
		self:SetMaterial(data.stuff_id, data.stuff_count)
	end
	local level_cfg = ZhiBaoData.Instance:GetHuanHuaLevelCfg(data.huanhua_type)
	if not level_cfg then
		print_error("error in page:186")
		return
	end
	local attrs = CommonDataManager.GetAttributteByClass(level_cfg)
	--战力
	local power = CommonDataManager.GetCapabilityCalculation(attrs)
	self.node_list["TxtFightPower"].text.text = power
	--属性
	local count = 1
	for k,v in pairs(attrs) do
		if v > 0 then
			for k2, v2 in ipairs(self.attr_list) do
				local name = v2.name
				if attr_name_list[name] == k then
					v2.attr_name.text.text = CommonDataManager.GetAttrName(k)..':'
					v2.attr_value.text.text = v
					break
				end
			end
		end
	end

	--道具
	local item_data = {}
	item_data.item_id = level_cfg.stuff_id
	item_data.num = 1
	item_data.is_bind = 0
	self.item_cell:SetData(item_data)
	local item_cfg = ItemData.Instance:GetItemConfig(level_cfg.stuff_id)
	if item_cfg == nil then return end
	local name_str = "<color="..SOUL_NAME_COLOR[item_cfg.color]..">".. data.name .."</color>"
	self.node_list["TxtName"].text.text = name_str

	self:FlushScroller()
end

--设置显示的材料
function ZhiBaoHuanHuaView:SetMaterial(item_id, item_count)
	local item_cfg = ItemData.Instance:GetItemConfig(item_id)
	local had_num = ItemData.Instance:GetItemNumInBagById(item_id)

	if item_count > had_num then
		self.have_item_text = string.format("%s",ToColorStr(had_num, TEXT_COLOR.RED))
	else
		self.have_item_text = string.format("%s",ToColorStr(had_num, TEXT_COLOR.GREEN))
	end

	self.need_item_text = string.format("%s",ToColorStr(item_count, TEXT_COLOR.GREEN))
	self.node_list["TxtNeedNumber"].text.text = string.format("%s / <color=#00ff00>%s</color>", self.have_item_text, self.need_item_text)
end

--使用形象按下后
function ZhiBaoHuanHuaView:UseImageClick()
	local data = self.scroller_data[self.select_index]
	ZhiBaoCtrl.Instance:SendActiveHuanhua(1, data.huanhua_type)
end

--激活/升阶按下后
function ZhiBaoHuanHuaView:ActivateClick()
	local data = self.scroller_data[self.select_index]
	ZhiBaoCtrl.Instance:SendActiveHuanhua(0, data.huanhua_type)
end

--滚动条----------------------
function ZhiBaoHuanHuaView:GetNumberOfCells()
	return #self.scroller_data
end

function ZhiBaoHuanHuaView:CellRefresh(cell, data_index)
	data_index = data_index + 1
	local tmp_cell = self.cell_list[cell]
	if tmp_cell == nil then
		self.cell_list[cell] = ZhiBaoHuanHuaCell.New(cell)
		tmp_cell = self.cell_list[cell]
		tmp_cell:SetMotherView(self)
		tmp_cell:SetToggleGroup(self.node_list["ListView"].toggle_group)
	end
	local data = self.scroller_data[data_index]
	data.data_index = data_index
	tmp_cell:SetData(data)
end

function ZhiBaoHuanHuaView:OnCellSelect(data_index)
	self.select_index = data_index
end

function ZhiBaoHuanHuaView:OnClickClose()
	self:Close()
end

-------------------------------------------------------
ZhiBaoHuanHuaCell = ZhiBaoHuanHuaCell or BaseClass(BaseCell)

function ZhiBaoHuanHuaCell:__init()


	self.node_list["ZhiBaoHuanHuaItem"].toggle:AddClickListener(BindTool.Bind(self.OnClick, self))
end

function ZhiBaoHuanHuaCell:__delete()
	self.mother_view = nil
end

function ZhiBaoHuanHuaCell:SetMotherView(view)
	self.mother_view = view
end

function ZhiBaoHuanHuaCell:SetToggleGroup(group)
	self.root_node.toggle.group = group
end

function ZhiBaoHuanHuaCell:OnFlush()
	--是否使用中
	local using_image = ZhiBaoData.Instance:GetZhiBaoImage()
	if using_image >= 1000 and using_image - 1000 == self.data.huanhua_type then
		self.node_list["ImgShowUse"]:SetActive(true)
	else
		self.node_list["ImgShowUse"]:SetActive(false)
	end

	local flag = ZhiBaoData.Instance:CheckHuanHuaCanUpgradeByType(self.data.huanhua_type)
	self.node_list["ImgRedPoint"]:SetActive(flag)
	self.root_node.toggle.isOn = (self.mother_view.select_index == self.data.data_index)

	local huanhua_data = ZhiBaoData.Instance:GetHuanHuaLevelCfg(self.data.huanhua_type)
	if not huanhua_data then
		print_error("error in page:321")
		return
	end
	local bundle, asset = ResPath.GetItemIcon(huanhua_data.stuff_id)

	local item_cfg = ItemData.Instance:GetItemConfig(huanhua_data.stuff_id)
	if item_cfg == nil then return end
	local name_str = "<color="..SOUL_NAME_COLOR[item_cfg.color]..">".. huanhua_data.name .."</color>"
	self.node_list["TxtName"].text.text = name_str
	self.node_list["ImgIcon"].image:LoadSprite(bundle, asset .. ".png")
end

function ZhiBaoHuanHuaCell:OnClick()
	local select_index = self.mother_view.select_index
	if select_index == self.data.data_index then
		return
	end
	self.mother_view:OnCellSelect(self.data.data_index)
	self.mother_view:Flush()
	self.mother_view:SetModelData()
end

