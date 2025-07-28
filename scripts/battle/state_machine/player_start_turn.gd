class_name PlayerStartTurn
extends State

signal player_starts_turn


func enter():
	print("Entered PlayerStartTurn")
	# choose enemy intents and resolve player start of turn effects
	player_starts_turn.emit()

func exit():
	print("Exited PlayerStartTurn")
