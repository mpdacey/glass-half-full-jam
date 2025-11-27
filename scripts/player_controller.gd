extends Node3D
class_name PlayerVehicleController

@export var max_swerve_distance : float = 15.0
@export var mouse_tracking_speed : float = 20
var remapped_vehicle_position := 0.0

func _physics_process(delta: float) -> void:
	var car_tilt_ratio := clampf(position.z - remapped_vehicle_position, -5.0, 5.0) / 5.0
	position.z = move_toward(position.z, remapped_vehicle_position, abs(mouse_tracking_speed * car_tilt_ratio) * delta)
	rotation.y = move_toward(rotation.y, deg_to_rad(car_tilt_ratio * 30), deg_to_rad(270) * delta)

func _unhandled_input(event: InputEvent) -> void:
	if event is not InputEventMouseMotion:
		return
	
	_calc_vehicle_position()

func _calc_vehicle_position() -> void:
	var viewport := get_viewport()
	var mouse_coords := viewport.get_mouse_position()
	var window_size := DisplayServer.window_get_size()
	var mouse_coords_ratio := mouse_coords.x / window_size.x
	
	remapped_vehicle_position = remap(mouse_coords_ratio, 0, 1, -max_swerve_distance, max_swerve_distance)
