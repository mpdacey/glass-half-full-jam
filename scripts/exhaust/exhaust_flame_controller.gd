extends Node3D
class_name ExhaustFlameController

const IGNITE_KEY = &"flame-ignite"
const FIZZLE_KEY = &"flame-fizzle"

@export var transition_animator: AnimationPlayer
var is_ignited : bool = false :
	get():
		return is_ignited

func ignite() -> void:
	transition_animator.play(IGNITE_KEY)
	is_ignited = true

func fizzle() -> void:
	transition_animator.play(FIZZLE_KEY)
	is_ignited = false
