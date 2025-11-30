extends PathFollow3D
class_name TrafficCoreController

@export var driving_speed : float = 25
var driving_duration : float = 2.5
signal started_driving

func set_traffic_properties(ongoing_path_ratio: float, is_incoming: bool = false) -> void:
	if is_incoming:
		ongoing_path_ratio = 1.0 - ongoing_path_ratio
	
	progress_ratio = ongoing_path_ratio

func _on_player_near() -> void:
	var drive_tween := create_tween()
	drive_tween.tween_property(self, "progress", progress + driving_speed * driving_duration, driving_duration) 
	drive_tween.tween_callback(self.queue_free)
	started_driving.emit()
