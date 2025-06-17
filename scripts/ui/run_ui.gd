class_name RunUI
extends TextureRect

signal open_map

@onready var tooltip = $Tooltip
@onready var hitpoints = $IconsLeft/HPLabel

var current_hp: int = 0
var max_hp: int = 100

func initialize() -> void:
	EventBusHandler.show_tooltips.connect(_on_eventbus_show_tooltips)
	EventBusHandler.hide_tooltips.connect(_on_eventbus_hide_tooltips)
	RunData.player_stats.hitpoints_changed.connect(_on_stats_hp_changed)

func _on_deck_icon_gui_input(event: InputEvent) -> void:
	if event.is_action_released("left_click"):
		EventBusHandler.show_deck_view.emit(DeckHandler.current_deck)

func _on_map_icon_gui_input(event: InputEvent) -> void:
	if event.is_action_released("left_click"):
		open_map.emit()

func _on_settings_icon_gui_input(event: InputEvent) -> void:
	if event.is_action_released("left_click"):
		EventBusHandler.open_settings.emit()

func _on_eventbus_show_tooltips(data: Array[TooltipData]) -> void:
	tooltip.load_tooltips(data)
	tooltip.show()

func _on_eventbus_hide_tooltips() -> void:
	tooltip.hide()

func _on_stats_hp_changed(current_hp: int, max_hp: int):
	hitpoints.text = "%d/%d" % [current_hp, max_hp]
