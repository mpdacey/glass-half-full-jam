extends Node
class_name PlayServiceInitialiser

@export var play_games_sign_in_client : PlayGamesSignInClient

func _enter_tree() -> void:
	GodotPlayGameServices.initialize()

func _ready() -> void:
	android_authentication()

func android_authentication() -> void:
	if not GodotPlayGameServices.android_plugin:
		printerr("GodotPlayGameServices plugin not found.")
		return
	
	play_games_sign_in_client.is_authenticated()
