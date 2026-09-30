extends Node3D
class_name MaterialLoader

signal shaders_done_compiling
signal _material_freed

@export_dir var mesh_shader_directories: Array[String]

func _ready() -> void:
	_prepare_materials(_get_paths())

func _get_paths() -> Array[String]:
	var paths: Array[String] = []
	var safety_net: int = 200
	for directory_path in mesh_shader_directories:
		var directory := DirAccess.open(directory_path)
		directory.list_dir_begin()
		
		var file_name := directory.get_next()
		while file_name != "":
			safety_net -= 1
			if safety_net <= 0:
				printerr("Uh oh. Infinite loop detected!")
				return paths
			
			if (
				directory.current_is_dir() 
				or not (file_name.ends_with(".tres") or file_name.ends_with(".tres.remap"))
			):
				file_name = directory.get_next()
				continue
			
			var full_path := directory_path.path_join(file_name.trim_suffix(".remap"))
			paths.append(full_path)
			file_name = directory.get_next()
		directory.list_dir_end()
	return paths

func _prepare_materials(queued_paths: Array[String]) -> void:
	if queued_paths.is_empty():
		shaders_done_compiling.emit()
		return
	
	var next_path : String = queued_paths.pop_front()
	_material_freed.connect(_prepare_materials.bind(queued_paths), CONNECT_ONE_SHOT)
	_display_material(next_path)

func _display_material(path: String) -> void:
	var material : Material = load(path)
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.mesh = QuadMesh.new()
	mesh_instance.set_surface_override_material(0, material)
	add_child(mesh_instance)
	
	print("Now displaying: ", path.get_file())
	
	var tween := create_tween()
	tween.tween_callback(mesh_instance.queue_free).set_delay(minf(get_process_delta_time() * 5, 0.05))
	tween.tween_callback(_material_freed.emit)
