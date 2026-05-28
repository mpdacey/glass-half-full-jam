// NOTE: Shader automatically converted from Godot Engine 4.5.stable's StandardMaterial3D.

shader_type spatial;
render_mode world_vertex_coords, blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_linear, repeat_enable;
uniform ivec2 albedo_texture_size;
uniform float point_size : hint_range(0.1, 128.0, 0.1);

uniform float roughness : hint_range(0.0, 1.0);
uniform sampler2D texture_metallic : hint_default_white, filter_linear_mipmap, repeat_enable;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_roughness_r, filter_linear_mipmap, repeat_enable;

uniform float specular : hint_range(0.0, 1.0, 0.01);
uniform float metallic : hint_range(0.0, 1.0, 0.01);

uniform vec3 uv1_scale = vec3(1.0);
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

uniform float curve_amount : hint_range(0.01, 1.0, 0.01) = 0.01;

uniform vec4 distant_albeno: source_color = vec4(vec3(1.0), 0.0);
uniform sampler2D distant_texture_albedo: source_color, filter_linear, repeat_enable;
uniform bool has_seperate_distant_texture = false;

varying float calculated_curve;

float remap(float value, float i_min, float i_max, float o_min, float o_max) {
    return o_min + ((value - i_min) / (i_max - i_min) * (o_max - o_min));
}

void vertex(){
	UV = UV * uv1_scale.xy + uv1_offset.xy;

	// Vertex code pinched from svenar-nl godot issue
	// https://github.com/godotengine/godot/issues/91894
	calculated_curve = pow(length(MAIN_CAM_INV_VIEW_MATRIX[3].xyx - VERTEX.xyx) * log((10.0 + curve_amount) * 0.1), 4);
	VERTEX.y -= calculated_curve;
}

void fragment() {
	vec2 base_uv = UV;

	vec4 albedo_tex = texture(texture_albedo, base_uv);
	
	float mix_amount = clamp(pow(calculated_curve, 0.3)-0.4, 0.0, 1.0);
	vec3 mix_near = albedo_tex.rgb * albedo.rgb;
	
	vec4 distant_tex = texture(distant_texture_albedo, base_uv);
	if (!has_seperate_distant_texture)
	{
		distant_tex = albedo_tex;
	}
	
	vec3 distant_albeno_blend;
	
	distant_albeno_blend.r = mix(albedo.r, distant_albeno.r, distant_albeno.a);
	distant_albeno_blend.g = mix(albedo.g, distant_albeno.g, distant_albeno.a);
	distant_albeno_blend.b = mix(albedo.b, distant_albeno.b, distant_albeno.a);
	
	vec3 mix_far = distant_tex.rgb * distant_albeno_blend.rgb;
	
	float mix_r = mix(mix_near.r, mix_far.r, mix_amount * distant_albeno.a);
	float mix_g = mix(mix_near.g, mix_far.g, mix_amount * distant_albeno.a);
	float mix_b = mix(mix_near.b, mix_far.b, mix_amount * distant_albeno.a);
	
	ALBEDO = vec3(mix_r, mix_g, mix_b);
	
	//ALBEDO = albedo_tex.rgb; //albedo.rgb * albedo_tex.rgb;

	float metallic_tex = dot(texture(texture_metallic, base_uv), metallic_texture_channel);
	METALLIC = metallic_tex * metallic;
	SPECULAR = specular;

	vec4 roughness_texture_channel = vec4(1.0, 0.0, 0.0, 0.0);
	float roughness_tex = dot(texture(texture_roughness, base_uv), roughness_texture_channel);
	ROUGHNESS = roughness_tex * roughness;

	ALPHA_SCISSOR_THRESHOLD = 0.5;
	ALPHA = albedo_tex.a * albedo.a;
	
	//RIM = 0.2;
	//RIM_TINT = 1.0;
}
