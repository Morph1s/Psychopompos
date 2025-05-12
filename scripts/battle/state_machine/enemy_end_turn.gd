class_name EnemyEndTurn
extends State

func enter():
	print("Entered EnemyEndTurn")
	# 1. for each enemy: resolve enemy end of turn effects
	# 2. enter state player_start_turn
	await get_tree().create_timer(2.0).timeout
	state_machine.transition_to("PlayerStartTurn")

func exit():
	print("Exited EnemyEndTurn")
