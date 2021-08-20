//------------------------------------------------------------------------------
// This file is part of MistLand project in Nirvana.
// Copyright © 2016-2016 Nirvana Technology Co., Ltd.
// All Right Reserved.
//------------------------------------------------------------------------------

#ifndef SHADENORMAL_INCLUDED
#define SHADENORMAL_INCLUDED

#ifdef ENABLE_NORMAL
#   ifndef REQUIRE_PS_WORLD_NORMAL
#   define REQUIRE_PS_WORLD_NORMAL
#   endif
#   ifndef REQUIRE_PS_WORLD_TANGENT
#   define REQUIRE_PS_WORLD_TANGENT
#   endif
#endif

// Normal contant buffer.
CBUFFER_START(ShaderNormal)
	sampler2D _NormalTex;
CBUFFER_END

inline half3 applyNormal(half2 uv, half3 normal, half4 tangent)
{
	half3 binormal = cross(normal, tangent) * tangent.w * unity_WorldTransformParams.w;

	// Gets the tangent normal.
	half3 normalTangent = UnpackNormal(tex2D(_NormalTex, uv));

	// Calculate the world normal.
	half3 worldNormal = tangent * normalTangent.x +
		binormal * normalTangent.y +
		normal * normalTangent.z;
	return normalize(worldNormal);
}

#ifdef ENABLE_NORMAL
#   define ApplyNormal(uv, a) \
    a.worldNormal = applyNormal(uv, a.worldNormal, a.worldTangent)
#else
#	define ApplyNormal(uv, a)
#endif

#endif
