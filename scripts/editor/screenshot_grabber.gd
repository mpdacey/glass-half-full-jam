extends Node

const SCREENSHOT_PATH = "screenshots/"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_input(event: InputEvent) -> void:
	if OS.is_debug_build() and event.is_action_pressed("screenshot"):
		var img : Image = get_viewport().get_texture().get_image()
		var path : String = SCREENSHOT_PATH + Time.get_datetime_string_from_system() + ".png"
		path = path.replace(":", "")
		img.save_png(path)
