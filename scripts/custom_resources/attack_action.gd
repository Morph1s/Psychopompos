class_name AttackAction
extends TargetedAction

@export var damage_stat: int = 6

var modified_damage: int:
	set(value):
		pass
	get:
		return modifier_handler.modify_value(damage_stat, ModifierHandler.ModifiedValue.DAMAGE_DEALT)


func resolve(targets: Array[Node2D]) -> void: 
	for target: Node2D in targets:
		if target.has_method("get_attacked"):
			target.get_attacked(modified_damage)
		else:
			printerr("Wrong node in node group! Node: " + target.to_string())
