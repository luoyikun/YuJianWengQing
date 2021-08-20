// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "GreatWall/AnimPlant" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	_Wind("Wind params",Vector) = (1,1,1,0.5)	
	_WindFreqScale("Wind freq scale",float) = 0.5
	_BranchIntensity("BranchIntensity",float) = 0.5
	_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
}

SubShader {
	Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
	LOD 200
	Cull Off
	
CGPROGRAM
#pragma surface surf Lambert alphatest:_Cutoff vertex:vert
#include "TerrainEngine.cginc"

sampler2D _MainTex;
fixed4 _Color;
fixed _WindFreqScale,_BranchIntensity;

struct Input {
	float2 uv_MainTex;
};

void vert (inout appdata_full v,out Input o) {

	UNITY_INITIALIZE_OUTPUT(Input,o);

	float4	wind;

	wind.xyz	= mul((float3x3)unity_WorldToObject,normalize(_Wind.xyz + float3(0.001,0.0,0.0)) );
	wind.w		= _Wind.w  * v.color.a;
	
	half4 worldPos = mul(unity_ObjectToWorld , v.vertex );
	float fObjPhase = dot(worldPos.xyz,1);

	float2 windTime = (_Time.yy + fObjPhase.xx) * _WindFreqScale;

	float4 vWaves = ( windTime.xxyy * float4(1.975, 0.793, 0.375, 0.193) );


	vWaves = SmoothTriangleWave( vWaves );
	
	float2 vWavesSum = vWaves.xz + vWaves.yw ;

	v.vertex.xyz += wind.xyz *  wind.w  ;
	v.vertex.xyz += vWavesSum.xyy * _BranchIntensity * v.color.a;	
}

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
	o.Albedo = c.rgb;
	o.Alpha = c.a;
}
ENDCG
}

Fallback "Legacy Shaders/Transparent/Cutout/VertexLit"
}