extends PanelContainer
class_name LeaderboardEntryController

const DEFAULT_PROFILE_TEXTURE := preload("uid://di7q3iwunf60j")
const SCROLL_AMOUNT_PER_SECOND = 30
const DELAY_BETWEEN_PING_PONG = 0.7

@export var username_label : Label
@export var username_scroll_container: ScrollContainer
@export var score_label : RichTextLabel
@export var rank_label : Label
@export var profile_picture : TextureRect
@export var http_request: HTTPRequest
var _username_scroll : HScrollBar
var _scroll_tween : Tween

func set_entry_values(data: PlayGamesLeaderboardScore) -> void:
	visible = data != null
	if not visible:
		return
	
	username_label.text = data.score_holder_display_name
	
	score_label.clear()
	score_label.add_text(str(float(data.raw_score) * 0.1))
	score_label.push_font_size(24)
	score_label.add_text("KM")
	score_label.pop()
	
	rank_label.text = str(data.display_rank)
	_set_scrolling_animation.call_deferred()
	
	if data.score_holder.has_icon_image:
		_set_profile_picture(data.score_holder.icon_image_uri)

func _set_scrolling_animation() -> void:
	if _scroll_tween:
		_scroll_tween.kill()
	
	_username_scroll = username_scroll_container.get_h_scroll_bar()
	#I don't like how this signal gets emitted multiple times before its finally "ready" but whatever
	if not _username_scroll.changed.is_connected(_on_scroll_changed):
		_username_scroll.changed.connect(_on_scroll_changed)

func _set_profile_picture(icon_image_uri: String) -> void:
	profile_picture.texture = DEFAULT_PROFILE_TEXTURE
	if icon_image_uri == "":
		return
		
	var image := Image.load_from_file(icon_image_uri)
	if not image:
		return
	
	var texture_image := ImageTexture.create_from_image(image)
	profile_picture.texture = texture_image

func _on_scroll_changed() -> void:
	_username_scroll.value = 0
	if _username_scroll.max_value == _username_scroll.page:
		return
	
	if _scroll_tween:
		_scroll_tween.kill()
	
	var scroll_range := _username_scroll.max_value - _username_scroll.page
	var scroll_time := float(scroll_range) / SCROLL_AMOUNT_PER_SECOND
	
	_scroll_tween = create_tween()
	_scroll_tween.tween_property(_username_scroll, "value", scroll_range, scroll_time).set_delay(DELAY_BETWEEN_PING_PONG)
	_scroll_tween.tween_property(_username_scroll, "value", 0, scroll_time).set_delay(DELAY_BETWEEN_PING_PONG)
	_scroll_tween.set_loops()
