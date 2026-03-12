extends Node3D

signal camera_position_changed(position: Vector3)

@export var player: Node3D
#Not gonna lie. This is just a magic number that feels good.
@export var smoothing_speed := 15.0

func _process(delta: float) -> void:
	position.z = move_toward(position.z, remap(player.position.z, -5, 5, -2.75, 2.75), delta * smoothing_speed)
	camera_position_changed.emit(position)
