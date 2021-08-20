//------------------------------------------------------------------------------
// This file is part of MistLand project in Nirvana.
// Copyright © 2016-2016 Nirvana Technology Co., Ltd.
// All Right Reserved.
//------------------------------------------------------------------------------

#ifndef SHADERATTRIBUTES_INCLUDED
#define SHADERATTRIBUTES_INCLUDED

//------------------------------------------------------------------------------
// Macro dependency.
//------------------------------------------------------------------------------

#ifdef ENABLE_NORMAL
#   ifndef REQUIRE_PS_NDOTLP
#   define REQUIRE_PS_NDOTLP
#   endif
#endif

#ifdef REQUIRE_PS_NDOTV
#   ifndef REQUIRE_PS_VIEW_DIR
#   define REQUIRE_PS_VIEW_DIR
#   endif
#   ifndef REQUIRE_PS_WORLD_NORMAL
#   define REQUIRE_PS_WORLD_NORMAL
#   endif
#endif

#ifdef REQUIRE_PS_AMBIENCE
#   ifndef REQUIRE_VS_AMBIENCE
#   define REQUIRE_VS_AMBIENCE
#   endif
#endif

#ifdef REQUIRE_PS_NDOTLP
#   ifndef REQUIRE_PS_WORLD_NORMAL
#   define REQUIRE_PS_WORLD_NORMAL
#   endif
#	ifdef REQUIRE_PS_NDOTL
#	undef REQUIRE_PS_NDOTL
#	endif
#elif defined(REQUIRE_PS_NDOTL)
#   ifndef REQUIRE_VS_NDOTL
#   define REQUIRE_VS_NDOTL
#   endif
#   ifndef REQUIRE_VS_LIGHT_DIRECTION
#   define REQUIRE_VS_LIGHT_DIRECTION
#   endif
#endif

#if defined(REQUIRE_VS_LIGHT_DIRECTION) && !defined(USING_DIRECTIONAL_LIGHT)
#   ifndef REQUIRE_VS_WORLD_POSITION
#   define REQUIRE_VS_WORLD_POSITION
#   endif
#endif

#ifdef REQUIRE_PS_WORLD_POSITION
#   ifndef REQUIRE_VS_WORLD_POSITION
#   define REQUIRE_VS_WORLD_POSITION
#   endif
#endif

#ifdef REQUIRE_PS_WORLD_NORMAL
#   ifndef REQUIRE_VS_WORLD_NORMAL
#   define REQUIRE_VS_WORLD_NORMAL
#   endif
#endif

#ifdef REQUIRE_PS_WORLD_TANGENT
#   ifndef REQUIRE_VS_WORLD_TANGENT
#   define REQUIRE_VS_WORLD_TANGENT
#   endif
#endif

#ifdef REQUIRE_PS_VIEW_DIR
#   ifndef REQUIRE_VS_VIEW_DIR
#   define REQUIRE_VS_VIEW_DIR
#   endif
#endif

#ifdef REQUIRE_PS_VIEW_REFLECT
#   ifndef REQUIRE_VS_VIEW_REFLECT
#   define REQUIRE_VS_VIEW_REFLECT
#   endif
#endif

#ifdef REQUIRE_VS_AMBIENCE
#   ifndef REQUIRE_VS_WORLD_NORMAL
#   define REQUIRE_VS_WORLD_NORMAL
#   endif
#endif

#ifdef REQUIRE_VS_NDOTL
#   ifndef REQUIRE_VS_WORLD_NORMAL
#   define REQUIRE_VS_WORLD_NORMAL
#   endif
#   ifndef REQUIRE_VS_LIGHT_DIRECTION
#   define REQUIRE_VS_LIGHT_DIRECTION
#   endif
#endif

#ifdef REQUIRE_VS_VIEW_REFLECT
#   ifndef REQUIRE_VS_VIEW_DIR
#   define REQUIRE_VS_VIEW_DIR
#   endif
#endif

