﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class Nirvana_ScriptablePoolWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(Nirvana.ScriptablePool), typeof(Nirvana.Singleton<Nirvana.ScriptablePool>));
		L.RegFunction("Load", Load);
		L.RegFunction("Free", Free);
		L.RegFunction("Clear", Clear);
		L.RegFunction("ClearAllUnused", ClearAllUnused);
		L.RegFunction("New", _CreateNirvana_ScriptablePool);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("DefaultReleaseAfterFree", get_DefaultReleaseAfterFree, set_DefaultReleaseAfterFree);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateNirvana_ScriptablePool(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 0)
			{
				Nirvana.ScriptablePool obj = new Nirvana.ScriptablePool();
				ToLua.PushSealed(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: Nirvana.ScriptablePool.New");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Load(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 2)
			{
				Nirvana.ScriptablePool obj = (Nirvana.ScriptablePool)ToLua.CheckObject(L, 1, typeof(Nirvana.ScriptablePool));
				Nirvana.AssetID arg0 = StackTraits<Nirvana.AssetID>.Check(L, 2);
				Nirvana.WaitLoadScriptable o = obj.Load(arg0);
				ToLua.PushSealed(L, o);
				return 1;
			}
			else if (count == 3)
			{
				Nirvana.ScriptablePool obj = (Nirvana.ScriptablePool)ToLua.CheckObject(L, 1, typeof(Nirvana.ScriptablePool));
				Nirvana.AssetID arg0 = StackTraits<Nirvana.AssetID>.Check(L, 2);
				System.Action<UnityEngine.ScriptableObject> arg1 = (System.Action<UnityEngine.ScriptableObject>)ToLua.CheckDelegate<System.Action<UnityEngine.ScriptableObject>>(L, 3);
				obj.Load(arg0, arg1);
				return 0;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: Nirvana.ScriptablePool.Load");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Free(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 2)
			{
				Nirvana.ScriptablePool obj = (Nirvana.ScriptablePool)ToLua.CheckObject(L, 1, typeof(Nirvana.ScriptablePool));
				UnityEngine.ScriptableObject arg0 = (UnityEngine.ScriptableObject)ToLua.CheckObject<UnityEngine.ScriptableObject>(L, 2);
				obj.Free(arg0);
				return 0;
			}
			else if (count == 3)
			{
				Nirvana.ScriptablePool obj = (Nirvana.ScriptablePool)ToLua.CheckObject(L, 1, typeof(Nirvana.ScriptablePool));
				UnityEngine.ScriptableObject arg0 = (UnityEngine.ScriptableObject)ToLua.CheckObject<UnityEngine.ScriptableObject>(L, 2);
				bool arg1 = LuaDLL.luaL_checkboolean(L, 3);
				obj.Free(arg0, arg1);
				return 0;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: Nirvana.ScriptablePool.Free");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Clear(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Nirvana.ScriptablePool obj = (Nirvana.ScriptablePool)ToLua.CheckObject(L, 1, typeof(Nirvana.ScriptablePool));
			obj.Clear();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ClearAllUnused(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Nirvana.ScriptablePool obj = (Nirvana.ScriptablePool)ToLua.CheckObject(L, 1, typeof(Nirvana.ScriptablePool));
			obj.ClearAllUnused();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_DefaultReleaseAfterFree(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ScriptablePool obj = (Nirvana.ScriptablePool)o;
			float ret = obj.DefaultReleaseAfterFree;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index DefaultReleaseAfterFree on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_DefaultReleaseAfterFree(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ScriptablePool obj = (Nirvana.ScriptablePool)o;
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.DefaultReleaseAfterFree = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index DefaultReleaseAfterFree on a nil value");
		}
	}
}
