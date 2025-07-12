in vec3 vaPosition;
in vec2 vaUV0;
in ivec2 vaUV2;
in vec4 vaColor;
in vec3 vaNormal;
in vec4 at_tangent;

uniform mat4 projectionMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 gbufferProjectionInverse;
uniform vec3 chunkOffset; // Is 0 for anything that ísnt terrain
uniform mat3 normalMatrix;

out vec2 texCoord;
out vec3 foliageColor;
out vec2 lightmapCoords;
out vec4 coord;
out vec3 normal;
out vec4 tangent;

#include "/lib/common/helpers/transforms.glsl"

void main() {
    texCoord = vaUV0;
    foliageColor = vaColor.rgb;
    lightmapCoords = vaUV2 * (1.0 / 256.0) + (1.0 / 32.0);
    coord = vec4(vaPosition + chunkOffset, 1.0);
    normal = normalMatrix * vaNormal;
    tangent = vec4(normalize(normalMatrix * at_tangent.rgb), at_tangent.a);

    gl_Position = ftransform(coord);
}