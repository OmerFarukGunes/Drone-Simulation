// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/SFX/Scanner/TopographicScanner"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_Power("Power", Range( 1 , 10)) = 0.5
		_ScanDistance("Scan Distance", Float) = 25
		_TrailColor("Trail Color", Color) = (0,0,0,0)
		_InnerColor("Inner Color", Color) = (0,0,0,0)
		_EdgeColor("Edge Color", Color) = (0,0,0,0)
		_GridColor("GridColor", Color) = (0,0,0,0)
		_EdgePower("Edge Power", Float) = 0
		_ScanWidth("Scan Width", Float) = 0
		_GridSize("Grid Size", Float) = 500
		[Toggle]_Invert("Invert", Float) = 0
		_WorldPosition("World Position", Vector) = (1,1,1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				float4 ase_texcoord4 : TEXCOORD4;
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float4 _TrailColor;
			uniform float4 _InnerColor;
			uniform float4 _EdgeColor;
			uniform float _Invert;
			uniform float _ScanDistance;
			UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
			uniform float4 _CameraDepthTexture_TexelSize;
			uniform float3 _WorldPosition;
			uniform float _ScanWidth;
			uniform float _EdgePower;
			uniform float _GridSize;
			uniform float4 _GridColor;
			uniform float _Power;
			float2 UnStereo( float2 UV )
			{
				#if UNITY_SINGLE_PASS_STEREO
				float4 scaleOffset = unity_StereoScaleOffset[ unity_StereoEyeIndex ];
				UV.xy = (UV.xy - scaleOffset.zw) / scaleOffset.xy;
				#endif
				return UV;
			}
			
			float3 InvertDepthDir72_g297( float3 In )
			{
				float3 result = In;
				#if !defined(ASE_SRP_VERSION) || ASE_SRP_VERSION <= 70301
				result *= float3(1,1,-1);
				#endif
				return result;
			}
			
			float CanScan354( float CurrentDistance, float ScanDistance, float ScanWidth )
			{
				if (CurrentDistance > ScanDistance - ScanWidth && CurrentDistance < ScanDistance)
				return 1;
				else return 0;
			}
			


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord4 = screenPos;
				
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float2 uv_MainTex = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 Main466 = tex2D( _MainTex, uv_MainTex );
				float ScanDistance272 = _ScanDistance;
				float4 screenPos = i.ase_texcoord4;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 UV22_g298 = ase_screenPosNorm.xy;
				float2 localUnStereo22_g298 = UnStereo( UV22_g298 );
				float2 break64_g297 = localUnStereo22_g298;
				float clampDepth69_g297 = SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy );
				#ifdef UNITY_REVERSED_Z
				float staticSwitch38_g297 = ( 1.0 - clampDepth69_g297 );
				#else
				float staticSwitch38_g297 = clampDepth69_g297;
				#endif
				float3 appendResult39_g297 = (float3(break64_g297.x , break64_g297.y , staticSwitch38_g297));
				float4 appendResult42_g297 = (float4((appendResult39_g297*2.0 + -1.0) , 1.0));
				float4 temp_output_43_0_g297 = mul( unity_CameraInvProjection, appendResult42_g297 );
				float3 temp_output_46_0_g297 = ( (temp_output_43_0_g297).xyz / (temp_output_43_0_g297).w );
				float3 In72_g297 = temp_output_46_0_g297;
				float3 localInvertDepthDir72_g297 = InvertDepthDir72_g297( In72_g297 );
				float4 appendResult49_g297 = (float4(localInvertDepthDir72_g297 , 1.0));
				float Distance254 = length( ( mul( unity_CameraToWorld, appendResult49_g297 ) - float4( _WorldPosition , 0.0 ) ) );
				float ScanWidth269 = _ScanWidth;
				float temp_output_321_0 = ( ( ScanDistance272 - Distance254 ) / ScanWidth269 );
				float d333 = (( _Invert )?( temp_output_321_0 ):( ( 1.0 - temp_output_321_0 ) ));
				float4 lerpResult231 = lerp( _InnerColor , _EdgeColor , saturate( pow( d333 , _EdgePower ) ));
				float4 EdgeAndInner283 = lerpResult231;
				float4 lerpResult233 = lerp( _TrailColor , EdgeAndInner283 , d333);
				float4 EmissionWithTrail286 = lerpResult233;
				float2 texCoord248 = i.uv.xy * float2( 1,1 ) + float2( 0,0 );
				float4 FullEmission276 = ( ( EmissionWithTrail286 + ( frac( ( texCoord248.y * _GridSize ) ) * _GridColor ) ) * d333 );
				float CurrentDistance354 = Distance254;
				float ScanDistance354 = ScanDistance272;
				float ScanWidth354 = ScanWidth269;
				float localCanScan354 = CanScan354( CurrentDistance354 , ScanDistance354 , ScanWidth354 );
				float CanScan374 = localCanScan354;
				float4 lerpResult361 = lerp( float4(0,0,0,0) , FullEmission276 , CanScan374);
				float FinalPower263 = _Power;
				float4 ResultEmission357 = ( lerpResult361 * FinalPower263 );
				

				finalColor = ( Main466 + ResultEmission357 );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18800
