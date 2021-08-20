local develop_mode = require("editor/develop_mode")
local is_develop = develop_mode:IsDeveloper()

--保存类类型的虚表
local _class = {}
local lua_obj_count = 0

function BaseClass(super)
	-- 生成一个类类型
	local class_type = {}
	-- 在创建对象的时候自动调用
	class_type.__init = false
	class_type.__delete = false
	class_type.super = super
	class_type.New = function(...)
		lua_obj_count = lua_obj_count + 1
		-- 生成一个类对象
		local obj = {_class_type = class_type}

		-- 在初始化之前注册基类方法
		setmetatable(obj, { __index = _class[class_type] })

		-- 调用初始化方法
		do
			local create
			create = function(c, ...)
				if c.super then
					create(c.super, ...)
				end
				if c.__init then
					c.__init(obj, ...)
				end
			end

			create(class_type, ...)
		end

		-- 注册一个delete方法
		obj.DeleteMe = function(self)
			lua_obj_count = lua_obj_count - 1
			local now_super = self._class_type
			while now_super ~= nil do
				if now_super.__delete then
					now_super.__delete(self)
				end
				now_super = now_super.super
			end

			if obj.__gameobj_loaders then
				ReleaseGameobjLoaders(obj)
			end
			
			if obj.__res_loaders then
				ReleaseResLoaders(obj)
			end
			
			if is_develop then
				develop_mode:OnDeleteObj(self)
			end
		end

		if is_develop then
			develop_mode:OnCreateObj(obj, class_type)
		end

		return obj
	end

	local vtbl = {}
	_class[class_type] = vtbl

	setmetatable(class_type, {__newindex = function(t,k,v) vtbl[k] = v end,
		__index = vtbl, --For call parent method
	})

	if super then
		setmetatable(vtbl, {__index = function(t,k) return _class[super][k] end})
	end

	if is_develop then
		develop_mode:OnCreateClass(class_type)
	end

	return class_type
end

function GetDebugLuaObjCount(t)
	t.lua_obj_count = lua_obj_count
end
