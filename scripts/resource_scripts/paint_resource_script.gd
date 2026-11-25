@icon("res://textures/editor/drawing_spray.svg")

extends Resource
class_name PaintResource

@export var paint_name : StringName
@export var price : int = 1000
@export var particle_colour : Color = Color.WHITE
@export var shader_uv_offset : Vector2
