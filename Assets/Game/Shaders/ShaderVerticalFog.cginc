//------------------------------------------------------------------------------
// This file is part of MistLand project in Nirvana.
// Copyright © 2016-2016 Nirvana Technology Co., Ltd.
// All Right Reserved.
//------------------------------------------------------------------------------

#ifndef SHADERVERTICALFOG_INCLUDED
#define SHADERVERTICALFOG_INCLUDED

// Color contant buffer
CBUFFER_START(ShaderVerticalFog)
    fixed4 _VerticalFogColor;
	half4 _VerticalFogParam;
CBUFFER_END

#ifdef ENABLE_VERTICAL_FOG
#   ifndef REQUIRE_PS_WORLD_POSITION
#   define REQUIRE_PS_WORLD_POSITION
#   endif
#endif

inline half3 applyVFog(
    half3 col,
    float3 worldPosition)
{
    half density = _VerticalFogParam.x;
    half start = _VerticalFogParam.y;
    half end = _VerticalFogParam.z;
    half fog = (worldPosition.y - start) / (end - start) * density;
    fog = saturate(fog);
    return lerp(col, _VerticalFogColor, fog);
}

#ifdef ENABLE_VERTICAL_FOG
#   define SHADER_APPLY_VFOG(a, col) \
        col.rgb = applyVFog(col.rgb, a.worldPosition);
#else
#   define SHADER_APPLY_VFOG(a, col)
#endif

#endif