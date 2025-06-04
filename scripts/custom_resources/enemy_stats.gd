class_name EnemyStats
extends EntityStats

# Signals
signal intent_changed(new_intent: Texture)

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

var _current_intent: Texture = null
var current_intent: Texture:
	set(value):
		if _current_intent != value:
			_current_intent = value
			intent_changed.emit(_current_intent)

func initialize() -> void:
	print("enemy initialized")
	super.initialize()
