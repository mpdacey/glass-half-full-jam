extends Node
class_name DriveController

const COMPLETE_CYCLE_DISTANCE : float = 400.0

@export var road_animator: AnimationPlayer
@export_group("Acceleration Rates")
## Acceleration value is meters per second
@export var boosted_acceleration_rate := 4.5
## Acceleration value is meters per second
@export var cruise_acceleration_rate := 1.5
## Acceleration value is meters per second
@export var drained_acceleration_rate := -2.0
@export_group("")
@export var surface_dampeners: Dictionary[SurfaceController.SurfaceType, float] = {
	SurfaceController.SurfaceType.ROAD : 0,
	SurfaceController.SurfaceType.DIRT : -4,
	SurfaceController.SurfaceType.OIL : -1,
}

var _engine_state : FuelController.EngineState = FuelController.EngineState.CRUISE
var _surface_type_dampener := 0.0

func _process(delta: float) -> void:
	var normalised_acceleration : float = 1
	match(_engine_state):
		FuelController.EngineState.BOOST:
			normalised_acceleration = boosted_acceleration_rate * delta
		FuelController.EngineState.CRUISE:
			normalised_acceleration = cruise_acceleration_rate * delta
		FuelController.EngineState.DRAINED:
			normalised_acceleration = drained_acceleration_rate * delta
	
	normalised_acceleration += _surface_type_dampener * delta
	normalised_acceleration /= COMPLETE_CYCLE_DISTANCE
	road_animator.speed_scale += normalised_acceleration

func _on_engine_state_changed(state: FuelController.EngineState) -> void:
	_engine_state = state

func _on_surface_type_changed(road_type: SurfaceController.SurfaceType) -> void:
	_surface_type_dampener = surface_dampeners[road_type]
