extends Node
class_name HighscoreGatesManager

const TIMESPAN_ALL_TIME = PlayGamesLeaderboardVariant.TimeSpan.TIME_SPAN_ALL_TIME
const TIMESPAN_WEEKLY = PlayGamesLeaderboardVariant.TimeSpan.TIME_SPAN_WEEKLY
const TIMESPAN_DAILY = PlayGamesLeaderboardVariant.TimeSpan.TIME_SPAN_DAILY
const COLLECTION = PlayGamesLeaderboardVariant.Collection.COLLECTION_PUBLIC

@export var leaderboard_client: PlayGamesLeaderboardsClient
@export_group("Highscore Gate Controllers")
@export var gate_all: HighscoreGateController
@export var gate_weekly: HighscoreGateController
@export var gate_daily: HighscoreGateController

@onready var _gates: Dictionary[PlayGamesLeaderboardVariant.TimeSpan, HighscoreGateController] = {
	TIMESPAN_DAILY: gate_daily,
	TIMESPAN_WEEKLY: gate_weekly,
	TIMESPAN_ALL_TIME: gate_all
}

var _scores: Dictionary[PlayGamesLeaderboardVariant.TimeSpan, float]

func recall_scores() -> void:
	gate_all.reset()
	gate_weekly.reset()
	gate_daily.reset()
	_request_next_score(TIMESPAN_DAILY)

func _set_gates() -> void:
	for i in range(PlayGamesLeaderboardVariant.TimeSpan.size() - 1, 0, -1):
		if (
			i < PlayGamesLeaderboardVariant.TimeSpan.size() - 1
			and _scores[i] >= _scores[i+1]
		):
			return
		
		_gates[i].set_score(_scores[i])

func _request_next_score(required_time_span: PlayGamesLeaderboardVariant.TimeSpan) -> void:
	leaderboard_client.score_loaded.connect(_score_loaded.bind(required_time_span), CONNECT_ONE_SHOT)
	leaderboard_client.load_player_score(GlobalConstants.LEADERBOARD_ID, required_time_span, COLLECTION)

func _score_loaded(_leaderboard_id: String, score: PlayGamesLeaderboardScore, timespan: PlayGamesLeaderboardVariant.TimeSpan) -> void:
	if score == null or score.raw_score == null or score.raw_score == 0:
		_scores[timespan] = -1
	else:
		_scores[timespan] = score.raw_score
	
	match timespan:
		TIMESPAN_DAILY:
			_request_next_score(TIMESPAN_WEEKLY)
		TIMESPAN_WEEKLY:
			_request_next_score(TIMESPAN_ALL_TIME)
		TIMESPAN_ALL_TIME:
			_set_gates()
