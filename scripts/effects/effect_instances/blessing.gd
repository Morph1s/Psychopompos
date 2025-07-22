extends Effect
# this is the template to create new effects

# IMPORTANT: make sure to set all variables in the inspector including the texture!
# the effect handler is currently implemented for 8px by 8px textures

# implement all functions relevant for your effect

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
func changed_stacks(previous: int, current: int) -> void:
	pass

## this function is called at the start of the entities turn 
func start_of_turn() -> void:
	var stats: EntityStats = effect_owner.stats
	# for animations or sound this should be moved to a heal method:
	stats.current_hitpoints += 2
	remove_stacks(1)

## this function is called ath the end of the entities turn s
func end_of_turn() -> void:
	pass

## this function is called when an effect is applied
func effect_applied(stacks_added:int, effec_added:Effect) -> void:
	if effec_added.type == EffectType.DEBUFF:
		if randi_range(0,1) == 1:
			effec_added.remove_stacks(stacks_added)
