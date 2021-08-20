﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class ActorFadeoutWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(ActorFadeout), typeof(UnityEngine.MonoBehaviour));
		L.RegFunction("Fadeout", Fadeout);
		L.RegFunction("Fadein", Fadein);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Fadeout(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			ActorFadeout obj = (ActorFadeout)ToLua.CheckObject(L, 1, typeof(ActorFadeout));
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			System.Action arg1 = (System.Action)ToLua.CheckDelegate<System.Action>(L, 3);
			obj.Fadeout(arg0, arg1);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Fadein(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			ActorFadeout obj = (ActorFadeout)ToLua.CheckObject(L, 1, typeof(ActorFadeout));
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			System.Action arg1 = (System.Action)ToLua.CheckDelegate<System.Action>(L, 3);
			obj.Fadein(arg0, arg1);
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
