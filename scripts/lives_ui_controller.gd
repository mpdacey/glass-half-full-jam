extends CanvasLayer
class_name LivesUIController

signal lives_value_changed()
signal open_shop_requested()
signal banish_requested()

@export var lives_label : Label
@export var regen_timer_label: Label

func _ready() -> void:
	if PurchaseController.has_premium:
		hide()
		return
	
	LivesSystem.life_regenerated.connect(set_lives_label)
	LivesSystem.timer_remaining_seconds.connect(set_regen_timer_label)
	LivesSystem.initial_timer_set.connect(grab_values)
	grab_values()

func set_lives_label(new_lives: int) -> void:
	lives_label.text = str(new_lives)
	lives_value_changed.emit()

func set_regen_timer_label(seconds_left: int) -> void:
	if seconds_left <= 0:
		regen_timer_label.text = "FULL"
		return
	
	var minutes : int = seconds_left / 60
	var seconds : int = seconds_left % 60
	regen_timer_label.text = str(minutes,":","%02d"%seconds)

func grab_values() -> void:
	LivesSystem.emit_signals(true)

func request_banish_lives() -> void:
	if PurchaseController.has_premium and visible:
		banish_requested.emit()
