extends Node
class_name SceneChanger

signal play_scene_loaded
signal title_scene_loaded

const PLAY_SCENE = preload("uid://dpfq7m4viuno")
const TITLE_SCENE = preload("uid://3k54q4ik0b0u")

@export var scene_container : Node


func swap_to_play_scene() -> void:
	_switch_dynamic_scene(PLAY_SCENE)
	play_scene_loaded.emit()

func swap_to_title_scene() -> void:
	_switch_dynamic_scene(TITLE_SCENE)
	title_scene_loaded.emit()

func _switch_dynamic_scene(scene: PackedScene) -> void:
	scene_container.get_child(0).queue_free()
	scene_container.call_deferred("add_child", scene.instantiate())
