class_name Exit
extends State

func enter():
	# 1. check if win == true:
	# true: show loot screen -> 2.1.
	# false: show end/defeat screen -> 2.2.
	# 2.1. wait for exit button pressed -> exit() with win parameters
	# 2.2. wait for exit button pressed -> exit() with defeat parameters
	pass

func exit():
	# exit state machine
	# either open map (win) or return to main menu (defeat)
	pass
