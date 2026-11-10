extends Control
class_name PaintSelector

const ONE_OVER_TWO_PI = 1 / (2 * PI)

@export var scroll_container : ScrollContainer
@export var scroll_momentum_calculator : Node2D
@export var scroll_ratio: float = 3
@export var item_list: HBoxContainer
var scroll_bar : ScrollBar
var initial_touch_position: float = 0.0
var set_rotation: float = 0.0

func ready_carousel() -> void:
	await get_tree().process_frame
	scroll_bar = scroll_container.get_h_scroll_bar()
	scroll_container.scroll_horizontal = roundi((scroll_bar.max_value - scroll_bar.page) / 3)

func _set_initial_scroll_progress() -> void:
	scroll_bar = scroll_container.get_h_scroll_bar()
	scroll_container.scroll_horizontal = roundi((scroll_bar.max_value - scroll_bar.page) * 0.5)

func _physics_process(_delta: float) -> void:
	if not scroll_bar:
		return
	
	var scroll_value := (scroll_momentum_calculator.rotation) * ONE_OVER_TWO_PI
	scroll_container.scroll_horizontal = remap(scroll_value, 0.0, 1.0, 0, item_list.size.x)

func _on_scroll_container_gui_input(event: InputEvent) -> void:
	if not visible:
		return
	
	if event is InputEventScreenTouch:
		if event.is_pressed():
			initial_touch_position = event.position.x
			set_rotation = scroll_momentum_calculator.rotation
	
	if event is not InputEventScreenDrag:
		return
	
	#var drag_velocity : float = (event as InputEventScreenDrag).velocity.x
	var drag_position : float = event.position.x
	var new_offset_rotation : float = (initial_touch_position - drag_position) / item_list.size.x * 2 * PI
	scroll_momentum_calculator.rotation = fmod(100 * PI + set_rotation + new_offset_rotation, 2 * PI)
