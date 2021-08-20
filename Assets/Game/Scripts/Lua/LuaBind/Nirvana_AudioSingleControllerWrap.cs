﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class Nirvana_AudioSingleControllerWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(Nirvana.AudioSingleController), typeof(System.Object));
		L.RegFunction("ToString", ToString);
		L.RegFunction("WaitFinish", WaitFinish);
		L.RegFunction("Stop", Stop);
		L.RegFunction("SetPosition", SetPosition);
		L.RegFunction("SetTransform", SetTransform);
		L.RegFunction("Play", Play);
		L.RegFunction("Update", Update);
		L.RegFunction("FinshAudio", FinshAudio);
		L.RegFunction("New", _CreateNirvana_AudioSingleController);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("IsPlaying", get_IsPlaying, null);
		L.RegVar("LeftTime", get_LeftTime, null);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateNirvana_AudioSingleController(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 4)
			{
				Nirvana.AudioSourcePool arg0 = (Nirvana.AudioSourcePool)ToLua.CheckObject(L, 1, typeof(Nirvana.AudioSourcePool));
				Nirvana.AudioItem arg1 = (Nirvana.AudioItem)ToLua.CheckObject(L, 2, typeof(Nirvana.AudioItem));
				Nirvana.AudioSubItem arg2 = StackTraits<Nirvana.AudioSubItem>.Check(L, 3);
				bool arg3 = LuaDLL.luaL_checkboolean(L, 4);
				Nirvana.AudioSingleController obj = new Nirvana.AudioSingleController(arg0, arg1, arg2, arg3);
				ToLua.PushSealed(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: Nirvana.AudioSingleController.New");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ToString(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Nirvana.AudioSingleController obj = (Nirvana.AudioSingleController)ToLua.CheckObject(L, 1, typeof(Nirvana.AudioSingleController));
			string o = obj.ToString();
			LuaDLL.lua_pushstring(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int WaitFinish(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Nirvana.AudioSingleController obj = (Nirvana.AudioSingleController)ToLua.CheckObject(L, 1, typeof(Nirvana.AudioSingleController));
			System.Collections.IEnumerator o = obj.WaitFinish();
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Stop(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Nirvana.AudioSingleController obj = (Nirvana.AudioSingleController)ToLua.CheckObject(L, 1, typeof(Nirvana.AudioSingleController));
			obj.Stop();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetPosition(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			Nirvana.AudioSingleController obj = (Nirvana.AudioSingleController)ToLua.CheckObject(L, 1, typeof(Nirvana.AudioSingleController));
			UnityEngine.Vector3 arg0 = ToLua.ToVector3(L, 2);
			obj.SetPosition(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetTransform(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			Nirvana.AudioSingleController obj = (Nirvana.AudioSingleController)ToLua.CheckObject(L, 1, typeof(Nirvana.AudioSingleController));
			UnityEngine.Transform arg0 = (UnityEngine.Transform)ToLua.CheckObject<UnityEngine.Transform>(L, 2);
			obj.SetTransform(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Play(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Nirvana.AudioSingleController obj = (Nirvana.AudioSingleController)ToLua.CheckObject(L, 1, typeof(Nirvana.AudioSingleController));
			obj.Play();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Update(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Nirvana.AudioSingleController obj = (Nirvana.AudioSingleController)ToLua.CheckObject(L, 1, typeof(Nirvana.AudioSingleController));
			obj.Update();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int FinshAudio(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Nirvana.AudioSingleController obj = (Nirvana.AudioSingleController)ToLua.CheckObject(L, 1, typeof(Nirvana.AudioSingleController));
			obj.FinshAudio();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_IsPlaying(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.AudioSingleController obj = (Nirvana.AudioSingleController)o;
			bool ret = obj.IsPlaying;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index IsPlaying on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_LeftTime(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.AudioSingleController obj = (Nirvana.AudioSingleController)o;
			float ret = obj.LeftTime;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index LeftTime on a nil value");
		}
	}
}

