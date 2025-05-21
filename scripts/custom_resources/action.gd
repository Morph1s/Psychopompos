class_name Action
extends Resource

enum TargetType {PLAYER, ENEMY_SINGLE, ENEMY_ALL_INCLUSIVE, ENEMY_ALL_EXCLUSIVE, ENEMY_RANDOM}

@export var target_type: TargetType

var modifier_handler: ModifierHandler

func resolve(targets: Array[Node2D]) -> void : 
	pass
