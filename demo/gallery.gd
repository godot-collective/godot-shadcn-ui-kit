extends Control

var _grid: GridContainer
var _scroll: ScrollContainer

func _ready() -> void:
	_apply_theme()
	_build_gallery()
	resized.connect(_sync_layout)
	get_viewport().size_changed.connect(_sync_layout)
	call_deferred("_sync_layout")
	_update_columns()


func _apply_theme() -> void:
	var theme_path := "res://shadcn_dark_theme.tres"
	if ResourceLoader.exists(theme_path):
		theme = load(theme_path)


func _build_gallery() -> void:
	var bg := ColorRect.new()
	bg.anchor_right = 1.0
	bg.anchor_bottom = 1.0
	bg.color = Color("09090b")
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	_scroll = ScrollContainer.new()
	_scroll.anchor_right = 1.0
	_scroll.anchor_bottom = 1.0
	_scroll.offset_left = 20
	_scroll.offset_top = 20
	_scroll.offset_right = -20
	_scroll.offset_bottom = -20
	_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(_scroll)

	_grid = GridContainer.new()
	_grid.columns = 3
	_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_grid.add_theme_constant_override("h_separation", 16)
	_grid.add_theme_constant_override("v_separation", 16)
	_scroll.add_child(_grid)

	_grid.add_child(_build_payment_card())
	_grid.add_child(_build_team_card())
	_grid.add_child(_build_settings_card())
	_grid.add_child(_build_misc_card())


func _update_columns() -> void:
	if _grid == null:
		return

	var width := _scroll.size.x if _scroll != null else size.x - 40.0
	if width >= 1600.0:
		_grid.columns = 4
	elif width >= 1180.0:
		_grid.columns = 3
	elif width >= 800.0:
		_grid.columns = 2
	else:
		_grid.columns = 1


func _sync_layout() -> void:
	if _grid == null or _scroll == null:
		return

	_grid.custom_minimum_size.x = maxf(_scroll.size.x, 0.0)
	_update_columns()


func _build_payment_card() -> Control:
	var card := _make_card("Payment Method", "All transactions are secure and encrypted", Vector2(360, 680))
	var body := _card_body(card)

	body.add_child(_field_label("Name on Card"))
	body.add_child(_make_input("John Doe"))

	var row1 := HBoxContainer.new()
	row1.add_theme_constant_override("separation", 12)
	row1.add_child(_labeled_input("Card Number", "1234 5678 9012 3456", true))
	row1.add_child(_labeled_input("CVV", "123", false))
	body.add_child(row1)
	body.add_child(_muted_label("Enter your 16-digit number."))

	var row2 := HBoxContainer.new()
	row2.add_theme_constant_override("separation", 12)
	var month := OptionButton.new()
	month.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	month.add_item("MM")
	var year := OptionButton.new()
	year.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	year.add_item("YYYY")
	row2.add_child(_labeled_control("Month", month))
	row2.add_child(_labeled_control("Year", year))
	body.add_child(row2)

	body.add_child(HSeparator.new())
	body.add_child(_field_label("Billing Address"))
	body.add_child(_muted_label("The billing address associated with your payment method"))

	var same_shipping := CheckBox.new()
	same_shipping.text = "Same as shipping address"
	same_shipping.button_pressed = true
	body.add_child(same_shipping)

	body.add_child(HSeparator.new())
	body.add_child(_field_label("Comments"))
	var comments := TextEdit.new()
	comments.placeholder_text = "Add any additional comments"
	comments.custom_minimum_size = Vector2(0, 96)
	body.add_child(comments)

	var actions := HBoxContainer.new()
	actions.add_theme_constant_override("separation", 8)
	var submit := Button.new()
	submit.text = "Submit"
	_style_primary_button(submit)
	actions.add_child(submit)
	var cancel := Button.new()
	cancel.text = "Cancel"
	actions.add_child(cancel)
	body.add_child(actions)

	return card


