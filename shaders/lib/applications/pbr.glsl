// uniform mat4 gbufferModelViewInverse;
// uniform sampler2D normals;

#include "/lib/common/settings.glsl"

mat3 tbnNormalTangent(vec3 normal, vec3 tangent) {
	// For DirectX normal mapping you want to switch the order of these
	vec3 bitangent = cross(tangent, normal);
	return mat3(tangent, bitangent, normal);
}

vec3 brdf(vec3 lightDir, vec3 viewDir, float roughness, vec3 normal, vec3 albedo, float metallic, vec3 reflectance) {
    float alpha = pow(roughness, 2);

    vec3 H = normalize(lightDir + viewDir);

    //dot products
    float NdotV = clamp(dot(normal, viewDir), 0.001, 1.0);
    float NdotL = clamp(dot(normal, lightDir), 0.001, 1.0);
    float NdotH = clamp(dot(normal,H), 0.001, 1.0);
    float VdotH = clamp(dot(viewDir, H), 0.001, 1.0);

    // Fresnel
    vec3 F0 = reflectance;
    vec3 fresnelReflectance = F0 + (1.0 - F0) * pow(1.0 - VdotH, 5.0); //Schlick's Approximation

    //phong diffuse
    vec3 rhoD = albedo;
    rhoD *= vec3(1.0) - fresnelReflectance; //energy conservation - light that doesn't reflect adds to diffuse

    //rhoD *= (1-metallic); //diffuse is 0 for metals

    // Geometric attenuation
    float k = alpha / 2;
    float geometry = (NdotL / (NdotL * (1 - k) + k)) * (NdotV / ((NdotV * (1 - k) + k)));

    // Distribution of Microfacets
    float lowerTerm = pow(NdotH, 2) * (pow(alpha, 2) - 1.0) + 1.0;
    float normalDistributionFunctionGGX = pow(alpha, 2) / (3.14159 * pow(lowerTerm, 2));

    vec3 phongDiffuse = rhoD;
    vec3 cookTorrance = (fresnelReflectance*normalDistributionFunctionGGX*geometry) / (4 * NdotL * NdotV);

    vec3 BRDF = (phongDiffuse + cookTorrance) * NdotL;

    vec3 diffFunction = BRDF;

    return BRDF;
}

vec3 applyNormal(in vec2 texCoord, in vec3 worldNormal, in vec4 tangent) {
    #ifdef NORMALS
        vec3 worldTangent = mat3(gbufferModelViewInverse) * tangent.xyz;

        vec4 texNormalData = texture(normals, texCoord) * 2.0 - 1.0;
        vec3 texNormal = vec3(texNormalData.xy, sqrt(1.0 - dot(texNormalData.xy, texNormalData.xy)));

        mat3 TBN = tbnNormalTangent(worldNormal, worldTangent);
        vec3 worldTexNormal = TBN * texNormal;

        return worldTexNormal;

    #else
        return worldNormal;
    #endif
}