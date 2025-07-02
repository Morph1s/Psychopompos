class_name Dialogue
extends Node2D

signal ended
signal player_died

@onready var character: Character = $Character



func initilaze():
	character.initialize()
	

func _on_dialogue_ui_end_dialogue() -> void:
	ended.emit() # Replace with function body.


func _on_character_player_died() -> void:
	player_died.emit()
