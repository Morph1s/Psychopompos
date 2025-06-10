class_name PlayerStartTurn
extends State

signal choose_enemy_intents
signal draw_cards
signal reset_energy

func enter():
	print("Entered PlayerStartTurn")

	# 1. choose enemy intents
	choose_enemy_intents.emit()
	# 2. resolve start of turn effects
	await get_tree().create_timer(0.2).timeout
	EventBusHandler.call_event(EventBus.Event.PLAYER_TURN_START_EFFECTS)
	# 3. draw cards
	await get_tree().create_timer(0.2).timeout
	draw_cards.emit()
	# 4. reset energy
	await get_tree().create_timer(0.2).timeout
	reset_energy.emit()
	# 5. enter state idle
	await get_tree().create_timer(1.0).timeout
	state_machine.transition_to("Idle")

func exit():
	print("Exited PlayerStartTurn")
