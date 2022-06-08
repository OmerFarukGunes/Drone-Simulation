// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/SFX/Cutout/NoiseCutOut"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[HDR]_Color("Color", Color) = (0,0,0,0)
		_Noise("Noise", 2D) = "white" {}
		_Tiling("Tiling", Vector) = (1,1,0,0)
		_Speed("Speed", Vector) = (0,0,0,0)
		_AlphaCutout("Alpha Cutout", Float) = 0
		_LinePower("Line Power", Float) = 5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _Noise;
		uniform float2 _Speed;
		uniform float2 _Tiling;
		uniform float4 _Color;
		uniform float _LinePower;
		uniform float _AlphaCutout;
		uniform float _Cutoff = 0.5;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_TexCoord8 = i.uv_texcoord * _Tiling;
			float2 panner5 = ( 1.0 * _Time.y * _Speed + uv_TexCoord8);
			float4 tex2DNode7 = tex2D( _Noise, panner5 );
			float4 Emission46 = ( tex2DNode7 * _Color );
			o.Emission = ( Emission46 * i.vertexColor.a ).rgb;
			float temp_output_31_4 = i.vertexColor.a;
			o.Alpha = temp_output_31_4;
			float temp_output_20_0 = (i.uv_texcoord).y;
			float4 OpacityMask44 = ( ( pow( ( ( temp_output_20_0 * ( 1.0 - temp_output_20_0 ) ) * 4.0 ) , _LinePower ) * ( tex2DNode7 * float4( 2,0,0,0 ) ) ) * ( ( tex2DNode7.r + 1.0 ) - _AlphaCutout ) );
			clip( OpacityMask44.r - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15600
212;194;1412;619;3783.507;1301.964;5.590684;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-147.5151,-74.37685;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;11;-183.2759,389.3247;Float;False;Property;_Tiling;Tiling;3;0;Create;True;0;0;False;0;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ComponentMaskNode;20;145.9663,-78.68196;Float;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;36.10032,372.7934;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;12;-181.7251,533.5251;Float;False;Property;_Speed;Speed;4;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.OneMinusNode;21;361.6792,63.05465;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;5;298.0439,371.9266;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;517.7378,-74.08687;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;794.8809,518.7543;Float;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;662.3799,-76.08864;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;652.4051,51.61428;Float;False;Property;_LinePower;Line Power;6;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;510.0792,343.4991;Float;True;Property;_Noise;Noise;2;0;Create;True;0;0;False;0;None;899b5107809f24c4db8af5f6bf40c2b0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;29;1582.882,617.8651;Float;False;Property;_Color;Color;1;1;[HDR];Create;True;0;0;False;0;0,0,0,0;3,1.055172,0,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;24;827.58,-76.68867;Float;True;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;900.1552,722.2936;Float;False;Property;_AlphaCutout;Alpha Cutout;5;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;883.6312,230.5943;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;2,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;954.3806,410.8543;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;1829.74,507.9384;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;17;1176.18,598.3246;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;1136.654,100.1765;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;1423.124,215.2216;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;46;1999.798,504.0931;Float;True;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;31;2428.913,449.6749;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;48;2366.984,308.9947;Float;False;46;Emission;0;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;2729.717,564.8653;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;2650.292,705.7781;Float;False;44;OpacityMask;0;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;44;1640.836,209.5859;Float;False;OpacityMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;43;2931.255,432.2474;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;QFX/SFX/Cutout/NoiseCutOut;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;TransparentCutout;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;20;0;19;0
WireConnection;8;0;11;0
WireConnection;21;0;20;0
WireConnection;5;0;8;0
WireConnection;5;2;12;0
WireConnection;22;0;20;0
WireConnection;22;1;21;0
WireConnection;23;0;22;0
WireConnection;7;1;5;0
WireConnection;24;0;23;0
WireConnection;24;1;25;0
WireConnection;26;0;7;0
WireConnection;15;0;7;1
WireConnection;15;1;16;0
WireConnection;30;0;7;0
WireConnection;30;1;29;0
WireConnection;17;0;15;0
WireConnection;17;1;14;0
WireConnection;27;0;24;0
WireConnection;27;1;26;0
WireConnection;28;0;27;0
WireConnection;28;1;17;0
WireConnection;46;0;30;0
WireConnection;50;0;48;0
WireConnection;50;1;31;4
WireConnection;44;0;28;0
WireConnection;43;2;50;0
WireConnection;43;9;31;4
WireConnection;43;10;45;0
ASEEND*/
//CHKSM=F5BACFE3E4CAF0EC2CBCDA4845CA41C1E808B6EB