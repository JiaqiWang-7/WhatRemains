// Made with Amplify Shader Editor v1.9.5.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "NV3D/Wild Harvest/Foliage"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Albedo("Albedo", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		[Toggle(_MIRRORVERTEXNORMALS_ON)] _MirrorVertexNormals("Mirror Vertex Normals", Float) = 1
		_Masks("Masks", 2D) = "black" {}
		_SmoothStrength("Smooth Strength", Range( 0 , 1)) = 0
		_Emission("Emission", Color) = (0,0,0,0)
		_FlowerTint("Flower Tint", Color) = (0.9056604,0.5254539,0.8817336,0)
		_Fruit("Fruit", Color) = (1,0.3160377,0.3160377,0)
		_StemTint("Stem Tint", Color) = (1,1,1,0)
		_LeafTintTop("Leaf Tint Top", Color) = (0.5150442,1,0.3915094,0)
		_LeafTintBottom("Leaf Tint Bottom", Color) = (0.745283,0.7090516,0.2355375,0)
		_AOTintVert("AO Tint (Vert)", Color) = (0,0,0,0)
		[Toggle(_TRANSLUCENTTOGGLE_ON)] _TranslucentToggle("TranslucentToggle", Float) = 1
		_TranslucencyStrength("TranslucencyStrength", Range( 0 , 3)) = 1
		[Toggle(_WINDTOGGLE_ON)] _WindToggle("WindToggle", Float) = 1
		_WindStrength("WindStrength", Float) = 0.25
		_WindSpeed("WindSpeed", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _WINDTOGGLE_ON
		#pragma shader_feature_local _MIRRORVERTEXNORMALS_ON
		#pragma shader_feature_local _TRANSLUCENTTOGGLE_ON
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform float _WindSpeed;
		uniform float _WindStrength;
		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform float4 _AOTintVert;
		uniform float4 _LeafTintBottom;
		uniform float4 _LeafTintTop;
		uniform sampler2D _Masks;
		uniform float4 _Masks_ST;
		uniform float4 _StemTint;
		uniform float4 _FlowerTint;
		uniform float4 _Fruit;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float _TranslucencyStrength;
		uniform float4 _Emission;
		uniform float _SmoothStrength;
		uniform float _Cutoff = 0.5;


		float2 UnityGradientNoiseDir( float2 p )
		{
			p = fmod(p , 289);
			float x = fmod((34 * p.x + 1) * p.x , 289) + p.y;
			x = fmod( (34 * x + 1) * x , 289);
			x = frac( x / 41 ) * 2 - 1;
			return normalize( float2(x - floor(x + 0.5 ), abs( x ) - 0.5 ) );
		}
		
		float UnityGradientNoise( float2 UV, float Scale )
		{
			float2 p = UV * Scale;
			float2 ip = floor( p );
			float2 fp = frac( p );
			float d00 = dot( UnityGradientNoiseDir( ip ), fp );
			float d01 = dot( UnityGradientNoiseDir( ip + float2( 0, 1 ) ), fp - float2( 0, 1 ) );
			float d10 = dot( UnityGradientNoiseDir( ip + float2( 1, 0 ) ), fp - float2( 1, 0 ) );
			float d11 = dot( UnityGradientNoiseDir( ip + float2( 1, 1 ) ), fp - float2( 1, 1 ) );
			fp = fp * fp * fp * ( fp * ( fp * 6 - 15 ) + 10 );
			return lerp( lerp( d00, d01, fp.y ), lerp( d10, d11, fp.y ), fp.x ) + 0.5;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float4 temp_cast_0 = (0.0).xxxx;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float2 appendResult109 = (float2(ase_vertex3Pos.x , ase_vertex3Pos.z));
			float2 temp_output_84_0 = ( appendResult109 + ( _Time.y * _WindSpeed ) );
			float gradientNoise89 = UnityGradientNoise(temp_output_84_0,1.0);
			gradientNoise89 = gradientNoise89*0.5 + 0.5;
			float gradientNoise118 = UnityGradientNoise(temp_output_84_0,0.75);
			gradientNoise118 = gradientNoise118*0.5 + 0.5;
			float4 appendResult85 = (float4((( 0.0 - _WindStrength ) + (gradientNoise89 - 0.0) * (_WindStrength - ( 0.0 - _WindStrength )) / (1.0 - 0.0)) , 0.0 , (( 0.0 - _WindStrength ) + (gradientNoise118 - 0.0) * (_WindStrength - ( 0.0 - _WindStrength )) / (1.0 - 0.0)) , 0.0));
			float4 lerpResult91 = lerp( float4( 0,0,0,0 ) , appendResult85 , (0.0 + (ase_vertex3Pos.y - 0.0) * (1.0 - 0.0) / (3.0 - 0.0)));
			#ifdef _WINDTOGGLE_ON
				float4 staticSwitch144 = lerpResult91;
			#else
				float4 staticSwitch144 = temp_cast_0;
			#endif
			v.vertex.xyz += staticSwitch144.xyz;
			v.vertex.w = 1;
			float3 ase_vertexNormal = v.normal.xyz;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float3 ase_worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
			half tangentSign = v.tangent.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
			float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * tangentSign;
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 ase_tanViewDir = mul( ase_worldToTangent, ase_worldViewDir );
			float ase_faceVertex = (dot(ase_tanViewDir,float3(0,0,1)));
			#ifdef _MIRRORVERTEXNORMALS_ON
				float3 staticSwitch256 = ( ase_vertexNormal * ase_faceVertex );
			#else
				float3 staticSwitch256 = ase_vertexNormal;
			#endif
			v.normal = staticSwitch256;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal ) );
			float4 lerpResult176 = lerp( _AOTintVert , float4( 1,1,1,0 ) , i.vertexColor.r);
			float4 lerpResult60 = lerp( _LeafTintBottom , _LeafTintTop , i.vertexColor.g);
			float2 uv_Masks = i.uv_texcoord * _Masks_ST.xy + _Masks_ST.zw;
			float4 tex2DNode3 = tex2D( _Masks, uv_Masks );
			float temp_output_206_0 = saturate(  ( tex2DNode3.r - 0.01 > 0.25 ? 0.0 : tex2DNode3.r - 0.01 <= 0.25 && tex2DNode3.r + 0.01 >= 0.25 ? 1.0 : 0.0 )  );
			float temp_output_212_0 = saturate(  ( tex2DNode3.r - 0.02 > 0.5 ? 0.0 : tex2DNode3.r - 0.02 <= 0.5 && tex2DNode3.r + 0.02 >= 0.5 ? 1.0 : 0.0 )  );
			float temp_output_216_0 = saturate(  ( tex2DNode3.r - 0.02 > 0.75 ? 0.0 : tex2DNode3.r - 0.02 <= 0.75 && tex2DNode3.r + 0.02 >= 0.75 ? 1.0 : 0.0 )  );
			float4 lerpResult233 = lerp( ( lerpResult176 * lerpResult60 ) , ( ( temp_output_206_0 * _StemTint ) + ( temp_output_212_0 * _FlowerTint ) + ( temp_output_216_0 * _Fruit ) ) , ( temp_output_206_0 + temp_output_212_0 + temp_output_216_0 ));
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 tex2DNode1 = tex2D( _Albedo, uv_Albedo );
			float4 temp_output_179_0 = saturate( ( lerpResult233 * tex2DNode1 ) );
			o.Albedo = temp_output_179_0.rgb;
			float4 color143 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float4 ase_vertex4Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float3 ase_objectlightDir = normalize( ObjSpaceLightDir( ase_vertex4Pos ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 normalizeResult126 = normalize( ( ( 1.0 - ase_objectlightDir ) + ase_worldTangent ) );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult134 = dot( normalizeResult126 , ase_worldViewDir );
			#ifdef _TRANSLUCENTTOGGLE_ON
				float4 staticSwitch142 = ( temp_output_179_0 * saturate( pow( saturate( dotResult134 ) , 1.5 ) ) * _TranslucencyStrength * tex2DNode3.g );
			#else
				float4 staticSwitch142 = color143;
			#endif
			o.Emission = ( staticSwitch142 + ( _Emission * tex2DNode1 ) ).rgb;
			o.Metallic = 0.0;
			o.Smoothness = saturate( ( tex2DNode3.a * ( _SmoothStrength * 1.5 ) ) );
			o.Occlusion = tex2DNode3.b;
			o.Alpha = 1;
			clip( tex2DNode1.a - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.vertexColor = IN.color;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}
/*ASEBEGIN
Version=19501
Node;AmplifyShaderEditor.SamplerNode;3;-1086.854,-96.53709;Inherit;True;Property;_Masks;Masks;4;0;Create;True;0;0;0;False;0;False;-1;None;b13dc463a27cbb8409f73e30b839d9c6;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode;210;-3083.665,52.3779;Inherit;False;Constant;_Float6;Float 4;18;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;211;-3082.665,126.3778;Inherit;False;Constant;_Float7;Float 5;18;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;214;-3095.376,425.5629;Inherit;False;Constant;_Float8;Float 4;18;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;215;-3094.376,499.5627;Inherit;False;Constant;_Float9;Float 5;18;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;204;-3083.641,-314.1006;Inherit;False;Constant;_Float4;Float 4;18;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;205;-3082.641,-240.1007;Inherit;False;Constant;_Float5;Float 5;18;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;199;-3348.091,-87.21472;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjSpaceLightDirHlpNode;125;-2287.285,-2153.596;Inherit;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TFHCIf;207;-3086.125,-522.8967;Inherit;True;6;0;FLOAT;0;False;1;FLOAT;0.25;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCIf;209;-3086.149,-156.4183;Inherit;True;6;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0.02;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCIf;213;-3097.86,216.7668;Inherit;True;6;0;FLOAT;0;False;1;FLOAT;0.75;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0.02;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;128;-1981.286,-2135.596;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.VertexTangentNode;127;-2121.285,-1949.596;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.VertexColorNode;180;-1850.734,-981.0571;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;8;-2167.785,-1304.569;Inherit;False;Property;_AOTintVert;AO Tint (Vert);12;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode;41;-2167.96,-958.4639;Inherit;False;Property;_LeafTintTop;Leaf Tint Top;10;0;Create;True;0;0;0;False;0;False;0.5150442,1,0.3915094,0;0.5150442,1,0.3915094,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode;42;-2167.615,-1126.052;Inherit;False;Property;_LeafTintBottom;Leaf Tint Bottom;11;0;Create;True;0;0;0;False;0;False;0.745283,0.7090516,0.2355375,0;0.745283,0.7090516,0.2355375,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SaturateNode;212;-2780.149,-157.4183;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;216;-2791.86,215.7668;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;175;-2776.488,-437.4642;Inherit;False;Property;_StemTint;Stem Tint;9;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode;154;-2792.002,296.1743;Inherit;False;Property;_Fruit;Fruit;8;0;Create;True;0;0;0;False;0;False;1,0.3160377,0.3160377,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode;14;-2771.021,-70.58458;Inherit;False;Property;_FlowerTint;Flower Tint;7;0;Create;True;0;0;0;False;0;False;0.9056604,0.5254539,0.8817336,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SaturateNode;206;-2780.125,-523.8967;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;129;-1802.286,-2053.596;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;60;-1842.904,-1119.121;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;176;-1843.115,-1260.999;Inherit;False;3;0;COLOR;1,1,1,0;False;1;COLOR;1,1,1,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;222;-2468.833,-152.7722;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;223;-2454.032,202.4175;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;221;-2483.632,-519.4727;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;80;-1815.177,1225.749;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;99;-1811.305,1345.52;Inherit;False;Property;_WindSpeed;WindSpeed;17;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;72;-1825.142,995.8094;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalizeNode;126;-1677.624,-2054.362;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;135;-1672.624,-1895.362;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;178;-1609.355,-1199.792;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;224;-2054.684,-546.7782;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;232;-2050.724,-319.9694;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;-1625.345,1278.785;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;109;-1611.746,1032.683;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DotProductOpNode;134;-1447.625,-2006.362;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-1214.435,1136.419;Inherit;False;Property;_WindStrength;WindStrength;16;0;Create;True;0;0;0;False;0;False;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;84;-1430.848,1141.022;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;-1066.688,-808.3575;Inherit;True;Property;_Albedo;Albedo;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SaturateNode;133;-1300.625,-1989.362;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;233;-1091.456,-1012.692;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;119;-915.5128,1408.793;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;97;-957.92,1034.568;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;89;-986.668,909.2065;Inherit;False;Gradient;True;True;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;118;-978.8459,1258.156;Inherit;False;Gradient;True;True;2;0;FLOAT2;0,0;False;1;FLOAT;0.75;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-708.3983,-790.7825;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;132;-1123.625,-1917.362;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;95;-757.7966,1006.206;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;120;-724.303,1285.956;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;123;-257.9676,1515.854;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;5;-1222.582,250.1176;Inherit;False;Property;_SmoothStrength;Smooth Strength;5;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;179;-547.4607,-792.8734;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;137;-930.6834,-1917.417;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;136;-1040.338,-1803.647;Inherit;False;Property;_TranslucencyStrength;TranslucencyStrength;14;0;Create;True;0;0;0;False;0;False;1;0;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;108;-260.0977,1339.828;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;3;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;85;-445.386,1218.725;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;153;-910.9677,150.7949;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;138;-705.1577,-1830.534;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;143;-740.3682,-2091.314;Inherit;False;Constant;_Color0;Color 0;14;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode;148;-436.9781,-1788.36;Inherit;False;Property;_Emission;Emission;6;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.WireNode;245;-487.2845,-1554.818;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;91;-243.268,1194.952;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;145;-297.6211,892.5537;Inherit;False;Constant;_Float0;Float 0;14;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-694.5393,54.96014;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;142;-408.2373,-1934.713;Inherit;False;Property;_TranslucentToggle;TranslucentToggle;13;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;150;-188.0347,-1677.318;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;251;48,112;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TwoSidedSign;249;64,272;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;144;-35.45289,858.1704;Inherit;False;Property;_WindToggle;WindToggle;15;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT4;0,0,0,0;False;0;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;152;-503.5638,58.64416;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;146;-43.53507,-1767.828;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;250;304,192;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;2;-288,-640;Inherit;True;Property;_Normal;Normal;2;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.WireNode;241;652.3249,-568.6196;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;240;553.2632,-412.0735;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;198;473.2198,-327.2522;Inherit;False;Constant;_Float2;Float 2;18;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;235;564.006,-198.9516;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;234;576.8552,-127.1451;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;239;685.32,20.77008;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;238;503.2825,-38.67745;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;256;464,112;Inherit;False;Property;_MirrorVertexNormals;Mirror Vertex Normals;3;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;862.2781,-474.7459;Float;False;True;-1;2;;0;0;Standard;NV3D/Wild Harvest/Foliage;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;199;0;3;1
WireConnection;207;0;199;0
WireConnection;207;2;204;0
WireConnection;207;3;205;0
WireConnection;207;4;204;0
WireConnection;209;0;199;0
WireConnection;209;2;210;0
WireConnection;209;3;211;0
WireConnection;209;4;210;0
WireConnection;213;0;199;0
WireConnection;213;2;214;0
WireConnection;213;3;215;0
WireConnection;213;4;214;0
WireConnection;128;0;125;0
WireConnection;212;0;209;0
WireConnection;216;0;213;0
WireConnection;206;0;207;0
WireConnection;129;0;128;0
WireConnection;129;1;127;0
WireConnection;60;0;42;0
WireConnection;60;1;41;0
WireConnection;60;2;180;2
WireConnection;176;0;8;0
WireConnection;176;2;180;1
WireConnection;222;0;212;0
WireConnection;222;1;14;0
WireConnection;223;0;216;0
WireConnection;223;1;154;0
WireConnection;221;0;206;0
WireConnection;221;1;175;0
WireConnection;126;0;129;0
WireConnection;178;0;176;0
WireConnection;178;1;60;0
WireConnection;224;0;221;0
WireConnection;224;1;222;0
WireConnection;224;2;223;0
WireConnection;232;0;206;0
WireConnection;232;1;212;0
WireConnection;232;2;216;0
WireConnection;117;0;80;0
WireConnection;117;1;99;0
WireConnection;109;0;72;1
WireConnection;109;1;72;3
WireConnection;134;0;126;0
WireConnection;134;1;135;0
WireConnection;84;0;109;0
WireConnection;84;1;117;0
WireConnection;133;0;134;0
WireConnection;233;0;178;0
WireConnection;233;1;224;0
WireConnection;233;2;232;0
WireConnection;119;1;96;0
WireConnection;97;1;96;0
WireConnection;89;0;84;0
WireConnection;118;0;84;0
WireConnection;56;0;233;0
WireConnection;56;1;1;0
WireConnection;132;0;133;0
WireConnection;95;0;89;0
WireConnection;95;3;97;0
WireConnection;95;4;96;0
WireConnection;120;0;118;0
WireConnection;120;3;119;0
WireConnection;120;4;96;0
WireConnection;179;0;56;0
WireConnection;137;0;132;0
WireConnection;108;0;123;2
WireConnection;85;0;95;0
WireConnection;85;2;120;0
WireConnection;153;0;5;0
WireConnection;138;0;179;0
WireConnection;138;1;137;0
WireConnection;138;2;136;0
WireConnection;138;3;3;2
WireConnection;245;0;1;0
WireConnection;91;1;85;0
WireConnection;91;2;108;0
WireConnection;4;0;3;4
WireConnection;4;1;153;0
WireConnection;142;1;143;0
WireConnection;142;0;138;0
WireConnection;150;0;148;0
WireConnection;150;1;245;0
WireConnection;144;1;145;0
WireConnection;144;0;91;0
WireConnection;152;0;4;0
WireConnection;146;0;142;0
WireConnection;146;1;150;0
WireConnection;250;0;251;0
WireConnection;250;1;249;0
WireConnection;241;0;179;0
WireConnection;240;0;146;0
WireConnection;235;0;152;0
WireConnection;234;0;3;3
WireConnection;239;0;144;0
WireConnection;238;0;1;4
WireConnection;256;1;251;0
WireConnection;256;0;250;0
WireConnection;0;0;241;0
WireConnection;0;1;2;0
WireConnection;0;2;240;0
WireConnection;0;3;198;0
WireConnection;0;4;235;0
WireConnection;0;5;234;0
WireConnection;0;10;238;0
WireConnection;0;11;239;0
WireConnection;0;12;256;0
ASEEND*/
//CHKSM=55EA2EC19F182877F89619A09BC83B7014EA013D