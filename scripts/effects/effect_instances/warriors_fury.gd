extends Effect
# this is the template to create new effects

# IMPORTANT: make sure to set all variables in the inspector including the texture!
# the effect handler is currently implemented for 8px by 8px textures

# implement all functions relevant for your effect

const DAMAGE_DEALT_INCREASE: float = 1.5
const DAMAGE_TAKEN_INCREASE: float = 1.25


## this function is called when the entity was attacked
func get_attacked() -> void:
	pass

## this function is called when the entity takes damage that is impacted by block
func take_damage() -> void:
	pass

## this function gets called after the unit plays a card containing an attack or resolves an action containing an attack
func played_attack() -> void:
	pass

## this function gets called whenever the player draws a card
func card_drawn() -> void:
	pass

## this function gets called whenever the player discards a card
func card_discarded() -> void:
	pass

## this function is called when the amount of stacks changes 
func changed_stacks(previous: int, current: int):
	if previous == 0:
		effect_owner.modifier_handler.apply_multiplicative_modifier(
			DAMAGE_DEALT_INCREASE,
			ModifierHandler.ModifiedValue.DAMAGE_DEALT,
			effect_name
			)
		effect_owner.modifier_handler.apply_multiplicative_modifier(
			DAMAGE_TAKEN_INCREASE,
			ModifierHandler.ModifiedValue.DAMAGE_TAKEN,
			effect_name
			)
	if current == 0:
		effect_owner.modifier_handler.remove_modifier(
			ModifierHandler.ModifiedValue.DAMAGE_DEALT,
			effect_name
			)
		effect_owner.modifier_handler.remove_modifier(
			ModifierHandler.ModifiedValue.DAMAGE_TAKEN,
			effect_name
			)

## this function is called at the start of the entities turn 
func start_of_turn():
	pass

## this function is called ath the end of the entities turn s
func end_of_turn():
	remove_stacks(1)

## this function is called when an effect is applied
func effect_applied(_stacks_added: int, _effect_added: Effect) -> void:
	pass

## this function is called when the unit gains block
func block_gained(_value: int) -> void:
	pass