//------------------------------------------------------------------------------
// Calculate for vertex requirement values.
//------------------------------------------------------------------------------
struct VertexAttribute
{
#ifdef REQUIRE_VS_WORLD_POSITION
    float4 worldPosition;
#endif

#ifdef REQUIRE_VS_WORLD_NORMAL
    half3 worldNormal;
#endif

#ifdef REQUIRE_VS_WORLD_TANGENT
    half4 worldTangent;
#endif

#ifdef REQUIRE_VS_AMBIENCE
    half3 ambience;
#endif

#ifdef REQUIRE_VS_LIGHT_DIRECTION
    half3 lightDirection;
#endif

#ifdef REQUIRE_VS_NDOTL
    half nDotL;
#endif

#ifdef REQUIRE_VS_VIEW_DIR
    half3 viewDir;
#endif

#ifdef REQUIRE_VS_VIEW_REFLECT
    half3 viewReflect;
#endif
};

#ifdef REQUIRE_VS_WORLD_POSITION
#   define VS_WORLD_POSITION(a, v) a.worldPosition = mul(unity_ObjectToWorld, v.vertex);
#else
#   define VS_WORLD_POSITION(a, v)
#endif

#ifdef REQUIRE_VS_WORLD_NORMAL
#   define VS_WORLD_NORMAL(a, v) a.worldNormal = UnityObjectToWorldNormal(v.normal);
#else
#   define VS_WORLD_NORMAL(a, v)
#endif

#ifdef REQUIRE_VS_WORLD_TANGENT
#   define VS_WORLD_TANGENT(a, v) a.worldTangent = half4(UnityObjectToWorldDir(v.tangent.xyz), v.tangent.w);
#else
#   define VS_WORLD_TANGENT(a, v)
#endif

#ifdef REQUIRE_VS_AMBIENCE
#   ifndef LIGHTMAP_ON
#       define VS_AMBIENCE(a, v) a.ambience = ShadeSH9(half4(a.worldNormal, 1.0));
#   else
#       define VS_AMBIENCE(a, v) a.ambience = fixed3(0.0, 0.0, 0.0);
#   endif
#else
#   define VS_AMBIENCE(a, v)
#endif

#ifdef REQUIRE_VS_LIGHT_DIRECTION
#   ifdef USING_DIRECTIONAL_LIGHT
#       define VS_LIGHT_DIRECTION(a, v) a.lightDirection = normalize(_WorldSpaceLightPos0.xyz);
#   else
#       define VS_LIGHT_DIRECTION(a, v) a.lightDirection = normalize(_WorldSpaceLightPos0.xyz - a.worldPosition);
#   endif
#else
#   define VS_LIGHT_DIRECTION(a, v)
#endif

#ifdef REQUIRE_VS_NDOTL
#   define VS_NDOTL(a, v) a.nDotL = max(dot(a.worldNormal, a.lightDirection), 0.0);
#else
#   define VS_NDOTL(a, v)
#endif

#ifdef REQUIRE_VS_VIEW_DIR
#   define VS_VIEW_DIR(a, v) a.viewDir = normalize(WorldSpaceViewDir(v.vertex));
#else
#   define VS_VIEW_DIR(a, v)
#endif

#ifdef REQUIRE_VS_VIEW_REFLECT
#   define VS_VIEW_REFLECT(a, v) a.viewReflect = reflect(-a.viewDir, a.worldNormal);
#else
#   define VS_VIEW_REFLECT(a, v)
#endif

//------------------------------------------------------------------------------
// Transfer requirement values from vertex to fragment shader.
//------------------------------------------------------------------------------
struct PixelAttribute
{
#ifdef REQUIRE_PS_WORLD_POSITION
    float3 worldPosition;
#endif

#ifdef REQUIRE_PS_WORLD_NORMAL
    half3 worldNormal;
#endif

#ifdef REQUIRE_PS_WORLD_TANGENT
    half4 worldTangent;
#endif

#ifdef REQUIRE_PS_AMBIENCE
    half3 ambience;
#endif

#if defined(REQUIRE_PS_NDOTL) || defined(REQUIRE_PS_NDOTLP)
    half nDotL;
#endif

#ifdef REQUIRE_PS_VIEW_DIR
    half3 viewDir;
#endif

#ifdef REQUIRE_PS_NDOTV
    half nDotV;
#endif

#ifdef REQUIRE_PS_VIEW_REFLECT
    half3 viewReflect;
#endif

#ifdef REQUIRE_PS_FLOW_UV
	half2 flowUV;
#endif
};

