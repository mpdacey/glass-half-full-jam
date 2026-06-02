extends Node
class_name LivesDeniedListener

signal no_lives
signal no_response
signal no_connection

func _on_lives_denied_response_received(value: Variant) -> void:
	if not value is GlobalConstants.SpendLifeResponses:
		return
	
	var response := value as GlobalConstants.SpendLifeResponses
	match(response):
		GlobalConstants.SpendLifeResponses.NO_LIVES:
			no_lives.emit()
		GlobalConstants.SpendLifeResponses.NO_RESPONSE:
			no_response.emit()
		GlobalConstants.SpendLifeResponses.NO_CONNECTION:
			no_connection.emit()
