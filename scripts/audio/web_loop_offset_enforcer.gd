extends Node
class_name WebLoopOffsetEnforcer

@onready var music_player : AudioStreamPlayer = $".."

func _ready() -> void:
	if not OS.has_feature("web"):
		queue_free()
		return
	
	var music_stream : AudioStreamOggVorbis = music_player.stream
	music_stream.loop = false
	music_player.finished.connect(_loop_music.bind(music_stream.loop_offset))

func _loop_music(loop_offset: float) -> void:
	music_player.play(loop_offset)
