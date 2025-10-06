class_name EnemyEndTurn
extends State

signal enemy_ends_turn


func enter() -> void:
	# for each enemy: resolve enemy end of turn effects
	enemy_ends_turn.emit()

func exit() -> void:
	pass
