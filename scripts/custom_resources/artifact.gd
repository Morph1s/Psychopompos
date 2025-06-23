class_name Artifact
extends Resource


@export var name: String
@export var texture: Texture
@export var amount: int
@export var tooltip: Array[TooltipData]

@export_category("Effect at start of combat")
@export var effects_active: bool
@export var effect: EffectAction.EffectType

@export_category("Effect on pickup")
@export var pickup_active: bool
@export_enum("None", "+Max HP", "+Max Energy", "Card Draw") var pickup_effect: int = 0

@export_category("Encounter Changes")
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
