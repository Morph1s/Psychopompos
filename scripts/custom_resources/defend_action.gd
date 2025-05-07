class_name DefendAction
extends Action

@export var block_stat: int = 5

func resolve(targets: Array[Node2D]) -> void : 
	for target in targets:
		if target.has_method("gain_block"):
			target.gain_block(block_stat)
		else:
			printerr("Wrong node in node group! Node: " + target.to_string())
