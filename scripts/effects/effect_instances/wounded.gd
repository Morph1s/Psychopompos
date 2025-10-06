extends Effect
# this is the template to create new effects

# IMPORTANT: make sure to set all variables in the inspector including the texture!
# the effect handler is currently implemented for 8px by 8px textures

# implement all functions relevant for your effect

## this function is called when the entity was attacked
func get_attacked():
	pass

## this function is called when the entity takes damage that is impacted by block
func take_damage() -> void:
	# don't apply if effect_owner is invincible
	var active_effects: Array[Node] = effect_owner.effect_handler.effect_collection.get_children()
	for effect: Effect in active_effects:
		if effect.effect_name == "Invincible":
			return
	
	if effect_owner.has_method("lose_hp"):
		effect_owner.lose_hp(stacks)

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
func changed_stacks(_previous: int, _current: int):
	pass

## this function is called at the start of the entities turn 
func start_of_turn():
	pass

## this function is called at the end of the entities turn s
func end_of_turn():
	pass
