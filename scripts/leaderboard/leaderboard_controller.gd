extends CanvasLayer

signal load_most_wanted_scores_request(
	leaderboard_id: String,
	time_span: PlayGamesLeaderboardVariant.TimeSpan,
	collection: PlayGamesLeaderboardVariant.Collection,
	max_results: int,
	force_reload: bool
)

signal load_personal_scores_request(
	leaderboard_id: String,
	time_span: PlayGamesLeaderboardVariant.TimeSpan,
	collection: PlayGamesLeaderboardVariant.Collection,
	max_results: int,
	force_reload: bool
)

const LEADERBOARD_ENTRY_SCENE = preload("uid://gqut7x3b0vj7")
const MAX_RESULTS = 20

@export var entries_container : Container
var _current_timespan : PlayGamesLeaderboardVariant.TimeSpan = PlayGamesLeaderboardVariant.TimeSpan.TIME_SPAN_WEEKLY
var _want_to_display_personal := false

func request_scores() -> void:
	if _want_to_display_personal:
		_request_personal_leaderboard()
	else:
		_request_most_wanted_leaderboard()

func set_scores(scores: Array[PlayGamesLeaderboardScore]) -> void:
	var children : Array[LeaderboardEntryController] = entries_container.get_children() as Array[LeaderboardEntryController]
	
	if scores.size() > children.size():
		for i in scores.size():
			if i < children.size():
				children[i].set_entry_values(scores[i])
			else:
				var new_entry : LeaderboardEntryController = LEADERBOARD_ENTRY_SCENE.instantiate()
				new_entry.set_entry_values(scores[i])
				entries_container.add_child(new_entry)
	else:
		for i in children.size():
			if i < scores.size():
				children[i].set_entry_values(scores[i])
			else:
				children[i].set_entry_values(null)

func _request_most_wanted_leaderboard() -> void:
	load_most_wanted_scores_request.emit(
		GlobalConstants.LEADERBOARD_ID,
		_current_timespan,
		PlayGamesLeaderboardVariant.Collection.COLLECTION_PUBLIC,
		MAX_RESULTS,
		false
	)

func _request_personal_leaderboard() -> void:
	load_personal_scores_request.emit(
		GlobalConstants.LEADERBOARD_ID,
		_current_timespan,
		PlayGamesLeaderboardVariant.Collection.COLLECTION_PUBLIC,
		MAX_RESULTS,
		false
	)

#region Google Responses
func _on_top_scores_loaded(_leaderboard_id: String, leaderboard_scores: PlayGamesLeaderboardScores) -> void:
	set_scores(leaderboard_scores.scores)

func _on_player_centered_scores_loaded(_leaderboard_id: String, leaderboard_scores: PlayGamesLeaderboardScores) -> void:
	set_scores(leaderboard_scores.scores)
#endregion

#region Button Listeners
func _on_focus_most_wanted_button_pressed() -> void:
	_want_to_display_personal = false
	request_scores()

func _on_focus_personal_button_pressed() -> void:
	_want_to_display_personal = true
	request_scores()

func _on_timespan_button_pressed(button_index: int) -> void:
	button_index = clampi(button_index, 0, 2)
	_current_timespan = button_index as PlayGamesLeaderboardVariant.TimeSpan
	request_scores()
#endregion
