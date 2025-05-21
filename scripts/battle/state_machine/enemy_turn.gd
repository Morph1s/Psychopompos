class_name EnemyTurn
extends State

func enter():
	print("Entered EnemyTurn")
	# 1. for each enemy: resolve enemy intent ('act')
	# 2. enter state enemy_end_turn
	await get_tree().create_timer(1.0).timeout
	state_machine.transition_to("EnemyEndTurn")

func exit():
	print("Exited EnemyTurn")