func _build_team_card() -> Control:
	var card := _make_card("Collaboration", "", Vector2(360, 680))
	var body := _card_body(card)

	var avatars := HBoxContainer.new()
	avatars.alignment = BoxContainer.ALIGNMENT_CENTER
	avatars.add_theme_constant_override("separation", -8)
	avatars.add_child(_avatar_dot(Color("6b7280")))
	avatars.add_child(_avatar_dot(Color("9ca3af")))
	avatars.add_child(_avatar_dot(Color("d1d5db")))
	body.add_child(avatars)

	body.add_child(_title_label("No Team Members", true))
	body.add_child(_muted_label("Invite your team to collaborate on this project.", true))

	var invite := Button.new()
	invite.text = "+ Invite Members"
	_style_primary_button(invite)
	invite.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	body.add_child(invite)

	var status_row := HBoxContainer.new()
	status_row.add_theme_constant_override("separation", 8)
	status_row.add_child(_make_chip("Syncing"))
	status_row.add_child(_make_chip("Updating"))
	status_row.add_child(_make_chip("Loading"))
	body.add_child(status_row)

	var input_row := HBoxContainer.new()
	input_row.add_theme_constant_override("separation", 8)
	var plus := Button.new()
	plus.text = "+"
	plus.custom_minimum_size = Vector2(30, 30)
	input_row.add_child(plus)
	var search := LineEdit.new()
	search.placeholder_text = "Send a message..."
	search.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	input_row.add_child(search)
	body.add_child(input_row)

	body.add_child(_field_label("Price Range"))
	body.add_child(_muted_label("Set your budget range ($200 - 800)."))
	var slider := HSlider.new()
	slider.min_value = 0
	slider.max_value = 100
	slider.value = 78
	body.add_child(slider)

	var search_panel := _surface_panel(8)
	search_panel.custom_minimum_size = Vector2(0, 52)
	var search_row := HBoxContainer.new()
	search_row.add_theme_constant_override("separation", 8)
	search_panel.add_child(search_row)
	search_row.add_child(_icon_circle_button("⌕", false, 28))
	var search_input := _make_embedded_line_edit("", "Search...")
	search_input.add_theme_font_size_override("font_size", 18)
	search_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	search_row.add_child(search_input)
	var results := _muted_label("12 results", false, false)
	results.add_theme_font_size_override("font_size", 18)
	search_row.add_child(results)
	body.add_child(search_panel)

	var url_panel := _surface_panel(8)
	url_panel.custom_minimum_size = Vector2(0, 52)
	var url_row := HBoxContainer.new()
	url_row.add_theme_constant_override("separation", 6)
	url_panel.add_child(url_row)
	var url_input := _make_embedded_line_edit("https://example.com", "")
	url_input.add_theme_font_size_override("font_size", 18)
	url_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	url_row.add_child(url_input)
	var info := _muted_label("ⓘ", false, false)
	info.add_theme_font_size_override("font_size", 20)
	url_row.add_child(info)
	body.add_child(url_panel)

	var composer := _surface_panel(10)
	composer.custom_minimum_size = Vector2(0, 170)
	var composer_body := VBoxContainer.new()
	composer_body.add_theme_constant_override("separation", 8)
	composer.add_child(composer_body)
	var composer_input := _make_embedded_text_edit("Ask, Search or Chat...")
	composer_input.custom_minimum_size = Vector2(0, 90)
	composer_body.add_child(composer_input)
	var composer_footer := HBoxContainer.new()
	composer_footer.add_theme_constant_override("separation", 8)
	composer_footer.add_child(_icon_circle_button("+", false, 34))
	composer_footer.add_child(_muted_label("Auto", false, false))
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	composer_footer.add_child(spacer)
	composer_footer.add_child(_muted_label("52% used", false, false))
	var divider := VSeparator.new()
	divider.custom_minimum_size = Vector2(8, 24)
	composer_footer.add_child(divider)
	composer_footer.add_child(_icon_circle_button("↑", true, 34))
	composer_body.add_child(composer_footer)
	body.add_child(composer)

	var mention_panel := _surface_panel(8)
	mention_panel.custom_minimum_size = Vector2(0, 48)
	var mention_row := HBoxContainer.new()
	mention_row.add_theme_constant_override("separation", 8)
	mention_panel.add_child(mention_row)
	var mention_input := _make_embedded_line_edit("@shadcn", "")
	mention_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	mention_input.add_theme_font_size_override("font_size", 18)
	mention_row.add_child(mention_input)
	mention_row.add_child(_icon_circle_badge("✓"))
	body.add_child(mention_panel)

	return card


