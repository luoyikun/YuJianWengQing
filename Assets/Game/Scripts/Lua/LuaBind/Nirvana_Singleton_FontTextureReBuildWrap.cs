﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class Nirvana_Singleton_FontTextureReBuildWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(Nirvana.Singleton<FontTextureReBuild>), typeof(System.Object), "Singleton_FontTextureReBuild");
		L.RegFunction("New", _CreateNirvana_Singleton_FontTextureReBuild);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("Instance", get_Instance, null);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateNirvana_Singleton_FontTextureReBuild(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 0)
			{
				Nirvana.Singleton<FontTextureReBuild> obj = new Nirvana.Singleton<FontTextureReBuild>();
				ToLua.PushObject(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: Nirvana.Singleton<FontTextureReBuild>.New");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Instance(IntPtr L)
	{
		try
		{
			ToLua.PushObject(L, Nirvana.Singleton<FontTextureReBuild>.Instance);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}
