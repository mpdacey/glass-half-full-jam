extends Node
class_name ButtonPulser

@export var target_control: Control
var _button_pulse_tween: Tween

func _enter_tree() -> void:
	if get_parent() is not Button:
		queue_free()
		return
	
	var parent : Button = get_parent()
	parent.button_down.connect(_on_button_down)
	parent.button_up.connect(_on_button_up)
	
	if not target_control:
		target_control = parent
	
	target_control.offset_transform_enabled = true

func _on_button_down() -> void:
	if _button_pulse_tween:
		_button_pulse_tween.kill()
	
	_button_pulse_tween = create_tween()
	_button_pulse_tween.tween_property(target_control, "offset_transform_scale", Vector2.ONE * 0.9, 0.05)

func _on_button_up() -> void:
	if _button_pulse_tween:
		_button_pulse_tween.kill()
	
	_button_pulse_tween = create_tween()
	_button_pulse_tween.tween_property(target_control, "offset_transform_scale", Vector2.ONE, 0.1)