func _build_settings_card() -> Control:
	var card := _make_card("System Settings", "", Vector2(360, 680))
	var body := _card_body(card)

	var url_row := HBoxContainer.new()
	url_row.add_theme_constant_override("separation", 8)
	var url := LineEdit.new()
	url.placeholder_text = "https://"
	url.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	url_row.add_child(url)
	var star := Button.new()
	star.text = "☆"
	url_row.add_child(star)
	body.add_child(url_row)

	var tfa := _surface_panel(10)
	tfa.custom_minimum_size = Vector2(0, 96)
	var tfa_row := HBoxContainer.new()
	tfa_row.add_theme_constant_override("separation", 10)
	tfa.add_child(tfa_row)
	var tfa_text := VBoxContainer.new()
	tfa_text.add_theme_constant_override("separation", 4)
	var tfa_title := Label.new()
	tfa_title.text = "Two-factor authentication"
	tfa_title.add_theme_font_size_override("font_size", 16)
	tfa_title.add_theme_color_override("font_color", Color("fafafa"))
	tfa_text.add_child(tfa_title)
	var tfa_desc := _muted_label("Verify via email or phone number.", false, false)
	tfa_desc.add_theme_font_size_override("font_size", 13)
	tfa_text.add_child(tfa_desc)
	tfa_row.add_child(tfa_text)
	var tfa_spacer := Control.new()
	tfa_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tfa_row.add_child(tfa_spacer)
	var enable := Button.new()
	enable.text = "Enable"
	_style_primary_button(enable)
	enable.add_theme_font_size_override("font_size", 14)
	enable.custom_minimum_size = Vector2(92, 40)
	enable.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	tfa_row.add_child(enable)
	body.add_child(tfa)

	var verified := Button.new()
	verified.text = "Your profile has been verified."
	verified.alignment = HORIZONTAL_ALIGNMENT_LEFT
	verified.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.add_child(verified)

	body.add_child(HSeparator.new())
	body.add_child(_muted_label("Appearance Settings", true))

	body.add_child(_field_label("Compute Environment"))
	body.add_child(_muted_label("Select the compute environment for your cluster."))

	body.add_child(_choice_card("Kubernetes", "Run GPU workloads on a configured cluster.", true))
	body.add_child(_choice_card("Virtual Machine", "Access VM workloads. (Coming soon)", false))

	body.add_child(HSeparator.new())
	var gpu_row := HBoxContainer.new()
	gpu_row.add_theme_constant_override("separation", 8)
	var gpu_text := VBoxContainer.new()
	gpu_text.add_child(_field_label("Number of GPUs"))
	gpu_text.add_child(_muted_label("You can add more later."))
	gpu_row.add_child(gpu_text)
	var gpu_spacer := Control.new()
	gpu_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	gpu_row.add_child(gpu_spacer)
	var spin := SpinBox.new()
	spin.min_value = 1
	spin.max_value = 16
	spin.step = 1
	spin.value = 8
	spin.custom_minimum_size = Vector2(110, 0)
	gpu_row.add_child(spin)
	body.add_child(gpu_row)

	body.add_child(HSeparator.new())
	var tint_row := HBoxContainer.new()
	var tint_text := VBoxContainer.new()
	tint_text.add_child(_field_label("Wallpaper Tinting"))
	tint_text.add_child(_muted_label("Allow the wallpaper to be tinted."))
	tint_row.add_child(tint_text)
	var tint_spacer := Control.new()
	tint_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tint_row.add_child(tint_spacer)
	var toggle := CheckBox.new()
	toggle.button_pressed = true
	toggle.text = ""
	tint_row.add_child(toggle)
	body.add_child(tint_row)

	return card


