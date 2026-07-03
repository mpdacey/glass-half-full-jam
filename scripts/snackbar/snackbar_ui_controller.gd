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

func display() -> void:
	animator.play(DISPLAY_KEY)

func dismiss() -> void:
	animator.play(DISMISS_KEY)

func _on_snackbar_button_pressed(button_type: SnackbarButtonType) -> void:
	if button_type == _current_pressed:
		return
	
	_current_pressed = button_type
	global_signal_emitter.emit_global_signal_with_value(_current_pressed)
