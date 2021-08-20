//------------------------------------------------------------------------------
// This file is part of MistLand project in Nirvana.
// Copyright © 2016-2016 Nirvana Technology Co., Ltd.
// All Right Reserved.
//------------------------------------------------------------------------------

Shader "AutoBuild/Game/WorldStandard__KW__"
{
    Properties
    {
        // Rendering mode.
        _RenderingMode("Rendering Mode", Float) = 0.0
        _Cutoff("Alpha Cutoff", Range(0.0, 1.0)) = 0.1
        _CullMode("Cull Mode", Float) = 0.0
		_Alpha("Alpha", Range(0.0, 1.0)) = 0.0
        _SrcBlend("Alpha Source Blend", Float) = 0.0
        _DstBlend("Alpha Destination Blend", Float) = 0.0
        _ZWrite("Z Write", Float) = 1.0

        // Basic colors.
        _MainTex("Main Texture", 2D) = "white" {}
        _MainColor("Main Color", Color) = (1,1,1,1)
        [HDR]_EmissionColor("Emission Color", Color) = (1,1,1,1)

		// Normal.
		_NormalTex("Normal Texture", 2D) = "bump" {}

        // Rim
        _RimColor("Rim Color (A)Opacity", Color) = (1,1,1,1)
        _RimIntensity("Rim Intensity", Range(0, 10)) = 1
        _RimFresnel("Rim Fresnel", Range(0, 5)) = 1

        // The occulde color
        _OccludeColor("Occlusion Color", Color) = (0,0,1,1)
        _OccludePower("Occlusion Power", Range(0.1, 10)) = 1
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
        }

        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }

            CGPROGRAM
            #pragma vertex vert   
            #pragma fragment frag

            #include "UnityCG.cginc"

            #pragma multi_compile_shadowcaster
            #pragma multi_compile_instancing
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma shader_feature _ _ALPHA_TEST _ALPHA_BLEND _ALPHA_PREMULTIPLY
            // #pragma multi_compile ENABLE_MAIN_COLOR
            #pragma skip_variants LIGHTMAP_ON DIRLIGHTMAP_SEPARATE DIRLIGHTMAP_COMBINED DYNAMICLIGHTMAP_ON VERTEXLIGHT_ON

            #if defined(_ALPHA_TEST) || defined(_ALPHA_BLEND) || defined(_ALPHA_PREMULTIPLY)
            #   define REQUIRE_SHADOW_ALPHA
            #endif

            fixed _Cutoff;

            sampler2D _MainTex;
            half4 _MainTex_ST;
            fixed4 _MainColor;

            struct appdata
            {
                float4 vertex : POSITION;
                half3 normal : NORMAL;
#ifdef REQUIRE_SHADOW_ALPHA
                half2 uv : TEXCOORD0;
#endif
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                V2F_SHADOW_CASTER;
#ifdef REQUIRE_SHADOW_ALPHA
                half2 uv : TEXCOORD1;
#endif
                UNITY_VERTEX_OUTPUT_STEREO
            };

            v2f vert(appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)

#ifdef REQUIRE_SHADOW_ALPHA
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
#endif

                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
#ifdef REQUIRE_SHADOW_ALPHA
                fixed4 col = tex2D(_MainTex, i.uv);
// #   ifdef ENABLE_MAIN_COLOR
                col *= _MainColor;
// #   endif

#   ifdef _ALPHA_PREMULTIPLY
                col.rgb *= col.a;
#   endif

#   if !defined(_ALPHA_TEST) && !defined(_ALPHA_BLEND) && !defined(_ALPHA_PREMULTIPLY) && !defined(ALPHA_IS_METALLIC)
                UNITY_OPAQUE_ALPHA(col.a);
#   endif

#   if defined(_ALPHA_TEST)
                clip(col.a - _Cutoff);
