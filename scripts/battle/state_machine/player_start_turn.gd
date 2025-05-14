class_name PlayerStartTurn
extends State

func enter():
	print("Entered PlayerStartTurn")
	await get_tree().create_timer(2.0).timeout
	# 1. choose enemy intent
	# 2. resolve start of turn effects
	# 3. draw cards
	# 4. enter state idle
	state_machine.transition_to("Idle")

func exit():
	print("Exited PlayerStartTurn")
