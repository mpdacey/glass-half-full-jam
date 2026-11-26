// NOTE: Shader automatically converted from Godot Engine 4.5.stable's StandardMaterial3D.

shader_type spatial;
render_mode world_vertex_coords, blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

global uniform vec2 player_paint_offset;
global uniform vec2 player_decal_paint_offset;
global uniform int player_decal_index;
global uniform float bend_multiplier;

instance uniform vec2 override_paint_offset;
instance uniform vec2 override_decal_paint_offset;
instance uniform int override_decal_index = -1;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_linear, repeat_enable;
uniform sampler2D decal_albedo : source_color, filter_nearest;
uniform sampler2D override_decal_design: source_color, filter_nearest;
uniform sampler2DArray decal_designs : source_color, filter_linear;

uniform float specular : hint_range(0.0, 1.0, 0.01);
uniform float metallic : hint_range(0.0, 1.0, 0.01);

uniform float curve_amount : hint_range(0.01, 1.0, 0.01) = 0.01;

uniform vec4 distant_albeno: source_color = vec4(vec3(1.0), 0.0);
uniform sampler2D distant_texture_albedo: source_color, filter_linear, repeat_enable;
uniform bool has_seperate_distant_texture = false;

uniform float bend_amplifier : hint_range (0, 1.0, 0.01) = 1.0;
varying float calculated_curve;

float remap(float value, float i_min, float i_max, float o_min, float o_max) {
    return o_min + ((value - i_min) / (i_max - i_min) * (o_max - o_min));
}

vec3 apply_decal(vec3 base, vec2 base_uv, vec2 decal_uv) {
	vec2 decal_paint_offset = player_decal_paint_offset;
	int decal_index = player_decal_index;
	
	if (override_decal_paint_offset != player_decal_paint_offset) {
		decal_paint_offset = override_decal_paint_offset;
	}
	
	if (override_decal_index != player_decal_index) {
		decal_index = override_decal_index;
	}
	
	if (
		decal_paint_offset == vec2(0,0)
		|| decal_index < 0
	) {
		return base;
	}
	
	
	vec2 decal_color_uv = base_uv;
	decal_color_uv += override_decal_paint_offset;
	
	vec4 decal_coords = texture(decal_designs, vec3(decal_uv, float(decal_index)));
	float decal_intensity = decal_coords.r;
	float remapped_decal_instensity = remap(decal_intensity, 0, 1, 0.01, 0.25);
	vec4 decal_color = texture(decal_albedo, vec2(0,-0.25 - remapped_decal_instensity) + decal_paint_offset);
	
	float mix_decal_r = mix(base.r, decal_color.r, decal_coords.a);
	float mix_decal_g = mix(base.g, decal_color.g, decal_coords.a);
	float mix_decal_b = mix(base.b, decal_color.b, decal_coords.a);
	
	vec3 final_color = vec3(mix_decal_r, mix_decal_g, mix_decal_b);
	
	return final_color;
}

void vertex(){
	// Vertex code pinched from svenar-nl godot issue
	// https://github.com/godotengine/godot/issues/91894
	calculated_curve = pow(length(MAIN_CAM_INV_VIEW_MATRIX[3].xyx - VERTEX.xyx) * log((10.0 + curve_amount) * 0.1), 4);
	VERTEX.y -= calculated_curve;
	
	// Calculate the sine and cosine of the angle
    float angle = calculated_curve*bend_multiplier / 360.0 * bend_amplifier;
    float s = sin(angle);
    float c = cos(angle);
    
    // Create a 3x3 rotation matrix around the Y axis
    mat3 rotation_matrix = mat3(
        vec3(c, 0.0, s),
        vec3(0.0, 1.0, 0.0),
        vec3(-s, 0.0, c)
    );
    
    // Apply the rotation matrix to the vertex and normal
    VERTEX = rotation_matrix * VERTEX;
    NORMAL = rotation_matrix * NORMAL;
}

void fragment() {
	vec2 base_uv = UV;

	if (override_paint_offset == vec2(0,0)) {
		base_uv += player_paint_offset;
	} else {
		base_uv += override_paint_offset;
	}

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

	vec3 final_color = vec3(mix_r, mix_g, mix_b);
	
	final_color = apply_decal(final_color, UV, UV2);
	
	ALBEDO = final_color;
	
	METALLIC = metallic;
	SPECULAR = specular;
	
	//ALBEDO = albedo_tex.rgb; //albedo.rgb * albedo_tex.rgb;

	ALPHA_SCISSOR_THRESHOLD = 0.5;
	ALPHA = albedo_tex.a * albedo.a;
	
	//RIM = 0.2;
	//RIM_TINT = 1.0;
}
