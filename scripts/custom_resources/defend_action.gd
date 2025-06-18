class_name DefendAction
extends TargetedAction

@export var block_stat: int = 5

var modified_block: int:
	set(value):
		pass
	get:
		return modifier_handler.modify_value(block_stat, ModifierHandler.ModifiedValue.BLOCK_GAINED)

func resolve(targets: Array[Node2D]) -> void : 
	for target in targets:
		if target.has_method("gain_block"):
			target.gain_block(modified_block)
		else:
			printerr("Wrong node in node group! Node: " + target.to_string())
