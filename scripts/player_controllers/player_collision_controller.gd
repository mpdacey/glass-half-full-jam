extends Node
class_name PlayerCollisionController

const DISAPPEAR_ON_ENTER_META = "vanish_after_collision"

signal fuel_collected
signal player_crashed

func _on_player_hitbox_entered(other: Area3D) -> void:
	fuel_collected.emit()
	if other.has_meta(DISAPPEAR_ON_ENTER_META) and other.get_meta(DISAPPEAR_ON_ENTER_META):
		other.get_parent_node_3d().visible = false

func _on_player_hurtbox_entered(other: Area3D) -> void:
	player_crashed.emit()
	if other.has_meta(DISAPPEAR_ON_ENTER_META) and other.get_meta(DISAPPEAR_ON_ENTER_META):
		other.get_parent_node_3d().visible = false
