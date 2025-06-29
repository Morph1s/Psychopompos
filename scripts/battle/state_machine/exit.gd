class_name Exit
extends State

func enter():
	EventBusHandler.battle_ended.emit()
	EventBusHandler.clear_all_battle_events()
	RunData.reset_altered_battle_parameters()

func exit():
	# exit state machine
	pass
