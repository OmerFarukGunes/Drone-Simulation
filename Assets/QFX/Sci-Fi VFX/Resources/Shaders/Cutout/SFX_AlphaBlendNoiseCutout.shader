// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/SFX/Cutout/AlphaBlendNoiseCutout"
{
	Properties
	{
		[HDR]_Color("Color", Color) = (0,0,0,0)
		_Noise("Noise", 2D) = "white" {}
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Speed("Speed", Vector) = (0,0,0,0)
		_AlphaCutout("Alpha Cutout", Float) = 0
		_MainTex("Main Tex", 2D) = "white" {}
		[HideInInspector] _tex4coord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float2 uv2_texcoord2;
			float4 uv2_tex4coord2;
		};

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _Color;
		uniform sampler2D _Noise;
		uniform float2 _Speed;
		uniform float4 _Noise_ST;
		uniform float _AlphaCutout;
		uniform float _Cutoff = 0.5;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode31 = tex2D( _MainTex, uv_MainTex );
			float4 Emission22 = ( tex2DNode31 * _Color );
			o.Emission = Emission22.rgb;
			o.Alpha = ( (Emission22).a * i.vertexColor.a );
			float2 uv_Noise = i.uv2_texcoord2 * _Noise_ST.xy + _Noise_ST.zw;
			float2 panner7 = ( 1.0 * _Time.y * _Speed + uv_Noise);
			float4 temp_cast_1 = (( tex2D( _Noise, panner7 ).r - ( _AlphaCutout + i.uv2_tex4coord2.z ) )).xxxx;
			float4 OpacityMask27 = ( ( tex2DNode31 - temp_cast_1 ) * tex2DNode31.a );
			clip( OpacityMask27.r - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15600
44;808;1412;619;2115.071;-281.3644;1.3;False;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-2476.597,231.8251;Float;False;1;12;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;5;-2683.425,398.5568;Float;False;Property;_Speed;Speed;4;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;46;-2168.263,604.424;Float;False;1;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;38;-2039.177,755.5758;Float;False;0;31;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-2131.361,446.671;Float;False;Property;_AlphaCutout;Alpha Cutout;5;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;7;-2203.655,236.9583;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;13;-1696.858,1216.01;Float;False;Property;_Color;Color;0;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0,2.103449,5.000003,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;31;-1761.515,735.7971;Float;True;Property;_MainTex;Main Tex;6;0;Create;True;0;0;False;0;None;c1ab7177ccc336d459e7b3de8e7d93da;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-1909.474,451.6151;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;12;-1991.62,208.5308;Float;True;Property;_Noise;Noise;1;0;Create;True;0;0;False;0;None;d784595d7b8bfef41ac0a5bd8fa0a662;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1360.132,979.8726;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;19;-1580.039,233.2182;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-1157.258,973.0485;Float;True;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;40;-1320.077,343.9556;Float;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;48;-623.2192,712.2346;Float;False;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;23;-446.497,821.5546;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-1095.804,385.2491;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;2;-2684.975,254.3564;Float;False;Property;_Tiling;Tiling;3;0;Create;True;0;0;False;0;1,1;0.2,0.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;26;-116.2747,981.6128;Float;True;27;OpacityMask;0;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;-901.5879,337.9695;Float;True;OpacityMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;30;-5.076064,512.0312;Float;False;22;Emission;0;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-217.544,657.3463;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;51;264.4662,509.7705;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;QFX/SFX/Cutout/AlphaBlendNoiseCutout;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;TransparentCutout;Transparent;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;2;0
WireConnection;7;0;4;0
WireConnection;7;2;5;0
WireConnection;31;1;38;0
WireConnection;43;0;15;0
WireConnection;43;1;46;3
WireConnection;12;1;7;0
WireConnection;18;0;31;0
WireConnection;18;1;13;0
WireConnection;19;0;12;1
WireConnection;19;1;43;0
WireConnection;22;0;18;0
WireConnection;40;0;31;0
WireConnection;40;1;19;0
WireConnection;48;0;22;0
WireConnection;53;0;40;0
WireConnection;53;1;31;4
WireConnection;27;0;53;0
WireConnection;25;0;48;0
WireConnection;25;1;23;4
WireConnection;51;2;30;0
WireConnection;51;9;25;0
WireConnection;51;10;26;0
ASEEND*/
//CHKSM=B407693C523B7F8F7B7445812DBF66C0B5CC40B7