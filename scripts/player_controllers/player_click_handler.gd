extends Node
class_name PlayerClickHandler

signal click_detected

func _on_player_clickbox_area_input_event(_camera: Node, event : InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is not InputEventMouseButton:
		return
	
	event = event as InputEventMouseButton
	if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		click_detected.emit()
