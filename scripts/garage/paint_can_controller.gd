@tool
extends Control
class_name PaintCanController

const PAINT_SHADER_KEY = "paint"
const PAINT_UV_OFFSET_KEY = "paint_offset"

@export var paint: PaintResource :
	set(value):
		paint = value
		texture_rect.set_instance_shader_parameter(PAINT_UV_OFFSET_KEY, paint.shader_uv_offset)

@export_group("Texture References")
@export var closed_lid_texture: Texture2D
@export var opened_lid_texture: Texture2D

@export_group("Node References")
@export var texture_rect: TextureRect


func _on_paint_applied_signal_emitted(applied_paint: StringName) -> void:
	if applied_paint == paint.paint_name:
		texture_rect.texture = opened_lid_texture
	else:
		texture_rect.texture = closed_lid_texture
