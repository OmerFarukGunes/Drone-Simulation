// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/SFX/Flicker/MainTexFlicker"
{
	Properties
	{
		[HDR]_TintColor("Tint Color", Color) = (1,1,1,1)
		_MainTex("Main Tex", 2D) = "white" {}
		_FlickerTexture("Flicker Texture", 2D) = "white" {}
		_FlickerSpeed("Flicker Speed", Vector) = (0.1,0.1,0,0)
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
		Cull Back
		ColorMask RGBA
		ZWrite Off
		ZTest LEqual
		Offset 0 , 0
		
		

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
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
			};

			uniform float4 _TintColor;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform sampler2D _FlickerTexture;
			uniform float2 _FlickerSpeed;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
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
				float Flicker12 = tex2D( _FlickerTexture, ( _Time.y * _FlickerSpeed ) ).r;
				
				
				finalColor = ( _TintColor * tex2D( _MainTex, uv_MainTex ) * Flicker12 );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=15600
137;332;1412;619;2426.658;402.9359;2.553622;True;False
Node;AmplifyShaderEditor.CommentaryNode;7;-1474.216,232.6936;Float;False;1145.839;404.78;Comment;5;12;11;10;9;8;Flicker;1,1,1,1;0;0
Node;AmplifyShaderEditor.TimeNode;9;-1444.057,307.1127;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;8;-1423.586,472.8445;Float;False;Property;_FlickerSpeed;Flicker Speed;3;0;Create;True;0;0;False;0;0.1,0.1;0,5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1168.399,397.8006;Float;True;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;11;-910.8197,369.8927;Float;True;Property;_FlickerTexture;Flicker Texture;2;0;Create;True;0;0;False;0;None;9d903017bd4bd344e976cdb4cf902b6d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;12;-553.6235,387.5555;Float;False;Flicker;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-672.5,-211.5;Float;False;Property;_TintColor;Tint Color;0;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1.014706,2.699393,6.000001,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-672.5,-4.5;Float;True;Property;_MainTex;Main Tex;1;0;Create;True;0;0;False;0;None;4aa70904f61151248936c76554daf686;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-283.5,67.5;Float;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-27,69;Float;False;True;2;Float;ASEMaterialInspector;0;1;QFX/SFX/Flicker/MainTexFlicker;0770190933193b94aaa3065e307002fa;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;2;RenderType=Transparent;Queue=Transparent;True;2;0;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;0;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;10;0;9;2
WireConnection;10;1;8;0
WireConnection;11;1;10;0
WireConnection;12;0;11;1
WireConnection;5;0;2;0
WireConnection;5;1;3;0
WireConnection;5;2;12;0
WireConnection;0;0;5;0
ASEEND*/
//CHKSM=407115F59685084726BD6A9532230EEE3B2CEDDD