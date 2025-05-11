class_name BattleUI
extends Control

@onready var end_turn_button: Button = $EndTurnButton

signal discard_pile_pressed
signal draw_pile_pressed
signal end_turn_button_pressed

func _on_discard_pile_gui_input(event: InputEvent) -> void:
	if event.is_released() :
		discard_pile_pressed.emit()

func _on_end_turn_button_button_up() -> void:
	end_turn_button_pressed.emit()

func _on_draw_pile_gui_input(event: InputEvent) -> void:
	if event.is_released() :
		draw_pile_pressed.emit()

func set_end_turn_button_enabled(enabled: bool) -> void:
	end_turn_button.disabled = not enabled
