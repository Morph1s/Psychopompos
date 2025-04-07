class_name CardEffect
extends Resource

enum TargetType {SELF_TARGET, SINGLE_TARGET, MULTIPLE_TARGET}

@export var target: TargetType = TargetType.SINGLE_TARGET

func resolve () -> void : 
	pass
