// uniform mat4 projectionMatrix;
// uniform mat4 modelViewMatrix;
// uniform mat4 gbufferProjectionInverse;

vec4 ftransform(in vec4 coord) {
    return projectionMatrix * modelViewMatrix * coord;
}

vec3 screenToView(vec3 screenPos) {
	vec4 ndcPos = vec4(screenPos, 1.0) * 2.0 - 1.0;
	vec4 tmp = gbufferProjectionInverse * ndcPos;
	return tmp.xyz / tmp.w;
}