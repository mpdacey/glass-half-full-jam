extends Node3D
class_name PostSelfPlanter

const GRASS_PLANT_CHANCE = 0.1

func _ready() -> void:
	plant_self()

func plant_self() -> void:
	var rng := RandomNumberGenerator.new()
	var unix_time : int = floori(Time.get_unix_time_from_system())
	var self_index : int = get_index()
	var fence_index : int = get_parent_node_3d().get_parent_node_3d().get_index()
	var side_index : int = get_parent_node_3d().get_parent_node_3d().get_parent_node_3d().get_index()
	rng.seed = unix_time * self_index * fence_index * side_index
	
	if randf() > GRASS_PLANT_CHANCE:
		queue_free()
		return
	
	var plant_index : int = randi_range(0, 4)
	for child in get_children():
		if child.get_index() != plant_index:
			child.queue_free()
	
	#rotate_y(randf_range(0, PI*2))
