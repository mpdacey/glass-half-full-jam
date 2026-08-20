extends AudioStreamPlayer
class_name ButtonSFXApplier

const BUTTON_DOWN_SFX : AudioStreamOggVorbis = preload("uid://b5r5cul7bkfyr")
const BUTTON_UP_SFX : AudioStreamOggVorbis = preload("uid://cuworq3h4j0rj")
const RANDOM_PITCH_SEMITONES = 0.5
const SFX_BUS_NAME = &"SFX"

func _enter_tree() -> void:
	if get_parent() is not Button:
		queue_free()
		return
	
	var parent : Button = get_parent()
	parent.button_down.connect(_on_button_down)
	parent.button_up.connect(_on_button_up)
	
	var stream_randomizer := AudioStreamRandomizer.new()
	stream_randomizer.random_pitch_semitones = RANDOM_PITCH_SEMITONES
	stream_randomizer.add_stream(0, null)
	stream = stream_randomizer
	bus = SFX_BUS_NAME

func _on_button_down() -> void:
	stop()
	(stream as AudioStreamRandomizer).set_stream(0, BUTTON_DOWN_SFX)
	play()

func _on_button_up() -> void:
	stop()
	(stream as AudioStreamRandomizer).set_stream(0, BUTTON_UP_SFX)
	play()
