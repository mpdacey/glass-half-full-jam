extends Node3D
class_name HighscoreGateController

@export var near_gate: Node3D
@export var far_gate: Node3D

var distance_to_highscore : float = 0.0

func reset() -> void:
	distance_to_highscore = UserConfigManager.get_config_value(UserConfigManager.HIGHSCORE_KEY)
	distance_to_highscore *= 100
	visible = true
	near_gate.visible = false
	far_gate.visible = false

func _on_new_cycle() -> void:
	var has_passed_highscore : bool = near_gate.visible
	if has_passed_highscore:
		visible = false
		distance_to_highscore = -1
		return
	
	if distance_to_highscore > GlobalConstants.COMPLETE_CYCLE_DISTANCE:
		distance_to_highscore -= 400
		
		far_gate.visible = (
			GlobalConstants.COMPLETE_CYCLE_DISTANCE > distance_to_highscore
			and distance_to_highscore > 0
		)
		
		if far_gate.visible:
			position.x = distance_to_highscore
		
		return
	
	position.x = distance_to_highscore
	near_gate.visible = true
	far_gate.visible = false
