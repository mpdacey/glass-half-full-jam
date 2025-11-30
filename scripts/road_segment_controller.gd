extends Node3D
class_name RoadSegmentController

const ROAD_SEGMENT_LENGTH = 200

@export var traffic_scenes: Array[PackedScene]
@export_group("References")
@export var traffic_paths: Array[Path3D]
var minimum_distance_between_traffic := 30.0

func _ready() -> void:
	dress_road_segment()

func dress_road_segment() -> void:
	_clean_road_segment()
	
	for lane_index in traffic_paths.size():
		var num_of_vehicles := randi_range(7,11)
		
		var potential_placements : Array[float] = []
		for i in num_of_vehicles:
			potential_placements.append(randf_range(40, 160))
		potential_placements.sort()
		
		var placements : Array[float] = [potential_placements[0]]
		for i in range(1, num_of_vehicles):
			if potential_placements[i] - placements[-1] > minimum_distance_between_traffic:
				placements.append(potential_placements[i])
		
		var divisor := 1.0 / ROAD_SEGMENT_LENGTH
		for placement in placements:
			var vehicle : TrafficCoreController = traffic_scenes.pick_random().instantiate()
			traffic_paths[lane_index].add_child(vehicle)
			vehicle.set_traffic_properties(placement * divisor, lane_index == 0)

func _clean_road_segment() -> void:
	for lane in traffic_paths:
		for child in lane.get_children():
			child.queue_free()
