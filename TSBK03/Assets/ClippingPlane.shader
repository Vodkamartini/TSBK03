Shader "Custom/ClippingPlane"
{
    Properties {
        _Color ("Tint", Color) = (0,0,0,1)
        _MainTex ("Texture", 2D) = "white" {}
        _Smoothness ("Smoothness", Range(0,1)) = 0
        _Metallic ("Metalness", Range(0,1)) = 0
        [HDR]_Emission ("Emission", color) = (0,0,0)

        [HRD]_CutoffColor("Cutoff Color", Color) = (1,0,0,0)
    }

    SubShader {
        Tags{"RenderType"="Opaque" "Queue"="Geometry"}

        // Render faces regardless if they point towards the camera of away from it
        // I.e. let us see the inside of cut object
        Cull Off

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        fixed4 _Color;

        half _Smoothness;
        half _Metallic;
        half3 _Emission;

        float4 _Plane;  // Since we don't write from the inspector, we don't need a property
        float4 _CutoffColor;

        struct Input {
            float2 uv_MainTex;
            float3 worldPos;
            float facing : VFACE;
        };

        void surf(Input i, inout SurfaceOutputStandard o) {
            // Calculate singed distance to plane
            float distance = dot(i.worldPos, _Plane.xyz);
            distance = distance + _Plane.w;
            clip(-distance);
            o.Emission = distance;

            float facing = i.facing * 0.5 + 0.5;

            // Color stuff
            fixed4 col = tex2D(_MainTex, i.uv_MainTex);
            col *= _Color;
            o.Albedo = col.rgb * facing;
            o.Metallic = _Metallic * facing;
            o.Smoothness = _Smoothness * facing;
            o.Emission = lerp(_CutoffColor, _Emission, facing);
        }

        ENDCG
    }
    FallBack "Standard"
}
