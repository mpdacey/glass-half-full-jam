extends Node
class_name SnackbarButtonController

signal snackbar_button_pressed
signal snackbar_button_released

@export var button_icon: Texture2D
@export_group("References")
@export var button_icon_node: TextureRect
@export var button_reference: Button
var _button_group : ButtonGroup = preload("uid://ckjn10ul5kvve")

func _ready() -> void:
	if button_icon != null:
		button_icon_node.texture = button_icon
	
	button_reference.button_group = _button_group

func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		snackbar_button_pressed.emit()
	else:
		snackbar_button_released.emit()