func _build_misc_card() -> Control:
	var card := _make_card("Assistant", "", Vector2(360, 680))
	var body := _card_body(card)

	var prompt := TextEdit.new()
	prompt.placeholder_text = "Ask, search, or make anything..."
	prompt.custom_minimum_size = Vector2(0, 120)
	body.add_child(prompt)

	var action_row := HBoxContainer.new()
	action_row.add_theme_constant_override("separation", 8)
	action_row.add_child(_make_chip("Archive"))
	action_row.add_child(_make_chip("Report"))
	action_row.add_child(_make_chip("Snooze"))
	action_row.add_child(_make_chip("..."))
	body.add_child(action_row)

	var agree := CheckBox.new()
	agree.text = "I agree to the terms and conditions"
	agree.button_pressed = true
	body.add_child(agree)

	var pager := HBoxContainer.new()
	pager.add_theme_constant_override("separation", 6)
	pager.add_child(_make_chip("1"))
	pager.add_child(_make_chip("2", true))
	pager.add_child(_make_chip("3"))
	pager.add_child(_make_chip("←"))
	pager.add_child(_make_chip("→"))
	var pager_spacer := Control.new()
	pager_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	pager.add_child(pager_spacer)
	var source := OptionButton.new()
	source.add_item("Copilot")
	pager.add_child(source)
	body.add_child(pager)

	body.add_child(HSeparator.new())
	body.add_child(_field_label("How did you hear about us?"))
	body.add_child(_muted_label("Select the option that best describes how you found us."))

	var chips1 := HBoxContainer.new()
	chips1.add_theme_constant_override("separation", 8)
	chips1.add_child(_make_chip("Social Media", true))
	chips1.add_child(_make_chip("Search Engine"))
	body.add_child(chips1)

	var chips2 := HBoxContainer.new()
	chips2.add_theme_constant_override("separation", 8)
	chips2.add_child(_make_chip("Referral"))
	chips2.add_child(_make_chip("Other"))
	body.add_child(chips2)

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_child(spacer)

	var loading := _surface_panel(16)
	loading.custom_minimum_size = Vector2(0, 170)
	var loading_body := VBoxContainer.new()
	loading_body.alignment = BoxContainer.ALIGNMENT_CENTER
	loading_body.add_theme_constant_override("separation", 10)
	loading.add_child(loading_body)
	var spinner := _avatar_dot(Color("3f3f46"), 42)
	loading_body.add_child(spinner)
	loading_body.add_child(_title_label("Processing your request", true))
	loading_body.add_child(_muted_label("Please wait while we process your request.", true))
	var cancel := Button.new()
	cancel.text = "Cancel"
	loading_body.add_child(cancel)
	body.add_child(loading)

	return card


func _make_card(title: String, subtitle: String, min_size: Vector2) -> PanelContainer:
	var card := PanelContainer.new()
	card.custom_minimum_size = min_size
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var card_style := StyleBoxFlat.new()
	card_style.bg_color = Color("0f0f10")
	card_style.border_color = Color("262626")
	card_style.set_border_width_all(1)
	card_style.set_corner_radius_all(14)
	card_style.shadow_color = Color(0, 0, 0, 0.25)
	card_style.shadow_size = 6
	card_style.shadow_offset = Vector2(0, 2)
	card.add_theme_stylebox_override("panel", card_style)

	var margin := MarginContainer.new()
	margin.name = "Margin"
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_top", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_bottom", 18)
	card.add_child(margin)

	var body := VBoxContainer.new()
	body.name = "Body"
	body.add_theme_constant_override("separation", 12)
	margin.add_child(body)

	if title != "":
		body.add_child(_title_label(title))
	if subtitle != "":
		body.add_child(_muted_label(subtitle))

	return card


