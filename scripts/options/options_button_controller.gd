extends HBoxContainer
class_name OptionsButtonController

signal toggle_set(toggled_on: bool)

@export var toggled_on_button_icon: Texture2D
@export var toggled_off_button_icon: Texture2D
@export_group("References")
@export var button: SnackbarButtonController
@export var on_toggle_light : ToggleLight
@export var off_toggle_light : ToggleLight

func set_toggle(toggled_on: bool) -> void:
	if toggled_on:
		button.set_button_icon(toggled_on_button_icon)
		on_toggle_light.light()
		off_toggle_light.extinguish()
	else:
		button.set_button_icon(toggled_off_button_icon)
		on_toggle_light.extinguish()
		off_toggle_light.light()
	
	toggle_set.emit(toggled_on)
