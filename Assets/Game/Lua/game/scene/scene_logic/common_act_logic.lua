-------------------------------------------
--基础活动逻辑,所有活动逻辑都继承这个
--@author bzw
--------------------------------------------
CommonActivityLogic = CommonActivityLogic or BaseClass(BaseFbLogic)

function CommonActivityLogic:__init()

end

function CommonActivityLogic:__delete()

end

function CommonActivityLogic:Enter(old_scene_type, new_scene_type)
	BaseFbLogic.Enter(self, old_scene_type, new_scene_type)
end

--退出
function CommonActivityLogic:Out(old_scene_type, new_scene_type)
	BaseFbLogic.Out(self, old_scene_type, new_scene_type)
	if new_scene_type ~= SceneType.CrossGuild then
		GuajiCtrl.Instance:SetMoveToPosCallBack(nil)
	end
end

-- 活动时间
function CommonActivityLogic:OpenActivitySceneCd(act_type)
	-- local activity_info = ActivityData.Instance:GetActivityStatuByType(act_type)
	-- if nil ~= activity_info then
	-- 	MainuiCtrl.Instance:SetFbIconEndCountDown(activity_info.next_time)
	-- end
end

function CommonActivityLogic:OnClickHeadHandler(is_show)
	-- BaseFbLogic.OnClickHeadHandler(self)
end

-- 是否可以拉取移动对象信息
function CommonActivityLogic:CanGetMoveObj()
	return false
end