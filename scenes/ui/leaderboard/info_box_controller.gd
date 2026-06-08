extends CanvasLayer
class_name InfoBoxController

signal action_button_pressed

const CONTENT_RESOURCE_METADATA_KEY = &"content"
const CHANGING_USER_SIGNAL = &"changing"
const ANIMATION_CHANGE_KEY = &"change"
const ANIMATION_SHOW_KEY = &"show"
const ANIMATION_HIDE_KEY = &"hide"

@export var title_label: RichTextLabel
@export var body_label: RichTextLabel
@export var hyper_link_label: RichTextLabel
@export var action_button: Button
@export var dismiss_button: Button
@export var animator: AnimationPlayer

func _enter_tree() -> void:
	_assign_content_metadata()

func _ready() -> void:
	action_button.pressed.connect(action_button_pressed.emit)

func set_content_using_metadata(metadata_key: StringName) -> void:
	if not has_meta(metadata_key):
		printerr("Tried to apply content to infobox with invalid metadata key.")
		return
	
	var raw_metadata : Variant = get_meta(metadata_key)
	if not raw_metadata is InfoBoxContentsResource:
		printerr(
			str("Infobox with metadata `", metadata_key,
			"` was not of type InfoBoxContentsResource")
		)
		return
	
	var metadata_content : InfoBoxContentsResource = raw_metadata
	set_content(metadata_content)

func set_content(content: InfoBoxContentsResource) -> void:
	set_title(content.title)
	set_body(content.body)
	set_hyper_link(content.hyperlink_text, content.hyperlink_url)
	set_action_button(content.button_content)
	set_dismiss_button_visibility(content.can_dismiss)

func set_title(title: String) -> void:
	title_label.clear()
	title_label.push_bold_italics()
	title_label.add_text(title)
	title_label.pop_all()

func set_body(body: String) -> void:
	body_label.visible = body != ""
	body_label.text = body

func set_hyper_link(hyper_link_text: String, url: String = "") -> void:
	hyper_link_label.visible = hyper_link_text != ""
	
	if url == "":
		hyper_link_label.text = hyper_link_text
		return
	
	hyper_link_label.push_meta(url, RichTextLabel.META_UNDERLINE_ALWAYS)
	hyper_link_label.add_text(hyper_link_text)
	title_label.pop_all()

func set_action_button(action_button_text: String) -> void:
	action_button.text = action_button_text
	action_button.visible = action_button_text != ""

func set_dismiss_button_visibility(can_dismiss: bool) -> void:
	dismiss_button.visible = can_dismiss

func emit_changing() -> void:
	if has_user_signal(CHANGING_USER_SIGNAL):
		emit_signal(CHANGING_USER_SIGNAL)

func display_info_box() -> void:
	animator.play(ANIMATION_SHOW_KEY)

func dismiss_info_box() -> void:
	animator.play(ANIMATION_HIDE_KEY)

func _assign_content_metadata() -> void:
	if not has_meta(CONTENT_RESOURCE_METADATA_KEY):
		return
	
	var raw_content: Variant = get_meta(CONTENT_RESOURCE_METADATA_KEY)
	if not raw_content or raw_content is not InfoBoxContentsResource:
		return
	
	set_content(raw_content as InfoBoxContentsResource)

func _on_hyper_link_clicked(url: String) -> void:
	OS.shell_open(url)
