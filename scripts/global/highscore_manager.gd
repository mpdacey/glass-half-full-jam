extends Node

signal current_player_scores_loaded(scores: Dictionary[PlayGamesLeaderboardVariant.TimeSpan, int])

const TIME_SPAN_ALL_TIME = PlayGamesLeaderboardVariant.TimeSpan.TIME_SPAN_ALL_TIME
const TIME_SPAN_WEEKLY = PlayGamesLeaderboardVariant.TimeSpan.TIME_SPAN_WEEKLY
const TIME_SPAN_DAILY = PlayGamesLeaderboardVariant.TimeSpan.TIME_SPAN_DAILY
const COLLECTION = PlayGamesLeaderboardVariant.Collection.COLLECTION_PUBLIC

@export var leaderboard_client: PlayGamesLeaderboardsClient
var _current_player_scores: Dictionary[PlayGamesLeaderboardVariant.TimeSpan, int]
var _current_player_scores_loaded: bool = false

func fetch_current_player_highscores(recieving_callable: Callable) -> void:
	if _current_player_scores_loaded:
		recieving_callable.call(_current_player_scores)
	else:
		current_player_scores_loaded.connect(recieving_callable, CONNECT_ONE_SHOT)

func sumbit_metres_travelled(metres_travelled: float) -> void:
	set_score(floori(metres_travelled * 0.1))

func set_score(new_score: int) -> void:
	var new_highscore: bool = false
	
	for time_span : PlayGamesLeaderboardVariant.TimeSpan in PlayGamesLeaderboardVariant.TimeSpan.keys():
		if new_score > _current_player_scores[time_span]:
			_current_player_scores[time_span] = new_score
			new_highscore = true
	
	if new_highscore:
		leaderboard_client.submit_score(GlobalConstants.LEADERBOARD_ID, new_score)

func _load_current_player_highscores() -> void:
	_request_next_score(TIME_SPAN_DAILY)

func _request_next_score(required_time_span: PlayGamesLeaderboardVariant.TimeSpan) -> void:
	if OS.is_debug_build():
		var debug_score: PlayGamesLeaderboardScore = PlayGamesLeaderboardScore.new({"rawScore": 44 * float(required_time_span+1) })
		_score_loaded("", debug_score, required_time_span)
		return
	
	leaderboard_client.score_loaded.connect(_score_loaded.bind(required_time_span), CONNECT_ONE_SHOT)
	leaderboard_client.load_player_score(GlobalConstants.LEADERBOARD_ID, required_time_span, COLLECTION)

func _score_loaded(_leaderboard_id: String, score: PlayGamesLeaderboardScore, timespan: PlayGamesLeaderboardVariant.TimeSpan) -> void:
	if score == null or score.raw_score == null or score.raw_score == 0:
		_current_player_scores[timespan] = -1
	else:
		_current_player_scores[timespan] = score.raw_score
	
	match timespan:
		TIME_SPAN_DAILY:
			_request_next_score(TIME_SPAN_WEEKLY)
		TIME_SPAN_WEEKLY:
			_request_next_score(TIME_SPAN_ALL_TIME)
		TIME_SPAN_ALL_TIME:
			_current_player_scores_loaded = true
			current_player_scores_loaded.emit(_current_player_scores)
