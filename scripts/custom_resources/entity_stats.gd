class_name EntityStats
extends Resource

signal hitpoints_changed(new_hp: int, max_hp: int)
signal block_changed(new_block: int)
signal died()

@export var starting_maximum_hitpoints: int = 1

var maximum_hitpoints: int = 1:
	set(value):
		var maximum_hitpoint_gain: int = value - maximum_hitpoints
		
		maximum_hitpoints = value
		
		if maximum_hitpoint_gain > 0:
			# gain hp
			current_hitpoints += maximum_hitpoint_gain
		else:
			current_hitpoints = clamp(current_hitpoints, 0, maximum_hitpoints) # limit hp if maxhp get reduced
		
		# call hitpoint changed eventbus
		hitpoints_changed.emit(current_hitpoints, maximum_hitpoints)

@export var current_hitpoints: int = 1:
	set(value):
		var old_hp = current_hitpoints
		current_hitpoints = clamp(value, 0, maximum_hitpoints)
		if old_hp != current_hitpoints:
			hitpoints_changed.emit(current_hitpoints, maximum_hitpoints)
			
		if current_hitpoints == 0:
			# signal death
			died.emit()
			print("unit_died")
var block: int = 0:
	set(value):
		var old_block = block
		block = clamp(value, 0, 999)
		if old_block != block:
			block_changed.emit(block)

func initialize() -> void:
	maximum_hitpoints = starting_maximum_hitpoints
	current_hitpoints = maximum_hitpoints

func create_instance() -> EntityStats:
	var new_entity = self.duplicate()
	new_entity.initialize()
	return new_entity

func take_damage(damage_value: int) -> void:
	if damage_value <= 0:
		return
	
	var actual_damage: int = damage_value - block
	block -= damage_value
	
	if actual_damage > 0:
		lose_hp(actual_damage)

func lose_hp(hp_loss) -> void:
	if current_hitpoints <= 0:
		return
	current_hitpoints -= hp_loss
