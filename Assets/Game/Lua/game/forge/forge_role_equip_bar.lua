RoleEquipBar = RoleEquipBar or BaseClass(BaseRender)
local Defult_Icon_List = {
	{100, 200, 300}, {1100, 1200, 1300}, {3100, 3200, 3300}, {4100, 4200 ,4300}, {5100, 5200, 5300}, {6100, 6200, 6300}, {8100, 8200, 8300}, 9100, {2100, 2200, 2300}, 9100
	}
--装备格列表和数据列表都是从0开始的

function RoleEquipBar:__init()
	self.role_view_index = 101
	self.select_index = 0
	self.click_callback_list = {}
	self.equip_list = {}
	for i = 0, 9 do
		self.equip_list[i] = EquipCell.New(self.node_list["EquipBarItem" .. i])
		self.equip_list[i].toggle.group = self.root_node.toggle_group
		self.equip_list[i].mother_view = self
	end
	self.equip_data = {}
	self:RefreshEquipData()
	self:LoadEquipData()
end

function RoleEquipBar:__delete()
	for k, v in pairs(self.equip_list) do
		v:DeleteMe()
	end

	self.click_callback_list = {}
end

function RoleEquipBar:LoadEquipData()
	for k,v in pairs(self.equip_list) do
		self.equip_list[k]:SetData(self.equip_data[k])
	end
end

--得到选中物品的数据
function RoleEquipBar:GetSelectData()
	local data = self.equip_data[self.select_index]
	if data ~= nil then
		data.item_cfg = ConfigManager.Instance:GetAutoItemConfig("equipment_auto")[data.item_id]
		return data
	end
end


-- 格子点击后的回调函数
function RoleEquipBar:OnClick(data_index)
	local data = self.equip_data[data_index]
	ForgeData.Instance:SetCurItemData(data)

	if self.select_index == data_index then
		return
	end

	self.select_index = data_index
	local call_back = self.click_callback_list[self.role_view_index]
	if call_back ~= nil then
		call_back(data_index, data)
	end
end

-- 设定装备条格子点击后的回调函数
function RoleEquipBar:SetClickCallBack(view_index, call_back)
	if self.click_callback_list[view_index] == nil then
		self.click_callback_list[view_index] = call_back
	end
end

--更新装备条Data
function RoleEquipBar:RefreshEquipData()
	self.equip_data = {}
	local equip_data = EquipData.Instance:GetDataList()
	for i = 0, COMMON_CONSTS.MAX_CAN_FORGE_EQUIP_NUM - 1 do
		self.equip_data[i] = equip_data[i] or {}
		self.equip_data[i].data_index = i
	end

end

function RoleEquipBar:SelectFirst()
	for i = 0, COMMON_CONSTS.MAX_CAN_FORGE_EQUIP_NUM - 1 do
		local id = self.equip_data[i].item_id
		if self.role_view_index == TabIndex.forge_red_equip then
			if ForgeData.Instance:CheckEquipCanSelect(self.equip_data[i]) then
				self:SetToggle(i)
				return
			end
		else
			if id ~= nil and id ~= 0 then
				self:SetToggle(i)
				return
			end
		end
	end
end

function RoleEquipBar:SetToggle(index)
	for k,v in pairs(self.equip_list) do
		v.toggle.isOn = false
	end
	self.equip_list[index].toggle.isOn = false
	self.equip_list[index].toggle.isOn = true
	local call_back = self.click_callback_list[self.role_view_index]
	local data = self.equip_data[index]
	if call_back ~= nil then
		call_back(index, data)
	end
end

--主角的装备变化时
function RoleEquipBar:OnEquipDataChange()
	self:RefreshEquipData()
	self:LoadEquipData()

	local data = self.equip_data[self.select_index]
	if data and data.param and data.param.shen_level == 10 then
		if self.role_view_index == TabIndex.forge_cast then
			ForgeCast.Instcance:SetEquipModel(data)
		end
	end

end

-- 设定当前选择了哪个面板
function RoleEquipBar:SetViewIndex(index)
	self.role_view_index = index
	self:LoadEquipData()
end

--------------------------------------------------------------------------
--装备格子
--------------------------------------------------------------------------
EquipCell = EquipCell or BaseClass(BaseCell)
function EquipCell:__init()
	self.is_use_step_calc = true								-- 使用分步计算
	self.item_cell = ItemCell.New()
	self.item_cell:SetInstanceParent(self.node_list["ItemCell"])
	self.item_cell:SetInteractable(false)
	self.toggle = self.root_node.toggle
	self.node_list["ShengText"]:SetActive(false)
	self.node_list["EquipBarItem"].toggle:AddClickListener(BindTool.Bind(self.OnValueChangeClick, self))
