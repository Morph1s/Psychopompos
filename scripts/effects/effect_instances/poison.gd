extends Effect
# this is the template to create new effects

# IMPORTANT: make sure to set all variables in the inspector including the texture!
# the effect handler is currently implemented for 8px by 8px textures

# if you are implementing an effect that modifies values like block or damage dealt, implement the change_modifier function
# fo all other effects implement their logic inside the resolve function!

func resolve():
	if "lose_hp" in effect_owner:
		effect_owner.lose_hp(stacks)

func change_modifier(amount):
	pass
