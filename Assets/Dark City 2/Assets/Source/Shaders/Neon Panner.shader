// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MK4/Neon Panner"
{
	Properties
	{
		_Neon("Neon", 2D) = "white" {}
		_Smoothness("Smoothness", Range( 0 , 1)) = 0.3
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_EmissionMultiply("Emission Multiply", Color) = (1,1,1,0)
		_AlbedoColor("Albedo Color", Color) = (0.5019608,0.5019608,0.5019608,0)
		_PannerSpeed("Panner Speed", Vector) = (0,0.2,0,0)
		_PulsatingSpeed("Pulsating Speed", Range( 0 , 1)) = 0.3
		_PulsatingInt("Pulsating Int", Range( 0 , 1)) = 0.2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _AlbedoColor;
		uniform float4 _EmissionMultiply;
		uniform float _PulsatingSpeed;
		uniform float _PulsatingInt;
		uniform sampler2D _Neon;
		uniform float2 _PannerSpeed;
		uniform float _Metallic;
		uniform float _Smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Albedo = _AlbedoColor.rgb;
			float lerpResult29 = lerp( 1.0 , (0.5 + (sin( ( ( _Time.y * 1.3 ) * (0.1 + (_PulsatingSpeed - 0.0) * (16.0 - 0.1) / (1.0 - 0.0)) ) ) - 0.0) * (1.0 - 0.5) / (1.0 - 0.0)) , _PulsatingInt);
			float2 uv_TexCoord7 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			float2 panner8 = ( uv_TexCoord7 + 1.0 * _Time.y * _PannerSpeed);
			float4 clampResult33 = clamp( ( _EmissionMultiply * ( lerpResult29 * tex2D( _Neon, panner8 ) ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Emission = clampResult33.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14301
213;311;1297;692;2240.253;802.9324;3.060317;True;True
Node;AmplifyShaderEditor.RangedFloatNode;17;-1443.971,567.6721;Float;False;Property;_PulsatingSpeed;Pulsating Speed;6;0;Create;True;0.3;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;12;-1370.545,312.9576;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-1139.249,301.503;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;1.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;18;-1165.441,569.2372;Float;False;5;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;0.1;False;4;FLOAT;16.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-945.8856,284.7098;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;9;-1279.297,81.91925;Float;False;Property;_PannerSpeed;Panner Speed;5;0;Create;True;0,0.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-1308.505,-109.3191;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;19;-794.4169,281.825;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-636.8643,446.7899;Float;False;Property;_PulsatingInt;Pulsating Int;7;0;Create;True;0.2;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;15;-654.4595,266.5153;Float;False;5;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;0.5;False;4;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;8;-931.5864,42.51976;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;-702.0999,29.66353;Float;True;Property;_Neon;Neon;0;0;Create;True;a9f84de2304826a439a962d9aecbfcf9;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;29;-366.8152,231.6036;Float;False;3;0;FLOAT;1.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-192.7508,20.56035;Float;False;2;2;0;FLOAT;0.0;False;1;COLOR;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;32;-225.9025,-374.2531;Float;False;Property;_EmissionMultiply;Emission Multiply;3;0;Create;True;1,1,1,0;0.5019608,0.5019608,0.5019608,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;38.81883,-300.2628;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;6;-710.4362,-209.6102;Float;False;Property;_AlbedoColor;Albedo Color;4;0;Create;True;0.5019608,0.5019608,0.5019608,0;0.5019608,0.5019608,0.5019608,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;33;197.7595,-172.609;Float;False;3;0;COLOR;0.0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-306.7422,-130.5353;Float;False;Property;_Metallic;Metallic;2;0;Create;True;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-311.6278,-62.40517;Float;False;Property;_Smoothness;Smoothness;1;0;Create;True;0.3;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;350.0481,-234.7024;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MK4/Neon Panner;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;24;0;12;2
WireConnection;18;0;17;0
WireConnection;20;0;24;0
WireConnection;20;1;18;0
WireConnection;19;0;20;0
WireConnection;15;0;19;0
WireConnection;8;0;7;0
WireConnection;8;2;9;0
WireConnection;1;1;8;0
WireConnection;29;1;15;0
WireConnection;29;2;23;0
WireConnection;22;0;29;0
WireConnection;22;1;1;0
WireConnection;34;0;32;0
WireConnection;34;1;22;0
WireConnection;33;0;34;0
WireConnection;0;0;6;0
WireConnection;0;2;33;0
WireConnection;0;3;31;0
WireConnection;0;4;30;0
ASEEND*/
//CHKSM=5BD66C137FB30B58AF03EA2D8F4FF816B3CC477A