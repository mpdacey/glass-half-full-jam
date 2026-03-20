extends Node
class_name PlatformDependantTextSetter

@export_multiline var mobile_text : String
@export_multiline var desktop_text : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parent := get_parent()
	if not (parent is Label or parent is RichTextLabel):
		return
	
	var is_mobile : bool = (
		OS.has_feature("android") 
		or OS.has_feature("web_android") 
		or OS.has_feature("web_ios")
	)
	
	if is_mobile:
		parent.text = mobile_text
	else:
		parent.text = desktop_text
