class_name PlayerEndTurn
extends State

signal player_ends_turn


func enter() -> void:
	# resolve player end of turn effects
	player_ends_turn.emit()

func exit() -> void:
	pass
