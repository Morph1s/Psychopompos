extends Effect
# this is the template to create new effects

# IMPORTANT: make sure to set all variables in the inspector including the texture!
# the effect handler is currently implemented for 8px by 8px textures

# implement all functions relevant for your effect

## this function is called when the entity was attacked
func get_attacked():
	pass

## this function is called when the entity takes damage that is impacted by block
func take_damage():
	pass

## this function gets called after the unit plays a card containing an attack or resolves an action containing an attack
func played_attack():
	pass

## this function is called when the amount of stacks changes 
func changed_stacks(previous, current):
	pass

## this function is called at the start of the entities turn 
func start_of_turn():
	pass

## this function is called at the end of the entities turn s
func end_of_turn():
	remove_stacks(1)

## this function is called when an effect is applied
func effect_applied(stacks_added:int, effect_added:Effect):
	pass

func player_pre_attack_action(all_enemies: bool) -> void:
	if not all_enemies:
		effect_owner.gain_block(2)
	else:
		effect_owner.gain_block(2 * get_tree().get_node_count_in_group("enemy"))
