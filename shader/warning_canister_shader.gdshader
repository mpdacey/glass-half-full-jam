// NOTE: Shader automatically converted from Godot Engine 4.5.stable's StandardMaterial3D.

shader_type spatial;
render_mode world_vertex_coords, blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_schlick_ggx, unshaded, depth_test_disabled;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_nearest;

uniform vec3 uv1_scale;
uniform vec3 uv1_offset;

uniform float curve_amount : hint_range(0.01, 1.0, 0.01) = 0.01;
uniform float bend_multiplier = 0.0;
uniform float bend_amplifier : hint_range (0, 1.0, 0.01) = 1.0;
uniform float uv_counter_weight = -0.35;
varying float calculated_curve;

void vertex() {
	UV = UV * uv1_scale.xy + uv1_offset.xy;

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
	ALBEDO = albedo.rgb * albedo_tex.rgb;

	ALPHA *= albedo.a * albedo_tex.a;
}
