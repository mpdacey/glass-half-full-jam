extends Node
class_name SurfaceController

const ROAD_COLLISION_LAYER = 5

signal road_type_changed(road_type: SurfaceType)

enum SurfaceType {
	ROAD,
	DIRT,
	OIL
}

@export var road_raycast: RayCast3D 
var _null_surface_type := SurfaceType.DIRT
var _current_surface_type := SurfaceType.ROAD:
	set(value):
		if _current_surface_type != value:
			road_type_changed.emit(value)
		_current_surface_type = value

func _physics_process(_delta: float) -> void:
	if not road_raycast.is_colliding():
		_current_surface_type = _null_surface_type
		return
	
	var road_collider_object := road_raycast.get_collider()
	if road_collider_object is not CollisionObject3D:
		return
	
	var road_collider := road_collider_object as CollisionObject3D
	if road_collider.get_collision_layer_value(ROAD_COLLISION_LAYER):
		_current_surface_type = SurfaceType.ROAD
		return
