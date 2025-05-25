extends Effect
# this is the template to create new effects

# IMPORTANT: make sure to set all variables in the inspector including the texture!
# the effect handler is currently implemented for 8px by 8px textures

# if you are implementing an effect that modifies values like block or damage dealt, implement the change_modifier function
# fo all other effects implement their logic inside the resolve function!

func resolve():
	pass

func change_modifier(amount):
	effect_owner.modifier_handler.apply_additive_modifier(amount, 
	ModifierHandler.ModifiedValue.DAMAGE_DEALT,
	"Strenght"
	)
	print("added ", amount, " strength")
