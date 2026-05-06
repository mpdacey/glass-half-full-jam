extends Node

const PAGE_UP_KEY = &"page_up"
const PAGE_DOWN_KEY = &"page_down"

@export var animator: AnimationPlayer
var current_catagory: int = 0
var current_page: int = 0

func change_catagory(index: int) -> void:
	_flip_page(current_catagory, index)
	current_catagory = index

func change_table(index: int) -> void:
	_flip_page(current_page, index)
	current_page = index

func _flip_page(current_value: int, new_value: int) -> void:
	if current_value == new_value:
		return
	
	if current_value > new_value:
		animator.play(PAGE_DOWN_KEY)
	else:
		animator.play(PAGE_UP_KEY)
