class_name RunUI
extends TextureRect

signal open_map

@onready var tooltip = $Tooltip

func _ready() -> void:
	EventBusHandler.show_tooltips.connect(_on_eventbus_show_tooltips)
	EventBusHandler.hide_tooltips.connect(_on_eventbus_hide_tooltips)

func _on_deck_icon_gui_input(event: InputEvent) -> void:
	if event.is_action_released("left_click"):
		pass

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
