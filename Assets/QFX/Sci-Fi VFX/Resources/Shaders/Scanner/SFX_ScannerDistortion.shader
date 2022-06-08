// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/SFX/Scanner/Scanner Distortion"
{
	Properties
	{
		[HDR]_TintColor("Tint Color", Color) = (1,1,1,1)
		_MainTex("Main Tex", 2D) = "white" {}
		_TexturePow("Texture Pow", Range( 0.1 , 10)) = 5.316663
		_MaskMap("Mask Map", 2D) = "white" {}
		_MaskSpeed("Mask Speed", Vector) = (0,0.5,0,0)
		_NoiseMap("Noise Map", 2D) = "white" {}
		_DistortionMap("Distortion Map", 2D) = "white" {}
		_NoiseDistortionTilling("Noise Distortion Tilling", Range( 0 , 2)) = 0.1793017
		_NoiseDistortionSpeed("Noise Distortion Speed", Vector) = (0,0.2,0,0)
		_NoiseTilling("Noise Tilling", Range( 0 , 2)) = 0.5832521
		_NoisePower("Noise Power", Range( 0 , 2)) = 0.9750929
		[HDR]_DepthColor("Depth Color", Color) = (1,1,1,1)
		_DepthDistance("Depth Distance", Float) = 0
		_DepthFadeExp("Depth Fade Exp", Range( 0.2 , 10)) = 5.316663
		_Glitch("Glitch", Range( 0.1 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}
	
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
		LOD 100
		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Off
		ColorMask RGBA
		ZWrite Off
		ZTest LEqual
		Offset 0 , 0
		
		GrabPass{ }


		Pass
		{
			Name "SubShader 0 Pass 0"
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#include "UnityCG.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_texcoord : TEXCOORD0;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
			};

			uniform float _Glitch;
			uniform sampler2D _GrabTexture;
			uniform sampler2D _NoiseMap;
			uniform sampler2D _DistortionMap;
			uniform float2 _NoiseDistortionSpeed;
			uniform float _NoiseDistortionTilling;
			uniform float _NoiseTilling;
			uniform float _NoisePower;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform float _TexturePow;
			uniform sampler2D _CameraDepthTexture;
			uniform float _DepthDistance;
			uniform float _DepthFadeExp;
			uniform float4 _DepthColor;
			uniform sampler2D _MaskMap;
			uniform float2 _MaskSpeed;
			uniform float4 _MaskMap_ST;
			uniform float4 _TintColor;
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
				o.ase_texcoord2 = screenPos;
				
				o.ase_texcoord = v.vertex;
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				
				v.vertex.xyz +=  float3(0,0,0) ;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				fixed4 finalColor;
				float temp_output_10_0_g57 = sin( ( ( _Time.y * 100.0 ) + i.ase_texcoord.xyz.y ) );
				float2 uv20_g55 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner21_g55 = ( 1.0 * _Time.y * _NoiseDistortionSpeed + uv20_g55);
				float2 temp_cast_0 = (_NoiseTilling).xx;
				float2 uv45_g55 = i.ase_texcoord1.xy * temp_cast_0 + float2( 0,0 );
				float4 temp_output_714_0 = ( tex2D( _NoiseMap, ( tex2D( _DistortionMap, (panner21_g55*_NoiseDistortionTilling + 0.0) ) + float4( uv45_g55, 0.0 , 0.0 ) ).rg ) * _NoisePower );
				float4 screenPos = i.ase_texcoord2;
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float4 screenColor639 = tex2D( _GrabTexture, ( temp_output_714_0 + ase_grabScreenPosNorm ).rg );
				float2 uv_MainTex = i.ase_texcoord1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 temp_cast_5 = (_TexturePow).xxxx;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth2_g56 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD( screenPos ))));
				float distanceDepth2_g56 = abs( ( screenDepth2_g56 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthDistance ) );
				float2 uv_MaskMap = i.ase_texcoord1.xy * _MaskMap_ST.xy + _MaskMap_ST.zw;
				float2 panner580 = ( _Time.y * _MaskSpeed + uv_MaskMap);
				float4 noise722 = temp_output_714_0;
				
				
				finalColor = ( ( ( saturate( ( step( temp_output_10_0_g57 , _Glitch ) + step( temp_output_10_0_g57 , ( _Glitch * 0.5 ) ) ) ) * screenColor639 ) + ( saturate( pow( tex2D( _MainTex, uv_MainTex ) , temp_cast_5 ) ) * ( pow( saturate( ( 1.0 - distanceDepth2_g56 ) ) , _DepthFadeExp ) * _DepthColor ) * tex2D( _MaskMap, ( float4( panner580, 0.0 , 0.0 ) + noise722 ).rg ).r ) ) * _TintColor );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=15600
