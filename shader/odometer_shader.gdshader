shader_type canvas_item;

const float offset = 0.05;

uniform sampler2D numbers : source_color, filter_linear, repeat_enable;
uniform float display_number = 0.0;

void fragment() {
	vec2 number_uv = vec2(UV.r, (UV.g - 1.0 - display_number+offset)*0.1);
	COLOR.rbga = texture(numbers, number_uv);
}
