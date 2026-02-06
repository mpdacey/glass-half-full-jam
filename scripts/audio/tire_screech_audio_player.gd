extends AudioStreamPlayer3D
class_name TireScreechAudioPlayer

const CLIP_NAME_ROAD = "Road"
const CLIP_NAME_DIRT = "Dirt"

func _on_surface_type_changed(state: SurfaceController.SurfaceType) -> void:
	var interactive_stream : AudioStreamInteractive = stream
	interactive_stream.initial_clip = state
