extends Node3D
class_name HighscoreGateController

var distance_to_highscore : float = 0.0

func reset() -> void:
	distance_to_highscore = UserConfigManager.get_config_value(UserConfigManager.HIGHSCORE_KEY)
	distance_to_highscore *= 100
	visible = false

func _on_new_cycle() -> void:
	var has_passed_highscore : bool = visible or distance_to_highscore < 0
	if has_passed_highscore:
		visible = false
		distance_to_highscore = -1
		return
	
	if distance_to_highscore > GlobalConstants.COMPLETE_CYCLE_DISTANCE:
		distance_to_highscore -= 400
		return
	
	position.x = distance_to_highscore
	visible = true
