extends Node

const DISPLAY_NUMBER_KEY = &"display_number"
const MAX_SCORE = 99999.9
@export var odometer_values : Array[Sprite2D]

func update_odometer(kilometres_travelled: float) -> void:
	var score : float = min(kilometres_travelled/100, MAX_SCORE)
	
	var decimal_value := score * 10
	odometer_values[0].set_instance_shader_parameter(DISPLAY_NUMBER_KEY, decimal_value)
	#print(odometer_values[0].get_instance_shader_parameter(DISPLAY_NUMBER_KEY))
	
	for i in range(1, odometer_values.size()):
		var value : float = fmod(floor(score * pow(0.1, (i - 1))), 10)
		odometer_values[i].set_instance_shader_parameter(DISPLAY_NUMBER_KEY, value)
