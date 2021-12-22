// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BOXOPHOBIC/The Vegetation Engine/Elements/Default/React Size Fade"
{
	Properties
	{
		[HideInInspector]_IsReactShader("_IsReactShader", Float) = 1
		[StyledBanner(Size Element)]_Banner("Banner", Float) = 0
		[StyledMessage(Info, Use the Size elements to add scale variation or combine it with seasons to add dynamic vegetation growing. Element Texture R is used as alpha mask. Particle Color R is used as values multiplier and Alpha as Element Intensity multiplier., 0,0)]_Message("Message", Float) = 0
		[StyledCategory(Render Settings)]_RenderCat("[ Render Cat ]", Float) = 0
		_ElementIntensity("Element Intensity", Range( 0 , 1)) = 1
		[StyledMessage(Info, When using a higher Layer number the Global Volume will create more render textures to render the elements. Try using fewer layers when posibble., _ElementLayerMessage, 1, 10, 10)]_ElementLayerMessage("Element Layer Message", Float) = 0
		[StyledEnum(Default _Layer 1 _Layer 2 _Layer 3 _Layer 4 _Layer 5 _Layer 6 _Layer 7 _Layer 8)]_ElementLayerValue("Element Layer", Float) = 0
		[Enum(Constant,0,Seasons,1)]_ElementMode("Element Mode", Float) = 0
		[Enum(Multiplicative,0,Additive,1)]_ElementBlendA("Element Blend", Float) = 0
		[StyledCategory(Element Settings)]_ElementCat("[ Element Cat ]", Float) = 0
		[NoScaleOffset][StyledTextureSingleLine]_MainTex("Element Texture", 2D) = "white" {}
		[StyledSpace(10)]_MainTexSpace("#MainTex Space", Float) = 0
		[StyledRemapSlider(_MainTexMinValue, _MainTexMaxValue, 0, 1)]_MainTexRemap("Element Remap", Vector) = (0,0,0,0)
		[HideInInspector]_MainTexMinValue("Element Min", Range( 0 , 1)) = 0
		[HideInInspector]_MainTexMaxValue("Element Max", Range( 0 , 1)) = 1
		[StyledVector(9)]_MainUVs("Element UVs", Vector) = (1,1,0,0)
		_MainValue("Element Value", Range( 0 , 1)) = 1
		_AdditionalValue1("Winter Value", Range( 0 , 1)) = 1
		_AdditionalValue2("Spring Value", Range( 0 , 1)) = 1
		_AdditionalValue3("Summer Value", Range( 0 , 1)) = 1
		_AdditionalValue4("Autumn Value", Range( 0 , 1)) = 1
		[StyledRemapSlider(_NoiseMinValue, _NoiseMaxValue, 0, 1)]_NoiseRemap("Noise Remap", Vector) = (0,0,0,0)
		[StyledCategory(Advanced)]_AdvancedCat("[ Advanced Cat ]", Float) = 0
		[StyledMessage(Info, Use this feature to fade out elements close to a volume edges to avoid rendering issues when the element is exiting the volume., _ElementFadeSupport, 1, 2, 10)]_ElementFadeMessage("Enable Fade Message", Float) = 0
		[ASEEnd][StyledToggle]_ElementFadeSupport("Enable Edge Fade Support", Float) = 0
		[HideInInspector]_IsElementShader("_IsElementShader", Float) = 1
		[HideInInspector]_render_src("_render_src", Float) = 2
		[HideInInspector]_render_dst("_render_dst", Float) = 0

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" "Queue"="Transparent" "PreviewType"="Plane" }
	LOD 0

		CGINCLUDE
		#pragma target 2.0
		ENDCG
		Blend One Zero, [_render_src] [_render_dst]
		AlphaToMask Off
		Cull Off
		ColorMask A
		ZWrite Off
		ZTest LEqual
		
		
		
		Pass
		{
			Name "Unlit"

			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#define ASE_NEEDS_FRAG_COLOR
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			// Element Type Define
			#define TVE_IS_REACT_SHADER


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_color : COLOR;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform half _Banner;
			uniform half _Message;
			uniform half _IsReactShader;
			uniform half4 _MainTexRemap;
			uniform half _ElementLayerMessage;
			uniform half _ElementFadeMessage;
			uniform half _ElementLayerValue;
			uniform half _RenderCat;
			uniform half _IsElementShader;
			uniform half _AdvancedCat;
			uniform half4 _NoiseRemap;
			uniform half _ElementCat;
			uniform half _MainTexSpace;
			uniform float _render_src;
			uniform float _render_dst;
			uniform half _MainValue;
			uniform half4 TVE_SeasonOptions;
			uniform half _AdditionalValue1;
			uniform half _AdditionalValue2;
			uniform half TVE_SeasonLerp;
			uniform half _AdditionalValue3;
			uniform half _AdditionalValue4;
			uniform float _ElementMode;
			uniform sampler2D _MainTex;
			uniform half4 _MainUVs;
			uniform half _MainTexMinValue;
			uniform half _MainTexMaxValue;
			uniform float _ElementIntensity;
			uniform half4 TVE_ColorsCoord;
			uniform half4 TVE_ExtrasCoord;
			uniform half4 TVE_MotionCoord;
			uniform half4 TVE_ReactCoord;
			uniform half TVE_ElementsFadeValue;
			uniform float _ElementFadeSupport;
			uniform half _ElementBlendA;
			half4 IS_ELEMENT( half4 Colors, half4 Extras, half4 Motion, half4 React )
			{
				#if defined (TVE_IS_COLORS_SHADER)
				return Colors;
				#elif defined (TVE_IS_EXTRAS_SHADER)
				return Extras;
				#elif defined (TVE_IS_MOTION_SHADER)
				return Motion;
				#elif defined (TVE_IS_REACT_SHADER)
				return React;
				#else
				return Colors;
				#endif
			}
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_color = v.color;
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				half3 Final_Size_RGB228_g1 = half3(0,0,0);
				half Value_Main157_g1 = _MainValue;
				half TVE_SeasonOptions_X50_g1 = TVE_SeasonOptions.x;
				half Value_Winter158_g1 = _AdditionalValue1;
				float temp_output_427_0_g1 = ( 1.0 - Value_Winter158_g1 );
				half Value_Spring159_g1 = _AdditionalValue2;
				float temp_output_428_0_g1 = ( 1.0 - Value_Spring159_g1 );
				half TVE_SeasonLerp54_g1 = TVE_SeasonLerp;
				float lerpResult419_g1 = lerp( temp_output_427_0_g1 , temp_output_428_0_g1 , TVE_SeasonLerp54_g1);
				half TVE_SeasonOptions_Y51_g1 = TVE_SeasonOptions.y;
				half Value_Summer160_g1 = _AdditionalValue3;
				float temp_output_429_0_g1 = ( 1.0 - Value_Summer160_g1 );
				float lerpResult422_g1 = lerp( temp_output_428_0_g1 , temp_output_429_0_g1 , TVE_SeasonLerp54_g1);
				half TVE_SeasonOptions_Z52_g1 = TVE_SeasonOptions.z;
				half Value_Autumn161_g1 = _AdditionalValue4;
				float temp_output_430_0_g1 = ( 1.0 - Value_Autumn161_g1 );
				float lerpResult407_g1 = lerp( temp_output_429_0_g1 , temp_output_430_0_g1 , TVE_SeasonLerp54_g1);
				half TVE_SeasonOptions_W53_g1 = TVE_SeasonOptions.w;
				float lerpResult415_g1 = lerp( temp_output_430_0_g1 , temp_output_427_0_g1 , TVE_SeasonLerp54_g1);
				half Element_Mode55_g1 = _ElementMode;
				float lerpResult413_g1 = lerp( ( 1.0 - ( Value_Main157_g1 * i.ase_color.r ) ) , ( ( ( TVE_SeasonOptions_X50_g1 * lerpResult419_g1 ) + ( TVE_SeasonOptions_Y51_g1 * lerpResult422_g1 ) + ( TVE_SeasonOptions_Z52_g1 * lerpResult407_g1 ) + ( TVE_SeasonOptions_W53_g1 * lerpResult415_g1 ) ) * i.ase_color.r ) , Element_Mode55_g1);
				half Base_Extras_A423_g1 = ( 1.0 - lerpResult413_g1 );
				float2 temp_output_11_0_g1 = ( ( ( 1.0 - i.ase_texcoord1.xy ) * (_MainUVs).xy ) + (_MainUVs).zw );
				float4 tex2DNode17_g1 = tex2D( _MainTex, temp_output_11_0_g1 );
				float temp_output_7_0_g19405 = _MainTexMinValue;
				float4 temp_cast_0 = (temp_output_7_0_g19405).xxxx;
				float4 break469_g1 = saturate( ( ( tex2DNode17_g1 - temp_cast_0 ) / ( _MainTexMaxValue - temp_output_7_0_g19405 ) ) );
				half MainTex_R73_g1 = break469_g1.r;
				float lerpResult224_g1 = lerp( 1.0 , Base_Extras_A423_g1 , MainTex_R73_g1);
				half4 Colors37_g19401 = TVE_ColorsCoord;
				half4 Extras37_g19401 = TVE_ExtrasCoord;
				half4 Motion37_g19401 = TVE_MotionCoord;
				half4 React37_g19401 = TVE_ReactCoord;
				half4 localIS_ELEMENT37_g19401 = IS_ELEMENT( Colors37_g19401 , Extras37_g19401 , Motion37_g19401 , React37_g19401 );
				float4 temp_output_35_0_g19399 = localIS_ELEMENT37_g19401;
				float temp_output_7_0_g19389 = TVE_ElementsFadeValue;
				float2 temp_cast_1 = (temp_output_7_0_g19389).xx;
				float2 temp_output_851_0_g1 = saturate( ( ( abs( (( (temp_output_35_0_g19399).zw + ( (temp_output_35_0_g19399).xy * (WorldPosition).xz ) )*2.0 + -1.0) ) - temp_cast_1 ) / ( 1.0 - temp_output_7_0_g19389 ) ) );
				float2 break852_g1 = ( temp_output_851_0_g1 * temp_output_851_0_g1 );
				half Enable_Fade_Support454_g1 = _ElementFadeSupport;
				float lerpResult842_g1 = lerp( 1.0 , ( 1.0 - saturate( ( break852_g1.x + break852_g1.y ) ) ) , Enable_Fade_Support454_g1);
				half FadeOut_Mask656_g1 = lerpResult842_g1;
				half Element_Intensity56_g1 = ( _ElementIntensity * i.ase_color.a * FadeOut_Mask656_g1 );
				float lerpResult799_g1 = lerp( 1.0 , lerpResult224_g1 , Element_Intensity56_g1);
				half Element_BlendA918_g1 = _ElementBlendA;
				float lerpResult941_g1 = lerp( lerpResult799_g1 , ( Base_Extras_A423_g1 * MainTex_R73_g1 * Element_Intensity56_g1 ) , Element_BlendA918_g1);
				half Final_Size_A229_g1 = lerpResult941_g1;
				float4 appendResult473_g1 = (float4(Final_Size_RGB228_g1 , Final_Size_A229_g1));
				
				
				finalColor = ( appendResult473_g1 + ( Element_BlendA918_g1 * 0.0 ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "TVEShaderElementGUI"
	
	
}
/*ASEBEGIN
Version=18909
1920;0;1920;1029;1092.264;1730.589;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;109;-512,-1280;Half;False;Property;_Banner;Banner;2;0;Create;True;0;0;0;True;1;StyledBanner(Size Element);False;0;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;112;-384,-1280;Half;False;Property;_Message;Message;3;0;Create;True;0;0;0;True;1;StyledMessage(Info, Use the Size elements to add scale variation or combine it with seasons to add dynamic vegetation growing. Element Texture R is used as alpha mask. Particle Color R is used as values multiplier and Alpha as Element Intensity multiplier., 0,0);False;0;0;1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;129;-768,-1280;Inherit;False;Define Element React;0;;19401;9f8670cd8fdc98444822270656343d82;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;131;-768,-1025;Inherit;False;Base Element;4;;1;0e972c73cae2ee54ea51acc9738801d0;7,477,2,478,0,145,1,481,4,576,1,491,1,903,0;0;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;133;32,-1280;Inherit;False;Property;_render_dst;_render_dst;53;1;[HideInInspector];Create;True;0;0;0;True;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;132;-128,-1280;Inherit;False;Property;_render_src;_render_src;52;1;[HideInInspector];Create;True;0;0;0;True;0;False;2;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-432,-1024;Float;False;True;-1;2;TVEShaderElementGUI;0;1;BOXOPHOBIC/The Vegetation Engine/Elements/Default/React Size Fade;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;0;2;False;-1;0;False;-1;1;0;True;132;0;True;133;True;0;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;2;False;-1;True;True;False;False;False;True;0;False;-1;False;False;False;False;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;0;False;-1;True;False;0;False;-1;0;False;-1;True;3;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;PreviewType=Plane;True;0;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;0;0;131;0
ASEEND*/
//CHKSM=1E006B2F35522B7D473B1986A2C13075D4CFA54B