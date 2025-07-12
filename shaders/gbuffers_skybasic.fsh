#version 460

in vec3 vaPosition;

uniform int renderStage;
uniform float viewHeight;
uniform float viewWidth;
uniform mat4 gbufferModelView;
uniform mat4 gbufferProjectionInverse;
uniform mat4 projectionMatrix;
uniform mat4 modelViewMatrix;
uniform vec3 fogColor;
uniform vec3 skyColor;

in vec4 glcolor;

#include "/lib/common/helpers/transforms.glsl"
#include "/lib/common/helpers/atmospherics.glsl"

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 outColor0;

void main() {
    vec4 color;

	if (renderStage == MC_RENDER_STAGE_STARS) {
		color = glcolor;
	} else {
		vec3 pos = screenToView(vec3(gl_FragCoord.xy / vec2(viewWidth, viewHeight), 1.0));
		color = vec4(calcSkyColor(normalize(pos)), 1.0);
	}

    outColor0 = color;
}