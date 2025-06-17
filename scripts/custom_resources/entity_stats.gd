class_name EntityStats
extends Resource

signal hitpoints_changed(new_hp: int, max_hp: int)
signal block_changed(new_block: int)
signal died()


@export var maximum_hitpoints: int = 1:
	set(value):
		maximum_hitpoints = value
		current_hitpoints = clamp(current_hitpoints, 0, maximum_hitpoints) # limit hp if maxhp get reduced
		# call stats changed eventbus
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
		print("changing block")
		var old_block = block
		block = clamp(value, 0, 999)
		if old_block != block:
			print("changed block")
			block_changed.emit(block)

func initialize() -> void:
	current_hitpoints = maximum_hitpoints
	hitpoints_changed.emit(current_hitpoints, maximum_hitpoints)
	block_changed.emit(block)

func create_instance() -> EntityStats:
	var new_entity = self.duplicate()
	new_entity.initialize()
	return new_entity

func take_damage(damage_value: int) -> void:
	if damage_value <= 0:
		return
	
	var actual_damage: int = damage_value - block
	if actual_damage > 0:
		lose_hp(actual_damage)
	else:
		print("damage blocked")
		# play blocked animation
	
	block -= damage_value
	block_changed.emit(block)

func lose_hp(hp_loss) -> void:
	if current_hitpoints <= 0:
		return
	current_hitpoints -= hp_loss
	# play take damage animation
