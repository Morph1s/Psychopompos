class_name EnemyStartTurn
extends State

func enter():
	print("Entered EnemyStartTurn")
	# 1. resolve enemy start of turn effects
	EventBusHandler.call_event(EventBus.Event.ENEMY_TURN_START_EFFECTS)
	# 2. enter state enemy_turn
	await get_tree().create_timer(1.0).timeout
	state_machine.transition_to("EnemyTurn")

func exit():
	print("Exited EnemyStartTurn")
