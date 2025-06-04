class_name Effect
extends Sprite2D

signal remove_effect(effect: Effect)

@onready var counter = $Counter

## unique idenifier for the effect
@export var effect_name: String
## can the effect have mutiple stacks at the same time?
@export var stackable: bool
## set true if the effect can't be added to enemies
@export var player_only: bool = false

var effect_owner: Node2D
var stacks: int = 0:
	set(value):
		# call the logic on changing stats
		changed_stacks(stacks, value)
		
		# update value
		stacks = value
		
		# update label
		if 1 < value:
			counter.text = str(value)
		else:
			counter.text = ""

## called to setup the effects functionality
func initialize(entity: Node2D, amount: int) -> void:
	effect_owner = entity
	add_stacks(amount)

## removes the effect completely
func remove() -> void:
	remove_effect.emit(self)

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

## this function has to be implemented individually for each effect that doesn't modify values 
func attacked() -> void:
	pass

## this function has to be implemented individually for each effect that modifies values 
func changed_stacks(_previous: int, _current: int) -> void:
	pass

func start_of_turn() -> void:
	pass

func end_of_turn() -> void:
	pass
