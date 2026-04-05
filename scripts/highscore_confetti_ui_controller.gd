extends CanvasLayer
class_name HighscoreConfettiUI

signal confetti_popped

func pop_confetti() -> void:
	for child in get_children():
		var particles: CPUParticles2D = child.get_child(0)
		particles.emitting = true
	
	confetti_popped.emit()
