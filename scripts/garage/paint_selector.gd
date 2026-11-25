extends Control
class_name PaintSelector

signal saved_paint_loaded(paint_index: int)

const PAINT_OVERRIDE_KEY = "override_paint_offset"

@export var player_car_mesh: MeshInstance3D
@export var general_particles: CPUParticles3D
@export var paint_particles: CPUParticles3D
@export var carousel_controller: CarouselController
var saved_paint : PaintResource

func _ready() -> void:
	var saved_paint_uid : String = UserConfigManager.get_config_value(UserConfigManager.STALLION_PAINT_KEY)
	saved_paint = load(saved_paint_uid)
	apply_saved_paint()

func apply_saved_paint() -> void:
	player_car_mesh.set_instance_shader_parameter(
		PAINT_OVERRIDE_KEY,
		saved_paint.shader_uv_offset
	)
	
	var paint_item : Node = carousel_controller.find_item_with_matching_property("paint", saved_paint)
	saved_paint_loaded.emit(paint_item.get_index())

func _on_carousel_item_hovered(item: Control) -> void:
	var paint_can := item as PaintCanController
	var paint := paint_can.paint
	paint_particles.color = paint.particle_colour
	paint_particles.emitting = true
	player_car_mesh.set_instance_shader_parameter(PAINT_OVERRIDE_KEY, paint.shader_uv_offset)

func _on_carousel_scrolling_started() -> void:
	general_particles.emitting = true

func _on_carousel_scrolling_ended() -> void:
	general_particles.emitting = false

func _on_carousel_item_selected(item: Control) -> void:
	var paint_can := item as PaintCanController
	saved_paint = paint_can.paint
	
	var paint_uid := ResourceUID.path_to_uid(saved_paint.resource_path)
	
	UserConfigManager.set_config_value(UserConfigManager.STALLION_PAINT_KEY, paint_uid)
	UserConfigManager.save_config_file()
	
	GlobalSignalBus.paint_applied.emit(saved_paint.paint_name)
	RenderingServer.global_shader_parameter_set(
		GlobalConstants.SHADER_PLAYER_PAINT_OFFSET_KEY,
		saved_paint.shader_uv_offset
	)
