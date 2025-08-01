class_name PlayerStartTurn
extends State

signal player_starts_turn


func enter() -> void:
	# choose enemy intents and resolve player start of turn effects
	player_starts_turn.emit()

func exit() -> void:
	pass
