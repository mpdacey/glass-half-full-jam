extends Node

@export var road_segment_material : ShaderMaterial
@export var car_speed := 15.0
var current_position := 0.0

func _physics_process(delta: float) -> void:
	current_position = fmod(current_position + car_speed * delta, 100.0)
	road_segment_material.set_shader_parameter("uv1_offset", Vector2i.RIGHT * current_position / 100.0)