func _card_body(card: PanelContainer) -> VBoxContainer:
	return card.get_node("Margin/Body") as VBoxContainer


func _title_label(text: String, center := false) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 30 if center else 28)
	label.add_theme_color_override("font_color", Color("fafafa"))
	if center:
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return label


func _field_label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 18)
	label.add_theme_color_override("font_color", Color("f5f5f5"))
	return label


func _muted_label(text: String, center := false, wrap := true) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 16)
	label.add_theme_color_override("font_color", Color("a3a3a3"))
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART if wrap else TextServer.AUTOWRAP_OFF
	if not wrap:
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	if center:
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return label


func _make_input(placeholder: String) -> LineEdit:
	var input := LineEdit.new()
	input.placeholder_text = placeholder
	input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return input


func _labeled_input(title: String, placeholder: String, expand := true) -> VBoxContainer:
	var wrap := VBoxContainer.new()
	wrap.add_theme_constant_override("separation", 6)
	wrap.size_flags_horizontal = Control.SIZE_EXPAND_FILL if expand else Control.SIZE_SHRINK_BEGIN
	wrap.add_child(_field_label(title))
	var input := _make_input(placeholder)
	if not expand:
		input.custom_minimum_size = Vector2(90, 0)
	wrap.add_child(input)
	return wrap


func _labeled_control(title: String, control: Control) -> VBoxContainer:
	var wrap := VBoxContainer.new()
	wrap.add_theme_constant_override("separation", 6)
	wrap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	wrap.add_child(_field_label(title))
	wrap.add_child(control)
	return wrap


func _style_primary_button(button: Button) -> void:
	button.add_theme_color_override("font_color", Color("171717"))
	button.add_theme_color_override("font_hover_color", Color("171717"))
	button.add_theme_color_override("font_pressed_color", Color("171717"))

	var normal := StyleBoxFlat.new()
	normal.bg_color = Color("fafafa")
	normal.border_color = Color("fafafa")
	normal.set_border_width_all(1)
	normal.set_corner_radius_all(9)
	normal.content_margin_left = 12
	normal.content_margin_right = 12
	normal.content_margin_top = 7
	normal.content_margin_bottom = 7

	var hover := normal.duplicate()
	hover.bg_color = Color("e5e5e5")
	hover.border_color = Color("e5e5e5")

	var pressed := normal.duplicate()
	pressed.bg_color = Color("d4d4d4")
	pressed.border_color = Color("d4d4d4")

	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", pressed)


func _icon_circle_button(text: String, primary := false, size := 30) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(size, size)
	button.add_theme_font_size_override("font_size", 18)
	button.add_theme_color_override("font_color", Color("171717") if primary else Color("a3a3a3"))
	button.add_theme_color_override("font_hover_color", Color("171717") if primary else Color("fafafa"))
	button.add_theme_color_override("font_pressed_color", Color("171717") if primary else Color("fafafa"))

	var normal := StyleBoxFlat.new()
	normal.bg_color = Color("fafafa") if primary else Color("1a1a1b")
	normal.border_color = Color("fafafa") if primary else Color("3f3f46")
	normal.set_border_width_all(1)
	normal.set_corner_radius_all(999)
	normal.content_margin_left = 0
	normal.content_margin_right = 0
	normal.content_margin_top = 0
	normal.content_margin_bottom = 0

	var hover := normal.duplicate()
	hover.bg_color = Color("e5e5e5") if primary else Color("262626")

	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", hover)
	return button


func _icon_circle_badge(text: String) -> PanelContainer:
	var badge := PanelContainer.new()
	badge.custom_minimum_size = Vector2(28, 28)
	var style := StyleBoxFlat.new()
	style.bg_color = Color("a3a3a3")
	style.set_corner_radius_all(999)
	badge.add_theme_stylebox_override("panel", style)

	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", Color("fafafa"))
	label.add_theme_font_size_override("font_size", 16)
	badge.add_child(label)
	return badge


