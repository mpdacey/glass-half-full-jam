extends Node
class_name SnackbarButtonController

signal snackbar_button_pressed

@export var button_icon: Texture2D
@export_group("References")
@export var button_icon_node: TextureRect
@export var button_reference: Button
var _button_group : ButtonGroup = preload("uid://ckjn10ul5kvve")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if button_icon != null:
		button_icon_node.texture = button_icon
	
	button_reference.button_group = _button_group
