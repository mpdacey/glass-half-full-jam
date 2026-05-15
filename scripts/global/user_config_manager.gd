extends Node

const CONFIG_FILE_PATH = "user://userdata.cfg"
const DEFAULT_USER = "root"
const HIGHSCORE_KEY = "highscore"
const LIVES_REGENERATION_UNIX_KEY = "revival"

var current_config := ConfigFile.new()

func _ready() -> void:
	load_config_file()

func create_default_config_file() -> ConfigFile:
	var config := ConfigFile.new()
	
	config.set_value(DEFAULT_USER, HIGHSCORE_KEY, 0)
	config.set_value(DEFAULT_USER, LIVES_REGENERATION_UNIX_KEY, 0)
	
	return config

func load_config_file() -> void:
	var err: Error = current_config.load(CONFIG_FILE_PATH)
	
	if err != OK:
		if err == ERR_FILE_NOT_FOUND:
			current_config = create_default_config_file()
		else:
			printerr(str("Config Manager Error: ", error_string(err)))
			return
	
	_validate_config_file()

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
	
	if not current_config.has_section_key(DEFAULT_USER, key):
		printerr("Attempted to set invalid key from config.")
		return
	
	current_config.set_value(DEFAULT_USER, key, value)

func save_config_file() -> void:
	if not current_config:
		printerr("Config wasn't loaded.")
		return
	
	current_config.save(CONFIG_FILE_PATH)


func _validate_config_file() -> void:
	if not current_config.has_section_key(DEFAULT_USER, HIGHSCORE_KEY):
		current_config.set_value(DEFAULT_USER, HIGHSCORE_KEY, 0)
	
	if not current_config.has_section_key(DEFAULT_USER, LIVES_REGENERATION_UNIX_KEY):
		current_config.set_value(DEFAULT_USER, LIVES_REGENERATION_UNIX_KEY, 0)
