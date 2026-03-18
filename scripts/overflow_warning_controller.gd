extends Node
class_name OverflowWarningController

signal overflow_imminent
signal overflow_safe

const TERRAIN_LOOP_DISTANCE = 400.0
const TERRAIN_LOOP_TIME = 20.0

@export var fuel_controller : FuelController
@export var fuel_placement_controller: FuelPlacementController
@export var drive_controller : DriveController

var _current_fuel_value := 0.0
var _current_speed_value := 0.0
var _fuel_placement_time_gap := 5.0
# Just a number that feels right, but isn't exact cause player movement can be variable
var _fuel_placement_delay := 1.05

func _ready() -> void:
	var fuel_placement_distance_ratio := fuel_placement_controller.canister_distance / TERRAIN_LOOP_DISTANCE
	_fuel_placement_time_gap = TERRAIN_LOOP_TIME * fuel_placement_distance_ratio

func record_new_values() -> void:
	fuel_controller.fuel_amount_updated.connect(_set_current_fuel_value, CONNECT_ONE_SHOT)
	drive_controller.speed_scale_updated.connect(_set_current_speed_value, CONNECT_ONE_SHOT)

func _set_current_fuel_value(value: float) -> void:
	_current_fuel_value = value
	_calculate_projected_fuel_amount()

func _set_current_speed_value(value: float) -> void:
	_current_speed_value = value
	_calculate_projected_fuel_amount()

func _calculate_projected_fuel_amount() -> void:
	if _current_fuel_value == 0.0 or _current_speed_value == 0.0:
		return
	
	var scaled_time_between_placements := (_fuel_placement_time_gap - _fuel_placement_delay) / _current_speed_value
	var decayed_fuel_between_placements := scaled_time_between_placements * fuel_controller.boost_decay_rate
	var projected_fuel_amount := _current_fuel_value + fuel_controller.fuel_canister_replenishment - decayed_fuel_between_placements
	
	if projected_fuel_amount >= 1.0:
		overflow_imminent.emit()
	else:
		overflow_safe.emit()
	
	print(str("Projected_fuel_amount: ", projected_fuel_amount))
	
	_current_fuel_value = 0.0
	_current_speed_value = 0.0
