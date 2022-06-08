// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/SFX/Shield/ObjectShield"
{
	Properties
	{
		[HDR]_TintColor("Tint Color", Color) = (1,1,1,1)
		[HDR]_CracksColor("Cracks Color", Color) = (0,0,0,0)
		[HDR]_FresnelColor("Fresnel Color", Color) = (1,1,1,1)
		_NoiseMap("Noise Map", 2D) = "white" {}
		_DistortionMap("Distortion Map", 2D) = "white" {}
		_NoiseDistortionPower("Noise Distortion Power", Range( 0 , 2)) = 0.2179676
		_NoiseDistortionTilling("Noise Distortion Tilling", Range( 0 , 10)) = 1.142912
		_NoiseDistortionSpeed("Noise Distortion Speed", Vector) = (0,0.2,0,0)
		_NoisePower("Noise Power", Range( 0 , 2)) = 2
		_NoiseOffset("Noise Offset", Range( 0 , 1)) = 0
		_NoiseTilling("Noise Tilling", Range( 0 , 10)) = 0.894883
		_NoiseSpeed("Noise Speed", Vector) = (0.2,0,0,0)
		_PatternTexture1("Pattern Texture 1", 2D) = "white" {}
		_PatternTexture2("Pattern Texture 2", 2D) = "white" {}
		_PatternTexture3("Pattern Texture 3", 2D) = "white" {}
		_PatternTexture1Speed("Pattern Texture 1 Speed", Vector) = (0.5,0,0,0)
		_PatternTexture2Speed("Pattern Texture 2 Speed", Vector) = (0.5,0,0,0)
		_PatternTexture3Speed("Pattern Texture 3 Speed", Vector) = (0.5,0,0,0)
		_PatternPower1("Pattern Power 1", Range( 0.1 , 20)) = 0.1
		_PatternPower2("Pattern Power 2", Range( 0.1 , 20)) = 0.1
		_PatternPower3("Pattern Power 3", Range( 0.1 , 20)) = 0.1
		_CracksAdjust("Cracks Adjust", Range( 0.01 , 0.99)) = 0
		_CracksPower("Cracks Power", Range( 0 , 1.5)) = 0
		_CracksTexture("Cracks Texture", 2D) = "white" {}
		_FresnelScale("Fresnel Scale", Range( 0 , 1)) = 0.510905
		_FresnelPower("Fresnel Power", Range( 0 , 5)) = 2
		[Toggle]_FresnelOpacity("Fresnel Opacity", Float) = 0
		_MaskAppearProgress("Mask Appear Progress", Float) = 1.002935
		_VertexOffset("Vertex Offset", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		GrabPass{ }
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform float _VertexOffset;
		uniform float4 _FresnelColor;
		uniform float _FresnelScale;
		uniform float _FresnelPower;
		uniform float4 _TintColor;
		uniform sampler2D _PatternTexture1;
		uniform float2 _PatternTexture1Speed;
		uniform float4 _PatternTexture1_ST;
		uniform float _PatternPower1;
		uniform sampler2D _PatternTexture2;
		uniform float2 _PatternTexture2Speed;
		uniform float4 _PatternTexture2_ST;
		uniform float _PatternPower2;
		uniform sampler2D _PatternTexture3;
		uniform float2 _PatternTexture3Speed;
		uniform float4 _PatternTexture3_ST;
		uniform float _PatternPower3;
		uniform sampler2D _NoiseMap;
		uniform sampler2D _DistortionMap;
		uniform float2 _NoiseDistortionSpeed;
		uniform float _NoiseDistortionTilling;
		uniform float _NoiseDistortionPower;
		uniform float2 _NoiseSpeed;
		uniform float _NoiseTilling;
		uniform float _NoisePower;
		uniform float _NoiseOffset;
		uniform sampler2D _GrabTexture;
		uniform float _CracksAdjust;
		uniform sampler2D _CracksTexture;
		uniform float4 _CracksTexture_ST;
		uniform float _CracksPower;
		uniform float4 _CracksColor;
		uniform float _MaskAppearProgress;
		uniform float _FresnelOpacity;


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
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			v.vertex.xyz += ( _VertexOffset * ase_worldNormal );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV1_g22 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode1_g22 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV1_g22, _FresnelPower ) );
			float temp_output_159_0 = saturate( fresnelNode1_g22 );
			float2 uv_PatternTexture1 = i.uv_texcoord * _PatternTexture1_ST.xy + _PatternTexture1_ST.zw;
			float2 uv_PatternTexture2 = i.uv_texcoord * _PatternTexture2_ST.xy + _PatternTexture2_ST.zw;
			float2 uv_PatternTexture3 = i.uv_texcoord * _PatternTexture3_ST.xy + _PatternTexture3_ST.zw;
			float2 panner21_g7 = ( 1.0 * _Time.y * _NoiseDistortionSpeed + i.uv_texcoord);
			float temp_output_72_0_g7 = ( tex2D( _DistortionMap, (panner21_g7*_NoiseDistortionTilling + 0.0) ).r * _NoiseDistortionPower );
			float2 panner71_g7 = ( 1.0 * _Time.y * _NoiseSpeed + i.uv_texcoord);
			float temp_output_124_0 = ( ( tex2D( _NoiseMap, ( temp_output_72_0_g7 + (panner71_g7*_NoiseTilling + 0.0) ) ).r * _NoisePower ) - _NoiseOffset );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor6 = tex2D( _GrabTexture, ( temp_output_124_0 + ase_grabScreenPosNorm ).xy );
			float2 uv_CracksTexture = i.uv_texcoord * _CracksTexture_ST.xy + _CracksTexture_ST.zw;
			float smoothstepResult81 = smoothstep( 0.0 , _CracksAdjust , pow( tex2D( _CracksTexture, uv_CracksTexture ).r , _CracksPower ));
			float4 transform106 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float2 panner21_g21 = ( 1.0 * _Time.y * _NoiseDistortionSpeed + i.uv_texcoord);
			float temp_output_72_0_g21 = ( tex2D( _DistortionMap, (panner21_g21*_NoiseDistortionTilling + 0.0) ).r * _NoiseDistortionPower );
			float2 panner71_g21 = ( 1.0 * _Time.y * _NoiseSpeed + i.uv_texcoord);
			float mask_appear113 = ( ( ( transform106 - float4( ase_worldPos , 0.0 ) ).y + _MaskAppearProgress ) - ( ( tex2D( _NoiseMap, ( temp_output_72_0_g21 + (panner71_g21*_NoiseTilling + 0.0) ) ).r * _NoisePower ) - _NoiseOffset ) );
			float temp_output_151_0 = saturate( mask_appear113 );
			o.Emission = ( ( ( ( _FresnelColor * temp_output_159_0 ) + ( ( _TintColor * ( ( pow( tex2D( _PatternTexture1, ( ( _PatternTexture1Speed * _Time.y ) + uv_PatternTexture1 ) ).r , _PatternPower1 ) * pow( tex2D( _PatternTexture2, ( ( _PatternTexture2Speed * _Time.y ) + uv_PatternTexture2 ) ).r , _PatternPower2 ) ) + ( pow( tex2D( _PatternTexture3, ( ( _PatternTexture3Speed * _Time.y ) + uv_PatternTexture3 ) ).r , _PatternPower3 ) * saturate( temp_output_124_0 ) ) ) * temp_output_159_0 ) + screenColor6 ) ) + ( temp_output_159_0 * ( saturate( ( smoothstepResult81 - 0.2 ) ) * _CracksColor ) ) ) * temp_output_151_0 ).rgb;
			o.Alpha = saturate( ( temp_output_151_0 * lerp(1.0,temp_output_159_0,_FresnelOpacity) ) );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
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
				float2 customPack1 : TEXCOORD1;
				float4 screenPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
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
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
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
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
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
Version=15600
0;92;480;936;1397.766;1690.269;2.537251;True;False
Node;AmplifyShaderEditor.CommentaryNode;8;-1839.762,-458.1002;Float;False;1581.542;935.1526;;20;158;157;156;155;154;18;17;9;13;15;54;153;20;53;152;47;50;56;163;51;Pattern Texture 2,3;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;24;-1843.602,-1381.217;Float;False;1305.484;769.2443;;8;43;44;33;31;27;30;28;26;Pattern Texture 1;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;28;-1802.922,-1294.613;Float;False;Property;_PatternTexture1Speed;Pattern Texture 1 Speed;16;0;Create;True;0;0;False;0;0.5,0;-0.5,-0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;15;-1806.191,-402.6152;Float;False;Property;_PatternTexture2Speed;Pattern Texture 2 Speed;17;0;Create;True;0;0;False;0;0.5,0;0,-0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TimeNode;13;-1810.387,-242.615;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;26;-1791.922,-1134.612;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;154;-1816.274,35.47043;Float;False;Property;_PatternTexture3Speed;Pattern Texture 3 Speed;18;0;Create;True;0;0;False;0;0.5,0;0,-2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TimeNode;155;-1808.857,193.1482;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-1811.722,-92.01646;Float;False;0;20;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;27;-1782.807,-841.1617;Float;False;0;33;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1568.29,-317.8938;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-1552.825,-1203.721;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;156;-1810.193,343.7468;Float;False;0;47;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;157;-1566.761,117.8694;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;162;575.694,1473.965;Float;False;1580.771;864.7175;;9;128;113;111;100;108;98;107;106;99;Mask Appear;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-1427.176,-194.353;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;160;-1557.978,1377.5;Float;False;1649.364;702.3201;;9;92;91;81;78;77;82;80;84;161;Pattern - Cracks;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-1370.18,-1024.169;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;3,3;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;158;-1425.646,241.4102;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;77;-1359.079,1485.769;Float;True;Property;_CracksTexture;Cracks Texture;24;0;Create;True;0;0;False;0;None;158952560ab7ba648999bbcfea2c975a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;106;668.5761,1694.251;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;99;681.2481,1892.092;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;20;-1166.554,-395.866;Float;True;Property;_PatternTexture2;Pattern Texture 2;14;0;Create;True;0;0;False;0;None;e28b5ed144afcfa4ba0b6e147ecde7c3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;80;-1369.359,1795.846;Float;False;Property;_CracksPower;Cracks Power;23;0;Create;True;0;0;False;0;0;1.21;0;1.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;33;-1165.501,-1050.388;Float;True;Property;_PatternTexture1;Pattern Texture 1;13;0;Create;True;0;0;False;0;None;163632276e446414db3976d5befc6048;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;54;-1163.541,-196.8379;Float;False;Property;_PatternPower2;Pattern Power 2;20;0;Create;True;0;0;False;0;0.1;1.5;0.1;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-1153.099,-749.1547;Float;False;Property;_PatternPower1;Pattern Power 1;19;0;Create;True;0;0;False;0;0.1;0.9;0.1;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;153;-1181.577,195.1546;Float;False;Property;_PatternPower3;Pattern Power 3;21;0;Create;True;0;0;False;0;0.1;0.9;0.1;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;47;-1184.77,-20.75671;Float;True;Property;_PatternTexture3;Pattern Texture 3;15;0;Create;True;0;0;False;0;None;eaca2f44f86a39242884d8b08999a841;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;124;-1150.568,518.3878;Float;False;QFX Get Simple Noise Distortion;3;;7;dba3a45ee088a1c42ae7fbf09d132e5e;0;0;4;COLOR;81;COLOR;82;FLOAT;64;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;2;-708.805,606.5655;Float;False;766.7092;506.1884;;3;6;5;4;Grab Screen;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;82;-1264.819,1935.769;Float;False;Property;_CracksAdjust;Cracks Adjust;22;0;Create;True;0;0;False;0;0;0.075;0.01;0.99;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;78;-1026.925,1601.135;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;152;-812.2885,-350.3193;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;53;-811.9256,-16.3164;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;43;-826.6606,-962.291;Float;True;2;0;FLOAT;0;False;1;FLOAT;1.47;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;107;885.1314,1822.329;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;163;-723.6992,361.8829;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;4;-665.9404,909.2615;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;81;-776.8303,1600.265;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-516.9025,-397.8806;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-565.772,111.7127;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;98;1015.378,2130.115;Float;False;Property;_MaskAppearProgress;Mask Appear Progress;29;0;Create;True;0;0;False;0;1.002935;0.56;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;108;1043.309,1823.379;Float;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleSubtractOpNode;91;-545.9614,1601.488;Float;True;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;128;1151.255,1659.445;Float;False;QFX Get Simple Noise Distortion;3;;21;dba3a45ee088a1c42ae7fbf09d132e5e;0;0;4;COLOR;81;COLOR;82;FLOAT;64;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;159;-174.9152,-877.7905;Float;False;QFX Get Fresnel;25;;22;0a832704e6daa5244b3db55d16dfb317;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;5;-378.3203,795.3254;Float;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;21;-223.0986,-495.0457;Float;False;Property;_TintColor;Tint Color;0;1;[HDR];Create;True;0;0;False;0;1,1,1,1;15,6.054766,3.419117,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;100;1307.927,2061.563;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-466.0643,-170.9485;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;6;-217.5933,788.1294;Float;False;Global;_GrabScreen0;Grab Screen 0;4;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;84;-340.1056,1867.944;Float;False;Property;_CracksColor;Cracks Color;1;1;[HDR];Create;True;0;0;False;0;0,0,0,0;8.000001,3.862069,2,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;243.0237,-283.0946;Float;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;65;-175.8768,-1062.083;Float;False;Property;_FresnelColor;Fresnel Color;2;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,0.3308823,0.3308823,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;92;-333.8428,1600.678;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;111;1617.902,1886.118;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;114;1228.121,160.8674;Float;False;113;mask_appear;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;152.5258,-974.7974;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;76;1080.26,455.0847;Float;False;Constant;_Float1;Float 1;21;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;113;1863.818,1881.645;Float;True;mask_appear;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;57;598.4151,-112.7995;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;161;-61.63781,1537.891;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;67;937.3184,-72.49989;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;742.162,374.8362;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;151;1445.825,165.4855;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;75;1291.206,393.7105;Float;False;Property;_FresnelOpacity;Fresnel Opacity;28;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;1992.55,663.5253;Float;False;Property;_VertexOffset;Vertex Offset;30;0;Create;True;0;0;False;0;0;0.002;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;1756.722,349.4589;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;60;1994.077,775.6333;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;86;1140.364,-26.28192;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;104;2016.954,355.8922;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;2200.643,708.5302;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;102;1838.786,36.27208;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;7;2423.549,129.5067;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;QFX/SFX/Shield/ObjectShield;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;17;0;15;0
WireConnection;17;1;13;2
WireConnection;30;0;28;0
WireConnection;30;1;26;2
WireConnection;157;0;154;0
WireConnection;157;1;155;2
WireConnection;18;0;17;0
WireConnection;18;1;9;0
WireConnection;31;0;30;0
WireConnection;31;1;27;0
WireConnection;158;0;157;0
WireConnection;158;1;156;0
WireConnection;20;1;18;0
WireConnection;33;1;31;0
WireConnection;47;1;158;0
WireConnection;78;0;77;1
WireConnection;78;1;80;0
WireConnection;152;0;20;1
WireConnection;152;1;54;0
WireConnection;53;0;47;1
WireConnection;53;1;153;0
WireConnection;43;0;33;1
WireConnection;43;1;44;0
WireConnection;107;0;106;0
WireConnection;107;1;99;0
WireConnection;163;0;124;0
WireConnection;81;0;78;0
WireConnection;81;2;82;0
WireConnection;50;0;43;0
WireConnection;50;1;152;0
WireConnection;56;0;53;0
WireConnection;56;1;163;0
WireConnection;108;0;107;0
WireConnection;91;0;81;0
WireConnection;5;0;124;0
WireConnection;5;1;4;0
WireConnection;100;0;108;1
WireConnection;100;1;98;0
WireConnection;51;0;50;0
WireConnection;51;1;56;0
WireConnection;6;0;5;0
WireConnection;52;0;21;0
WireConnection;52;1;51;0
WireConnection;52;2;159;0
WireConnection;92;0;91;0
WireConnection;111;0;100;0
WireConnection;111;1;128;0
WireConnection;66;0;65;0
WireConnection;66;1;159;0
WireConnection;113;0;111;0
WireConnection;57;0;52;0
WireConnection;57;1;6;0
WireConnection;161;0;92;0
WireConnection;161;1;84;0
WireConnection;67;0;66;0
WireConnection;67;1;57;0
WireConnection;85;0;159;0
WireConnection;85;1;161;0
WireConnection;151;0;114;0
WireConnection;75;0;76;0
WireConnection;75;1;159;0
WireConnection;103;0;151;0
WireConnection;103;1;75;0
WireConnection;86;0;67;0
WireConnection;86;1;85;0
WireConnection;104;0;103;0
WireConnection;59;0;58;0
WireConnection;59;1;60;0
WireConnection;102;0;86;0
WireConnection;102;1;151;0
WireConnection;7;2;102;0
WireConnection;7;9;104;0
WireConnection;7;11;59;0
ASEEND*/
//CHKSM=48B2697BA513A094F4CA662BFF9944BE5B25B694