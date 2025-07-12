#version 460

in vec4 vaColor;
in vec3 vaPosition;

uniform mat4 projectionMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 gbufferProjectionInverse;

out vec4 glcolor;

#include "/lib/common/helpers/transforms.glsl"

void main() {
	glcolor = vaColor;

    vec4 coord = vec4(vaPosition, 1.0);

    gl_Position = ftransform(coord);
}