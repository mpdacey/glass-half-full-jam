extends Node

signal life_regenerated(current_lives: int)
signal timer_remaining_seconds(time_left: int)

const MAX_LIVES : int = 5
## Number of seconds to regenerate a life
const LIFE_REGENERATION_RATE : int = 300

@export var lives_save_controller: LivesSaveController
@export var regen_timer : Timer
var _current_time_left : int = 0
var _responce_code : GlobalConstants.SpendLifeResponses

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

func can_spend_life() -> GlobalConstants.SpendLifeResponses:
	_responce_code = GlobalConstants.SpendLifeResponses.NO_LIVES
	var set_response_code: Callable = func (response: GlobalConstants.SpendLifeResponses) -> void:
		_responce_code = response
	
	GlobalTimeInterfacer.status_found.connect(set_response_code, CONNECT_ONE_SHOT)
	GlobalTimeInterfacer.request_global_time()
	if _responce_code == GlobalConstants.SpendLifeResponses.NO_LIVES:
		await GlobalTimeInterfacer.status_found
	
	if _responce_code != GlobalConstants.SpendLifeResponses.OK:
		return _responce_code
	
	if regen_timer.time_left < LIFE_REGENERATION_RATE * (MAX_LIVES - 1):
		return GlobalConstants.SpendLifeResponses.OK
	return GlobalConstants.SpendLifeResponses.NO_LIVES

func spend_life() -> void:
	var remaining_time := regen_timer.time_left
	regen_timer.start(remaining_time + LIFE_REGENERATION_RATE)
	_current_time_left = ceili(regen_timer.time_left)
	_emit_lives_left()
	
	GlobalTimeInterfacer.global_unix_time_recieved.connect(_set_stored_regeneration_time, CONNECT_ONE_SHOT)
	GlobalTimeInterfacer.request_global_time()

func _request_initial_time() -> void:
	GlobalTimeInterfacer.global_unix_time_recieved.connect(_set_initial_timer, CONNECT_ONE_SHOT)
	GlobalTimeInterfacer.request_global_time()
	
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
	var spend_life_response : GlobalConstants.SpendLifeResponses = await can_spend_life()
	if spend_life_response == GlobalConstants.SpendLifeResponses.OK:
		GlobalSignalBus.spend_life_granted.emit()
		spend_life()
	else:
		GlobalSignalBus.spend_life_denied.emit(spend_life_response)

func _emit_lives_left() -> void:
	var lives_left : int = MAX_LIVES - ceili(float(_current_time_left) / LIFE_REGENERATION_RATE)
	life_regenerated.emit(lives_left)
	
