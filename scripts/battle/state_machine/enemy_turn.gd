class_name EnemyTurn
extends State

signal resolve_enemy_intents


func enter() -> void:
	# resolve enemy intent
	resolve_enemy_intents.emit()

func exit() -> void:
	pass
