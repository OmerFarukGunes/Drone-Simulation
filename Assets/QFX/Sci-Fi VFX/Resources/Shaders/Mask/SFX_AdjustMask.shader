// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/SFX/Mask/AdjustMask"
{
	Properties
	{
		[HDR]_TintColor("Tint Color", Color) = (0,0,0,0)
		_MainTex("Main Tex", 2D) = "white" {}
		_MainTexSpeed("Main Tex Speed", Vector) = (0,0,0,0)
		_AdjustPower("Adjust Power", Float) = 0
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
				float4 ase_color : COLOR;
			};

			uniform float4 _TintColor;
			uniform sampler2D _MainTex;
			uniform float2 _MainTexSpeed;
			uniform float4 _MainTex_ST;
			uniform float _AdjustPower;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				o.ase_texcoord = v.ase_texcoord;
				o.ase_color = v.ase_color;
				
				v.vertex.xyz +=  float3(0,0,0) ;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				fixed4 finalColor;
				float4 uv_MainTex = i.ase_texcoord;
				uv_MainTex.xy = i.ase_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float2 panner7 = ( _Time.y * _MainTexSpeed + uv_MainTex.xy);
				float4 uv17 = i.ase_texcoord;
				uv17.xy = i.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float4 temp_cast_1 = (( _AdjustPower + uv17.z )).xxxx;
				
				
				finalColor = ( _TintColor * pow( tex2D( _MainTex, panner7 ) , temp_cast_1 ) * i.ase_color.a );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=15600
137;332;1412;619;1472.191;264.9812;1.3;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-1354.012,-231.0212;Float;False;0;4;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;9;-1322.712,-61.02124;Float;False;Property;_MainTexSpeed;Main Tex Speed;2;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TimeNode;8;-1324.712,86.97876;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;7;-1076.294,-79.78632;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-863.7906,221.8688;Float;False;Property;_AdjustPower;Adjust Power;3;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-866.3913,318.0685;Float;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-830.2925,-108.0186;Float;True;Property;_MainTex;Main Tex;1;0;Create;True;0;0;False;0;None;8c7becfd88f947a4eb66eadb67e9715e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-602.4908,255.6687;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;3;-826.801,-293.8366;Float;False;Property;_TintColor;Tint Color;0;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0,5.689657,15.00001,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;15;-465.9912,37.26869;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;19;-420.4906,237.4689;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-216.7981,-123.4005;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-46.05588,-124.0346;Float;False;True;2;Float;ASEMaterialInspector;0;1;QFX/SFX/Mask/AdjustMask;0770190933193b94aaa3065e307002fa;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;2;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;False;0;False;-1;0;False;-1;True;2;RenderType=Transparent;Queue=Transparent;True;2;0;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;0;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;7;0;10;0
WireConnection;7;2;9;0
WireConnection;7;1;8;2
WireConnection;4;1;7;0
WireConnection;18;0;16;0
WireConnection;18;1;17;3
WireConnection;15;0;4;0
WireConnection;15;1;18;0
WireConnection;5;0;3;0
WireConnection;5;1;15;0
WireConnection;5;2;19;4
WireConnection;0;0;5;0
ASEEND*/
//CHKSM=71DE221AADE898295437CB13B257A00671D7FBA5