extends Node

@export var exhaust : Node3D

func rotate_exhaust() -> void:
	exhaust.rotate_y(randf() * 2 + 0.5)
