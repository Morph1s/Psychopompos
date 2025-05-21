class_name BattleUI
extends Control

@onready var end_turn_button: Button = $EndTurnButton

func _ready() -> void:
	EventBusHandler.connect_to_event(EventBus.Event.ENTERED_IDLE, _on_event_bus_entered_idle)

func _on_discard_pile_gui_input(event: InputEvent) -> void:
	if event.is_released() :
		pass

func _on_end_turn_button_button_up() -> void:
	EventBusHandler.call_event(EventBus.Event.END_TURN_BUTTON)
	end_turn_button.disabled = true

func _on_draw_pile_gui_input(event: InputEvent) -> void:
	if event.is_released() :
		pass

func _on_event_bus_entered_idle() -> void:
	end_turn_button.disabled = false
