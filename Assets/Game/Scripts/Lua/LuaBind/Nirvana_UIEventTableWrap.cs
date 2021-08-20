﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class Nirvana_UIEventTableWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(Nirvana.UIEventTable), typeof(UnityEngine.MonoBehaviour));
		L.RegFunction("ListenEvent", ListenEvent);
		L.RegFunction("ClearEvent", ClearEvent);
		L.RegFunction("ClearAllEvents", ClearAllEvents);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ListenEvent(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			Nirvana.UIEventTable obj = (Nirvana.UIEventTable)ToLua.CheckObject(L, 1, typeof(Nirvana.UIEventTable));
			string arg0 = ToLua.CheckString(L, 2);
			Nirvana.SignalDelegate arg1 = (Nirvana.SignalDelegate)ToLua.CheckDelegate<Nirvana.SignalDelegate>(L, 3);
			Nirvana.SignalHandle o = obj.ListenEvent(arg0, arg1);
			ToLua.PushSealed(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ClearEvent(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			Nirvana.UIEventTable obj = (Nirvana.UIEventTable)ToLua.CheckObject(L, 1, typeof(Nirvana.UIEventTable));
			string arg0 = ToLua.CheckString(L, 2);
			obj.ClearEvent(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ClearAllEvents(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Nirvana.UIEventTable obj = (Nirvana.UIEventTable)ToLua.CheckObject(L, 1, typeof(Nirvana.UIEventTable));
			obj.ClearAllEvents();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int op_Equality(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.Object arg0 = (UnityEngine.Object)ToLua.ToObject(L, 1);
			UnityEngine.Object arg1 = (UnityEngine.Object)ToLua.ToObject(L, 2);
			bool o = arg0 == arg1;
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}
