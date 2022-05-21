// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MK4/Second UV AO"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "gray" {}
		_MetalicGloss("Metalic Gloss", 2D) = "black" {}
		_Normalmap("Normalmap", 2D) = "bump" {}
		_NormalScale("Normal Scale", Range( 0 , 5)) = 1
		_AO1("AO1", 2D) = "white" {}
		_AO1Intensity("AO1 Intensity", Range( 0 , 1)) = 1
		_AO2("AO2", 2D) = "white" {}
		_AO2Intensity("AO2 Intensity", Range( 0 , 1)) = 0
		_AO2GlossMultiply("AO2 Gloss Multiply", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float2 uv2_texcoord2;
		};

		uniform float _NormalScale;
		uniform sampler2D _Normalmap;
		uniform sampler2D _Albedo;
		uniform sampler2D _MetalicGloss;
		uniform sampler2D _AO2;
		uniform float _AO2GlossMultiply;
		uniform sampler2D _AO1;
		uniform float _AO1Intensity;
		uniform float _AO2Intensity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = UnpackScaleNormal( tex2D( _Normalmap, i.uv_texcoord ), _NormalScale );
			o.Albedo = tex2D( _Albedo, i.uv_texcoord ).rgb;
			float4 tex2DNode3 = tex2D( _MetalicGloss, i.uv_texcoord );
			o.Metallic = tex2DNode3.r;
			float4 tex2DNode20 = tex2D( _AO2, i.uv2_texcoord2 );
			float4 lerpResult21 = lerp( float4( 1,1,1,0 ) , tex2DNode20 , _AO2GlossMultiply);
			o.Smoothness = ( lerpResult21 * tex2DNode3.a ).r;
			float4 lerpResult8 = lerp( float4( 1,1,1,0 ) , tex2D( _AO1, i.uv_texcoord ) , _AO1Intensity);
			float4 lerpResult14 = lerp( float4( 1,1,1,0 ) , tex2DNode20 , _AO2Intensity);
			float4 clampResult13 = clamp( ( lerpResult8 * lerpResult14 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Occlusion = clampResult13.r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
9;349;1353;526;1785.915;277.8045;1.733982;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;18;-1552.718,106.6798;Float;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;16;-1482.239,671.9606;Float;True;Property;_AO2;AO2;6;0;Create;True;0;0;False;0;None;5b77cb3707c3f3844a97f60c36f128dc;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;15;-1468.227,363.2769;Float;True;Property;_AO1;AO1;4;0;Create;True;0;0;False;0;None;8e2075ab67410fc4381cdcdbc392650a;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-1550.365,-10.07719;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-1041.974,907.476;Float;False;Property;_AO2Intensity;AO2 Intensity;7;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;20;-1148.128,671.3327;Float;True;Property;_TextureSample1;Texture Sample 1;8;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;19;-1140.358,367.9141;Float;True;Property;_TextureSample0;Texture Sample 0;8;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;9;-1041.338,586.2966;Float;False;Property;_AO1Intensity;AO1 Intensity;5;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-791.1002,44.72144;Float;False;Property;_AO2GlossMultiply;AO2 Gloss Multiply;8;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;8;-753.0947,369.1599;Float;False;3;0;COLOR;1,1,1,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;14;-744.3236,652.3173;Float;False;3;0;COLOR;1,1,1,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-358.7234,445.9172;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1197.947,233.4647;Float;False;Property;_NormalScale;Normal Scale;3;0;Create;True;0;0;False;0;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-788.7115,-168.2009;Float;True;Property;_MetalicGloss;Metalic Gloss;1;0;Create;True;0;0;False;0;None;3ada18b09b0e9f34cac1bae184c2bf91;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;21;-462.4141,26.56132;Float;False;3;0;COLOR;1,1,1,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-777.8353,-362.2997;Float;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;False;0;None;8741047451c12124c8be7309f6550cd7;True;0;False;gray;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-810.2248,161.3754;Float;True;Property;_Normalmap;Normalmap;2;0;Create;True;0;0;False;0;None;303ff61db6c36684895878d3e017f9b6;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-249.7396,16.80003;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;13;-222.7239,319.5174;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MK4/Second UV AO;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;20;0;16;0
WireConnection;20;1;18;0
WireConnection;19;0;15;0
WireConnection;19;1;17;0
WireConnection;8;1;19;0
WireConnection;8;2;9;0
WireConnection;14;1;20;0
WireConnection;14;2;12;0
WireConnection;11;0;8;0
WireConnection;11;1;14;0
WireConnection;3;1;17;0
WireConnection;21;1;20;0
WireConnection;21;2;22;0
WireConnection;2;1;17;0
WireConnection;4;1;17;0
WireConnection;4;5;7;0
WireConnection;23;0;21;0
WireConnection;23;1;3;4
WireConnection;13;0;11;0
WireConnection;0;0;2;0
WireConnection;0;1;4;0
WireConnection;0;3;3;0
WireConnection;0;4;23;0
WireConnection;0;5;13;0
ASEEND*/
//CHKSM=7F9F08F6C1303E9F7A6B5055DD8FBE3E5D9BBDAF