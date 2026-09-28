extends Control
class_name TravelledHighscoreLabelController

@export var labels: Dictionary[PlayGamesLeaderboardVariant.TimeSpan, RichTextLabel]

func show_label(timespan: PlayGamesLeaderboardVariant.TimeSpan) -> void:
	hide_labels()
	labels[timespan].show()

func hide_labels() -> void:
	for label : RichTextLabel in labels.values():
		label.hide()
