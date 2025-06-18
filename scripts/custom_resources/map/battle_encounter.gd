class_name BattleEncounter
extends Encounter

@export var enemies: Array[EnemyStats] = []
@export var difficulty: int = 0

func _init() -> void:
	type = EncounterType.BATTLE
	icon = preload("res://assets/graphics/map/icon_battle.png")
