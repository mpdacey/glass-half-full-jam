extends CanvasLayer

@export var fuel_gauge: Slider
@export var overflow_warning: TextureRect
@export var underflow_warning: TextureRect
@export_group("Warning Thresholds")
@export_range(0, 1, 0.01) var full_fuel_threshold := 0.8
@export_range(0, 1, 0.01) var low_fuel_threshold := 0.2

func _on_fuel_amount_updated(remaining_fuel: float) -> void:
	fuel_gauge.value = remaining_fuel
	
	overflow_warning.visible = remaining_fuel >= full_fuel_threshold
	underflow_warning.visible = remaining_fuel <= low_fuel_threshold
