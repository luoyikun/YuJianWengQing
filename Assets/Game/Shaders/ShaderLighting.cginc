//------------------------------------------------------------------------------
// This file is part of MistLand project in Nirvana.
// Copyright © 2016-2016 Nirvana Technology Co., Ltd.
// All Right Reserved.
//------------------------------------------------------------------------------

#ifndef SHADERLIGHTING_INCLUDED
#define SHADERLIGHTING_INCLUDED

#include "ShaderColor.cginc"

// Require the necessary resource.
#ifndef REQUIRE_PS_AMBIENCE
#define REQUIRE_PS_AMBIENCE
#endif

// Require the necessary resource.
#ifndef REQUIRE_PS_NDOTL
#define REQUIRE_PS_NDOTL
#endif

#if defined(ENABLE_SEPCULAR) || defined(ENABLE_SEPCULAR_DIR)
#   ifndef REQUIRE_PS_NDOTV
#   define REQUIRE_PS_NDOTV
#   endif
#endif

// Rim contant buffer.
CBUFFER_START(ShaderLighting)
    fixed _SpecularPower;
    fixed _SpecularIntensity;
    fixed3 _SpecularColor;
CBUFFER_END

inline void applyLighting(
    inout ShaderColor col,
    half nDotL,
#if defined(ENABLE_SEPCULAR) || defined(ENABLE_SEPCULAR_DIR)
    half nDotV,
#endif
    half3 ambience)
{
    // Ambience
    col.ambience = ambience;

    // Diffuse
#ifndef LIGHTMAP_ON
    col.diffuse = _LightColor0.rgb * nDotL;
#else
    col.diffuse = half3(1.0, 1.0, 1.0);
#endif

	// Specular
#ifdef ENABLE_SEPCULAR
    col.specular = pow(nDotV, _SpecularPower) * _SpecularIntensity * _SpecularColor;
#elif defined(ENABLE_SEPCULAR_DIR)
	col.specular = pow(nDotL * nDotV, _SpecularPower) * _SpecularIntensity * _SpecularColor;
#endif
}

#if defined(ENABLE_SEPCULAR) || defined(ENABLE_SEPCULAR_DIR)
#define ApplyLighting(col, a) applyLighting(col, a.nDotL, a.nDotV, a.ambience)
#else
#define ApplyLighting(col, a) applyLighting(col, a.nDotL, a.ambience)
#endif

#endif
