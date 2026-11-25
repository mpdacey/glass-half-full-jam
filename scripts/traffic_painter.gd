extends Node
class_name TrafficPainter

const PAINT_UV_OFFSET_KEY = "paint_offset"

@export var mesh : MeshInstance3D
@export var weighted_paints: Dictionary[PaintResource, float]

func _ready() -> void:
	if not mesh:
		return
	
	set_random_paint()

func set_random_paint() -> void:
	mesh.set_instance_shader_parameter(PAINT_UV_OFFSET_KEY, _pick_paint().shader_uv_offset)

func _pick_paint() -> PaintResource:
	if weighted_paints.size() <= 0:
		return PaintResource.new()
	
	var total_weight := 0.0
	for weight : float in weighted_paints.values():
		total_weight += weight
	
	var random_weight := randf() * total_weight
	
	for paint : PaintResource in weighted_paints.keys():
		if random_weight > weighted_paints[paint]:
			random_weight -= weighted_paints[paint]
			continue
		return paint
	return weighted_paints.keys()[0]
