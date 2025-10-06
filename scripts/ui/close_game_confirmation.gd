extends CanvasLayer


func ask_for_exit_confirmation() -> void:
	show()

func _on_confirm_button_up() -> void:
	get_tree().quit()

func _on_cancel_button_up() -> void:
	hide()
