uniform sampler2D gtexture;
uniform sampler2D lightmap;

in vec2 texCoord;
in vec3 foliageColor;
in vec2 lightmapCoords;

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outColor0;

void main() {
    vec4 texColor = texture(gtexture, texCoord);
    vec3 lightColor = texture(lightmap, lightmapCoords).rgb;

    vec3 color = texColor.rgb * foliageColor * lightColor;

    outColor0 = vec4(color, texColor.a);
}