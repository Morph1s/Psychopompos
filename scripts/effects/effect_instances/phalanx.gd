extends Effect
# this is the template to create new effects

# IMPORTANT: make sure to set all variables in the inspector including the texture!
# the effect handler is currently implemented for 8px by 8px textures

# implement all functions relevant for your effect

const BLOCK_GAIN_INCREACE: float = 1.75

## this function is called when the entity was attacked
func attacked():
	pass

## this function is called when the amount of stacks changes 
func changed_stacks(previous, current):
	if previous == 0:
		effect_owner.modifier_handler.apply_multiplicative_modifier(
			BLOCK_GAIN_INCREACE,
			ModifierHandler.ModifiedValue.BLOCK_GAINED,
			effect_name
			)
	if current == 0:
		effect_owner.modifier_handler.remove_modifier(
			ModifierHandler.ModifiedValue.BLOCK_GAINED,
			effect_name
		)

## this function is called at the start of the entities turn 
func start_of_turn():
	pass

## this function is called ath the end of the entities turn s
func end_of_turn():
	remove_stacks(1)
