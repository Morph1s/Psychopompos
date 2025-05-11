class_name EffectAction
extends Action

enum EffectType {STRENGTH, DEXTERITY}

@export var effect_value: int = 2

func resolve(targets: Array[Node2D]) -> void:
	for target in targets:
		if target.has_method("something"):
			# add a function to give entities effects
			pass
		else:
			printerr("Wrong node in node group! Node: " + target.to_string())

func undo(targets: Array[Node2D]) -> void : 
	for target in targets:
		if target.has_method("something"):
			# add a function to make entities lose effects
			pass
		else:
			printerr("Wrong node in node group! Node: " + target.to_string())
