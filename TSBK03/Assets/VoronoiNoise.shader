Shader "Custom/VoronoiNoise"
{
    Properties {
        _CellSize("Cell Size", Range(0,5)) = 2.5
    }
    
    SubShader {
        Tags{"RenderType"="Opaque" "Queue"="Geometry"}

        CGPROGRAM
        
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        #include "/Random.cginc"    // Random numbers needed for point generation etc.

        float _CellSize;

        struct Input {
            float3 worldPos;
        };

        // 3D VoronoiNoise
        float2 voronoiNoise(float3 value) {
            float3 baseCell = floor(value); // Current cell

            // Make sure min distance is something large to start off with
            float minDistToCell = 10;
            // The actual closest point
            float3 closestCell;

            // Scroll through the loops to take into account neighboring cells,
            // the closest cell center might be in another cell than current cell
            [unroll]
            for(int x = -1; x <= 1; x++) {
                [unroll]
                for(int y = -1; y <= 1; y++) {
                    [unroll]
                    for(int z = -1; z <= 1; z++) {
                        
                        /* 1. Divide our space into cells by flooring input value
                         * 2. Calc. dist. to input value */
                        float3 cell = baseCell + float3(x,y,z);
                        float3 cellPosition = cell + rand3dTo3d(cell);
                        float3 toCell = cellPosition - value;
                        float distToCell = length(toCell);

                        // Update min distance
                        if(distToCell < minDistToCell) {
                            minDistToCell = distToCell;
                            closestCell = cell;
                        }
                    }
                }
            }
            float random = rand3dTo1d(closestCell);
            return float2(minDistToCell, random);
        }

        // "Surface shader part"
        void surf (Input i, inout SurfaceOutputStandard o) {
            // Base input on worldPos for scalability and "skip" uv-mapping
            float3 value = i.worldPos.xyz / _CellSize;
            float noise = voronoiNoise(value).y;
            float3 color = rand1dTo3d(noise);
            o.Albedo = color;
        }
    ENDCG
    }
    FallBack "Standard"
}
