class_name EnemyEndTurn
extends State

signal enemy_ends_turn

func enter():
	print("Entered EnemyEndTurn")
	# 1. for each enemy: resolve enemy end of turn effects
	enemy_ends_turn.emit()
	# 2. enter state player_start_turn
	await get_tree().create_timer(1.0).timeout
	state_machine.transition_to("PlayerStartTurn")

func exit():
	print("Exited EnemyEndTurn")
