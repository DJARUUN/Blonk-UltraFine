uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform float far;
uniform float rainStrength;
uniform float thunderStrength;
uniform vec3 fogColor;

in vec2 texCoord;
in vec3 foliageColor;
in vec2 lightmapCoords;
in vec4 coord;

#include "/lib/applications/fog.glsl"

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outColor0;

void main() {
    vec3 lightColor = texture(lightmap, lightmapCoords).rgb;

    vec4 texColor = texture(gtexture, texCoord);

    vec3 color = texColor.rgb * foliageColor * lightColor;

    if (texColor.a < 0.1) {
        discard;
    }

    #ifdef WANTS_FOG
        color = applyFog(color, coord.xyz);
    #endif

    outColor0 = vec4(color, texColor.a);
}