0;523.2;1259;270;-2205.921;1277.369;1.672055;True;False
Node;AmplifyShaderEditor.CommentaryNode;260;-198.0923,-1469.356;Inherit;False;1296.108;523.6191;;4;254;35;214;39;Distance;0.5147059,0.5147059,0.5147059,1;0;0
Node;AmplifyShaderEditor.FunctionNode;492;-63.8911,-1346.616;Inherit;False;Reconstruct World Position From Depth;-1;;297;e7094bcbcc80eb140b2a3dbe6a861de8;0;0;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector3Node;39;113.532,-1256.296;Float;False;Property;_WorldPosition;World Position;30;0;Create;True;0;0;0;False;0;False;1,1,1;0.13,1.192093E-07,1.76;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;214;331.0686,-1345.891;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LengthOpNode;35;532.6617,-1346.092;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;209;1179.724,-559.0404;Float;False;Property;_ScanDistance;Scan Distance;21;0;Create;True;0;0;0;False;0;False;25;12.02565;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;262;1163.118,-1483.29;Inherit;False;1613.54;637.3947;;11;368;333;367;327;321;329;374;354;271;278;275;Scan Value;0.5147059,0.5147059,0.5147059,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;272;1405.43,-559.6408;Float;False;ScanDistance;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;254;682.9337,-1351.197;Float;False;Distance;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;224;1176.401,-671.2173;Float;False;Property;_ScanWidth;Scan Width;27;0;Create;True;0;0;0;False;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;269;1436.095,-670.6228;Float;False;ScanWidth;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;275;1207.187,-1145.065;Inherit;False;272;ScanDistance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;278;1208.752,-1243.797;Inherit;False;254;Distance;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;329;1682.913,-1062.366;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;271;1211.967,-1047.735;Inherit;False;269;ScanWidth;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;321;1837.39,-1060.981;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;327;1986.607,-1057.502;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;368;2027.989,-954.638;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;367;2173.432,-1063.153;Float;False;Property;_Invert;Invert;29;0;Create;True;0;0;0;False;0;False;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;122;2909.676,-1493.495;Inherit;False;1883.25;1969.539;;30;357;332;361;267;360;375;276;359;348;349;244;286;251;250;233;243;291;225;285;283;284;231;288;248;223;222;230;308;226;499;Scan Emission;0.75,0.75,0.75,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;333;2435.219,-1062.298;Float;False;d;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;226;3019.588,-102.973;Float;False;Property;_EdgePower;Edge Power;26;0;Create;True;0;0;0;False;0;False;0;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;308;3025.647,-199.9959;Inherit;False;333;d;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;230;3188.196,-152.4349;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;222;3065.386,-542.3717;Float;False;Property;_InnerColor;Inner Color;23;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.2720587,0.5481745,1,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;499;3358.125,-170.0919;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;223;3066.79,-373.3684;Float;False;Property;_EdgeColor;Edge Color;24;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0.2965516,1,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;231;3546.894,-389.1734;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;283;3733.896,-395.2249;Float;False;EdgeAndInner;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;288;3266.157,-790.4128;Float;False;Property;_GridSize;Grid Size;28;0;Create;True;0;0;0;False;0;False;500;200;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;248;3267.082,-921.3383;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;291;3523.301,-876.5323;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;500;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;285;2923.043,-967.7045;Inherit;False;333;d;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;284;2954.043,-1090.705;Inherit;False;283;EdgeAndInner;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;225;2970.967,-1279.392;Float;False;Property;_TrailColor;Trail Color;22;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,0,0,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FractNode;243;3678.466,-876.8101;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;250;3520.048,-765.0913;Float;False;Property;_GridColor;GridColor;25;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.2794118,0.2794118,0.2794118,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;233;3275.967,-1160.979;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;251;3825.403,-878.2657;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;286;3461.333,-1166.169;Float;False;EmissionWithTrail;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;244;4077.869,-903.062;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;349;4048.833,-638.05;Inherit;False;333;d;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;354;1638.826,-1343.718;Float;False;if (CurrentDistance > ScanDistance - ScanWidth && CurrentDistance < ScanDistance)$return 1@$else return 0@;1;False;3;False;CurrentDistance;FLOAT;0;In;;Float;False;False;ScanDistance;FLOAT;0;In;;Float;False;False;ScanWidth;FLOAT;0;In;;Float;False;CanScan;True;False;0;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;348;4234.832,-904.05;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;374;1906.958,-1348.607;Float;False;CanScan;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;145;1173.584,-787.5129;Float;False;Property;_Power;Power;20;0;Create;True;0;0;0;False;0;False;0.5;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;276;4457.55,-916.1563;Float;False;FullEmission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;375;3695.542,116.1128;Inherit;False;374;CanScan;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;359;3679.517,4.222103;Inherit;False;276;FullEmission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;263;1484.452,-788.3406;Float;False;FinalPower;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;360;3675.11,-177.1058;Float;False;Constant;_Color0;Color 0;27;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;464;1187.287,-401.336;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;267;4065.895,140.1607;Inherit;False;263;FinalPower;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;361;3960.977,-64.83894;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;332;4268.518,-63.97078;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;465;1335.141,-404.773;Inherit;True;Property;_TextureSample0;Texture Sample 0;15;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;268;1189.597,12.13453;Inherit;False;1071.459;423.3039;;9;401;460;469;183;458;351;436;486;488;Blending;0.5147059,0.5147059,0.5147059,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;357;4487.827,-67.68011;Float;False;ResultEmission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;466;1628.141,-404.773;Float;False;Main;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;485;-514.5173,-317.4272;Inherit;False;1564.685;891.1016;;12;477;480;478;476;479;474;475;484;472;470;483;487;Sobel;0.4117647,0.4117647,0.4117647,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;183;1217.762,73.11197;Inherit;False;466;Main;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;351;1221.543,175.026;Inherit;False;357;ResultEmission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;475;-443.9747,-66.74876;Float;False;Property;_SobelTiling;Sobel Tiling;19;0;Create;True;0;0;0;False;0;False;0;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;478;53.73736,102.7241;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;488;1554.436,357.5637;Inherit;False;487;Sobel;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;476;-179.0738,-157.9798;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;479;576.6359,43.40811;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;474;-453.9051,-246.7384;Inherit;False;0;0;_MainTex_TexelSize;Pass;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;486;1752.55,322.181;Float;False;Property;_Sobel;Sobel;17;0;Create;True;0;0;0;False;0;False;1;2;0;COLOR;0,0,0,0;False;1;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;470;316.1526,-40.28841;Inherit;False;SobelMain;0;;299;481788033fe47cd4893d0d4673016cbc;0;4;2;FLOAT;50;False;3;FLOAT;50;False;4;FLOAT2;0,0;False;1;SAMPLER2D;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;497;1519.461,78.34349;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;460;1813.533,113.9953;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;487;805.4736,38.33318;Float;False;Sobel;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;483;100.1604,449.1251;Inherit;False;374;CanScan;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;469;1544.168,209.6903;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;484;384.3349,181.6842;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;472;-279.4445,14.98946;Inherit;False;0;0;_MainTex;Shader;False;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;477;-14.92818,-158.9142;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ColorNode;480;62.62209,269.4274;Float;False;Property;_SobelColor;Sobel Color;18;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;1,0.5586207,0,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;436;1217.762,265.1118;Inherit;False;333;d;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;458;1410.746,327.8315;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;401;1989.796,73.07061;Float;False;True;-1;2;ASEMaterialInspector;0;2;QFX/SFX/Scanner/TopographicScanner;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;214;0;492;0
WireConnection;214;1;39;0
WireConnection;35;0;214;0
WireConnection;272;0;209;0
WireConnection;254;0;35;0
WireConnection;269;0;224;0
WireConnection;329;0;275;0
WireConnection;329;1;278;0
WireConnection;321;0;329;0
WireConnection;321;1;271;0
WireConnection;327;0;321;0
WireConnection;368;0;321;0
WireConnection;367;0;327;0
WireConnection;367;1;368;0
WireConnection;333;0;367;0
WireConnection;230;0;308;0
WireConnection;230;1;226;0
WireConnection;499;0;230;0
WireConnection;231;0;222;0
WireConnection;231;1;223;0
WireConnection;231;2;499;0
WireConnection;283;0;231;0
WireConnection;291;0;248;2
WireConnection;291;1;288;0
WireConnection;243;0;291;0
WireConnection;233;0;225;0
WireConnection;233;1;284;0
WireConnection;233;2;285;0
WireConnection;251;0;243;0
WireConnection;251;1;250;0
WireConnection;286;0;233;0
WireConnection;244;0;286;0
WireConnection;244;1;251;0
WireConnection;354;0;278;0
WireConnection;354;1;275;0
WireConnection;354;2;271;0
WireConnection;348;0;244;0
WireConnection;348;1;349;0
WireConnection;374;0;354;0
WireConnection;276;0;348;0
WireConnection;263;0;145;0
WireConnection;361;0;360;0
WireConnection;361;1;359;0
WireConnection;361;2;375;0
WireConnection;332;0;361;0
WireConnection;332;1;267;0
WireConnection;465;0;464;0
WireConnection;357;0;332;0
WireConnection;466;0;465;0
WireConnection;478;2;472;0
WireConnection;476;0;474;0
WireConnection;476;1;475;0
WireConnection;479;0;470;0
WireConnection;479;1;484;0
WireConnection;486;1;488;0
WireConnection;470;2;477;0
WireConnection;470;3;477;1
WireConnection;470;4;478;0
WireConnection;470;1;472;0
WireConnection;497;0;183;0
WireConnection;497;1;351;0
WireConnection;460;0;183;0
WireConnection;460;1;351;0
WireConnection;460;2;469;0
WireConnection;460;3;486;0
WireConnection;487;0;479;0
WireConnection;469;0;351;0
WireConnection;469;1;436;0
WireConnection;484;1;480;0
WireConnection;484;2;483;0
WireConnection;477;0;476;0
WireConnection;458;0;436;0
WireConnection;401;0;497;0
ASEEND*/
//CHKSM=5CB061DBABB8D9BC82EF39F62EF505AA4C609CB1