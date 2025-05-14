class_name CardHighlighted
extends State

func enter():
	print("Entered CardHighlighted")
	
	# check card type -> set cursor accordingly
	# check for card selected -> change local variable selected_card and re-check card type for cursor type
	# check for card deselected -> enter state idle
	# check for card played -> enter state resolve_card

func exit():
	
	print("Exited CardHighlighted")
