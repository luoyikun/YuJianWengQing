// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Hidden/Game/Skybox" {
	Properties {
	}

	SubShader {
		Tags { "Queue"="Background" "RenderType"="Background" "PreviewType"="Skybox" }

		Cull Off
		ZWrite Off

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile SUN_ON SUN_OFF
			#pragma multi_compile MOON_ON MOON_OFF
			#pragma multi_compile SPACE_ON SPACE_OFF
#pragma target 2.0
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			half _Stretch;
			#ifdef SUN_ON
				fixed4 _SunColor;
				half _SunOffset;
			#endif
			#ifdef MOON_ON
				sampler2D _MoonTex;
				half4 _MoonDirSize;
				half _MoonAlpha;
			#endif
			#ifdef SPACE_ON
				samplerCUBE _SpaceTex;
				half4x4 _SpaceTrans;
				half _SpaceAlpha;
			#endif
			half _Exposure;

			struct appdata_t {
				float4 vertex : POSITION;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				half3 eyeDir : TEXCOORD0;
				#ifdef MOON_ON
					half3 moonUV : TEXCOORD1;
				#endif
				#ifdef SPACE_ON
					half3 spaceUV : TEXCOORD2;
				#endif
			};

			v2f vert(appdata_t v) {
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				float z = o.vertex.z;

				o.vertex.z = 0;
				o.eyeDir = normalize(mul((float3x3)unity_ObjectToWorld, v.vertex.xyz));

				#ifdef MOON_ON
					half3 right = normalize(cross(_MoonDirSize.xyz, half3(0, 0, 1)));
					half3 up = cross(_MoonDirSize.xyz, right);
					o.moonUV.xy = half2(dot(right, v.vertex.xyz), dot(up, v.vertex.xyz)) * _MoonDirSize.w + 0.5;
					o.moonUV.z = saturate(dot(_MoonDirSize.xyz, v.vertex.xyz) * -1);
				#endif
				#ifdef SPACE_ON
					o.spaceUV = mul((float3x3)_SpaceTrans, v.vertex.xyz);
				#endif

				o.vertex.z = z;

				return o;
			}

			fixed4 frag(v2f i) : SV_Target {
				half3 eyeDir = normalize(i.eyeDir);
				half2 uv = half2(0.5, 1.0 - pow(saturate(0.5 - eyeDir.y), _Stretch));
				fixed4 tex = tex2D(_MainTex, uv);

				#ifdef SUN_ON
					half3 lightDir = _WorldSpaceLightPos0;
					lightDir.y += _SunOffset;
					lightDir = normalize(lightDir);
					half edl = max(0, dot(lightDir, eyeDir));
					half sun = pow(edl, 256.0) * 2.0;
					half brightness = edl * 0.5 + 1.0;
					fixed3 c = (tex.rgb + sun * _SunColor) * brightness * _Exposure;
				#else
					fixed3 c = tex.rgb * _Exposure;
				#endif

				#ifdef SPACE_ON
					fixed3 space = texCUBE(_SpaceTex, i.spaceUV).rgb * _SpaceAlpha * _Exposure;
					c = c + space * eyeDir.y;
				#endif

				#ifdef MOON_ON
					fixed3 moon = tex2D(_MoonTex, i.moonUV).rgb * unity_ColorSpaceDouble.rgb * _MoonAlpha * i.moonUV.z;
					c = c * (1 - moon) + moon;
				#endif

				return fixed4(c, 1);
			}
			ENDCG
		}
	}

	Fallback Off
}