908;92;733;794;-821.1729;952.6026;3.955203;False;False
Node;AmplifyShaderEditor.CommentaryNode;644;1434.197,-260.6554;Float;False;566.2307;161.8469;;2;714;722;NOISE;1,1,1,1;0;0
Node;AmplifyShaderEditor.TimeNode;573;1601.561,1628.531;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;571;1564.572,1342.202;Float;False;0;554;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;574;1597.119,1489.986;Float;False;Property;_MaskSpeed;Mask Speed;4;0;Create;True;0;0;False;0;0,0.5;0.2,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FunctionNode;714;1468.716,-212.5089;Float;False;Get Simple Noise;5;;55;dba3a45ee088a1c42ae7fbf09d132e5e;0;0;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;722;1753.367,-217.1621;Float;False;noise;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;721;1903.043,1585.868;Float;False;722;noise;0;1;COLOR;0
Node;AmplifyShaderEditor.GrabScreenPosition;683;1732.681,63.67409;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;580;1900.589,1432.465;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;496;1346.84,762.7704;Float;False;Property;_TexturePow;Texture Pow;2;0;Create;True;0;0;False;0;5.316663;0.1;0.1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;473;1288.466,567.3925;Float;True;Property;_MainTex;Main Tex;1;0;Create;True;0;0;False;0;None;d1b8e5e9b8a03d149966526d4f311c7e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;682;2006.997,46.67388;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;720;2136.901,1437.526;Float;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;603;1789.62,935.0194;Float;False;268;132.2;;1;602;DEPTH;1,1,1,1;0;0
Node;AmplifyShaderEditor.PowerNode;495;1653.17,662.5005;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;602;1813.939,980.7129;Float;False;Get Depth Fade Color;12;;56;178c752a5f1ef2644a24cb6a097a6938;0;0;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;553;2332.301,21.3478;Float;False;Simple Glitch;16;;57;bb16914625242fb46ba2e0385c26d46a;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;639;2349.565,155.0856;Float;False;Global;_GrabScreen0;Grab Screen 0;15;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;554;2303.029,1410.422;Float;True;Property;_MaskMap;Mask Map;3;0;Create;True;0;0;False;0;None;8ff96dbed3bc8ab44a7842f0bc5c934a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;497;1800.22,662.5922;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;717;2813.379,946.5715;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;715;2575.271,198.3925;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;716;3017.319,924.5596;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;472;2749.034,1321.367;Float;False;Property;_TintColor;Tint Color;0;1;[HDR];Create;True;0;0;False;0;1,1,1,1;0.8161765,0.8250507,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;723;3132.205,926.0259;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;470;3278.74,922.4233;Float;False;True;2;Float;ASEMaterialInspector;0;1;QFX/SFX/Scanner/Scanner Distortion;0770190933193b94aaa3065e307002fa;0;0;SubShader 0 Pass 0;2;True;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;True;0;False;-1;0;False;-1;True;2;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;2;RenderType=Transparent;Queue=Transparent;True;2;0;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;0;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;722;0;714;0
WireConnection;580;0;571;0
WireConnection;580;2;574;0
WireConnection;580;1;573;2
WireConnection;682;0;714;0
WireConnection;682;1;683;0
WireConnection;720;0;580;0
WireConnection;720;1;721;0
WireConnection;495;0;473;0
WireConnection;495;1;496;0
WireConnection;639;0;682;0
WireConnection;554;1;720;0
WireConnection;497;0;495;0
WireConnection;717;0;497;0
WireConnection;717;1;602;0
WireConnection;717;2;554;1
WireConnection;715;0;553;0
WireConnection;715;1;639;0
WireConnection;716;0;715;0
WireConnection;716;1;717;0
WireConnection;723;0;716;0
WireConnection;723;1;472;0
WireConnection;470;0;723;0
ASEEND*/
//CHKSM=A0BAF2489ED54D857061E468F3C054707E3CC177