extends CanvasLayer

signal abandon_run_confirmed

func ask_abandon_run_confirmation() -> void:
	show()

func _on_confirm_button_up():
	abandon_run_confirmed.emit()

func _on_cancel_button_up():
	hide()
