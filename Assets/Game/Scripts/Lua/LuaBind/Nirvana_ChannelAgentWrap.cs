//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class Nirvana_ChannelAgentWrap
{
	public static void Register(LuaState L)
	{
		L.BeginStaticLibs("ChannelAgent");
		L.RegFunction("GetChannelID", GetChannelID);
		L.RegFunction("GetAgentID", GetAgentID);
		L.RegFunction("GetAliasPathMapPath", GetAliasPathMapPath);
		L.RegFunction("GetEncryptKey", GetEncryptKey);
		L.RegFunction("GetOutlog", GetOutlog);
		L.RegFunction("GetInitUrl", GetInitUrl);
		L.RegFunction("Initialize", Initialize);
		L.RegFunction("Login", Login);
		L.RegFunction("Reserve", Reserve);
		L.RegFunction("Logout", Logout);
		L.RegFunction("Pay", Pay);
		L.RegFunction("ReportEnterZone", ReportEnterZone);
		L.RegFunction("ReportCreateRole", ReportCreateRole);
		L.RegFunction("ReportLoginRole", ReportLoginRole);
		L.RegFunction("ReportLogoutRole", ReportLogoutRole);
		L.RegFunction("ReportLevelUp", ReportLevelUp);
		L.RegFunction("FacebookActive", FacebookActive);
		L.RegFunction("CloseSplash", CloseSplash);
		L.RegVar("InitializedEvent", get_InitializedEvent, set_InitializedEvent);
		L.RegVar("LoginEvent", get_LoginEvent, set_LoginEvent);
		L.RegVar("ReserveEvent", get_ReserveEvent, set_ReserveEvent);
		L.RegVar("LogoutEvent", get_LogoutEvent, set_LogoutEvent);
		L.RegVar("ExitEvent", get_ExitEvent, set_ExitEvent);
		L.EndStaticLibs();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetChannelID(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			string o = Nirvana.ChannelAgent.GetChannelID();
			LuaDLL.lua_pushstring(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetAgentID(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			string o = Nirvana.ChannelAgent.GetAgentID();
			LuaDLL.lua_pushstring(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetAliasPathMapPath(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			string o = Nirvana.ChannelAgent.GetAliasPathMapPath();
			LuaDLL.lua_pushstring(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetEncryptKey(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			string o = Nirvana.ChannelAgent.GetEncryptKey();
			LuaDLL.lua_pushstring(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetOutlog(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			bool o = Nirvana.ChannelAgent.GetOutlog();
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetInitUrl(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			string o = Nirvana.ChannelAgent.GetInitUrl();
			LuaDLL.lua_pushstring(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Initialize(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			Nirvana.ChannelAgent.Initialize();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Login(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Nirvana.ChannelUserInfo arg0 = (Nirvana.ChannelUserInfo)ToLua.CheckObject(L, 1, typeof(Nirvana.ChannelUserInfo));
			Nirvana.ChannelAgent.Login(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Reserve(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			string arg0 = ToLua.CheckString(L, 1);
			Nirvana.ChannelAgent.Reserve(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Logout(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Nirvana.ChannelUserInfo arg0 = (Nirvana.ChannelUserInfo)ToLua.CheckObject(L, 1, typeof(Nirvana.ChannelUserInfo));
			Nirvana.ChannelAgent.Logout(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Pay(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 4);
			Nirvana.ChannelUserInfo arg0 = (Nirvana.ChannelUserInfo)ToLua.CheckObject(L, 1, typeof(Nirvana.ChannelUserInfo));
			string arg1 = ToLua.CheckString(L, 2);
			string arg2 = ToLua.CheckString(L, 3);
			double arg3 = (double)LuaDLL.luaL_checknumber(L, 4);
			Nirvana.ChannelAgent.Pay(arg0, arg1, arg2, arg3);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ReportEnterZone(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Nirvana.ChannelUserInfo arg0 = (Nirvana.ChannelUserInfo)ToLua.CheckObject(L, 1, typeof(Nirvana.ChannelUserInfo));
			Nirvana.ChannelAgent.ReportEnterZone(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ReportCreateRole(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Nirvana.ChannelUserInfo arg0 = (Nirvana.ChannelUserInfo)ToLua.CheckObject(L, 1, typeof(Nirvana.ChannelUserInfo));
			Nirvana.ChannelAgent.ReportCreateRole(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ReportLoginRole(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Nirvana.ChannelUserInfo arg0 = (Nirvana.ChannelUserInfo)ToLua.CheckObject(L, 1, typeof(Nirvana.ChannelUserInfo));
			Nirvana.ChannelAgent.ReportLoginRole(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ReportLogoutRole(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Nirvana.ChannelUserInfo arg0 = (Nirvana.ChannelUserInfo)ToLua.CheckObject(L, 1, typeof(Nirvana.ChannelUserInfo));
			Nirvana.ChannelAgent.ReportLogoutRole(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ReportLevelUp(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Nirvana.ChannelUserInfo arg0 = (Nirvana.ChannelUserInfo)ToLua.CheckObject(L, 1, typeof(Nirvana.ChannelUserInfo));
			Nirvana.ChannelAgent.ReportLevelUp(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int FacebookActive(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			string arg0 = ToLua.CheckString(L, 1);
			Nirvana.ChannelAgent.FacebookActive(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CloseSplash(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			Nirvana.ChannelAgent.CloseSplash();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_InitializedEvent(IntPtr L)
	{
		ToLua.Push(L, new EventObject(typeof(System.Action<bool>)));
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_LoginEvent(IntPtr L)
	{
		ToLua.Push(L, new EventObject(typeof(System.Action<string>)));
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_ReserveEvent(IntPtr L)
	{
		ToLua.Push(L, new EventObject(typeof(System.Action<string>)));
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_LogoutEvent(IntPtr L)
	{
		ToLua.Push(L, new EventObject(typeof(System.Action)));
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_ExitEvent(IntPtr L)
	{
		ToLua.Push(L, new EventObject(typeof(System.Action)));
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_InitializedEvent(IntPtr L)
	{
		try
		{
			EventObject arg0 = null;

			if (LuaDLL.lua_isuserdata(L, 2) != 0)
			{
				arg0 = (EventObject)ToLua.ToObject(L, 2);
			}
			else
			{
				return LuaDLL.luaL_throw(L, "The event 'Nirvana.ChannelAgent.InitializedEvent' can only appear on the left hand side of += or -= when used outside of the type 'Nirvana.ChannelAgent'");
			}

			if (arg0.op == EventOp.Add)
			{
				System.Action<bool> ev = (System.Action<bool>)arg0.func;
				Nirvana.ChannelAgent.InitializedEvent += ev;
			}
			else if (arg0.op == EventOp.Sub)
			{
				System.Action<bool> ev = (System.Action<bool>)arg0.func;
				Nirvana.ChannelAgent.InitializedEvent -= ev;
			}

			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_LoginEvent(IntPtr L)
	{
		try
		{
			EventObject arg0 = null;

			if (LuaDLL.lua_isuserdata(L, 2) != 0)
			{
				arg0 = (EventObject)ToLua.ToObject(L, 2);
			}
			else
			{
				return LuaDLL.luaL_throw(L, "The event 'Nirvana.ChannelAgent.LoginEvent' can only appear on the left hand side of += or -= when used outside of the type 'Nirvana.ChannelAgent'");
			}

			if (arg0.op == EventOp.Add)
			{
				System.Action<string> ev = (System.Action<string>)arg0.func;
				Nirvana.ChannelAgent.LoginEvent += ev;
			}
			else if (arg0.op == EventOp.Sub)
			{
				System.Action<string> ev = (System.Action<string>)arg0.func;
				Nirvana.ChannelAgent.LoginEvent -= ev;
			}

			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_ReserveEvent(IntPtr L)
	{
		try
		{
			EventObject arg0 = null;

			if (LuaDLL.lua_isuserdata(L, 2) != 0)
			{
				arg0 = (EventObject)ToLua.ToObject(L, 2);
			}
			else
			{
				return LuaDLL.luaL_throw(L, "The event 'Nirvana.ChannelAgent.ReserveEvent' can only appear on the left hand side of += or -= when used outside of the type 'Nirvana.ChannelAgent'");
			}

			if (arg0.op == EventOp.Add)
			{
				System.Action<string> ev = (System.Action<string>)arg0.func;
				Nirvana.ChannelAgent.ReserveEvent += ev;
			}
			else if (arg0.op == EventOp.Sub)
			{
				System.Action<string> ev = (System.Action<string>)arg0.func;
				Nirvana.ChannelAgent.ReserveEvent -= ev;
			}

			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_LogoutEvent(IntPtr L)
	{
		try
		{
			EventObject arg0 = null;

			if (LuaDLL.lua_isuserdata(L, 2) != 0)
			{
				arg0 = (EventObject)ToLua.ToObject(L, 2);
			}
			else
			{
				return LuaDLL.luaL_throw(L, "The event 'Nirvana.ChannelAgent.LogoutEvent' can only appear on the left hand side of += or -= when used outside of the type 'Nirvana.ChannelAgent'");
			}

			if (arg0.op == EventOp.Add)
			{
				System.Action ev = (System.Action)arg0.func;
				Nirvana.ChannelAgent.LogoutEvent += ev;
			}
			else if (arg0.op == EventOp.Sub)
			{
				System.Action ev = (System.Action)arg0.func;
				Nirvana.ChannelAgent.LogoutEvent -= ev;
			}

			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_ExitEvent(IntPtr L)
	{
		try
		{
			EventObject arg0 = null;

			if (LuaDLL.lua_isuserdata(L, 2) != 0)
			{
				arg0 = (EventObject)ToLua.ToObject(L, 2);
			}
			else
			{
				return LuaDLL.luaL_throw(L, "The event 'Nirvana.ChannelAgent.ExitEvent' can only appear on the left hand side of += or -= when used outside of the type 'Nirvana.ChannelAgent'");
			}

			if (arg0.op == EventOp.Add)
			{
				System.Action ev = (System.Action)arg0.func;
				Nirvana.ChannelAgent.ExitEvent += ev;
			}
			else if (arg0.op == EventOp.Sub)
			{
				System.Action ev = (System.Action)arg0.func;
				Nirvana.ChannelAgent.ExitEvent -= ev;
			}

			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

