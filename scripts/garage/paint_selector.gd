extends Control
class_name PaintSelector

@export var general_particles: CPUParticles3D
@export var paint_particles: CPUParticles3D

func _on_carousel_item_selected(item: Control) -> void:
	var paint_can := item as PaintCanController
	var paint := paint_can.paint
	paint_particles.color = paint.particle_colour
	paint_particles.emitting = true
	RenderingServer.global_shader_parameter_set(
		GlobalConstants.SHADER_PLAYER_PAINT_OFFSET_KEY,
		paint.shader_uv_offset
	)

func _on_carousel_scrolling_started() -> void:
	general_particles.emitting = true

func _on_carousel_scrolling_ended() -> void:
	general_particles.emitting = false
