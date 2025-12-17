extends Node
class_name SceneChanger

func swap_to_main_scene() -> void:
	get_tree().change_scene_to_packed(load("uid://kaxdymo06lyx"))

func swap_to_title_scene() -> void:
	get_tree().change_scene_to_packed(load("uid://3k54q4ik0b0u"))
