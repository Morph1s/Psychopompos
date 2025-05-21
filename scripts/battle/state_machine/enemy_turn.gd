class_name EnemyTurn
extends State

signal resolve_enemy_intents

func enter():
	print("Entered EnemyTurn")
	# 1. resolve enemy intent
	resolve_enemy_intents.emit()
	# 2. enter state enemy_end_turn
	await get_tree().create_timer(1.0).timeout
	state_machine.transition_to("EnemyEndTurn")

func exit():
	print("Exited EnemyTurn")
