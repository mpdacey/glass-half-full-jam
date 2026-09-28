extends CanvasLayer
class_name HighscoreConfettiUI

signal confetti_popped

@export var confetti_cannon_containers: Dictionary[PlayGamesLeaderboardVariant.TimeSpan, Control]

func pop_confetti(highscore_type: PlayGamesLeaderboardVariant.TimeSpan = PlayGamesLeaderboardVariant.TimeSpan.TIME_SPAN_ALL_TIME) -> void:
	var cannon_container := confetti_cannon_containers[highscore_type]
	for child in cannon_container.get_children():
		if child.get_child_count() <= 0 or child.get_child(0) is not CPUParticles2D:
			continue
		
		var particles: CPUParticles2D = child.get_child(0)
		particles.emitting = true
	
	confetti_popped.emit()
