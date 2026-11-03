extends Node
class_name TrafficPainter

const PAINT_SHADER_KEY = "paint"

enum Paint {
	AMBER, BABY_BLUE, BLACK, BLUE, BROWN, CREAM, DARK_GREY,
	GREEN, LIGHT_GREY, ORANGE, PINK, PURPLE, RED, SILVER,
	STEEL, TAN, WHITE, YELLOW
}

@export var mesh : MeshInstance3D
@export var weighted_paints: Dictionary[Paint, float]

func _ready() -> void:
	if not mesh:
		return
	
	set_random_paint()

func set_random_paint() -> void:
	mesh.set_instance_shader_parameter(PAINT_SHADER_KEY, _pick_paint())

func _pick_paint() -> int:
	if weighted_paints.size() <= 0:
		return Paint.SILVER
	
	var total_weight := 0.0
	for weight : float in weighted_paints.values():
		total_weight += weight
	
	var random_weight := randf() * total_weight
	
	for paint : int in weighted_paints.keys():
		if random_weight > weighted_paints[paint]:
			random_weight -= weighted_paints[paint]
			continue
		return paint
	return weighted_paints.keys()[0]
