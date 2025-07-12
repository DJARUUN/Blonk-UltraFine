in vec3 vaPosition;
in vec2 vaUV0;
in ivec2 vaUV2;
in vec4 vaColor;

uniform mat4 projectionMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 gbufferProjectionInverse;

out vec2 texCoord;
out vec3 foliageColor;
out vec2 lightmapCoords;

#include "/lib/common/helpers/transforms.glsl"

void main() {
    texCoord = vaUV0;
    foliageColor = vaColor.rgb;
    lightmapCoords = vaUV2 * (1.0 / 256.0) + (1.0 / 32.0);

    vec4 coord = vec4(vaPosition, 1.0);

    gl_Position = ftransform(coord);
}