extends Node

signal reset_requested

@export var can_reset : bool = false

func request_reset() -> void:
	if can_reset:
		reset_requested.emit()

func reset_game() -> void:
	if can_reset:
		get_tree().reload_current_scene()
