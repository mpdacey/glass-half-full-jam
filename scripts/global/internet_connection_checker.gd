extends Node

@export var connecting_canvas: CanvasLayer
@export var timeout_timer : Timer 

func check_connection() -> void:
	timeout_timer.start()
	connecting_canvas.show()
	GlobalTimeInterfacer.status_found.connect(_on_status_found, CONNECT_ONE_SHOT)
	GlobalTimeInterfacer.ping_global_time()

func _on_status_found(status: GlobalConstants.TimeConnectionResponses) -> void:
	timeout_timer.stop()
	connecting_canvas.hide()
	
	match status:
		GlobalConstants.TimeConnectionResponses.OK:
			GlobalSignalBus.time_established_connection.emit()
		GlobalConstants.TimeConnectionResponses.NO_CONNECTION:
			GlobalSignalBus.time_no_connection.emit()
		GlobalConstants.TimeConnectionResponses.NO_RESPONSE:
			GlobalSignalBus.time_no_response.emit()
		GlobalConstants.TimeConnectionResponses.TIMEOUT:
			GlobalSignalBus.time_timed_out.emit()
