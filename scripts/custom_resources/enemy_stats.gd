class_name EnemyStats
extends EntityStats

enum ActionPattern {
	RANDOM,
	LINEAR,
}

@export var enemy_sprite: Texture
@export var action_pattern: ActionPattern = ActionPattern.RANDOM
@export var actions: Array[EnemyAction] 

## adds a reference to the modifier handler of the enemy to all actions
func set_modifier_handler(modifier_handler: ModifierHandler) -> void:
	for action in actions:
		for action_instance in action.action_catalogue:
			action_instance.modifier_handler = modifier_handler

func initialize() -> void:
	super.initialize()
	
	# creating a true deep copy of the resource because .duplacate(true) doesn't deep copy arrays
	actions = actions.duplicate(true)
	
	for i in actions.size():
		actions[i] = actions[i].duplicate(true)
		
		for index in actions[i].action_catalogue.size():
			actions[i].action_catalogue[index] = actions[i].action_catalogue[index].duplicate(true)
