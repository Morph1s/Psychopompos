extends CanvasLayer

signal main_menu_button_pressed

func _input(event) -> void:
	if not event.is_action_pressed("pause"):
		return
	
	if visible:
		hide()
	else:
		show()

func _on_continue_button_up():
	hide()

func _on_main_menu_button_up():
	main_menu_button_pressed.emit()

func _on_exit_button_up():
	get_tree().quit()

func _on_fullscreen_checkbox_toggled(toggled_on):
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN if toggled_on else DisplayServer.WINDOW_MODE_WINDOWED)
