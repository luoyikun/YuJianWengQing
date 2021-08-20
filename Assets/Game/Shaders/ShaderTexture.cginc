//------------------------------------------------------------------------------
// This file is part of MistLand project in Nirvana.
// Copyright © 2016-2016 Nirvana Technology Co., Ltd.
// All Right Reserved.
//------------------------------------------------------------------------------

#ifndef SHADERTEXTURE_INCLUDED
#define SHADERTEXTURE_INCLUDED

#include "ShaderColor.cginc"

// Texture contant buffer
CBUFFER_START(ShaderTexture)
	sampler2D _MainTex;
	half4 _MainTex_ST;
	fixed4 _MainColor;
	half4 _EmissionColor;

    sampler2D _MaskControlTex;
CBUFFER_END

// SHADER_TEXCOORDS
#if defined(LIGHTMAP_ON)
#   define SHADER_TEXCOORDS_TYPE half4
#   define SHADER_TEXCOORDS(sematic) half4 uv : sematic;
#else
#   define SHADER_TEXCOORDS_TYPE half2
#   define SHADER_TEXCOORDS(sematic) half2 uv : sematic;
#endif

// TRANSFER_UV
#if defined(LIGHTMAP_ON)
#   define TRANSFER_UV(o, v) \
        o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex); \
		o.uv.zw = v.uv2 * unity_LightmapST.xy + unity_LightmapST.zw;
#else
#   define TRANSFER_UV(o, v) \
        o.uv = TRANSFORM_TEX(v.uv, _MainTex);
#endif

inline void applyTexture(SHADER_TEXCOORDS_TYPE uv, inout ShaderColor col)
{
    // Fetch the main texture.
    fixed4 mainColor = tex2D(_MainTex, uv.xy);
    col.albedo = mainColor.rgb;
#ifndef ALPHA_IS_METALLIC
    col.alpha = mainColor.a;
#endif

    // Control the main color.
// #ifdef ENABLE_MAIN_COLOR
    col.albedo *= _MainColor.rgb;
    col.alpha *= _MainColor.a;
// #endif

    // Apply the alpha.
    applyAlpha(col);

    // Apply the emission
#if ENABLE_EMISSION
    col.emission = _EmissionColor;
#endif

#ifdef LIGHTMAP_ON
    // single lightmap
    fixed4 lmtex = UNITY_SAMPLE_TEX2D(unity_Lightmap, uv.zw);
    col.albedo *= DecodeLightmap(lmtex);
#endif

    // Apply the mask.
#if ENABLE_MASK_CONTROL
    fixed4 mask = tex2D(_MaskControlTex, uv.xy);
    col.specularControl = mask.r;
    col.emissionControl = mask.g;
#endif

#ifdef ALPHA_IS_METALLIC
    col.specularControl *= mainColor.a;
#endif

#ifdef ENABLE_EMISSION_ALPHA_CONTROL
    col.emissionControl *= mainColor.a;
#endif

#if defined(ENABLE_FLOW_ADD) || defined(ENABLE_FLOW_MUL)
	col.flowControl *= mainColor.a;
#endif
}

#endif