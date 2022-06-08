// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/SFX/Hologram/HologramDissolve"
{
	Properties
	{
		[Toggle]_MaskAppearInvert("Mask Appear Invert", Float) = 0
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[KeywordEnum(None,X,Y,Z)] _MaskAppearAxis("Mask Appear Axis", Float) = 0
		[HDR]_EmissionColor("Emission Color", Color) = (0,0,0,0)
		_MaskAppearProgress("Mask Appear Progress", Float) = 0
		_EmissionTexture("Emission Texture", 2D) = "white" {}
		_GlowTiling("Glow Tiling", Range( 0 , 5)) = 2
		_MaskAppearStrength("Mask Appear Strength", Range( 0 , 1)) = 0.5
		[HDR]_GlowColor("Glow Color", Color) = (0,0,0,0)
		_GlowSpeed("Glow Speed", Float) = 0
		_Scan("Scan", Range( 0 , 1)) = 0.7926539
		_ScanTiling("Scan Tiling", Range( 0 , 100)) = 3.60764
		_ScanSpeed("Scan Speed", Vector) = (0,0,0,0)
		_FlickerTexture("Flicker Texture", 2D) = "white" {}
		_FlickerSpeed("Flicker Speed", Vector) = (0.1,0.1,0,0)
		[HDR]_FresnelColor("Fresnel Color", Color) = (1,1,1,1)
		_FresnelScale("Fresnel Scale", Range( 0 , 1)) = 0.510905
		_FresnelPower("Fresnel Power", Range( 0 , 5)) = 2
		[Toggle]_UseGlowOpacity("Use Glow Opacity", Float) = 0
		[Toggle]_UseFresnelOpacity("Use Fresnel Opacity", Float) = 0
		_GlitchOffset("Glitch Offset", Vector) = (0,0,0,0)
		_GlowSize("Glow Size", Range( 0 , 1)) = 0
		_OpacityPower("Opacity Power", Range( 0 , 1)) = 1
		_Glitch("Glitch", Range( 0 , 1)) = 0.4997923
		_GlitchSpeed("Glitch Speed", Float) = 5
		[HDR]_DissolveColor("Dissolve Color", Color) = (1,1,1,1)
		_DissolveAmount("Dissolve Amount", Range( 0 , 1)) = 0
		_DissolveTex("Dissolve Tex", 2D) = "white" {}
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
		#pragma shader_feature _MASKAPPEARAXIS_NONE _MASKAPPEARAXIS_X _MASKAPPEARAXIS_Y _MASKAPPEARAXIS_Z
		#pragma surface surf Unlit keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform float3 _GlitchOffset;
		uniform float _GlitchSpeed;
		uniform float _Glitch;
		uniform float _MaskAppearStrength;
		uniform float _MaskAppearInvert;
		uniform float _MaskAppearProgress;
		uniform sampler2D _DissolveTex;
		uniform float4 _DissolveTex_ST;
		uniform float _DissolveAmount;
		uniform sampler2D _EmissionTexture;
		uniform float4 _EmissionTexture_ST;
		uniform float4 _EmissionColor;
		uniform float4 _GlowColor;
		uniform float _GlowSize;
		uniform float _GlowTiling;
		uniform float _GlowSpeed;
		uniform float _FresnelScale;
		uniform float _FresnelPower;
		uniform float4 _FresnelColor;
		uniform float4 _DissolveColor;
		uniform float _UseFresnelOpacity;
		uniform float _UseGlowOpacity;
		uniform float _ScanTiling;
		uniform float2 _ScanSpeed;
		uniform float _Scan;
		uniform sampler2D _FlickerTexture;
		uniform float2 _FlickerSpeed;
		uniform float _OpacityPower;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 VertexOffset87 = ( _GlitchOffset * ( 1.0 - saturate( step( sin( ( ( _Time.y * _GlitchSpeed ) + ase_vertex3Pos.y ) ) , ( 1.0 - _Glitch ) ) ) ) );
			v.vertex.xyz += VertexOffset87;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 transform24_g74 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float3 temp_output_33_0_g74 = transform24_g74.xyz;
			float3 ase_worldPos = i.worldPos;
			float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );
			float3 break5_g74 = ( lerp(( temp_output_33_0_g74 - ase_worldPos ),( ase_worldPos - temp_output_33_0_g74 ),_MaskAppearInvert) / ase_objectScale );
			#if defined(_MASKAPPEARAXIS_NONE)
				float staticSwitch6_g74 = 1.0;
			#elif defined(_MASKAPPEARAXIS_X)
				float staticSwitch6_g74 = break5_g74.x;
			#elif defined(_MASKAPPEARAXIS_Y)
				float staticSwitch6_g74 = break5_g74.y;
			#elif defined(_MASKAPPEARAXIS_Z)
				float staticSwitch6_g74 = break5_g74.z;
			#else
				float staticSwitch6_g74 = 1.0;
			#endif
			float2 uv_DissolveTex = i.uv_texcoord * _DissolveTex_ST.xy + _DissolveTex_ST.zw;
			float smoothstepResult31_g74 = smoothstep( 0.0 , _MaskAppearStrength , ( ( staticSwitch6_g74 + ( _MaskAppearProgress + 0.0 ) ) - tex2D( _DissolveTex, uv_DissolveTex ).r ));
			float temp_output_30_0_g73 = smoothstepResult31_g74;
			float mask_appear6_g73 = temp_output_30_0_g73;
			float2 uv_EmissionTexture = i.uv_texcoord * _EmissionTexture_ST.xy + _EmissionTexture_ST.zw;
			float4 emission134 = ( tex2D( _EmissionTexture, uv_EmissionTexture ) * _EmissionColor );
			float smoothstepResult238 = smoothstep( 0.0 , _GlowSize , saturate( frac( ( ( _GlowTiling * ase_worldPos.y ) + ( _Time.y * _GlowSpeed ) ) ) ));
			float temp_output_234_0 = ( 1.0 - smoothstepResult238 );
			float4 glow_colorg211 = ( _GlowColor * temp_output_234_0 );
			float glow_val219 = temp_output_234_0;
			float4 lerpResult237 = lerp( emission134 , glow_colorg211 , glow_val219);
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV1_g8 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode1_g8 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV1_g8, _FresnelPower ) );
			float temp_output_220_0 = saturate( fresnelNode1_g8 );
			float4 fresnel_color8 = ( temp_output_220_0 * _FresnelColor );
			float fresnel_val172 = temp_output_220_0;
			float4 lerpResult175 = lerp( lerpResult237 , fresnel_color8 , saturate( fresnel_val172 ));
			float4 dissolve_color5_g73 = ( _DissolveColor * temp_output_30_0_g73 );
			o.Emission = (( mask_appear6_g73 > _DissolveAmount ) ? lerpResult175 :  dissolve_color5_g73 ).rgb;
			float2 temp_cast_2 = (_Scan).xx;
			float2 Scan35 = step( frac( ( ( _ScanTiling * ase_worldPos.y ) + ( _Time.y * _ScanSpeed ) ) ) , temp_cast_2 );
			float4 Flicker72 = tex2D( _FlickerTexture, ( _Time.y * _FlickerSpeed ) );
			float4 Opacity149 = ( float4( lerp(( Scan35 + glow_val219 ),( Scan35 * glow_val219 ),_UseGlowOpacity), 0.0 , 0.0 ) * Flicker72 );
			o.Alpha = ( saturate( lerp(Opacity149,( Opacity149 * fresnel_val172 ),_UseFresnelOpacity) ) * _OpacityPower ).r;
			clip( mask_appear6_g73 - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16500
7;166;1278;877;517.5912;-42.51221;2.048203;True;False
Node;AmplifyShaderEditor.CommentaryNode;48;-2569.847,1032.729;Float;False;1789.742;679.3903;Comment;16;63;64;52;53;54;55;51;209;210;211;217;219;233;234;238;239;Glow;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;53;-2512.677,1178.349;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;51;-2522.948,1095.463;Float;False;Property;_GlowTiling;Glow Tiling;3;0;Create;True;0;0;False;0;2;3;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;52;-2520.131,1371.512;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;217;-2483.624,1527.648;Float;False;Property;_GlowSpeed;Glow Speed;5;0;Create;True;0;0;False;0;0;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;45;-1820.209,-152.4088;Float;False;1394.875;636.1515;Comment;11;35;34;33;43;31;32;30;26;29;28;24;Scan;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-2272.896,1462.498;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-2206.01,1157.576;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1788.83,-100.5544;Float;False;Property;_ScanTiling;Scan Tiling;7;0;Create;True;0;0;False;0;3.60764;38.1;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;29;-1788.83,139.4456;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;26;-1788.83,299.4457;Float;False;Property;_ScanSpeed;Scan Speed;8;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WorldPosInputsNode;28;-1788.83,-20.55432;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;64;-1998.348,1302.564;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-1498.83,-34.55432;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;63;-1869.257,1301.83;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;32;-1516.83,283.4457;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;233;-1705.533,1300.61;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-1276.83,75.44569;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;239;-1882.396,1586.012;Float;False;Property;_GlowSize;Glow Size;18;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;238;-1563.396,1303.012;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;67;-1385.017,578.2517;Float;False;1145.839;404.78;Comment;5;72;70;68;69;71;Flicker;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-1244.83,315.4457;Float;False;Property;_Scan;Scan;6;0;Create;True;0;0;False;0;0.7926539;0.56;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;33;-1148.83,75.44569;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;69;-1334.387,818.4026;Float;False;Property;_FlickerSpeed;Flicker Speed;10;0;Create;True;0;0;False;0;0.1,0.1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TimeNode;70;-1354.858,652.6708;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;234;-1386.533,1299.61;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;34;-892.8307,75.44569;Float;True;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-1079.2,743.3587;Float;True;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;219;-1016.5,1303.95;Float;False;glow_val;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;-640.8304,68.54557;Float;False;Scan;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;-63.60762,450.9254;Float;False;219;glow_val;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;-63.26923,370.7632;Float;False;35;Scan;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;68;-821.6207,715.4508;Float;True;Property;_FlickerTexture;Flicker Texture;9;0;Create;True;0;0;False;0;None;1f9c984b9ac6466fa2c2c4a935b43930;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;179.2799,418.5257;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;240;196.4013,306.5274;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;72;-452.7246,716.2137;Float;False;Flicker;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;168;-371.5799,-601.2195;Float;False;769.0178;434.2314;;4;132;131;134;133;Emission;1,1,1,1;0;0
Node;AmplifyShaderEditor.ToggleSwitchNode;241;330.3557,389.8206;Float;False;Property;_UseGlowOpacity;Use Glow Opacity;15;0;Create;True;0;0;False;0;0;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;73;327.664,522.4269;Float;False;72;Flicker;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;209;-1405.988,1081.449;Float;False;Property;_GlowColor;Glow Color;4;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.8826571,0.3455874,1,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;131;-338.5438,-547.3767;Float;True;Property;_EmissionTexture;Emission Texture;2;0;Create;True;0;0;False;0;None;e672066926df45bd96c6983eebb6b169;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;132;-254.7276,-346.4791;Float;False;Property;_EmissionColor;Emission Color;1;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.77221,0.3529399,1.5,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;220;-339.8762,-84.12777;Float;False;QFX Get Fresnel;12;;8;0a832704e6daa5244b3db55d16dfb317;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;242;553.8403,401.8755;Float;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;1;-372.5782,-128.1208;Float;False;641.2316;392.2466;;4;8;167;166;172;Fresnel;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;166;-338.0693,-8.384624;Float;False;Property;_FresnelColor;Fresnel Color;11;1;[HDR];Create;True;0;0;False;0;1,1,1,1;0.1102929,1.206389,3.000003,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;149;698.8139,394.4391;Float;True;Opacity;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;210;-1154.988,1177.449;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;133;1.744608,-417.2962;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;172;59.70565,126.8321;Float;False;fresnel_val;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;150;476.6146,1182.349;Float;False;149;Opacity;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;167;-66.0172,-25.79201;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;211;-1010.839,1173.035;Float;False;glow_colorg;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;173;406.0053,1324.265;Float;False;172;fresnel_val;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;134;179.7441,-423.038;Float;False;emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;226;68.35352,863.4203;Float;False;219;glow_val;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;170;613.4037,1305.526;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;225;53.35352,782.4203;Float;False;211;glow_colorg;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;224;77.35352,703.4203;Float;False;134;emission;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;176;395.4203,1095.274;Float;False;172;fresnel_val;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;69.98251,-29.33241;Float;False;fresnel_color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;155;-663.7959,1120.956;Float;False;Property;_GlitchOffset;Glitch Offset;17;0;Create;True;0;0;False;0;0,0,0;-0.02,-0.02,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;208;-695.6877,1294.305;Float;False;QFX Get Simple Glitch;20;;29;bb16914625242fb46ba2e0385c26d46a;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;18;549.2241,969.6487;Float;False;8;fresnel_color;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;198;-432.5253,1248.009;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;177;595.6434,1101.172;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;237;587.6653,738.9188;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;171;751.589,1182.756;Float;False;Property;_UseFresnelOpacity;Use Fresnel Opacity;16;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;87;-233.5562,1244.003;Float;True;VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;174;984.6907,1184.59;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;244;892.9824,1320.75;Float;False;Property;_OpacityPower;Opacity Power;19;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;175;857.9542,949.403;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;235;311.8109,713.9061;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;313;1214.079,984.5399;Float;False;QFX Get Simple Dissolve;23;;73;21c72553f54e0544991259e08d1b7efa;0;1;10;COLOR;0,0,0,0;False;2;COLOR;0;FLOAT;12
Node;AmplifyShaderEditor.GetLocalVarNode;88;1332.299,1381.479;Float;False;87;VertexOffset;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;243;1171.982,1184.75;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;129;1680.799,992.8266;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;QFX/SFX/Hologram/HologramDissolve;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;TransparentCutout;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;54;0;52;2
WireConnection;54;1;217;0
WireConnection;55;0;51;0
WireConnection;55;1;53;2
WireConnection;64;0;55;0
WireConnection;64;1;54;0
WireConnection;30;0;24;0
WireConnection;30;1;28;2
WireConnection;63;0;64;0
WireConnection;32;0;29;2
WireConnection;32;1;26;0
WireConnection;233;0;63;0
WireConnection;31;0;30;0
WireConnection;31;1;32;0
WireConnection;238;0;233;0
WireConnection;238;2;239;0
WireConnection;33;0;31;0
WireConnection;234;0;238;0
WireConnection;34;0;33;0
WireConnection;34;1;43;0
WireConnection;71;0;70;2
WireConnection;71;1;69;0
WireConnection;219;0;234;0
WireConnection;35;0;34;0
WireConnection;68;1;71;0
WireConnection;62;0;38;0
WireConnection;62;1;61;0
WireConnection;240;0;38;0
WireConnection;240;1;61;0
WireConnection;72;0;68;0
WireConnection;241;0;240;0
WireConnection;241;1;62;0
WireConnection;242;0;241;0
WireConnection;242;1;73;0
WireConnection;149;0;242;0
WireConnection;210;0;209;0
WireConnection;210;1;234;0
WireConnection;133;0;131;0
WireConnection;133;1;132;0
WireConnection;172;0;220;0
WireConnection;167;0;220;0
WireConnection;167;1;166;0
WireConnection;211;0;210;0
WireConnection;134;0;133;0
WireConnection;170;0;150;0
WireConnection;170;1;173;0
WireConnection;8;0;167;0
WireConnection;198;0;155;0
WireConnection;198;1;208;0
WireConnection;177;0;176;0
WireConnection;237;0;224;0
WireConnection;237;1;225;0
WireConnection;237;2;226;0
WireConnection;171;0;150;0
WireConnection;171;1;170;0
WireConnection;87;0;198;0
WireConnection;174;0;171;0
WireConnection;175;0;237;0
WireConnection;175;1;18;0
WireConnection;175;2;177;0
WireConnection;235;0;224;0
WireConnection;235;1;226;0
WireConnection;313;10;175;0
WireConnection;243;0;174;0
WireConnection;243;1;244;0
WireConnection;129;2;313;0
WireConnection;129;9;243;0
WireConnection;129;10;313;12
WireConnection;129;11;88;0
ASEEND*/
//CHKSM=5EFBA1B40C44882901CAB41049223783E53ADFDB