#   endif
#endif
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }

        Pass
        {
            Name "Main"
            Tags
            {
                "LightMode" = "ForwardBase"
            }

            Blend [_SrcBlend] [_DstBlend]
            ZWrite [_ZWrite]
            Cull [_CullMode]

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            #include "../../ShaderColor.cginc"
            #include "../../ShaderTexture.cginc"
			#include "../../ShaderNormal.cginc"
            #include "../../ShaderLighting.cginc"
            #include "../../ShaderReflection.cginc"
            #include "../../ShaderRim.cginc"
			// #include "../../ShaderFlow.cginc"
            #include "../../ShaderVerticalFog.cginc"
            #include "../../ShaderAttributes.cginc"

            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma multi_compile_instancing
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma shader_feature _ _ALPHA_TEST _ALPHA_BLEND _ALPHA_PREMULTIPLY
            // #pragma multi_compile _ ENABLE_MAIN_COLOR
            #pragma shader_feature _ ENABLE_EMISSION
            // #pragma shader_feature _ ENABLE_EMISSION_ALPHA_CONTROL
            // #pragma shader_feature _ ENABLE_SEPCULAR ENABLE_SEPCULAR_DIR
            // #pragma shader_feature ENABLE_REFLECTION
			#pragma shader_feature ENABLE_NORMAL
			// #pragma shader_feature _ ENABLE_FLOW_ADD ENABLE_FLOW_MUL
			// #pragma shader_feature _ ENABLE_FLOW_SMOOTH
            #pragma shader_feature ALPHA_IS_METALLIC
            #pragma shader_feature ENABLE_RIM
            // #pragma shader_feature ENABLE_RIM_LIGHT
            // #pragma shader_feature ENABLE_MASK_CONTROL
            #pragma multi_compile _ ENABLE_VERTICAL_FOG
            #pragma skip_variants DIRLIGHTMAP_SEPARATE DIRLIGHTMAP_COMBINED DYNAMICLIGHTMAP_ON VERTEXLIGHT_ON

			fixed _Alpha;

            struct appdata
            {
                float4 vertex : POSITION;
                half3 normal : NORMAL;
#if defined(REQUIRE_VS_WORLD_TANGENT)
				half4 tangent : TANGENT;
#endif
                half2 uv : TEXCOORD0;
#if defined(LIGHTMAP_ON)
                half2 uv2 : TEXCOORD1;
#endif
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                SHADER_TEXCOORDS(TEXCOORD0)
                V2F_VERTEX_ATTRIBUTES(TEXCOORD1, TEXCOORD2, TEXCOORD3, COLOR0, COLOR1, COLOR2, COLOR3)
                LIGHTING_COORDS(4, 5)
                UNITY_FOG_COORDS(6)
                UNITY_VERTEX_OUTPUT_STEREO
            };

            v2f vert(appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                // Calculate position.
                o.pos = UnityObjectToClipPos(v.vertex);

                // Calculate vertex attributes.
                VertexAttribute a;
                CALCULATE_VERTEX_ATTRIBUTES(a, v);

                // Transfer data to pixel shader.
                TRANSFER_UV(o, v);
                TRANSFER_VERTEX_ATTRIBUTES(o, a, v);
                TRANSFER_VERTEX_TO_FRAGMENT(o);
                UNITY_TRANSFER_FOG(o, o.pos);

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // Calculate the texture.
                ShaderColor col;
                SHADER_COLOR_INITIALIZE(col);
                applyTexture(i.uv, col);

                // Calcualte pixel attributes.
                PixelAttribute a;
				CALCULATE_PIXEL_GEO_ATTRIBUTE(a, i);

				// Apply normal.
				ApplyNormal(i.uv, a);
				//return fixed4(a.worldNormal, 1);

				CALCULATE_PIXEL_LIGHT_ATTRIBUTE(a, i);

                // Apply the lighting
                ApplyLighting(col, a);

                // Apply light attenuation
                fixed atten = LIGHT_ATTENUATION(i);
#ifdef LIGHTMAP_ON
                atten = min(0.5f + atten, 1.0);
#endif

                // Calculate final color.
                fixed4 finalColor = getFinalColor(col, atten);
                ApplyReflection(finalColor, col, a);
                ApplyRim(finalColor, a);
				// ApplyFlow(finalColor, col, a);
                UNITY_APPLY_FOG(i.fogCoord, finalColor);
                SHADER_APPLY_VFOG(a, finalColor);

				finalColor.a = finalColor.a + _Alpha;

                return finalColor;
            }
            ENDCG
        }
    }

    CustomEditor "GameWorldStandardShaderGUI"
}
