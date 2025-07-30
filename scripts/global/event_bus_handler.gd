class_name EventBus
extends Node

# if you add an event ONLY relevant for battle encounters, make sure to add it to the clear_all_battle_events function 

signal battle_started
signal battle_ended
signal end_turn_button_pressed
signal player_played_attack
signal set_player_control(value: bool)
signal open_settings
signal show_deck_view(deck: Array[CardType])
signal show_deck_view_with_action(deck: Array[CardType], on_card_selected_action: Callable, has_button: bool, on_button_pressed_action: Callable, on_exit_pressed_action: Callable)
signal show_map
signal back_to_battle
signal card_drawn
signal cards_drawn
signal card_discarded
signal card_selected(cost: int)
signal card_deselected
signal card_piles_card_count_changed(draw_pile_card_count: int, discard_pile_card_count: int)
signal card_picked_for_deck_add(cards: Array[CardType], positions: Array[Vector2])
signal encounter_finished


## disposes all connections of all events
func clear_all_battle_events() -> void:
	for function in end_turn_button_pressed.get_connections():
		end_turn_button_pressed.disconnect(function["callable"])
	
	for function in player_played_attack.get_connections():
		player_played_attack.disconnect(function["callable"])
	
	for function in set_player_control.get_connections():
		set_player_control.disconnect(function["callable"])
	
	for function in card_piles_card_count_changed.get_connections():
		card_piles_card_count_changed.disconnect(function["callable"])
