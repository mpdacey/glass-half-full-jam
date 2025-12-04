extends CanvasLayer

@export var odometer_value_label: Label
var distance_traveled: float

func update_odometer(changed_metres: float) -> void:
	distance_traveled += changed_metres
	odometer_value_label.text = "%0*.*f" % [8, 1, distance_traveled]
