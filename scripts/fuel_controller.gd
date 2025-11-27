extends Node

signal fuel_amount_updated(remaining_fuel: float)

## Amount of fuel drained per second.
@export_range(0, 1, 0.01) var decay_rate : float = 0.15
var remaining_fuel : float = 0.9

func _process(delta: float) -> void:
	remaining_fuel -= decay_rate * delta
	fuel_amount_updated.emit(remaining_fuel)
