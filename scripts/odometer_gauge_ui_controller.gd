extends Node

const DISPLAY_NUMBER_KEY = &"display_number"
const MAX_SCORE = 99999.9
const NUMBER_CHANGE_TIME = 0.15
@export var odometer_values : Array[Sprite2D]

func reset_odometer() -> void:
	for i in range(1, odometer_values.size()):
		odometer_values[i].set_instance_shader_parameter(DISPLAY_NUMBER_KEY, 0)

func update_odometer(kilometres_travelled: float) -> void:
	var score : float = min(kilometres_travelled/100, MAX_SCORE)
	
	var decimal_value := score * 10
	odometer_values[0].set_instance_shader_parameter(DISPLAY_NUMBER_KEY, decimal_value)
	
	for i in range(1, odometer_values.size()):
		var new_value : float = floor(score * pow(0.1, (i - 1)))
		var current_value : float = odometer_values[i].get_instance_shader_parameter(DISPLAY_NUMBER_KEY)
		
		if new_value == current_value:
			continue
		
		var tween := create_tween()
		var set_shader_value_callable := func(value: float) -> void:
			odometer_values[i].set_instance_shader_parameter(DISPLAY_NUMBER_KEY, value)
		tween.tween_method(set_shader_value_callable, current_value, new_value, NUMBER_CHANGE_TIME)
