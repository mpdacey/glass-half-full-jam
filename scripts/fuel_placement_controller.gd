extends Node
class_name FuelPlacementController

@export var lane_follower : PathFollow3D
@export var placement_follower : PathFollow3D
@export var canister_distance : float = 100
@export var warp_shift_amount : float = 400
@export var fuel_canister : Node3D

func place_next_canister() -> void:
	lane_follower.progress += canister_distance
	placement_follower.progress_ratio = randf()
	fuel_canister.get_node(fuel_canister.get_meta("animator")).play(&"grow")

func warp_back() -> void:
	lane_follower.progress -= warp_shift_amount
