extends Control

@onready var _sidebar: PanelContainer = $AppFrame/Body/Sidebar
@onready var _content: VBoxContainer = $AppFrame/Body/MainArea/MainBody/Scroll/Center/Content
@onready var _conversation: VBoxContainer = $AppFrame/Body/MainArea/MainBody/Scroll/Center/Content/Conversation
@onready var _welcome_block: VBoxContainer = $AppFrame/Body/MainArea/MainBody/Scroll/Center/Content/WelcomeBlock
@onready var _suggestion_flow: HFlowContainer = $AppFrame/Body/MainArea/MainBody/Scroll/Center/Content/SuggestionFlow
@onready var _message_input: TextEdit = $AppFrame/Body/MainArea/MainBody/Scroll/Center/Content/InputPanel/InputMargin/InputBody/MessageInput
@onready var _new_thread: Button = $AppFrame/Body/Sidebar/SidebarMargin/SidebarBody/NewThread
@onready var _send_button: Button = $AppFrame/Body/MainArea/MainBody/Scroll/Center/Content/InputPanel/InputMargin/InputBody/InputFooter/SendButton
@onready var _attach_button: Button = $AppFrame/Body/MainArea/MainBody/Scroll/Center/Content/InputPanel/InputMargin/InputBody/InputFooter/AttachButton
@onready var _menu_button: Button = $AppFrame/Body/MainArea/TopBar/LeftActions/MenuButton
@onready var _share_button: Button = $AppFrame/Body/MainArea/TopBar/ShareButton
@onready var _model_select: OptionButton = $AppFrame/Body/MainArea/TopBar/LeftActions/ModelSelect
@onready var _suggestion_a: Button = $AppFrame/Body/MainArea/MainBody/Scroll/Center/Content/SuggestionFlow/SuggestionA
@onready var _suggestion_b: Button = $AppFrame/Body/MainArea/MainBody/Scroll/Center/Content/SuggestionFlow/SuggestionB


func _ready() -> void:
	_apply_theme()
	_seed_models()
	_apply_styles()
	_wire_events()
	resized.connect(_sync_layout)
	get_viewport().size_changed.connect(_sync_layout)
	call_deferred("_sync_layout")


func _apply_theme() -> void:
	var theme_path := "res://shadcn_dark_theme.tres"
	if ResourceLoader.exists(theme_path):
		theme = load(theme_path)


func _seed_models() -> void:
	if _model_select.item_count > 0:
		return
	_model_select.add_item("Gemini 3.0 Flash")
	_model_select.add_item("GPT-4.1")
	_model_select.add_item("Claude 3.7 Sonnet")
	_model_select.select(0)


func _apply_styles() -> void:
	_style_icon_button(_menu_button, "[]")
	_style_icon_button(_share_button, "^")
	_style_icon_button(_attach_button, "+")
	_style_icon_button(_send_button, "^", true)

	_style_suggestion_button(_suggestion_a)
	_style_suggestion_button(_suggestion_b)

	for child in $AppFrame/Body/Sidebar/SidebarMargin/SidebarBody/Threads.get_children():
		if child is Button:
			_style_thread_button(child)


func _wire_events() -> void:
	_new_thread.pressed.connect(_reset_conversation)
	_send_button.pressed.connect(_send_message)
	_suggestion_a.pressed.connect(func() -> void:
		_message_input.text = "What's the weather in San Francisco?"
		_message_input.grab_focus()
	)
	_suggestion_b.pressed.connect(func() -> void:
		_message_input.text = "Explain React hooks like useState and useEffect."
		_message_input.grab_focus()
	)


func _sync_layout() -> void:
	var width := size.x
	_sidebar.visible = width >= 920.0
	if width < 1160.0:
		_content.custom_minimum_size.x = maxf(width - (_sidebar.size.x if _sidebar.visible else 80.0), 480.0)
	else:
		_content.custom_minimum_size.x = 860.0


func _send_message() -> void:
	var text := _message_input.text.strip_edges()
	if text == "":
		return

	var bubble := PanelContainer.new()
	bubble.size_flags_horizontal = Control.SIZE_SHRINK_END
	bubble.add_theme_stylebox_override("panel", _make_bubble_style())

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_bottom", 10)
	bubble.add_child(margin)

	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.custom_minimum_size = Vector2(120, 0)
	label.add_theme_font_size_override("font_size", 15)
	label.add_theme_color_override("font_color", Color("f4f4f5"))
	margin.add_child(label)

	_conversation.add_child(bubble)
	_conversation.visible = true
	_welcome_block.visible = false
	_suggestion_flow.visible = false
	_message_input.clear()


func _reset_conversation() -> void:
	for child in _conversation.get_children():
		child.queue_free()
	_conversation.visible = false
	_welcome_block.visible = true
	_suggestion_flow.visible = true
	_message_input.clear()


func _style_icon_button(button: Button, text_value: String, primary := false) -> void:
	button.text = text_value
	button.custom_minimum_size = Vector2(34, 34)
	button.add_theme_font_size_override("font_size", 17)
	button.add_theme_color_override("font_color", Color("18181b") if primary else Color("a1a1aa"))
	button.add_theme_color_override("font_hover_color", Color("18181b") if primary else Color("fafafa"))
	button.add_theme_color_override("font_pressed_color", Color("18181b") if primary else Color("fafafa"))

	var normal := StyleBoxFlat.new()
	normal.bg_color = Color("fafafa") if primary else Color("121214")
	normal.border_color = Color("fafafa") if primary else Color("303136")
	normal.set_border_width_all(1)
	normal.set_corner_radius_all(999)

	var hover := normal.duplicate()
	hover.bg_color = Color("e4e4e7") if primary else Color("1c1d21")

	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", hover)


func _style_suggestion_button(button: Button) -> void:
	button.custom_minimum_size = Vector2(360, 84)
	button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.add_theme_font_size_override("font_size", 15)
	button.add_theme_color_override("font_color", Color("f4f4f5"))

	var normal := StyleBoxFlat.new()
	normal.bg_color = Color("111113")
	normal.border_color = Color("2d2e33")
	normal.set_border_width_all(1)
	normal.set_corner_radius_all(14)
	normal.content_margin_left = 16
	normal.content_margin_top = 12
	normal.content_margin_right = 16
	normal.content_margin_bottom = 12

	var hover := normal.duplicate()
	hover.bg_color = Color("17181c")

	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", hover)


func _style_thread_button(button: Button) -> void:
	button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.add_theme_font_size_override("font_size", 15)
	button.add_theme_color_override("font_color", Color("d4d4d8"))

	var normal := StyleBoxFlat.new()
	normal.bg_color = Color(0, 0, 0, 0)
	normal.set_corner_radius_all(10)
	normal.content_margin_left = 8
	normal.content_margin_top = 8
	normal.content_margin_right = 8
	normal.content_margin_bottom = 8

	var hover := normal.duplicate()
	hover.bg_color = Color("18181b")

	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", hover)


func _make_bubble_style() -> StyleBoxFlat:
	var bubble := StyleBoxFlat.new()
	bubble.bg_color = Color("17181c")
	bubble.border_color = Color("2f3036")
	bubble.set_border_width_all(1)
	bubble.set_corner_radius_all(12)
	return bubble
