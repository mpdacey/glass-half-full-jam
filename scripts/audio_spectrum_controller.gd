extends VBoxContainer
class_name AudioSpectrumController

const FREQ_MAX: float = 11050.0
const MIN_DB: int = 60

@export var lights: Array[Panel]

var spectrum: AudioEffectSpectrumAnalyzerInstance
var heights: Array[Height]

func _ready() -> void:
	spectrum = AudioServer.get_bus_effect_instance(0, 0)
	
	for i : int in lights.size():
		heights.append(Height.new())

func _process(_delta: float) -> void:
	_draw_to_panels()
	_update_spectrum_data()

func _draw_to_panels() -> void:
	for i: int in lights.size():
		var modified_height := clampf(pow(heights[i].actual * 15, 1.5), 0, 1)
		lights[i].modulate.a = roundf(modified_height * 8) * 0.125 

func _update_spectrum_data() -> void:
	var prev_hertz: float = 0.0
	
	for i: int in lights.size():
		var hertz: float = (i+1) * FREQ_MAX / lights.size()
		var magnitude: float = spectrum.get_magnitude_for_frequency_range(prev_hertz, hertz).length()
		var energy: float = clampf((MIN_DB + linear_to_db(magnitude)) / MIN_DB, 0, 1)
		var height: float = energy
		
		if height > heights[i].high:
			heights[i].high = height
		else:
			heights[i].high = lerp(heights[i].high, height, 0.1)
		
		if height <= 0.0:
			heights[i].low = lerp(heights[i].low, height, 0.1)
		
		heights[i].actual = lerp(heights[i].low, heights[i].high, 0.1)
		prev_hertz = hertz

class Height:
	var high: float
	var low: float
	var actual: float
