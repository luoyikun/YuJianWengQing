// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "AutoBuild/Game/Grass__KW__" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}

	_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5

	_UVCut("UVCut", Range(0, 1)) = 0
	_WaveScale("Wave Scale", Float) = 0.2
	_WaveControl1("Waves", Vector) = (1, 0.01, 0.001, 0)
	_TimeControl1("Time", Vector) = (1, 10, 0.02, 100)
	_WaveXFactor("Wave Control x axis", Float) = 1
	_WaveYFactor("Wave Control y axis", Float) = 1


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

half3 _WaveControl1;
half3 _TimeControl1;

half _UVCut;
half _WaveScale;
half _WaveXFactor;
half _WaveYFactor;


struct Input {
	float2 uv_MainTex;
};

void vert (inout appdata_full v,out Input o) {

	UNITY_INITIALIZE_OUTPUT(Input,o);

	half factor = saturate(v.texcoord.y - _UVCut);

	half4 worldPos = mul(unity_ObjectToWorld, v.vertex);
	worldPos.x += _WaveScale * 3 * cos(worldPos.x*_WaveControl1.x + _Time.y*_TimeControl1.x + worldPos.z*_WaveControl1.z)*0.1*sin(worldPos.z + _Time.y) * factor;
	worldPos.z += _WaveScale * 3 * sin(worldPos.x*_WaveControl1.x + _Time.y*_TimeControl1.x + worldPos.z*_WaveControl1.z)*0.1*cos(worldPos.z + _Time.y) * factor;

	v.vertex.xyz = mul(unity_WorldToObject, worldPos);
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