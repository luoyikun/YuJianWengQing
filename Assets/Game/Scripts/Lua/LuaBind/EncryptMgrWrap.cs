//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class EncryptMgrWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(EncryptMgr), typeof(System.Object));
		L.RegFunction("InitEncryptKey", InitEncryptKey);
		L.RegFunction("SetIsEncryptPath", SetIsEncryptPath);
		L.RegFunction("IsEncryptAsset", IsEncryptAsset);
		L.RegFunction("GetEncryptPath", GetEncryptPath);
		L.RegFunction("ReadEncryptFile", ReadEncryptFile);
		L.RegFunction("DecryptAssetBundle", DecryptAssetBundle);
		L.RegFunction("DecryptAgentAssets", DecryptAgentAssets);
		L.RegFunction("New", _CreateEncryptMgr);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateEncryptMgr(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 0)
			{
				EncryptMgr obj = new EncryptMgr();
				ToLua.PushObject(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: EncryptMgr.New");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int InitEncryptKey(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			EncryptMgr.InitEncryptKey();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetIsEncryptPath(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			bool arg0 = LuaDLL.luaL_checkboolean(L, 1);
			EncryptMgr.SetIsEncryptPath(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IsEncryptAsset(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			bool o = EncryptMgr.IsEncryptAsset();
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetEncryptPath(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			string arg0 = ToLua.CheckString(L, 1);
			string o = EncryptMgr.GetEncryptPath(arg0);
			LuaDLL.lua_pushstring(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ReadEncryptFile(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			string arg0 = ToLua.CheckString(L, 1);
			string o = EncryptMgr.ReadEncryptFile(arg0);
			LuaDLL.lua_pushstring(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DecryptAssetBundle(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			string arg0 = ToLua.CheckString(L, 1);
			string arg1 = ToLua.CheckString(L, 2);
			bool o = EncryptMgr.DecryptAssetBundle(arg0, arg1);
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DecryptAgentAssets(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			string arg0 = ToLua.CheckString(L, 1);
			string o = EncryptMgr.DecryptAgentAssets(arg0);
			LuaDLL.lua_pushstring(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

