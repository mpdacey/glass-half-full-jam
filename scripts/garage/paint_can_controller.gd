@tool
extends Control
class_name PaintCanController

const PAINT_SHADER_KEY = "paint"
const PAINT_UV_OFFSET_KEY = "paint_offset"

@export var paint: PaintResource :
	set(value):
		paint = value
		texture.set_instance_shader_parameter(PAINT_UV_OFFSET_KEY, paint.shader_uv_offset)

@export var texture: TextureRect
