extends Node3D
class_name RoadSegmentController

const ROAD_SEGMENT_LENGTH = GlobalConstants.COMPLETE_CYCLE_DISTANCE * 0.5
const MAX_TRAFFIC = 7

@export var incremental_traffic_value: float = 1.0
@export var starting_traffic: int = 0

@export_group("References")
@export var traffic_scenes: Array[PackedScene]
@export var traffic_paths: Array[Path3D]
var minimum_distance_between_traffic := 25.0
var traffic_count : float

func reset_road_segment() -> void:
	_clean_road_segment()
	traffic_count = starting_traffic

func dress_road_segment() -> void:
	_clean_road_segment()
	
	for lane_index in traffic_paths.size():
		var num_of_vehicles := randi_range(roundi(traffic_count), roundi(traffic_count * 1.4))
		
		var potential_placements : Array[float] = []
		for i in num_of_vehicles:
			potential_placements.append(randf_range(40, 160))
		potential_placements.sort()
		
		if potential_placements.size() <= 0:
			traffic_count = min(traffic_count + incremental_traffic_value, MAX_TRAFFIC)
			return
		
		var placements : Array[float] = [potential_placements[0]]
		for i in range(1, num_of_vehicles):
			if potential_placements[i] - placements[-1] > minimum_distance_between_traffic:
				placements.append(potential_placements[i])
		
		var divisor := 1.0 / ROAD_SEGMENT_LENGTH
		for placement in placements:
			var vehicle : TrafficCoreController = traffic_scenes.pick_random().instantiate()
			traffic_paths[lane_index].add_child(vehicle)
			vehicle.set_traffic_properties(placement * divisor, lane_index == 0)
	
	traffic_count = min(traffic_count + incremental_traffic_value, MAX_TRAFFIC)

func halt_traffic() -> void:
	for path in traffic_paths:
		for child : TrafficCoreController in path.get_children():
			child.stop_driving()

func _clean_road_segment() -> void:
	for lane in traffic_paths:
		for child in lane.get_children():
			child.queue_free()
