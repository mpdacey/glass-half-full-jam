extends CanvasLayer
class_name OptionsUIController

const PRIVACY_POLICY_URL = "https://github.com/mpdacey/glass-half-full-jam/blob/main/app_privacy_policy.md"

@export var display_label: RichTextLabel

func _on_privacy_policy_button_pressed() -> void:
	OS.shell_open(PRIVACY_POLICY_URL)

func _on_credits_button_pressed() -> void:
	pass # Replace with function body.
