class_name Artifact
extends Resource

@export var name: String
@export var texture: Texture
@export var amount: int
@export var tooltip: Array[TooltipData]

@export_group("Effect at start of combat")
@export var effects_active: bool
@export var effect: EffectAction.EffectType
@export var target_type: TargetedAction.TargetType

@export_group("Effect at start of turn")
@export var start_of_turn_effects_active: bool
@export var start_of_turn_effect: EffectAction.EffectType

@export_group("Effect on pickup")
@export var pickup_active: bool
@export_enum("None", "+Max HP", "+Max Energy", "Card Draw") var pickup_effect: int = 0

@export_group("Encounter Changes")
@export var changes_active: bool
@export_enum("None", "Campfire Heal") var changed_value: int = 0


func pickup() -> void:
	match pickup_effect:
		0: # none
			return
		1: # max hp
			RunData.player_stats.maximum_hitpoints += amount
		2: # max energy
			RunData.player_stats.maximum_energy += amount
		3: # card draw
			RunData.player_stats.card_draw_amount += amount
