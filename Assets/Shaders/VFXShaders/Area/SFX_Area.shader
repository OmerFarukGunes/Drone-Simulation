// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/SFX/Area/Area"
{
	Properties
	{
		[HDR]_EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HDR]_DepthColor("Depth Color", Color) = (1,1,1,1)
		_DepthDistance("Depth Distance", Float) = 0
		_DepthFadeExp("Depth Fade Exp", Range( 0.2 , 10)) = 5.316663
		_NoiseMap("Noise Map", 2D) = "white" {}
		_NoiseTilling("Noise Tilling", Float) = 0.5
		_NoisePower("Noise Power", Float) = 0.82
		_NoiseDistortionMap("Noise Distortion Map", 2D) = "white" {}
		_NoiseDistortionTilling("Noise Distortion Tilling", Float) = 0.5
		_NoiseDistortionPower("Noise Distortion Power", Float) = 0
		_Vector0("Noise Scroll", Vector) = (0,0,0,0)
		_DistortionPower("Distortion Power", Range( 0 , 5)) = 0
		_FresnelScale("Fresnel Scale", Range( 0 , 1)) = 0.510905
		_FresnelPower("Fresnel Power", Range( 0 , 5)) = 2
		[Toggle]_MaskAppearInvert("Mask Appear Invert", Float) = 0
		[KeywordEnum(None,X,Y,Z)] _MaskAppearAxis("Mask Appear Axis", Float) = 2
		_MaskAppearProgress("Mask Appear Progress", Float) = -0.03
		_MaskAppearStrength("Mask Appear Strength", Range( 0 , 1)) = 0.5
		[HideInInspector] _tex4coord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma shader_feature _MASKAPPEARAXIS_NONE _MASKAPPEARAXIS_X _MASKAPPEARAXIS_Y _MASKAPPEARAXIS_Z
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
			float4 screenPos;
			float4 uv_tex4coord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _GrabTexture;
		uniform sampler2D _NoiseMap;
		uniform float _NoiseTilling;
		uniform float2 _Vector0;
		uniform sampler2D _NoiseDistortionMap;
		uniform float _NoiseDistortionTilling;
		uniform float _NoiseDistortionPower;
		uniform float _NoisePower;
		uniform float _DistortionPower;
		uniform sampler2D _CameraDepthTexture;
		uniform float _DepthDistance;
		uniform float _DepthFadeExp;
		uniform float4 _DepthColor;
		uniform float4 _EmissionColor;
		uniform float _FresnelScale;
		uniform float _FresnelPower;
		uniform float _MaskAppearStrength;
		uniform float _MaskAppearInvert;
		uniform float _MaskAppearProgress;


		inline float4 TriplanarSamplingSF( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float tilling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= projNormal.x + projNormal.y + projNormal.z;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = ( tex2D( topTexMap, tilling * worldPos.zy * float2( nsign.x, 1.0 ) ) );
			yNorm = ( tex2D( topTexMap, tilling * worldPos.xz * float2( nsign.y, 1.0 ) ) );
			zNorm = ( tex2D( topTexMap, tilling * worldPos.xy * float2( -nsign.z, 1.0 ) ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


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
			o.Normal = float3(0,0,1);
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 temp_output_16_0_g13 = abs( ase_worldNormal );
			float3 ase_worldPos = i.worldPos;
			float4 triplanar4_g13 = TriplanarSamplingSF( _NoiseDistortionMap, ase_worldPos, ase_worldNormal, 1.0, _NoiseDistortionTilling, 1.0, 0 );
			float4 break14_g13 = ( float4( ( ase_worldPos * _NoiseTilling ) , 0.0 ) + float4( ( _Time.y * _Vector0 ), 0.0 , 0.0 ) + ( triplanar4_g13 * _NoiseDistortionPower ) );
			float2 appendResult19_g13 = (float2(break14_g13.x , break14_g13.y));
			float2 appendResult15_g13 = (float2(break14_g13.x , break14_g13.z));
			float2 appendResult18_g13 = (float2(break14_g13.y , break14_g13.z));
			float3 weightedBlendVar25_g13 = ( temp_output_16_0_g13 * temp_output_16_0_g13 );
			float weightedBlend25_g13 = ( weightedBlendVar25_g13.x*tex2D( _NoiseMap, appendResult19_g13 ).r + weightedBlendVar25_g13.y*tex2D( _NoiseMap, appendResult15_g13 ).r + weightedBlendVar25_g13.z*tex2D( _NoiseMap, appendResult18_g13 ).r );
			float temp_output_42_0 = ( weightedBlend25_g13 * _NoisePower );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor26 = tex2D( _GrabTexture, ( temp_output_42_0 + ase_grabScreenPosNorm ).xy );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth2_g22 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD( ase_screenPos ))));
			float distanceDepth2_g22 = abs( ( screenDepth2_g22 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthDistance ) );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float fresnelNdotV1_g14 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode1_g14 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV1_g14, _FresnelPower ) );
			float temp_output_21_0 = saturate( fresnelNode1_g14 );
			float4 temp_output_6_0 = ( ( pow( saturate( ( 1.0 - distanceDepth2_g22 ) ) , _DepthFadeExp ) * _DepthColor ) + ( _EmissionColor * temp_output_21_0 ) );
			o.Emission = ( ( screenColor26 * _DistortionPower ) + temp_output_6_0 ).rgb;
			float4 transform24_g21 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );
			float4 temp_output_7_0_g21 = ( ( lerp(( transform24_g21 - float4( ase_worldPos , 0.0 ) ),( float4( ase_worldPos , 0.0 ) - transform24_g21 ),_MaskAppearInvert) / float4( ase_objectScale , 0.0 ) ) + ( _MaskAppearProgress + i.uv_tex4coord.z ) );
			float4 break5_g21 = temp_output_7_0_g21;
			float4 temp_cast_7 = (break5_g21.y).xxxx;
			float4 temp_cast_11 = (break5_g21.x).xxxx;
			float4 temp_cast_12 = (break5_g21.y).xxxx;
			float4 temp_cast_13 = (break5_g21.z).xxxx;
			#if defined(_MASKAPPEARAXIS_NONE)
				float4 staticSwitch6_g21 = temp_output_7_0_g21;
			#elif defined(_MASKAPPEARAXIS_X)
				float4 staticSwitch6_g21 = temp_cast_11;
			#elif defined(_MASKAPPEARAXIS_Y)
				float4 staticSwitch6_g21 = temp_cast_7;
			#elif defined(_MASKAPPEARAXIS_Z)
				float4 staticSwitch6_g21 = temp_cast_13;
			#else
				float4 staticSwitch6_g21 = temp_cast_7;
			#endif
			float4 temp_cast_14 = (temp_output_42_0).xxxx;
			float smoothstepResult31_g21 = smoothstep( 0.0 , _MaskAppearStrength , ( staticSwitch6_g21 - temp_cast_14 ).x);
			o.Alpha = saturate( ( temp_output_21_0 * smoothstepResult31_g21 * i.vertexColor.a ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15600
60;393;1412;619;2865.119;972.5543;3.893793;False;False
Node;AmplifyShaderEditor.GrabScreenPosition;27;-1113.76,-669.5969;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;42;-1139.953,-869.3925;Float;True;QFX Get Triplanar Noise;5;;13;2856b8dea5889c54bb4a7a850b80ebcc;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-793.1672,-800.6676;Float;True;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;46;-956.9733,173.0542;Float;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;2;-815.8408,-359.8301;Float;False;Property;_EmissionColor;Emission Color;0;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1.5,0.4411764,0.4411764,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;21;-924.7402,-36.23016;Float;False;QFX Get Fresnel;14;;14;0a832704e6daa5244b3db55d16dfb317;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;51;-438.565,-73.63747;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-544.8407,-164.8301;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;26;-580.619,-807.7528;Float;False;Global;_GrabScreen0;Grab Screen 0;5;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;22;-774.9664,-467.3312;Float;False;QFX Get Depth Fade Color;1;;22;178c752a5f1ef2644a24cb6a097a6938;0;0;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-581.8815,-569.6052;Float;False;Property;_DistortionPower;Distortion Power;13;0;Create;True;0;0;False;0;0;2;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;52;-670.4499,604.9056;Float;True;QFX Get Mask Appear;17;;21;6c0a21bbc2173ee4f98c4fde6531d5a9;0;2;14;FLOAT;0;False;32;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-258.8727,-617.8468;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-163.285,44.00129;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;6;-372.488,-199.9545;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-16.89883,-213.3934;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;14;-16.08469,42.40134;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-224.0957,-198.3116;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;223,-238;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;QFX/SFX/Area/Area;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;28;0;42;0
WireConnection;28;1;27;0
WireConnection;3;0;2;0
WireConnection;3;1;21;0
WireConnection;26;0;28;0
WireConnection;52;14;46;3
WireConnection;52;32;42;0
WireConnection;41;0;26;0
WireConnection;41;1;40;0
WireConnection;13;0;21;0
WireConnection;13;1;52;0
WireConnection;13;2;51;4
WireConnection;6;0;22;0
WireConnection;6;1;3;0
WireConnection;29;0;41;0
WireConnection;29;1;6;0
WireConnection;14;0;13;0
WireConnection;50;0;6;0
WireConnection;50;1;51;4
WireConnection;0;2;29;0
WireConnection;0;9;14;0
ASEEND*/
//CHKSM=23780D2C067EC342F43FC6DEA5A5819F6724B31B