end

function EquipCell:__delete()
	if self.item_cell then
		self.item_cell:DeleteMe()
		self.item_cell = nil
	end
end

function EquipCell:ShowEmpty()
	if not self.toggle.interactable then
		return
	end
	self.toggle.interactable = false
	self.node_list["BtnImprove"]:SetActive(false)
	self.node_list["ShengText"]:SetActive(false)

	local data_index = self.data.data_index
	local target_id = 0

	if data_index < 2 then			--TODO 目前没有指定的置灰图标
		target_id = data_index
	elseif data_index <= 5 then
		target_id = data_index + 1
	elseif data_index == 8 then
		target_id = 2
	elseif data_index == 9 then
		target_id = 9
	else
		target_id = data_index + 2
	end

	local data = {}
	if type(Defult_Icon_List[index]) == "table" then
		data.item_id = Defult_Icon_List[target_id][0]
	else
		data.item_id = Defult_Icon_List[target_id]
	end
	self.node_list["EquipNameText"].text.text = Language.Forge.HaventEquip
	self.node_list["EquipNameText2"].text.text = Language.Forge.HaventEquip
	self.item_cell:SetData(self.data)
	self.item_cell:SetIconGrayScale(true)
	local asset,bundle = ResPath.GetItemIcon(target_id * 1000 + 100)
	self.item_cell:SetAsset(asset, bundle .. ".png")
	self.node_list["LockImg"]:SetActive(false)
	self.item_cell:SetIconGrayVisible(false)
	self.item_cell:SetInteractable(false)
end

function EquipCell:OnFlush()
	if self.data.item_id == nil then
		self:ShowEmpty()
		return
	end
	self.toggle.interactable = true

	--Toggle是否激活
	if self.mother_view.select_index == self.data.data_index then
		self.mother_view.root_node:GetComponent(typeof(UnityEngine.UI.ToggleGroup)):SetAllTogglesOff()
		self.toggle.isOn = false
		self.toggle.isOn = true
		
	else
		self.toggle.isOn = false
	end

	self.item_cell:SetData(self.data)
		local item_cfg = ItemData.Instance:GetItemConfig(self.data.item_id)
		self.node_list["EquipNameText"].text.text = item_cfg.name
		self.node_list["EquipNameText2"].text.text = item_cfg.name

	local role_view_index = self.mother_view.role_view_index
	if role_view_index == TabIndex.forge_red_equip then
		local value = ForgeData.Instance:CheckEquipCanSelect(self.data)
		self.item_cell:SetIconGrayVisible(not value)
		self.node_list["LockImg"]:SetActive(not value)
		self.item_cell:SetInteractable(value)
		self.item_cell:SetHighLight(self.toggle.isOn and value)
		self.item_cell:SetIconGrayScale(false)
	else
		self.item_cell:SetInteractable(true)
		self.item_cell:SetIconGrayScale(false)
		self.node_list["LockImg"]:SetActive(false)
		self.item_cell:SetIconGrayVisible(false)
	end


	if role_view_index == TabIndex.forge_strengthen then
		if self.data.param.strengthen_level > 0 then
		end
		self.node_list["ShengText"]:SetActive(false)
	elseif role_view_index == TabIndex.forge_cast then
		if self.data.param.shen_level > 0 then
			self.node_list["ShengText"].text.text = Language.Forge.ShengLevel[self.data.param.shen_level]
			self.node_list["ShengText"]:SetActive(true)
		end
	else
		self.node_list["ShengText"]:SetActive(false)
		if self.data.param.strengthen_level > 0 then
		end
	end

	--是否能强化/升品/神铸
	local can_improve, improve_type = ForgeData.Instance:CheckIsCanImprove(self.data, role_view_index)
	if can_improve == 0 then
		self.node_list["BtnImprove"]:SetActive(true)
	else
		self.node_list["BtnImprove"]:SetActive(false)
	end
end

function EquipCell:OnValueChangeClick(p_bool)
	if p_bool then
		self.mother_view:OnClick(self.data.data_index)
	end
end

function EquipCell:OnClick()
	
end

function EquipCell:SetBackgroudHL(is_hl)
	
end




