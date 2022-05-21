// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MK4/Laser"
{
	Properties
	{
		[HDR]_Color("Color", Color) = (1,0.8168357,0.05147058,0)
		_GlowIntensity("Glow Intensity", Range( 0 , 1)) = 1
		_EmissionMask("Emission Mask", 2D) = "white" {}
		_CloudsTile("Clouds Tile", Range( 0 , 1)) = 0.1
		_EdgeBlendContrast("Edge Blend Contrast", Range( 0 , 1)) = 0
		_Edgeblend("Edge blend", Range( 0 , 1)) = 0.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard alpha:fade keepalpha noshadow 
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
		};

		uniform float4 _Color;
		uniform float _Edgeblend;
		uniform float _EdgeBlendContrast;
		uniform sampler2D _EmissionMask;
		uniform float _CloudsTile;
		uniform float _GlowIntensity;


		inline float4 TriplanarSamplingSF( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float tilling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= projNormal.x + projNormal.y + projNormal.z;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = ( tex2D( topTexMap, tilling * worldPos.zy * float2( nsign.x, 1.0 ) ) );
			yNorm = ( tex2D( topTexMap, tilling * worldPos.xz * float2( nsign.y, 1.0 ) ) );
			zNorm = ( tex2D( topTexMap, tilling * worldPos.xy * float2( -nsign.z, 1.0 ) ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			o.Emission = _Color.rgb;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV64 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode64 = ( 0.0 + (0.0 + (_Edgeblend - 0.0) * (2.0 - 0.0) / (1.0 - 0.0)) * pow( 1.0 - fresnelNdotV64, (7.0 + (_EdgeBlendContrast - 0.0) * (0.0 - 7.0) / (1.0 - 0.0)) ) );
			float4 triplanar50 = TriplanarSamplingSF( _EmissionMask, ase_worldPos, ase_worldNormal, 1.0, (0.1 + (_CloudsTile - 0.0) * (0.4 - 0.1) / (1.0 - 0.0)), 1.0, 0 );
			float2 panner45 = ( 1.0 * _Time.y * float2( 0.05,0.2 ) + i.uv_texcoord);
			float2 panner47 = ( 1.0 * _Time.y * float2( 0.6,0.3 ) + i.uv_texcoord);
			float lerpResult62 = lerp( ( tex2D( _EmissionMask, panner45 ).b + tex2D( _EmissionMask, panner47 ).g ) , 1.0 , _GlowIntensity);
			float clampResult49 = clamp( ( ( 1.0 - fresnelNode64 ) * ( tex2D( _EmissionMask, i.uv_texcoord ).r * ( triplanar50.w * lerpResult62 ) ) ) , 0.0 , 1.0 );
			o.Alpha = clampResult49;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
110;430;1353;603;-528.4008;268.1002;1.499982;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;5;-433.3332,381.5182;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;47;-48.75119,522.4811;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.6,0.3;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;43;-184.7026,-30.61057;Float;True;Property;_EmissionMask;Emission Mask;2;0;Create;True;0;0;False;0;a62ba3c237356c44380ebe3282eda88c;a62ba3c237356c44380ebe3282eda88c;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.PannerNode;45;-82.93735,387.9466;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.05,0.2;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;57;442.3401,-53.59714;Float;False;Property;_CloudsTile;Clouds Tile;3;0;Create;True;0;0;False;0;0.1;0.207;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;46;235.9189,308.7406;Float;True;Property;_TextureSample1;Texture Sample 1;6;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;44;242.6506,48.9076;Float;True;Property;_TextureSample0;Texture Sample 0;6;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;48;701.6479,312.6378;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;58;731.9401,20.55167;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.1;False;4;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;708.7677,530.126;Float;False;Property;_GlowIntensity;Glow Intensity;1;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;83.55558,-291.5507;Float;False;Property;_EdgeBlendContrast;Edge Blend Contrast;4;0;Create;True;0;0;False;0;0;0.201;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;119.0888,-428.5285;Float;False;Property;_Edgeblend;Edge blend;5;0;Create;True;0;0;False;0;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;50;949.2172,-45.75257;Float;True;Spherical;World;False;Top Texture 0;_TopTexture0;white;0;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;False;9;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;8;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;62;1093.478,268.9426;Float;False;3;0;FLOAT;1;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;70;549.7011,-554.1962;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;73;562.5336,-346.6741;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;7;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;60;228.3439,554.4897;Float;True;Property;_TextureSample2;Texture Sample 2;6;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;1429.891,171.8402;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;64;853.5821,-418.0544;Float;True;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1.65;False;3;FLOAT;6.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;66;1498.036,-154.4619;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;1590.524,202.049;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;1763.393,169.4491;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;49;1907.914,166.8452;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;17;1558.131,-422.7648;Float;False;Property;_Color;Color;0;1;[HDR];Create;True;0;0;False;0;1,0.8168357,0.05147058,0;1.003922,0,0,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2080.323,-267.9743;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MK4/Laser;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;47;0;5;0
WireConnection;45;0;5;0
WireConnection;46;0;43;0
WireConnection;46;1;47;0
WireConnection;44;0;43;0
WireConnection;44;1;45;0
WireConnection;48;0;44;3
WireConnection;48;1;46;2
WireConnection;58;0;57;0
WireConnection;50;0;43;0
WireConnection;50;3;58;0
WireConnection;62;0;48;0
WireConnection;62;2;63;0
WireConnection;70;0;69;0
WireConnection;73;0;71;0
WireConnection;60;0;43;0
WireConnection;60;1;5;0
WireConnection;56;0;50;4
WireConnection;56;1;62;0
WireConnection;64;2;70;0
WireConnection;64;3;73;0
WireConnection;66;0;64;0
WireConnection;61;0;60;1
WireConnection;61;1;56;0
WireConnection;68;0;66;0
WireConnection;68;1;61;0
WireConnection;49;0;68;0
WireConnection;0;2;17;0
WireConnection;0;9;49;0
ASEEND*/
//CHKSM=8C717A8F6EB50A0A4CBBF4340E6398F1348B405B