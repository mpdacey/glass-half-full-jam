extends Node3D
class_name PlayerVehicleController

signal turned_sharply()

const IDEAL_RATIO = 0.36477986419691

@export var max_swerve_distance : float = 8.0
@export var mouse_tracking_surface_speeds : Dictionary[SurfaceController.SurfaceType, float] = {
		SurfaceController.SurfaceType.ROAD : 20,
		SurfaceController.SurfaceType.DIRT : 10,
		SurfaceController.SurfaceType.OIL : 0
}
@export var surface_transition_time := 0.7
@export var engine_smoke_emitter: CPUParticles3D
var remapped_vehicle_position := 0.0
var _mouse_tracking_speed := mouse_tracking_surface_speeds[SurfaceController.SurfaceType.ROAD]
var _surface_change_tween : Tween
var _currently_sharp_turning : bool = false

func _physics_process(delta: float) -> void:
	var car_tilt_ratio := clampf(position.z - remapped_vehicle_position, -5.0, 5.0) / 5.0
	position.z = move_toward(position.z, remapped_vehicle_position, abs(_mouse_tracking_speed * car_tilt_ratio) * delta)
	rotation.y = move_toward(rotation.y, deg_to_rad(car_tilt_ratio * 30), deg_to_rad(270) * delta)

func _unhandled_input(event: InputEvent) -> void:
	if (
		event is InputEventMouseMotion
		or (
			event is InputEventMouseButton
			and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT
		)
	):
		_calc_vehicle_position()

func _calc_vehicle_position() -> void:
	var viewport := get_viewport()
	var mouse_coords := viewport.get_window().get_mouse_position()
	var viewport_window_size := viewport.get_window().size
	var viewport_size := viewport.get_visible_rect().size
	
	var mouse_coords_ratio := mouse_coords.x / viewport_size.x
	var window_play_area_size := Vector2i(roundi(viewport_window_size.y * IDEAL_RATIO), viewport_window_size.y)
	var deadzone_size := (viewport_window_size.x - window_play_area_size.x) * 0.5
	var deadzone_ratio := deadzone_size / viewport_window_size.x
	var play_area_ratio := float(window_play_area_size.x) / viewport_window_size.x
	var clamped_mouse_coords := clampf(mouse_coords_ratio, deadzone_ratio, deadzone_ratio + play_area_ratio)
	var remapped_mouse_coords := remap(clamped_mouse_coords, deadzone_ratio, deadzone_ratio + play_area_ratio, 0, 1)

	var new_remapped_position := remap(remapped_mouse_coords, 0, 1, -max_swerve_distance, max_swerve_distance)
	if abs(remapped_vehicle_position - new_remapped_position) > 1:
		if not _currently_sharp_turning:
			turned_sharply.emit() 
			_currently_sharp_turning = true
	else:
		_currently_sharp_turning = false
	remapped_vehicle_position = new_remapped_position

func _on_surface_type_changed(road_type: SurfaceController.SurfaceType) -> void:
	if _surface_change_tween:
		_surface_change_tween.kill()
	_surface_change_tween = create_tween()
	
	if mouse_tracking_surface_speeds.has(road_type):
		_surface_change_tween.tween_property(
			self, "_mouse_tracking_speed", mouse_tracking_surface_speeds[road_type], surface_transition_time)
	else:
		_surface_change_tween.tween_property(
			self, "_mouse_tracking_speed", mouse_tracking_surface_speeds[0], surface_transition_time)

func _set_smoke_particles(on: bool) -> void:
	engine_smoke_emitter.emitting = on
