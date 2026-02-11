extends Area3D

@export var underflow_collider_shape : CollisionShape3D

func _on_engine_state_changed(state: FuelController.EngineState) -> void:
	underflow_collider_shape.disabled = state == FuelController.EngineState.BOOST
