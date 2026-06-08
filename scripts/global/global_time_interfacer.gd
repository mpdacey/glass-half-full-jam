extends Node

signal global_datetime_recieved(datetime: String)
signal global_unix_time_recieved(unix_time: int)
signal status_found(responce: GlobalConstants.TimeConnectionResponses)

const TIME_URL = "https://time.now/developer/api/timezone/Europe/London"

@export var http_request: HTTPRequest

func request_global_time() -> void:
	var error : Error = http_request.request(TIME_URL, [], HTTPClient.METHOD_GET)
	if error != OK:
		status_found.emit(GlobalConstants.TimeConnectionResponses.NO_CONNECTION)
		print(error)

func ping_global_time() -> void:
	var error : Error = http_request.request(TIME_URL, [], HTTPClient.METHOD_HEAD)
	if error != OK:
		status_found.emit(GlobalConstants.TimeConnectionResponses.NO_CONNECTION)
		print(error)

func request_recieved(
	result: int,
	response_code: int,
	_headers: PackedStringArray,
	body: PackedByteArray
) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		printerr(str("Error with the request. Error Code: ", response_code))
		if response_code == 0:
			status_found.emit(GlobalConstants.TimeConnectionResponses.NO_CONNECTION)
		else:
			status_found.emit(GlobalConstants.TimeConnectionResponses.NO_RESPONSE)
		return
	
	status_found.emit(GlobalConstants.TimeConnectionResponses.OK)
	
	if !body:
		return
	
	var json_string : String = body.get_string_from_utf8()
	var json_data : Dictionary = JSON.parse_string(json_string)
	
	if json_data == null:
		printerr("Failed to parse time data.")
		return
	
	var datetime : String = json_data["datetime"]
	if datetime.is_empty():
		printerr("No datetime in json data.")
	else:
		global_datetime_recieved.emit(datetime)
	
	var unix_time : int = json_data["unixtime"]
	if unix_time and unix_time > 0:
		global_unix_time_recieved.emit(unix_time)
	else:
		printerr("No unix time in json data.")
