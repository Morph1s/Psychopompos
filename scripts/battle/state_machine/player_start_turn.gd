class_name PlayerStartTurn
extends State

signal choose_enemy_intents
signal draw_cards
signal player_starts_turn

func enter():
	print("Entered PlayerStartTurn")
	# 1. choose enemy intents
	choose_enemy_intents.emit()
	# 2. the player starts its turn
	await get_tree().create_timer(0.2).timeout
	player_starts_turn.emit()
	# 3. draw cards
	await get_tree().create_timer(0.2).timeout
	draw_cards.emit()
	# 4. enter state idle
	await get_tree().create_timer(1.0).timeout
	state_machine.transition_to("Idle")

func exit():
	print("Exited PlayerStartTurn")
