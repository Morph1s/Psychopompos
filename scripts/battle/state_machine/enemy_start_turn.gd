class_name EnemyStartTurn
extends State

signal enemy_starts_turn


func enter() -> void:
	# resolve enemy start of turn effects
	enemy_starts_turn.emit()

func exit() -> void:
	pass
