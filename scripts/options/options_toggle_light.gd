extends Panel
class_name ToggleLight

@export var lit_stylebox : StyleBoxFlat
@export var highlight_panel : Panel
@export_group("Universal Styleboxes")
@export var unlit_stylebox : StyleBoxFlat
@export var highlight_lit_stylebox : StyleBoxFlat
@export var highlight_unlit_stylebox : StyleBoxFlat

func light() -> void:
	add_theme_stylebox_override("panel", lit_stylebox)
	highlight_panel.add_theme_stylebox_override("panel", highlight_lit_stylebox)

func extinguish() -> void:
	add_theme_stylebox_override("panel", unlit_stylebox)
	highlight_panel.add_theme_stylebox_override("panel", highlight_unlit_stylebox)
