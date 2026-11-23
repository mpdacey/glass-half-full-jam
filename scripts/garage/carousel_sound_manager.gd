extends Node
class_name CarouselSoundManager

@export var scrolling_fade_in_seconds: float = 1.0
@export var scrolling_fade_out_seconds: float = 0.7
@export_group("SFX")
@export var scrolling_sfx: AudioStream
@export var hovered_sfx: AudioStream
@export var selected_sfx: AudioStream
@export var ticks_sfxs: Array[AudioStream]
@export_group("References")
@export var scrolling_audio_player: AudioStreamPlayer
@export var instance_audio_player: AudioStreamPlayer

var scrolling_tween: Tween
var is_scrolling: bool

func _on_carousel_scrolling_started() -> void:
	if not scrolling_sfx:
		return
	
	if is_scrolling:
		return
	is_scrolling = true
	
	if scrolling_tween:
		scrolling_tween.kill()
	scrolling_tween = create_tween()
	
	scrolling_audio_player.stream = scrolling_sfx
	scrolling_tween.tween_property(scrolling_audio_player, "volume_linear", 0.0, 0)
	scrolling_tween.tween_callback(scrolling_audio_player.play)
	scrolling_tween.tween_property(scrolling_audio_player, "volume_linear", 1.0, scrolling_fade_in_seconds)

func _on_carousel_scrolling_ended() -> void:
	if not scrolling_tween:
		return
	
	is_scrolling = false
	
	if scrolling_tween:
		scrolling_tween.kill()
	
	scrolling_tween = create_tween()
	scrolling_tween.tween_property(scrolling_audio_player, "volume_linear", 0.0, scrolling_fade_out_seconds)
	scrolling_tween.tween_callback(scrolling_audio_player.stop)

func _on_carousel_item_hovered() -> void:
	if not hovered_sfx:
		return
	
	var stream_randomizer := instance_audio_player.stream as AudioStreamRandomizer
	stream_randomizer.set_stream(0, hovered_sfx)
	instance_audio_player.play()

func _on_carousel_item_selected() -> void:
	if not selected_sfx:
		return
	
	var stream_randomizer := instance_audio_player.stream as AudioStreamRandomizer
	stream_randomizer.set_stream(0, selected_sfx)
	instance_audio_player.play()
