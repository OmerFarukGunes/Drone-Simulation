// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/SFX/Shield/EnergyShield"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[HDR]_TintColor("Tint Color", Color) = (0,0,0,0)
		[Toggle]_MaskAppearInvert("Mask Appear Invert", Float) = 0
		[KeywordEnum(None,X,Y,Z)] _MaskAppearAxis("Mask Appear Axis", Float) = 2
		_MaskAppearProgress("Mask Appear Progress", Float) = -0.03
		_MaskAppearStrength("Mask Appear Strength", Range( 0 , 1)) = 0.5
		[HDR]_DisotrionColor("Disotrion Color", Color) = (0,0,0,0)
		_DissolveAmount("Dissolve Amount", Range( 0 , 1)) = 0
		[HideInInspector]_ObjectWorldPosition("Object World Position", Vector) = (0,0,0,0)
		_NoiseMap("Noise Map", 2D) = "white" {}
		_DistortionMap("Distortion Map", 2D) = "white" {}
		_NoiseDistortionPower("Noise Distortion Power", Range( 0 , 2)) = 0.2179676
		_NoiseDistortionTilling("Noise Distortion Tilling", Range( 0 , 10)) = 1.142912
		_NoiseDistortionSpeed("Noise Distortion Speed", Vector) = (0,0.2,0,0)
		_NoisePower("Noise Power", Range( 0 , 2)) = 2
		_NoiseOffset("Noise Offset", Range( 0 , 1)) = 0
		_NoiseTilling("Noise Tilling", Range( 0 , 10)) = 0.894883
		_NoiseSpeed("Noise Speed", Vector) = (0.2,0,0,0)
		[HDR]_DepthColor("Depth Color", Color) = (1,1,1,1)
		_DepthDistance("Depth Distance", Float) = 0
		_DepthFadeExp("Depth Fade Exp", Range( 0.2 , 10)) = 5.316663
		_FresnelScale("Fresnel Scale", Range( 0 , 1)) = 0.510905
		_FresnelPower("Fresnel Power", Range( 0 , 5)) = 2
		_HitTexture("Hit Texture", 2D) = "white" {}
		_HitWaveRampMap("Hit Wave Ramp Map", 2D) = "white" {}
		[HDR]_HitColor("Hit Color", Color) = (0,0,0,0)
		_HitWaveMaxRadius("Hit Wave Max Radius", Float) = 0
		_HitWaveFade("Hit Wave Fade", Range( 0.05 , 1)) = 0.05
		_VertexOffsetAmount("Vertex Offset Amount", Float) = 0
		[HideInInspector] _tex4coord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		GrabPass{ }
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.5
		#pragma shader_feature _MASKAPPEARAXIS_NONE _MASKAPPEARAXIS_X _MASKAPPEARAXIS_Y _MASKAPPEARAXIS_Z
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float3 worldPos;
			float4 uv_tex4coord;
			float2 uv_texcoord;
			float4 screenPos;
			float3 worldNormal;
			INTERNAL_DATA
			half ASEVFace : VFACE;
			float4 vertexColor : COLOR;
		};

		uniform float _VertexOffsetAmount;
		uniform float _MaskAppearStrength;
		uniform float _MaskAppearInvert;
		uniform float3 _ObjectWorldPosition;
		uniform float _MaskAppearProgress;
		uniform sampler2D _DistortionMap;
		uniform float2 _NoiseDistortionSpeed;
		uniform float _NoiseDistortionTilling;
		uniform float _NoiseDistortionPower;
		uniform float _DissolveAmount;
		uniform float4 _HitColor;
		uniform float _HitWaveMaxRadius;
		uniform float _HitWaveFade;
		uniform float4 _HitPositions[(int)10.0];
		uniform float _HitRadii[(int)10.0];
		uniform sampler2D _HitWaveRampMap;
		uniform sampler2D _HitTexture;
		uniform float4 _HitTexture_ST;
		uniform float4 _DistortionMap_ST;
		uniform sampler2D _CameraDepthTexture;
		uniform float _DepthDistance;
		uniform float _DepthFadeExp;
		uniform float4 _DepthColor;
		uniform float4 _DisotrionColor;
		uniform sampler2D _GrabTexture;
		uniform sampler2D _NoiseMap;
		uniform float2 _NoiseSpeed;
		uniform float _NoiseTilling;
		uniform float _NoisePower;
		uniform float _NoiseOffset;
		uniform float4 _TintColor;
		uniform float _FresnelScale;
		uniform float _FresnelPower;
		uniform float _Cutoff = 0.5;


		float GetHits300( float3 WorldPosition , int HitMaxCount , float HitWaveMaxRadius , float HitWaveFade , float4 HitPositions , float4 HitRadii , sampler2D HitWaveRampMap , float HitTextureR , float2 DistortionRG )
		{
			float hit_intencity = 0;
			for (int i = 0; i < HitMaxCount; i++)
			            {
			                float hit_distance = ( distance( _HitPositions[i], WorldPosition ) / HitWaveMaxRadius );
			                float hit_fade = smoothstep( 0.0 , HitWaveFade , ( 1.0 - ( hit_distance - (-1.0 + (_HitRadii[i] - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) ) ));
			                float4 ramp_map = tex2D( HitWaveRampMap, float2(hit_fade, 0) );
			                float wave = ( ramp_map.r - ( ramp_map.r * tex2D( HitWaveRampMap, ( hit_fade - DistortionRG ).rg ).r ) );
			                float intencity = ( saturate( ( 1.0 - hit_distance ) ) * saturate(wave - HitTextureR ) );		
			                hit_intencity += intencity;
			            }
			            hit_intencity = saturate(hit_intencity);
			return hit_intencity;
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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( _VertexOffsetAmount * ase_vertexNormal );
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 temp_cast_0 = (_MaskAppearStrength).xxx;
			float3 temp_output_33_0_g96 = _ObjectWorldPosition;
			float3 ase_worldPos = i.worldPos;
			float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );
			float3 temp_output_7_0_g96 = ( ( lerp(( temp_output_33_0_g96 - ase_worldPos ),( ase_worldPos - temp_output_33_0_g96 ),_MaskAppearInvert) / ase_objectScale ) + ( _MaskAppearProgress + i.uv_tex4coord.z ) );
			float3 break5_g96 = temp_output_7_0_g96;
			float3 temp_cast_1 = (break5_g96.y).xxx;
			float3 temp_cast_2 = (break5_g96.x).xxx;
			float3 temp_cast_3 = (break5_g96.y).xxx;
			float3 temp_cast_4 = (break5_g96.z).xxx;
			#if defined(_MASKAPPEARAXIS_NONE)
				float3 staticSwitch6_g96 = temp_output_7_0_g96;
			#elif defined(_MASKAPPEARAXIS_X)
				float3 staticSwitch6_g96 = temp_cast_2;
			#elif defined(_MASKAPPEARAXIS_Y)
				float3 staticSwitch6_g96 = temp_cast_1;
			#elif defined(_MASKAPPEARAXIS_Z)
				float3 staticSwitch6_g96 = temp_cast_4;
			#else
				float3 staticSwitch6_g96 = temp_cast_1;
			#endif
			float2 panner21_g7 = ( 1.0 * _Time.y * _NoiseDistortionSpeed + i.uv_texcoord);
			float temp_output_72_0_g7 = ( tex2D( _DistortionMap, (panner21_g7*_NoiseDistortionTilling + 0.0) ).r * _NoiseDistortionPower );
			float3 temp_cast_5 = (temp_output_72_0_g7).xxx;
			float3 smoothstepResult31_g96 = smoothstep( float3( 0,0,0 ) , temp_cast_0 , ( staticSwitch6_g96 - temp_cast_5 ));
			float3 temp_output_367_0 = smoothstepResult31_g96;
			float4 temp_cast_7 = (_DissolveAmount).xxxx;
			float3 WorldPosition300 = ase_worldPos;
			int HitMaxCount300 = (int)10.0;
			float HitWaveMaxRadius300 = _HitWaveMaxRadius;
			float HitWaveFade300 = _HitWaveFade;
			float4 HitPositions300 = _HitPositions[0];
			float4 temp_cast_11 = (_HitRadii[0]).xxxx;
			float4 HitRadii300 = temp_cast_11;
			sampler2D HitWaveRampMap300 = _HitWaveRampMap;
			float2 uv_HitTexture = i.uv_texcoord * _HitTexture_ST.xy + _HitTexture_ST.zw;
			float HitTextureR300 = tex2D( _HitTexture, uv_HitTexture ).r;
			float2 uv_DistortionMap = i.uv_texcoord * _DistortionMap_ST.xy + _DistortionMap_ST.zw;
			float2 DistortionRG300 = tex2D( _DistortionMap, uv_DistortionMap ).rg;
			float localGetHits300 = GetHits300( WorldPosition300 , HitMaxCount300 , HitWaveMaxRadius300 , HitWaveFade300 , HitPositions300 , HitRadii300 , HitWaveRampMap300 , HitTextureR300 , DistortionRG300 );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth2_g57 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD( ase_screenPos ))));
			float distanceDepth2_g57 = abs( ( screenDepth2_g57 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthDistance ) );
			float2 panner71_g7 = ( 1.0 * _Time.y * _NoiseSpeed + i.uv_texcoord);
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor54 = tex2D( _GrabTexture, ( ( ( tex2D( _NoiseMap, ( temp_output_72_0_g7 + (panner71_g7*_NoiseTilling + 0.0) ) ).r * _NoisePower ) - _NoiseOffset ) + ase_grabScreenPosNorm ).xy );
			float4 temp_output_48_0 = ( ( pow( saturate( ( 1.0 - distanceDepth2_g57 ) ) , _DepthFadeExp ) * _DepthColor ) + ( _DisotrionColor * screenColor54 ) );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV1_g58 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode1_g58 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV1_g58, _FresnelPower ) );
			float temp_output_40_0 = saturate( fresnelNode1_g58 );
			float4 lerpResult218 = lerp( temp_output_48_0 , ( _TintColor * temp_output_40_0 ) , saturate( temp_output_40_0 ));
			float4 switchResult75 = (((i.ASEVFace>0)?(( ( _HitColor * localGetHits300 ) + lerpResult218 )):(temp_output_48_0)));
			o.Emission = (( float4( temp_output_367_0 , 0.0 ) >= temp_cast_7 ) ? switchResult75 :  _TintColor ).rgb;
			o.Alpha = saturate( ( (lerpResult218).a * i.vertexColor.a * temp_output_367_0 ) ).x;
			clip( temp_output_367_0.x - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.5
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 customPack1 : TEXCOORD1;
				float2 customPack2 : TEXCOORD2;
				float4 screenPos : TEXCOORD3;
				float4 tSpace0 : TEXCOORD4;
				float4 tSpace1 : TEXCOORD5;
				float4 tSpace2 : TEXCOORD6;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xyzw = customInputData.uv_tex4coord;
				o.customPack1.xyzw = v.texcoord;
				o.customPack2.xy = customInputData.uv_texcoord;
				o.customPack2.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_tex4coord = IN.customPack1.xyzw;
				surfIN.uv_texcoord = IN.customPack2.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
				surfIN.vertexColor = IN.color;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
45;323;1389;720;601.4175;-384.444;1;True;False
Node;AmplifyShaderEditor.FunctionNode;299;-1031.73,108.0997;Float;False;QFX Get Simple Noise Distortion;17;;7;dba3a45ee088a1c42ae7fbf09d132e5e;0;0;4;COLOR;81;COLOR;82;FLOAT;64;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;53;-802.8898,467.0756;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;55;-541.7477,413.7545;Float;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenColorNode;54;-385.4664,409.2976;Float;False;Global;_GrabScreen1;Grab Screen 1;0;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;216;-495.4174,180.3286;Float;False;Property;_DisotrionColor;Disotrion Color;14;1;[HDR];Create;True;0;0;False;0;0,0,0,0;1.376644,1.376644,1.376644,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;311;-1454.808,-289.6699;Float;True;Property;_HitWaveRampMap;Hit Wave Ramp Map;35;0;Create;True;0;0;False;0;None;27779bac95236784ab8f7246c70afa83;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;314;-1229.791,-126.1509;Float;True;Property;_HitTexture;Hit Texture;34;0;Create;True;0;0;False;0;None;eaca2f44f86a39242884d8b08999a841;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;302;-1497.674,-496.7906;Float;False;Constant;_HitsMaxCount;Hits Max Count;14;0;Create;True;0;0;False;0;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;214;-193.7354,355.2847;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;47;-518.9494,61.89984;Float;False;QFX Get Depth Fade Color;27;;57;178c752a5f1ef2644a24cb6a097a6938;0;0;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;40;-522.9691,-135.0436;Float;False;QFX Get Fresnel;31;;58;0a832704e6daa5244b3db55d16dfb317;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GlobalArrayNode;301;-1146.252,-519.6903;Float;False;_HitPositions;0;1;2;False;False;0;1;False;Object;-1;4;0;INT;0;False;2;INT;0;False;1;INT;0;False;3;INT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;306;-1196.769,-686.6085;Float;False;Property;_HitWaveFade;Hit Wave Fade;38;0;Create;True;0;0;False;0;0.05;1;0.05;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;305;-1108.125,-989.8769;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WireNode;309;-1207.603,-821.4246;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;316;-940.5433,-283.0797;Float;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.WireNode;318;-834.971,-272.6943;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GlobalArrayNode;304;-1142.756,-417.658;Float;False;_HitRadii;0;1;0;False;False;0;1;False;Object;-1;4;0;INT;0;False;2;INT;0;False;1;INT;0;False;3;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;307;-1153.909,-822.9374;Float;False;Property;_HitWaveMaxRadius;Hit Wave Max Radius;37;0;Create;True;0;0;False;0;0;2.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;57;-524.2322,-387.8693;Float;False;Property;_TintColor;Tint Color;1;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.8529389,1.916427,4,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CustomExpressionNode;300;-686.7235,-830.2758;Float;False;float hit_intencity = 0@$for (int i = 0@ i < HitMaxCount@ i++)$            {$                float hit_distance = ( distance( _HitPositions[i], WorldPosition ) / HitWaveMaxRadius )@$                float hit_fade = smoothstep( 0.0 , HitWaveFade , ( 1.0 - ( hit_distance - (-1.0 + (_HitRadii[i] - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) ) ))@$                float4 ramp_map = tex2D( HitWaveRampMap, float2(hit_fade, 0) )@$                float wave = ( ramp_map.r - ( ramp_map.r * tex2D( HitWaveRampMap, ( hit_fade - DistortionRG ).rg ).r ) )@$                float intencity = ( saturate( ( 1.0 - hit_distance ) ) * saturate(wave - HitTextureR ) )@		$                hit_intencity += intencity@$            }$            hit_intencity = saturate(hit_intencity)@$return hit_intencity@;1;False;9;False;WorldPosition;FLOAT3;0,0,0;In;;Float;False;HitMaxCount;INT;0;In;;Float;False;HitWaveMaxRadius;FLOAT;1;In;;Float;False;HitWaveFade;FLOAT;1;In;;Float;False;HitPositions;FLOAT4;0,0,0,0;In;;Float;False;HitRadii;FLOAT4;0,0,0,0;In;;Float;False;HitWaveRampMap;SAMPLER2D;;In;;Float;False;HitTextureR;FLOAT;0;In;;Float;True;DistortionRG;FLOAT2;0,0;In;;Float;Get Hits;True;False;0;9;0;FLOAT3;0,0,0;False;1;INT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;SAMPLER2D;;False;7;FLOAT;0;False;8;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;-58.18925,172.7596;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-263.5041,-279.0087;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;219;-202.7932,-135.1003;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;81;-182.6127,-714.8492;Float;False;Property;_HitColor;Hit Color;36;1;[HDR];Create;True;0;0;False;0;0,0,0,0;1.492636,3.353752,7.000021,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;328;-244.962,748.4111;Float;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;357;-241.2835,593.793;Float;False;Property;_ObjectWorldPosition;Object World Position;16;1;[HideInInspector];Create;True;0;0;False;0;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;68.70758,-613.6136;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;347;-351.351,902.3446;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;218;117.3961,-176.8531;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;367;49.82264,795.8851;Float;True;QFX Get Mask Appear;2;;96;6c0a21bbc2173ee4f98c4fde6531d5a9;0;3;33;FLOAT3;0,0,0;False;14;FLOAT;0;False;32;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;180;317.0894,-274.2061;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;200;364.8435,24.18335;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;58;178.5959,307.7987;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;226;182.1308,195.0442;Float;False;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;75;438.2473,-52.68284;Float;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;217;569.6887,297.7307;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;354;472.8009,-145.7424;Float;False;Property;_DissolveAmount;Dissolve Amount;15;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;285;506.5123,517.2944;Float;False;Property;_VertexOffsetAmount;Vertex Offset Amount;39;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;286;555.3651,623.1401;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCCompareGreaterEqual;350;701.9507,-27.29528;Float;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;287;778.5111,571.6451;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode;355;-589.3416,-546.7148;Float;False;QFX Get Hit;7;;97;c4c66cba1faffcf4a96de0e0e7f21d90;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;323;716.481,275.47;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;50;992.6642,1.180705;Float;False;True;3;Float;ASEMaterialInspector;0;0;Unlit;QFX/SFX/Shield/EnergyShield;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;55;0;299;0
WireConnection;55;1;53;0
WireConnection;54;0;55;0
WireConnection;214;0;216;0
WireConnection;214;1;54;0
WireConnection;301;1;302;0
WireConnection;309;0;302;0
WireConnection;316;0;311;0
WireConnection;318;0;314;1
WireConnection;304;1;302;0
WireConnection;300;0;305;0
WireConnection;300;1;309;0
WireConnection;300;2;307;0
WireConnection;300;3;306;0
WireConnection;300;4;301;0
WireConnection;300;5;304;0
WireConnection;300;6;316;0
WireConnection;300;7;318;0
WireConnection;300;8;299;81
WireConnection;48;0;47;0
WireConnection;48;1;214;0
WireConnection;69;0;57;0
WireConnection;69;1;40;0
WireConnection;219;0;40;0
WireConnection;82;0;81;0
WireConnection;82;1;300;0
WireConnection;347;0;299;64
WireConnection;218;0;48;0
WireConnection;218;1;69;0
WireConnection;218;2;219;0
WireConnection;367;33;357;0
WireConnection;367;14;328;3
WireConnection;367;32;347;0
WireConnection;180;0;82;0
WireConnection;180;1;218;0
WireConnection;200;0;48;0
WireConnection;226;0;218;0
WireConnection;75;0;180;0
WireConnection;75;1;200;0
WireConnection;217;0;226;0
WireConnection;217;1;58;4
WireConnection;217;2;367;0
WireConnection;350;0;367;0
WireConnection;350;1;354;0
WireConnection;350;2;75;0
WireConnection;350;3;57;0
WireConnection;287;0;285;0
WireConnection;287;1;286;0
WireConnection;323;0;217;0
WireConnection;50;2;350;0
WireConnection;50;9;323;0
WireConnection;50;10;367;0
WireConnection;50;11;287;0
ASEEND*/
//CHKSM=74E1837555366D72781A2343D361D7BAF1476A0F