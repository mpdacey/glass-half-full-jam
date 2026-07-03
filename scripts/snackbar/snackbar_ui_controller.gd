extends CanvasLayer
class_name SnackbarUIController

const DISPLAY_KEY = &"show"
const DISMISS_KEY = &"hide"

@export var animator: AnimationPlayer

func display() -> void:
	animator.play(DISPLAY_KEY)

func dismiss() -> void:
	animator.play(DISMISS_KEY)
