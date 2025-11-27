extends Node

@export var road_root : Node3D
@export var car_speed := 15.0

func _physics_process(delta: float) -> void:
	road_root.position.x = fmod(road_root.position.x - car_speed * delta, 100.0)
