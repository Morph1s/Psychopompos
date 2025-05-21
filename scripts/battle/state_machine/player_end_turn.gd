class_name PlayerEndTurn
extends State

func enter():
	print("Entered PlayerEndTurn")
	# 1. resolve player end of turn effects
	# 2. discard hand
	# 3. enter state enemy_start_turn
	
	EventBusHandler.call_event(EventBus.Event.PLAYER_TURN_END)
	
	await get_tree().create_timer(1.0).timeout
	state_machine.transition_to("EnemyStartTurn")

func exit():
	print("Exited PlayerEndTurn")
