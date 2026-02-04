extends Node
class_name OffRoadVisualsController

@export var off_road_animator : AnimationPlayer

func _on_surface_type_changed(road_type: SurfaceController.SurfaceType) -> void:
	match(road_type):
		SurfaceController.SurfaceType.ROAD:
			off_road_animator.play("road")
		SurfaceController.SurfaceType.DIRT:
			off_road_animator.play("dirt")
