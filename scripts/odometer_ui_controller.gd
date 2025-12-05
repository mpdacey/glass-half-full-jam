extends Node
class_name OdometerUpdater

@export var odometer_value_label: Label

func update_odometer(travelled_metres: float, format_string: bool = true) -> void:
	if format_string:
		odometer_value_label.text = "%0*.*f" % [7, 1, travelled_metres/100]
	else:
		odometer_value_label.text = "%0.1f" % [travelled_metres/100]
