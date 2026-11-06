extends Control
class_name GarageSwipeController

@export var platform: Node3D
@export var spin_ratio: float = 0.01

func _on_gui_input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event is not InputEventScreenDrag:
		return
	
	event.is_released()
	
	var drag_velocity := (event as InputEventScreenDrag).velocity
	print(drag_velocity)
	var drag_position := (event as InputEventScreenDrag).position
	print(drag_position)
	
	platform.apply_torque(Vector3(0, drag_velocity.x * spin_ratio, 0))
