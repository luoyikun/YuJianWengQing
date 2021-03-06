//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class GameLayersWrap
{
	public static void Register(LuaState L)
	{
		L.BeginStaticLibs("GameLayers");
		L.RegVar("Default", get_Default, null);
		L.RegVar("Walkable", get_Walkable, null);
		L.RegVar("Clickable", get_Clickable, null);
		L.RegVar("MainRole", get_MainRole, null);
		L.RegVar("Role", get_Role, null);
		L.RegVar("AreaAtmosphere", get_AreaAtmosphere, null);
		L.RegVar("Water", get_Water, null);
		L.RegVar("BigBuilding", get_BigBuilding, null);
		L.RegVar("SmallBuilding", get_SmallBuilding, null);
		L.RegVar("UIEffect1", get_UIEffect1, null);
		L.RegVar("UIEffect2", get_UIEffect2, null);
		L.RegVar("UIEffect3", get_UIEffect3, null);
		//L.RegVar("IosAuditUI", get_IosAuditUI, null);
		L.EndStaticLibs();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Default(IntPtr L)
	{
		try
		{
			LuaDLL.lua_pushinteger(L, GameLayers.Default);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Walkable(IntPtr L)
	{
		try
		{
			LuaDLL.lua_pushinteger(L, GameLayers.Walkable);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Clickable(IntPtr L)
	{
		try
		{
			LuaDLL.lua_pushinteger(L, GameLayers.Clickable);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_MainRole(IntPtr L)
	{
		try
		{
			LuaDLL.lua_pushinteger(L, GameLayers.MainRole);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Role(IntPtr L)
	{
		try
		{
			LuaDLL.lua_pushinteger(L, GameLayers.Role);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_AreaAtmosphere(IntPtr L)
	{
		try
		{
			LuaDLL.lua_pushinteger(L, GameLayers.AreaAtmosphere);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Water(IntPtr L)
	{
		try
		{
			LuaDLL.lua_pushinteger(L, GameLayers.Water);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_BigBuilding(IntPtr L)
	{
		try
		{
			LuaDLL.lua_pushinteger(L, GameLayers.BigBuilding);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_SmallBuilding(IntPtr L)
	{
		try
		{
			LuaDLL.lua_pushinteger(L, GameLayers.SmallBuilding);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_UIEffect1(IntPtr L)
	{
		try
		{
			LuaDLL.lua_pushinteger(L, GameLayers.UIEffect1);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_UIEffect2(IntPtr L)
	{
		try
		{
			LuaDLL.lua_pushinteger(L, GameLayers.UIEffect2);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_UIEffect3(IntPtr L)
	{
		try
		{
			LuaDLL.lua_pushinteger(L, GameLayers.UIEffect3);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	//[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	/* static int get_IosAuditUI(IntPtr L)
	{
		try
		{
			LuaDLL.lua_pushinteger(L, GameLayers.IosAuditUI);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	} */
}

