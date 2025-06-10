class_name PauseMenu
extends CanvasLayer

signal main_menu_button_pressed
signal exit_button_pressed

enum OpenFrom {
	MAIN_MENU,
	RUN,
}

@onready var buttons_for_run = $PauseMenu/Panel/VerticalSeparation/HorizontalSeparation/ButtonsForRun
@onready var buttons_for_main_menu = $PauseMenu/Panel/VerticalSeparation/HorizontalSeparation/ButtonsForMainMenu
@onready var header = $PauseMenu/Panel/VerticalSeparation/Header

func open(mode: OpenFrom) -> void:
	match mode:
		OpenFrom.MAIN_MENU:
			header.text = "OPTIONS"
			buttons_for_main_menu.show()
			buttons_for_run.hide()
		OpenFrom.RUN:
			header.text = "PAUSED"
			buttons_for_main_menu.hide()
			buttons_for_run.show()
	show()

func close() -> void:
	hide()

#region signal functions
func _on_main_menu_button_up():
	main_menu_button_pressed.emit()
	hide()

func _on_exit_button_up():
	exit_button_pressed.emit()

func _on_fullscreen_checkbox_toggled(toggled_on):
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN if toggled_on else DisplayServer.WINDOW_MODE_WINDOWED)

func _on_return_button_up():
	close()
#endregion
