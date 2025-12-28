extends Node3D
class_name ExhaustFlameController

const IGNITE_KEY = &"flame-ignite"
const FIZZLE_KEY = &"flame-fizzle"

@export var transition_animator: AnimationPlayer

func ignite() -> void:
	transition_animator.play(IGNITE_KEY)

func fizzle() -> void:
	transition_animator.play(FIZZLE_KEY)
