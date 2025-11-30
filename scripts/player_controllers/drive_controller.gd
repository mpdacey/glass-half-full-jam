extends Node
class_name DriveController

const COMPLETE_CYCLE_DISTANCE : float = 100.0

@export var road_animator: AnimationPlayer
@export_group("Acceleration Rates")
## Acceleration value is meters per second
@export var boosted_acceleration_rate := 4.5
## Acceleration value is meters per second
@export var cruise_acceleration_rate := 1.5
## Acceleration value is meters per second
@export var drained_acceleration_rate := -2.0

var _engine_state : FuelController.EngineState = FuelController.EngineState.CRUISE

func _process(delta: float) -> void:
	var normalised_acceleration : float = 1
	match(_engine_state):
		FuelController.EngineState.BOOST:
			normalised_acceleration = boosted_acceleration_rate * delta
		FuelController.EngineState.CRUISE:
			normalised_acceleration = cruise_acceleration_rate * delta
		FuelController.EngineState.DRAINED:
			normalised_acceleration = drained_acceleration_rate * delta
	
	normalised_acceleration /= COMPLETE_CYCLE_DISTANCE
	road_animator.speed_scale += normalised_acceleration

func _on_engine_state_changed(state: FuelController.EngineState) -> void:
	_engine_state = state
