class_name EffectHandler
extends Node2D

const EFFECT_ICON_DISTANCE: int = 1
const EFFECT_ICON_HEIGHT: int = 10

@onready var effect_collection = $EffectCollection
@onready var buttons = $Buttons

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
	"Blessing": preload("res://scenes/effects/effect_instances/blessing.tscn"),
	"Artemis": preload("res://scenes/effects/effect_instances/artemis.tscn"),
	"HelmOfHades": preload("res://scenes/effects/effect_instances/helm_of_hades.tscn"),
	"Invincible": preload("res://scenes/effects/effect_instances/invincible.tscn"),
	"Listening": preload("res://scenes/effects/effect_instances/listening.tscn"),
  "NemeanHide": preload("res://scenes/effects/effect_instances/nemean_hide.tscn"),
}

var parent_node: Node2D
var max_effects_per_column: int
@export var visible_range: Vector2i 

## call this method to setup the nodes functionality
func initialize(parent: Node2D) -> void:
	parent_node = parent
	
	max_effects_per_column = int(parent.size.y / (EFFECT_ICON_DISTANCE + EFFECT_ICON_HEIGHT))
	visible_range = Vector2i(0, max_effects_per_column - 1)
	
	buttons.set_bottom_button_position(max_effects_per_column * EFFECT_ICON_HEIGHT + (max_effects_per_column - 1) * EFFECT_ICON_DISTANCE)
	
	EventBusHandler.card_drawn.connect(_on_player_card_drawn)
	EventBusHandler.card_discarded.connect(_on_player_card_discarded)


#region effect adding

## adds a effect if it doesnt exist yet and adds stacks if it does
func apply_effect(effect_name: String, amount: int) -> void:
	
	# search for the effect in all columns and adds stacks if found
	for effect: Effect in effect_collection.get_children():
		if effect.effect_name == effect_name:
			if amount > 0:
				effect.add_stacks(amount)
			elif amount < 0:
				effect.remove_stacks(-amount)
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
	
	new_effect.index = effect_collection.get_child_count()
	new_effect.position = _calculate_icon_position(new_effect.index)
	effect_collection.add_child(new_effect)
	new_effect.remove_effect.connect(_on_effect_remove_effect)
	new_effect.initialize(parent_node, amount)
	
	_on_effect_applied(amount, new_effect)
	
	_change_visibility()

#endregion

#region effect ordering

## calculates the relative position of the effect given its index 
func _calculate_icon_position(index: int) -> Vector2:
	var y_pos: int = index % max_effects_per_column * (EFFECT_ICON_DISTANCE + EFFECT_ICON_HEIGHT)
	return Vector2(0, y_pos)

#endregion

#region manage visibility

func _change_visibility() -> void:
	for effect: Effect in effect_collection.get_children():
		if effect.index in range(visible_range.x, visible_range.y + 1):
			effect.show()
		else:
			effect.hide()
	
	buttons.set_decrement_button_visibility(visible_range.x != 0)
	buttons.set_increment_button_visibility(visible_range.y < effect_collection.get_child_count() - 1)

func _increment_visible_range() -> void:
	if effect_collection.get_child_count() < visible_range.y:
		return
	
	visible_range += Vector2i(max_effects_per_column, max_effects_per_column)

func _decrement_visible_range() -> void:
	if visible_range.x == 0:
		return
	
	visible_range -= Vector2i(max_effects_per_column, max_effects_per_column)


func _on_buttons_decrement_pressed():
	_decrement_visible_range()
	_change_visibility()


func _on_buttons_increment_pressed():
	_increment_visible_range()
	_change_visibility()

#endregion

#region removing effects

## gets called to remove an effect from the handler
func _on_effect_remove_effect(target: Effect) -> void:
	# delete effect
	target.queue_free()
	
	await target.tree_exited
	
	# reorganize the icons of the rest of the effects
	var index: int = 0
	for effect: Effect in effect_collection.get_children():
		effect.index = index
		effect.position = _calculate_icon_position(index)
		index += 1
	
	if effect_collection.get_child_count() == visible_range.x:
		_decrement_visible_range()
	
	_change_visibility()

#endregion

#region effect triggers

func _on_unit_turn_end() -> void:
	for effect: Effect in effect_collection.get_children():
		effect.end_of_turn()
		await get_tree().create_timer(0.1).timeout

func _on_unit_turn_start() -> void:
	for effect: Effect in effect_collection.get_children():
		effect.start_of_turn()
		await get_tree().create_timer(0.1).timeout

func _on_unit_get_attacked() -> void:
	for effect: Effect in effect_collection.get_children():
		effect.get_attacked()

func _on_unit_take_damage() -> void:
	for effect: Effect in effect_collection.get_children():
		effect.take_damage()

func _on_unit_played_attack() -> void:
	for effect: Effect in effect_collection.get_children():
		effect.played_attack()

func _on_player_card_drawn() -> void:
	for effect: Effect in effect_collection.get_children():
		effect.card_drawn()

func _on_player_card_discarded() -> void:
	for effect: Effect in effect_collection.get_children():
		effect.card_discarded()

func _on_effect_applied(stack_count:int, applied_effect:Effect) -> void:
	for effect: Effect in effect_collection.get_children():
		effect.effect_applied(stack_count,applied_effect)

func _on_unit_block_gained(value: int) -> void:
	for effect: Effect in effect_collection.get_children():
		effect.block_gained(value)

#endregion
