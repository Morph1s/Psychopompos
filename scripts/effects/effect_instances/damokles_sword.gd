extends Effect
# this is the template to create new effects

# IMPORTANT: make sure to set all variables in the inspector including the texture!
# the effect handler is currently implemented for 8px by 8px textures

# implement all functions relevant for your effect

const DAMAGE_PER_STACK: int = 5

## this function is called when the entity was attacked
func get_attacked() -> void:
	add_stacks(1)

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
func changed_stacks(_previous, _current):
	pass

## this function is called at the start of the entities turn 
func start_of_turn():
	if effect_owner.has_method("take_damage"):
		effect_owner.take_damage(stacks * DAMAGE_PER_STACK)
		remove_stacks(stacks)
	else:
		push_warning("something went wrong with damokles_swords damage")

## this function is called at the end of the entities turn s
func end_of_turn():
	pass
