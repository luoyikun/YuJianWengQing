//------------------------------------------------------------------------------
// This file is part of MistLand project in Nirvana.
// Copyright © 2016-2016 Nirvana Technology Co., Ltd.
// All Right Reserved.
//------------------------------------------------------------------------------

#ifndef SHADERREFLECTION_INCLUDED
#define SHADERREFLECTION_INCLUDED

#include "ShaderColor.cginc"

#ifdef ENABLE_REFLECTION
#   ifndef REQUIRE_PS_VIEW_REFLECT
#   define REQUIRE_PS_VIEW_REFLECT
#   endif
#   ifndef REQUIRE_PS_NDOTV
#   define REQUIRE_PS_NDOTV
#   endif
#endif

// Reflection contant buffer.
CBUFFER_START(ShaderReflection)
    fixed _ReflectionOpacity;
    fixed _ReflectionIntensity;
    fixed _ReflectionFresnel;
    fixed _ReflectionMetallic;
    fixed3 _ReflectionColor;
CBUFFER_END

inline void applyReflection(
    inout half4 finalColor,
    half specularControl,
    half3 viewReflect,
    half nDotV)
{
    // Cubemap
    fixed4 cubemap = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, viewReflect);
    cubemap.rgb = DecodeHDR(cubemap, unity_SpecCube0_HDR);
    cubemap.rgb *= _ReflectionIntensity;

    // Metallic
    fixed3 colnl = finalColor.rgb;
    fixed3 cubemapM = finalColor.rgb * cubemap.rgb;
    fixed3 cubemapN = lerp(cubemap.rgb, finalColor.rgb + cubemap.rgb * unity_ColorSpaceDielectricSpec.rgb, finalColor.a);
    cubemap = fixed4(lerp(cubemapN, cubemapM, _ReflectionMetallic).rgb, finalColor.a + cubemap.a);

    // Reflection
    fixed reflectionOpacity = pow(1.0 - nDotV, _ReflectionFresnel) * _ReflectionOpacity;
    reflectionOpacity *= specularControl;
    finalColor.rgb = lerp(colnl, cubemap.rgb, reflectionOpacity);
}

#ifdef ENABLE_REFLECTION
#define ApplyReflection(finalColor, col, a) applyReflection(finalColor, col.specularControl, a.viewReflect, a.nDotV)
#else
#define ApplyReflection(finalColor, col, a)
#endif

#endif
