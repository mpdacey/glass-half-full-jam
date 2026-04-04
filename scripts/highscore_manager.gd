extends Node
class_name HighscoreManager

signal new_highscore_set

@export var drive_controller: DriveController

func _on_gameover() -> void:
	drive_controller.distance_traveled.connect(_update_highscore, CONNECT_ONE_SHOT)
	drive_controller.emit_distance_travelled()

func _update_highscore(metres_travelled: float) -> void:
	metres_travelled = floor(metres_travelled * 0.1) * 0.1
	
	var current_highscore : float = UserConfigManager.get_config_value(UserConfigManager.HIGHSCORE_KEY)
	if current_highscore >= metres_travelled:
		return
	
	UserConfigManager.set_config_value(UserConfigManager.HIGHSCORE_KEY, metres_travelled)
	UserConfigManager.save_config_file()
	
	new_highscore_set.emit()
