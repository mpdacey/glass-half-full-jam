extends Node
class_name SnackbarButtonAutoSelector

signal auto_button_pressed(snackbar_option: SnackbarUIController.SnackbarButtonType)

func set_auto_button() -> void:
	if not owner.has_meta(GlobalConstants.SNACKBAR_BUTTON_META_KEY):
		return
	
	var meta_option : Variant = owner.get_meta(GlobalConstants.SNACKBAR_BUTTON_META_KEY)
	if meta_option is not SnackbarUIController.SnackbarButtonType:
		return
	
	auto_button_pressed.emit(meta_option)
