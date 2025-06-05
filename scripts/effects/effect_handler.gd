class_name EffectHandler
extends Node2D

const EFFECT_ICON_DISTANCE: int = 2
const EFFECT_ICON_HEIGHT: int = 8
const MAX_EFFECTS_IN_COLUMN: int = 5
const COLUMN_DISTANCE: int = 15

var effect_scenes: Dictionary = {
	"Vigilant": preload("res://scenes/effects/effect_instances/vigilant.tscn"),
	"Incapacitated": preload("res://scenes/effects/effect_instances/incapacitated.tscn"),
	"Agile": preload("res://scenes/effects/effect_instances/agile.tscn"),
	"Regeneration": preload("res://scenes/effects/effect_instances/regeneration.tscn"),
	"Phalanx": preload("res://scenes/effects/effect_instances/phalanx.tscn"),
	"Wounded": preload("res://scenes/effects/effect_instances/wounded.tscn"),
	"Gather": preload("res://scenes/effects/effect_instances/gather.tscn"),
	"DamoklesSword": preload("res://scenes/effects/effect_instances/damokles_sword.tscn"),
	"WarriorsFury": preload("res://scenes/effects/effect_instances/warriors_fury.tscn"),
}

var parent_node: Node2D

## call this method to setup the nodes functionality
func initialize(parent: Node2D) -> void:
	parent_node = parent
	
	# connect the corresponding events 
	if parent_node is Character:
		EventBusHandler.connect_to_event(EventBus.Event.PLAYER_TURN_START_EFFECTS, _on_unit_turn_start)
		EventBusHandler.connect_to_event(EventBus.Event.PLAYER_TURN_END_EFFECTS, _on_unit_turn_end)
	elif parent_node is Enemy:
		EventBusHandler.connect_to_event(EventBus.Event.ENEMY_TURN_START_EFFECTS, _on_unit_turn_start)
		EventBusHandler.connect_to_event(EventBus.Event.ENEMY_TURN_END_EFFECTS, _on_unit_turn_end)
	else:
		push_error("effect handler added to wrong node type: ", self)
		queue_free()
	
	await get_tree().create_timer(1).timeout
	
	apply_effect("Vigilant", 10)
	apply_effect("Gather", 10)
	apply_effect("DamoklesSword", 10)
	apply_effect("Phalanx", 10)
	apply_effect("Agile", 10)
	apply_effect("WarriorsFury", 10)
	apply_effect("Wounded", 10)

## adds a effect if it doesnt exist yet and adds stacks if it does
func apply_effect(effect_name: String, amount: int) -> void:
	# search for the effect in all children and adds stacks if found
	for effect: Effect in get_children():
		if effect.effect_name == effect_name:
			effect.add_stacks(amount)
			return
	
	# check if the effect exists
	if not effect_name in effect_scenes:
		push_error("attempted to add effect that doesn't exist: ", effect_name)
		return
	
	# if the child doesn't exist yet but has a correct effect_name it will get created
	var new_effect: Effect = effect_scenes[effect_name].instantiate()
	
	if new_effect.player_only and parent_node is Enemy:
		push_warning("attempted to add player only effect to enemy")
		new_effect.queue_free()
		return
	
	new_effect.position = _calculate_icon_position(get_child_count())
	new_effect.remove_effect.connect(_on_effect_remove_effect)
	add_child(new_effect)
	new_effect.initialize(parent_node, amount)

## calculates the relative position of the effect given its index 
func _calculate_icon_position(index: int) -> Vector2:
	var y_pos: int = index % MAX_EFFECTS_IN_COLUMN * (EFFECT_ICON_DISTANCE + EFFECT_ICON_HEIGHT)
	var x_pos: int = index / MAX_EFFECTS_IN_COLUMN * COLUMN_DISTANCE
	return Vector2(x_pos, y_pos)

## gets called to remove an effect from the handler
func _on_effect_remove_effect(target: Effect) -> void:
	# delete effect
	target.queue_free()
	
	await target.tree_exited
	
	# reorganize the icons of the rest of the effects
	for index in range(get_child_count()):
		get_children()[index].position = _calculate_icon_position(index)

func _on_unit_turn_end() -> void:
	for effect: Effect in get_children():
		effect.end_of_turn()

func _on_unit_turn_start() -> void:
	for effect: Effect in get_children():
		effect.start_of_turn()

func _on_unit_get_attacked() -> void:
	for effect: Effect in get_children():
		effect.get_attacked()

func _on_unit_played_attack() -> void:
	for effect: Effect in get_children():
		effect.played_attack()
