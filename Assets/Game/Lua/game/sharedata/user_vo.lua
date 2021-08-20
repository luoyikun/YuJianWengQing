
UserVo = UserVo or BaseClass()

-- 仅用来处理服务器登录流程
-- 主要是保存着平台相关的信息、角色列表、session_key、场景ID，场景key

PLAT_ACCOUNT_TYPE_COMMON = 0
PLAT_ACCOUNT_TYPE_TEST = 1

function UserVo:__init()
	if UserVo.Instance then
		print_error("[UserVo] Attempt to create singleton twice!")
		return
	end
	UserVo.Instance = self

	--登录平台信息
	self.plat_name = ""
	self.old_plat_name = ""
	self.plat_account_type = 0						-- 0正常，1测试
	self.plat_session_key = ""						-- php返回的加密sign
	self.plat_login_time = 0
	self.plat_fcm = 0								-- 防沉迷标记
	self.plat_server_id = 1
	self.real_server_id = 1
	self.old_plat_id = 1
	self.plat_is_verify = false
	self.plat_server_name = ""
	self.ext = ""

	-- 角色登录信息
	self.now_role_index = 0
	self.role_list = {}
	self.role_count = 0
	self.is_role_list_get = false

	self.login_time = 0
	self.anti_wallow = 0
	self.session_key = ""
	self.gs_index = 0

	self.scene_id = 0
	self.last_scene_id = 0
end

function UserVo:__delete()
	UserVo.Instance = nil
end

function UserVo:ClearRoleList()
	self.role_list = {}
	self.role_count = 0
end

--添加角色到角色列表
function UserVo:AddRole(role_id, role_name, avatar, sex, prof, country, level, create_time, last_login_time, role_info, wuqi_id, shizhuang_wuqi, shizhuang_body, wing_used_imageid, halo_used_imageid)
	local role_info = {}
	self.role_count = self.role_count + 1
	self.role_list[self.role_count] = role_info
	role_info.role_id = role_id
	role_info.role_name = role_name
	role_info.avatar = avatar
	role_info.sex = sex
	role_info.prof = prof
	role_info.country = country
	role_info.level = level
	role_info.create_time = create_time
	role_info.last_login_time = last_login_time
	role_info.wuqi_id = wuqi_id
	role_info.shizhuang_wuqi = shizhuang_wuqi
	role_info.shizhuang_body = shizhuang_body
	role_info.wing_used_imageid = wing_used_imageid
	role_info.halo_used_imageid = halo_used_imageid
end

function UserVo:SetNowRole(role_id)
	local is_set_suc = false
	for i = 1, self.role_count, 1 do
		if self.role_list[i].role_id == role_id then
			local now_role = self.role_list[i]
			local main_role_vo = GameVoManager.Instance:GetMainRoleVo()

			main_role_vo.role_id = now_role.role_id
			main_role_vo.server_id = UserVo.GetServerId(now_role.role_id)
			main_role_vo.role_name = now_role.role_name
			main_role_vo.avatar = now_role.avatar
			main_role_vo.sex = now_role.sex
			main_role_vo.prof = now_role.prof
			main_role_vo.country = now_role.country
			main_role_vo.level = now_role.level
			main_role_vo.create_time = now_role.create_time
			main_role_vo.last_login_time = now_role.last_login_time
			main_role_vo.wuqi_id = now_role.wuqi_id
			main_role_vo.shizhuang_wuqi = now_role.shizhuang_wuqi
			main_role_vo.shizhuang_body = now_role.shizhuang_body
			main_role_vo.wing_used_imageid = now_role.wing_used_imageid
			main_role_vo.halo_used_imageid = now_role.halo_used_imageid

			self.now_role_index = i
			self.real_server_id = main_role_vo.server_id

			is_set_suc = true

			break
		end
	end

	if not is_set_suc then
		print_error("try to set now role to a unexist role!")
	end
end

-- 根据角色id获取服id
function UserVo.GetServerId(role_id)
	return bit:_rshift(role_id, 20)
end
