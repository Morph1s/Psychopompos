class_name PlayerEndTurn
extends State

signal player_ends_turn


func _ready() -> void:
	EventBusHandler.player_end_of_turn_resolved.connect(_on_event_bus_player_end_of_turn_resolved)

func enter():
	print("Entered PlayerEndTurn")
	# resolve player end of turn effects
	player_ends_turn.emit()

func exit():
	print("Exited PlayerEndTurn")

func _on_event_bus_player_end_of_turn_resolved():
	state_machine.transition_to("EnemyStartTurn")
