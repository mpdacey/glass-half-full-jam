extends CanvasLayer
class_name PurchaseUIController

signal processing_started()
signal processing_finished()

enum InfoBoxStatus {
	INITIAL,
	PROCESSING,
	SUCCESSFUL,
	FAILED
}

@export var info_box : InfoBoxController
@export_group("Content Resources")
@export var initial_resource: InfoBoxContentsResource
@export var pending_resource: InfoBoxContentsResource
@export var success_resource: InfoBoxContentsResource
@export var failed_resource: InfoBoxContentsResource

var current_status := InfoBoxStatus.INITIAL

func _enter_tree() -> void:
	info_box.add_user_signal(InfoBoxController.CHANGING_USER_SIGNAL)
	info_box.connect(InfoBoxController.CHANGING_USER_SIGNAL, set_info_box)

func open_purchase_window() -> void:
	current_status = InfoBoxStatus.INITIAL
	set_info_box()
	info_box.display_info_box()

func close_purchase_window() -> void:
	info_box.dismiss_info_box()

func purchase_status_changed(purchase_successful: bool) -> void:
	if purchase_successful:
		current_status = InfoBoxStatus.SUCCESSFUL
	else:
		current_status = InfoBoxStatus.FAILED
	
	info_box.animator.play(info_box.ANIMATION_CHANGE_KEY)

func set_info_box() -> void:
	match(current_status):
		InfoBoxStatus.INITIAL:
			info_box.set_content(initial_resource)
			info_box.set_action_button(PurchaseController.premium_price)
		InfoBoxStatus.PROCESSING:
			info_box.set_content(pending_resource)
			processing_started.emit()
		InfoBoxStatus.SUCCESSFUL:
			info_box.set_content(success_resource)
			processing_finished.emit()
		InfoBoxStatus.FAILED:
			info_box.set_content(failed_resource)
			processing_finished.emit()

func _on_action_button_pressed() -> void:
	match(current_status):
		InfoBoxStatus.INITIAL:
			current_status = InfoBoxStatus.PROCESSING
			info_box.change_info_box()
			PurchaseController.purchase_premium_button_pressed()
		InfoBoxStatus.SUCCESSFUL:
			info_box.dismiss_info_box()
