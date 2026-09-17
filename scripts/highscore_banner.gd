extends Node3D
class_name HighscoreBanner

signal banner_scale_changed(new_scale: Vector3)

const SQUASH_TWEEN_TIME = 0.05
const REFORM_TWEEN_TIME = 1.5

const MAIN_COLOUR_INSTANCE_KEY = "main_colour"
const SHADING_COLOUR_INSTANCE_KEY = "shading_colour"
const BANNER_TEXTURE_INDEX_INSTANCE_KEY = "banner_texture_index"

@export var banner_scaler: Node3D
@export var banner_mesh: MeshInstance3D
@export_category("Banner Colours")
@export var banner_main_colours: Dictionary[PlayGamesLeaderboardVariant.TimeSpan, Color]
@export var banner_shade_colours: Dictionary[PlayGamesLeaderboardVariant.TimeSpan, Color]

var overlapping_cars: Dictionary[Area3D, bool]
var tween: Tween

func set_banner_type(banner_type: PlayGamesLeaderboardVariant.TimeSpan, is_describer: bool) -> void:
	banner_mesh.set_instance_shader_parameter(MAIN_COLOUR_INSTANCE_KEY, banner_main_colours[banner_type])
	banner_mesh.set_instance_shader_parameter(SHADING_COLOUR_INSTANCE_KEY, banner_shade_colours[banner_type])
	
	var banner_texture_index : int = 1 + banner_type if is_describer else 0
	banner_mesh.set_instance_shader_parameter(BANNER_TEXTURE_INDEX_INSTANCE_KEY, banner_texture_index)

func reset() -> void:
	if tween:
		tween.kill()
	
	overlapping_cars.clear()
	banner_scaler.scale.y = 1.0

func _animate_banner() -> void:
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_method(_change_scale_y, banner_scaler.scale.y, 0.0, SQUASH_TWEEN_TIME * scale.y)
	tween.tween_method(_change_scale_y, 0.0, 1.0, REFORM_TWEEN_TIME)

func _change_scale_y(new_value: float) -> void:
	banner_scaler.scale.y = new_value
	banner_scale_changed.emit(scale)

func _on_collision_entered(_area: Area3D) -> void:
	_animate_banner()
