class_name PlayerStartTurn
extends State

signal player_starts_turn


func _ready() -> void:
	EventBusHandler.player_start_of_turn_resolved.connect(_on_event_bus_handler_player_start_of_turn_resolved)

func enter():
	print("Entered PlayerStartTurn")
	# choose enemy intents and resolve player start of turn effects
	player_starts_turn.emit()

func exit():
	print("Exited PlayerStartTurn")

func _on_event_bus_handler_player_start_of_turn_resolved():
	state_machine.transition_to("Idle")
