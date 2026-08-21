extends CanvasLayer
class_name SnackbarUIController

const DISPLAY_KEY = &"show"
const DISMISS_KEY = &"hide"

@export var animator: AnimationPlayer
@export var global_signal_emitter: GlobalSignalInterfacer

enum SnackbarButtonType {
	DRIVE = 0,
	LEADERBOARD = 1,
	SETTINGS = 2,
	SHOP = 3,
	GARAGE = 4
}

var _current_pressed : SnackbarButtonType = SnackbarButtonType.DRIVE

func lock_snackbox() -> void:
	get_child(0).get_child(0).process_mode = Node.PROCESS_MODE_DISABLED

func unlock_snackbox() -> void:
	get_child(0).get_child(0).process_mode = Node.PROCESS_MODE_INHERIT

func display() -> void:
	animator.play(DISPLAY_KEY)

func dismiss() -> void:
	animator.play(DISMISS_KEY)

func press_snackbar_button(button_type: SnackbarButtonType) -> void:
	for dictionary: Dictionary in get_incoming_connections():
		var callable: Callable = dictionary.callable
		if callable.get_method() != _on_snackbar_button_pressed.get_method():
			continue
		
		var callable_binding : SnackbarButtonType = callable.get_bound_arguments()[0]
		var connected_node: SnackbarButtonController = (dictionary.signal as Signal).get_object()
		
		connected_node.set_toggle(callable_binding == button_type)
	
	_on_snackbar_button_pressed(button_type)

func _on_snackbar_button_pressed(button_type: SnackbarButtonType) -> void:
	_current_pressed = button_type
	global_signal_emitter.emit_global_signal_with_value(_current_pressed)
