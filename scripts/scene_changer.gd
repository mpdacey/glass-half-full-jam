extends Node

const MAIN_SCENE = preload("res://scenes/main_scene.tscn")

func swap_to_main_scene() -> void:
	get_tree().change_scene_to_packed(MAIN_SCENE)
