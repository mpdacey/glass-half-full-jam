extends Node
class_name FuelPlacementController

@export var lane_follower : PathFollow3D
@export var placement_follower : PathFollow3D
@export var canister_distance : float = 120
@export var warp_shift_amount : float = 400

func place_next_canister() -> void:
	lane_follower.progress += canister_distance
	placement_follower.progress_ratio = randf()

func warp_back() -> void:
	lane_follower.progress -= warp_shift_amount
