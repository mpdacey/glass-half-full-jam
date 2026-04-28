extends PanelContainer
class_name LeaderboardEntryController

@export var username_label : Label
@export var score_label : RichTextLabel
@export var rank_label : Label

func set_entry_values(data: PlayGamesLeaderboardScore) -> void:
	visible = data != null# and data.has_player_info
	if not visible:
		return
	
	username_label.text = data.score_holder_display_name
	
	score_label.text = str(data.raw_score)
	score_label.push_font_size(24)
	score_label.add_text("KM")
	score_label.pop()
	
	rank_label.text = str(data.display_rank)
