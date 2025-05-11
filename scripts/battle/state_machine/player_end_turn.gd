class_name PlayerEndTurn
extends State

func enter():
	print("Entered PlayerEndTurn")
	# 1. resolve player end of turn effects
	# 2. discard hand
	# 3. enter state enemy_start_turn
	await get_tree().create_timer(2.0).timeout
	state_machine.transition_to("EnemyStartTurn")

func exit():
	print("Exited PlayerEndTurn")
