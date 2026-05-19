extends Node
class_name LivesSaveController

signal config_loaded

const STORAGE_CONFIG_FILE_PATH = "user://secret.cfg"
const KEY_FILE_PATH = "user://secret.key"
const DEFAULT_USER = "root"
const LIVES_UNIX_KEY = "revival"

var current_config := ConfigFile.new()

func _ready() -> void:
	load_config_file()

func create_default_config_file() -> ConfigFile:
	var config := ConfigFile.new()
	
	current_config.set_value(DEFAULT_USER, LIVES_UNIX_KEY, 0)
	
	return config

func save_config_file() -> void:
	if not current_config:
		printerr("Config wasn't loaded.")
		return
	
	var key_file_access := FileAccess.open(KEY_FILE_PATH, FileAccess.WRITE)
	key_file_access.close()
	
	var key : String = str(FileAccess.get_modified_time(KEY_FILE_PATH))
	current_config.save_encrypted_pass(STORAGE_CONFIG_FILE_PATH, key)

func load_config_file() -> void:
	if not FileAccess.file_exists(STORAGE_CONFIG_FILE_PATH):
		create_default_config_file()
		GlobalTimeInterfacer.global_unix_time_recieved.connect(_initialise_time.bind(false), CONNECT_ONE_SHOT)
		GlobalTimeInterfacer.request_global_time()
		return
	
	if not FileAccess.file_exists(KEY_FILE_PATH):
		create_default_config_file()
		printerr("File was corrupted or tampered with. Resetting to no lives.")
		GlobalTimeInterfacer.global_unix_time_recieved.connect(_initialise_time.bind(true), CONNECT_ONE_SHOT)
		GlobalTimeInterfacer.request_global_time()
		return
	
	var key : String = str(FileAccess.get_modified_time(KEY_FILE_PATH))
	print(key)
	var error : Error = current_config.load_encrypted_pass(STORAGE_CONFIG_FILE_PATH, key)
	
	if error != OK:
		create_default_config_file()
		if error != ERR_FILE_CORRUPT:
			printerr("File was corrupted or tampered with. Resetting to no lives.")
			GlobalTimeInterfacer.global_unix_time_recieved.connect(_initialise_time.bind(true), CONNECT_ONE_SHOT)
			GlobalTimeInterfacer.request_global_time()
			return
		
		printerr("Couldn't load secret config: ", error_string(error))
		return
	
	config_loaded.emit()

func get_encrypted_regen_time() -> int:
	return current_config.get_value(DEFAULT_USER, LIVES_UNIX_KEY)

func set_encrypted_regen_time(regen_unix: int) -> void:
	if not current_config:
		printerr("Config wasn't loaded.")
		return
	
	if not current_config.has_section_key(DEFAULT_USER, LIVES_UNIX_KEY):
		printerr("Attempted to set invalid key from config.")
		return
	
	current_config.set_value(DEFAULT_USER, LIVES_UNIX_KEY, regen_unix)

func _initialise_time(time: int, apply_punishment: bool) -> void:
	if apply_punishment:
		time += LivesSystem.MAX_LIVES * LivesSystem.LIFE_REGENERATION_RATE
	
	set_encrypted_regen_time(time)
	save_config_file()
	config_loaded.emit.call_deferred()
