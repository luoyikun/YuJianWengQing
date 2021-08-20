Shader "Hidden/Game/BackGround" {
	Properties {
		_MainTex ("Texture (R)", 2D) = "white" {}
	}

	SubShader {
		Tags { "Queue"="AlphaTest+10" "RenderType"="Background" }

		Blend SrcAlpha OneMinusSrcAlpha
		Zwrite Off

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			half4 _MainTex_ST;
			uniform float _RotateSpeed;

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
			};

			v2f vert(appdata_t v) {
				v2f o;

				float3 t = v.vertex.xyz * _ProjectionParams.z + _WorldSpaceCameraPos.xyz;

				o.pos = UnityObjectToClipPos(float4(t, 1));
#if SHADER_API_D3D11 || SHADER_API_METAL
				o.pos.z = 0;
#else
				o.pos.z = o.pos.w;
#endif
				o.uv = TRANSFORM_TEX(v.rectangular, _MainTex);

				return o;
			}

			half4 frag(v2f i) : SV_Target {
				return tex2D(_MainTex, i.uv);

			}
			ENDCG

		}
	}

	Fallback Off
}
