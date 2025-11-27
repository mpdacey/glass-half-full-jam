extends CanvasLayer

@export var fuel_gauge: Slider

func _on_fuel_amount_updated(remaining_fuel: float) -> void:
	fuel_gauge.value = remaining_fuel
