class_name EffectAction
extends TargetedAction

enum EffectType {
	AGILE,
	DAMOKLES_SWORD,
	GATHER,
	INCAPACITATED,
	PHALANX,
	REGENERATION,
	VIGILANT,
	WARRIORS_FURRY,
	WOUNDED,
	BLESSING,
	LISTENING,
}
 
var effect_names: Dictionary = {
	EffectType.AGILE: "Agile",
	EffectType.DAMOKLES_SWORD: "DamoklesSword",
	EffectType.GATHER: "Gather",
	EffectType.INCAPACITATED: "Incapacitated",
	EffectType.PHALANX: "Phalanx",
	EffectType.REGENERATION: "Regeneration",
	EffectType.VIGILANT: "Vigilant",
	EffectType.WARRIORS_FURRY: "WarriorsFury",
	EffectType.WOUNDED: "Wounded",
	EffectType.BLESSING: "Blessing",
	EffectType.LISTENING: "Listening",
}

@export var effect: EffectType
@export var effect_value: int = 1

func resolve(targets: Array[Node2D]) -> void:
	for target in targets:
		target.effect_handler.apply_effect(effect_names[effect], effect_value)

func undo(targets: Array[Node2D]) -> void: 
	for target in targets:
		target.effect_handler.apply_effect(effect_names[effect], -effect_value)
