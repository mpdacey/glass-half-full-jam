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

signal scores_set()

const LEADERBOARD_ENTRY_SCENE = preload("uid://gqut7x3b0vj7")
const MAX_RESULTS = 20
const DEBUG_PROFILE_ICON_PATH = "user://icon_color.png"

const OPEN_ANIMATION_KEY = &"open"
const CLOSE_ANIMATION_KEY = &"close"

@export var entries_container : Container
@export var scroll_container: ScrollContainer
@export var empty_collection_label: RichTextLabel
@export var book_animator: AnimationPlayer
var _current_timespan : PlayGamesLeaderboardVariant.TimeSpan = PlayGamesLeaderboardVariant.TimeSpan.TIME_SPAN_DAILY
var _want_to_display_personal := false
var _refresh_leaderboard: Dictionary = {}
var _current_player_scores: Dictionary[PlayGamesLeaderboardVariant.TimeSpan, PlayGamesLeaderboardScore]

func reset_refresh_states() -> void:
	_refresh_leaderboard = {
		true: {
			PlayGamesLeaderboardVariant.TimeSpan.TIME_SPAN_DAILY : true,
			PlayGamesLeaderboardVariant.TimeSpan.TIME_SPAN_WEEKLY : true,
			PlayGamesLeaderboardVariant.TimeSpan.TIME_SPAN_ALL_TIME : true
		},
		false: {
			PlayGamesLeaderboardVariant.TimeSpan.TIME_SPAN_DAILY : true,
			PlayGamesLeaderboardVariant.TimeSpan.TIME_SPAN_WEEKLY : true,
			PlayGamesLeaderboardVariant.TimeSpan.TIME_SPAN_ALL_TIME : true
		}
	}
	
	HighscoreManager.fetch_current_player_highscores(_populate_current_player_scores)

func request_scores() -> void:
	if OS.is_debug_build() and not OS.has_feature("android"):
		_generate_list_of_scores()
		return
	
	var force_refresh : bool = _refresh_leaderboard[_want_to_display_personal][_current_timespan]
	_refresh_leaderboard[_want_to_display_personal][_current_timespan] = false
	
	if _want_to_display_personal:
		_request_personal_leaderboard(force_refresh)
	else:
		_request_most_wanted_leaderboard(force_refresh)

func set_scores(scores: Array[PlayGamesLeaderboardScore]) -> void:
	_set_scroll_to_top.call_deferred()
	
	scores = _inject_current_score(scores)
	
	empty_collection_label.visible = scores.size() == 0
	
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
	
	scores_set.emit()

func open_leaderboards() -> void:
	book_animator.play(OPEN_ANIMATION_KEY)

func close_leaderboards() -> void:
	book_animator.play(CLOSE_ANIMATION_KEY)

func _inject_current_score(scores: Array[PlayGamesLeaderboardScore]) -> Array[PlayGamesLeaderboardScore]:
	if _current_player_scores == null or _current_player_scores.size() == 0:
		return scores
	
	var index := 0
	for score in scores:
		if score == null:
			scores.remove_at(index)
		else:
			index += 1
	
	var player_found := false
	var current_score := _current_player_scores[_current_timespan]
	
	if scores.size() == 0:
		if not current_score.score_holder_display_name.ends_with(" (You)"):
			current_score.score_holder_display_name += " (You)"
		current_score.rank = 1
		scores.append(current_score)
		return scores
	
	for i in scores.size():
		if scores[i].score_holder.player_id == current_score.score_holder.player_id:
			if player_found:
				scores.remove_at(i)
			else:
				if not current_score.score_holder_display_name.ends_with(" (You)"):
					scores[i].score_holder_display_name += " (You)"
			return scores
		
		if not player_found and scores[i].raw_score < current_score.raw_score:
			if not current_score.score_holder_display_name.ends_with(" (You)"):
				current_score.score_holder_display_name += " (You)"
			current_score.rank = scores[i].rank
			scores.insert(i, current_score)
			player_found = true
		
		if i == scores.size() - 1 and not player_found:
			if not current_score.score_holder_display_name.ends_with(" (You)"):
				current_score.score_holder_display_name += " (You)"
			current_score.rank = scores[i].rank + 1
			scores.append(current_score)
			return scores
	
	for score in scores:
		if score.score_holder.player_id == current_score.score_holder.player_id:
			continue
		
		if score.rank >= current_score.rank:
			score.rank += 1
	
	return scores

func _set_scroll_to_top() -> void:
	var scroll_bar := scroll_container.get_v_scroll_bar()
	scroll_bar.value = 0

func _generate_list_of_scores() -> void:
	var names_file := "res://resources/debug_players.txt"
	var list := FileAccess.open(names_file, FileAccess.READ)
	
	if not list:
		return
	
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
		score_dictionary["rank"] = i+1
		score_dictionary["scoreHolderIconImageUri"] = DEBUG_PROFILE_ICON_PATH
		score_dictionary["scoreHolder"] = {
			"hasIconImage" = true,
			"iconImageUri" = DEBUG_PROFILE_ICON_PATH,
			"playerId" = selected_names.values()[i]
		}
		
		leaderboard_scores.append(PlayGamesLeaderboardScore.new(score_dictionary))
	
	set_scores(leaderboard_scores)

func _populate_current_player_scores(values: Dictionary[PlayGamesLeaderboardVariant.TimeSpan, PlayGamesLeaderboardScore]) -> void:
	_current_player_scores.assign(values)

#region Request Methods
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
#endregion

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
