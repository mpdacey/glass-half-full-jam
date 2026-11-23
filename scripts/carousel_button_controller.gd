extends Button
class_name CarouselButton

var tween: Tween

func _init(carousel_controller: CarouselController) -> void:
	modulate = Color.TRANSPARENT
	mouse_filter = Control.MOUSE_FILTER_PASS
	button_down.connect(_on_button_down.bind(carousel_controller))
	button_up.connect(_on_button_up)

func _on_button_down(carousel_controller: CarouselController) -> void:
	if not carousel_controller:
		return
	
	var carousel_item : Control = get_parent()
	
	if (
		not carousel_controller.can_select
		or carousel_controller.get_current_centre_item() != carousel_item
	):
		return
	
	carousel_item.offset_transform_enabled = true
	carousel_item.offset_transform_visual_only = true
	
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(carousel_item, "offset_transform_scale", Vector2(0.9,0.9), 0.05)

func _on_button_up() -> void:
	var carousel_item : Control = get_parent()
	
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(carousel_item, "offset_transform_scale", Vector2(1,1), 0.05)
