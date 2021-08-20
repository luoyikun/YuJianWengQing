//------------------------------------------------------------------------------
// This file is part of MistLand project in Nirvana.
// Copyright © 2016-2016 Nirvana Technology Co., Ltd.
// All Right Reserved.
//------------------------------------------------------------------------------

Shader "AutoBuild/Game/Terrain4__KW__"
{
    Properties
    {
		// Main color
		_MainColor("Main Color", Color) = (1,1,1,1)

        // Basic colors.
        _Splat0("Layer 1", 2D) = "white" {}
        _Splat1("Layer 2", 2D) = "white" {}
        _Splat2("Layer 3", 2D) = "white" {}
        _Splat3("Layer 4", 2D) = "white" {}
        _Control("Control (RGBA)", 2D) = "white" {}

		// Specular
		_SpecularPower("Specular Power", Range(0, 20)) = 1
		_SpecularIntensity("Specular Intensity", Range(0, 5)) = 1
        _SpecularColor("Specular Color", Color) = (1,1,1,1)

        // Reflection.
        _ReflectionOpacity("Reflection Opacity", Range(0, 1)) = 1
        _ReflectionIntensity("Reflection Intensity", Range(0, 3)) = 1
        _ReflectionFresnel("Reflection Fresnel", Range(0, 5)) = 1
        _ReflectionMetallic("Reflection Metallic", Range(0, 1)) = 0
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
        }

        UsePass "Game/Standard/SHADOWCASTER"

        Pass
		{
			Tags
            {
                "LightMode" = "ForwardBase"
            }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            #include "../../ShaderColor.cginc"
            #include "../../ShaderTexture.cginc"
            #include "../../ShaderLighting.cginc"
            #include "../../ShaderReflection.cginc"
            #include "../../ShaderVerticalFog.cginc"
            #include "../../ShaderAttributes.cginc"

			#pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma multi_compile_instancing
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma shader_feature ENABLE_SEPCULAR
			#pragma shader_feature ENABLE_REFLECTION
			#pragma multi_compile _ ENABLE_MAIN_COLOR
            #pragma multi_compile _ ENABLE_VERTICAL_FOG
			#pragma skip_variants DIRLIGHTMAP_SEPARATE DIRLIGHTMAP_COMBINED DYNAMICLIGHTMAP_ON VERTEXLIGHT_ON

            sampler2D _Control;
            sampler2D _Splat0;
            half4 _Splat0_ST;
            sampler2D _Splat1;
            half4 _Splat1_ST;
            sampler2D _Splat2;
            half4 _Splat2_ST;
            sampler2D _Splat3;
            half4 _Splat3_ST;

			struct appdata
			{
				float4 vertex : POSITION;
				half3 normal : NORMAL;
                half2 uv : TEXCOORD0;
#ifdef LIGHTMAP_ON
                half2 uv2 : TEXCOORD1;
#endif
                UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f
			{
                float4 pos : SV_POSITION;
#ifdef LIGHTMAP_ON
                half4 uv : TEXCOORD0;
#else
                half2 uv : TEXCOORD0;
#endif
				half4 uv2 : TEXCOORD1;
				half4 uv3 : TEXCOORD2;

				V2F_VERTEX_ATTRIBUTES(TEXCOORD3, TEXCOORD4, TEXCOORD5, COLOR0, COLOR1, COLOR2, COLOR3)
				LIGHTING_COORDS(6, 7)
				UNITY_FOG_COORDS(8)
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
#ifdef LIGHTMAP_ON
                o.uv.xy = v.uv;
                o.uv.zw = v.uv2 * unity_LightmapST.xy + unity_LightmapST.zw;
#else
                o.uv = v.uv;
#endif
				o.uv2.xy = TRANSFORM_TEX(v.uv, _Splat0);
				o.uv2.zw = TRANSFORM_TEX(v.uv, _Splat1);
				o.uv3.xy = TRANSFORM_TEX(v.uv, _Splat2);
				o.uv3.zw = TRANSFORM_TEX(v.uv, _Splat3);

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

                // Calculate terrain color.
                half4 control = tex2D(_Control, i.uv.xy).rgba;

				half4 layer1 = tex2D(_Splat0, i.uv2.xy);
				half4 layer2 = tex2D(_Splat1, i.uv2.zw);
				half4 layer3 = tex2D(_Splat2, i.uv3.xy);
				half4 layer4 = tex2D(_Splat3, i.uv3.zw);

				half4 mix = (layer1 * control.r + layer2 * control.g + layer3 * control.b + layer4 * control.a);
                col.albedo = mix.rgb;
                col.specularControl = mix.a;

#if ENABLE_MAIN_COLOR
				col.albedo *= _MainColor;
#endif

#ifdef LIGHTMAP_ON
                // single lightmap
                fixed4 lmtex = UNITY_SAMPLE_TEX2D(unity_Lightmap, i.uv.zw);
                col.albedo *= DecodeLightmap(lmtex);
#endif

                // Calcualte pixel attributes.
                PixelAttribute a;
				CALCULATE_PIXEL_GEO_ATTRIBUTE(a, i);
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
                UNITY_APPLY_FOG(i.fogCoord, finalColor);
                SHADER_APPLY_VFOG(a, finalColor);
                return finalColor;
			}
            ENDCG
        }
    }

    CustomEditor "GameTerrain4ShaderGUI"
}
