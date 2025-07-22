class_name Effect
extends Sprite2D

signal remove_effect(effect: Effect)

@onready var counter = $Counter
@onready var tooltip = $Tooltip

## unique idenifier for the effect
@export var effect_name: String
## can the effect have mutiple stacks at the same time?
@export var stackable: bool
## set true if the effect can't be added to enemies
@export var player_only: bool = false
@export var tooltip_data: Array[TooltipData]

var effect_owner: Node2D
@export var index: int
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
		
		for tooltip_entry in tooltip_data:
			tooltip_entry.set_description(stacks)
		tooltip.load_tooltips(tooltip_data)

## called to setup the effects functionality
func initialize(entity: Node2D, amount: int) -> void:
	if not is_node_ready():
		await ready
	
	effect_owner = entity
	add_stacks(amount)
	
	for tooltip_entry in tooltip_data:
		tooltip_entry.set_description(stacks)
	
	await tooltip.load_tooltips(tooltip_data)
	
	tooltip.position.x -= max(0, self.global_position.x + tooltip.box_size.x - 316.0)

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

## this function is called when the entity was attacked 
func get_attacked() -> void:
	pass

## this function is called when the entity takes damage that is impacted by block
func take_damage() -> void:
	pass

## this function gets called after the unit plays a card containing an attack or resolves an action containing an attack
func played_attack() -> void:
	pass

## this function is called when the amount of stacks changes 
func changed_stacks(_previous: int, _current: int) -> void:
	pass

## this function is called at the start of the entities turn 
func start_of_turn() -> void:
	pass

## this function is called ath the end of the entities turn s
func end_of_turn() -> void:
	pass


func _on_area_2d_mouse_entered():
	tooltip.show()

func _on_area_2d_mouse_exited():
	tooltip.hide()
