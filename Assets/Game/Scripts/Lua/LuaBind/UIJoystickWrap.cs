//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class UIJoystickWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(UIJoystick), typeof(UnityEngine.MonoBehaviour));
		L.RegFunction("AddDragBeginListener", AddDragBeginListener);
		L.RegFunction("AddDragUpdateListener", AddDragUpdateListener);
		L.RegFunction("AddDragEndListener", AddDragEndListener);
		L.RegFunction("AddIsTouchedListener", AddIsTouchedListener);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("OnDragBegin", get_OnDragBegin, set_OnDragBegin);
		L.RegVar("OnDragUpdate", get_OnDragUpdate, set_OnDragUpdate);
		L.RegVar("OnDragEnd", get_OnDragEnd, set_OnDragEnd);
		L.RegVar("OnIsTouched", get_OnIsTouched, set_OnIsTouched);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddDragBeginListener(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UIJoystick obj = (UIJoystick)ToLua.CheckObject(L, 1, typeof(UIJoystick));
			System.Action<float,float> arg0 = (System.Action<float,float>)ToLua.CheckDelegate<System.Action<float,float>>(L, 2);
			obj.AddDragBeginListener(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddDragUpdateListener(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UIJoystick obj = (UIJoystick)ToLua.CheckObject(L, 1, typeof(UIJoystick));
			System.Action<float,float> arg0 = (System.Action<float,float>)ToLua.CheckDelegate<System.Action<float,float>>(L, 2);
			obj.AddDragUpdateListener(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddDragEndListener(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UIJoystick obj = (UIJoystick)ToLua.CheckObject(L, 1, typeof(UIJoystick));
			System.Action<float,float> arg0 = (System.Action<float,float>)ToLua.CheckDelegate<System.Action<float,float>>(L, 2);
			obj.AddDragEndListener(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddIsTouchedListener(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UIJoystick obj = (UIJoystick)ToLua.CheckObject(L, 1, typeof(UIJoystick));
			System.Action<bool,int> arg0 = (System.Action<bool,int>)ToLua.CheckDelegate<System.Action<bool,int>>(L, 2);
			obj.AddIsTouchedListener(arg0);
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

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_OnDragBegin(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UIJoystick obj = (UIJoystick)o;
			System.Action<float,float> ret = obj.OnDragBegin;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index OnDragBegin on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_OnDragUpdate(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UIJoystick obj = (UIJoystick)o;
			System.Action<float,float> ret = obj.OnDragUpdate;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index OnDragUpdate on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_OnDragEnd(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UIJoystick obj = (UIJoystick)o;
			System.Action<float,float> ret = obj.OnDragEnd;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index OnDragEnd on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_OnIsTouched(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UIJoystick obj = (UIJoystick)o;
			System.Action<bool,int> ret = obj.OnIsTouched;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index OnIsTouched on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_OnDragBegin(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UIJoystick obj = (UIJoystick)o;
			System.Action<float,float> arg0 = (System.Action<float,float>)ToLua.CheckDelegate<System.Action<float,float>>(L, 2);
			obj.OnDragBegin = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index OnDragBegin on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_OnDragUpdate(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UIJoystick obj = (UIJoystick)o;
			System.Action<float,float> arg0 = (System.Action<float,float>)ToLua.CheckDelegate<System.Action<float,float>>(L, 2);
			obj.OnDragUpdate = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index OnDragUpdate on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_OnDragEnd(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UIJoystick obj = (UIJoystick)o;
			System.Action<float,float> arg0 = (System.Action<float,float>)ToLua.CheckDelegate<System.Action<float,float>>(L, 2);
			obj.OnDragEnd = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index OnDragEnd on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_OnIsTouched(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			UIJoystick obj = (UIJoystick)o;
			System.Action<bool,int> arg0 = (System.Action<bool,int>)ToLua.CheckDelegate<System.Action<bool,int>>(L, 2);
			obj.OnIsTouched = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index OnIsTouched on a nil value");
		}
	}
}

