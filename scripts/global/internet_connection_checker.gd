extends Node

signal connection_established

@export var connecting_canvas: CanvasLayer
@export var timeout_timer : Timer 
var _current_status : GlobalConstants.TimeConnectionResponses = GlobalConstants.TimeConnectionResponses.NO_CONNECTION

func check_connection() -> void:
	_current_status = GlobalConstants.TimeConnectionResponses.NO_CONNECTION
	timeout_timer.start()
	connecting_canvas.show()
	GlobalTimeInterfacer.status_found.connect(_on_status_found, CONNECT_ONE_SHOT)
	GlobalTimeInterfacer.ping_global_time()

func emit_when_established() -> void:
	if _current_status == GlobalConstants.TimeConnectionResponses.OK:
		connection_established.emit()
		return
	
	var established_connection_signal: Signal = GlobalSignalBus.time_established_connection
	var is_already_connected := established_connection_signal.is_connected(connection_established.emit)
	if not is_already_connected:
		established_connection_signal.connect(connection_established.emit, CONNECT_ONE_SHOT)

func _on_status_found(status: GlobalConstants.TimeConnectionResponses) -> void:
	timeout_timer.stop()
	connecting_canvas.hide()
	_current_status = status
	
	match status:
		GlobalConstants.TimeConnectionResponses.OK:
			GlobalSignalBus.time_established_connection.emit()
		GlobalConstants.TimeConnectionResponses.NO_CONNECTION:
			GlobalSignalBus.time_no_connection.emit()
		GlobalConstants.TimeConnectionResponses.NO_RESPONSE:
			GlobalSignalBus.time_no_response.emit()
		GlobalConstants.TimeConnectionResponses.TIMEOUT:
			GlobalSignalBus.time_timed_out.emit()
