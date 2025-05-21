class_name ResolveCard
extends State

signal resolve_card

func enter():
	# 1. resolve card play effects -> signal with card info as parameters
	resolve_card.emit({})
	# 2. discard card
	
	# 3. enter state idle
	await get_tree().create_timer(0.5).timeout
	state_machine.transition_to("Idle")
	pass

func exit():
	pass
