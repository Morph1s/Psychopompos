extends Effect
# this is the template to create new effects

# IMPORTANT: make sure to set all variables in the inspector including the texture!
# the effect handler is currently implemented for 8px by 8px textures

# implement all functions relevant for your effect

const HEAL_AMOUNT: float = 0.35

## this function is called when the entity was attacked
func get_attacked() -> void:
	pass

## this function gets called after the unit plays a card containing an attack or resolves an action containing an attack
func played_attack() -> void:
	pass

## this function is called when the amount of stacks changes 
func changed_stacks(_previous, _current):
	pass

## this function is called at the start of the entities turn 
func start_of_turn():
	var stats: EntityStats = effect_owner.stats
	var missing_hp: int = stats.maximum_hitpoints - stats.current_hitpoints
	# for animations or sound this should be moved to a heal method:
	stats.current_hitpoints += int(missing_hp * HEAL_AMOUNT)
	remove_stacks(1)

## this function is called ath the end of the entities turn s
func end_of_turn():
	pass
