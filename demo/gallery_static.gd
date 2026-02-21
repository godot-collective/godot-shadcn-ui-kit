extends Control

@onready var _scroll: ScrollContainer = $Scroll
@onready var _grid: GridContainer = $Scroll/Grid


func _ready() -> void:
	_apply_theme()
	_apply_static_defaults()
	resized.connect(_sync_layout)
	get_viewport().size_changed.connect(_sync_layout)
	call_deferred("_sync_layout")


func _apply_theme() -> void:
	var theme_path := "res://shadcn_dark_theme.tres"
	if ResourceLoader.exists(theme_path):
		theme = load(theme_path)


func _sync_layout() -> void:
	if _grid == null or _scroll == null:
		return

	_grid.custom_minimum_size.x = maxf(_scroll.size.x, 0.0)

	var width := _scroll.size.x
	if width >= 1600.0:
		_grid.columns = 4
	elif width >= 1180.0:
		_grid.columns = 3
	elif width >= 800.0:
		_grid.columns = 2
	else:
		_grid.columns = 1


func _apply_static_defaults() -> void:
	_ensure_option_item("Scroll/Grid/PaymentCard/Margin/Body/MonthYearRow/MonthWrap/MonthInput", "MM")
	_ensure_option_item("Scroll/Grid/PaymentCard/Margin/Body/MonthYearRow/YearWrap/YearInput", "YYYY")
	_ensure_option_item("Scroll/Grid/AssistantCard/Margin/Body/PagerRow/Source", "Copilot")


func _ensure_option_item(path: String, item_text: String) -> void:
	var option := get_node_or_null(path) as OptionButton
	if option == null:
		return
	if option.item_count == 0:
		option.add_item(item_text)
	if option.item_count > 0 and option.selected < 0:
		option.select(0)
