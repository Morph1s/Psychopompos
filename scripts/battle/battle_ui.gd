class_name BattleUI
extends Control

@onready var end_turn_button: Button = $EndTurnButton

func _ready() -> void:
	EventBusHandler.set_player_control.connect(_on_eventbus_set_player_control)

func _on_discard_pile_gui_input(event: InputEvent) -> void:
	if event.is_action_released("left_click") and not get_tree().get_first_node_in_group("card_piles").discard_pile.is_empty():
		EventBusHandler.show_deck_view.emit(get_tree().get_first_node_in_group("card_piles").discard_pile)

func _on_end_turn_button_button_up() -> void:
	EventBusHandler.end_turn_button_pressed.emit()
	end_turn_button.disabled = true

func _on_draw_pile_gui_input(event: InputEvent) -> void:
	if event.is_action_released("left_click") and not get_tree().get_first_node_in_group("card_piles").draw_pile.is_empty():
		EventBusHandler.show_deck_view.emit(get_tree().get_first_node_in_group("card_piles").draw_pile)

func _on_eventbus_set_player_control(value: bool) -> void:
	end_turn_button.disabled = not value
