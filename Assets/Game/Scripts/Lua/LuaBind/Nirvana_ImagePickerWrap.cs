//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class Nirvana_ImagePickerWrap
{
	public static void Register(LuaState L)
	{
		L.BeginStaticLibs("ImagePicker");
		L.RegFunction("PickFromCamera", PickFromCamera);
		L.RegFunction("PickFromPhoto", PickFromPhoto);
		L.EndStaticLibs();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PickFromCamera(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 1);
			int arg1 = (int)LuaDLL.luaL_checknumber(L, 2);
			System.Action<string,string> arg2 = (System.Action<string,string>)ToLua.CheckDelegate<System.Action<string,string>>(L, 3);
			Nirvana.ImagePicker.PickFromCamera(arg0, arg1, arg2);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PickFromPhoto(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 1);
			int arg1 = (int)LuaDLL.luaL_checknumber(L, 2);
			System.Action<string,string> arg2 = (System.Action<string,string>)ToLua.CheckDelegate<System.Action<string,string>>(L, 3);
			Nirvana.ImagePicker.PickFromPhoto(arg0, arg1, arg2);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

