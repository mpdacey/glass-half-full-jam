extends Node

@export var mesh : MeshInstance3D
@export var surface_override_index : int = 5
@export var weighted_paints: Dictionary[Material, float]

func _ready() -> void:
	if not mesh:
		return
	
	mesh.set_surface_override_material(surface_override_index, _pick_paint())

func _pick_paint() -> Material:
	if weighted_paints.size() <= 0:
		return null
	
	var total_weight := 0.0
	for weight : float in weighted_paints.values():
		total_weight += weight
	
	var random_weight := randf() * total_weight
	
	for paint : Material in weighted_paints.keys():
		if random_weight > weighted_paints[paint]:
			random_weight -= weighted_paints[paint]
			continue
		return paint
	return weighted_paints.keys()[0]
