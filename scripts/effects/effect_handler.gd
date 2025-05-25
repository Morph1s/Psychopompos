class_name EffectHandler
extends Node2D

const EFFECT_ICON_DISTACE: int = 2
const EFFECT_ICON_HEIGHT: int = 8

var effect_scenes: Dictionary = {
	"strength": preload("res://scenes/effects/effect_instances/strength.tscn"),
	"poison": preload("res://scenes/effects/effect_instances/poison.tscn"),
}

var parent_node: Node2D

## call this method to setup the nodes functionality
func initialize(owner: Node2D) -> void:
	parent_node = owner
	
	# connect the corresponding events 
	if parent_node is Character:
		EventBusHandler.connect_to_event(EventBus.Event.PLAYER_TURN_START_EFFECTS, _on_unit_turn_start)
		EventBusHandler.connect_to_event(EventBus.Event.PLAYER_TURN_END_EFFECTS, _on_unit_turn_end)
	elif parent_node is Enemy:
		EventBusHandler.connect_to_event(EventBus.Event.ENEMY_TURN_START_EFFECTS, _on_unit_turn_start)
		EventBusHandler.connect_to_event(EventBus.Event.ENEMY_TURN_END_EFFECTS, _on_unit_turn_end)
	else:
		queue_free()

## adds a effect if it doesnt exist yet and adds stacks if it does
func apply_effect(name: String, amount: int) -> void:
	# search for the effect in all children and adds stacks if found
	for effect: Effect in get_children():
		if effect.effect_name == name:
			effect.add_stacks(amount)
			return
	
	# if the child doesn't exist yet but has a correct name it will get created
	if not name in effect_scenes:
		push_error("attempted to add effect that doesn't exist: ", name)
		return
	
	var new_effect: Effect = effect_scenes[name].instantiate()
	new_effect.position = _calculate_icon_position(get_child_count())
	new_effect.remove_effect.connect(_on_effect_remove_effect)
	add_child(new_effect)
	new_effect.initialize(parent_node, amount)

## calculates the relative position of the effect given its index 
func _calculate_icon_position(index: int) -> Vector2:
	var y_pos: int = index * (EFFECT_ICON_DISTACE + EFFECT_ICON_HEIGHT)
	return Vector2(0, y_pos)

## gets called to remove an effect from the handler
func _on_effect_remove_effect(target: Effect) -> void:
	# delete effect
	target.queue_free()
	
	await target.tree_exited
	
	# reorganize the icons of the rest of the effects
	for index in range(get_child_count()):
		get_children()[index].position = _calculate_icon_position(index)


# consider replacing this functionality with function calls in player and enemy handler
# maybe more performant but causes merge conflicts in other code files

func _on_unit_turn_end() -> void:
	for effect: Effect in get_children():
		if effect.effect_trigger == Effect.Trigger.END_OF_ENTITY_TURN:
			effect.resolve()
		if effect.stack_loss_mode == Effect.StackLossMode.END_OF_TURN:
			effect.remove_stacks(1)

func _on_unit_turn_start() -> void:
	for effect: Effect in get_children():
		if effect.effect_trigger == Effect.Trigger.START_OF_ENTITY_TURN:
			effect.resolve()
