extends CanvasLayer
class_name LivesUIController

signal lives_value_changed()

@export var lives_label : Label
@export var regen_timer_label: Label

func _ready() -> void:
	LivesSystem.life_regenerated.connect(set_lives_label)
	LivesSystem.timer_remaining_seconds.connect(set_regen_timer_label)
	grab_values()

func set_lives_label(new_lives: int) -> void:
	lives_label.text = str(new_lives)
	lives_value_changed.emit()

func set_regen_timer_label(seconds_left: int) -> void:
	if seconds_left == 0:
		regen_timer_label.text = "FULL"
		return
	
	var minutes : int = seconds_left / 60
	var seconds : int = seconds_left % 60
	regen_timer_label.text = str(minutes,":","%02d"%seconds)

func grab_values() -> void:
	LivesSystem.emit_signals(true)
