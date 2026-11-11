extends Control
class_name PaintSelector

@export var flick_time_divisor : float = 4000
@export var flick_drag : float = 4
@export var flick_max_velocity : float = 10000

@export_group("References")
@export var scroll_container : ScrollContainer
@export var item_list: HBoxContainer
@export var halt_timer: Timer

var scroll_bar : ScrollBar
var initial_touch_position: float = 0.0
var cache_scroll_progress: float = 0.0
var drag_velocity: float = 0.0
var fling_tween: Tween
var real_scroll_progress : float

func _physics_process(_delta: float) -> void:
	if not scroll_bar:
		return
	
	# There is probably something super obvious I am missing here but this trash works :)
	if fling_tween and not fling_tween.is_running():
		real_scroll_progress = fmod(100 + real_scroll_progress, 1.0)
	
	var caroucel_progress := fmod(100 + real_scroll_progress, 1.0)
	scroll_container.scroll_horizontal = floori(caroucel_progress * item_list.size.x)

func _on_scroll_container_gui_input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event is InputEventScreenTouch:
		if event.is_pressed():
			initial_touch_position = event.position.x
			cache_scroll_progress = real_scroll_progress
			if fling_tween:
				fling_tween.kill()
		elif event.is_released() and halt_timer.time_left > 0:
			_fling_carousel()
	
	if event is not InputEventScreenDrag:
		return
	
	drag_velocity = (event as InputEventScreenDrag).velocity.x
	var drag_position : float = event.position.x
	var new_offset_progress : float = (initial_touch_position - drag_position) / item_list.size.x
	real_scroll_progress = cache_scroll_progress + new_offset_progress
	halt_timer.start()

func ready_carousel() -> void:
	await get_tree().process_frame
	scroll_bar = scroll_container.get_h_scroll_bar()
	scroll_container.scroll_horizontal = roundi((scroll_bar.max_value - scroll_bar.page) / 3)

func _fling_carousel() -> void:
	var velocity : float = min(abs(drag_velocity), flick_max_velocity) * sign(drag_velocity)
	var time : float = abs(velocity / flick_time_divisor)
	var distance : float = -velocity / flick_drag * time
	var final_scroll_offset := distance / roundf((scroll_bar.max_value - scroll_bar.page) / 3.0)
	var final_scroll_result := final_scroll_offset + real_scroll_progress
	fling_tween = create_tween()
	fling_tween.set_ease(Tween.EASE_OUT)
	fling_tween.set_trans(Tween.TRANS_QUAD)
	fling_tween.tween_property(self, "real_scroll_progress", final_scroll_result, time)

func _correct_carousel() -> void:
	fling_tween = create_tween()
	
