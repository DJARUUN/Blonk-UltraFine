uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform sampler2D normals;
uniform sampler2D specular;
uniform sampler2D shadowtex0;
uniform float far;
uniform float rainStrength;
uniform float thunderStrength;
uniform vec3 fogColor;
uniform mat4 gbufferModelViewInverse;
uniform vec3 shadowLightPosition;
uniform mat4 projectionMatrix;
uniform mat4 modelViewMatrix;
uniform mat4 gbufferProjectionInverse;
uniform vec3 cameraPosition;
uniform float viewWidth;
uniform float viewHeight;

in vec2 texCoord;
in vec3 foliageColor;
in vec2 lightmapCoords;
in vec4 coord;
in vec3 normal;
in vec4 tangent;

#include "/lib/applications/fog.glsl"
#include "/lib/applications/pbr.glsl"

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outColor0;

void main() {
    vec4 texColor = texture(gtexture, texCoord);
    vec3 lightColor = texture(lightmap, lightmapCoords).rgb;

    vec3 color = texColor.rgb * foliageColor * lightColor;

    vec3 shadowLightDir = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);

    vec3 worldNormal = mat3(gbufferModelViewInverse) * normal;
    vec3 worldTexNormal = applyNormal(texCoord, worldNormal, tangent);

    // BEGIN SPECULARITY //

    vec4 specularData = texture(specular, texCoord);

    float perceptualSmoothness = specularData.r;

    float metallic = 0.0;
    vec3 reflectance = vec3(0.0);

    if (specularData.g * 255 > 229) {
        metallic = 1.0;
        reflectance = color;
    } else {
        reflectance = vec3(specularData.g);
    }

    float roughness = pow(1.0 - perceptualSmoothness, 2.0);
    float smoothness = 1 - roughness;
    float shininess = 1 + (smoothness * 100);

    vec3 reflectionDir = reflect(-shadowLightDir, worldTexNormal);

    vec3 fragFeetPlayerSpace = (gbufferModelViewInverse * coord).xyz;
    vec3 fragWorldSpace = fragFeetPlayerSpace + cameraPosition;
    vec3 viewDir = normalize(cameraPosition - fragWorldSpace);

    // END SPECULARITY //

    // BEGIN SHADOWS //

    vec3 shadow = texture(shadowtex0, gl_FragCoord.xy / vec2(viewWidth, viewHeight)).rgb;

    // END SHADOWS //

    vec3 ambientLightDir = worldNormal;
    float ambientLight = 0.2 * clamp(dot(ambientLightDir, worldTexNormal), 0.0, 1.0);

    color *= vec3(ambientLight) + brdf(shadowLightDir, viewDir, roughness, worldTexNormal, color, metallic, reflectance);

    if (texColor.a < 0.1) {
        discard;
    }

    #ifdef WANTS_FOG
        color = applyFog(color, coord.xyz);
    #endif

    outColor0 = vec4(color, texColor.a);
}