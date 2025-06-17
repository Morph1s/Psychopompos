class_name EventBus
extends Node

# if you add an event ONLY relevant for battle encounters, make sure to add it to the clear_all_battle_events function 

signal battle_started
signal battle_ended
signal entered_idle
signal end_turn_button_pressed
signal player_played_attack
signal open_settings
signal show_tooltips(data: Array[TooltipData])
signal hide_tooltips
signal show_deck_view(deck: Array[CardType], fullscreen: bool)


## disposes all connections of all events
func clear_all_battle_events() -> void:
	for function in entered_idle.get_connections():
		entered_idle.disconnect(function["callable"])
	
	for function in end_turn_button_pressed.get_connections():
		end_turn_button_pressed.disconnect(function["callable"])
	
	for function in player_played_attack.get_connections():
		player_played_attack.disconnect(function["callable"])
