// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MK4/Movie Billboard"
{
	Properties
	{
		_Maintexture("Main texture", 2D) = "white" {}
		_Masks("Masks", 2D) = "white" {}
		_Color("Color", Color) = (0.5807742,0.7100198,0.9632353,0)
		_Animation("Animation", 2D) = "white" {}
		_Columns("Columns", Range( 0 , 128)) = 0
		_Rows("Rows", Range( 0 , 128)) = 16
		_MovieSpeed("Movie Speed", Range( 0 , 50)) = 1
		_Specular("Specular", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0.5
		_LED("LED", 2D) = "black" {}
		_EmissionAlbedo("Emission Albedo", Range( 0 , 1)) = 1
		_EmissionLED("Emission LED", Range( 0 , 1)) = 1
		_Texture0("Texture 0", 2D) = "black" {}
		_Distort("Distort", Range( 0 , 1)) = 0.1
		_DistortSpeed("Distort Speed", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		ZTest LEqual
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _Color;
		uniform sampler2D _Masks;
		uniform float4 _Masks_ST;
		uniform sampler2D _Maintexture;
		uniform sampler2D _Texture0;
		uniform float _DistortSpeed;
		uniform float _Distort;
		uniform sampler2D _Animation;
		uniform float _Columns;
		uniform float _Rows;
		uniform float _MovieSpeed;
		uniform sampler2D _LED;
		uniform float4 _LED_ST;
		uniform float _EmissionLED;
		uniform float _EmissionAlbedo;
		uniform float _Specular;
		uniform float _Smoothness;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_TexCoord304 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			float2 panner308 = ( uv_TexCoord304 + 1.0 * _Time.y * float2( 0,0.1 ));
			float2 uv_Masks = i.uv_texcoord * _Masks_ST.xy + _Masks_ST.zw;
			float4 tex2DNode314 = tex2D( _Masks, uv_Masks );
			float lerpResult311 = lerp( 0.0 , tex2D( _Masks, panner308 ).g , tex2DNode314.a);
			float2 panner303 = ( uv_TexCoord304 + 1.0 * _Time.y * float2( -0.1,0 ));
			float lerpResult305 = lerp( 0.0 , tex2D( _Masks, panner303 ).r , tex2DNode314.b);
			float2 uv_TexCoord258 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			float temp_output_287_0 = ( _Time.y * _DistortSpeed );
			float2 uv_TexCoord271 = i.uv_texcoord * float2( 0.3,0.3 ) + float2( 0,0 );
			float2 panner273 = ( uv_TexCoord271 + temp_output_287_0 * float2( -3,6 ));
			float2 panner274 = ( uv_TexCoord271 + temp_output_287_0 * float2( 3,4 ));
			float2 panner272 = ( uv_TexCoord271 + temp_output_287_0 * float2( -3.3,-2 ));
			float temp_output_284_0 = ( ( ( tex2D( _Texture0, panner273 ).a * 0.5 ) + ( tex2D( _Texture0, panner274 ).a + tex2D( _Texture0, panner272 ).a ) ) * (0.0 + (_Distort - 0.0) * (0.01 - 0.0) / (1.0 - 0.0)) );
			float4 tex2DNode297 = tex2D( _Maintexture, ( uv_TexCoord258 + temp_output_284_0 ) );
			float2 appendResult290 = (float2(frac( ( ( uv_TexCoord258.x * 2.5 ) + 0.5 ) ) , frac( ( ( uv_TexCoord258.y * 2.5 ) + 0.5 ) )));
			// *** BEGIN Flipbook UV Animation vars ***
			// Total tiles of Flipbook Texture
			float fbtotaltiles4 = _Columns * _Rows;
			// Offsets for cols and rows of Flipbook Texture
			float fbcolsoffset4 = 1.0f / _Columns;
			float fbrowsoffset4 = 1.0f / _Rows;
			// Speed of animation
			float fbspeed4 = _Time[ 1 ] * _MovieSpeed;
			// UV Tiling (col and row offset)
			float2 fbtiling4 = float2(fbcolsoffset4, fbrowsoffset4);
			// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
			// Calculate current tile linear index
			float fbcurrenttileindex4 = round( fmod( fbspeed4 + 0.0, fbtotaltiles4) );
			fbcurrenttileindex4 += ( fbcurrenttileindex4 < 0) ? fbtotaltiles4 : 0;
			// Obtain Offset X coordinate from current tile linear index
			float fblinearindextox4 = round ( fmod ( fbcurrenttileindex4, _Columns ) );
			// Multiply Offset X by coloffset
			float fboffsetx4 = fblinearindextox4 * fbcolsoffset4;
			// Obtain Offset Y coordinate from current tile linear index
			float fblinearindextoy4 = round( fmod( ( fbcurrenttileindex4 - fblinearindextox4 ) / _Columns, _Rows ) );
			// Reverse Y to get tiles from Top to Bottom
			fblinearindextoy4 = (int)(_Rows-1) - fblinearindextoy4;
			// Multiply Offset Y by rowoffset
			float fboffsety4 = fblinearindextoy4 * fbrowsoffset4;
			// UV Offset
			float2 fboffset4 = float2(fboffsetx4, fboffsety4);
			// Flipbook UV
			half2 fbuv4 = appendResult290 * fbtiling4 + fboffset4;
			// *** END Flipbook UV Animation vars ***
			float4 lerpResult299 = lerp( tex2DNode297 , tex2D( _Animation, ( fbuv4 + temp_output_284_0 ) ) , tex2DNode297.a);
			float4 temp_output_312_0 = ( lerpResult311 + ( lerpResult305 + lerpResult299 ) );
			o.Albedo = ( _Color * temp_output_312_0 ).rgb;
			float2 uv_LED = i.uv_texcoord * _LED_ST.xy + _LED_ST.zw;
			o.Emission = ( ( tex2D( _LED, uv_LED ) * _EmissionLED ) + ( temp_output_312_0 * _EmissionAlbedo ) ).rgb;
			float temp_output_220_0 = _Specular;
			float3 temp_cast_2 = (temp_output_220_0).xxx;
			o.Specular = temp_cast_2;
			float temp_output_216_0 = _Smoothness;
			o.Smoothness = temp_output_216_0;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14301
290;319;1344;692;3769.491;2279.774;3.826338;True;True
Node;AmplifyShaderEditor.RangedFloatNode;288;-2465.479,-356.7407;Float;False;Property;_DistortSpeed;Distort Speed;16;0;Create;True;0;0.14;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;281;-2459.438,-573.0873;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;258;-1929.473,-1676.898;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;287;-2174.359,-415.8233;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;271;-2086.971,-639.2286;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.3,0.3;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;274;-1493.723,-773.726;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;3,4;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;282;-1864.282,-850.8271;Float;True;Property;_Texture0;Texture 0;14;0;Create;True;7264660150c07a642a7be33ecbadad56;7264660150c07a642a7be33ecbadad56;False;black;Auto;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.PannerNode;272;-1507.43,-603.8416;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-3.3,-2;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;291;-1620.078,-1515.473;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;2.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;273;-1565.016,-211.2551;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-3,6;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;293;-1619.89,-1394.617;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;2.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;276;-1344.819,-213.3704;Float;True;Property;_TextureSample1;Texture Sample 1;11;0;Create;True;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;277;-1302.964,-815.4236;Float;True;Property;_TextureSample2;Texture Sample 2;11;0;Create;True;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;296;-1450.03,-1455.098;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;295;-1470.618,-1608.229;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;275;-1306.321,-623.1364;Float;True;Property;_TextureSample0;Texture Sample 0;11;0;Create;True;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FractNode;294;-1299.474,-1395.905;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;292;-1298.485,-1513.64;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;278;-893.4141,-434.6983;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;285;-1167.572,-948.0432;Float;False;Property;_Distort;Distort;15;0;Create;True;0.1;0.206;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;279;-937.702,-711.5442;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;256;-1155.085,-1166.181;Float;False;Property;_Rows;Rows;5;0;Create;True;16;8;0;128;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;289;-841.3623,-926.4801;Float;False;5;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;0.0;False;4;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;280;-781.526,-693.0245;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;255;-1152.974,-1246.255;Float;False;Property;_Columns;Columns;4;0;Create;True;0;4;0;128;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1155.332,-1078.443;Float;False;Property;_MovieSpeed;Movie Speed;6;0;Create;True;1;22;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;290;-1114.36,-1473.008;Float;False;FLOAT2;4;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;3;FLOAT;0.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;4;-858.1899,-1244.822;Float;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;8.0;False;2;FLOAT;8.0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;304;-889.6557,-2440.052;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;284;-650.826,-857.2214;Float;False;2;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;300;-658.0765,-1873.516;Float;False;2;2;0;FLOAT2;0.0;False;1;FLOAT;0.0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;313;-967.0823,-2632.505;Float;True;Property;_Masks;Masks;1;0;Create;True;None;b694e0281c1aa6940acde04d761b3a2c;False;white;Auto;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.PannerNode;303;-591.5884,-2490.635;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.1,0;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;286;-532.3095,-1153.138;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0.0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;297;-366.3544,-1846.362;Float;True;Property;_Maintexture;Main texture;0;0;Create;True;None;394075d93630e6e4789db50654c96c23;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;302;-0.1889229,-2596.083;Float;True;Property;_TextureSample3;Texture Sample 3;18;0;Create;True;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;308;-589.5753,-2377.858;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.1;False;1;FLOAT;1.0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;66;-316.1019,-1665.316;Float;True;Property;_Animation;Animation;3;0;Create;True;None;a6c6d69a5cb3dfb4bb08f1153eab981a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;314;0.7652068,-2195.325;Float;True;Property;_TextureSample5;Texture Sample 5;18;0;Create;True;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;305;383.6442,-2358.693;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;307;4.947626,-2404.075;Float;True;Property;_TextureSample4;Texture Sample 4;18;0;Create;True;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;299;174.7357,-1785.631;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.0;False;2;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;306;491.7164,-1793.879;Float;False;2;2;0;FLOAT;0,0,0,0;False;1;COLOR;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;311;499.2586,-2129.249;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;312;674.6109,-1804.173;Float;False;2;2;0;FLOAT;0,0,0,0;False;1;COLOR;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;262;-406.1961,-1423.645;Float;True;Property;_LED;LED;11;0;Create;True;18e1965a87226254b8eb7f01462acc78;18e1965a87226254b8eb7f01462acc78;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;268;677.364,-1170.79;Float;False;Property;_EmissionLED;Emission LED;13;0;Create;True;1;0.389;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;266;685.8994,-1026.749;Float;False;Property;_EmissionAlbedo;Emission Albedo;12;0;Create;True;1;0.725;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;263;954.4649,-1122.087;Float;False;2;2;0;COLOR;0;False;1;FLOAT;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;119;845.7213,-1392.001;Float;False;Property;_Color;Color;2;0;Create;True;0.5807742,0.7100198,0.9632353,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;270;936.2141,-1230.519;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;220;-282.0237,-835.489;Float;False;Property;_Specular;Specular;9;0;Create;True;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;212;200.5783,-286.7701;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;214;516.6758,-841.5266;Float;False;3;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;137;-91.51608,-3.294767;Float;True;Property;_NormalMap;Normal Map;7;0;Create;True;None;dabea5b1c44e615408c04cd2184de9e9;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;213;322.136,-897.6593;Float;False;5;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;1.0;False;4;FLOAT;2.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;216;-499.679,-290.4398;Float;False;Property;_Smoothness;Smoothness;10;0;Create;True;0.5;0.125;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;211;12.69072,-292.7262;Float;False;5;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;-0.8;False;4;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;210;-318.7589,-751.5133;Float;True;Property;_SpecularGloss;Specular Gloss;8;0;Create;True;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0.0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1.0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;219;123.7164,-750.7406;Float;False;5;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;0.0;False;4;FLOAT;2.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;269;1180.313,-1144.27;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;215;-187.55,-299.0619;Float;False;5;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;-1.0;False;4;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;121;1184.91,-1374.545;Float;False;2;2;0;COLOR;0.0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;218;118.9838,-905.0873;Float;False;5;0;FLOAT;0.0;False;1;FLOAT;0.0;False;2;FLOAT;1.0;False;3;FLOAT;-1.0;False;4;FLOAT;1.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1840.858,-1130.763;Float;False;True;2;Float;ASEMaterialInspector;0;0;StandardSpecular;MK4/Movie Billboard;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;3;False;0;0;False;0;Opaque;0.5;True;True;0;False;Opaque;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;0;Zero;Zero;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0.0,0,0;False;12;FLOAT3;0.0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;287;0;281;2
WireConnection;287;1;288;0
WireConnection;274;0;271;0
WireConnection;274;1;287;0
WireConnection;272;0;271;0
WireConnection;272;1;287;0
WireConnection;291;0;258;1
WireConnection;273;0;271;0
WireConnection;273;1;287;0
WireConnection;293;0;258;2
WireConnection;276;0;282;0
WireConnection;276;1;273;0
WireConnection;277;0;282;0
WireConnection;277;1;274;0
WireConnection;296;0;293;0
WireConnection;295;0;291;0
WireConnection;275;0;282;0
WireConnection;275;1;272;0
WireConnection;294;0;296;0
WireConnection;292;0;295;0
WireConnection;278;0;276;4
WireConnection;279;0;277;4
WireConnection;279;1;275;4
WireConnection;289;0;285;0
WireConnection;280;0;278;0
WireConnection;280;1;279;0
WireConnection;290;0;292;0
WireConnection;290;1;294;0
WireConnection;4;0;290;0
WireConnection;4;1;255;0
WireConnection;4;2;256;0
WireConnection;4;3;6;0
WireConnection;284;0;280;0
WireConnection;284;1;289;0
WireConnection;300;0;258;0
WireConnection;300;1;284;0
WireConnection;303;0;304;0
WireConnection;286;0;4;0
WireConnection;286;1;284;0
WireConnection;297;1;300;0
WireConnection;302;0;313;0
WireConnection;302;1;303;0
WireConnection;308;0;304;0
WireConnection;66;1;286;0
WireConnection;314;0;313;0
WireConnection;305;1;302;1
WireConnection;305;2;314;3
WireConnection;307;0;313;0
WireConnection;307;1;308;0
WireConnection;299;0;297;0
WireConnection;299;1;66;0
WireConnection;299;2;297;4
WireConnection;306;0;305;0
WireConnection;306;1;299;0
WireConnection;311;1;307;2
WireConnection;311;2;314;4
WireConnection;312;0;311;0
WireConnection;312;1;306;0
WireConnection;263;0;312;0
WireConnection;263;1;266;0
WireConnection;270;0;262;0
WireConnection;270;1;268;0
WireConnection;212;0;211;0
WireConnection;214;0;213;0
WireConnection;213;0;210;1
WireConnection;213;3;218;0
WireConnection;213;4;219;0
WireConnection;211;0;210;4
WireConnection;211;3;215;0
WireConnection;219;0;220;0
WireConnection;269;0;270;0
WireConnection;269;1;263;0
WireConnection;215;0;216;0
WireConnection;121;0;119;0
WireConnection;121;1;312;0
WireConnection;218;0;220;0
WireConnection;0;0;121;0
WireConnection;0;2;269;0
WireConnection;0;3;220;0
WireConnection;0;4;216;0
ASEEND*/
//CHKSM=5D3EE0C542CB43148203ED21F08E1DEDEE1764DE