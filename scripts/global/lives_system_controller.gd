extends Node

signal life_regenerated(current_lives: int)
signal timer_remaining_seconds(time_left: int)

const MAX_LIVES : int = 5
## Number of seconds to regenerate a life
const LIFE_REGENERATION_RATE : int = 300

@export var lives_save_controller: LivesSaveController
@export var regen_timer : Timer
@export_group("Connection References")
@export var connecting_canvas: CanvasLayer
@export var timeout_timer : Timer 
var _current_time_left : int = 0
var _connected := false

func _process(_delta: float) -> void:
	var ceil_time_left : int = ceili(regen_timer.time_left)
	
	if _current_time_left == ceil_time_left:
		return
	
	_current_time_left = ceil_time_left
	
	emit_signals()

func emit_signals(force_emit_lives: bool = false) -> void:
	var modulo_time_left : int = _current_time_left % LIFE_REGENERATION_RATE
	
	if modulo_time_left == 0:
		_emit_lives_left()
		if _current_time_left == 0:
			timer_remaining_seconds.emit(0)
		else:
			timer_remaining_seconds.emit(LIFE_REGENERATION_RATE)
	else:
		timer_remaining_seconds.emit(modulo_time_left)
		if force_emit_lives:
			_emit_lives_left()

func can_spend_life() -> bool:
	return regen_timer.time_left < LIFE_REGENERATION_RATE * (MAX_LIVES - 1)

func spend_life() -> void:
	# Maybe redundant but better safe than sorry
	if not can_spend_life():
		return
	
	var remaining_time := regen_timer.time_left
	regen_timer.start(remaining_time + LIFE_REGENERATION_RATE)
	_current_time_left = ceili(regen_timer.time_left)
	_emit_lives_left()
	
	GlobalTimeInterfacer.global_unix_time_recieved.connect(_set_stored_regeneration_time, CONNECT_ONE_SHOT)
	GlobalTimeInterfacer.request_global_time()

func _request_initial_time() -> void:
	GlobalTimeInterfacer.global_unix_time_recieved.connect(_set_initial_timer, CONNECT_ONE_SHOT)
	GlobalSignalBus.time_established_connection.connect(GlobalTimeInterfacer.request_global_time, CONNECT_ONE_SHOT)

func _set_initial_timer(global_unix_time: int) -> void:
	var stored_regeneration_time : int = lives_save_controller.get_encrypted_regen_time()
	if stored_regeneration_time < global_unix_time:
		return
	
	regen_timer.start(stored_regeneration_time - global_unix_time)

func _set_stored_regeneration_time(global_unix_time: int) -> void:
	var fully_regeneration_unix_time := global_unix_time + ceili(regen_timer.time_left)
	lives_save_controller.set_encrypted_regen_time(fully_regeneration_unix_time)
	lives_save_controller.save_config_file()

func _on_spend_life_request() -> void:
	if not _connected:
		return
	
	_connected = false
	if can_spend_life():
		spend_life()
		GlobalSignalBus.spend_life_granted.emit()
	else:
		GlobalSignalBus.spend_life_denied.emit()

func _emit_lives_left() -> void:
	var lives_left : int = MAX_LIVES - ceili(float(_current_time_left) / LIFE_REGENERATION_RATE)
	life_regenerated.emit(lives_left)

func _on_connected() -> void:
	_connected = true
