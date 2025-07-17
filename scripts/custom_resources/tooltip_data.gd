class_name TooltipData
extends Resource

@export var icon: Texture
@export_multiline var description_pre_value: String
@export var use_value: bool = false
@export var default_value: int = 1
@export var dynamic_plural: bool = false
@export var hide_value_when_singular: bool = false
@export var singular: String
@export_multiline var description_after_value: String

var description: String = ""

func set_description(value: int = -1) -> void:
	# "mom can we have string buiders?
	# "no we have string builders at home!"
	var string_builders_at_home: String = description_pre_value
	
	if use_value:
		if value == -1:
			string_builders_at_home = string_builders_at_home + " " + str(default_value)
		else:
			string_builders_at_home = string_builders_at_home + " " + str(value)
	
	if dynamic_plural:
		if value > 1 or value == -1 and default_value > 1:
			string_builders_at_home = string_builders_at_home + " " + singular + "s"
		elif not hide_value_when_singular:
			string_builders_at_home = string_builders_at_home + " " + singular
		else: 
			string_builders_at_home = description_pre_value + " " + singular
	
	if not description_after_value.is_empty():
		string_builders_at_home = string_builders_at_home + " " + description_after_value
	
	description = string_builders_at_home
