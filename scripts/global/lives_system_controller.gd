extends Node

signal life_regenerated(current_lives: int)
signal lives_fully_replenished()

const MAX_LIVES : int = 5
## Number of seconds to regenerate a life
const LIFE_REGENERATION_RATE = 300

@export var regen_timer : Timer

func _ready() -> void:
	_request_initial_time()

func _process(_delta: float) -> void:
	if regen_timer.time_left > 0:
		print(ceili(regen_timer.time_left))

func can_spend_life() -> bool:
	return regen_timer.time_left < LIFE_REGENERATION_RATE * (MAX_LIVES - 1)

func spend_life() -> void:
	# Maybe redundant but better safe than sorry
	if not can_spend_life():
		return
	
	var remaining_time := regen_timer.time_left
	regen_timer.start(remaining_time + LIFE_REGENERATION_RATE)
	
	GlobalTimeInterfacer.global_unix_time_recieved.connect(_set_stored_regeneration_time, CONNECT_ONE_SHOT)
	GlobalTimeInterfacer.request_global_time()

func _request_initial_time() -> void:
	GlobalTimeInterfacer.global_unix_time_recieved.connect(_set_initial_timer, CONNECT_ONE_SHOT)
	GlobalTimeInterfacer.request_global_time()
	
func _set_initial_timer(global_unix_time: int) -> void:
	var stored_regeneration_time : int = UserConfigManager.get_config_value(UserConfigManager.LIVES_REGENERATION_UNIX_KEY)
	if stored_regeneration_time < global_unix_time:
		return
	
	regen_timer.start(stored_regeneration_time - global_unix_time)

func _set_stored_regeneration_time(global_unix_time: int) -> void:
	var fully_regeneration_unix_time := global_unix_time + ceili(regen_timer.time_left)
	UserConfigManager.set_config_value(UserConfigManager.LIVES_REGENERATION_UNIX_KEY, fully_regeneration_unix_time)
	UserConfigManager.save_config_file() 

func _on_spend_life_request() -> void:
	if can_spend_life():
		spend_life()
		GlobalSignalBus.spend_life_granted.emit()
	else:
		GlobalSignalBus.spend_life_denied.emit()
