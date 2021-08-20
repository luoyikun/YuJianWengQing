FollowObj = FollowObj or BaseClass(Character)

function FollowObj:__init(vo)
	---------------- 子类可以修改的参数 ----------------------
	-- 主人obj_id
	self.owner_obj_id = vo.owner_obj_id or 0x10000
	-- 是否随机漫步
	self.is_wander = false
	-- 跟随偏移值
	self.follow_offset = 0
	-- 最大速度
	self.max_speed = 13
	-- 最大速度平方
	self.sqrt_max_speed = 13 * 13
	-- 最大牵引力
	self.max_force = 20
	-- 最大牵引力平方
	self.sqrt_max_force = 20 * 20
	-- 质量
	self.mass = 1
	-- 最大距离平方（超出这个距离则瞬移到跟随的物体）
	self.sqrt_max_distance = 50 * 50
	-- 减速距离平方
	self.sqrt_slow_down_distance = 4 * 4
	-- 停止距离
	self.stop_distance = 2
	-- 停止距离平方
	self.sqrt_stop_distance = 2 * 2
	-- 随机漫步范围
	self.wander_distance = 4
	-- 随机漫步范围平方
	self.sqrt_wander_distance = 4 * 4
	-- 随机漫步速度
	self.max_wander_speed = 7
	-- 随机漫步CD
	self.wander_cd = 7
	-- 是否可更改最大
	self.const_max_speed = false

	------------------ 子类不可修改的参数 ------------------
	-- 加速度
	self.acceleration = u3d.vec3(0, 0, 0)
	-- 速率
	self.velocity = u3d.vec3(0, 0, 0)
	-- target的坐标
	self.last_target_pos = u3d.vec3(0, 0, 0)

	self.check_cd = 0.2
	self.timer = 0
	self.is_stop_move = true
	self.last_wander_time = 0
	self.last_wander_pos = u3d.vec3(0, 0, 0)
end

function FollowObj:__delete()
	self.same_group = {}
end

function FollowObj:InitShow()
	Character.InitShow(self)
	self:UpdateMoveSpeed()
	local target = Scene.Instance:GetObjectByObjId(self.owner_obj_id)
	if target then
		self.last_target_pos = target:GetLuaPosition()
	end

	self.draw_obj:CheckBuilding(true)
end

function FollowObj:SetAttr(key, value)
	Character.SetAttr(self, key, value)
	if key == "move_speed" then
		self:UpdateMoveSpeed()
	end
end

function FollowObj:Update(now_time, elapse_time)
	Character.Update(self, now_time, elapse_time)
	self.timer = elapse_time + self.timer

	-- 目标在轻功时，原地待命
	local target = Scene.Instance:GetObjectByObjId(self.owner_obj_id)
	if target and target.IsRole and target:IsRole() then
		if target:IsQingGong() then
			return
		end
	end

	-- 牵引力
	local steeringForce = u3d.vec3(0, 0, 0)
	if self.timer > self.check_cd then
		local sqrt_distance = self:GetOwnerDistance(false)
		-- 超出最大距离，则瞬移过来
		if sqrt_distance > self.sqrt_max_distance then
			
			if nil ~= target and nil ~= target:GetRoot() then
				if self:GetRoot() and self:GetRoot().transform then
					self:GetRoot().transform.position = target:GetRoot().transform.position
					self.velocity = u3d.vec3(0, 0, 0)
					return
				end
			end
		end
		-- 计算牵引力
		steeringForce = u3d.v3Add(steeringForce, self:FollowForce())
		if u3d.v3Length(steeringForce, false) > self.sqrt_max_force then
			steeringForce = u3d.v3Mul(u3d.v3Normalize(steeringForce), self.max_force)
		end
		-- 加速度
		self.acceleration = u3d.v3Mul(steeringForce, 1 / self.mass)
		self.timer = 0
	end
	if self.is_stop_move then
		self.velocity = u3d.vec3(0, 0, 0)
		self:StopMove()
	else
		-- 计算速率
		self.velocity = u3d.v3Add(self.velocity, u3d.v3Mul(self.acceleration, elapse_time))
		if u3d.v3Length(self.velocity, false) > self.sqrt_max_speed then
			self.velocity = u3d.v3Mul(u3d.v3Normalize(self.velocity), self.max_speed)
		end
		local move_ment = u3d.v3Mul(self.velocity, elapse_time)
		local target_pos = u3d.v3Add(self:GetLuaPosition(), move_ment)
		self:DoMove(target_pos)
	end
end

function FollowObj:DoMove(target_pos)
	if self.draw_obj then
		self.draw_obj:SetDirectionByXY(target_pos.x, target_pos.z)
		self.draw_obj:MoveTo(target_pos.x, target_pos.z, self:GetMoveSpeed())
		--如果当前不在移动状态则切换至移动状态
		if not self:IsMove() then
			self.state_machine:ChangeState(SceneObjState.Move)
		end
	end
end

