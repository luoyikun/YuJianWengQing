﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class Nirvana_SignalHandleWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(Nirvana.SignalHandle), typeof(System.Object));
		L.RegFunction("Dispose", Dispose);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Dispose(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			Nirvana.SignalHandle obj = (Nirvana.SignalHandle)ToLua.CheckObject(L, 1, typeof(Nirvana.SignalHandle));
			obj.Dispose();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}

