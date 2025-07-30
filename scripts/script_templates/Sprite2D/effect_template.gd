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

## this function gets called whenever the player draws a card
func card_drawn() -> void:
	pass

## this function gets called whenever the player discards a card
func card_discarded() -> void:
	pass

## this function is called when the amount of stacks changes 
func changed_stacks(previous: int, current: int) -> void:
	pass

## this function is called at the start of the entities turn 
func start_of_turn() -> void:
	pass

## this function is called at the end of the entities turn s
func end_of_turn() -> void:
	pass

## this function is called when an effect is applied
func effect_applied(stacks_added:int, effect_added:Effect) -> void:
	pass
