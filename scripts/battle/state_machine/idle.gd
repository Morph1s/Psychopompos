class_name Idle
extends State

func enter():
	print("Entered Idle")
	battle_ui.end_turn_button_pressed.connect(_on_end_turn_button_pressed)
	battle_ui.set_end_turn_button_enabled(true)
	# check for card selected -> enter state card_highlighted
	# check for end of turn button pressed -> enter state player_end_turn

func exit():
	battle_ui.set_end_turn_button_enabled(false)
	battle_ui.end_turn_button_pressed.disconnect(_on_end_turn_button_pressed)
	print("Exited Idle")


func _on_end_turn_button_pressed() -> void:
	state_machine.transition_to("PlayerEndTurn")
