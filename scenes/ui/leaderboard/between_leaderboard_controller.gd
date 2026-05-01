extends AnimationPlayer

const SHOW_LOADING_RETICLE_KEY = "switch_to_loading"
const SHOW_LEADERBOARD_KEY = "switch_to_entries"

func _ready() -> void:
	if OS.is_debug_build():
		play(SHOW_LEADERBOARD_KEY)

func _on_leaderboard_load_request() -> void:
	play(SHOW_LOADING_RETICLE_KEY)

func _on_leaderboard_loaded() -> void:
	play(SHOW_LEADERBOARD_KEY)
