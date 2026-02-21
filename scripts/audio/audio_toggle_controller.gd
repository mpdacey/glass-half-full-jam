extends Node
class_name AudioToggleController

@onready var sfx_bus_index : int = AudioServer.get_bus_index("SFX")
@onready var music_bus_index : int = AudioServer.get_bus_index("Music")

func set_music_mute(muted: bool) -> void:
	AudioServer.set_bus_mute(music_bus_index, muted)

func set_sfx_mute(muted: bool) -> void:
	AudioServer.set_bus_mute(sfx_bus_index, muted)
