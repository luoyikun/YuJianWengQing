﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class UnityEngine_ScriptableObjectWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(UnityEngine.ScriptableObject), typeof(UnityEngine.Object));
		L.RegFunction("CreateInstance", CreateInstance);
		L.RegFunction("New", _CreateUnityEngine_ScriptableObject);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateUnityEngine_ScriptableObject(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 0)
			{
				UnityEngine.ScriptableObject obj = new UnityEngine.ScriptableObject();
				ToLua.Push(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: UnityEngine.ScriptableObject.New");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CreateInstance(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 1 && TypeChecker.CheckTypes<System.Type>(L, 1))
			{
				System.Type arg0 = (System.Type)ToLua.ToObject(L, 1);
				UnityEngine.ScriptableObject o = UnityEngine.ScriptableObject.CreateInstance(arg0);
				ToLua.Push(L, o);
				return 1;
			}
			else if (count == 1 && TypeChecker.CheckTypes<string>(L, 1))
			{
				string arg0 = ToLua.ToString(L, 1);
				UnityEngine.ScriptableObject o = UnityEngine.ScriptableObject.CreateInstance(arg0);
				ToLua.Push(L, o);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: UnityEngine.ScriptableObject.CreateInstance");
			}
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