#ifdef REQUIRE_PS_FLOW_UV
#   define V2F_FLOW_UV_POSITION(semantic) half2 flowUV : semantic;
#   define TRANSFER_FLOW_UV(o, a, v) o.flowUV = reflect(normalize(WorldSpaceViewDir(v.vertex)), v.normal);
#   define PS_FLOW_UV(a, i) a.flowUV = i.flowUV;
#else
#   define V2F_FLOW_UV_POSITION(semantic)
#   define TRANSFER_FLOW_UV(o, a, v)
#   define PS_FLOW_UV(a, i)
#endif

#ifdef REQUIRE_PS_WORLD_POSITION
#   define V2F_WORLD_POSITION(semantic) float3 worldPosition : semantic;
#   define TRANSFER_WORLD_POSITION(o, a) o.worldPosition = a.worldPosition;
#   define PS_WORLD_POSITION(a, i) a.worldPosition = i.worldPosition;
#else
#   define V2F_WORLD_POSITION(semantic)
#   define TRANSFER_WORLD_POSITION(o, a)
#   define PS_WORLD_POSITION(a, i)
#endif

#ifdef REQUIRE_PS_WORLD_NORMAL
#   define V2F_WORLD_NORMAL(semantic) half3 worldNormal : semantic;
#   define TRANSFER_WORLD_NORMAL(o, a) o.worldNormal = a.worldNormal;
#   define PS_WORLD_NORMAL(a, i) a.worldNormal = i.worldNormal;
#else
#   define V2F_WORLD_NORMAL(semantic)
#   define TRANSFER_WORLD_NORMAL(o, a)
#   define PS_WORLD_NORMAL(a, i)
#endif

#ifdef REQUIRE_PS_WORLD_TANGENT
#   define V2F_WORLD_TANGENT(semantic) half4 worldTangent : semantic;
#   define TRANSFER_WORLD_TANGENT(o, a) o.worldTangent = a.worldTangent;
#   define PS_WORLD_TANGENT(a, i) a.worldTangent = i.worldTangent;
#else
#   define V2F_WORLD_TANGENT(semantic)
#   define TRANSFER_WORLD_TANGENT(o, a)
#   define PS_WORLD_TANGENT(a, i)
#endif

#ifdef REQUIRE_PS_AMBIENCE
#   ifdef REQUIRE_PS_NDOTL
#       define V2F_WORLD_AMBIENCE(semantic) half4 ambience : semantic;
#   else
#       define V2F_WORLD_AMBIENCE(semantic) half3 ambience : semantic;
#   endif
#   define TRANSFER_AMBIENCE(o, a) o.ambience.rgb = a.ambience;
#   define PS_AMBIENCE(a, i) a.ambience = i.ambience.rgb;
#else
#   define V2F_WORLD_AMBIENCE(semantic)
#   define TRANSFER_AMBIENCE(o, a)
#   define PS_AMBIENCE(a, i)
#endif

#ifdef REQUIRE_PS_NDOTLP
#   define TRANSFER_NDOTL(o, a)
#   define PS_NDOTL(a, i) a.nDotL = max(dot(a.worldNormal, normalize(_WorldSpaceLightPos0.xyz)), 0.0);
#elif defined(REQUIRE_PS_NDOTL)
#   ifdef REQUIRE_PS_AMBIENCE
#       define TRANSFER_NDOTL(o, a) o.ambience.a = a.nDotL;
#       define PS_NDOTL(a, i) a.nDotL = i.ambience.a;
#   else
#       define TRANSFER_NDOTL(o, a) o.nDotL = a.nDotL;
#       define PS_NDOTL(a, i) a.nDotL = i.nDotL;
#   endif
#else
#   define TRANSFER_NDOTL(o, a)
#   define PS_NDOTL(a, i)
#endif

