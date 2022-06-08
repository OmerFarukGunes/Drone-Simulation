// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/SFX/Distortion/NoiseDistortionAdjust"
{
	Properties
	{
		[HDR]_TintColor("Tint Color", Color) = (1,0,0,1)
		_MainTex("Main Tex", 2D) = "white" {}
		_NoiseMap("Noise Map", 2D) = "white" {}
		_DistortionMap("Distortion Map", 2D) = "white" {}
		_NoiseDistortionPower("Noise Distortion Power", Range( 0 , 2)) = 0.2179676
		_NoiseDistortionTilling("Noise Distortion Tilling", Range( 0 , 10)) = 1.142912
		_NoiseDistortionSpeed("Noise Distortion Speed", Vector) = (0,0.2,0,0)
		_NoisePower("Noise Power", Range( 0 , 2)) = 2
		_NoiseOffset("Noise Offset", Range( 0 , 1)) = 0
		_NoiseTilling("Noise Tilling", Range( 0 , 10)) = 0.894883
		_NoiseSpeed("Noise Speed", Vector) = (0.2,0,0,0)
		_AdjustPower("Adjust Power", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _tex4coord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 uv_tex4coord;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float4 _TintColor;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _NoiseMap;
		uniform sampler2D _DistortionMap;
		uniform float2 _NoiseDistortionSpeed;
		uniform float _NoiseDistortionTilling;
		uniform float _NoiseDistortionPower;
		uniform float2 _NoiseSpeed;
		uniform float _NoiseTilling;
		uniform float _NoisePower;
		uniform float _NoiseOffset;
		uniform float _AdjustPower;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 uv_MainTex = i.uv_tex4coord;
			uv_MainTex.xy = i.uv_tex4coord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 panner21_g2 = ( 1.0 * _Time.y * _NoiseDistortionSpeed + i.uv_texcoord);
			float temp_output_72_0_g2 = ( tex2D( _DistortionMap, (panner21_g2*_NoiseDistortionTilling + 0.0) ).r * _NoiseDistortionPower );
			float2 panner71_g2 = ( 1.0 * _Time.y * _NoiseSpeed + i.uv_texcoord);
			float4 temp_output_5_0 = ( _TintColor * saturate( pow( tex2D( _MainTex, ( uv_MainTex + ( ( tex2D( _NoiseMap, ( temp_output_72_0_g2 + (panner71_g2*_NoiseTilling + 0.0) ) ).r * _NoisePower ) - _NoiseOffset ) ).xy ).r , ( _AdjustPower + i.uv_tex4coord.z ) ) ) );
			o.Emission = ( temp_output_5_0 * i.vertexColor.a ).rgb;
			o.Alpha = saturate( ( (temp_output_5_0).a * i.vertexColor.a ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15600
137;332;1412;619;1817.7;349.6143;2.396759;True;False
Node;AmplifyShaderEditor.FunctionNode;45;-1630.408,226.8817;Float;False;QFX Get Simple Noise Distortion;2;;2;dba3a45ee088a1c42ae7fbf09d132e5e;0;0;4;COLOR;81;COLOR;82;FLOAT;64;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-1404.228,34.17705;Float;False;0;3;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;8;-1384.98,267.6622;Float;False;True;True;False;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;43;-1075.579,704.583;Float;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-1112.935,136.2967;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1070.51,617.2928;Float;False;Property;_AdjustPower;Adjust Power;12;0;Create;True;0;0;False;0;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-921.1802,106.9859;Float;True;Property;_MainTex;Main Tex;1;0;Create;True;0;0;False;0;2a2854d4b1276ce43b7452693bf47e04;c08287335df0f1b43820e27dee902611;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;46;-729.9175,410.1852;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;14;-560.3757,226.328;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;38;-250.9929,226.2089;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;4;-374.0428,-197.2021;Float;False;Property;_TintColor;Tint Color;0;1;[HDR];Create;True;0;0;False;0;1,0,0,1;1.5,2.648276,6.000001,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;26.4915,-12.95182;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;9;71.20584,479.3232;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;48;226.4388,363.745;Float;False;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;432.9882,434.5071;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;50;572.6005,415.3822;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;375.6243,128.2012;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;47;878.7603,86.41972;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;QFX/SFX/Distortion/NoiseDistortionAdjust;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;45;0
WireConnection;7;0;6;0
WireConnection;7;1;8;0
WireConnection;3;1;7;0
WireConnection;46;0;15;0
WireConnection;46;1;43;3
WireConnection;14;0;3;1
WireConnection;14;1;46;0
WireConnection;38;0;14;0
WireConnection;5;0;4;0
WireConnection;5;1;38;0
WireConnection;48;0;5;0
WireConnection;49;0;48;0
WireConnection;49;1;9;4
WireConnection;50;0;49;0
WireConnection;12;0;5;0
WireConnection;12;1;9;4
WireConnection;47;2;12;0
WireConnection;47;9;50;0
ASEEND*/
//CHKSM=6E14D249439D4183432FD91D269891E54CEFD2C2