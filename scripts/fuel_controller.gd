extends Node
class_name FuelController

signal fuel_amount_updated(remaining_fuel: float)
signal engine_state_changed(state: EngineState)

enum EngineState {
	BOOST,
	CRUISE,
	DRAINED
}

## Amount of fuel drained per second.
@export_range(0, 1, 0.01) var boost_decay_rate : float = 0.15
@export_range(0, 1, 0.01) var cruise_decay_rate : float = 0.05
@export_range(0, 1, 0.01) var drained_decay_rate : float = 0.03
var remaining_fuel : float = 0.9
var current_state : EngineState = EngineState.CRUISE

func _process(delta: float) -> void:
	match(current_state):
		EngineState.BOOST:
			remaining_fuel -= boost_decay_rate * delta
		EngineState.CRUISE:
			remaining_fuel -= cruise_decay_rate * delta
		EngineState.DRAINED:
			remaining_fuel -= drained_decay_rate * delta
	
	fuel_amount_updated.emit(remaining_fuel)
	set_engine_state()

func set_engine_state() -> void:
	var state_cache := current_state
	if remaining_fuel > 0.55:
		current_state = EngineState.BOOST
	elif remaining_fuel > 0.2:
		current_state = EngineState.CRUISE
	else:
		current_state = EngineState.DRAINED
	
	if state_cache != current_state:
		engine_state_changed.emit(current_state)
