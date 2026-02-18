extends Node
class_name VisibilityListener

signal shown
signal hidden

var _parent_item : CanvasItem
var _parent_layer : CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_parent() is CanvasItem:
		_parent_item = get_parent()
		_parent_item.visibility_changed.connect(_on_visibility_changed)
	if get_parent() is CanvasLayer:
		_parent_layer = get_parent()
		_parent_layer.visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed() -> void:
	if (
			_parent_item and _parent_item.visible
			or _parent_layer and _parent_layer.visible
	):
		shown.emit()
	else:
		hidden.emit()
