extends Node
class_name ExhaustController

@export_group("Left Exhaust References")
@export var left_flame: ExhaustFlameController
@export var left_smoke: CPUParticles3D
@export_group("Right Exhaust References")
@export var right_flame: ExhaustFlameController
@export var right_smoke: CPUParticles3D

func _on_engine_state_changed(state: FuelController.EngineState) -> void:
	left_smoke.emitting = state == FuelController.EngineState.DRAINED
	right_smoke.emitting = state == FuelController.EngineState.DRAINED
	
	match (state):
		FuelController.EngineState.BOOST:
			if not left_flame.is_ignited:
				left_flame.ignite()
				right_flame.ignite()
		FuelController.EngineState.CRUISE:
			if left_flame.is_ignited:
				left_flame.fizzle()
				right_flame.fizzle()
