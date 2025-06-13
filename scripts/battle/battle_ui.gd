class_name BattleUI
extends Control

@onready var end_turn_button: Button = $EndTurnButton

func _ready() -> void:
	EventBusHandler.entered_idle.connect(_on_event_bus_entered_idle)

func _on_discard_pile_gui_input(event: InputEvent) -> void:
	if event.is_released() :
		pass

func _on_end_turn_button_button_up() -> void:
	EventBusHandler.end_turn_button_pressed.emit()
	end_turn_button.disabled = true

func _on_draw_pile_gui_input(event: InputEvent) -> void:
	if event.is_released() :
		pass

func _on_event_bus_entered_idle() -> void:
	end_turn_button.disabled = false
