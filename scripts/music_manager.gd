extends Node
class_name MusicManager

enum TrackList {
	MAIN,
	TITLE,
	GAMEOVER,
}
const MUSIC_PLAYERS : Dictionary[TrackList, StringName] = {
	TrackList.MAIN  : "main_music",
	TrackList.TITLE  : "title_music",
	TrackList.GAMEOVER  : "gameover_music",
}

func play_main_tracks() -> void:
	var title_player : AudioStreamPlayer = MusicPlayer.get_node(MusicPlayer.get_meta(MUSIC_PLAYERS[TrackList.TITLE]))
	title_player.play()
	
	var main_player : AudioStreamPlayer = MusicPlayer.get_node(MusicPlayer.get_meta(MUSIC_PLAYERS[TrackList.MAIN]))
	main_player.play()
	main_player.volume_db = -80.0

func swap_to_main() -> void:
	var title_player : AudioStreamPlayer = MusicPlayer.get_node(MusicPlayer.get_meta(MUSIC_PLAYERS[TrackList.TITLE]))
	var main_player : AudioStreamPlayer = MusicPlayer.get_node(MusicPlayer.get_meta(MUSIC_PLAYERS[TrackList.MAIN]))
	
	if not main_player.playing:
		_stop_tracks()
		main_player.play()
	
	var tween : Tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel()
	tween.tween_property(title_player, "volume_db", -80, 4)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(main_player, "volume_db", 0, 0.7)

func play_gameover() -> void:
	var main_player : AudioStreamPlayer = MusicPlayer.get_node(MusicPlayer.get_meta(MUSIC_PLAYERS[TrackList.MAIN]))
	var gameover_player : AudioStreamPlayer = MusicPlayer.get_node(MusicPlayer.get_meta(MUSIC_PLAYERS[TrackList.GAMEOVER]))
	
	var tween : Tween = create_tween()
	tween.tween_property(main_player, "volume_db", -80, 1.1)
	tween.tween_callback(main_player.stop)
	tween.tween_property(main_player, "volume_db", 0, 0)
	tween.tween_callback(gameover_player.play).set_delay(0.2)
	tween.tween_property(gameover_player, "volume_db", 0, 0.7)

func _stop_tracks() -> void:
	var audio_player : AudioStreamPlayer
	audio_player = MusicPlayer.get_node(MusicPlayer.get_meta(MUSIC_PLAYERS[TrackList.MAIN]))
	audio_player.stop()
	
	audio_player = MusicPlayer.get_node(MusicPlayer.get_meta(MUSIC_PLAYERS[TrackList.TITLE]))
	audio_player.stop()
	
	audio_player = MusicPlayer.get_node(MusicPlayer.get_meta(MUSIC_PLAYERS[TrackList.GAMEOVER]))
	audio_player.stop()
