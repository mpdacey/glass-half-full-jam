shader_type canvas_item;
render_mode blend_mix;

instance uniform int paint: hint_enum(
	"Amber", "Baby Blue", "Black", "Blue", "Brown", "Cream", "Dark Grey",
	"Green", "Light Grey", "Orange", "Pink", "Purple", "Red", "Silver",
	"Steel", "Tan", "White", "Yellow"
	) = 0;

uniform sampler2D color_map_texture : source_color, filter_linear, repeat_enable;
uniform vec2 color_segment_size = vec2(16, 4);
uniform vec2 segment_offset = vec2(0,0);

vec2 get_color_uv_offset() {
	// Amber
	if (paint == 0) {
		return vec2(0.8125, 0);
	// Baby Blue
	} else if (paint == 1) {
		return vec2(0.3125, -0.25);
	// Black
	} else if (paint == 2) {
		return vec2(0.5625, 0.25);
	// Blue
	} else if (paint == 3) {
		return vec2(0.4375, 0.25);
	// Brown
	} else if (paint == 4) {
		return vec2(0.3125, 0);
	// Cream
	} else if (paint == 5) {
		return vec2(0.5625, 0);
	// Dark Grey
	} else if (paint == 6) {
		return vec2(0.8125, 0.25);
	// Green
	} else if (paint == 7) {
		return vec2(0.625, 0);
	// Light Grey
	} else if (paint == 8) {
		return vec2(0.9375, 0.25);
	// Orange
	} else if (paint == 9) {
		return vec2(0.9375, 0);
	// Pink
	} else if (paint == 10) {
		return vec2(0.5625, -0.25);
	// Purple
	} else if (paint == 11) {
		return vec2(0.4375, -0.25);
	// Red
	} else if (paint == 12) {
		return vec2(0.0625, -0.25);
	// Silver
	} else if (paint == 13) {
		return vec2(0.0625, 0);
	// Steel
	} else if (paint == 14) {
		return vec2(0.6875, 0.25);
	// Tan
	} else if (paint == 15) {
		return vec2(0.4375, 0);
	// White
	} else if (paint == 16) {
		return vec2(0.0625, 0.25);
	// Yellow
	} else if (paint == 17) {
		return vec2(0.1875, 0.25);
	}
	
	return vec2(0);
}

void fragment(){
	vec2 segment_uv = (UV) * (vec2(1.0)/color_segment_size) + segment_offset + get_color_uv_offset();
	
	vec4 texture_color = texture(TEXTURE, UV);
	vec4 converted_texture_color = texture_color;
	if (texture_color.bg != vec2(1.0)){
		vec2 sample_uv = vec2(1.0 - texture_color.r, 1.0 - texture_color.r);
		vec2 color_map_uv = (sample_uv/color_segment_size) + segment_offset + get_color_uv_offset();
		converted_texture_color = texture(color_map_texture, color_map_uv);
		converted_texture_color.a = texture_color.a;
	}
	
	vec4 texture_outline = texture(TEXTURE, UV);
	if (texture_outline.rbg != vec3(1.0) && texture_outline.a > 0.0){
		texture_outline.a = texture_outline.b;
		texture_outline.rbg = vec3(1.0);
	}
	
	vec4 final_color = converted_texture_color;
	if (texture_outline.a > 0.0){
		final_color.rbg = vec3(
			mix(final_color.r, texture_outline.r, texture_outline.a),
			mix(final_color.b, texture_outline.b, texture_outline.a),
			mix(final_color.g, texture_outline.g, texture_outline.a)
		);
	}
	
	COLOR = final_color;
}