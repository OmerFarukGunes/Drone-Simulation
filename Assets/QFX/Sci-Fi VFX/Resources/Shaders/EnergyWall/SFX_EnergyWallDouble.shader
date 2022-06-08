// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/SFX/EnergyWallDouble"
{
	Properties
	{
		_SphereCenter("Sphere Center", Vector) = (0.5,0.5,0,0)
		_SphereRadius("Sphere Radius", Range( 0 , 1)) = 0.3105874
		_SphereHardness("Sphere Hardness", Range( 0 , 1)) = 0.3796069
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
		[Toggle]_BlendGrid("Blend Grid", Float) = 0
		[Toggle]_NoiseDistortion("NoiseDistortion", Float) = 1
		_OpacityPower("Opacity Power", Range( 0 , 1)) = 0
		_MainTexSpeed("Main Tex Speed", Vector) = (0.5,0,0,0)
		_MainTextureTilling("Main Texture Tilling", Float) = 0.1
		[KeywordEnum(UV,U,V)] _MainTexNoise("Main Tex Noise", Float) = 0
		_MainTex("Main Tex", 2D) = "white" {}
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
		#pragma shader_feature _MAINTEXNOISE_UV _MAINTEXNOISE_U _MAINTEXNOISE_V
		#pragma surface surf Standard alpha:fade keepalpha noshadow 
		struct Input
		{
			float4 screenPos;
			float3 worldNormal;
			float3 worldPos;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float _NoiseDistortion;
		uniform sampler2D _CameraDepthTexture;
		uniform float _DepthDistance;
		uniform float _DepthFadeExp;
		uniform float4 _DepthColor;
		uniform float4 _TintColor;
		uniform sampler2D _GridTexture;
		uniform float _GridTilling;
		uniform float _GridOffsetX;
		uniform float _GridOffsetY;
		uniform float _GridTexturePow;
		uniform float _BlendGrid;
		uniform sampler2D _MainTex;
		uniform float2 _MainTexSpeed;
		uniform float _MainTextureTilling;
		uniform sampler2D _NoiseMap;
		uniform sampler2D _DistortionMap;
		uniform float2 _NoiseDistortionSpeed;
		uniform float _NoiseDistortionTilling;
		uniform float _NoiseTilling;
		uniform float _NoisePower;
		uniform float2 _SphereCenter;
		uniform float _SphereRadius;
		uniform float _SphereHardness;
		uniform sampler2D _GrabTexture;
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
			float4 temp_output_36_0 = ( pow( saturate( ( 1.0 - distanceDepth2_g34 ) ) , _DepthFadeExp ) * _DepthColor );
			float3 ase_worldNormal = i.worldNormal;
			float3 temp_output_22_0_g35 = abs( ase_worldNormal );
			float3 ase_worldPos = i.worldPos;
			float2 appendResult8_g35 = (float2(ase_worldPos.y , ase_worldPos.z));
			float2 appendResult4_g35 = (float2(_GridTilling , _GridTilling));
			float2 appendResult9_g35 = (float2(_GridOffsetX , _GridOffsetY));
			float4 temp_cast_0 = (_GridTexturePow).xxxx;
			float2 appendResult7_g35 = (float2(ase_worldPos.z , ase_worldPos.x));
			float4 temp_cast_1 = (_GridTexturePow).xxxx;
			float2 appendResult6_g35 = (float2(ase_worldPos.x , ase_worldPos.y));
			float4 temp_cast_2 = (_GridTexturePow).xxxx;
			float3 weightedBlendVar27_g35 = ( temp_output_22_0_g35 * temp_output_22_0_g35 );
			float4 weightedAvg27_g35 = ( ( weightedBlendVar27_g35.x*pow( tex2D( _GridTexture, ( ( appendResult8_g35 * appendResult4_g35 ) + appendResult9_g35 ) ) , temp_cast_0 ) + weightedBlendVar27_g35.y*pow( tex2D( _GridTexture, ( ( appendResult7_g35 * appendResult4_g35 ) + appendResult9_g35 ) ) , temp_cast_1 ) + weightedBlendVar27_g35.z*pow( tex2D( _GridTexture, ( ( appendResult6_g35 * appendResult4_g35 ) + appendResult9_g35 ) ) , temp_cast_2 ) )/( weightedBlendVar27_g35.x + weightedBlendVar27_g35.y + weightedBlendVar27_g35.z ) );
			float4 temp_output_116_0 = weightedAvg27_g35;
			float4 temp_output_151_0 = ( _TintColor * temp_output_116_0 );
			float2 temp_cast_4 = (i.uv_texcoord.x).xx;
			float2 temp_cast_5 = (i.uv_texcoord.y).xx;
			#if defined(_MAINTEXNOISE_UV)
				float2 staticSwitch73 = i.uv_texcoord;
			#elif defined(_MAINTEXNOISE_U)
				float2 staticSwitch73 = temp_cast_4;
			#elif defined(_MAINTEXNOISE_V)
				float2 staticSwitch73 = temp_cast_5;
			#else
				float2 staticSwitch73 = i.uv_texcoord;
			#endif
			float2 panner21_g10 = ( 1.0 * _Time.y * _NoiseDistortionSpeed + i.uv_texcoord);
			float2 temp_cast_7 = (_NoiseTilling).xx;
			float2 uv_TexCoord45_g10 = i.uv_texcoord * temp_cast_7;
			float spheremask176 = saturate( ( ( distance( i.uv_texcoord , _SphereCenter ) - _SphereRadius ) / saturate( _SphereHardness ) ) );
			float4 temp_output_22_0 = ( ( _TintColor * tex2D( _MainTex, ( float4( ( _MainTexSpeed * _Time.y ), 0.0 , 0.0 ) + ( _MainTextureTilling * ( float4( staticSwitch73, 0.0 , 0.0 ) + ( tex2D( _NoiseMap, ( tex2D( _DistortionMap, (panner21_g10*_NoiseDistortionTilling + 0.0) ) + float4( uv_TexCoord45_g10, 0.0 , 0.0 ) ).rg ) * _NoisePower ) ) ) ).rg ).r * spheremask176 ) + temp_output_36_0 );
			float2 panner21_g33 = ( 1.0 * _Time.y * _NoiseDistortionSpeed + i.uv_texcoord);
			float2 temp_cast_14 = (_NoiseTilling).xx;
			float2 uv_TexCoord45_g33 = i.uv_texcoord * temp_cast_14;
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor19 = tex2D( _GrabTexture, ( ( tex2D( _NoiseMap, ( tex2D( _DistortionMap, (panner21_g33*_NoiseDistortionTilling + 0.0) ) + float4( uv_TexCoord45_g33, 0.0 , 0.0 ) ).rg ) * _NoisePower ) + ase_grabScreenPosNorm ).rg );
			float clampResult174 = clamp( spheremask176 , 0.0 , 1.0 );
			float smoothstepResult175 = smoothstep( 0.5 , 1.0 , ( 1.0 - clampResult174 ));
			float4 tint_color182 = _TintColor;
			float4 appear_mask185 = ( temp_output_116_0 * smoothstepResult175 * tint_color182 );
			o.Emission = lerp(( temp_output_36_0 + temp_output_151_0 ),( lerp(temp_output_22_0,( temp_output_22_0 * temp_output_116_0 ),_BlendGrid) + screenColor19 + appear_mask185 ),_NoiseDistortion).rgb;
			o.Alpha = saturate( ( _OpacityPower * i.vertexColor.a * lerp((temp_output_151_0).a,1.0,_NoiseDistortion) ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15600
7;29;1906;1014;3258.005;821.5417;3.22784;True;False
Node;AmplifyShaderEditor.CommentaryNode;146;-2114.622,-231.792;Float;False;1560.64;819.0309;;14;58;24;67;66;6;60;63;71;69;68;73;70;23;177;Main Tex ;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;60;-2077.69,298.6447;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;58;-1792.69,499.6448;Float;False;Get Simple Noise;10;;10;dba3a45ee088a1c42ae7fbf09d132e5e;0;0;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;73;-1824.69,291.6447;Float;False;Property;_MainTexNoise;Main Tex Noise;22;0;Create;True;0;0;False;0;0;0;0;True;;KeywordEnum;3;UV;U;V;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-1824.69,195.6448;Float;False;Property;_MainTextureTilling;Main Texture Tilling;21;0;Create;True;0;0;False;0;0.1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;68;-1792.69,-124.3552;Float;False;Property;_MainTexSpeed;Main Tex Speed;20;0;Create;True;0;0;False;0;0.5,0;-0.15,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;66;-1504.69,339.6447;Float;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TimeNode;71;-1808.69,35.64485;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;180;-2157.518,1495.809;Float;False;Get UV Sphere;0;;22;24f3cbf37524d844f889d22202bd9bc8;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-1488.69,-44.35517;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-1360.69,291.6447;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;176;-1973.55,1491.154;Float;False;spheremask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;69;-1184.69,147.6448;Float;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;6;-944.6894,-140.3552;Float;False;Property;_TintColor;Tint Color;28;1;[HDR];Create;True;0;0;False;0;1,1,1,1;0,1.186207,4,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;174;-1744.125,1496.342;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;24;-1040.689,99.64478;Float;True;Property;_MainTex;Main Tex;23;0;Create;True;0;0;False;0;None;8ff96dbed3bc8ab44a7842f0bc5c934a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;145;-2115.352,795.9858;Float;False;766.7092;506.1884;;4;21;19;20;18;Grab Screen;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;177;-912.321,323.4767;Float;False;176;spheremask;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;116;-1271.634,763.707;Float;False;Get Weight Blended Texture;4;;35;71af75d3d7ad4f045be3dfc5ea711f13;0;0;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-691.1638,52.33665;Float;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;173;-1598.02,1492.22;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;152;-420.7889,1072.247;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;18;-2033.524,913.1259;Float;False;Get Simple Noise;10;;33;dba3a45ee088a1c42ae7fbf09d132e5e;0;0;1;COLOR;0
Node;AmplifyShaderEditor.GrabScreenPosition;20;-2038.668,1088.001;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;36;-1180.586,638.5232;Float;False;Get Depth Fade Color;24;;34;178c752a5f1ef2644a24cb6a097a6938;0;0;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;182;-499.0269,-137.4606;Float;False;tint_color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;175;-1433.062,1489.645;Float;False;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-514.751,442.0875;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;-173.8879,1208.948;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-1781.307,982.9654;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;183;-1439.686,1921.615;Float;False;182;tint_color;0;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;184;-1125.243,1467.516;Float;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-402.1969,612.3199;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;154;24.65951,1446.542;Float;False;Constant;_Float0;Float 0;17;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;19;-1624.139,977.5494;Float;False;Global;_GrabScreen0;Grab Screen 0;4;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;142;13.3644,1310.344;Float;False;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;147;205.537,1570.132;Float;False;705.5583;337.0039;;4;181;74;28;140;Opacity;1,1,1,1;0;0
Node;AmplifyShaderEditor.ToggleSwitchNode;149;-168.2987,439.4539;Float;False;Property;_BlendGrid;Blend Grid;17;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;187;-213.3681,662.9467;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;186;-103.9666,702.2972;Float;False;185;appear_mask;0;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;185;-976.3546,1463.838;Float;False;appear_mask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;153;270.9916,1351.237;Float;False;Property;_NoiseDistortion;NoiseDistortion;18;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;140;334.3769,1707.548;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;28;242.7763,1634.742;Float;False;Property;_OpacityPower;Opacity Power;19;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;156;0.5135498,1098.124;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;578.7767,1666.742;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;114;159.9079,449.7811;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;150;385.147,886.8519;Float;False;Property;_NoiseDistortion;NoiseDistortion;18;0;Create;True;0;0;False;0;1;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;181;732.7596,1663.785;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;2;1009.879,853.4917;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;QFX/SFX/EnergyWallDouble;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;73;1;60;0
WireConnection;73;0;60;1
WireConnection;73;2;60;2
WireConnection;66;0;73;0
WireConnection;66;1;58;0
WireConnection;70;0;68;0
WireConnection;70;1;71;2
WireConnection;67;0;63;0
WireConnection;67;1;66;0
WireConnection;176;0;180;0
WireConnection;69;0;70;0
WireConnection;69;1;67;0
WireConnection;174;0;176;0
WireConnection;24;1;69;0
WireConnection;23;0;6;0
WireConnection;23;1;24;1
WireConnection;23;2;177;0
WireConnection;173;0;174;0
WireConnection;152;0;6;0
WireConnection;182;0;6;0
WireConnection;175;0;173;0
WireConnection;22;0;23;0
WireConnection;22;1;36;0
WireConnection;151;0;152;0
WireConnection;151;1;116;0
WireConnection;21;0;18;0
WireConnection;21;1;20;0
WireConnection;184;0;116;0
WireConnection;184;1;175;0
WireConnection;184;2;183;0
WireConnection;83;0;22;0
WireConnection;83;1;116;0
WireConnection;19;0;21;0
WireConnection;142;0;151;0
WireConnection;149;0;22;0
WireConnection;149;1;83;0
WireConnection;187;0;19;0
WireConnection;185;0;184;0
WireConnection;153;0;142;0
WireConnection;153;1;154;0
WireConnection;156;0;36;0
WireConnection;156;1;151;0
WireConnection;74;0;28;0
WireConnection;74;1;140;4
WireConnection;74;2;153;0
WireConnection;114;0;149;0
WireConnection;114;1;187;0
WireConnection;114;2;186;0
WireConnection;150;0;156;0
WireConnection;150;1;114;0
WireConnection;181;0;74;0
WireConnection;2;2;150;0
WireConnection;2;9;181;0
ASEEND*/
//CHKSM=469066F957728EB01ECD484661804D47DF073756