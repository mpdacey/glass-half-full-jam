extends Control

@export var underflow_warning: TextureRect
@export_range(0, 1, 0.01) var low_fuel_threshold := 0.2

func _on_fuel_amount_updated(remaining_fuel: float) -> void:
	underflow_warning.visible = remaining_fuel <= low_fuel_threshold
