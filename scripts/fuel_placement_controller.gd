extends Node
class_name FuelPlacementController

signal next_canister_placed

@export var lane_follower : PathFollow3D
@export var placement_follower : PathFollow3D
@export var canister_distance : float = 100
@export var fuel_canister : Node3D

func reset() -> void:
	lane_follower.progress = 0

func place_next_canister() -> void:
	lane_follower.progress += canister_distance
	placement_follower.progress_ratio = randf()
	fuel_canister.get_node(fuel_canister.get_meta("animator")).play(&"grow")
	next_canister_placed.emit()

func warp_back() -> void:
	lane_follower.progress -= GlobalConstants.COMPLETE_CYCLE_DISTANCE
