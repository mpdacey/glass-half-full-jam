extends Node

@export var can_reset : bool = false

func reset_game() -> void:
	if can_reset:
		get_tree().reload_current_scene()
