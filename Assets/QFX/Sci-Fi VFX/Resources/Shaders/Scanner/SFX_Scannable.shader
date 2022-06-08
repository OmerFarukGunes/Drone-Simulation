// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/SFX/Scanner/Scannable"
{
	Properties
	{
		[HDR]_EmissionColor("Emission Color", Color) = (0,0,0,0)
		_FresnelPower("Fresnel Power", Range( 0 , 4)) = 0
		_Alpha("Alpha", Range( 0 , 1)) = 0
		_ScanAdd("Scan Add", Range( 0 , 1)) = 0
		_ScanSize("Scan Size", Range( 0 , 1)) = 0.7926539
		_ScanTiling("Scan Tiling", Range( 0 , 100)) = 3.60764
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
		ZWrite On
		ZTest Always
		Offset 0 , 0
		
		

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			

			struct appdata
			{
				float4 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float3 ase_normal : NORMAL;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
			};

			uniform float4 _EmissionColor;
			uniform float _FresnelPower;
			uniform float _ScanTiling;
			uniform float _ScanSize;
			uniform float _ScanAdd;
			uniform float _Alpha;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.ase_texcoord.xyz = ase_worldPos;
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord1.xyz = ase_worldNormal;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.w = 0;
				o.ase_texcoord1.w = 0;
				
				v.vertex.xyz +=  float3(0,0,0) ;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				fixed4 finalColor;
				float3 ase_worldPos = i.ase_texcoord.xyz;
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(ase_worldPos);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = i.ase_texcoord1.xyz;
				float fresnelNdotV6 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode6 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV6, _FresnelPower ) );
				float Scan32 = step( frac( ( _ScanTiling * ase_worldPos.y ) ) , _ScanSize );
				
				
				finalColor = ( _EmissionColor * saturate( ( ( fresnelNode6 * Scan32 ) + _ScanAdd ) ) * _Alpha );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=15401
111;432;1680;487;1371.158;248.8932;1.543408;True;False
Node;AmplifyShaderEditor.CommentaryNode;21;528.7866,-597.8455;Float;False;1118.324;392.3106;Comment;6;32;31;22;30;27;23;Scan;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;23;563.5706,-444.451;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;22;569.6277,-529.0406;Float;False;Property;_ScanTiling;Scan Tiling;5;0;Create;True;0;0;False;0;3.60764;20;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;869.7272,-486.0712;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;30;1041.38,-486.6289;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;559.6557,-266.1162;Float;False;Property;_ScanSize;Scan Size;4;0;Create;True;0;0;False;0;0.7926539;0.8;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;31;1195.621,-486.1474;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-953.6221,20.71581;Float;False;Property;_FresnelPower;Fresnel Power;1;0;Create;True;0;0;False;0;0;0.98;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;33;-663.312,124.3895;Float;False;32;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;1429.887,-491.8716;Float;False;Scan;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;6;-658.6033,-67.33971;Float;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-444.3418,184.8043;Float;False;Property;_ScanAdd;Scan Add;3;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-383.4557,7.144398;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;-258.2006,10.55753;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;4;-197.2634,-182.8921;Float;False;Property;_EmissionColor;Emission Color;0;1;[HDR];Create;True;0;0;False;0;0,0,0,0;2,0.646247,0.6176466,1;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;-141.4047,239.5796;Float;False;Property;_Alpha;Alpha;2;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;39;-147.3185,8.72205;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;55.25242,-14.37977;Float;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;43;288.5504,-14.66;Float;False;True;2;Float;ASEMaterialInspector;0;1;QFX/SFX/Scanner/Scannable;0770190933193b94aaa3065e307002fa;0;0;SubShader 0 Pass 0;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;True;-1;False;-1;-1;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;7;False;-1;True;True;0;False;-1;0;False;-1;True;2;RenderType=Transparent;Queue=Transparent;True;2;0;False;False;False;False;False;False;False;False;False;False;0;;0;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;27;0;22;0
WireConnection;27;1;23;2
WireConnection;30;0;27;0
WireConnection;31;0;30;0
WireConnection;31;1;29;0
WireConnection;32;0;31;0
WireConnection;6;3;9;0
WireConnection;37;0;6;0
WireConnection;37;1;33;0
WireConnection;44;0;37;0
WireConnection;44;1;45;0
WireConnection;39;0;44;0
WireConnection;42;0;4;0
WireConnection;42;1;39;0
WireConnection;42;2;10;0
WireConnection;43;0;42;0
ASEEND*/
//CHKSM=FEB929FC64C4C4C46D6D6DF117F747C0930E8A1B