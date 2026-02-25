extends Node
class_name AudioToggleController

signal music_muted_set(is_muted: bool)
signal sfx_muted_set(is_muted: bool)

@onready var sfx_bus_index : int = AudioServer.get_bus_index("SFX")
@onready var music_bus_index : int = AudioServer.get_bus_index("Music")

func set_music_mute(muted: bool) -> void:
	AudioServer.set_bus_mute(music_bus_index, muted)
	music_muted_set.emit(muted)

func set_sfx_mute(muted: bool) -> void:
	AudioServer.set_bus_mute(sfx_bus_index, muted)
	sfx_muted_set.emit(muted)

func load_audio_settings() -> void:
	var music_muted : bool = ConfigManager.get_config_value(ConfigManager.MUSIC_MUTE_KEY)
	set_music_mute(music_muted)
	
	var sfx_muted : bool = ConfigManager.get_config_value(ConfigManager.SFX_MUTE_KEY)
	set_sfx_mute(sfx_muted)

func save_audio_settings() -> void:
	var sfx_muted : bool = AudioServer.is_bus_mute(sfx_bus_index)
	ConfigManager.set_config_value(ConfigManager.SFX_MUTE_KEY, sfx_muted)
	
	var music_muted : bool = AudioServer.is_bus_mute(music_bus_index)
	ConfigManager.set_config_value(ConfigManager.MUSIC_MUTE_KEY, music_muted)
	
	ConfigManager.save_config_file()
