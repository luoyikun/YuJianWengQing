Shader "AutoBuild/Game/RoleOcclusion__KW__7_10"
{
	Properties
	{
		_RimColor("Rim-Color", Color) = (0.5,0.5,0.5,1)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "Queue"="Geometry+1" }

		Blend One One
		ZWrite Off
		ZTest Greater
		Cull Back
		LOD 100

		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float4 normal: NORMAL;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 normal: TEXCOORD1;
				float4 worldPos: TEXCOORD2;
			};
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.normal = UnityObjectToWorldNormal(v.normal);
				return o;
			}

			fixed4 _RimColor;

			fixed4 frag (v2f i) : SV_Target
			{
				float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
				float spec = dot(viewDirection, i.normal);
				fixed4 col = fixed4(1,1,1,1) * spec * _RimColor;
				return col;
			}
			ENDCG
		}
	}
}