-- 跟随力
function FollowObj:FollowForce()
	local desired_velocity = u3d.vec3(0, 0, 0)
	local target = Scene.Instance:GetObjectByObjId(self.owner_obj_id)
	if target and nil ~= target:GetRoot() and not IsNil(target:GetRoot().transform) then
		self.is_stop_move = false
		local target_pos = target:GetLuaPosition()
		local fixed_target_pos = u3d.v3Add(target_pos, u3d.v3Mul(target:GetRoot().transform.right, self.follow_offset))
		local to_target = u3d.v3Sub(fixed_target_pos, self:GetLuaPosition())
		local target_is_moving = false
		local target_movement = u3d.v3Sub(target_pos, self.last_target_pos)
		if u3d.v3Length(target_movement, false) > 0.01 then
			target_is_moving = true
		end
		if not target_is_moving and self.is_wander and self.draw_obj and self.draw_obj:GetObjVisible() then  -- 只有显示中的才漫步
			desired_velocity = self:WadnerForce()
		else
			local sqrt_distance = self:GetOwnerDistance(false)
			-- 如果距离大于减速距离则全速靠近
			if sqrt_distance > self.sqrt_slow_down_distance then
				desired_velocity = u3d.v3Mul(u3d.v3Normalize(to_target), self.max_speed)
			else
				-- 如果目标在移动，保持与目标相同的速度
				if target_is_moving then
					local elapse_time = self.timer
					if elapse_time == 0 then
						elapse_time = 0.0001
					end
					local target_velocity = u3d.v3Mul(target_movement, 1 / elapse_time)
					desired_velocity = u3d.v3Mul(u3d.v3Normalize(to_target), u3d.v3Length(target_velocity))
				else
					-- 减速靠近目标
					desired_velocity = u3d.v3Sub(to_target, self.velocity)
					-- 如果小于停止距离
					if sqrt_distance <= self.sqrt_stop_distance then
						self.is_stop_move = true
					end
				end
			end
		end
		self.last_target_pos = target_pos
	end
	return u3d.v3Sub(desired_velocity, self.velocity)
end

-- 随机漫步
function FollowObj:WadnerForce()
	self.is_stop_move = true
	local desired_velocity = u3d.vec3(0, 0, 0)
	local target = Scene.Instance:GetObjectByObjId(self.owner_obj_id)
	if target then
		local lua_position = target:GetLuaPosition()
		local wander_pos = self.last_wander_pos
		if self.last_wander_time + self.wander_cd < Status.NowTime then
			self.last_wander_time = Status.NowTime
			local random_pos = u3d.vec3((math.random() - 0.5) * 2 * self.wander_distance, 0, (math.random() - 0.5) * 2 * self.wander_distance)
			wander_pos = u3d.v3Add(lua_position, random_pos)
			self.last_wander_pos = wander_pos
		end
		local target_to_wander = u3d.v3Sub(wander_pos, lua_position)
		if u3d.v3Length(target_to_wander, false) > self.sqrt_wander_distance then
			wander_pos = u3d.v3Add(lua_position, u3d.v3Mul(u3d.v3Normalize(target_to_wander), self.wander_distance))
			self.last_wander_pos = wander_pos
		end
		local can_move = true
		local logic_x, logic_y = GameMapHelper.WorldToLogic(wander_pos.x, wander_pos.z)
		-- 如果目标点是Block，则沿着移动方向找一个可以站立的点
		if AStarFindWay:IsBlock(logic_x, logic_y, true) then
			can_move = false
			local distance = u3d.v3Length(u3d.v3Sub(wander_pos, lua_position))
			distance = distance - Config.SCENE_TILE_WIDTH
			while(distance > 0) do
				wander_pos = u3d.v3Add(lua_position, u3d.v3Mul(u3d.v3Normalize(target_to_wander), distance))
				distance = distance - Config.SCENE_TILE_WIDTH
				local logic_x, logic_y = GameMapHelper.WorldToLogic(wander_pos.x, wander_pos.z)
				if not AStarFindWay:IsBlock(logic_x, logic_y, true) then
					can_move = true
					self.last_wander_pos = wander_pos
					break
				end
			end
		end
		if can_move then
			local to_wander = u3d.v3Sub(wander_pos, self:GetLuaPosition())
			-- 忽略高度
			to_wander.y = 0
			local sqrt_distance = u3d.v3Length(to_wander, false)
			if sqrt_distance > self.stop_distance then
				self.is_stop_move = false

				-- 如果距离大于减速距离则全速靠近
				if sqrt_distance > self.sqrt_slow_down_distance then
					desired_velocity = u3d.v3Mul(u3d.v3Normalize(to_wander), self.max_speed)
				else
					desired_velocity = u3d.v3Mul(u3d.v3Normalize(to_wander), self.max_wander_speed)
				end
			end
		end
	end
	return desired_velocity
end

-- 停止移动
function FollowObj:StopMove()
	self.state_machine:ChangeState(SceneObjState.Stand)
end

function FollowObj:GetMoveSpeed()
	return u3d.v3Length(self.velocity)
end

function FollowObj:GetOwnerID()
	return self.vo.owner_obj_id
end

-- 得到与跟随物的距离
function FollowObj:GetOwnerDistance(is_sqrt)
	local distance = 0
	local target = Scene.Instance:GetObjectByObjId(self.owner_obj_id)
	if target then
		distance = u3d.v3Length(u3d.v3Sub(target:GetLuaPosition(), self:GetLuaPosition()), is_sqrt)
	end
	return distance
end

function FollowObj:SetMaxSpeed(max_speed)
	self.const_max_speed = true
	self.max_speed = max_speed
	self.sqrt_max_speed = max_speed * max_speed
end

function FollowObj:UpdateMoveSpeed()
	if not self.const_max_speed then
		local move_speed = Scene.ServerSpeedToClient(self.vo.move_speed)
		self.max_speed = move_speed + 2
		self.sqrt_max_speed = self.max_speed * self.max_speed
	end
end

function FollowObj:SetMaxForce(max_force)
	self.max_force = max_force
	self.sqrt_max_force = max_force * max_force
end

function FollowObj:IsFollowObj()
	return true
end

