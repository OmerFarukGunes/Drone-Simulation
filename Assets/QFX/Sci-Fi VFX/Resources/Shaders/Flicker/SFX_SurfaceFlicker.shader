// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/SFX/Flicker/SurfaceFlicker"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.1
		_MainTex("Main Tex", 2D) = "white" {}
		_MaskAppearProgress("Mask Appear Progress", Range( 0 , 1)) = 0
		[HDR]_Color("Color", Color) = (1,1,1,1)
		_NoiseTex("Noise Tex", 2D) = "white" {}
		[HDR]_DissolveColor("Dissolve Color", Color) = (1,1,1,1)
		[KeywordEnum(X,Y,Z,None)] _Axis("Axis", Float) = 0
		_DissolveAmount("Dissolve Amount", Float) = 0
		_NoiseTilling("Noise Tilling", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#pragma target 3.0
		#pragma shader_feature _AXIS_X _AXIS_Y _AXIS_Z _AXIS_NONE
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float _MaskAppearProgress;
		uniform sampler2D _NoiseTex;
		uniform float _NoiseTilling;
		uniform float _DissolveAmount;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _Color;
		uniform float4 _DissolveColor;
		uniform float _Cutoff = 0.1;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			float4 transform53 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );
			float4 break97 = ( ( float4( ase_worldPos , 0.0 ) - transform53 ) / float4( ase_objectScale , 0.0 ) );
			#if defined(_AXIS_X)
				float staticSwitch93 = break97.x;
			#elif defined(_AXIS_Y)
				float staticSwitch93 = break97.y;
			#elif defined(_AXIS_Z)
				float staticSwitch93 = break97.z;
			#elif defined(_AXIS_NONE)
				float staticSwitch93 = 0.0;
			#else
				float staticSwitch93 = break97.x;
			#endif
			float temp_output_91_0 = saturate( ( ( staticSwitch93 - (-2.0 + (_MaskAppearProgress - 0.0) * (2.0 - -2.0) / (1.0 - 0.0)) ) - tex2D( _NoiseTex, ( i.uv_texcoord * _NoiseTilling ) ).r ) );
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 temp_output_3_0 = ( tex2D( _MainTex, uv_MainTex ) * _Color );
			o.Emission = (( temp_output_91_0 > _DissolveAmount ) ? temp_output_3_0 :  _DissolveColor ).rgb;
			o.Alpha = (temp_output_3_0).a;
			clip( temp_output_91_0 - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15600
137;332;1412;619;458.1205;210.9103;2.127901;True;False
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;53;-466.8564,974.7758;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;51;-446.1848,795.6321;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;52;-201.8555,897.7759;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ObjectScaleNode;56;-190.0192,1257.156;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleDivideOpNode;59;36.84374,909.2352;Float;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;72;306.2875,572.294;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;71;331.8622,782.2775;Float;False;Property;_NoiseTilling;Noise Tilling;8;0;Create;True;0;0;False;0;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;280.3397,1320.591;Float;False;Property;_MaskAppearProgress;Mask Appear Progress;2;0;Create;True;0;0;False;0;0;0.453;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;97;251.7031,912.1552;Float;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.StaticSwitch;93;510.9133,907.0255;Float;False;Property;_Axis;Axis;6;0;Create;True;0;0;False;0;0;0;3;True;;KeywordEnum;4;X;Y;Z;None;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;566.074,700.1682;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;85;660.7101,1323.505;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-2;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;69;784.6139,671.8619;Float;True;Property;_NoiseTex;Noise Tex;4;0;Create;True;0;0;False;0;None;9d903017bd4bd344e976cdb4cf902b6d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;86;869.697,1098.753;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;172.8068,78.94621;Float;False;Property;_Color;Color;3;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;130.7179,-142.3795;Float;True;Property;_MainTex;Main Tex;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;76;1142.538,769.5446;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;78;874.5817,-198.9848;Float;False;Property;_DissolveColor;Dissolve Color;5;1;[HDR];Create;True;0;0;False;0;1,1,1,1;0,0.7655168,3,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;91;1347.287,769.0546;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;603.0388,35.79175;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;14;1425.846,43.18285;Float;False;Property;_DissolveAmount;Dissolve Amount;7;0;Create;True;0;0;False;0;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareGreater;84;1526.498,202.2472;Float;True;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;5;731.6553,237.6252;Float;False;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;11;1977.559,153.5184;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;QFX/SFX/Flicker/SurfaceFlicker;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.1;True;False;0;True;TransparentCutout;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;52;0;51;0
WireConnection;52;1;53;0
WireConnection;59;0;52;0
WireConnection;59;1;56;0
WireConnection;97;0;59;0
WireConnection;93;1;97;0
WireConnection;93;0;97;1
WireConnection;93;2;97;2
WireConnection;70;0;72;0
WireConnection;70;1;71;0
WireConnection;85;0;61;0
WireConnection;69;1;70;0
WireConnection;86;0;93;0
WireConnection;86;1;85;0
WireConnection;76;0;86;0
WireConnection;76;1;69;1
WireConnection;91;0;76;0
WireConnection;3;0;6;0
WireConnection;3;1;2;0
WireConnection;84;0;91;0
WireConnection;84;1;14;0
WireConnection;84;2;3;0
WireConnection;84;3;78;0
WireConnection;5;0;3;0
WireConnection;11;2;84;0
WireConnection;11;9;5;0
WireConnection;11;10;91;0
ASEEND*/
//CHKSM=60F169A1990F2968A6AFB760104191B78C5530B6