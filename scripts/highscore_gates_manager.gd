extends Node3D
class_name HighscoreGatesManager

@warning_ignore("unused_signal")
signal highscore_gate_popped(gate_type: PlayGamesLeaderboardVariant.TimeSpan)

@export var leaderboard_client: PlayGamesLeaderboardsClient
@export_group("Highscore Gate Controllers")
@export var gate_all: HighscoreGateController
@export var gate_weekly: HighscoreGateController
@export var gate_daily: HighscoreGateController

@onready var _gates: Dictionary[PlayGamesLeaderboardVariant.TimeSpan, HighscoreGateController] = {
	PlayGamesLeaderboardVariant.TimeSpan.TIME_SPAN_DAILY: gate_daily,
	PlayGamesLeaderboardVariant.TimeSpan.TIME_SPAN_WEEKLY: gate_weekly,
	PlayGamesLeaderboardVariant.TimeSpan.TIME_SPAN_ALL_TIME: gate_all
}

func recall_scores() -> void:
	gate_all.reset()
	gate_weekly.reset()
	gate_daily.reset()
	HighscoreManager.fetch_current_player_highscores(_set_gates)

func _set_gates(scores: Dictionary[PlayGamesLeaderboardVariant.TimeSpan, PlayGamesLeaderboardScore]) -> void:
	for i in range(PlayGamesLeaderboardVariant.TimeSpan.size(), 0, -1):
		i -= 1
		if (
			i < PlayGamesLeaderboardVariant.TimeSpan.size() - 1
			and scores[i].raw_score >= scores[i+1].raw_score
		):
			return
		
		_gates[i].set_score(scores[i].raw_score)
