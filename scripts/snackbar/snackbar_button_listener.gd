extends Node
class_name SnackbarButtonListener

signal target_toggled_on
signal target_toggled_off

const SNACKBAR_CHANGED_SIGNAL_NAME = &"snackbar_button_pressed"

@export var target_button_type: SnackbarUIController.SnackbarButtonType
var _is_toggled : bool = false

func _enter_tree() -> void:
	var global_signal_listener := GlobalSignalInterfacer.new(SNACKBAR_CHANGED_SIGNAL_NAME)
	global_signal_listener.global_signal_emitted_with_value.connect(_on_button_type_changed)
	add_child(global_signal_listener)

func _ready() -> void:
	if target_button_type == (0 as SnackbarUIController.SnackbarButtonType):
		_is_toggled = true

func _on_button_type_changed(new_type: SnackbarUIController.SnackbarButtonType) -> void:
	if new_type == target_button_type and not _is_toggled:
		_is_toggled = true
		target_toggled_on.emit()
	elif new_type != target_button_type and _is_toggled:
		_is_toggled = false
		target_toggled_off.emit()
