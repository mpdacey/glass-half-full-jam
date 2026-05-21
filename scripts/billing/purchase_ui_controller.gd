extends CanvasLayer
class_name PurchaseUIController

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

func _init() -> void:
	info_box.add_user_signal(InfoBoxController.CHANGING_USER_SIGNAL)
	info_box.connect(InfoBoxController.CHANGING_USER_SIGNAL, set_info_box)

func open_purchase_window() -> void:
	current_status = InfoBoxStatus.INITIAL
	set_info_box()
	info_box.show()

func set_info_box() -> void:
	match(current_status):
		InfoBoxStatus.INITIAL:
			info_box.set_content(initial_resource)
		InfoBoxStatus.PROCESSING:
			info_box.set_content(pending_resource)
		InfoBoxStatus.SUCCESSFUL:
			info_box.set_content(success_resource)
		InfoBoxStatus.FAILED:
			info_box.set_content(failed_resource)

func _on_action_button_pressed() -> void:
	match(current_status):
		InfoBoxStatus.INITIAL:
			current_status = InfoBoxStatus.PROCESSING
			info_box.animator.play(info_box.ANIMATION_CHANGE_KEY)
		InfoBoxStatus.SUCCESSFUL:
			info_box.animator.play(info_box.ANIMATION_HIDE_KEY)
