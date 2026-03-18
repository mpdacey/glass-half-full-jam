extends Node
class_name FuelWarningController

const WARNING_ANIMATOR_KEY = &"warning_animator"
const PLAY_ANIMATION_KEY = &"fuel-warning/warning"
const HIDE_ANIMATION_KEY = &"fuel-warning/hide-warning"

@export var fuel_canister : Node3D
var warning_animator : AnimationPlayer

func play_warning() -> void:
	if not warning_animator:
		_grab_fuel_canister_animator()
	warning_animator.play(PLAY_ANIMATION_KEY)

func stop_warning() -> void:
	if not warning_animator:
		_grab_fuel_canister_animator()
	warning_animator.play(HIDE_ANIMATION_KEY)

func _grab_fuel_canister_animator() -> void:
	var node_path : NodePath = fuel_canister.get_meta(WARNING_ANIMATOR_KEY)
	warning_animator = fuel_canister.get_node(node_path)
