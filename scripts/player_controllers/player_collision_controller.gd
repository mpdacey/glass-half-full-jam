extends Node
class_name PlayerCollisionController

signal fuel_collected

const PICKUP_LAYER = 1

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.get_collision_layer_value(PICKUP_LAYER):
		fuel_collected.emit()
		#area.get_parent()
		return
	
