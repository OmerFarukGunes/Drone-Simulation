// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/SFX/LaserWall"
{
	Properties
	{
		_GridTexture("Grid Texture", 2D) = "white" {}
		_GridOffsetX("Grid Offset X", Float) = 0
		_GridOffsetY("Grid Offset Y", Float) = 0
		_GridTilling("Grid Tilling", Float) = 0.2
		_GridTexturePow("Grid Texture Pow", Float) = 0
		_NoiseMap("Noise Map", 2D) = "white" {}
		_DistortionMap("Distortion Map", 2D) = "white" {}
		_NoiseDistortionTilling("Noise Distortion Tilling", Range( 0 , 2)) = 0.1793017
		_NoiseDistortionSpeed("Noise Distortion Speed", Vector) = (0,0.2,0,0)
		_NoiseTilling("Noise Tilling", Range( 0 , 2)) = 0.5832521
		_NoisePower("Noise Power", Range( 0 , 2)) = 0.9750929
		_SmokeSpeed2("Smoke Speed 2", Vector) = (-0.2,0.2,0,0)
		_SmokeSpeed1("Smoke Speed 1", Vector) = (0.2,0.2,0,0)
		_SmokeTexture("Smoke Texture", 2D) = "white" {}
		_SmokeTexturePower("Smoke Texture Power", Range( 0 , 10)) = 0
		_OpacityPower("Opacity Power", Range( 0 , 1)) = 0
		[HDR]_DepthColor("Depth Color", Color) = (1,1,1,1)
		_DepthDistance("Depth Distance", Float) = 0
		_DepthFadeExp("Depth Fade Exp", Range( 0.2 , 10)) = 5.316663
		[HDR]_TintColor("Tint Color", Color) = (1,1,1,1)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		GrabPass{ }
		CGPROGRAM
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha noshadow 
		struct Input
		{
			float4 screenPos;
			float3 worldNormal;
			float3 worldPos;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _CameraDepthTexture;
		uniform float _DepthDistance;
		uniform float _DepthFadeExp;
		uniform float4 _DepthColor;
		uniform sampler2D _GridTexture;
		uniform float _GridTilling;
		uniform float _GridOffsetX;
		uniform float _GridOffsetY;
		uniform float _GridTexturePow;
		uniform float4 _TintColor;
		uniform sampler2D _SmokeTexture;
		uniform float2 _SmokeSpeed1;
		uniform float _SmokeTexturePower;
		uniform float2 _SmokeSpeed2;
		uniform sampler2D _GrabTexture;
		uniform sampler2D _NoiseMap;
		uniform sampler2D _DistortionMap;
		uniform float2 _NoiseDistortionSpeed;
		uniform float _NoiseDistortionTilling;
		uniform float _NoiseTilling;
		uniform float _NoisePower;
		uniform float _OpacityPower;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth2_g34 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD( ase_screenPos ))));
			float distanceDepth2_g34 = abs( ( screenDepth2_g34 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthDistance ) );
			float3 ase_worldNormal = i.worldNormal;
			float3 temp_output_22_0_g31 = abs( ase_worldNormal );
			float3 ase_worldPos = i.worldPos;
			float2 appendResult8_g31 = (float2(ase_worldPos.y , ase_worldPos.z));
			float2 appendResult4_g31 = (float2(_GridTilling , _GridTilling));
			float2 appendResult9_g31 = (float2(_GridOffsetX , _GridOffsetY));
			float4 temp_cast_0 = (_GridTexturePow).xxxx;
			float2 appendResult7_g31 = (float2(ase_worldPos.z , ase_worldPos.x));
			float4 temp_cast_1 = (_GridTexturePow).xxxx;
			float2 appendResult6_g31 = (float2(ase_worldPos.x , ase_worldPos.y));
			float4 temp_cast_2 = (_GridTexturePow).xxxx;
			float3 weightedBlendVar27_g31 = ( temp_output_22_0_g31 * temp_output_22_0_g31 );
			float4 weightedAvg27_g31 = ( ( weightedBlendVar27_g31.x*pow( tex2D( _GridTexture, ( ( appendResult8_g31 * appendResult4_g31 ) + appendResult9_g31 ) ) , temp_cast_0 ) + weightedBlendVar27_g31.y*pow( tex2D( _GridTexture, ( ( appendResult7_g31 * appendResult4_g31 ) + appendResult9_g31 ) ) , temp_cast_1 ) + weightedBlendVar27_g31.z*pow( tex2D( _GridTexture, ( ( appendResult6_g31 * appendResult4_g31 ) + appendResult9_g31 ) ) , temp_cast_2 ) )/( weightedBlendVar27_g31.x + weightedBlendVar27_g31.y + weightedBlendVar27_g31.z ) );
			float2 panner127 = ( _Time.y * _SmokeSpeed1 + i.uv_texcoord);
			float2 panner128 = ( _Time.y * _SmokeSpeed2 + i.uv_texcoord);
			float4 temp_output_151_0 = ( weightedAvg27_g31 * _TintColor * ( pow( tex2D( _SmokeTexture, panner127 ).r , _SmokeTexturePower ) + pow( tex2D( _SmokeTexture, panner128 ).r , _SmokeTexturePower ) ) );
			float2 panner21_g33 = ( 1.0 * _Time.y * _NoiseDistortionSpeed + i.uv_texcoord);
			float2 temp_cast_3 = (_NoiseTilling).xx;
			float2 uv_TexCoord45_g33 = i.uv_texcoord * temp_cast_3;
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor19 = tex2D( _GrabTexture, ( ( tex2D( _NoiseMap, ( tex2D( _DistortionMap, (panner21_g33*_NoiseDistortionTilling + 0.0) ) + float4( uv_TexCoord45_g33, 0.0 , 0.0 ) ).rg ) * _NoisePower ) + ase_grabScreenPosNorm ).rg );
			o.Emission = ( ( pow( saturate( ( 1.0 - distanceDepth2_g34 ) ) , _DepthFadeExp ) * _DepthColor ) + temp_output_151_0 + screenColor19 ).rgb;
			o.Alpha = saturate( ( _OpacityPower * i.vertexColor.a * (temp_output_151_0).a ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15600
7;29;1906;1014;6164.014;2156.009;5.668895;True;False
Node;AmplifyShaderEditor.CommentaryNode;144;-2115.408,1373.838;Float;False;1702.875;945.8268;;14;136;135;133;134;132;131;130;139;138;126;123;128;127;125;Smoke;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;139;-1951.88,2128.846;Float;False;Property;_SmokeSpeed2;Smoke Speed 2;13;0;Create;True;0;0;False;0;-0.2,0.2;-0.2,0.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;125;-1983.673,1508.752;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;138;-1934.936,1625.15;Float;False;Property;_SmokeSpeed1;Smoke Speed 1;14;0;Create;True;0;0;False;0;0.2,0.2;0.2,0.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;126;-1994.246,2007.596;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;123;-2006.337,1840.62;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;130;-1629.099,1753.066;Float;True;Property;_SmokeTexture;Smoke Texture;15;0;Create;True;0;0;False;0;None;357928dd8c8088440b4662373bd09d7a;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.PannerNode;127;-1534.773,1503.346;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;128;-1526.213,2007.155;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;134;-1319.672,1765.904;Float;False;Property;_SmokeTexturePower;Smoke Texture Power;16;0;Create;True;0;0;False;0;0;2;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;132;-1287.961,1975.918;Float;True;Property;_TextureSample2;Texture Sample 2;14;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;131;-1262.197,1471.78;Float;True;Property;_TextureSample1;Texture Sample 1;13;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;133;-942.934,1499.953;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;135;-932.6456,2001.51;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;6;-615.688,1170.619;Float;False;Property;_TintColor;Tint Color;22;1;[HDR];Create;True;0;0;False;0;1,1,1,1;0,1.186207,4,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;116;-682.6196,961.4693;Float;True;Get Weight Blended Texture;0;;31;71af75d3d7ad4f045be3dfc5ea711f13;0;0;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;145;-366.2074,1806.685;Float;False;766.7092;506.1884;;4;21;19;20;18;Grab Screen;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;136;-740.3082,1931.634;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;-131.179,1307.222;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GrabScreenPosition;20;-289.5232,2098.7;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;18;-284.3794,1923.825;Float;False;Get Simple Noise;6;;33;dba3a45ee088a1c42ae7fbf09d132e5e;0;0;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;147;468.9977,1880.743;Float;False;558.5957;391.9832;;3;74;140;28;Opacity;1,1,1,1;0;0
Node;AmplifyShaderEditor.ComponentMaskNode;142;405.2878,1637.568;Float;False;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-32.1622,1993.664;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;140;597.8378,2018.159;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;28;506.2372,1945.353;Float;False;Property;_OpacityPower;Opacity Power;17;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;36;50.69508,1026.127;Float;False;Get Depth Fade Color;18;;34;178c752a5f1ef2644a24cb6a097a6938;0;0;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;19;125.0056,1988.248;Float;False;Global;_GrabScreen0;Grab Screen 0;4;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;842.2375,1977.353;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;181;1169.921,1560.456;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;156;369.7361,1280.87;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;2;1423.905,1226.509;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;QFX/SFX/LaserWall;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;127;0;125;0
WireConnection;127;2;138;0
WireConnection;127;1;123;2
WireConnection;128;0;126;0
WireConnection;128;2;139;0
WireConnection;128;1;123;2
WireConnection;132;0;130;0
WireConnection;132;1;128;0
WireConnection;131;0;130;0
WireConnection;131;1;127;0
WireConnection;133;0;131;1
WireConnection;133;1;134;0
WireConnection;135;0;132;1
WireConnection;135;1;134;0
WireConnection;136;0;133;0
WireConnection;136;1;135;0
WireConnection;151;0;116;0
WireConnection;151;1;6;0
WireConnection;151;2;136;0
WireConnection;142;0;151;0
WireConnection;21;0;18;0
WireConnection;21;1;20;0
WireConnection;19;0;21;0
WireConnection;74;0;28;0
WireConnection;74;1;140;4
WireConnection;74;2;142;0
WireConnection;181;0;74;0
WireConnection;156;0;36;0
WireConnection;156;1;151;0
WireConnection;156;2;19;0
WireConnection;2;2;156;0
WireConnection;2;9;181;0
ASEEND*/
//CHKSM=3AC48C02EB924C251517F26CBF77A4C602509C39