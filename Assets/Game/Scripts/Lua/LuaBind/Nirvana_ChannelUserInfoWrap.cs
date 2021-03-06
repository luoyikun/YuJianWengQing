//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class Nirvana_ChannelUserInfoWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(Nirvana.ChannelUserInfo), typeof(System.Object));
		L.RegFunction("New", _CreateNirvana_ChannelUserInfo);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("ZoneID", get_ZoneID, set_ZoneID);
		L.RegVar("ZoneName", get_ZoneName, set_ZoneName);
		L.RegVar("RoleID", get_RoleID, set_RoleID);
		L.RegVar("RoleName", get_RoleName, set_RoleName);
		L.RegVar("RoleLevel", get_RoleLevel, set_RoleLevel);
		L.RegVar("Currency", get_Currency, set_Currency);
		L.RegVar("Diamond", get_Diamond, set_Diamond);
		L.RegVar("VIP", get_VIP, set_VIP);
		L.RegVar("GuildName", get_GuildName, set_GuildName);
		L.RegVar("UserID", get_UserID, set_UserID);
		L.RegVar("CreateTime", get_CreateTime, set_CreateTime);
		L.RegVar("ProductName", get_ProductName, set_ProductName);
		L.RegVar("ProductDesc", get_ProductDesc, set_ProductDesc);
		L.RegVar("Ratio", get_Ratio, set_Ratio);
		L.RegVar("paramStr", get_paramStr, set_paramStr);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateNirvana_ChannelUserInfo(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 0)
			{
				Nirvana.ChannelUserInfo obj = new Nirvana.ChannelUserInfo();
				ToLua.PushSealed(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: Nirvana.ChannelUserInfo.New");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_ZoneID(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ChannelUserInfo obj = (Nirvana.ChannelUserInfo)o;
			int ret = obj.ZoneID;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index ZoneID on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_ZoneName(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ChannelUserInfo obj = (Nirvana.ChannelUserInfo)o;
			string ret = obj.ZoneName;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index ZoneName on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_RoleID(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ChannelUserInfo obj = (Nirvana.ChannelUserInfo)o;
			int ret = obj.RoleID;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index RoleID on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_RoleName(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ChannelUserInfo obj = (Nirvana.ChannelUserInfo)o;
			string ret = obj.RoleName;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index RoleName on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_RoleLevel(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ChannelUserInfo obj = (Nirvana.ChannelUserInfo)o;
			int ret = obj.RoleLevel;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index RoleLevel on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Currency(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ChannelUserInfo obj = (Nirvana.ChannelUserInfo)o;
			int ret = obj.Currency;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index Currency on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Diamond(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ChannelUserInfo obj = (Nirvana.ChannelUserInfo)o;
			int ret = obj.Diamond;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index Diamond on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_VIP(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ChannelUserInfo obj = (Nirvana.ChannelUserInfo)o;
			int ret = obj.VIP;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index VIP on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_GuildName(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ChannelUserInfo obj = (Nirvana.ChannelUserInfo)o;
			string ret = obj.GuildName;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index GuildName on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_UserID(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ChannelUserInfo obj = (Nirvana.ChannelUserInfo)o;
			string ret = obj.UserID;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index UserID on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_CreateTime(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ChannelUserInfo obj = (Nirvana.ChannelUserInfo)o;
			long ret = obj.CreateTime;
			LuaDLL.tolua_pushint64(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index CreateTime on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_ProductName(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ChannelUserInfo obj = (Nirvana.ChannelUserInfo)o;
			string ret = obj.ProductName;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index ProductName on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_ProductDesc(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ChannelUserInfo obj = (Nirvana.ChannelUserInfo)o;
			string ret = obj.ProductDesc;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index ProductDesc on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Ratio(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ChannelUserInfo obj = (Nirvana.ChannelUserInfo)o;
			string ret = obj.Ratio;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index Ratio on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_paramStr(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ChannelUserInfo obj = (Nirvana.ChannelUserInfo)o;
			string ret = obj.paramStr;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index paramStr on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_ZoneID(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ChannelUserInfo obj = (Nirvana.ChannelUserInfo)o;
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.ZoneID = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index ZoneID on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_ZoneName(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ChannelUserInfo obj = (Nirvana.ChannelUserInfo)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.ZoneName = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index ZoneName on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_RoleID(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ChannelUserInfo obj = (Nirvana.ChannelUserInfo)o;
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.RoleID = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index RoleID on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_RoleName(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ChannelUserInfo obj = (Nirvana.ChannelUserInfo)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.RoleName = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index RoleName on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_RoleLevel(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ChannelUserInfo obj = (Nirvana.ChannelUserInfo)o;
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.RoleLevel = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index RoleLevel on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_Currency(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ChannelUserInfo obj = (Nirvana.ChannelUserInfo)o;
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.Currency = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index Currency on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_Diamond(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ChannelUserInfo obj = (Nirvana.ChannelUserInfo)o;
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.Diamond = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index Diamond on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_VIP(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ChannelUserInfo obj = (Nirvana.ChannelUserInfo)o;
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.VIP = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index VIP on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_GuildName(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ChannelUserInfo obj = (Nirvana.ChannelUserInfo)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.GuildName = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index GuildName on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_UserID(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ChannelUserInfo obj = (Nirvana.ChannelUserInfo)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.UserID = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index UserID on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_CreateTime(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ChannelUserInfo obj = (Nirvana.ChannelUserInfo)o;
			long arg0 = LuaDLL.tolua_checkint64(L, 2);
			obj.CreateTime = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index CreateTime on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_ProductName(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ChannelUserInfo obj = (Nirvana.ChannelUserInfo)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.ProductName = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index ProductName on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_ProductDesc(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ChannelUserInfo obj = (Nirvana.ChannelUserInfo)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.ProductDesc = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index ProductDesc on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_Ratio(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ChannelUserInfo obj = (Nirvana.ChannelUserInfo)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.Ratio = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index Ratio on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_paramStr(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ChannelUserInfo obj = (Nirvana.ChannelUserInfo)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.paramStr = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index paramStr on a nil value");
		}
	}
}

