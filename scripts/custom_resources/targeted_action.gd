class_name TargetedAction
extends Action

enum TargetType {PLAYER, ENEMY_SINGLE, ENEMY_ALL_INCLUSIVE, ENEMY_ALL_EXCLUSIVE, ENEMY_RANDOM}

@export var target_type: TargetType

var modifier_handler: ModifierHandler

func resolve(_targets: Array[Node2D]) -> void : 
	pass
