class_name EnemyStartTurn
extends State

signal enemy_starts_turn

func enter():
	print("Entered EnemyStartTurn")
	# 1. resolve enemy start of turn effects
	enemy_starts_turn.emit()
	# 2. enter state enemy_turn
	await get_tree().create_timer(1.0).timeout
	state_machine.transition_to("EnemyTurn")

func exit():
	print("Exited EnemyStartTurn")
