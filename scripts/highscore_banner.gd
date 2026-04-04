extends Node3D
class_name HighscoreBanner

signal banner_scale_changed(new_scale: Vector3)

const SQUASH_TWEEN_TIME = 0.05
const REFORM_TWEEN_TIME = 1.5

@export var banner_scaler: Node3D
var overlapping_cars: Dictionary[Area3D, bool]
var tween: Tween

func reset() -> void:
	if tween:
		tween.kill()
	
	overlapping_cars.clear()
	banner_scaler.scale.y = 1.0

func _animate_banner() -> void:
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_method(_change_scale_y, banner_scaler.scale.y, 0.0, SQUASH_TWEEN_TIME * scale.y)
	tween.tween_method(_change_scale_y, 0.0, 1.0, REFORM_TWEEN_TIME)

func _change_scale_y(new_value: float) -> void:
	banner_scaler.scale.y = new_value
	banner_scale_changed.emit(scale)

func _on_collision_entered(_area: Area3D) -> void:
	_animate_banner()
