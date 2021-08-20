Shader "Game/PostEffect/UICameraPostEffect"
{
	Properties
	{
		_MainTex("Base (RGB)", 2D) = "" {}
	}

	CGINCLUDE

	#include "UnityCG.cginc"

	#pragma multi_compile _ _BLOOM_ADD _BLOOM_SCREEN
	#pragma multi_compile _ _SATURATION
	#pragma multi_compile _ _COLOR_CURVE
	#pragma multi_compile _ _VIGNETTE_INTENSITY
	#pragma multi_compile _ _VIGNETTE_BLUR

	struct v2f
	{
		float4 pos : SV_POSITION;
		half2 uv : TEXCOORD0;
	};

	sampler2D _MainTex;
	half4 _CameraColor;


	v2f vert(appdata_img v)
	{
		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.uv = v.texcoord.xy;
		return o;
	}

	fixed cal(half value)
	{
		fixed a = saturate(abs(value));
		return ceil(a - 0.1);
	}

	half4 frag(v2f i) : SV_Target
	{
		half4 color = tex2D(_MainTex, i.uv);

		fixed value = max(cal(color.r - _CameraColor.r), cal(color.g - _CameraColor.g));
		color.a *= value;

		return color;
	}

	ENDCG

	Subshader
	{
		Cull Off
		ZTest Off
		ZWrite Off

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			ENDCG
		}
	}

	Fallback off
}
