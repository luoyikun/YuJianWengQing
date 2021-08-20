require("game/marriage/baobao/baobao_image_view")
require("game/marriage/baobao/baobao_attr_view")
require("game/marriage/baobao/baobao_aptitude_view")
require("game/marriage/baobao/baobao_bless_view")
require("game/marriage/baobao/baobao_guard_view")

BaoBaoView = BaoBaoView or BaseClass(BaseRender)

function BaoBaoView:__init(instance, mother_view)
	self.parent = mother_view
	self.cur_index = TabIndex.marriage_baobao
	self.is_show_aptitude = false

	self.image_view = BaoBaoImageView.New(self.node_list["ImageView"])
	self.attr_view = BaoBaoAttrView.New(self.node_list["AttrView"])
	self.aptitude_view = BaoBaoAptitudeView.New(self.node_list["AptitudeView"], self)
	self.bless_view = BaoBaoBlessView.New(self.node_list["BlessView"])
	self.guard_view = BaoBaoGuardView.New(self.node_list["GuardView"])

	self.node_list["AptitudeView"]:SetActive(false)
	self.node_list["AttrView"]:SetActive(true)

	BaobaoData.Instance:SetSelectedBabyIndex(1)
	self.node_list["BtnZizhi"].button:AddClickListener(BindTool.Bind(self.OpenZizhiClick, self, true))
	self.node_list["AttrToggle"].toggle:AddValueChangedListener(BindTool.Bind(self.OnToggleChange,self, TabIndex.marriage_baobao))
	self.node_list["BessToggle"].toggle:AddValueChangedListener(BindTool.Bind(self.OnToggleChange,self, TabIndex.marriage_baobao_bless))
	self.node_list["GuardToggle"].toggle:AddValueChangedListener(BindTool.Bind(self.OnToggleChange,self, TabIndex.marriage_baobao_guard))
end

function BaoBaoView:__delete()
	if self.image_view then
		self.image_view:DeleteMe()
		self.image_view = nil
	end
	if self.attr_view then
		self.attr_view:DeleteMe()
		self.attr_view = nil
	end
	if self.aptitude_view then
		self.aptitude_view:DeleteMe()
		self.aptitude_view = nil
	end
	if self.bless_view then
		self.bless_view:DeleteMe()
		self.bless_view = nil
	end
	if self.guard_view then
		self.guard_view:DeleteMe()
		self.guard_view = nil
	end
end

function BaoBaoView:ShowOrHideTab()
	
end

function BaoBaoView:OnToggleChange(index, is_on)
	if not is_on then return end
	self.cur_index = index
	self.parent:Flush("baobao")
end

function BaoBaoView:SelectBaoBaoGuard()
	self.node_list["GuardToggle"].toggle.isOn = true
end

function BaoBaoView:OpenBaobaoCallBack()
	local baby_list = BaobaoData.Instance:GetListBabyData() or {}
	if #baby_list <= 0 then
		self.bless_toggle.isOn = true
	else
		ViewManager.Instance:FlushView(ViewName.Marriage, "baobao")
	end
end

function BaoBaoView:FlushView()
	if self.parent.cur_index ~= TabIndex.marriage_baobao then return end
	if self.cur_index == TabIndex.marriage_baobao then
		self.image_view:FlushView()
		if self.is_show_aptitude then
			self.aptitude_view:FlushView()
		else
			self.attr_view:FlushView()
		end
	elseif self.cur_index == TabIndex.marriage_baobao_bless then
		self.bless_view:FlushView()
	elseif self.cur_index == TabIndex.marriage_baobao_guard then
		self.image_view:FlushView()
		self.guard_view:FlushView()
	end
end

function BaoBaoView:OpenZizhiClick(value)
	local baby_list = BaobaoData.Instance:GetListBabyData() or {}
	if #baby_list <= 0 then
		SysMsgCtrl.Instance:ErrorRemind(Language.Marriage.HaveNotBaby)
		return
	end
	self.is_show_aptitude = value
	self.node_list["AptitudeView"]:SetActive(value)
	self.node_list["AttrView"]:SetActive(not value)
	if self.is_show_aptitude then
		self.aptitude_view:FlushView()
	else
		self.attr_view:FlushView()
	end
end