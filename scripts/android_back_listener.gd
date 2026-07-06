extends Node
class_name AndroidBackListener

signal back_requested

@export var bind_close_application : bool = false

func _ready() -> void:
	if get_parent() is BaseButton:
		var parent_button : BaseButton = get_parent()
		if parent_button.disabled or not parent_button.visible:
			return
		
		if parent_button.pressed.has_connections():
			back_requested.connect(parent_button.pressed.emit)
		if parent_button.toggled.has_connections():
			back_requested.connect(parent_button.toggled.emit.bind(true))
	
	if bind_close_application:
		back_requested.connect(get_tree().quit)

func _notification(what: int) -> void:
	if (
		process_mode == ProcessMode.PROCESS_MODE_DISABLED
		or (
			process_mode == ProcessMode.PROCESS_MODE_PAUSABLE
			and get_tree().paused
		)
		or (
			process_mode == ProcessMode.PROCESS_MODE_WHEN_PAUSED
			and not get_tree().paused
		)
	):
		return
	
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		back_requested.emit()
