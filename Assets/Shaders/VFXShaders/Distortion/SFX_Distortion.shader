// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/SFX/Distortion/DistortionCutOut"
{
	Properties
	{
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
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_color : COLOR;
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
				
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				
				v.vertex.xyz +=  float3(0,0,0) ;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				fixed4 finalColor;
				float2 uv_MainTex = i.ase_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float2 uv3_g1 = i.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float4 screenPos = i.ase_texcoord1;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float4 screenColor14_g1 = tex2D( _GrabTexture, ( float4( ( _Distortion * UnpackNormal( tex2D( _DistortionTexture, (uv3_g1*_Scale + ( _Time.y * _DistortionSpeed )) ) ) ) , 0.0 ) + ase_grabScreenPosNorm ).xy );
				float3 temp_output_19_0_g1 = (( ( _TintColor * tex2D( _MainTex, uv_MainTex ) ) + screenColor14_g1 )).rgb;
				float2 uv_CutOutA = i.ase_texcoord.xy * _CutOutA_ST.xy + _CutOutA_ST.zw;
				float temp_output_20_0_g1 = ( tex2D( _CutOutA, uv_CutOutA ).a * i.ase_color.a );
				float4 appendResult21_g1 = (float4(temp_output_19_0_g1 , temp_output_20_0_g1));
				
				
				finalColor = appendResult21_g1;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=15600
146;384;1412;619;273.049;400.5146;1;True;False
Node;AmplifyShaderEditor.FunctionNode;39;68.43877,-138.9283;Float;False;QFX Get Distortion Cutout;0;;1;db69d9cc7908a9a44b0b25d1b86b6fe8;0;0;3;FLOAT3;22;FLOAT;23;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;35;586.3373,-92.1138;Float;False;True;2;Float;ASEMaterialInspector;0;1;QFX/SFX/Distortion/DistortionCutOut;0770190933193b94aaa3065e307002fa;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;0;False;-1;True;False;0;False;-1;0;False;-1;True;2;RenderType=Transparent;Queue=Transparent+1;True;2;0;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;0;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;35;0;39;0
ASEEND*/
//CHKSM=C1DFC04DA7A420A347A53294AFD821A4F2995C5E