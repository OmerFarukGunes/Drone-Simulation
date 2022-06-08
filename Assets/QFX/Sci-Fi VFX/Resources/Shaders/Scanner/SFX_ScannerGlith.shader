// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/SFX/Scanner/Scanner Glith"
{
	Properties
	{
		[HDR]_TintColor("Tint Color", Color) = (1,1,1,1)
		_MainTex("Main Tex", 2D) = "white" {}
		_TexturePow("Texture Pow", Range( 0.2 , 10)) = 5.316663
		[HDR]_DepthColor("Depth Color", Color) = (1,1,1,1)
		_DepthDistance("Depth Distance", Float) = 0.25
		_DepthFadeExp("Depth Fade Exp", Range( 0.2 , 10)) = 5.316663
		_Glitch("Glitch", Range( 0 , 1)) = 0.4997923
		_GlitchSpeed("Glitch Speed", Float) = 5
		_AppearProgress("Appear Progress", Range( 0 , 1)) = 1
		_MaskSpeed("Mask Speed", Vector) = (0,0.5,0,0)
		_MaskMap("Mask Map", 2D) = "white" {}
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
		
		

		Pass
		{
			Name "SubShader 0 Pass 0"
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_texcoord : TEXCOORD0;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_OUTPUT_STEREO
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			uniform float _GlitchSpeed;
			uniform float _Glitch;
			uniform float4 _TintColor;
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
			uniform float _AppearProgress;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

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
				UNITY_SETUP_INSTANCE_ID(i);
				fixed4 finalColor;
				float2 uv_MainTex = i.ase_texcoord1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 temp_cast_0 = (_TexturePow).xxxx;
				float4 screenPos = i.ase_texcoord2;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth476 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD( screenPos ))));
				float distanceDepth476 = abs( ( screenDepth476 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthDistance ) );
				float clampResult479 = clamp( ( 1.0 - distanceDepth476 ) , 0.0 , 1.0 );
				float2 uv_MaskMap = i.ase_texcoord1.xy * _MaskMap_ST.xy + _MaskMap_ST.zw;
				float2 panner580 = ( _Time.y * _MaskSpeed + uv_MaskMap);
				float2 uv588 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult592 = smoothstep( 0.0 , saturate( _AppearProgress ) , ( 0.5 * uv588.y ));
				
				
				finalColor = ( ( ( 1.0 - saturate( step( sin( ( ( _Time.y * _GlitchSpeed ) + i.ase_texcoord.xyz.y ) ) , ( 1.0 - _Glitch ) ) ) ) * ( ( ( _TintColor * saturate( pow( tex2D( _MainTex, uv_MainTex ) , temp_cast_0 ) ) ) + ( pow( clampResult479 , _DepthFadeExp ) * _DepthColor ) ) * tex2D( _MaskMap, panner580 ).r ) ) * saturate( ( 1.0 - smoothstepResult592 ) ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16100
567;244;1084;799;-1493.008;345.8184;2.856666;True;False
Node;AmplifyShaderEditor.RangedFloatNode;475;1357.603,797.7935;Float;False;Property;_DepthDistance;Depth Distance;4;0;Create;True;0;0;False;0;0.25;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;476;1568.767,802.4196;Float;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;496;1702.031,660.0117;Float;False;Property;_TexturePow;Texture Pow;2;0;Create;True;0;0;False;0;5.316663;1.04;0.2;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;473;1683.391,463.285;Float;True;Property;_MainTex;Main Tex;1;0;Create;True;0;0;False;0;None;cfc5448210d4ff246956ff92be32da7c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;477;1844.433,799.2394;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;479;2006.288,799.8884;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;478;1883.905,955.4075;Float;False;Property;_DepthFadeExp;Depth Fade Exp;5;0;Create;True;0;0;False;0;5.316663;10;0.2;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;495;1989.301,560.7449;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;574;2561.581,1217.696;Float;False;Property;_MaskSpeed;Mask Speed;10;0;Create;True;0;0;False;0;0,0.5;0,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;599;4460.036,1069.409;Float;False;190;119;changes in the script;1;598;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PowerNode;480;2204.109,847.4075;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;555;4187.672,1107.404;Float;False;Property;_AppearProgress;Appear Progress;9;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;588;4143.523,954.7515;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;497;2136.351,560.8365;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;472;2021.877,230.2777;Float;False;Property;_TintColor;Tint Color;0;1;[HDR];Create;True;0;0;False;0;1,1,1,1;15,2.793102,0,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;573;2566.023,1356.241;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;571;2529.034,1069.912;Float;False;0;554;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;483;2200.88,1020.209;Float;False;Property;_DepthColor;Depth Color;3;1;[HDR];Create;True;0;0;False;0;1,1,1,1;5,0.9310337,0,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;590;4143.518,846.2626;Float;False;Constant;_Float0;Float 0;13;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;474;2269.877,366.2776;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;598;4479.299,1111.433;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;580;2865.053,1160.175;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;482;2416.27,841.9716;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;589;4428.744,849.7624;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;481;2831.911,632.6971;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;592;4657.967,849.7623;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;554;3126.799,1027.494;Float;True;Property;_MaskMap;Mask Map;11;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;553;3738.785,377.6218;Float;False;QFX Get Simple Glitch;6;;1;bb16914625242fb46ba2e0385c26d46a;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;566;3665.914,796.6874;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;595;4855.7,848.0126;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;597;5032.433,846.2629;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;581;3967.107,579.2476;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;594;5098.653,585.3767;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;470;5365.555,582.2463;Float;False;True;2;Float;ASEMaterialInspector;0;1;QFX/SFX/Scanner/Scanner Glith;0770190933193b94aaa3065e307002fa;0;0;SubShader 0 Pass 0;2;True;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;True;0;False;-1;0;False;-1;True;2;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;0;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;476;0;475;0
WireConnection;477;0;476;0
WireConnection;479;0;477;0
WireConnection;495;0;473;0
WireConnection;495;1;496;0
WireConnection;480;0;479;0
WireConnection;480;1;478;0
WireConnection;497;0;495;0
WireConnection;474;0;472;0
WireConnection;474;1;497;0
WireConnection;598;0;555;0
WireConnection;580;0;571;0
WireConnection;580;2;574;0
WireConnection;580;1;573;2
WireConnection;482;0;480;0
WireConnection;482;1;483;0
WireConnection;589;0;590;0
WireConnection;589;1;588;2
WireConnection;481;0;474;0
WireConnection;481;1;482;0
WireConnection;592;0;589;0
WireConnection;592;2;598;0
WireConnection;554;1;580;0
WireConnection;566;0;481;0
WireConnection;566;1;554;1
WireConnection;595;0;592;0
WireConnection;597;0;595;0
WireConnection;581;0;553;0
WireConnection;581;1;566;0
WireConnection;594;0;581;0
WireConnection;594;1;597;0
WireConnection;470;0;594;0
ASEEND*/
//CHKSM=23443B5107AAE85CD1F2F253346F8294F77081B2