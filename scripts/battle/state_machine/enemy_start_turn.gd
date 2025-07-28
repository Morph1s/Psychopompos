class_name EnemyStartTurn
extends State

signal enemy_starts_turn


func enter():
	print("Entered EnemyStartTurn")
	# resolve enemy start of turn effects
	enemy_starts_turn.emit()

func exit():
	print("Exited EnemyStartTurn")
