extends Node

const LOG_DIR = "player_logs"
const BASE_SPEED = 72.0

var start_time : float
var fuel_canisters_collected : int
var kilometres_travelled : float
var top_speed_modifier : float
var current_log : FileAccess

func start_log() -> void:
	var dir_access := DirAccess.open("user://")
	
	if not dir_access.dir_exists(LOG_DIR):
		dir_access.make_dir(LOG_DIR)
	
	var rn : String = Time.get_datetime_string_from_system().replace(":", "")
	current_log = FileAccess.open("user://".path_join(LOG_DIR).path_join(rn + ".log"), FileAccess.WRITE)
	current_log.store_line("Start Time: " + Time.get_time_string_from_system())
	
	reset_values()

func reset_values() -> void:
	start_time = Time.get_unix_time_from_system()
	fuel_canisters_collected = 0
	kilometres_travelled = 0
	top_speed_modifier = 1.0

func end_log() -> void:
	var finish_time := Time.get_unix_time_from_system()
	var drive_duration := finish_time - start_time
	var drive_duration_time := Time.get_time_string_from_unix_time(floori(drive_duration))
	
	current_log.store_line(str("End Time: ", Time.get_time_string_from_system()))
	current_log.store_line(str("Drive Duration: ", drive_duration_time))
	current_log.store_line(str("Kilometres Travelled: ", kilometres_travelled))
	current_log.store_line(str("Top Speed: ", BASE_SPEED * top_speed_modifier))
	current_log.store_line(str("Fuel Canisters Collected: ", fuel_canisters_collected))

func _on_fuel_collected() -> void:
	fuel_canisters_collected += 1

func _on_distance_travelled_updated(units: float) -> void:
	kilometres_travelled = floor(units * 0.1) * 0.1

func _on_speed_scale_updated(changed_speed_scale: float) -> void:
	top_speed_modifier = max(top_speed_modifier, changed_speed_scale)
