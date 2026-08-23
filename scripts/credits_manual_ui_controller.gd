extends CanvasLayer

const OPEN_ANIMATION_KEY = &"open"
const CLOSE_ANIMATION_KEY = &"close"

@export var book_animator: AnimationPlayer

func open_book() -> void:
	book_animator.play(OPEN_ANIMATION_KEY)

func close_book() -> void:
	if (
		book_animator.current_animation != CLOSE_ANIMATION_KEY
		and not book_animator.is_playing()
		and visible
	):
		book_animator.play(CLOSE_ANIMATION_KEY)
