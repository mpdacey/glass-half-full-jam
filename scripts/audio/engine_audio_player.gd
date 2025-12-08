extends AudioStreamPlayer3D
class_name EngineAudioPlayer

const CLIP_NAME_BOOST = "high"
const CLIP_NAME_CRUISE = "medium"
const CLIP_NAME_DRAINED = "low"

func _on_engine_state_changed(state: FuelController.EngineState) -> void:
	var playback: AudioStreamPlaybackInteractive = get_stream_playback()
	match(state):
		FuelController.EngineState.BOOST:
			playback.switch_to_clip_by_name(CLIP_NAME_BOOST)
		FuelController.EngineState.CRUISE:
			playback.switch_to_clip_by_name(CLIP_NAME_CRUISE)
		FuelController.EngineState.DRAINED:
			playback.switch_to_clip_by_name(CLIP_NAME_DRAINED)
