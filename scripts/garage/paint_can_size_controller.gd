extends Node
class_name PaintCanSizeController

@export var growth_curve: Curve
@export var texture_rext: TextureRect
@export var curve_radius: float = 100
var _parent: Control

func _enter_tree() -> void:
	if get_parent() is not Control:
		queue_free()
		return
	_parent = get_parent()

func _process(_delta: float) -> void:
	if not _parent or not _parent.is_visible_in_tree():
		return
	
	var origin : float = _parent.get_global_transform_with_canvas().get_origin().x + _parent.size.x * 0.5
	var screen_centre := _parent.get_viewport_rect().size.x * 0.5
	var offset : float = abs(origin - screen_centre) / curve_radius
	if offset > 1.0:
		texture_rext.offset_transform_scale = Vector2.ONE
		return
	
	var sample := growth_curve.sample(1 - offset)
	var remapped_scale := remap(sample, 0, 1, 1.0, 1.3)
	
	texture_rext.offset_transform_scale = Vector2(remapped_scale, remapped_scale)
