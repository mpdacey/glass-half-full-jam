extends Control
class_name PaintSelector

@export var general_particles: CPUParticles3D
@export var paint_particles: CPUParticles3D

func _on_carousel_item_selected(item: Control) -> void:
	paint_particles.emitting = true
	print(item)

func _on_carousel_scrolling_started() -> void:
	general_particles.emitting = true

func _on_carousel_scrolling_ended() -> void:
	general_particles.emitting = false
