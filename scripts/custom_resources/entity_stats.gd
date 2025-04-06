class_name EntityStats
extends Resource

@export var maximum_hitpoints: int = 1:
	set(value):
		maximum_hitpoints = value
		current_hitpoints = clamp(current_hitpoints, 0, maximum_hitpoints) # limit hp if maxhp get reduced
		# call stats changed eventbus

var current_hitpoints: int = maximum_hitpoints:
	set(value):
		current_hitpoints = clamp(value, 0, maximum_hitpoints)
		if current_hitpoints == 0:
			# signal death
			print("unit_died")
		# call stats changed eventbus
var block: int = 0:
	set(value):
		block = clamp(value, 0, 999)
		# call stats changed eventbus

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

func lose_hp(hp_loss) -> void:
	current_hitpoints -= hp_loss
	# play take damage animation
