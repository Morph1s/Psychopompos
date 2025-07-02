class_name TooltipData
extends Resource

@export var icon: Texture
@export_multiline var description_pre_value: String
@export var use_value: bool = false
@export var default_value: int = 1
@export_multiline var description_after_value: String

var description: String = ""

func set_description(value: int = -1) -> void:
	if use_value:
		if value == -1:
			description = description_pre_value + " " + str(default_value) + " " + description_after_value
		else:
			description = description_pre_value + " " + str(value) + " " + description_after_value
	
	elif description_after_value.is_empty():
		description = description_pre_value
	else:
		description = description_pre_value + " " + description_after_value
