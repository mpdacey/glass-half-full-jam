extends Node
class_name SceneChanger

signal play_scene_loaded
signal title_scene_loaded

const PLAY_SCENE_UID = "uid://dpfq7m4viuno"
const TITLE_SCENE_UID = "uid://3k54q4ik0b0u"

@export var scene_container : Node

func swap_to_play_scene() -> void:
	_switch_dynamic_scene(_load_scene(PLAY_SCENE_UID))
	play_scene_loaded.emit()

func swap_to_title_scene(snackbar_option: SnackbarUIController.SnackbarButtonType = SnackbarUIController.SnackbarButtonType.DRIVE) -> void:
	var title_node := _switch_dynamic_scene(_load_scene(TITLE_SCENE_UID))
	title_node.set_meta(GlobalConstants.SNACKBAR_BUTTON_META_KEY, snackbar_option)
	title_scene_loaded.emit()

func _load_scene(uid: String) -> PackedScene:
	return load(uid)

func _switch_dynamic_scene(scene: PackedScene) -> Node:
	scene_container.get_child(0).queue_free()
	
	var new_scene : Node = scene.instantiate()
	scene_container.call_deferred("add_child", new_scene)
	
	return new_scene