func _inline_field(prefix: String, value: String, suffix: String = "") -> PanelContainer:
	var panel := _surface_panel(8)
	panel.custom_minimum_size = Vector2(0, 52)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	panel.add_child(row)

	var left := Label.new()
	left.text = prefix
	left.add_theme_color_override("font_color", Color("93c5fd"))
	left.add_theme_font_size_override("font_size", 18)
	row.add_child(left)

	var center := _muted_label(value, false, false)
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center.add_theme_font_size_override("font_size", 18)
	row.add_child(center)

	if suffix != "":
		var right := _muted_label(suffix, false, false)
		right.add_theme_font_size_override("font_size", 20)
		row.add_child(right)

	return panel


func _make_embedded_line_edit(text: String, placeholder: String) -> LineEdit:
	var input := LineEdit.new()
	input.text = text
	input.placeholder_text = placeholder
	var empty := StyleBoxEmpty.new()
	input.add_theme_stylebox_override("normal", empty)
	input.add_theme_stylebox_override("focus", empty)
	input.add_theme_stylebox_override("read_only", empty)
	return input


func _make_embedded_text_edit(placeholder: String) -> TextEdit:
	var editor := TextEdit.new()
	editor.placeholder_text = placeholder
	editor.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var empty := StyleBoxEmpty.new()
	editor.add_theme_stylebox_override("normal", empty)
	editor.add_theme_stylebox_override("focus", empty)
	editor.add_theme_stylebox_override("read_only", empty)
	return editor


func _make_chip(text: String, active := false) -> Button:
	var chip := Button.new()
	chip.text = text
	chip.toggle_mode = false
	chip.add_theme_font_size_override("font_size", 14)

	var normal := StyleBoxFlat.new()
	normal.bg_color = Color("1e1e1f") if active else Color("141415")
	normal.border_color = Color("3b82f6") if active else Color("262626")
	normal.set_border_width_all(1)
	normal.set_corner_radius_all(999)
	normal.content_margin_left = 10
	normal.content_margin_right = 10
	normal.content_margin_top = 4
	normal.content_margin_bottom = 4

	var hover := normal.duplicate()
	hover.bg_color = Color("262626") if not active else Color("1d4ed8")

	chip.add_theme_stylebox_override("normal", normal)
	chip.add_theme_stylebox_override("hover", hover)
	chip.add_theme_stylebox_override("pressed", hover)
	chip.add_theme_color_override("font_color", Color("fafafa"))
	chip.add_theme_color_override("font_hover_color", Color("fafafa"))
	chip.add_theme_color_override("font_pressed_color", Color("fafafa"))
	return chip


func _surface_panel(padding := 12) -> PanelContainer:
	var panel := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color("121213")
	style.border_color = Color("34353b")
	style.set_border_width_all(1)
	style.set_corner_radius_all(14)
	style.content_margin_left = padding
	style.content_margin_right = padding
	style.content_margin_top = padding
	style.content_margin_bottom = padding
	panel.add_theme_stylebox_override("panel", style)
	return panel


func _choice_card(title: String, description: String, selected: bool) -> PanelContainer:
	var panel := _surface_panel(12)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	panel.add_child(row)

	var text := VBoxContainer.new()
	text.add_theme_constant_override("separation", 4)
	text.add_child(_field_label(title))
	text.add_child(_muted_label(description))
	row.add_child(text)

	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(spacer)

	var select := CheckBox.new()
	select.text = ""
	select.button_pressed = selected
	row.add_child(select)
	return panel


func _avatar_dot(color: Color, size := 30) -> PanelContainer:
	var avatar := PanelContainer.new()
	avatar.custom_minimum_size = Vector2(size, size)
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.set_corner_radius_all(999)
	avatar.add_theme_stylebox_override("panel", style)
	return avatar
