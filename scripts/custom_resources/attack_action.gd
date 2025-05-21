class_name AttackAction
extends Action

@export var damage_stat: int = 6

var modified_damage: int:
	set(value):
		pass
	get:
		return modifier_handler.modify_value(damage_stat, ModifierHandler.ModifiedValue.DAMAGE_DEALT)

func resolve(targets: Array[Node2D]) -> void: 
	for target in targets:
		if target.has_method("take_damage"):
			target.take_damage(modified_damage)
		else:
			printerr("Wrong node in node group! Node: " + target.to_string())
