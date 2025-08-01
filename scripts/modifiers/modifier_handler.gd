class_name ModifierHandler
extends Node

enum ModifiedValue {
	DAMAGE_DEALT,
	DAMAGE_TAKEN,
	BLOCK_GAINED,
}

@onready var damage_dealt: ModifierInstance = $DamageDealt
@onready var damage_taken: ModifierInstance = $DamageTaken
@onready var block_gained: ModifierInstance = $BlockGained


## add a additively stacking modifier
func apply_additive_modifier(amount: int, modified_value: ModifiedValue, source: String) -> void:
	match modified_value:
		ModifiedValue.DAMAGE_DEALT:
			damage_dealt.apply_additive_modifier(amount, source)
		ModifiedValue.DAMAGE_TAKEN:
			damage_taken.apply_additive_modifier(amount, source)
		ModifiedValue.BLOCK_GAINED:
			block_gained.apply_additive_modifier(amount, source)

## add a multiplicatively stacking modifier
## (ex: to add 50% extra damage the amount should be 1.5)
func apply_multiplicative_modifier(amount: float, modified_value: ModifiedValue, source: String) -> void:
	match modified_value:
		ModifiedValue.DAMAGE_DEALT:
			damage_dealt.apply_multiplicative_modifier(amount, source)
		ModifiedValue.DAMAGE_TAKEN:
			damage_taken.apply_multiplicative_modifier(amount, source)
		ModifiedValue.BLOCK_GAINED:
			block_gained.apply_multiplicative_modifier(amount, source)

## remove the given modifier
func remove_modifier(modified_value: ModifiedValue, source: String) -> void:
	match modified_value:
		ModifiedValue.DAMAGE_DEALT:
			damage_dealt.remove_modifier(source)
		ModifiedValue.DAMAGE_TAKEN:
			damage_taken.remove_modifier(source)
		ModifiedValue.BLOCK_GAINED:
			block_gained.remove_modifier(source)

## returns the value with all modifiers of the given type applied
func modify_value(value: int, value_type: ModifiedValue) -> int:
	match value_type:
		ModifiedValue.DAMAGE_DEALT:
			value = damage_dealt.modify_value(value)
		ModifiedValue.DAMAGE_TAKEN:
			value = damage_taken.modify_value(value)
		ModifiedValue.BLOCK_GAINED:
			value = block_gained.modify_value(value)
	return value
