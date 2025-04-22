// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "NV3D/Wild Harvest/Soil"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_SoilTint("Soil Tint", Color) = (0.6226415,0.5454482,0.4376113,0)
		_MetSmooth("MetSmooth", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		[Toggle]_Wet("Wet", Float) = 0
		_WetNormalFade("Wet Normal Fade", Range( 0 , 1)) = 0.8
		_WetColorTint("Wet Color Tint", Color) = (0.5943396,0.5943396,0.5943396,0)
		_WetSmoothStrength("Wet Smooth Strength", Range( 0 , 1)) = 0.5
		_Emission("Emission", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform float _WetNormalFade;
		uniform float _Wet;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float4 _SoilTint;
		uniform float4 _WetColorTint;
		uniform float4 _Emission;
		uniform sampler2D _MetSmooth;
		uniform float4 _MetSmooth_ST;
		uniform float _WetSmoothStrength;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float3 tex2DNode3 = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float3 lerpResult12 = lerp( tex2DNode3 , float3( 0.5,0.5,1 ) , _WetNormalFade);
			float3 lerpResult11 = lerp( tex2DNode3 , lerpResult12 , (( _Wet )?( i.vertexColor.r ):( 0.0 )));
			o.Normal = lerpResult11;
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 temp_output_19_0 = ( tex2D( _Albedo, uv_Albedo ) * _SoilTint );
			float4 lerpResult6 = lerp( temp_output_19_0 , saturate( ( temp_output_19_0 * _WetColorTint ) ) , (( _Wet )?( i.vertexColor.r ):( 0.0 )));
			o.Albedo = lerpResult6.rgb;
			o.Emission = _Emission.rgb;
			float2 uv_MetSmooth = i.uv_texcoord * _MetSmooth_ST.xy + _MetSmooth_ST.zw;
			float4 tex2DNode2 = tex2D( _MetSmooth, uv_MetSmooth );
			o.Metallic = tex2DNode2.r;
			float lerpResult18 = lerp( tex2DNode2.a , 0.98 , _WetSmoothStrength);
			float lerpResult7 = lerp( tex2DNode2.a , saturate( lerpResult18 ) , (( _Wet )?( i.vertexColor.r ):( 0.0 )));
			o.Smoothness = lerpResult7;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.SamplerNode;1;-1537.118,-279.1516;Inherit;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode;20;-1431.262,-33.2267;Inherit;False;Property;_SoilTint;Soil Tint;1;0;Create;True;0;0;0;False;0;False;0.6226415,0.5454482,0.4376113,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;2;-844,158.5;Inherit;True;Property;_MetSmooth;MetSmooth;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;16;-938.5818,87.36108;Inherit;False;Property;_WetSmoothStrength;Wet Smooth Strength;7;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-1117.363,-125.5267;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;15;-1027.747,-308.6863;Inherit;False;Property;_WetColorTint;Wet Color Tint;6;0;Create;True;0;0;0;False;0;False;0.5943396,0.5943396,0.5943396,0;0.5943396,0.5943396,0.5943396,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;13;-730.0632,633.0932;Inherit;False;Property;_WetNormalFade;Wet Normal Fade;5;0;Create;True;0;0;0;False;0;False;0.8;0.8;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;18;-428.9375,243.6634;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.98;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-823,388.5;Inherit;True;Property;_Normal;Normal;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-504.0264,-142.7064;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.6698113,0.6698113,0.6698113,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;4;-1073.52,-687.4937;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;9;-364.9261,87.39369;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;10;-315.5262,-344.2063;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;12;-375.8632,525.7933;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0.5,0.5,1;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ToggleSwitchNode;14;-765.2072,-741.0554;Inherit;False;Property;_Wet;Wet;4;0;Create;True;0;0;0;False;0;False;0;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-530.0264,54.89371;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;6;-52.9263,-238.9063;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;7;-214.1263,-29.60629;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;11;-134.0629,371.0932;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;21;202.9136,450.5914;Inherit;False;Property;_Emission;Emission;8;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;365.6706,-6.764174;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;NV3D/Wild Harvest/Soil;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;19;0;1;0
WireConnection;19;1;20;0
WireConnection;18;0;2;4
WireConnection;18;2;16;0
WireConnection;5;0;19;0
WireConnection;5;1;15;0
WireConnection;9;0;18;0
WireConnection;10;0;5;0
WireConnection;12;0;3;0
WireConnection;12;2;13;0
WireConnection;14;1;4;1
WireConnection;8;0;2;4
WireConnection;8;1;16;0
WireConnection;6;0;19;0
WireConnection;6;1;10;0
WireConnection;6;2;14;0
WireConnection;7;0;2;4
WireConnection;7;1;9;0
WireConnection;7;2;14;0
WireConnection;11;0;3;0
WireConnection;11;1;12;0
WireConnection;11;2;14;0
WireConnection;0;0;6;0
WireConnection;0;1;11;0
WireConnection;0;2;21;0
WireConnection;0;3;2;1
WireConnection;0;4;7;0
ASEEND*/
//CHKSM=78B978795C5BC4EF2B6AFF3B3E8817CB308BA932