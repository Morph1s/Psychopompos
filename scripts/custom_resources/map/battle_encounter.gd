class_name BattleEncounter
extends Encounter

@export var enemies: Array[EnemyStats] = []

func _init() -> void:
	type = EncounterType.BATTLE
	icon = load("res://assets/graphics/map/icon_enemy.png")
