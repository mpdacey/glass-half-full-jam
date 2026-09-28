extends Node
class_name HighscoreSubmitter

@export var drive_controller: DriveController

func _on_gameover() -> void:
	drive_controller.distance_traveled.connect(_update_highscore, CONNECT_ONE_SHOT)
	drive_controller.emit_distance_travelled()

func _update_highscore(metres_travelled: float) -> void:
	HighscoreManager.sumbit_metres_travelled(metres_travelled)
