// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/Game/Cloud" {
	Properties {
		_MainTex ("Texture (R)", 2D) = "white" {}
		_TexTiling ("Texture Tiling", Range(1, 4)) = 1
		_AlphaSaturation ("Alpha Saturation", Range(1, 10)) = 1.5
		_RotateSpeed ("Rotate Speed", Range(-1, 1)) = 0.5
		_SkyColor ("Sky Color", Color) = (1, 1, 1, 1)
		_LightColor ("Light Color", Color) = (0.8, 1, 1, 1)
		_LightDir ("Light Direction", Vector) = (1, 0, 0, 1)
		_LightStep ("Light Step", Range(0.001, 0.01)) = 0.002
		_LightStrength ("Light Strength", Range(0, 1)) = 0.4
	}

	SubShader {
		Tags { "Queue"="Geometry+501" "RenderType"="Background" }

		Blend SrcAlpha OneMinusSrcAlpha
		Zwrite Off

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#pragma multi_compile _ LIGHT_COLOR

			sampler2D _MainTex;
			uniform half _TexTiling;
			uniform half _AlphaSaturation;
			uniform float _RotateSpeed;
			uniform half3 _SkyColor;

			#ifdef LIGHT_COLOR
				uniform half3 _LightColor;
				uniform float3 _LightDir;
				uniform float _LightStep;
				uniform half _LightStrength;
			#endif

			struct appdata_t {
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float2 rectangular : TEXCOORD0;
				float2 polar : TEXCOORD1;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				half2 uv : TEXCOORD0;
				#ifdef LIGHT_COLOR
					half2 lightdir : TEXCOORD1;
				#endif
			};

			float3 RotateAroundYInDegrees(float3 vertex, float degrees) {
				float alpha = degrees * 3.1416 / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
				float2x2 m = float2x2(cosa, -sina, sina, cosa);
				return float3(mul(m, vertex.xz), vertex.y).xzy;
			}

			v2f vert(appdata_t v) {
				v2f o;

				float offsetValue = _RotateSpeed * _Time.y + unity_DeltaTime.z;
				float3 t = RotateAroundYInDegrees(v.vertex.xyz, offsetValue);
				t = t * _ProjectionParams.z + _WorldSpaceCameraPos.xyz;

				o.pos = UnityObjectToClipPos(float4(t, 1));
#if SHADER_API_D3D11 || SHADER_API_METAL
				o.pos.z = 0;
#else
				o.pos.z = o.pos.w;
#endif
				o.uv = half2(v.rectangular.x * _TexTiling, v.rectangular.y);

				#ifdef LIGHT_COLOR
					float3 dir = RotateAroundYInDegrees(_LightDir, offsetValue);
					TANGENT_SPACE_ROTATION;
					o.lightdir = mul(rotation, dir).xy * _LightStep;
				#endif

				return o;
			}

			half4 frag(v2f i) : SV_Target {
				half2 uv = i.uv.xy;
				half4 tex = tex2D(_MainTex, uv);

				#ifdef LIGHT_COLOR
					half density = 0;
					for (int k = 1; k <= 8; k++) {
						density += tex2D(_MainTex, uv + k * i.lightdir).r;
					}
					half t = saturate(8.0 / density * _LightStrength * _LightStrength);
					half3 col = lerp(_SkyColor.xyz, _LightColor.xyz, t);
				#else
					half3 col = _SkyColor.xyz;
				#endif

				half a = pow(tex.r, _AlphaSaturation);

				return half4(col, a);

			}
			ENDCG

		}
	}

	Fallback Off
}