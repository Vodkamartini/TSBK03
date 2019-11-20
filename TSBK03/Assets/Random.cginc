// This file provides functions to generate random numbers based on input dimensions
#ifndef WHITE_NOISE
#define WHITE_NOISE

// 1D --> 1D
float rand1dTo1d(float3 value, float mutator = 0.546) {
    float random = frac(sin(value + mutator) * 143758.5433);
    return random;
}
// 1D --> 3D
float3 rand1dTo3d(float value) {
    return float3(
            rand1dTo1d(value, 3.9812),
            rand1dTo1d(value, 7.1536),
            rand1dTo1d(value, 5.7241)
    );
}

// 2D --> 1D
float rand2dTo1d(float2 value, float2 dotDir = float2(12.9898, 78.233)){
	float2 smallValue = sin(value);
	float random = dot(smallValue, dotDir);
	random = frac(sin(random) * 143758.5453);
	return random;
}

// 2D --> 2D
float2 rand2dTo2d(float2 value){
	return float2(
		rand2dTo1d(value, float2(12.989, 78.233)),
		rand2dTo1d(value, float2(39.346, 11.135))
	);
}

// 3D --> 1D
float rand3dTo1d(float3 value, float3 dotDir = float3(12.9898, 78.233, 37.719)) {
    // Make value smaller to avoid artefacts
    float3 smallValue = sin(value);
    float random = dot(smallValue,dotDir);
    random = frac(sin(random * 143758.5453));
    return random;
}

// 3D --> 3D
float3 rand3dTo3d(float3 value){
	return float3(
		rand3dTo1d(value, float3(12.989, 78.233, 37.719)),
		rand3dTo1d(value, float3(39.346, 11.135, 83.155)),
		rand3dTo1d(value, float3(73.156, 52.235, 09.151))
	);
}

#endif