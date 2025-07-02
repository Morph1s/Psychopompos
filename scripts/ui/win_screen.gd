extends Control
class_name GameOverScreen

signal back_to_main_menu_pressed

func _on_button_pressed() -> void:
	back_to_main_menu_pressed.emit()
