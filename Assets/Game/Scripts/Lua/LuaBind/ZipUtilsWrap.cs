//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class ZipUtilsWrap
{
	public static void Register(LuaState L)
	{
		L.BeginStaticLibs("ZipUtils");
		L.RegFunction("ZipFile", ZipFile);
		L.RegFunction("ZipDirectory", ZipDirectory);
		L.RegFunction("UnZip", UnZip);
		L.EndStaticLibs();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ZipFile(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 2)
			{
				string arg0 = ToLua.CheckString(L, 1);
				string arg1 = ToLua.CheckString(L, 2);
				ZipUtils.ZipFile(arg0, arg1);
				return 0;
			}
			else if (count == 3)
			{
				string arg0 = ToLua.CheckString(L, 1);
				string arg1 = ToLua.CheckString(L, 2);
				string arg2 = ToLua.CheckString(L, 3);
				ZipUtils.ZipFile(arg0, arg1, arg2);
				return 0;
			}
			else if (count == 4)
			{
				string arg0 = ToLua.CheckString(L, 1);
				string arg1 = ToLua.CheckString(L, 2);
				string arg2 = ToLua.CheckString(L, 3);
				System.Action arg3 = (System.Action)ToLua.CheckDelegate<System.Action>(L, 4);
				ZipUtils.ZipFile(arg0, arg1, arg2, arg3);
				return 0;
			}
			else if (count == 5)
			{
				string arg0 = ToLua.CheckString(L, 1);
				string arg1 = ToLua.CheckString(L, 2);
				string arg2 = ToLua.CheckString(L, 3);
				System.Action arg3 = (System.Action)ToLua.CheckDelegate<System.Action>(L, 4);
				int arg4 = (int)LuaDLL.luaL_checknumber(L, 5);
				ZipUtils.ZipFile(arg0, arg1, arg2, arg3, arg4);
				return 0;
			}
			else if (count == 6)
			{
				string arg0 = ToLua.CheckString(L, 1);
				string arg1 = ToLua.CheckString(L, 2);
				string arg2 = ToLua.CheckString(L, 3);
				System.Action arg3 = (System.Action)ToLua.CheckDelegate<System.Action>(L, 4);
				int arg4 = (int)LuaDLL.luaL_checknumber(L, 5);
				int arg5 = (int)LuaDLL.luaL_checknumber(L, 6);
				ZipUtils.ZipFile(arg0, arg1, arg2, arg3, arg4, arg5);
				return 0;
			}
			else if (count == 7)
			{
				string arg0 = ToLua.CheckString(L, 1);
				string arg1 = ToLua.CheckString(L, 2);
				string arg2 = ToLua.CheckString(L, 3);
				System.Action arg3 = (System.Action)ToLua.CheckDelegate<System.Action>(L, 4);
				int arg4 = (int)LuaDLL.luaL_checknumber(L, 5);
				int arg5 = (int)LuaDLL.luaL_checknumber(L, 6);
				bool arg6 = LuaDLL.luaL_checkboolean(L, 7);
				ZipUtils.ZipFile(arg0, arg1, arg2, arg3, arg4, arg5, arg6);
				return 0;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: ZipUtils.ZipFile");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ZipDirectory(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 2)
			{
				string arg0 = ToLua.CheckString(L, 1);
				string arg1 = ToLua.CheckString(L, 2);
				ZipUtils.ZipDirectory(arg0, arg1);
				return 0;
			}
			else if (count == 3)
			{
				string arg0 = ToLua.CheckString(L, 1);
				string arg1 = ToLua.CheckString(L, 2);
				string arg2 = ToLua.CheckString(L, 3);
				ZipUtils.ZipDirectory(arg0, arg1, arg2);
				return 0;
			}
			else if (count == 4)
			{
				string arg0 = ToLua.CheckString(L, 1);
				string arg1 = ToLua.CheckString(L, 2);
				string arg2 = ToLua.CheckString(L, 3);
				System.Action arg3 = (System.Action)ToLua.CheckDelegate<System.Action>(L, 4);
				ZipUtils.ZipDirectory(arg0, arg1, arg2, arg3);
				return 0;
			}
			else if (count == 5)
			{
				string arg0 = ToLua.CheckString(L, 1);
				string arg1 = ToLua.CheckString(L, 2);
				string arg2 = ToLua.CheckString(L, 3);
				System.Action arg3 = (System.Action)ToLua.CheckDelegate<System.Action>(L, 4);
				bool arg4 = LuaDLL.luaL_checkboolean(L, 5);
				ZipUtils.ZipDirectory(arg0, arg1, arg2, arg3, arg4);
				return 0;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: ZipUtils.ZipDirectory");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UnZip(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 2)
			{
				string arg0 = ToLua.CheckString(L, 1);
				string arg1 = ToLua.CheckString(L, 2);
				ZipUtils.UnZip(arg0, arg1);
				return 0;
			}
			else if (count == 3)
			{
				string arg0 = ToLua.CheckString(L, 1);
				string arg1 = ToLua.CheckString(L, 2);
				System.Action arg2 = (System.Action)ToLua.CheckDelegate<System.Action>(L, 3);
				ZipUtils.UnZip(arg0, arg1, arg2);
				return 0;
			}
			else if (count == 4)
			{
				string arg0 = ToLua.CheckString(L, 1);
				string arg1 = ToLua.CheckString(L, 2);
				System.Action arg2 = (System.Action)ToLua.CheckDelegate<System.Action>(L, 3);
				string arg3 = ToLua.CheckString(L, 4);
				ZipUtils.UnZip(arg0, arg1, arg2, arg3);
				return 0;
			}
			else if (count == 5)
			{
				string arg0 = ToLua.CheckString(L, 1);
				string arg1 = ToLua.CheckString(L, 2);
				System.Action arg2 = (System.Action)ToLua.CheckDelegate<System.Action>(L, 3);
				string arg3 = ToLua.CheckString(L, 4);
				bool arg4 = LuaDLL.luaL_checkboolean(L, 5);
				ZipUtils.UnZip(arg0, arg1, arg2, arg3, arg4);
				return 0;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: ZipUtils.UnZip");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

