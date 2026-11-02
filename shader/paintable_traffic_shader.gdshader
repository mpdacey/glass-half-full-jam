// NOTE: Shader automatically converted from Godot Engine 4.5.stable's StandardMaterial3D.

shader_type spatial;
render_mode world_vertex_coords, blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx;

instance uniform int paint: hint_enum(
	"Amber", "Baby Blue", "Black", "Blue", "Brown", "Cream", "Dark Grey",
	"Green", "Light Grey", "Orange", "Pink", "Purple", "Red", "Silver",
	"Steel", "Tan", "White", "Yellow"
	) = 0;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_linear, repeat_enable;

uniform vec3 uv1_scale = vec3(1.0);
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

uniform float curve_amount : hint_range(0.01, 1.0, 0.01) = 0.01;

uniform vec4 distant_albeno: source_color = vec4(vec3(1.0), 0.0);
uniform sampler2D distant_texture_albedo: source_color, filter_linear, repeat_enable;
uniform bool has_seperate_distant_texture = false;

uniform float bend_multiplier = 0.0;
uniform float bend_amplifier : hint_range (0, 1.0, 0.01) = 1.0;
varying float calculated_curve;

uniform bool paintable = false;

float remap(float value, float i_min, float i_max, float o_min, float o_max) {
    return o_min + ((value - i_min) / (i_max - i_min) * (o_max - o_min));
}

vec2 get_color_uv_offset() {
	// Amber
	if (paint == 0) {
		return vec2(0.82, 0);
	// Baby Blue
	} else if (paint == 1) {
		return vec2(0.295, -0.25);
	// Black
	} else if (paint == 2) {
		return vec2(0.57, 0.25);
	// Blue
	} else if (paint == 3) {
		return vec2(0.435, 0.25);
	// Brown
	} else if (paint == 4) {
		return vec2(0.3, 0);
	// Cream
	} else if (paint == 5) {
		return vec2(0.565, 0);
	// Dark Grey
	} else if (paint == 6) {
		return vec2(0.81, 0.25);
	// Green
	} else if (paint == 7) {
		return vec2(0.62, 0);
	// Light Grey
	} else if (paint == 8) {
		return vec2(0.945, 0.25);
	// Orange
	} else if (paint == 9) {
		return vec2(0.96, 0);
	// Pink
	} else if (paint == 10) {
		return vec2(0.565, -0.25);
	// Purple
	} else if (paint == 11) {
		return vec2(0.44, -0.25);
	// Red
	} else if (paint == 12) {
		return vec2(0.06, -0.25);
	// Silver
	} else if (paint == 13) {
		return vec2(0.06, 0);
	// Steel
	} else if (paint == 14) {
		return vec2(0.69, 0.25);
	// Tan
	} else if (paint == 15) {
		return vec2(0.44, 0);
	// White
	} else if (paint == 16) {
		return vec2(0.05, 0.25);
	// Yellow
	} else if (paint == 17) {
		return vec2(0.185, 0.25);
	}
	
	return vec2(0);
}

void vertex(){
	UV = UV * uv1_scale.xy + uv1_offset.xy;
	
	if (paintable)
		UV = UV + get_color_uv_offset();

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

	ALPHA_SCISSOR_THRESHOLD = 0.5;
	ALPHA = albedo_tex.a * albedo.a;

	//RIM = 0.2;
	//RIM_TINT = 1.0;
}
