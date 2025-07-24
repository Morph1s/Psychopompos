extends Effect
# this is the template to create new effects

# IMPORTANT: make sure to set all variables in the inspector including the texture!
# the effect handler is currently implemented for 8px by 8px textures

# implement all functions relevant for your effect

## this function is called when the entity was attacked
func get_attacked(amount: int) -> void:
	pass

## this function gets called after the unit plays a card containing an attack or resolves an action containing an attack
func played_attack() -> void:
	remove_stacks(stacks)

## this function is called when the amount of stacks changes 
func changed_stacks(previous, current):
	if current == 0:
		effect_owner.modifier_handler.remove_modifier(
			ModifierHandler.ModifiedValue.DAMAGE_DEALT,
			effect_name
		)
		return
	
	effect_owner.modifier_handler.apply_additive_modifier(
		current - previous,
		ModifierHandler.ModifiedValue.DAMAGE_DEALT,
		effect_name
		)

## this function is called at the start of the entities turn 
func start_of_turn():
	pass

## this function is called at the end of the entities turn s
func end_of_turn():
	pass
