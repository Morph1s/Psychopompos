class_name EventBus
extends Node

# to add an event you have to follow these steps:
# 1. add the signal
# 2. add the name to the Event enum 
# 3. add a case in the match statement of the connect_to_event and the call_event functions
# 4. add a for-loop to clear the connections in the clear_all_events function

signal player_turn_start
signal player_turn_end
signal enemies_turn_start
signal enemies_turn_end
signal card_played

## all currently available events during combat
enum Event {
	PLAYER_TURN_START,
	PLAYER_TURN_END,
	ENEMIES_TURN_START,
	ENEMIES_TURN_END,
	CARD_PLAY,
	}

## triggers the given event and all connected effects
func call_event(event: Event) -> void:
	match event:
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

## adds the given callable-function into the queue for the given event.
func connect_to_event(event: Event, function: Callable) -> void:
	match event:
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

## disposes all connections of all events
func clear_all_events() -> void:
	for function in player_turn_start.get_connections():
		player_turn_start.disconnect(function)
	
	for function in player_turn_end.get_connections():
		player_turn_end.disconnect(function)
	
	for function in enemies_turn_end.get_connections():
		enemies_turn_end.disconnect(function)
	
	for function in enemies_turn_start.get_connections():
		enemies_turn_start.disconnect(function)
	
	for function in card_played.get_connections():
		card_played.disconnect(function)
