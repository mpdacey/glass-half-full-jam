extends Node
class_name EnginePauseInterfacer

func pause_engine() -> void:
	get_tree().paused = true

func resume_engine() -> void:
	get_tree().paused = false
