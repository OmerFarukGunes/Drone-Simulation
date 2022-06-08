// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/SFX/Distortion/DistortionCutOutFresnel"
{
	Properties
	{
		_FresnelScale("Fresnel Scale", Range( 0 , 1)) = 0.510905
		_FresnelPower("Fresnel Power", Range( 0 , 5)) = 2
		[HDR]_TintColor("Tint Color", Color) = (0,0,0,0)
		_MainTex("Main Tex", 2D) = "white" {}
		_CutOutA("CutOut (A)", 2D) = "white" {}
		_DistortionTexture("Distortion Texture", 2D) = "bump" {}
		_Scale("Scale", Float) = 1
		_DistortionSpeed("Distortion Speed", Vector) = (0,0,0,0)
		_Distortion("Distortion", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}
	
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent+1" }
		LOD 100
		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		
		GrabPass{ }


		Pass
		{
			Name "Unlit"
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
				float3 ase_normal : NORMAL;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_color : COLOR;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
			};

			uniform float4 _TintColor;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform sampler2D _GrabTexture;
			uniform float _Distortion;
			uniform sampler2D _DistortionTexture;
			uniform float _Scale;
			uniform float2 _DistortionSpeed;
			uniform sampler2D _CutOutA;
			uniform float4 _CutOutA_ST;
			uniform float _FresnelScale;
			uniform float _FresnelPower;
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
			
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord1 = screenPos;
				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.ase_texcoord2.xyz = ase_worldPos;
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord3.xyz = ase_worldNormal;
				
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				o.ase_texcoord2.w = 0;
				o.ase_texcoord3.w = 0;
				
				v.vertex.xyz +=  float3(0,0,0) ;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				fixed4 finalColor;
				float2 uv_MainTex = i.ase_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float2 uv3_g14 = i.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float4 screenPos = i.ase_texcoord1;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float4 screenColor14_g14 = tex2D( _GrabTexture, ( float4( ( _Distortion * UnpackNormal( tex2D( _DistortionTexture, (uv3_g14*_Scale + ( _Time.y * _DistortionSpeed )) ) ) ) , 0.0 ) + ase_grabScreenPosNorm ).xy );
				float3 temp_output_19_0_g14 = (( ( _TintColor * tex2D( _MainTex, uv_MainTex ) ) + screenColor14_g14 )).rgb;
				float2 uv_CutOutA = i.ase_texcoord.xy * _CutOutA_ST.xy + _CutOutA_ST.zw;
				float temp_output_20_0_g14 = ( tex2D( _CutOutA, uv_CutOutA ).a * i.ase_color.a );
				float3 ase_worldPos = i.ase_texcoord2.xyz;
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(ase_worldPos);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = i.ase_texcoord3.xyz;
				float fresnelNdotV1_g15 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode1_g15 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV1_g15, _FresnelPower ) );
				float4 appendResult44 = (float4(temp_output_19_0_g14 , ( temp_output_20_0_g14 * saturate( fresnelNode1_g15 ) )));
				
				
				finalColor = appendResult44;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=15600
10;352;1412;619;700.3332;137.6159;1.161561;True;False
Node;AmplifyShaderEditor.FunctionNode;40;-324.6241,245.3948;Float;False;QFX Get Fresnel;0;;15;0a832704e6daa5244b3db55d16dfb317;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;50;-361.7397,34.1428;Float;False;QFX Get Distortion Cutout;3;;14;db69d9cc7908a9a44b0b25d1b86b6fe8;0;0;3;FLOAT3;22;FLOAT;23;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-12.06982,122.3265;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;44;185.6204,34.29636;Float;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;35;360.7844,35.61035;Float;False;True;2;Float;ASEMaterialInspector;0;1;QFX/SFX/Distortion/DistortionCutOutFresnel;0770190933193b94aaa3065e307002fa;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;0;False;-1;True;False;0;False;-1;0;False;-1;True;2;RenderType=Transparent;Queue=Transparent+1;True;2;0;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;0;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;45;0;50;23
WireConnection;45;1;40;0
WireConnection;44;0;50;22
WireConnection;44;3;45;0
WireConnection;35;0;44;0
ASEEND*/
//CHKSM=6041491F12451E72FA374512FFF81AF6EBFD6F1B