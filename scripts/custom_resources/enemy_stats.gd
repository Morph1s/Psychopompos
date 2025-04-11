class_name EnemyStats
extends EntityStats

enum ActionPattern {
	RANDOM,
	LINEAR,
}

@export var enemy_sprite: Texture
@export var action_pattern: ActionPattern = ActionPattern.RANDOM
@export var actions: Array[EnemyAction]
