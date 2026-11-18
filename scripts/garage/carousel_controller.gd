extends ScrollContainer
class_name CarouselController

signal carousel_scrolling_started
signal carousel_scrolling_interrupted
signal carousel_scrolling_ended
signal item_selected(item: Control)

@export var flick_time_divisor : float = 4000
@export var flick_drag : float = 4
@export var flick_max_velocity : float = 10000

@export_group("References")
@export var item_list: HBoxContainer
@export var halt_timer: Timer

var scroll_bar : ScrollBar
var initial_touch_position: float = 0.0
var cache_scroll_progress: float = 0.0
var drag_velocity: float = 0.0
var fling_tween: Tween
var real_scroll_progress : float

func _ready() -> void:
	item_list.add_sibling(item_list.duplicate())
	item_list.add_sibling(item_list.duplicate())

func _physics_process(_delta: float) -> void:
	if not scroll_bar:
		return
	
	var screen_width := size.x
	var item_width : float = item_list.get_child(0).size.x
	var visible_items : float =  screen_width / item_width
	# Magic numbers are truly magic. Brute forced these values and they just work. ¯\_(ツ)_/¯
	var offset : float = (visible_items - 4) * 0.5 / item_list.get_child_count()
	
	# There is probably something super obvious I am missing here but this trash works :)
	if fling_tween and not fling_tween.is_running():
		real_scroll_progress = fmod(100 + real_scroll_progress, 1.0)
	
	var caroucel_progress := fmod(100 + real_scroll_progress - offset, 1.0)
	scroll_horizontal = floori(caroucel_progress * item_list.size.x)

func _on_gui_input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event is InputEventScreenTouch:
		if event.is_pressed():
			initial_touch_position = event.position.x
			cache_scroll_progress = real_scroll_progress
			carousel_scrolling_started.emit()
			if fling_tween:
				carousel_scrolling_interrupted.emit()
				fling_tween.kill()
		elif event.is_released():
			if halt_timer.time_left > 0 and abs(drag_velocity) > 200:
				_fling_carousel()
			else:
				_correct_carousel()
	
	if event is not InputEventScreenDrag:
		return
	
	drag_velocity = (event as InputEventScreenDrag).velocity.x
	var drag_position : float = event.position.x
	var new_offset_progress : float = (initial_touch_position - drag_position) / item_list.size.x
	real_scroll_progress = cache_scroll_progress + new_offset_progress
	halt_timer.start()

func ready_carousel() -> void:
	await get_tree().process_frame
	scroll_bar = get_h_scroll_bar()
	real_scroll_progress = 0.0833

func _fling_carousel() -> void:
	var velocity : float = min(abs(drag_velocity), flick_max_velocity) * sign(drag_velocity)
	var time : float = abs(velocity / flick_time_divisor)
	var distance : float = -velocity / flick_drag * time
	
	var final_scroll_offset := distance / roundf((scroll_bar.max_value - scroll_bar.page) / 3.0)
	var final_scroll_result := final_scroll_offset + real_scroll_progress
	var final_targeted_scroll_result := _get_nearest_centred_progress(final_scroll_result)
	
	_spin_carousel(final_targeted_scroll_result, time)

func _correct_carousel() -> void:
	var nearest_centred_progress := _get_nearest_centred_progress(real_scroll_progress)
	_spin_carousel(nearest_centred_progress)

func _spin_carousel(final_progress: float, time: float = 1.0) -> void:
	fling_tween = create_tween()
	fling_tween.set_ease(Tween.EASE_OUT)
	fling_tween.set_trans(Tween.TRANS_QUAD)
	
	fling_tween.tween_property(self, "real_scroll_progress", final_progress, time)
	fling_tween.tween_callback(item_selected.emit.bind(_get_item_at_progress(final_progress)))
	fling_tween.tween_callback(carousel_scrolling_ended.emit)

func _get_nearest_centred_progress(raw_progress: float) -> float:
	var item_index : float = round(raw_progress * item_list.get_child_count())
	var modulo_swing : float = fmod(raw_progress * item_list.get_child_count() - 0.5, 1.0)
	var swing_value : float = clamp(round(modulo_swing), 0, 1) - 0.5
	var targeted_progress : float = (item_index + swing_value) / item_list.get_child_count()
	return targeted_progress

func _get_item_at_progress(progress: float) -> Control:
	var child_count : int = item_list.get_child_count()
	var item_index : int = ceili((100 + progress) * child_count + 1.0) % child_count
	return item_list.get_child(item_index)
