extends AudioStreamPlayer3D
class_name TireScreechAudioPlayer

const CLIP_NAME_ROAD = "Road"
const CLIP_NAME_DIRT = "Dirt"

func _on_surface_type_changed(state: SurfaceController.SurfaceType) -> void:
	var interactive_stream : AudioStreamInteractive = stream
	interactive_stream.initial_clip = state
	return
	var playback: AudioStreamPlaybackInteractive = get_stream_playback()
	if not playback:
		return
	
	match(state):
		SurfaceController.SurfaceType.ROAD:
			playback.switch_to_clip_by_name(CLIP_NAME_ROAD)
		SurfaceController.SurfaceType.DIRT:
			playback.switch_to_clip_by_name(CLIP_NAME_DIRT)
