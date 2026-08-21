extends Node

const CONFIG_FILE_PATH = "user://options.cfg"
const DEFAULT_USER = "root"
const MUSIC_MUTE_KEY = "mute_music"
const SFX_MUTE_KEY = "mute_sound"

var current_config := ConfigFile.new()

func _ready() -> void:
	load_config_file()

func set_default_config_file(config: ConfigFile) -> void:
	config.set_value(DEFAULT_USER, MUSIC_MUTE_KEY, false)
	config.set_value(DEFAULT_USER, SFX_MUTE_KEY, false)

func load_config_file() -> void:
	current_config = ConfigFile.new()
	var err: Error = current_config.load(CONFIG_FILE_PATH)
	
	if err != OK:
		set_default_config_file(current_config)
		printerr(str("Config Manager Error: ", error_string(err)))

func get_config_value(key: String) -> Variant:
	if not current_config:
		printerr("Config wasn't loaded.")
		return
	
	if not current_config.has_section_key(DEFAULT_USER, key):
		printerr("Attempted to get invalid key from config.")
		return
	
	return current_config.get_value(DEFAULT_USER, key)

func set_config_value(key: String, value: Variant) -> void:
	if not current_config:
		printerr("Config wasn't loaded.")
		return
	
	if value == null:
		printerr("Attempted to set ", key, " as null")
		value = false
	
	current_config.set_value(DEFAULT_USER, key, value)
	save_config_file()

func save_config_file() -> void:
	if not current_config:
		printerr("Config wasn't loaded.")
		return
	
	var err := current_config.save(CONFIG_FILE_PATH)
	if err != OK:
		printerr("Config wasn't saved successfully.")
