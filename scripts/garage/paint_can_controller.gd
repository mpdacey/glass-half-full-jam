@tool
extends Control

const PAINT_SHADER_KEY = "paint"

@export var paint_color: GlobalConstants.Paint :
	set(value):
		paint_color = value
		texture.set_instance_shader_parameter(PAINT_SHADER_KEY, paint_color)
@export var texture: TextureRect
