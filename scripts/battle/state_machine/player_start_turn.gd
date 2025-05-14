class_name PlayerStartTurn
extends State

func enter():
	print("Entered PlayerStartTurn")

	# 1. choose enemy intent
	# 2. resolve start of turn effects
	# 3. draw cards
	# 4. enter state idle
	
	EventBusHandler.call_event(EventBus.Event.PLAYER_TURN_START)
	
	await get_tree().create_timer(1.0).timeout
	
	state_machine.transition_to("Idle")

func exit():
	print("Exited PlayerStartTurn")
