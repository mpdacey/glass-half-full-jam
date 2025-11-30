extends Node
class_name PlayerCollisionController

signal fuel_collected
signal player_crashed

func _on_player_hitbox_entered() -> void:
	fuel_collected.emit()

func _on_player_hurtbox_entered() -> void:
	player_crashed.emit()
