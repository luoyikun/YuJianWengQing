require("game/recharge_capacity/recharge_capacity_view")
require("game/recharge_capacity/recharge_capacity_data")

RechargeCapacityCtrl = RechargeCapacityCtrl or BaseClass(BaseController)
function RechargeCapacityCtrl:__init()
	if RechargeCapacityCtrl.Instance then
		print_error("[RechargeCapacityCtrl] Attemp to create a singleton twice !")
	end
	RechargeCapacityCtrl.Instance = self

	self.recharge_capacity_data = RechargeCapacityData.New()
	self.recharge_capacity_view = RechargeCapacityView.New(ViewName.RechargeCapacity)

	self:RegisterAllProtocols()
end

function RechargeCapacityCtrl:__delete()
	RechargeCapacityCtrl.Instance = nil

	if self.recharge_capacity_view then
		self.recharge_capacity_view:DeleteMe()
		self.recharge_capacity_view = nil
	end

	if self.recharge_capacity_data then
		self.recharge_capacity_data:DeleteMe()
		self.recharge_capacity_data = nil
	end
end

function RechargeCapacityCtrl:RegisterAllProtocols()
	RemindManager.Instance:Fire(RemindName.RechargeCapacity)
end