class_name PlayerEndTurn
extends State

signal player_ends_turn


func enter():
	print("Entered PlayerEndTurn")
	# resolve player end of turn effects
	player_ends_turn.emit()

func exit():
	print("Exited PlayerEndTurn")
