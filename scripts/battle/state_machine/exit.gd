class_name Exit
extends State

func enter() -> void:
	EventBusHandler.battle_ended.emit()
	EventBusHandler.clear_all_battle_events()
	RunData.reset_altered_battle_parameters()

func exit() -> void:
	# exit state machine
	pass
