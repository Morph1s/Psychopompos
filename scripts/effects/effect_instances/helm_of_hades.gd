extends Effect
# this is the template to create new effects

# IMPORTANT: make sure to set all variables in the inspector including the texture!
# the effect handler is currently implemented for 8px by 8px textures

# implement all functions relevant for your effect

const HITPOINTS_THRESHOLD: float = 0.2

## this function is called when the entity was attacked
func get_attacked() -> void:
	pass

## this function is called when the entity takes damage that is impacted by block
func take_damage() -> void:
	if effect_owner.stats.current_hitpoints < int(HITPOINTS_THRESHOLD * effect_owner.stats.maximum_hitpoints):
		var effect_handler: EffectHandler = effect_owner.effect_handler
		effect_handler.apply_effect("Invincible", 2)
		remove_stacks()

## this function gets called after the unit plays a card containing an attack or resolves an action containing an attack
func played_attack() -> void:
	pass

## this function is called when the amount of stacks changes 
func changed_stacks(previous: int, current: int) -> void:
	pass

## this function is called at the start of the entities turn 
func start_of_turn() -> void:
	pass

## this function is called ath the end of the entities turn s
func end_of_turn() -> void:
	pass
