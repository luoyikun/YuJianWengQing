//------------------------------------------------------------------------------
// This file is part of MistLand project in Nirvana.
// Copyright © 2016-2016 Nirvana Technology Co., Ltd.
// All Right Reserved.
//------------------------------------------------------------------------------

#ifndef SHADERFLOW_INCLUDED
#define SHADERFLOW_INCLUDED

// Flow contant buffer
CBUFFER_START(ShaderFlow)
	sampler2D _FlowTex;
	half4 _FlowSpeed;
	half4 _FlowColor;
CBUFFER_END

#if defined(ENABLE_FLOW_ADD) || defined(ENABLE_FLOW_MUL)
#   ifndef REQUIRE_PS_FLOW_UV
#   define REQUIRE_PS_FLOW_UV
#   endif
#endif

inline void applyFlow(inout half4 finalColor, half mask, half2 flowUV)
{
	half2 uv = flowUV;
	uv.xy *= _FlowSpeed.zw;
	uv.xy += _FlowSpeed.xy * _Time.y;
	fixed4 color = tex2D(_FlowTex, uv.xy);

#ifndef ENABLE_FLOW_SMOOTH
	mask = step(0.01, mask);
#endif

#ifdef ENABLE_FLOW_ADD
	finalColor += color * _FlowColor * mask;
#else
	finalColor *= 1 + color * _FlowColor * mask;
#endif
}

#if defined(ENABLE_FLOW_ADD) || defined(ENABLE_FLOW_MUL)
#   define ApplyFlow(finalColor, col, a) \
        applyFlow(finalColor, col.flowControl, a.flowUV);
#else
#   define ApplyFlow(finalColor, col, a)
#endif

#endif