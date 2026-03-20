extends Node

signal reset_requested
signal reset_called

@export var can_reset : bool = false

func request_reset() -> void:
	if can_reset:
		reset_requested.emit()

func reset_game() -> void:
	if can_reset:
		reset_called.emit()
