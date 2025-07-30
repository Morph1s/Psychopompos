class_name EnemyTurn
extends State

signal resolve_enemy_intents


func enter():
	print("Entered EnemyTurn")
	# resolve enemy intent
	resolve_enemy_intents.emit()

func exit():
	print("Exited EnemyTurn")
