extends Node
class_name RoadBendController

const BEND_MULTIPLIER_PARAMETER = "bend_multiplier"

@export var min_bend_length: float = 50
@export var max_bend_length: float = 200
@export var min_bend_transition_length: float = 50
@export var max_bend_transition_length: float  = 120
@export var min_distance_between_bends: float = 350
@export var max_distance_between_bends: float = 1000
@export var min_range_of_bend: float = 1.3
@export var max_range_of_bend: float = 2.5

@export_group("References")
@export var bendable_materials : Array[ShaderMaterial]
@export var drive_controller : DriveController

var bend_tween: Tween

func start_bend() -> void:
	reset_bend()
	drive_controller.speed_scale_updated.connect(_set_bend_tween, CONNECT_ONE_SHOT)

func reset_bend() -> void:
	if bend_tween:
		bend_tween.kill()
	
	_set_bend(0)

func stop_bend() -> void:
	if bend_tween:
		bend_tween.kill()

func _set_bend_tween(current_speed_multiplier: float) -> void:
	var random_sign : int = randi_range(0,1) * 2 - 1
	var bend_multiplier : float = randf_range(min_range_of_bend, max_range_of_bend) * random_sign
	var bend_length : float = randf_range(min_bend_length, max_bend_length)
	var bend_leading_transition_length : float = randf_range(min_bend_transition_length, max_bend_transition_length)
	var bend_following_transition_length : float = randf_range(min_bend_transition_length, max_bend_transition_length)
	var leading_straight_length : float = randf_range(min_distance_between_bends, max_distance_between_bends)
	
	var bend_length_ratio : float = bend_length / GlobalConstants.COMPLETE_CYCLE_DISTANCE
	var bend_leading_transition_ratio : float = bend_leading_transition_length / GlobalConstants.COMPLETE_CYCLE_DISTANCE
	var bend_following_transition_ratio : float = bend_following_transition_length / GlobalConstants.COMPLETE_CYCLE_DISTANCE
	var leading_straight_ratio : float = leading_straight_length / GlobalConstants.COMPLETE_CYCLE_DISTANCE
	var current_cycle_duration : float = GlobalConstants.COMPLETE_CYCLE_DEFAULT_TIME / current_speed_multiplier
	
	var bend_duration : float = bend_length_ratio * current_cycle_duration
	var bend_leading_transition_duration: float = bend_leading_transition_ratio * current_cycle_duration
	var bend_following_transition_duration: float = bend_following_transition_ratio * current_cycle_duration
	var leading_straight_duration: float = leading_straight_ratio * current_cycle_duration
	
	if bend_tween:
		bend_tween.kill()
	bend_tween = create_tween()
	bend_tween.set_trans(Tween.TRANS_SINE)
	bend_tween.tween_method(_set_bend, 0.0, bend_multiplier, bend_leading_transition_duration).set_delay(leading_straight_duration)
	bend_tween.tween_method(_set_bend, bend_multiplier, 0.0, bend_following_transition_duration).set_delay(bend_duration)
	bend_tween.tween_callback(start_bend)

func _set_bend(bend_value: float) -> void:
	for material in bendable_materials:
		material.set_shader_parameter(BEND_MULTIPLIER_PARAMETER, bend_value)
