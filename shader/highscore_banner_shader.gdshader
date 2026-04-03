shader_type spatial;
render_mode world_vertex_coords, blend_mix, depth_draw_opaque, cull_disabled, diffuse_burley, specular_schlick_ggx;

uniform sampler2D banner_texture : source_color, filter_linear_mipmap, repeat_disable;
uniform float curve_amount : hint_range(0.01, 1.0, 0.01) = 0.1;
uniform float flap_multiplier = 0.1;

uniform vec4 main_colour: source_color;
uniform vec4 shading_colour: source_color;

uniform float sigma: hint_range(0.,1.,.01) = 0.5;
uniform float power: hint_range(0.,100.,.25) = 5.0;
uniform float scale: hint_range(0.,50.,.1) = 3.3;
uniform float albedo_influence: hint_range(0.,1.,.01) = 0.7;
uniform float light_color_influence: hint_range(0.,1.,.01) = 0.3;
uniform float attenuation_influence: hint_range(0.,1.,.01) = 1.0;

uniform vec3 uv1_scale = vec3(1.0);
uniform vec3 uv1_offset;

float remap(float value, float i_min, float i_max, float o_min, float o_max) {
    return o_min + ((value - i_min) / (i_max - i_min) * (o_max - o_min));
}

float get_positional_value(vec3 vertex) {
	return sin(TIME * 5.0 + vertex.y) * vertex.y;
}

void vertex() {
	UV = UV * uv1_scale.xy + uv1_offset.xy;
	VERTEX.x += sin(TIME * 5.0 + VERTEX.y) * VERTEX.y * flap_multiplier;

	// Vertex code pinched from svenar-nl godot issue
	// https://github.com/godotengine/godot/issues/91894
	VERTEX.y -= pow(length(MAIN_CAM_INV_VIEW_MATRIX[3].xyx - VERTEX.xyx) * log((10.0 + curve_amount) * 0.1), 4);
	
}

void fragment() {
	vec4 albedo_tex = texture(banner_texture, UV);
	
	float light_wave = (cos(TIME * 5.0 + VERTEX.y) + 1.0) * 0.5;
	float dark_wave = (sin((TIME - 0.2) * 5.0 + VERTEX.y) + 1.0) * 0.5;
	
	ALBEDO = albedo_tex.rgb * (main_colour.rgb * light_wave + shading_colour.rgb * dark_wave);
	ALPHA_SCISSOR_THRESHOLD = 0.2;
	ALPHA = albedo_tex.a;
}

float get_sss(vec3 n, vec3 v, vec3 l, float s)
{
	l = normalize(l);
	float kSSS = pow(clamp(dot((-l+n*s), v),0.,1.),power);
	return kSSS;
}


void light() {
	// Pass through light controls by int_45h : https://godotshaders.com/shader/simple-foliage-subsurface-scattering-shader/
	vec3 n2 = normalize(vec3(0,1,0)+.5);
	float kD = max(dot(normalize(LIGHT), n2),0.0);
	float s = sigma;
	float kSSS = get_sss(NORMAL, VIEW, LIGHT, s);

	vec3 SSS_color = albedo_influence*ALBEDO+light_color_influence*LIGHT_COLOR;

	DIFFUSE_LIGHT += (SSS_color)*(max(mix(1.,ATTENUATION,attenuation_influence),0.001)*(.3+max(kD*scale,kSSS*scale)));
}
