﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class Nirvana_AudioSequenceControllerWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(Nirvana.AudioSequenceController), typeof(System.Object));
		L.RegFunction("ToString", ToString);
		L.RegFunction("WaitFinish", WaitFinish);
		L.RegFunction("Stop", Stop);
		L.RegFunction("SetPosition", SetPosition);
		L.RegFunction("SetTransform", SetTransform);
		L.RegFunction("Play", Play);
		L.RegFunction("Update", Update);
		L.RegFunction("FinshAudio", FinshAudio);
		L.RegFunction("New", _CreateNirvana_AudioSequenceController);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("IsPlaying", get_IsPlaying, null);
		L.RegVar("LeftTime", get_LeftTime, null);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateNirvana_AudioSequenceController(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 4)
			{
				Nirvana.AudioItem arg0 = (Nirvana.AudioItem)ToLua.CheckObject(L, 1, typeof(Nirvana.AudioItem));
				Nirvana.AudioSourcePool arg1 = (Nirvana.AudioSourcePool)ToLua.CheckObject(L, 2, typeof(Nirvana.AudioSourcePool));
				UnityEngine.AudioSource arg2 = (UnityEngine.AudioSource)ToLua.CheckObject(L, 3, typeof(UnityEngine.AudioSource));
				Nirvana.AudioSubItem[] arg3 = ToLua.CheckStructArray<Nirvana.AudioSubItem>(L, 4);
				Nirvana.AudioSequenceController obj = new Nirvana.AudioSequenceController(arg0, arg1, arg2, arg3);
				ToLua.PushSealed(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: Nirvana.AudioSequenceController.New");
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
			Nirvana.AudioSequenceController obj = (Nirvana.AudioSequenceController)ToLua.CheckObject(L, 1, typeof(Nirvana.AudioSequenceController));
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
			Nirvana.AudioSequenceController obj = (Nirvana.AudioSequenceController)ToLua.CheckObject(L, 1, typeof(Nirvana.AudioSequenceController));
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
			Nirvana.AudioSequenceController obj = (Nirvana.AudioSequenceController)ToLua.CheckObject(L, 1, typeof(Nirvana.AudioSequenceController));
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
			Nirvana.AudioSequenceController obj = (Nirvana.AudioSequenceController)ToLua.CheckObject(L, 1, typeof(Nirvana.AudioSequenceController));
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
			Nirvana.AudioSequenceController obj = (Nirvana.AudioSequenceController)ToLua.CheckObject(L, 1, typeof(Nirvana.AudioSequenceController));
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
			Nirvana.AudioSequenceController obj = (Nirvana.AudioSequenceController)ToLua.CheckObject(L, 1, typeof(Nirvana.AudioSequenceController));
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
			Nirvana.AudioSequenceController obj = (Nirvana.AudioSequenceController)ToLua.CheckObject(L, 1, typeof(Nirvana.AudioSequenceController));
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
			Nirvana.AudioSequenceController obj = (Nirvana.AudioSequenceController)ToLua.CheckObject(L, 1, typeof(Nirvana.AudioSequenceController));
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
			Nirvana.AudioSequenceController obj = (Nirvana.AudioSequenceController)o;
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
			Nirvana.AudioSequenceController obj = (Nirvana.AudioSequenceController)o;
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
