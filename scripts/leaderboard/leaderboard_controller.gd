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
@export var scroll_container: ScrollContainer
var _current_timespan : PlayGamesLeaderboardVariant.TimeSpan = PlayGamesLeaderboardVariant.TimeSpan.TIME_SPAN_DAILY
var _want_to_display_personal := false

func request_scores(force_refresh: bool = false) -> void:
	if OS.is_debug_build():
		_generate_list_of_scores()
		return
	
	if _want_to_display_personal:
		_request_personal_leaderboard(force_refresh)
	else:
		_request_most_wanted_leaderboard(force_refresh)

func set_scores(scores: Array[PlayGamesLeaderboardScore]) -> void:
	_set_scroll_to_top.call_deferred()
	
	var children : Array[LeaderboardEntryController] = []
	children.assign(entries_container.get_children())
	
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

func _request_most_wanted_leaderboard(force_refresh: bool = false) -> void:
	load_most_wanted_scores_request.emit(
		GlobalConstants.LEADERBOARD_ID,
		_current_timespan,
		PlayGamesLeaderboardVariant.Collection.COLLECTION_PUBLIC,
		MAX_RESULTS,
		force_refresh
	)

func _request_personal_leaderboard(force_refresh: bool = false) -> void:
	load_personal_scores_request.emit(
		GlobalConstants.LEADERBOARD_ID,
		_current_timespan,
		PlayGamesLeaderboardVariant.Collection.COLLECTION_PUBLIC,
		MAX_RESULTS,
		force_refresh
	)

func _set_scroll_to_top() -> void:
	var scroll_bar := scroll_container.get_v_scroll_bar()
	scroll_bar.value = 0

func _generate_list_of_scores() -> void:
	var names_file := "res://resources/debug_players.txt"
	var list := FileAccess.open(names_file, FileAccess.READ)
	
	var selected_names : Dictionary[int, String]
	while not list.eof_reached() and selected_names.size() < MAX_RESULTS:
		var random_name := list.get_line()
		if randf() > 0.1:
			continue
		selected_names[selected_names.size()] = random_name
	
	var leaderboard_scores : Array[PlayGamesLeaderboardScore] = []
	for i in selected_names.size():
		var score_dictionary : Dictionary[String,Variant]
		score_dictionary["rawScore"] = (MAX_RESULTS - i) * 10 + randi_range(0,9)
		score_dictionary["scoreHolderDisplayName"] = selected_names.values()[i]
		score_dictionary["displayRank"] = str(i+1)
		score_dictionary["scoreHolderIconImageUri"] = "https://godotengine.org/assets/press/icon_color_outline.png"
		leaderboard_scores.append(PlayGamesLeaderboardScore.new(score_dictionary))
	
	set_scores(leaderboard_scores)

#region Google Responses
func _on_top_scores_loaded(_leaderboard_id: String, leaderboard_scores: PlayGamesLeaderboardScores) -> void:
	set_scores(leaderboard_scores.scores)

func _on_player_centered_scores_loaded(_leaderboard_id: String, leaderboard_scores: PlayGamesLeaderboardScores) -> void:
	set_scores(leaderboard_scores.scores)
#endregion

#region Button Listeners
func _on_focus_most_wanted_button_pressed() -> void:
	_want_to_display_personal = false

func _on_focus_personal_button_pressed() -> void:
	_want_to_display_personal = true

func _on_timespan_button_pressed(button_index: int) -> void:
	button_index = clampi(button_index, 0, 2)
	_current_timespan = button_index as PlayGamesLeaderboardVariant.TimeSpan
#endregion
