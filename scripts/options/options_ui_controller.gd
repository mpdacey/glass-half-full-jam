extends CanvasLayer
class_name OptionsUIController

signal view_credits_requested

const PRIVACY_POLICY_URL = "https://github.com/mpdacey/glass-half-full-jam/blob/main/app_privacy_policy.md"
const DEFAULT_DISPLAY_TEXT = "Options"

enum OptionState {
	DEFAULT,
	MUTE_MUSIC,
	MUTE_SFX,
	CREDITS,
	PRIVACY_POLICY,
}

@export var display_label: RichTextLabel
@export var animator: AnimationPlayer
@export_group("Display Text Animation Values")
@export_range(0, 2.0, 0.1) var display_text_seconds: float = 0.4
@export_range(0, 5.0, 0.1) var hold_text_seconds: float = 2.0
var display_text_tween: Tween
var current_display_state : OptionState = OptionState.DEFAULT

func tween_display_text(message: String, start_character : int = 0) -> void:
	if display_text_tween:
		display_text_tween.kill()
	display_text_tween = create_tween()
	
	start_character = clampi(start_character, 0, message.length())
	var starting_ratio : float = start_character / float(message.length())
	var shifted_text_seconds := (1.0 - starting_ratio) * display_text_seconds
	
	display_label.visible_ratio = starting_ratio
	display_label.text = message
	
	display_text_tween.tween_property(display_label, "visible_ratio", 1.0, shifted_text_seconds)
	
	if current_display_state != OptionState.DEFAULT:
		display_text_tween.tween_property(self, "current_display_state", OptionState.DEFAULT, 0).set_delay(hold_text_seconds)
		display_text_tween.tween_callback(tween_display_text.bind(DEFAULT_DISPLAY_TEXT))

func display() -> void:
	current_display_state = OptionState.DEFAULT
	animator.play(&"show")

func dismiss() -> void:
	animator.play(&"hide")

func _on_privacy_policy_button_pressed() -> void:
	OS.shell_open(PRIVACY_POLICY_URL)
	current_display_state = OptionState.PRIVACY_POLICY
	tween_display_text("View Privacy Policy")

func _on_credits_button_pressed() -> void:
	view_credits_requested.emit()
	current_display_state = OptionState.CREDITS
	tween_display_text("View Credits")

func _on_music_mute_button_toggle_set(toggled_on: bool) -> void:
	var message := "Music "
	if toggled_on:
		message += "Muted"
	else:
		message += "Unmuted"
	
	var text_offset := 5 if current_display_state == OptionState.MUTE_MUSIC else 0
	current_display_state = OptionState.MUTE_MUSIC
	tween_display_text(message, text_offset)

func _on_sound_mute_button_toggle_set(toggled_on: bool) -> void:
	var message := "SFX "
	if toggled_on:
		message += "Muted"
	else:
		message += "Unmuted"
	
	var text_offset := 5 if current_display_state == OptionState.MUTE_SFX else 0
	current_display_state = OptionState.MUTE_SFX
	tween_display_text(message, text_offset)