#ifdef REQUIRE_PS_VIEW_DIR
#   define V2F_VIEW_DIR(semantic) half3 viewDir : semantic;
#   define TRANSFER_VIEW_DIR(o, a) o.viewDir = a.viewDir;
#   define PS_VIEW_DIR(a, i) a.viewDir = i.viewDir;
#else
#   define V2F_VIEW_DIR(semantic)
#   define TRANSFER_VIEW_DIR(o, a)
#   define PS_VIEW_DIR(a, i)
#endif

#ifdef REQUIRE_PS_NDOTV
#   define PS_NDOTV(a, i) a.nDotV = max(dot(a.viewDir, a.worldNormal), 0.0);
#else
#   define PS_NDOTV(a, i)
#endif

#ifdef REQUIRE_PS_VIEW_REFLECT
#   define V2F_REFLECT(semantic) half3 viewReflect : semantic;
#   define TRANSFER_VIEW_REFLECT(o, a) o.viewReflect = a.viewReflect;
#   define PS_VIEW_REFLECT(a, i) a.viewReflect = i.viewReflect;
#else
#   define V2F_REFLECT(semantic)
#   define TRANSFER_VIEW_REFLECT(o, a)
#   define PS_VIEW_REFLECT(a, i)
#endif

// This macro put to the v2f structure, used to transfer packed attributes from vertex shader to
// pixel shader.
#define V2F_VERTEX_ATTRIBUTES(semantic1, semantic2, semantic3, semantic4, semantic5, semantic6, semantic7) \
    V2F_VIEW_DIR(semantic1) \
    V2F_REFLECT(semantic2) \
    V2F_WORLD_AMBIENCE(semantic3) \
    V2F_WORLD_NORMAL(semantic4) \
    V2F_WORLD_POSITION(semantic5) \
    V2F_WORLD_TANGENT(semantic6) \
	V2F_FLOW_UV_POSITION(semantic7)

// Calculate the vertex attributes on vertex shader.
#define CALCULATE_VERTEX_ATTRIBUTES(a, v) \
    VS_WORLD_POSITION(a, v) \
    VS_WORLD_NORMAL(a, v) \
	VS_WORLD_TANGENT(a, v) \
    VS_LIGHT_DIRECTION(a, v) \
    VS_NDOTL(a, v) \
    VS_VIEW_DIR(a, v) \
    VS_VIEW_REFLECT(a, v) \
    VS_AMBIENCE(a, v)

// Transfer the vertex attributes to pixel shader.
#define TRANSFER_VERTEX_ATTRIBUTES(o, a, v) \
	TRANSFER_FLOW_UV(o, a, v) \
    TRANSFER_WORLD_POSITION(o, a) \
    TRANSFER_WORLD_NORMAL(o, a) \
    TRANSFER_WORLD_TANGENT(o, a) \
    TRANSFER_AMBIENCE(o, a) \
    TRANSFER_NDOTL(o, a) \
    TRANSFER_VIEW_DIR(o, a) \
    TRANSFER_VIEW_REFLECT(o, a)

// Calculate the pixel attributes.
#define CALCULATE_PIXEL_GEO_ATTRIBUTE(a, i) \
	PS_FLOW_UV(a, i) \
    PS_WORLD_POSITION(a, i) \
    PS_WORLD_NORMAL(a, i) \
    PS_WORLD_TANGENT(a, i)
    

#define CALCULATE_PIXEL_LIGHT_ATTRIBUTE(a, i) \
	PS_AMBIENCE(a, i) \
    PS_NDOTL(a, i) \
    PS_VIEW_DIR(a, i) \
    PS_NDOTV(a, i) \
    PS_VIEW_REFLECT(a, i)

#endif
