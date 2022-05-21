// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MK4/Rain Paralax"
{
	Properties
	{
		_Color("Color", Color) = (0.5807742,0.7100198,0.9632353,0)
		_Albedo("Albedo", 2D) = "white" {}
		_NormalMap("Normal Map", 2D) = "bump" {}
		_Height("Height", 2D) = "white" {}
		_AO("AO", 2D) = "white" {}
		_SpecularGloss("Specular Gloss", 2D) = "white" {}
		_Specular("Specular", Range( 0 , 1)) = 0.5
		_Smoothness("Smoothness", Range( 0 , 1)) = 0.5
		_RainMask("Rain Mask", Range( 0 , 1)) = 0.5
		_RainDropsNormal("RainDrops Normal", 2D) = "bump" {}
		_Raindropsint("Raindrops  int", Range( 0 , 5)) = 0
		_RaindropsUVTile("Raindrops UV Tile", Range( 0 , 1)) = 0
		_RainSpeed("Rain Speed", Range( 0 , 50)) = 0
		_WaveNormal("Wave Normal", 2D) = "bump" {}
		_WaveNormalint("Wave Normal int", Range( 0 , 5)) = 0
		_WaveSpeed("Wave Speed", Range( 0 , 1)) = 0
		_WaveUVTile("Wave UV Tile", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[Header(Parallax Occlusion Mapping)]
		_CurvFix("Curvature Bias", Range( 0 , 1)) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		ZTest LEqual
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
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
			float2 uv_texcoord;
			float3 viewDir;
			INTERNAL_DATA
			float3 worldNormal;
			float3 worldPos;
		};

		uniform sampler2D _NormalMap;
		uniform sampler2D _RainDropsNormal;
		uniform float4 _RainDropsNormal_ST;
		uniform sampler2D _Height;
		uniform float4 _Height_ST;
		uniform float _CurvFix;
		uniform float4 0_ST;
		uniform float _Raindropsint;
		uniform float _RaindropsUVTile;
		uniform float _RainSpeed;
		uniform sampler2D _WaveNormal;
		uniform float _WaveNormalint;
		uniform float _WaveSpeed;
		uniform float _WaveUVTile;
		uniform sampler2D _SpecularGloss;
		uniform float _RainMask;
		uniform float4 _Color;
		uniform sampler2D _Albedo;
		uniform float _Specular;
		uniform float _Smoothness;
		uniform sampler2D _AO;


		inline float2 POM( sampler2D heightMap, float2 uvs, float2 dx, float2 dy, float3 normalWorld, float3 viewWorld, float3 viewDirTan, int minSamples, int maxSamples, float parallax, float refPlane, float2 tilling, float2 curv, int index )
		{
			float3 result = 0;
			int stepIndex = 0;
			int numSteps = ( int )lerp( (float)maxSamples, (float)minSamples, saturate( dot( normalWorld, viewWorld ) ) );
			float layerHeight = 1.0 / numSteps;
			float2 plane = parallax * ( viewDirTan.xy / viewDirTan.z );
			uvs += refPlane * plane;
			float2 deltaTex = -plane * layerHeight;
			float2 prevTexOffset = 0;
			float prevRayZ = 1.0f;
			float prevHeight = 0.0f;
			float2 currTexOffset = deltaTex;
			float currRayZ = 1.0f - layerHeight;
			float currHeight = 0.0f;
			float intersection = 0;
			float2 finalTexOffset = 0;
			while ( stepIndex < numSteps + 1 )
			{
				result.z = dot( curv, currTexOffset * currTexOffset );
				currHeight = tex2Dgrad( heightMap, uvs + currTexOffset, dx, dy ).r * ( 1 - result.z );
				if ( currHeight > currRayZ )
				{
					stepIndex = numSteps + 1;
				}
				else
				{
					stepIndex++;
					prevTexOffset = currTexOffset;
					prevRayZ = currRayZ;
					prevHeight = currHeight;
					currTexOffset += deltaTex;
					currRayZ -= layerHeight * ( 1 - result.z ) * (1+_CurvFix);
				}
			}
			int sectionSteps = 10;
			int sectionIndex = 0;
			float newZ = 0;
			float newHeight = 0;
			while ( sectionIndex < sectionSteps )
			{
				intersection = ( prevHeight - prevRayZ ) / ( prevHeight - currHeight + currRayZ - prevRayZ );
				finalTexOffset = prevTexOffset + intersection * deltaTex;
				newZ = prevRayZ - intersection * layerHeight;
				newHeight = tex2Dgrad( heightMap, uvs + finalTexOffset, dx, dy ).r;
				if ( newHeight > newZ )
				{
					currTexOffset = finalTexOffset;
					currHeight = newHeight;
					currRayZ = newZ;
					deltaTex = intersection * deltaTex;
					layerHeight = intersection * layerHeight;
				}
				else
				{
					prevTexOffset = finalTexOffset;
					prevHeight = newHeight;
					prevRayZ = newZ;
					deltaTex = ( 1 - intersection ) * deltaTex;
					layerHeight = ( 1 - intersection ) * layerHeight;
				}
				sectionIndex++;
			}
			#ifdef UNITY_PASS_SHADOWCASTER
			if ( unity_LightShadowBias.z == 0.0 )
			{
			#endif
				if ( result.z > 1 )
					clip( -1 );
			#ifdef UNITY_PASS_SHADOWCASTER
			}
			#endif
			return uvs + finalTexOffset;
		}


		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_RainDropsNormal = i.uv_texcoord * _RainDropsNormal_ST.xy + _RainDropsNormal_ST.zw;
			float2 uv_Height = i.uv_texcoord * _Height_ST.xy + _Height_ST.zw;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float2 OffsetPOM272 = POM( 0, uv_RainDropsNormal, ddx(uv_RainDropsNormal), ddy(uv_RainDropsNormal), ase_worldNormal, ase_worldViewDir, i.viewDir, 128, 128, 0.02, 0, 0_ST.xy, float2(10,0), 0 );
			float2 temp_output_273_0 = ddx( uv_RainDropsNormal );
			float2 temp_output_274_0 = ddy( uv_RainDropsNormal );
			float3 tex2DNode137 = UnpackNormal( tex2D( _NormalMap, OffsetPOM272, temp_output_273_0, temp_output_274_0 ) );
			float temp_output_254_0 = (0.05 + (_RaindropsUVTile - 0.0) * (3.0 - 0.05) / (1.0 - 0.0));
			float2 appendResult75 = (float2(frac( ( ase_worldPos.x * temp_output_254_0 ) ) , frac( ( ase_worldPos.z * temp_output_254_0 ) )));
			// *** BEGIN Flipbook UV Animation vars ***
			// Total tiles of Flipbook Texture
			float fbtotaltiles4 = 8.0 * 8.0;
			// Offsets for cols and rows of Flipbook Texture
			float fbcolsoffset4 = 1.0f / 8.0;
			float fbrowsoffset4 = 1.0f / 8.0;
			// Speed of animation
			float fbspeed4 = _Time[ 1 ] * _RainSpeed;
			// UV Tiling (col and row offset)
			float2 fbtiling4 = float2(fbcolsoffset4, fbrowsoffset4);
			// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
			// Calculate current tile linear index
			float fbcurrenttileindex4 = round( fmod( fbspeed4 + 0.0, fbtotaltiles4) );
			fbcurrenttileindex4 += ( fbcurrenttileindex4 < 0) ? fbtotaltiles4 : 0;
			// Obtain Offset X coordinate from current tile linear index
			float fblinearindextox4 = round ( fmod ( fbcurrenttileindex4, 8.0 ) );
			// Multiply Offset X by coloffset
			float fboffsetx4 = fblinearindextox4 * fbcolsoffset4;
			// Obtain Offset Y coordinate from current tile linear index
			float fblinearindextoy4 = round( fmod( ( fbcurrenttileindex4 - fblinearindextox4 ) / 8.0, 8.0 ) );
			// Reverse Y to get tiles from Top to Bottom
			fblinearindextoy4 = (int)(8.0-1) - fblinearindextoy4;
			// Multiply Offset Y by rowoffset
			float fboffsety4 = fblinearindextoy4 * fbrowsoffset4;
			// UV Offset
			float2 fboffset4 = float2(fboffsetx4, fboffsety4);
			// Flipbook UV
			half2 fbuv4 = appendResult75 * fbtiling4 + fboffset4;
			// *** END Flipbook UV Animation vars ***
			float temp_output_241_0 = ( _Time.y * (0.0 + (_WaveSpeed - 0.0) * (2.0 - 0.0) / (1.0 - 0.0)) );
			float2 appendResult183 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 panner245 = ( temp_output_241_0 * float2( 0.27,-0.25 ) + appendResult183);
			float temp_output_222_0 = (0.05 + (_WaveUVTile - 0.0) * (3.0 - 0.05) / (1.0 - 0.0));
			float2 panner231 = ( temp_output_241_0 * float2( -0.15,-0.23 ) + appendResult183);
			float2 panner91 = ( temp_output_241_0 * float2( 0.18,0.2 ).x + appendResult183);
			float4 tex2DNode210 = tex2D( _SpecularGloss, OffsetPOM272, temp_output_273_0, temp_output_274_0 );
			float clampResult228 = clamp( ((-1.0 + (_RainMask - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) + (tex2DNode210.a - 0.0) * (1.0 - (-1.0 + (_RainMask - 0.0) * (1.0 - -1.0) / (1.0 - 0.0))) / (1.0 - 0.0)) , 0.0 , 1.0 );
			float3 lerpResult88 = lerp( tex2DNode137 , BlendNormals( tex2DNode137 , ( UnpackScaleNormal( tex2D( _RainDropsNormal, fbuv4 ), _Raindropsint ) + ( UnpackScaleNormal( tex2D( _WaveNormal, ( panner245 * temp_output_222_0 ) ), _WaveNormalint ) + UnpackScaleNormal( tex2D( _WaveNormal, ( ( panner231 * float2( 0.9,0.9 ) ) * temp_output_222_0 ) ), _WaveNormalint ) + UnpackScaleNormal( tex2D( _WaveNormal, ( panner91 * temp_output_222_0 ) ), _WaveNormalint ) ) ) ) , clampResult228);
			float3 normalizeResult249 = normalize( lerpResult88 );
			o.Normal = normalizeResult249;
			float4 lerpResult120 = lerp( float4( 1,1,1,0 ) , _Color , clampResult228);
			o.Albedo = ( lerpResult120 * tex2D( _Albedo, OffsetPOM272, temp_output_273_0, temp_output_274_0 ) ).rgb;
			float clampResult214 = clamp( ((-1.0 + (_Specular - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) + (tex2DNode210.r - 0.0) * ((0.0 + (_Specular - 0.0) * (2.0 - 0.0) / (1.0 - 0.0)) - (-1.0 + (_Specular - 0.0) * (1.0 - -1.0) / (1.0 - 0.0))) / (1.0 - 0.0)) , 0.0 , 1.0 );
			float3 temp_cast_5 = (clampResult214).xxx;
			o.Specular = temp_cast_5;
			float clampResult212 = clamp( ((-1.0 + (_Smoothness - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) + (tex2DNode210.a - 0.0) * (1.0 - (-1.0 + (_Smoothness - 0.0) * (1.0 - -1.0) / (1.0 - 0.0))) / (1.0 - 0.0)) , 0.0 , 1.0 );
			o.Smoothness = clampResult212;
			o.Occlusion = tex2D( _AO, OffsetPOM272, temp_output_273_0, temp_output_274_0 ).r;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular keepalpha fullforwardshadows 

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
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
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
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
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
538;158;1338;786;3611.058;784.786;1.437621;True;True
Node;AmplifyShaderEditor.RangedFloatNode;240;-1850.364,1102.581;Float;False;Property;_WaveSpeed;Wave Speed;15;0;Create;True;0;0;False;0;0;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;207;-1740.444,-145.1366;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TimeNode;108;-1607.632,931.8244;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;239;-1562.2,1087.039;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;253;-1880.981,-388.4875;Float;False;Property;_RaindropsUVTile;Raindrops UV Tile;11;0;Create;True;0;0;False;0;0;0.4;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;183;-1563.946,104.9836;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;235;-1279.325,732.469;Float;False;Constant;_WaveUV2;Wave UV2;12;0;Create;True;0;0;False;0;-0.15,-0.23;-0.15,-0.25;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TFHCRemapNode;254;-1590.733,-361.693;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.05;False;4;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;241;-1382.023,1016.797;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;231;-1043.139,720.2559;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;252;-1469.608,-87.20174;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;223;-1267.693,1199.14;Float;False;Property;_WaveUVTile;Wave UV Tile;16;0;Create;True;0;0;False;0;0;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;232;-1276.196,860.0075;Float;False;Constant;_WaveUV1;Wave UV1;13;0;Create;True;0;0;False;0;0.18,0.2;0.1,0.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;246;-1277.963,514.2607;Float;False;Constant;_Vector0;Vector 0;12;0;Create;True;0;0;False;0;0.27,-0.25;-0.15,-0.25;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;251;-1472.912,-184.8229;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;236;-864.3458,727.386;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.9,0.9;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;245;-1039.81,550.4917;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FractNode;73;-1217.356,-275.8096;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;74;-1211.876,-194.9783;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;222;-970.9551,1104.245;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.05;False;4;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;91;-1038.328,841.2997;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT;0.1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;259;-3373.422,-652.6331;Float;True;Property;_Height;Height;3;0;Create;True;0;0;False;0;None;45326aac6945e5d418402dbea19fe6ed;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;268;-2977.792,-328.7822;Float;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;221;-701.4404,982.7373;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;271;-3016.392,-682.8821;Float;False;0;11;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;237;-675.1719,834.9395;Float;False;Property;_WaveNormalint;Wave Normal int;14;0;Create;True;0;0;False;0;0;0.1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;234;-725.8802,722.6469;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;247;-734.5847,592.1376;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;238;-623.578,384.2714;Float;True;Property;_WaveNormal;Wave Normal;13;0;Create;True;0;0;False;0;None;20e16ccd543ebdf4fbc4a9bcb13374b1;True;bump;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.DynamicAppendNode;75;-983.6446,-257.4715;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-923.3141,-60.89006;Float;False;Property;_RainSpeed;Rain Speed;12;0;Create;True;0;0;False;0;0;33;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;229;-551.9796,-773.2418;Float;False;Property;_RainMask;Rain Mask;8;0;Create;True;0;0;False;0;0.5;0.42;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;230;-341.8411,729.6231;Float;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;False;0;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ParallaxOcclusionMappingNode;272;-2714.692,-541.8822;Float;False;0;128;False;-1;128;False;-1;10;0.02;0;False;1,1;True;10,0;Texture2D;7;0;FLOAT2;0,0;False;1;SAMPLER2D;;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT2;0,0;False;6;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;102;-340.1845,927.4704;Float;True;Property;_WaterNormal;Water Normal;6;0;Create;True;0;0;False;0;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;4;-577.3209,-222.5767;Float;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;8;False;2;FLOAT;8;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;250;-571.3339,32.2523;Float;False;Property;_Raindropsint;Raindrops  int;10;0;Create;True;0;0;False;0;0;1.65;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.DdxOpNode;273;-935.9242,-1107.184;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;244;-341.8859,523.6908;Float;True;Property;_TextureSample1;Texture Sample 1;5;0;Create;True;0;0;False;0;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DdyOpNode;274;-935.9242,-1043.184;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;248;335.8223,196.254;Float;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;210;-356.2476,-1052.466;Float;True;Property;_SpecularGloss;Specular Gloss;5;0;Create;True;0;0;False;0;None;581a7e49b397a704d8841074bfe6c410;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;11;-135.3428,-38.99204;Float;True;Property;_RainDropsNormal;RainDrops Normal;9;0;Create;True;0;0;False;0;None;fd09dc3c530e8654dacba5a7ee36cb20;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;226;-219.4937,-761.6447;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;126;461.6678,-33.37104;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;220;-209.7496,-1163.032;Float;False;Property;_Specular;Specular;6;0;Create;True;0;0;False;0;0.5;0.42;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;137;-97.0103,-272.5109;Float;True;Property;_NormalMap;Normal Map;2;0;Create;True;0;0;False;0;None;bdfb4b25c81ed2249928d91feb229774;True;0;True;bump;Auto;True;Object;-1;Derivative;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;227;3.859527,-774.0189;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.8;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;216;-505.1732,-559.656;Float;False;Property;_Smoothness;Smoothness;7;0;Create;True;0;0;False;0;0.5;0.89;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;243;526.923,-189.0499;Float;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;228;184.7062,-764.761;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;218;113.4896,-1174.304;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;219;118.2222,-1019.957;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;119;183.4844,-1459.574;Float;False;Property;_Color;Color;0;0;Create;True;0;0;False;0;0.5807742,0.7100198,0.9632353,0;1,1,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;215;-193.0442,-568.278;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;120;475.216,-1298.346;Float;False;3;0;COLOR;1,1,1,0;False;1;COLOR;1,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;213;316.6418,-1166.876;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;66;-330.6409,-1360.836;Float;True;Property;_Albedo;Albedo;1;0;Create;True;0;0;False;0;None;d06db253870d7b44ea5a25661f1059ca;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;88;921.1825,-228.6158;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCRemapNode;211;7.196518,-561.9423;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.8;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;249;1084.586,-233.8844;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;214;511.1818,-1110.743;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;212;195.0841,-555.9862;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;255;267.6006,-443.9868;Float;True;Property;_AO;AO;4;0;Create;True;0;0;False;0;None;9ad9b03874286914f859a927b21c4fe5;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;121;651.6189,-1273.678;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1306.817,-390.812;Float;False;True;2;Float;ASEMaterialInspector;0;0;StandardSpecular;MK4/Rain Paralax;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;239;0;240;0
WireConnection;183;0;207;1
WireConnection;183;1;207;3
WireConnection;254;0;253;0
WireConnection;241;0;108;2
WireConnection;241;1;239;0
WireConnection;231;0;183;0
WireConnection;231;2;235;0
WireConnection;231;1;241;0
WireConnection;252;0;207;3
WireConnection;252;1;254;0
WireConnection;251;0;207;1
WireConnection;251;1;254;0
WireConnection;236;0;231;0
WireConnection;245;0;183;0
WireConnection;245;2;246;0
WireConnection;245;1;241;0
WireConnection;73;0;251;0
WireConnection;74;0;252;0
WireConnection;222;0;223;0
WireConnection;91;0;183;0
WireConnection;91;2;232;0
WireConnection;91;1;241;0
WireConnection;221;0;91;0
WireConnection;221;1;222;0
WireConnection;234;0;236;0
WireConnection;234;1;222;0
WireConnection;247;0;245;0
WireConnection;247;1;222;0
WireConnection;75;0;73;0
WireConnection;75;1;74;0
WireConnection;230;0;238;0
WireConnection;230;1;234;0
WireConnection;230;5;237;0
WireConnection;272;0;271;0
WireConnection;272;1;259;1
WireConnection;272;3;268;0
WireConnection;102;0;238;0
WireConnection;102;1;221;0
WireConnection;102;5;237;0
WireConnection;4;0;75;0
WireConnection;4;3;6;0
WireConnection;273;0;271;0
WireConnection;244;0;238;0
WireConnection;244;1;247;0
WireConnection;244;5;237;0
WireConnection;274;0;271;0
WireConnection;248;0;244;0
WireConnection;248;1;230;0
WireConnection;248;2;102;0
WireConnection;210;1;272;0
WireConnection;210;3;273;0
WireConnection;210;4;274;0
WireConnection;11;1;4;0
WireConnection;11;5;250;0
WireConnection;226;0;229;0
WireConnection;126;0;11;0
WireConnection;126;1;248;0
WireConnection;137;1;272;0
WireConnection;137;3;273;0
WireConnection;137;4;274;0
WireConnection;227;0;210;4
WireConnection;227;3;226;0
WireConnection;243;0;137;0
WireConnection;243;1;126;0
WireConnection;228;0;227;0
WireConnection;218;0;220;0
WireConnection;219;0;220;0
WireConnection;215;0;216;0
WireConnection;120;1;119;0
WireConnection;120;2;228;0
WireConnection;213;0;210;1
WireConnection;213;3;218;0
WireConnection;213;4;219;0
WireConnection;66;1;272;0
WireConnection;66;3;273;0
WireConnection;66;4;274;0
WireConnection;88;0;137;0
WireConnection;88;1;243;0
WireConnection;88;2;228;0
WireConnection;211;0;210;4
WireConnection;211;3;215;0
WireConnection;249;0;88;0
WireConnection;214;0;213;0
WireConnection;212;0;211;0
WireConnection;255;1;272;0
WireConnection;255;3;273;0
WireConnection;255;4;274;0
WireConnection;121;0;120;0
WireConnection;121;1;66;0
WireConnection;0;0;121;0
WireConnection;0;1;249;0
WireConnection;0;3;214;0
WireConnection;0;4;212;0
WireConnection;0;5;255;1
ASEEND*/
//CHKSM=E1D7C8F3F9171AEE920448E3546328DB5B682407