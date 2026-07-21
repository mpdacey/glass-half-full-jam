extends Node
class_name SnackbarButtonController

signal snackbar_button_pressed
signal snackbar_button_released

@export var button_icon: Texture2D
@export_group("References")
@export var button_icon_node: TextureRect
@export var button_reference: Button
@export var button_underline: Panel
var _button_group : ButtonGroup = preload("uid://ckjn10ul5kvve")
var _lit_underline_stylebox: StyleBoxFlat = preload("uid://bfjnouwh84kb")
var _unlit_underline_stylebox: StyleBoxFlat = preload("uid://bvnq8hjtkstin")

func _ready() -> void:
	if button_icon != null:
		button_icon_node.texture = button_icon
	
	button_reference.button_group = _button_group

func set_toggle(toggled_on: bool) -> void:
	_on_button_toggled(toggled_on)

func set_disabled(is_disabled: bool) -> void:
	button_reference.disabled = is_disabled

func _on_button_toggled(toggled_on: bool) -> void:
	button_reference.set_pressed_no_signal(toggled_on)
	_set_underline(toggled_on)
	
	if toggled_on:
		snackbar_button_pressed.emit()
	else:
		snackbar_button_released.emit()

func _set_underline(toggled_on: bool) -> void:
	if toggled_on:
		button_underline.add_theme_stylebox_override(&"panel", _lit_underline_stylebox)
	else:
		button_underline.add_theme_stylebox_override(&"panel", _unlit_underline_stylebox)
