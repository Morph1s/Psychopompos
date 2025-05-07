class_name AttackAction
extends Action

@export var damage_stat: int = 6;

func resolve(targets: Array[Node2D]) -> void: 
	for target in targets:
		if target.has_method("take_damage"):
			target.take_damage(damage_stat)
		else:
			printerr("Wrong node in node group! Node: " + target.to_string())
