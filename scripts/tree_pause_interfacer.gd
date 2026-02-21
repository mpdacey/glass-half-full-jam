extends Node
class_name EnginePauseInterfacer

@export var fade_resume_duration : float = 0.5

func pause_engine() -> void:
	get_tree().paused = true

func resume_engine(fade_resume: bool = false) -> void:
	get_tree().paused = false
	
	if not fade_resume:
		return
	
	Engine.time_scale = 0
	var tween := get_tree().create_tween()
	tween.tween_property(Engine, "time_scale", 1.0, fade_resume_duration)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
