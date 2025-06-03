class_name EventBus
extends Node

# to add an event you have to follow these steps:
# 1. add the signal
# 2. add the name to the Event enum 
# 3. add a case in the match statement of the connect_to_event and the call_event functions
# 4. add a for-loop to clear the connections in the clear_all_events function

signal battle_started
signal battle_ended
signal entered_idle
signal player_turn_start
signal player_turn_end
signal enemies_turn_start
signal enemies_turn_end
signal card_played
signal end_turn_button_pressed
signal resolve_player_turn_start_effects
signal resolve_player_turn_end_effects
signal resolve_enemy_turn_start_effects
signal resolve_enemy_turn_end_effects

## all currently available events during combat
enum Event {
	BATTLE_STARTED,
	BATTLE_ENDED,
	ENTERED_IDLE,
	PLAYER_TURN_START,
	PLAYER_TURN_END,
	ENEMIES_TURN_START,
	ENEMIES_TURN_END,
	CARD_PLAY,
	END_TURN_BUTTON,
	PLAYER_TURN_START_EFFECTS,
	PLAYER_TURN_END_EFFECTS,
	ENEMY_TURN_START_EFFECTS,
	ENEMY_TURN_END_EFFECTS,
	}

## triggers the given event and all connected effects
func call_event(event: Event) -> void:
	match event:
		Event.BATTLE_STARTED:
			battle_started.emit()
		Event.BATTLE_ENDED:
			battle_ended.emit()
		Event.ENTERED_IDLE:
			entered_idle.emit()
		Event.PLAYER_TURN_START:
			player_turn_start.emit()
		Event.PLAYER_TURN_END:
			player_turn_end.emit()
		Event.ENEMIES_TURN_START:
			enemies_turn_start.emit()
		Event.ENEMIES_TURN_END:
			enemies_turn_end.emit()
		Event.CARD_PLAY:
			card_played.emit()
		Event.END_TURN_BUTTON:
			end_turn_button_pressed.emit()
		Event.PLAYER_TURN_START_EFFECTS:
			resolve_player_turn_start_effects.emit()
		Event.PLAYER_TURN_END_EFFECTS:
			resolve_player_turn_end_effects.emit()
		Event.ENEMY_TURN_START_EFFECTS:
			resolve_enemy_turn_start_effects.emit()
		Event.ENEMY_TURN_END_EFFECTS:
			resolve_enemy_turn_end_effects.emit()

## adds the given callable-function into the queue for the given event.
func connect_to_event(event: Event, function: Callable) -> void:
	match event:
		Event.BATTLE_STARTED:
			battle_started.connect(function)
		Event.BATTLE_ENDED:
			battle_ended.connect(function)
		Event.ENTERED_IDLE:
			entered_idle.connect(function)
		Event.PLAYER_TURN_START:
			player_turn_start.connect(function)
		Event.PLAYER_TURN_END:
			player_turn_end.connect(function)
		Event.ENEMIES_TURN_START:
			enemies_turn_start.connect(function)
		Event.ENEMIES_TURN_END:
			enemies_turn_end.connect(function)
		Event.CARD_PLAY:
			card_played.connect(function)
		Event.END_TURN_BUTTON:
			end_turn_button_pressed.connect(function)
		Event.PLAYER_TURN_START_EFFECTS:
			resolve_player_turn_start_effects.connect(function)
		Event.PLAYER_TURN_END_EFFECTS:
			resolve_player_turn_end_effects.connect(function)
		Event.ENEMY_TURN_START_EFFECTS:
			resolve_enemy_turn_start_effects.connect(function)
		Event.ENEMY_TURN_END_EFFECTS:
			resolve_enemy_turn_end_effects.connect(function)

## disposes all connections of all events
func clear_all_battle_events() -> void:
	for function in entered_idle.get_connections():
		entered_idle.disconnect(function["callable"])
	
	for function in player_turn_start.get_connections():
		player_turn_start.disconnect(function["callable"])
	
	for function in player_turn_end.get_connections():
		player_turn_end.disconnect(function["callable"])
	
	for function in enemies_turn_start.get_connections():
		enemies_turn_start.disconnect(function["callable"])
	
	for function in enemies_turn_end.get_connections():
		enemies_turn_end.disconnect(function["callable"])
	
	for function in card_played.get_connections():
		card_played.disconnect(function["callable"])
	
	for function in end_turn_button_pressed.get_connections():
		end_turn_button_pressed.disconnect(function["callable"])
	
	for function in resolve_player_turn_start_effects.get_connections():
		resolve_player_turn_start_effects.disconnect(function["callable"])
	
	for function in resolve_player_turn_end_effects.get_connections():
		resolve_player_turn_end_effects.disconnect(function["callable"])
	
	for function in resolve_enemy_turn_start_effects.get_connections():
		resolve_enemy_turn_start_effects.disconnect(function["callable"])
	
	for function in resolve_enemy_turn_end_effects.get_connections():
		resolve_enemy_turn_end_effects.disconnect(function["callable"])
