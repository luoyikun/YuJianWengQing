//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class Nirvana_PageViewWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(Nirvana.PageView), typeof(Nirvana.ListView));
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("ActiveCellsMiddleIndex", get_ActiveCellsMiddleIndex, null);
		L.EndClass();
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
	static int get_ActiveCellsMiddleIndex(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.PageView obj = (Nirvana.PageView)o;
			int ret = obj.ActiveCellsMiddleIndex;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index ActiveCellsMiddleIndex on a nil value");
		}
	}
}

