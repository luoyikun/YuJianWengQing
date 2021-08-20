//------------------------------------------------------------------------------
// This file is part of MistLand project in Nirvana.
// Copyright © 2016-2016 Nirvana Technology Co., Ltd.
// All Right Reserved.
//------------------------------------------------------------------------------

#ifndef SHADERRIM_INCLUDED
#define SHADERRIM_INCLUDED

#include "ShaderColor.cginc"

#if defined(ENABLE_RIM) || defined(ENABLE_RIM_LIGHT)
#   ifndef REQUIRE_PS_NDOTL
#   define REQUIRE_PS_NDOTL
#   endif

#   ifndef REQUIRE_PS_NDOTV
#   define REQUIRE_PS_NDOTV
#   endif
#endif

// Reflection contant buffer.
CBUFFER_START(ShaderRim)
    fixed4 _RimColor;
    fixed _RimFresnel;
    fixed _RimIntensity;

    fixed4 _RimLightColor;
    fixed _RimLightFresnel;
    fixed _RimLightIntensity;
CBUFFER_END

inline void applyRim(
    inout half4 finalColor,
    half nDotL,
    half nDotV)
{
#ifdef ENABLE_RIM
    fixed rimOpacity = pow(1 - nDotV, _RimFresnel);
    finalColor.rgb = lerp(finalColor.rgb, _RimColor.rgb * _RimIntensity, rimOpacity);
#endif

#ifdef ENABLE_RIM_LIGHT
    fixed rimLightOpacity = pow(1 - nDotV, _RimLightFresnel);
    finalColor.rgb = lerp(finalColor.rgb, _RimLightColor.rgb * _RimLightIntensity, rimLightOpacity * nDotL);
#endif
}

#if defined(ENABLE_RIM) || defined(ENABLE_RIM_LIGHT)
#define ApplyRim(finalColor, a) applyRim(finalColor, a.nDotL, a.nDotV)
#else
#define ApplyRim(finalColor, a)
#endif

#endif
