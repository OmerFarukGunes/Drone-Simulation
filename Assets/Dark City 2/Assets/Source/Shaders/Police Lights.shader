// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MK4/Police Light"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "gray" {}
		_Normalmap("Normalmap", 2D) = "bump" {}
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		[HDR]_Color2("Color2", Color) = (0,0.541182,1,0)
		[HDR]_Color1("Color1", Color) = (1,0,0,0)
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

		uniform sampler2D _Normalmap;
		uniform float4 _Normalmap_ST;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float4 _Color1;
		uniform float4 _Color2;
		uniform float _Smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normalmap = i.uv_texcoord * _Normalmap_ST.xy + _Normalmap_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normalmap, uv_Normalmap ) );
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			o.Albedo = tex2D( _Albedo, uv_Albedo ).rgb;
			float4 lerpResult20 = lerp( _Color1 , _Color2 , sin( ( _Time.y * 20.0 ) ));
			float clampResult14 = clamp( (0.0 + (sin( ( _Time.y * 10.0 ) ) - 0.3) * (1.0 - 0.0) / (0.7 - 0.3)) , 0.0 , 1.0 );
			float clampResult16 = clamp( (0.5 + (sin( ( _Time.y * 40.0 ) ) - 0.0) * (1.0 - 0.5) / (1.0 - 0.0)) , 0.0 , 1.0 );
			o.Emission = ( lerpResult20 * ( clampResult14 * clampResult16 ) ).rgb;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15600
9;314;1200;683;1414.11;676.9504;2.231119;True;True
Node;AmplifyShaderEditor.TimeNode;2;-1521.765,-68.26225;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1259.775,-13.44444;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;40;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1275.775,-251.8447;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;10;-1085.375,-194.8759;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;3;-1041.888,75.10242;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;15;-888.18,95.67452;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.5;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-1242.986,195.7412;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;13;-841.5507,-308.1992;Float;False;5;0;FLOAT;0;False;1;FLOAT;0.3;False;2;FLOAT;0.7;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;14;-658.9793,-285.8183;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;22;-1060.797,229.3881;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;18;-874.2293,558.4267;Float;False;Property;_Color2;Color2;3;1;[HDR];Create;True;0;0;False;0;0,0.541182,1,0;0,1.254902,2,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;16;-684.2448,122.5497;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;17;-872.0635,386.7452;Float;False;Property;_Color1;Color1;4;1;[HDR];Create;True;0;0;False;0;1,0,0,0;0,1.254902,2,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;20;-506.8347,414.0339;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-535.2317,-12.91355;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;27;-316.3466,-638.9608;Float;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;False;0;None;4f65752fbef1e7a42bc15a7d84284f14;True;0;False;gray;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-144.078,120.9389;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;28;-316.3466,-350.7444;Float;True;Property;_Normalmap;Normalmap;1;0;Create;True;0;0;False;0;None;b8895c406c947664d88f283ce8bcecd3;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;29;-23.0093,-236.9702;Float;False;Property;_Smoothness;Smoothness;2;0;Create;True;0;0;False;0;0;0.872;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;366.4047,-346.1829;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MK4/Police Light;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;2;2
WireConnection;9;0;2;2
WireConnection;10;0;9;0
WireConnection;3;0;8;0
WireConnection;15;0;3;0
WireConnection;21;0;2;2
WireConnection;13;0;10;0
WireConnection;14;0;13;0
WireConnection;22;0;21;0
WireConnection;16;0;15;0
WireConnection;20;0;17;0
WireConnection;20;1;18;0
WireConnection;20;2;22;0
WireConnection;11;0;14;0
WireConnection;11;1;16;0
WireConnection;19;0;20;0
WireConnection;19;1;11;0
WireConnection;0;0;27;0
WireConnection;0;1;28;0
WireConnection;0;2;19;0
WireConnection;0;4;29;0
ASEEND*/
//CHKSM=6203E08EF0FE69AFE2F70233B71406D9A9564F86