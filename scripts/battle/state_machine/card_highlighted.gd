class_name CardHighlighted
extends State

func enter():
	print("Entered CardHighlighted")
	battle_ui.end_turn_button_pressed.connect(_on_end_turn_button_pressed)
	# check card type -> set cursor accordingly
	# check for card selected -> change local variable selected_card and re-check card type for cursor type
	# check for card deselected -> enter state idle
	# check for card played -> enter state resolve_card

func exit():
	battle_ui.set_end_turn_button_enabled(false)
	battle_ui.end_turn_button_pressed.disconnect(_on_end_turn_button_pressed)
	print("Exited CardHighlighted")


func _on_end_turn_button_pressed() -> void:
	state_machine.transition_to("PlayerEndTurn")
