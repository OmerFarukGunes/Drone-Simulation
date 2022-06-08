// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/SFX/Beam/Energy Beam"
{
	Properties
	{
		[HDR]_TintColor("Tint Color", Color) = (0,0,0,0)
		_MainTex("Main Tex", 2D) = "white" {}
		_MainSpeed("Main Speed", Vector) = (0,0,0,0)
		_MaskTex("Mask Tex", 2D) = "white" {}
		_NoiseMap("Noise Map", 2D) = "white" {}
		_DistortionMap("Distortion Map", 2D) = "white" {}
		_NoiseDistortionPower("Noise Distortion Power", Range( 0 , 2)) = 0.2179676
		_NoiseDistortionTilling("Noise Distortion Tilling", Range( 0 , 10)) = 1.142912
		_NoiseDistortionSpeed("Noise Distortion Speed", Vector) = (0,0.2,0,0)
		_NoisePower("Noise Power", Range( 0 , 2)) = 1.098096
		_NoiseOffset("Noise Offset", Range( 0 , 1)) = 0
		_NoiseTilling("Noise Tilling", Range( 0 , 10)) = 0.894883
		_NoiseSpeed("Noise Speed", Vector) = (0.2,0,0,0)
		_Float0("Float 0", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform float4 _TintColor;
		uniform sampler2D _MainTex;
		uniform float2 _MainSpeed;
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
		uniform float _Float0;
		uniform sampler2D _GrabTexture;
		uniform sampler2D _MaskTex;
		uniform float4 _MaskTex_ST;


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


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 panner105 = ( 1.0 * _Time.y * _MainSpeed + uv_MainTex);
			float2 panner21_g1 = ( 1.0 * _Time.y * _NoiseDistortionSpeed + i.uv_texcoord);
			float temp_output_72_0_g1 = ( tex2D( _DistortionMap, (panner21_g1*_NoiseDistortionTilling + 0.0) ).r * _NoiseDistortionPower );
			float2 panner71_g1 = ( 1.0 * _Time.y * _NoiseSpeed + i.uv_texcoord);
			float4 temp_cast_0 = (_Float0).xxxx;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor76 = tex2D( _GrabTexture, ( temp_output_72_0_g1 + ase_grabScreenPosNorm ).xy );
			o.Emission = ( ( _TintColor * pow( tex2D( _MainTex, ( panner105 + ( ( tex2D( _NoiseMap, ( temp_output_72_0_g1 + (panner71_g1*_NoiseTilling + 0.0) ) ).r * _NoisePower ) - _NoiseOffset ) ) ) , temp_cast_0 ) ) + screenColor76 ).rgb;
			float2 uv_MaskTex = i.uv_texcoord * _MaskTex_ST.xy + _MaskTex_ST.zw;
			o.Alpha = tex2D( _MaskTex, uv_MaskTex ).r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15600
0;92;728;936;2009.469;711.2624;2.032578;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;107;-1847.245,-56.32587;Float;False;0;99;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;106;-1797.096,102.4773;Float;False;Property;_MainSpeed;Main Speed;2;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FunctionNode;95;-1710.829,445.9177;Float;False;QFX Get Simple Noise;4;;1;dba3a45ee088a1c42ae7fbf09d132e5e;0;0;4;COLOR;81;COLOR;82;FLOAT;64;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;105;-1617.397,83.67168;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;108;-1434.041,161.797;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;99;-1236.426,93.91677;Float;True;Property;_MainTex;Main Tex;1;0;Create;True;0;0;False;0;None;c08287335df0f1b43820e27dee902611;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;114;-1151.721,361.9389;Float;False;Property;_Float0;Float 0;14;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;72;-1700.612,655.0095;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;113;-877.3223,221.691;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;75;-1439.469,601.6884;Float;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;8;-1203.964,-95.81254;Float;False;Property;_TintColor;Tint Color;0;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.07352943,3.165318,5.000004,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-646.4753,-1.388951;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;76;-1283.188,597.2316;Float;False;Global;_GrabScreen1;Grab Screen 1;0;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;82;-458.9728,267.5496;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;38;-742.8735,871.8792;Float;True;Property;_MaskTex;Mask Tex;3;0;Create;True;0;0;False;0;None;fc236386a4905e341ac33b46758022ad;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-133.0471,120.6462;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;QFX/SFX/Beam/Energy Beam;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;105;0;107;0
WireConnection;105;2;106;0
WireConnection;108;0;105;0
WireConnection;108;1;95;0
WireConnection;99;1;108;0
WireConnection;113;0;99;0
WireConnection;113;1;114;0
WireConnection;75;0;95;64
WireConnection;75;1;72;0
WireConnection;58;0;8;0
WireConnection;58;1;113;0
WireConnection;76;0;75;0
WireConnection;82;0;58;0
WireConnection;82;1;76;0
WireConnection;0;2;82;0
WireConnection;0;9;38;0
ASEEND*/
//CHKSM=5D1A60446A37F0BF548D047F6CAABA1C3C0E52B4