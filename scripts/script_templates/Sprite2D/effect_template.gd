extends Effect
# this is the template to create new effects

# IMPORTANT: make sure to set all variables in the inspector including the texture!
# the effect handler is currently implemented for 8px by 8px textures

# if you are implementing an effect that modifies values like block or damage dealt, implement the change_modifier function
# for all other effects implement the logic inside the resolve function!

func resolve() -> void:
	pass
	# example code:
	#if "example_fucntion" in effect_owner:
	#	effect_owner.example_function()

func change_modifier(amount: int) -> void:
	pass
	# example code:
	#effect_owner.modifier_handler.apply_additive_modifier(amount, ModifierHandler.ModifiedValue.SOMESTHING, "Name")
