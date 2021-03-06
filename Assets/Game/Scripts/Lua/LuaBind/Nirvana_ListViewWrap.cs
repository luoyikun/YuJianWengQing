//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class Nirvana_ListViewWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(Nirvana.ListView), typeof(UnityEngine.MonoBehaviour));
		L.RegFunction("OnBeginDrag", OnBeginDrag);
		L.RegFunction("OnEndDrag", OnEndDrag);
		L.RegFunction("Reload", Reload);
		L.RegFunction("JumpToIndex", JumpToIndex);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("GetCellDel", get_GetCellDel, set_GetCellDel);
		L.RegVar("CellCountDel", get_CellCountDel, set_CellCountDel);
		L.RegVar("GetCellSizeDel", get_GetCellSizeDel, set_GetCellSizeDel);
		L.RegVar("RecycleCellDel", get_RecycleCellDel, set_RecycleCellDel);
		L.RegVar("ActiveCellsStartIndex", get_ActiveCellsStartIndex, null);
		L.RegVar("ActiveCellsEndIndex", get_ActiveCellsEndIndex, null);
		L.RegVar("IsJumping", get_IsJumping, null);
		L.RegVar("ActiveCells", get_ActiveCells, null);
		L.RegFunction("RecycleCellDelegate", Nirvana_ListView_RecycleCellDelegate);
		L.RegFunction("GetCellSizeDelegate", Nirvana_ListView_GetCellSizeDelegate);
		L.RegFunction("CellCountDelegate", Nirvana_ListView_CellCountDelegate);
		L.RegFunction("GetCellDelegate", Nirvana_ListView_GetCellDelegate);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnBeginDrag(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			Nirvana.ListView obj = (Nirvana.ListView)ToLua.CheckObject<Nirvana.ListView>(L, 1);
			UnityEngine.EventSystems.PointerEventData arg0 = (UnityEngine.EventSystems.PointerEventData)ToLua.CheckObject<UnityEngine.EventSystems.PointerEventData>(L, 2);
			obj.OnBeginDrag(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnEndDrag(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			Nirvana.ListView obj = (Nirvana.ListView)ToLua.CheckObject<Nirvana.ListView>(L, 1);
			UnityEngine.EventSystems.PointerEventData arg0 = (UnityEngine.EventSystems.PointerEventData)ToLua.CheckObject<UnityEngine.EventSystems.PointerEventData>(L, 2);
			obj.OnEndDrag(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Reload(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 1)
			{
				Nirvana.ListView obj = (Nirvana.ListView)ToLua.CheckObject<Nirvana.ListView>(L, 1);
				obj.Reload();
				return 0;
			}
			else if (count == 2)
			{
				Nirvana.ListView obj = (Nirvana.ListView)ToLua.CheckObject<Nirvana.ListView>(L, 1);
				System.Action arg0 = (System.Action)ToLua.CheckDelegate<System.Action>(L, 2);
				obj.Reload(arg0);
				return 0;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: Nirvana.ListView.Reload");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int JumpToIndex(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 2)
			{
				Nirvana.ListView obj = (Nirvana.ListView)ToLua.CheckObject<Nirvana.ListView>(L, 1);
				int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
				obj.JumpToIndex(arg0);
				return 0;
			}
			else if (count == 3)
			{
				Nirvana.ListView obj = (Nirvana.ListView)ToLua.CheckObject<Nirvana.ListView>(L, 1);
				int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
				float arg1 = (float)LuaDLL.luaL_checknumber(L, 3);
				obj.JumpToIndex(arg0, arg1);
				return 0;
			}
			else if (count == 4)
			{
				Nirvana.ListView obj = (Nirvana.ListView)ToLua.CheckObject<Nirvana.ListView>(L, 1);
				int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
				float arg1 = (float)LuaDLL.luaL_checknumber(L, 3);
				float arg2 = (float)LuaDLL.luaL_checknumber(L, 4);
				obj.JumpToIndex(arg0, arg1, arg2);
				return 0;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: Nirvana.ListView.JumpToIndex");
			}
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
	static int get_GetCellDel(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ListView obj = (Nirvana.ListView)o;
			Nirvana.ListView.GetCellDelegate ret = obj.GetCellDel;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index GetCellDel on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_CellCountDel(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ListView obj = (Nirvana.ListView)o;
			Nirvana.ListView.CellCountDelegate ret = obj.CellCountDel;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index CellCountDel on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_GetCellSizeDel(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ListView obj = (Nirvana.ListView)o;
			Nirvana.ListView.GetCellSizeDelegate ret = obj.GetCellSizeDel;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index GetCellSizeDel on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_RecycleCellDel(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ListView obj = (Nirvana.ListView)o;
			Nirvana.ListView.RecycleCellDelegate ret = obj.RecycleCellDel;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index RecycleCellDel on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_ActiveCellsStartIndex(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ListView obj = (Nirvana.ListView)o;
			int ret = obj.ActiveCellsStartIndex;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index ActiveCellsStartIndex on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_ActiveCellsEndIndex(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ListView obj = (Nirvana.ListView)o;
			int ret = obj.ActiveCellsEndIndex;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index ActiveCellsEndIndex on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_IsJumping(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ListView obj = (Nirvana.ListView)o;
			bool ret = obj.IsJumping;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index IsJumping on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_ActiveCells(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ListView obj = (Nirvana.ListView)o;
			UnityEngine.GameObject[] ret = obj.ActiveCells;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index ActiveCells on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_GetCellDel(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ListView obj = (Nirvana.ListView)o;
			Nirvana.ListView.GetCellDelegate arg0 = (Nirvana.ListView.GetCellDelegate)ToLua.CheckDelegate<Nirvana.ListView.GetCellDelegate>(L, 2);
			obj.GetCellDel = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index GetCellDel on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_CellCountDel(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ListView obj = (Nirvana.ListView)o;
			Nirvana.ListView.CellCountDelegate arg0 = (Nirvana.ListView.CellCountDelegate)ToLua.CheckDelegate<Nirvana.ListView.CellCountDelegate>(L, 2);
			obj.CellCountDel = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index CellCountDel on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_GetCellSizeDel(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ListView obj = (Nirvana.ListView)o;
			Nirvana.ListView.GetCellSizeDelegate arg0 = (Nirvana.ListView.GetCellSizeDelegate)ToLua.CheckDelegate<Nirvana.ListView.GetCellSizeDelegate>(L, 2);
			obj.GetCellSizeDel = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index GetCellSizeDel on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_RecycleCellDel(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			Nirvana.ListView obj = (Nirvana.ListView)o;
			Nirvana.ListView.RecycleCellDelegate arg0 = (Nirvana.ListView.RecycleCellDelegate)ToLua.CheckDelegate<Nirvana.ListView.RecycleCellDelegate>(L, 2);
			obj.RecycleCellDel = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index RecycleCellDel on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Nirvana_ListView_RecycleCellDelegate(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);
			LuaFunction func = ToLua.CheckLuaFunction(L, 1);

			if (count == 1)
			{
				Delegate arg1 = DelegateTraits<Nirvana.ListView.RecycleCellDelegate>.Create(func);
				ToLua.Push(L, arg1);
			}
			else
			{
				LuaTable self = ToLua.CheckLuaTable(L, 2);
				Delegate arg1 = DelegateTraits<Nirvana.ListView.RecycleCellDelegate>.Create(func, self);
				ToLua.Push(L, arg1);
			}
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Nirvana_ListView_GetCellSizeDelegate(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);
			LuaFunction func = ToLua.CheckLuaFunction(L, 1);

			if (count == 1)
			{
				Delegate arg1 = DelegateTraits<Nirvana.ListView.GetCellSizeDelegate>.Create(func);
				ToLua.Push(L, arg1);
			}
			else
			{
				LuaTable self = ToLua.CheckLuaTable(L, 2);
				Delegate arg1 = DelegateTraits<Nirvana.ListView.GetCellSizeDelegate>.Create(func, self);
				ToLua.Push(L, arg1);
			}
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Nirvana_ListView_CellCountDelegate(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);
			LuaFunction func = ToLua.CheckLuaFunction(L, 1);

			if (count == 1)
			{
				Delegate arg1 = DelegateTraits<Nirvana.ListView.CellCountDelegate>.Create(func);
				ToLua.Push(L, arg1);
			}
			else
			{
				LuaTable self = ToLua.CheckLuaTable(L, 2);
				Delegate arg1 = DelegateTraits<Nirvana.ListView.CellCountDelegate>.Create(func, self);
				ToLua.Push(L, arg1);
			}
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Nirvana_ListView_GetCellDelegate(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);
			LuaFunction func = ToLua.CheckLuaFunction(L, 1);

			if (count == 1)
			{
				Delegate arg1 = DelegateTraits<Nirvana.ListView.GetCellDelegate>.Create(func);
				ToLua.Push(L, arg1);
			}
			else
			{
				LuaTable self = ToLua.CheckLuaTable(L, 2);
				Delegate arg1 = DelegateTraits<Nirvana.ListView.GetCellDelegate>.Create(func, self);
				ToLua.Push(L, arg1);
			}
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

