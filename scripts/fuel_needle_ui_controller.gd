extends TextureRect

@export var min_rotation := 65.5
@export var max_rotation := -65.5

func _on_fuel_amount_updated(remaining_fuel: float) -> void:
	var new_degrees := remap(remaining_fuel, 0.0, 1.0, min_rotation, max_rotation)
	rotation_degrees = new_degrees
