shader_type canvas_item;
render_mode blend_mix;

instance uniform vec2 paint_offset;

uniform sampler2D color_map_texture : source_color, filter_linear, repeat_enable;
uniform vec2 color_segment_size = vec2(16, 4);
uniform vec2 segment_offset = vec2(0,0);

void fragment(){
	vec4 texture_color = texture(TEXTURE, UV);
	vec4 converted_texture_color = texture_color;
	if (texture_color.bg != vec2(1.0)){
		vec2 sample_uv = vec2(1.0 - texture_color.r, 1.0 - texture_color.r);
		vec2 color_map_uv = (sample_uv/color_segment_size) + segment_offset + paint_offset;
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