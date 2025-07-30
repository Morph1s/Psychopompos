class_name Dialogue
extends Node2D

signal player_died

@onready var character: Character = $Character

func initialize():
	character.initialize()
	character.hide_character_hud()

func _on_dialogue_ui_end_dialogue() -> void:
	EventBusHandler.encounter_finished.emit()

func _on_character_player_died() -> void:
	player_died.emit()
