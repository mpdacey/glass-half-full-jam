extends Node
class_name InAppUpdateUIController

signal check_updates_request
signal set_flexible_request
signal set_immediate_request
signal complete_update_request

enum UpdateStatus {
	NO_UPDATE,
	UPDATE_FLEXIBLE_FOUND,
	UPDATE_IMMEDIATE_FOUND,
	UPDATE_READY,
	UPDATE_FAILED
}

@export_group("Infobox_Resources")
@export var update_found_resource: InfoBoxContentsResource
@export var update_ready_resource: InfoBoxContentsResource
@export var update_urgent_found_resource: InfoBoxContentsResource
@export var update_failed_resource: InfoBoxContentsResource

@export_group("References")
@export var infobox : InfoBoxController

var _current_status: UpdateStatus = UpdateStatus.NO_UPDATE
var _on_title: bool = false

func _display_info_box() -> void:
	if _on_title:
		infobox.display_info_box()

func _on_update_ready() -> void:
	infobox.set_content(update_ready_resource)
	_current_status = UpdateStatus.UPDATE_READY
	_display_info_box()

func _on_update_found(is_urgent: bool) -> void:
	if is_urgent:
		infobox.set_content(update_urgent_found_resource)
		_current_status = UpdateStatus.UPDATE_IMMEDIATE_FOUND
	else:
		infobox.set_content(update_found_resource)
		_current_status = UpdateStatus.UPDATE_FLEXIBLE_FOUND
	_display_info_box()

func _on_update_failed(_error_message: String, error_code: int) -> void:
	var temp_resource := update_failed_resource.duplicate()
	temp_resource.hyperlink_text = str("Error code: ", error_code)
	infobox.set_content(temp_resource)
	
	_current_status = UpdateStatus.UPDATE_FAILED
	_display_info_box()


func _on_action_button_pressed() -> void:
	infobox.dismiss_info_box()
	match _current_status:
		UpdateStatus.UPDATE_FLEXIBLE_FOUND:
			set_flexible_request.emit()
		UpdateStatus.UPDATE_IMMEDIATE_FOUND:
			set_immediate_request.emit()
		UpdateStatus.UPDATE_READY:
			complete_update_request.emit()
		UpdateStatus.UPDATE_FAILED:
			set_immediate_request.emit()

func _on_title_scene_loaded() -> void:
	_on_title = true
	
	if _current_status == UpdateStatus.NO_UPDATE:
		check_updates_request.emit()
	else:
		_display_info_box()

func _on_play_scene_loaded() -> void:
	_on_title = false
