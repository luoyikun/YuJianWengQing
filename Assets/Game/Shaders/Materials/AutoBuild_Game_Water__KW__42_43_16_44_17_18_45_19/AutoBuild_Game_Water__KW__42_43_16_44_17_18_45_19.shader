//------------------------------------------------------------------------------
// This file is part of MistLand project in Nirvana.
// Copyright © 2016-2016 Nirvana Technology Co., Ltd.
// All Right Reserved.
//------------------------------------------------------------------------------

Shader "AutoBuild/Game/Water__KW__42_43_16_44_17_18_45_19"
{
    Properties
    {
		_MainTex("Main Texture", 2D) = "white" {}
        _NormalMap("Normal", 2D) = "bump" {}
        _HeightMap("Height Displace", 2D) = "white" {}

		_WaterSpeed("Water Speed", Range(0.0, 1.0)) = 0.5
		_Wavex1y1x2y2("Wave (x1,y1,x2,y2)", Vector) = (0.05,0.05,0.05,0.05)
		_WaveSmallx1y1x2y2("WaveSmall (x1,y1,x2,y2)", Vector) = (0.1,0.1,0.1,0.1)

        _WaterColor1("Water Color 1", Color) = (1,1,1,1)
        _WaterColor2("Water Color 2", Color) = (0,0,0,1)

        [HDR]_AmbianceColor("Ambiance Color", Color) = (0.2,0.2,0.2,1)
		[HDR]_DiffuseColor("Diffuse Color", Color) = (1,1,1,1)
		[HDR]_SpecularColor("Specular Color", Color) = (1,1,1,1)

        _RefractionDistort("Refraction Distort", Range(0, 0.5)) = 0.05
		_RefractionOpacity("Refraction Opacity", Range(0, 1.0)) = 0.5

		_Reflection("_Reflection", 2D) = "black" {}
		_ReflectionSpace("_ReflectionSpace", Range(0, 10.0)) = 1
		_ReflectPower("_ReflectPower", Range(0, 1.0)) = 0
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Transparent"
            "Queue" = "Transparent"
        }

        GrabPass { "_WaterRefraction" }

        Pass
        {
            Tags
            {
                "LightMode" = "ForwardBase"
                "ShadowCaster" = "false"
            }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
			#define REQUIRE_PS_WORLD_NORMAL
#if ENABLE_AMBIANCE
			#define REQUIRE_PS_AMBIENCE
#endif
#if ENABLE_DIFFUSE
			# ifndef REQUIRE_PS_NDOTLP
			# define REQUIRE_PS_NDOTLP
			# endif
#endif
#if ENABLE_SPECULAR
			#define REQUIRE_PS_NDOTV
#endif
#if ENABLE_REFLECTION
			#define REQUIRE_PS_VIEW_DIR
#endif

            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
			#include "../../ShaderVerticalFog.cginc"
			#include "../../ShaderAttributes.cginc"

            #pragma multi_compile_fwdbase
			#pragma multi_compile_fog
            #pragma fragmentoption ARB_precision_hint_fastest
			#pragma shader_feature _ ENABLE_MAIN
			#pragma shader_feature _ ENABLE_NORMAL
			#pragma shader_feature _ ENABLE_HEIGHT
			#pragma shader_feature _ ENABLE_WAVE_ANIMATION
			#pragma shader_feature _ ENABLE_AMBIANCE
			#pragma shader_feature _ ENABLE_DIFFUSE
			#pragma shader_feature _ ENABLE_SPECULAR
			#pragma shader_feature _ ENABLE_REFRACTION
			#pragma shader_feature _ ENABLE_REFLECTION
			#pragma shader_feature _ ENABLE_VERTEX_COLOR
			#pragma multi_compile _ ENABLE_VERTICAL_FOG
			#pragma skip_variants DIRLIGHTMAP_SEPARATE DIRLIGHTMAP_COMBINED DYNAMICLIGHTMAP_ON VERTEXLIGHT_ON

            struct appdata
            {
                float4 vertex : POSITION;
                half2 uv : TEXCOORD0;
                half3 normal : NORMAL;
#if ENABLE_VERTEX_COLOR
                half4 color : COLOR;
#endif
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                half2 uv : TEXCOORD0;
				float4 grabPos : TEXCOORD1;
				V2F_VERTEX_ATTRIBUTES(TEXCOORD2, TEXCOORD3, TEXCOORD4, COLOR0, COLOR1, COLOR2, COLOR3)
#if ENABLE_VERTEX_COLOR
				half4 color : COLOR3;
#endif
				LIGHTING_COORDS(5, 6)
				UNITY_FOG_COORDS(7)
				UNITY_VERTEX_OUTPUT_STEREO
            };

			sampler2D _MainTex;
			half4 _MainTex_ST;
            sampler2D _NormalMap;
            half4 _NormalMap_ST;
            sampler2D _HeightMap;
            half4 _HeightMap_ST;

            sampler2D _WaterRefraction;
            half4 _WaterRefraction_ST;

            fixed4 _WaterColor1;
            fixed4 _WaterColor2;

            half3 _AmbianceColor;
            half3 _DiffuseColor;
			half3 _SpecularColor;

            half _RefractionDistort;
			half _RefractionOpacity;

            half _WaterSpeed;
            half4 _Wavex1y1x2y2;
            half4 _WaveSmallx1y1x2y2;

			sampler2D _Reflection;
			half _ReflectionSpace;
			half _ReflectPower;
            
            v2f vert(appdata v)
            {
				v2f o;
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				// Calculate position.
				o.pos = UnityObjectToClipPos(v.vertex);

				// Transfer uv.
				o.uv = v.uv;

				// Transfer color.
#if ENABLE_VERTEX_COLOR
				o.color = v.color;
#endif

				// Calculate grab pos.
				o.grabPos = ComputeGrabScreenPos(o.pos);

				// Calculate vertex attributes.
				VertexAttribute a;
				CALCULATE_VERTEX_ATTRIBUTES(a, v);

				// Transfer data to pixel shader.
				TRANSFER_VERTEX_ATTRIBUTES(o, a, v);
				TRANSFER_VERTEX_TO_FRAGMENT(o);
				UNITY_TRANSFER_FOG(o, o.pos);

                return o;
            }
            
            fixed4 frag(v2f i) : SV_Target
            {
                // Animation uv
#if ENABLE_WAVE_ANIMATION
                float time = _WaterSpeed * _Time.y;
                half2 uvBase1 = half2(_Wavex1y1x2y2.b, _Wavex1y1x2y2.a) * time;
                half2 uvBase2 = half2(_Wavex1y1x2y2.r, _Wavex1y1x2y2.g) * time;
                half2 uvBase3 = half2(_WaveSmallx1y1x2y2.r, _WaveSmallx1y1x2y2.g) * sin(time);
                half2 uvBase4 = half2(_WaveSmallx1y1x2y2.b, _WaveSmallx1y1x2y2.a) * sin(time);
#else
				half2 uvBase1 = half2(_Wavex1y1x2y2.b, _Wavex1y1x2y2.a);
				half2 uvBase2 = half2(_Wavex1y1x2y2.r, _Wavex1y1x2y2.g);
				half2 uvBase3 = half2(_WaveSmallx1y1x2y2.r, _WaveSmallx1y1x2y2.g);
				half2 uvBase4 = half2(_WaveSmallx1y1x2y2.b, _WaveSmallx1y1x2y2.a);
#endif

                half2 uv1 = 0.2 * i.uv + uvBase1;
                half2 uv2 = 0.3 * i.uv + uvBase2;
                half2 uv3 = 1.8 * i.uv + uvBase3;
                half2 uv4 = 1.0 * i.uv + uvBase4;

#if ENABLE_NORMAL
                // Combine normal.
                half3 normal1 = UnpackNormal(tex2D(_NormalMap, TRANSFORM_TEX(uv1, _NormalMap)));
                half3 normal2 = UnpackNormal(tex2D(_NormalMap, TRANSFORM_TEX(uv2, _NormalMap)));
                half3 normal3 = UnpackNormal(tex2D(_NormalMap, TRANSFORM_TEX(uv3, _NormalMap)));
                half3 normal4 = UnpackNormal(tex2D(_NormalMap, TRANSFORM_TEX(uv4, _NormalMap)));

                half3 normalBase1 = normal1 + half3(0, 0, 1);
                half3 normalDetail1 = normal2 * half3(-1, -1, 1);
                half3 normalCombined1 = normalBase1 * dot(normalBase1, normalDetail1) / normalBase1.z - normalDetail1;

                half3 normalBase2 = normal3 + half3(0, 0, 1);
                half3 normalDetail2 = normal4 * half3(-1, -1, 1);
                half3 normalCombined2 = normalBase2 * dot(normalBase2, normalDetail2) / normalBase2.z - normalDetail2;

                half3 normalBase3 = normalCombined1 + half3(0, 0, 1);
                half3 normalDetail3 = normalCombined2 * half3(-1, -1, 1);
                half3 normalCombined = normalBase3 * dot(normalBase3, normalDetail3) / normalBase3.z - normalDetail3;

                i.worldNormal = UnityObjectToWorldNormal(normalCombined);
#endif

				// Calcualte pixel attributes.
				PixelAttribute a;
				CALCULATE_PIXEL_GEO_ATTRIBUTE(a, i);
				CALCULATE_PIXEL_LIGHT_ATTRIBUTE(a, i);

#if ENABLE_HEIGHT
				// Water color with height.
				half height1 = tex2D(_HeightMap, TRANSFORM_TEX(uv1, _HeightMap)).r;
				half height2 = tex2D(_HeightMap, TRANSFORM_TEX(uv2, _HeightMap)).r;
				half height3 = tex2D(_HeightMap, TRANSFORM_TEX(uv3, _HeightMap)).r;
				half height4 = tex2D(_HeightMap, TRANSFORM_TEX(uv4, _HeightMap)).r;

				half heightValue1 = 1.0 - (1.0 - 2.0 * (height1 + height2 - 0.5)) * (1.0 - height3 - height4);
				half heightValue2 = 2.0 * (height2 + height1) * (height3 + height4);
				half heightValue = (height1 + height2) > 0.5 ? heightValue1 : heightValue2;
				heightValue = saturate(heightValue);
				fixed3 waterColor = lerp(
					_WaterColor1.rgb * _WaterColor1.a,
					_WaterColor2.rgb * _WaterColor2.a,
					heightValue);
#endif

                // Lighting.
				fixed3 col = fixed3(0, 0, 0);
#if ENABLE_AMBIANCE
                fixed3 ambience = _AmbianceColor * a.ambience;
#	if ENABLE_VERTEX_COLOR
				col += i.color.a * ambience;
#	else
				col += ambience;
#	endif
#endif

#if ENABLE_DIFFUSE
				fixed3 diffuse = _LightColor0.rgb * _DiffuseColor * a.nDotL;
#	if ENABLE_VERTEX_COLOR
				diffuse *= i.color.a;
#	endif

#	if ENABLE_MAIN
				fixed3 main = tex2D(_MainTex, TRANSFORM_TEX(i.uv, _MainTex));
				diffuse *= main;
#	endif
#	if ENABLE_HEIGHT
				col += waterColor * saturate(diffuse);
#	else
				col += saturate(diffuse);
#	endif
#else
#	if ENABLE_MAIN
				fixed3 main = tex2D(_MainTex, TRANSFORM_TEX(i.uv, _MainTex));
				col += main;
#	endif
#	if ENABLE_HEIGHT
				col += waterColor;
#	endif
#endif

				fixed atten = LIGHT_ATTENUATION(i);
				col *= atten;

#if ENABLE_REFRACTION
                half4 distort = half4(a.worldNormal.xy * _RefractionDistort, 0, 0);
                half4 distortGrabPos = i.grabPos + distort;

                fixed3 refraction = tex2Dproj(_WaterRefraction, UNITY_PROJ_COORD(distortGrabPos));
				col = lerp(refraction, col, _RefractionOpacity);
#endif

#if ENABLE_REFLECTION
				half3 refViewDir = a.viewDir;
				refViewDir.y *= _ReflectionSpace;
				refViewDir = normalize(refViewDir);
				fixed2 reflexUV = float2((refViewDir.x + 1) * 0.5, (refViewDir.z + 1) * 0.5);
#	if ENABLE_REFRACTION
				reflexUV += distort;
#	endif
				fixed4 reflexCol = tex2D(_Reflection, reflexUV);

#	if ENABLE_VERTEX_COLOR
				col += i.color.a * reflexCol * _ReflectPower;
#	else
				col += reflexCol * _ReflectPower;
#	endif
#endif

#if ENABLE_SPECULAR
				fixed3 specular = _LightColor0.rgb * _SpecularColor * a.nDotV;
#	if ENABLE_VERTEX_COLOR
				col += i.color.a * specular;
#	else
				col += specular;
#	endif
#endif

#	if defined(FOG_LINEAR) && defined(ENABLE_VERTEX_COLOR)
				i.fogCoord.x = lerp(1.0, i.fogCoord.x, i.color.a);
#	endif
				UNITY_APPLY_FOG(i.fogCoord, col);

				SHADER_APPLY_VFOG(a, col);

                return half4(col, 1.0);
            }
            ENDCG
        }
    }

	CustomEditor "GameWaterShaderGUI"
}