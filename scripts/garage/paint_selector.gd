extends Control
class_name PaintSelector

const ONE_OVER_TWO_PI = 1 / (2 * PI)

@export var scroll_container : ScrollContainer
@export var scroll_ratio: float = 3
@export var item_list: HBoxContainer
@export var halt_timer: Timer
var scroll_bar : ScrollBar
var initial_touch_position: float = 0.0
var cache_rotation: float = 0.0
var drag_velocity: float = 0.0
var fling_tween: Tween
var real_rotation : float

func _physics_process(_delta: float) -> void:
	if not scroll_bar:
		return
	
	# There is probably something super obvious I am missing here but this trash works :)
	if fling_tween and not fling_tween.is_running():
		real_rotation = fmod(100 * PI + real_rotation, 2 * PI)
	
	var caroucel_progress := fmod(100 * PI + real_rotation, 2 * PI)
	var scroll_value :=  caroucel_progress * ONE_OVER_TWO_PI
	scroll_container.scroll_horizontal = floori(remap(scroll_value, 0.0, 1.0, 0, item_list.size.x))

func _on_scroll_container_gui_input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event is InputEventScreenTouch:
		if event.is_pressed():
			initial_touch_position = event.position.x
			cache_rotation = real_rotation
			if fling_tween:
				fling_tween.kill()
		elif event.is_released() and halt_timer.time_left > 0:
			_fling_carousel()
	
	if event is not InputEventScreenDrag:
		return
	
	drag_velocity = (event as InputEventScreenDrag).velocity.x
	var drag_position : float = event.position.x
	var new_offset_rotation : float = (initial_touch_position - drag_position) / item_list.size.x * 2 * PI
	real_rotation = cache_rotation + new_offset_rotation
	halt_timer.start()

func ready_carousel() -> void:
	await get_tree().process_frame
	scroll_bar = scroll_container.get_h_scroll_bar()
	scroll_container.scroll_horizontal = roundi((scroll_bar.max_value - scroll_bar.page) / 3)

func _set_initial_scroll_progress() -> void:
	scroll_bar = scroll_container.get_h_scroll_bar()
	scroll_container.scroll_horizontal = roundi((scroll_bar.max_value - scroll_bar.page) * 0.5)

func _fling_carousel() -> void:
	var time : float = abs(drag_velocity/4000)
	var distance : float = -drag_velocity / 4 * time
	var scroll_distance := distance / roundf((scroll_bar.max_value - scroll_bar.page) / 3.0)
	var final_rotation_offset := 2 * PI * scroll_distance
	var final_rotation_result := final_rotation_offset + real_rotation
	fling_tween = create_tween()
	fling_tween.set_ease(Tween.EASE_OUT)
	fling_tween.set_trans(Tween.TRANS_QUAD)
	fling_tween.tween_property(self, "real_rotation", final_rotation_result, time)
