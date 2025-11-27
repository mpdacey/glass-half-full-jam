extends Node3D
class_name PlayerVehicleController

@export var max_swerve_distance : float = 15.0

func _unhandled_input(event: InputEvent) -> void:
	if event is not InputEventMouseMotion:
		return
	
	var viewport := get_viewport()
	var mouse_coords := viewport.get_mouse_position()
	var window_size := DisplayServer.window_get_size()
	var mouse_coords_ratio := mouse_coords.x / window_size.x
	
	var remapped_vehicle_position := remap(mouse_coords_ratio, 0, 1, -max_swerve_distance, max_swerve_distance)
	position.z = remapped_vehicle_position
