//------------------------------------------------------------------------------
// This file is part of MistLand project in Nirvana.
// Copyright © 2016-2016 Nirvana Technology Co., Ltd.
// All Right Reserved.
//------------------------------------------------------------------------------

Shader "AutoBuild/Game/Particle__KW__32_10_31"
{
    Properties
    {
        // Rendering mode.
        _RenderingMode("Rendering Mode", Float) = 0.0
        _CullMode("Cull Mode", Float) = 0.0
        _Cutoff("Alpha Cutoff", Range(0.0, 1.0)) = 0.1
        _SrcBlend("Alpha Source Blend", Float) = 0.0
        _DstBlend("Alpha Destination Blend", Float) = 0.0
        _ZWrite("Z Write", Float) = 0.0
		_AlphaFactor("Alpha Factor", Float) = 1.0

        // Basic colors.
        _MainTex("Main Texture", 2D) = "white" {}
		[HDR]_TintColor("Tine Color", Color) = (0.5,0.5,0.5,1)

        // Decal.
        _DecalTex("Decal Texture", 2D) = "white" {}

		// Disslove.
		_DissloveTex("Disslove Texture", 2D) = "white" {}
        _DissloveAmount("Disslove Amount", Range(0.0, 1.01)) = 0.1
		_DissloveOutlineStep("Disslove Outline Step", Range(0.0, 1.0)) = 0.1
		[HDR]_DissloveOutlineColor("Disslove Outline Color", Color) = (1, 1, 1, 1)

		// UVNoise
		_UVNoise("UV Noise", 2D) = "black" {}
		_UVNoiseBias("UV Noise Bias", Range(-1, 1)) = 0.6
        _UVNoiseIntensity("UV Noise Bias", Range(0, 1)) = 0.5
        _UVNoiseSpeed("UV Noise Speed", Vector) = (0, 0, 0, 0)

		// Glow
		_GlowTex("Glow Texture", 2D) = "black" {}
		_GlowSpeed("Glow Speed", Vector) = (0, 0, 0, 0)
		[HDR]_GlowColor("Glow Color", Color) = (1, 1, 1, 1)

        // Rim
		[HDR]_RimColor("Rim Color (A)Opacity", Color) = (1,1,1,1)
        _RimIntensity("Rim Intensity", Range(0, 10)) = 1
        _RimFresnel("Rim Fresnel", Range(0, 5)) = 1

		// Rim Light
		[HDR]_RimLightColor("Rim Light Color (A)Opacity", Color) = (1,1,1,1)
		_RimLightIntensity("Rim Light Intensity", Range(0, 10)) = 1
		_RimLightFresnel("Rim Light Fresnel", Range(0, 5)) = 1

		// Support ui clip.
		/*_StencilComp("Stencil Comparison", Float) = 8
		_Stencil("Stencil ID", Float) = 0
		_StencilOp("Stencil Operation", Float) = 0
		_StencilWriteMask("Stencil Write Mask", Float) = 255
		_StencilReadMask("Stencil Read Mask", Float) = 255*/

		_ColorMask("Color Mask", Float) = 15

		/*_OffsetFactor("Offset factor", Float) = 0
		_OffsetUnits("Offset unit", Float) = 0*/

		_Alpha("Alpha", Range(0.0, 1.0)) = 1.0
		// [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip("Use Alpha Clip", Float) = 0
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "RenderType" = "Transparent"
			"PreviewType" = "Plane"
        }

        Pass
        {
            Name "Main"
            Tags
            {
                "LightMode" = "ForwardBase"
            }

			/*Stencil
			{
				Ref [_Stencil]
				Comp [_StencilComp]
				Pass [_StencilOp]
				ReadMask [_StencilReadMask]
				WriteMask [_StencilWriteMask]
			}*/

            Blend [_SrcBlend] [_DstBlend]
            ZWrite [_ZWrite]
            Cull [_CullMode]
            Lighting Off
			ColorMask[_ColorMask]
			// Offset[_OffsetFactor],[_OffsetUnits]

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
			#include "UnityUI.cginc"

            #pragma multi_compile_particles
            #pragma multi_compile_fog
            // #pragma multi_compile_instancing
            #pragma fragmentoption ARB_precision_hint_fastest
			#pragma shader_feature _ALPHA_TEST _ALPHA_BLEND _ALPHA_PREMULTIPLY
			#pragma shader_feature _ _CHANNEL_A
			#pragma shader_feature _ _DECAL_CHANNEL_A
            // #pragma shader_feature ENABLE_TINT_COLOR
            #pragma shader_feature ENABLE_DECAL
            #pragma shader_feature ENABLE_DISSLOVE
			#pragma shader_feature ENABLE_DISSLOVE_VERTEX_COLOR
			#pragma shader_feature ENABLE_DISSLOVE_OUTLINE
			#pragma shader_feature ENABLE_UV_NOISE
			#pragma shader_feature ENABLE_PARTICLE_UV_ANIMATION
			#pragma shader_feature ENABLE_GLOW
            #pragma shader_feature ENABLE_RIM
			#pragma shader_feature ENABLE_RIM_LIGHT
            // #pragma shader_feature ENABLE_FOG
			// #pragma multi_compile _ ENABLE_UI_CLIP
			// #pragma multi_compile _ UNITY_UI_ALPHACLIP
            #pragma skip_variants DIRLIGHTMAP_SEPARATE DIRLIGHTMAP_COMBINED DYNAMICLIGHTMAP_ON LIGHTMAP_ON VERTEXLIGHT_ON

			// Main texture.
            sampler2D _MainTex;
            half4 _MainTex_ST;
            half4 _TintColor;
            fixed _Cutoff;

            // Decal texture.
            sampler2D _DecalTex;
            half4 _DecalTex_ST;

			// Disslove.
			sampler2D _DissloveTex;
			half4 _DissloveTex_ST;
            fixed _DissloveAmount;
			half _DissloveOutlineStep;
			half3 _DissloveOutlineColor;

            // Noise
			sampler2D _UVNoise;
			float4 _UVNoise_ST;
			half _UVNoiseBias;
            half _UVNoiseIntensity;
			half4 _UVNoiseSpeed;

			// Glow
			sampler2D _GlowTex;
			half4 _GlowTex_ST;
			half2 _GlowSpeed;
			fixed4 _GlowColor;

            // Rim.
            fixed4 _RimColor;
            fixed _RimFresnel;
            fixed _RimIntensity;

			half _AlphaFactor;

			// Rim Light.
			fixed4 _RimLightColor;
			fixed _RimLightIntensity;
			fixed _RimLightFresnel;

			fixed _Alpha;
/*#if ENABLE_UI_CLIP
			// Clip support.
			float4 _ClipRect;
#endif*/

            struct appdata
            {
                float4 vertex : POSITION;
                half3 normal : NORMAL;
#ifdef ENABLE_PARTICLE_UV_ANIMATION
				half4 uv : TEXCOORD0;
#else
				half2 uv : TEXCOORD0;
#endif
                fixed4 color : COLOR0;
                // UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
#if ENABLE_UV_NOISE
				half4 uv : TEXCOORD0;
#else
                half2 uv : TEXCOORD0;
#endif
#if defined(ENABLE_DECAL) && defined(ENABLE_DISSLOVE)
                half4 uv2 : TEXCOORD1;
#elif defined(ENABLE_DECAL) || defined(ENABLE_DISSLOVE)
				half2 uv2 : TEXCOORD1;
#endif
#if ENABLE_RIM || ENABLE_RIM_LIGHT
                half3 worldNormal : TEXCOORD2;
                half3 viewDir : TEXCOORD3;
#endif
				
                half4 color : COLOR0;
/*#if ENABLE_UI_CLIP
				float4 worldPosition : TEXCOORD4;
#endif
#if ENABLE_FOG
                UNITY_FOG_COORDS(5)
#endif*/
                UNITY_VERTEX_OUTPUT_STEREO
            };

            v2f vert(appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                // Position, color and UV.
                o.pos = UnityObjectToClipPos(v.vertex);
                o.color = v.color;

#ifdef ENABLE_PARTICLE_UV_ANIMATION
				half2 uv = v.uv.xy + v.uv.zw;
				o.uv.xy = TRANSFORM_TEX(uv, _MainTex);
#else
				o.uv.xy = TRANSFORM_TEX(v.uv.xy, _MainTex);
#endif

#if ENABLE_UV_NOISE
				o.uv.zw = TRANSFORM_TEX(v.uv.xy, _UVNoise);
#endif

#if defined(ENABLE_DECAL) && defined(ENABLE_DISSLOVE)
                o.uv2.xy = TRANSFORM_TEX(v.uv.xy, _DecalTex);
                o.uv2.zw = TRANSFORM_TEX(v.uv.xy, _DissloveTex);
#elif defined(ENABLE_DECAL)
                o.uv2 = TRANSFORM_TEX(v.uv.xy, _DecalTex);
#elif defined(ENABLE_DISSLOVE)
				o.uv2 = TRANSFORM_TEX(v.uv.xy, _DissloveTex);
#endif

#if ENABLE_RIM || ENABLE_RIM_LIGHT
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.viewDir = normalize(WorldSpaceViewDir(v.vertex));
#endif

/*#if ENABLE_UI_CLIP
				o.worldPosition = v.vertex;
#endif

#if ENABLE_FOG
                UNITY_TRANSFER_FOG(o, o.pos);
#endif*/

                return o;
            }

            half4 frag(v2f i) : SV_Target
            {
#if ENABLE_UV_NOISE
                fixed2 uvNoise = i.uv.zw;
                uvNoise.xy += _Time.y * _UVNoiseSpeed.zw;
				fixed2 noise = _UVNoiseBias + tex2D(_UVNoise, uvNoise).rg;
                noise *= _UVNoiseIntensity;

                fixed2 uvTex = i.uv.xy;
                uvTex.xy += _Time.y * _UVNoiseSpeed.xy;
				uvTex.xy = frac(uvTex.xy);
				half4 col = tex2D(_MainTex, uvTex + noise);
#else
				half4 col = tex2D(_MainTex, i.uv.xy);
#endif

/*#if _CHANNEL_R
				col = half4(col.r, col.r, col.r, col.r);
#elif _CHANNEL_G
				col = half4(col.g, col.g, col.g, col.g);
#elif _CHANNEL_B
				col = half4(col.b, col.b, col.b, col.b);*/
#if _CHANNEL_A
				col = half4(col.a, col.a, col.a, col.a);
#endif

#if ENABLE_DISSLOVE_VERTEX_COLOR
				// half4 vcolor = half4(i.color.rgb, 1);
				/*#	if ENABLE_TINT_COLOR
				col.rgb *= 2.0 * vcolor.rgb * _TintColor.rgb;
				col.a *= vcolor.a * _TintColor.a;
				#	else
				col *= vcolor;
				#	endif*/
				// col *= 2.0 * half4(i.color.rgb, 1) * _TintColor;

				col.rgb *= 2.0 * i.color.rgb * _TintColor.rgb;
				col.a *= _TintColor.a * _AlphaFactor;
#else
				/*#	if ENABLE_TINT_COLOR
				col.rgb *= 2.0 * i.color.rgb * _TintColor.rgb;
				col.a *= i.color.a * _TintColor.a;
				#	else
				col *= i.color;
				#	endif*/
				col.rgb *= 2.0 * i.color.rgb * _TintColor.rgb;
				col.a *= i.color.a * _TintColor.a * _AlphaFactor;
#endif


#if defined(ENABLE_DECAL) && defined(ENABLE_DISSLOVE)
                half4 decal = tex2D(_DecalTex, i.uv2.xy);
/*#	if _DECAL_CHANNEL_R
				decal = half4(decal.r, decal.r, decal.r, decal.r);
#	elif _DECAL_CHANNEL_G
				decal = half4(decal.g, decal.g, decal.g, decal.g);
#	elif _DECAL_CHANNEL_B
				decal = half4(decal.b, decal.b, decal.b, decal.b);*/
#	if _DECAL_CHANNEL_A
				decal = half4(decal.a, decal.a, decal.a, decal.a);
#	endif
                col *= decal;

                half4 disslove = tex2D(_DissloveTex, i.uv2.zw);
                
#	ifdef ENABLE_DISSLOVE_VERTEX_COLOR
				half dissloveValue = disslove.a - (1 - i.color.a);
#		ifdef ENABLE_DISSLOVE_OUTLINE
				half disstep = step(dissloveValue - _DissloveOutlineStep, 0);
				col.rgb = lerp(col.rgb, col.rgb * _DissloveOutlineColor, disstep);
#		endif
				clip(dissloveValue + 0.0001);
#	else
				half dissloveValue = disslove.a - _DissloveAmount;
#		ifdef ENABLE_DISSLOVE_OUTLINE
				half disstep = step(dissloveValue - _DissloveOutlineStep, 0);
				col.rgb = lerp(col.rgb, col.rgb * _DissloveOutlineColor, disstep);
#		endif
				clip(dissloveValue + 0.0001);
#	endif
#elif defined(ENABLE_DECAL)
				half4 decal = tex2D(_DecalTex, i.uv2);
/*#	if _DECAL_CHANNEL_R
				decal = half4(decal.r, decal.r, decal.r, decal.r);
#	elif _DECAL_CHANNEL_G
				decal = half4(decal.g, decal.g, decal.g, decal.g);
#	elif _DECAL_CHANNEL_B
				decal = half4(decal.b, decal.b, decal.b, decal.b);*/
#	if _DECAL_CHANNEL_A
				decal = half4(decal.a, decal.a, decal.a, decal.a);
#	endif
                col *= decal;
#elif defined(ENABLE_DISSLOVE)
                half4 disslove = tex2D(_DissloveTex, i.uv2);

#	ifdef ENABLE_DISSLOVE_VERTEX_COLOR
				half dissloveValue = disslove.a - (1 - i.color.a);
#		ifdef ENABLE_DISSLOVE_OUTLINE
				half disstep = step(dissloveValue - _DissloveOutlineStep, 0);
				col.rgb = lerp(col.rgb, col.rgb * _DissloveOutlineColor, disstep);
#		endif
				clip(dissloveValue + 0.0001);
#	else
				half dissloveValue = disslove.a - _DissloveAmount;
#		ifdef ENABLE_DISSLOVE_OUTLINE
				half disstep = step(dissloveValue - _DissloveOutlineStep, 0);
				col.rgb = lerp(col.rgb, col.rgb * _DissloveOutlineColor, disstep);
#		endif
				clip(dissloveValue + 0.0001);
#	endif
#endif

#ifdef ENABLE_GLOW
				half2 glowUV = i.uv.xy;
				glowUV.xy += _Time.y * _GlowSpeed.xy;
				half3 glow = tex2D(_GlowTex, glowUV.xy) * _GlowColor;
				col.rgb += col.a * glow.rgb;
#endif

#ifdef _ALPHA_PREMULTIPLY
                col.rgb *= col.a;
#endif

#if !defined(_ALPHA_TEST) && !defined(_ALPHA_BLEND) && !defined(_ALPHA_PREMULTIPLY)
                UNITY_OPAQUE_ALPHA(col.a);
#endif

#ifdef ENABLE_RIM
                half rimOpacity = pow(1 - saturate(dot(i.viewDir, i.worldNormal)), _RimFresnel);
                col.rgb = lerp(col.rgb, _RimColor.rgb * _RimIntensity, rimOpacity);
#endif

#ifdef ENABLE_RIM_LIGHT
				half rimLightOpacity = pow(1 - saturate(dot(i.viewDir, i.worldNormal)), _RimLightFresnel);
				col += _RimLightColor * _RimLightIntensity * rimLightOpacity;
				col = saturate(col);
#endif

#if _ALPHA_TEST
                clip(col.a - _Cutoff);
#endif

/*#if ENABLE_FOG
                // fog towards black due to our blend mode
                UNITY_APPLY_FOG_COLOR(i.fogCoord, col, half4(0, 0, 0, 0));
#endif*/
		col.a *= _Alpha;
/*#if ENABLE_UI_CLIP
				col.a *= UnityGet2DClipping(i.worldPosition.xy, _ClipRect);
#ifdef UNITY_UI_ALPHACLIP
				clip(col.a - 0.001);
#endif
#endif*/

                return col;
            }
            ENDCG
        }
    }

    CustomEditor "GameParticleShaderGUI"
}
