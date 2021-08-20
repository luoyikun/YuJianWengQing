﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class Nirvana_QualityControlActiveWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(Nirvana.QualityControlActive), typeof(UnityEngine.MonoBehaviour));
		L.RegFunction("SetOverrideLevel", SetOverrideLevel);
		L.RegFunction("ResetOverrideLevel", ResetOverrideLevel);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetOverrideLevel(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			Nirvana.QualityControlActive obj = (Nirvana.QualityControlActive)ToLua.CheckObject(L, 1, typeof(Nirvana.QualityControlActive));
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.SetOverrideLevel(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ResetOverrideLevel(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Nirvana.QualityControlActive obj = (Nirvana.QualityControlActive)ToLua.CheckObject(L, 1, typeof(Nirvana.QualityControlActive));
			obj.ResetOverrideLevel();
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
