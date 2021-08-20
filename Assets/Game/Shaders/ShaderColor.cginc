//------------------------------------------------------------------------------
// This file is part of MistLand project in Nirvana.
// Copyright © 2016-2016 Nirvana Technology Co., Ltd.
// All Right Reserved.
//------------------------------------------------------------------------------

#ifndef SHADERCOLOR_INCLUDED
#define SHADERCOLOR_INCLUDED

// The color for the shader.
struct ShaderColor
{
    half3 albedo;
    half3 emission;
    half3 ambience;
    half3 diffuse;
    half3 specular;
    half alpha;
    half emissionControl;
    half specularControl;
	half flowControl;
};

#define SHADER_COLOR_INITIALIZE(c) \
    c.albedo = half3(0, 0, 0); \
    c.emission = half3(0, 0, 0); \
    c.ambience = half3(0, 0, 0); \
    c.diffuse = half3(0, 0, 0); \
    c.specular = half3(0, 0, 0); \
    c.alpha = 1; \
    c.emissionControl = 1; \
    c.specularControl = 1; \
	c.flowControl = 1;
    
// Color contant buffer
CBUFFER_START(ShaderColor)
    fixed _Cutoff;
CBUFFER_END

inline void applyAlpha(inout ShaderColor col)
{
#ifdef _ALPHA_PREMULTIPLY
    col.albedo *= col.alpha;
#endif

#if !defined(_ALPHA_TEST) && !defined(_ALPHA_BLEND) && !defined(_ALPHA_PREMULTIPLY)
    UNITY_OPAQUE_ALPHA(col.alpha);
#endif

#if defined(_ALPHA_TEST)
    clip(col.alpha - _Cutoff);
#endif
}

inline fixed4 getFinalColor(ShaderColor col, fixed atten)
{
    half3 emission = 1 + col.emission * col.emissionControl;
    half3 specular = col.specular * col.specularControl;
    half3 final = col.albedo * emission * (col.ambience + atten * (col.diffuse + specular));
    return fixed4(final.r, final.g, final.b, col.alpha);
}

#endif