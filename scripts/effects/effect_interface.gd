class_name Effect
extends Sprite2D

signal remove_effect(effect: Effect)

enum Trigger {
	MODIFIER,
	END_OF_ENTITY_TURN,
	START_OF_ENTITY_TURN,
}
enum StackLossMode {
	NONE,
	END_OF_TURN,
	SPECIAL,
}

@onready var counter = $Counter

## unique idenifier for the effect
@export var effect_name: String
## when the effect will trigger
@export var effect_trigger: Trigger
## can the effect have mutiple stacks at the same time?
@export var stackable: bool
## if and when the stacks of this effect will fall of
@export var stack_loss_mode: StackLossMode

var effect_owner: Node2D
var stacks: int = 0:
	set(value):
		# apply modifier
		if effect_trigger == Trigger.MODIFIER:
			change_modifier(value - stacks)
		
		# update value
		stacks = value
		
		# update label
		if 1 < value:
			counter.text = str(value)
		else:
			counter.text = ""

## called to setup the effects functionality
func initialize(owner: Node2D, amount: int) -> void:
	effect_owner = owner
	add_stacks(amount)

## call to add stacks. to remove stacks call remove_stacks() instead!
func add_stacks(amount: int = 1) -> void:
	if stackable:
		stacks += amount
	else:
		stacks = 1

## call to remove stacks
func remove_stacks(amount: int = 1) -> void:
	if stackable:
		stacks -= amount
		if stacks <= 0:
			remove()
	else:
		remove()

## removes the effect completely
func remove() -> void:
	remove_effect.emit(self)

## this function has to be implemented individually for each effect that doesn't modify values 
func resolve() -> void:
	pass

## this function has to be implemented individually for each effect that modifies values 
func change_modifier(amount: int) -> void:
	pass
