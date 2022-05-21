// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MK4/Holo1"
{
	Properties
	{
		_Emission("Emission", 2D) = "black" {}
		_Composite("Composite", 2D) = "black" {}
		[HDR]_Color("Color", Color) = (1,0.8168357,0.05147058,0)
		[Toggle(_COLORBYTEXTURE_ON)] _ColorbyTexture("Color by Texture", Float) = 0
		_ColorTexture("Color Texture", 2D) = "white" {}
		_TextureExposition("Texture Exposition", Range( 0 , 1)) = 0
		_Opacity("Opacity", Range( 0 , 1)) = 0
		_Panner1("Panner1", Range( 0 , 2)) = 0
		_Panner2("Panner2", Range( 0 , 2)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature _COLORBYTEXTURE_ON
		#pragma surface surf Standard alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _Color;
		uniform sampler2D _ColorTexture;
		uniform float4 _ColorTexture_ST;
		uniform float _TextureExposition;
		uniform sampler2D _Composite;
		uniform sampler2D _Emission;
		uniform float4 _Composite_ST;
		uniform float _Panner2;
		uniform float _Panner1;
		uniform float _Opacity;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_ColorTexture = i.uv_texcoord * _ColorTexture_ST.xy + _ColorTexture_ST.zw;
			#ifdef _COLORBYTEXTURE_ON
				float4 staticSwitch20 = ( tex2D( _ColorTexture, uv_ColorTexture ) * unity_ColorSpaceDouble * (0.5 + (_TextureExposition - 0.0) * (1.0 - 0.5) / (1.0 - 0.0)) );
			#else
				float4 staticSwitch20 = _Color;
			#endif
			o.Emission = staticSwitch20.rgb;
			float2 panner14 = ( 1.0 * _Time.y * float2( 0,0.5 ) + i.uv_texcoord);
			float4 tex2DNode2 = tex2D( _Emission, i.uv_texcoord );
			float2 uv_Composite = i.uv_texcoord * _Composite_ST.xy + _Composite_ST.zw;
			float2 panner6 = ( ( _Time.y * _Panner2 ) * float2( -0.1,0 ) + i.uv_texcoord);
			float2 panner11 = ( ( _Time.y * _Panner1 ) * float2( 0,0.2 ) + i.uv_texcoord);
			float4 clampResult18 = clamp( ( ( (0.95 + (sin( ( _Time.y * 60.0 ) ) - 0.0) * (1.0 - 0.95) / (1.0 - 0.0)) * ( tex2D( _Composite, panner14 ).g + ( ( tex2DNode2 + ( tex2D( _Composite, uv_Composite ).b * tex2D( _Composite, panner6 ).a ) ) + ( tex2DNode2.a * tex2D( _Composite, panner11 ).r ) ) ) ) * _Opacity ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			o.Alpha = clampResult18.r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
307;395;1353;579;2200.107;202.3143;1.6;True;True
Node;AmplifyShaderEditor.TimeNode;38;-1772.585,396.4132;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;42;-1638.929,113.4177;Float;False;Property;_Panner2;Panner2;8;0;Create;True;0;0;False;0;0;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-1714.436,545.4342;Float;False;Property;_Panner1;Panner1;7;0;Create;True;0;0;False;0;0;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-1624.054,-35.6908;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-1224.933,43.92215;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-1317.203,166.082;Float;True;Property;_Composite;Composite;1;0;Create;True;0;0;False;0;None;27893138eecb41f4a96d9b8c35a85d0a;False;black;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.PannerNode;6;-1047.953,-57.1539;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-1411.436,429.4342;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;11;-1139.642,387.1957;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.2;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;8;-805.5918,-96.80281;Float;True;Property;_TextureSample2;Texture Sample 2;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-826.2941,160.6673;Float;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;1;-1270.069,-510.6367;Float;True;Property;_Emission;Emission;0;0;Create;True;0;0;False;0;None;a58b4b73606fe4a489e868e62ff51987;False;black;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;2;-791.0591,-340.942;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-400.6456,-59.30924;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;29;-331.9859,501.3998;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;10;-836.7957,364.4066;Float;True;Property;_TextureSample3;Texture Sample 3;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;14;-1141.292,593.2313;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.5;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-333.7194,235.031;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-281.0931,-197.0101;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-108.1389,502.8822;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;60;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-31.97456,-138.2542;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;15;-836.83,570.4422;Float;True;Property;_TextureSample4;Texture Sample 4;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;28;53.44575,471.7511;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-198.0858,-284.6392;Float;False;Property;_TextureExposition;Texture Exposition;5;0;Create;True;0;0;False;0;0;0.431;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;105.2122,145.499;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;33;212.6656,435.7004;Float;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.95;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;25;125.0689,-442.7341;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.5;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;555.8214,247.8768;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;21;-25.83435,-836.4863;Float;True;Property;_ColorTexture;Color Texture;4;0;Create;True;0;0;False;0;None;8da6a4a3986ebf0448544f0e797ceb6f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorSpaceDouble;23;-41.15273,-627.1631;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;35;652.8076,384.9246;Float;True;Property;_Opacity;Opacity;6;0;Create;True;0;0;False;0;0;0.702;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;831.97,196.6083;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;17;172.2655,-216.6421;Float;False;Property;_Color;Color;2;1;[HDR];Create;True;0;0;False;0;1,0.8168357,0.05147058,0;0.07992861,1.053603,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;328.0502,-607.5162;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;18;1031.49,203.1012;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;20;457.263,-206.5416;Float;False;Property;_ColorbyTexture;Color by Texture;3;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1323.674,-187.8606;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MK4/Holo1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;41;0;38;2
WireConnection;41;1;42;0
WireConnection;6;0;5;0
WireConnection;6;1;41;0
WireConnection;39;0;38;2
WireConnection;39;1;40;0
WireConnection;11;0;5;0
WireConnection;11;1;39;0
WireConnection;8;0;3;0
WireConnection;4;0;3;0
WireConnection;4;1;6;0
WireConnection;2;0;1;0
WireConnection;2;1;5;0
WireConnection;9;0;8;3
WireConnection;9;1;4;4
WireConnection;10;0;3;0
WireConnection;10;1;11;0
WireConnection;14;0;5;0
WireConnection;12;0;2;4
WireConnection;12;1;10;1
WireConnection;7;0;2;0
WireConnection;7;1;9;0
WireConnection;30;0;29;2
WireConnection;13;0;7;0
WireConnection;13;1;12;0
WireConnection;15;0;3;0
WireConnection;15;1;14;0
WireConnection;28;0;30;0
WireConnection;16;0;15;2
WireConnection;16;1;13;0
WireConnection;33;0;28;0
WireConnection;25;0;24;0
WireConnection;31;0;33;0
WireConnection;31;1;16;0
WireConnection;34;0;31;0
WireConnection;34;1;35;0
WireConnection;22;0;21;0
WireConnection;22;1;23;0
WireConnection;22;2;25;0
WireConnection;18;0;34;0
WireConnection;20;1;17;0
WireConnection;20;0;22;0
WireConnection;0;2;20;0
WireConnection;0;9;18;0
ASEEND*/
//CHKSM=99F96F01CCD00D5E73EE7E9D7DD65AEFFF7B282B