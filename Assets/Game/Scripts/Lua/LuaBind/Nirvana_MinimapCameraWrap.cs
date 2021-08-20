﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class Nirvana_MinimapCameraWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(Nirvana.MinimapCamera), typeof(UnityEngine.MonoBehaviour));
		L.RegFunction("TransformWorldToUV", TransformWorldToUV);
		L.RegFunction("TransformUVToWorld", TransformUVToWorld);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("Instance", get_Instance, null);
		L.RegVar("MapTexture", get_MapTexture, set_MapTexture);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int TransformWorldToUV(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			Nirvana.MinimapCamera obj = (Nirvana.MinimapCamera)ToLua.CheckObject(L, 1, typeof(Nirvana.MinimapCamera));
			UnityEngine.Vector3 arg0 = ToLua.ToVector3(L, 2);
			UnityEngine.Vector2 o = obj.TransformWorldToUV(arg0);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int TransformUVToWorld(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			Nirvana.MinimapCamera obj = (Nirvana.MinimapCamera)ToLua.CheckObject(L, 1, typeof(Nirvana.MinimapCamera));
			UnityEngine.Vector2 arg0 = ToLua.ToVector2(L, 2);
			UnityEngine.Vector3 o = obj.TransformUVToWorld(arg0);
			ToLua.Push(L, o);
			return 1;
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

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Instance(IntPtr L)
	{
		try
		{
			ToLua.PushSealed(L, Nirvana.MinimapCamera.Instance);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_MapTexture(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.MinimapCamera obj = (Nirvana.MinimapCamera)o;
			UnityEngine.Texture2D ret = obj.MapTexture;
			ToLua.PushSealed(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index MapTexture on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_MapTexture(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.MinimapCamera obj = (Nirvana.MinimapCamera)o;
			UnityEngine.Texture2D arg0 = (UnityEngine.Texture2D)ToLua.CheckObject(L, 2, typeof(UnityEngine.Texture2D));
			obj.MapTexture = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index MapTexture on a nil value");
		}
	}
}

