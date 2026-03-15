extends Node
class_name AndroidBackListener

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		if get_parent() is BaseButton:
			var parent_button : BaseButton = get_parent()
			if parent_button.disabled or not parent_button.visible:
				return
			parent_button.pressed.emit()
		else:
			get_tree().quit()
