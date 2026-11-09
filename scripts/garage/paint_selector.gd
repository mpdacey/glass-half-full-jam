extends Control
class_name PaintSelector

const ONE_OVER_TWO_PI = 1 / (2 * PI)
const FREE_DAMP = 4.0
const HELD_DAMP = 12.0

@export var scroll_container : ScrollContainer
@export var scroll_momentum_calculator : RigidBody2D
@export var scroll_ratio: float = 3
@export var item_list: HBoxContainer
var scroll_bar : ScrollBar
var is_held : bool = false
var initial_touch_position: float = 0.0
var set_scroll: int = 0.0

func _set_initial_scroll_progress() -> void:
	scroll_bar = scroll_container.get_h_scroll_bar()
	scroll_container.scroll_horizontal = roundi((scroll_bar.max_value - scroll_bar.page) * 0.5)

func _process(_delta: float) -> void:
	
	#var real_max = scroll_bar.max_value - scroll_bar.page
	return
	if scroll_container.scroll_horizontal < 710:
		scroll_container.scroll_horizontal += scroll_container.get_h_scroll_bar().max_value - 2130
	elif scroll_container.scroll_horizontal >= scroll_container.get_h_scroll_bar().max_value - 710:
		scroll_container.scroll_horizontal = 710

func _physics_process(_delta: float) -> void:
	if not scroll_bar:
		return
	
	var real_max := scroll_bar.max_value - scroll_bar.page
	var scroll_loop_point := real_max * (3.0 / item_list.get_child_count())
	
	#if scroll_container.scroll_horizontal < 147:
	#	scroll_container.scroll_horizontal += 2674 - scroll_container.scroll_horizontal
	#elif scroll_container.scroll_horizontal > 2952:
	#	scroll_container.scroll_horizontal += 437 - scroll_container.scroll_horizontal
	
	scroll_momentum_calculator.rotation = scroll_container.scroll_horizontal / real_max * 2 * PI
	#return
	#if not visible:
		#return
	#
	#var scroll_max := scroll_bar.max_value - scroll_container.size.x
	#var new_scroll_value : float = (scroll_momentum_calculator.rotation + PI) * ONE_OVER_TWO_PI * scroll_max
	#scroll_container.scroll_horizontal =  roundi(new_scroll_value)

func _update_scroll_container(new_scroll: int) -> void:
	var current_scroll := new_scroll
	print(current_scroll)
	if current_scroll < 147:
		current_scroll += 2674 - 147
	elif current_scroll > 2952:
		current_scroll -= 2952 - 437
	
	
	scroll_container.scroll_horizontal = current_scroll

func _on_scroll_container_gui_input(event: InputEvent) -> void:
	
	#return
	#if not visible:
		#return
	#
	if event is InputEventScreenTouch:
		if event.is_pressed():
			initial_touch_position = event.position.x
			set_scroll = scroll_container.scroll_horizontal
			is_held = true
		elif event.is_released():
			is_held = false
	#
	if event is not InputEventScreenDrag:
		return
	#
	#var drag_velocity : float = (event as InputEventScreenDrag).velocity.x
	##drag_velocity = min(abs(drag_velocity), 2000) * sign(drag_velocity)
	#print(drag_velocity)
	var drag_position : float = event.position.x
	_update_scroll_container(set_scroll + (initial_touch_position - drag_position))
	#
	#scroll_momentum_calculator.apply_torque(drag_velocity * -scroll_ratio)
