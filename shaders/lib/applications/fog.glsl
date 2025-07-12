// uniform float far;
// uniform float rainStrength;
// uniform float thunderStrength;
// uniform vec3 fogColor;

#include "/lib/common/settings.glsl"

vec3 applyFog(in vec3 color, in vec3 pos) {
    float currentFogStart = FOG_START;
    float currentFogEnd = FOG_END;
    float currentFogMax = FOG_MAX;

    // Blends in current weather fog values

    currentFogStart = mix(currentFogStart, FOG_START_RAIN, rainStrength);
    currentFogEnd = mix(currentFogEnd, FOG_END_RAIN, rainStrength);
    currentFogMax = mix(currentFogMax, FOG_MAX_RAIN, rainStrength);

    currentFogStart = mix(currentFogStart, FOG_START_THUNDER, thunderStrength);
    currentFogEnd = mix(currentFogEnd, FOG_END_THUNDER, thunderStrength);
    currentFogMax = mix(currentFogMax, FOG_MAX_THUNDER, thunderStrength);

    float dist = distance(vec3(0.0), pos);

    float atmosphericFogAmount =
        #ifdef FOG
            clamp((dist - currentFogStart) / (currentFogEnd - currentFogStart), 0.0, currentFogMax)
        #else
            0.0
        #endif
    ;

    float borderFogAmount =
        #ifdef BORDER_FOG
            clamp((dist - (BORDER_FOG_START * far)) / ((1.0 - BORDER_FOG_START) * far), 0.0, 1.0)
        #else
            0.0
        #endif
    ;

    float fogAmount = max(atmosphericFogAmount, borderFogAmount);

    return mix(color, fogColor, fogAmount);
}