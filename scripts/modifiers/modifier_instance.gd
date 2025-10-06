class_name ModifierInstance
extends Node

const ADDITIVE_MODIFIER: PackedScene = preload("res://scenes/modifiers/additive_modifier.tscn")
const MULTIPLICATIVE_MODIFIER: PackedScene = preload("res://scenes/modifiers/multiplicative_modifier.tscn")

@onready var additive_modifiers: Node = $AdditiveModifiers
@onready var multiplicative_modifiers: Node = $MultiplicativeModifiers


## returns the value with all modifiers applied
func modify_value(value: int) -> int:
	for modifier: ModifierAdditive in additive_modifiers.get_children():
		value += modifier.value
	
	for modifier: ModifierMultiplicative in multiplicative_modifiers.get_children():
		value *= modifier.value
	
	return value

## add a additively stacking modifier
func apply_additive_modifier(amount: int, source: String) -> void:
	for modifier: ModifierAdditive in additive_modifiers.get_children():
		if modifier.source == source:
			modifier.value += amount
			if modifier.value <= 0:
				modifier.queue_free()
			return
	
	var new_modifier: ModifierAdditive = ADDITIVE_MODIFIER.instantiate()
	new_modifier.name = source
	new_modifier.source = source
	new_modifier.value = amount
	additive_modifiers.add_child(new_modifier)

## add a multiplicatively stacking modifier
## (ex: to add 50% extra damage the amount should be 1.5)
func apply_multiplicative_modifier(amount: float, source: String) -> void:
	for modifier: ModifierMultiplicative in multiplicative_modifiers.get_children():
		if modifier.source == source:
			push_warning("attempted to apply multiplicative modifier more than once")
			return
	
	var new_modifier: ModifierMultiplicative = MULTIPLICATIVE_MODIFIER.instantiate()
	new_modifier.name = source
	new_modifier.source = source
	new_modifier.value = amount
	multiplicative_modifiers.add_child(new_modifier)

## remove a modifier from a given source
func remove_modifier(source: String) -> void:
	for modifier: ModifierAdditive in additive_modifiers.get_children():
		if modifier.source == source:
			modifier.queue_free()
			break
	
	for modifier: ModifierMultiplicative in multiplicative_modifiers.get_children():
		if modifier.source == source:
			modifier.queue_free()
			break
