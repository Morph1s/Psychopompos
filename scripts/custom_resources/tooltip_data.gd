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
	var we_have_string_builders_at_home: String = description_pre_value
	
	if use_value:
		if value == -1:
			we_have_string_builders_at_home = we_have_string_builders_at_home + " " + str(default_value)
		else:
			we_have_string_builders_at_home = we_have_string_builders_at_home + " " + str(value)
	
	if dynamic_plural:
		if value > 1 or value == -1 and default_value > 1:
			we_have_string_builders_at_home = we_have_string_builders_at_home + " " + singular + "s"
		elif not hide_value_when_singular:
			we_have_string_builders_at_home = we_have_string_builders_at_home + " " + singular
		else: 
			we_have_string_builders_at_home = description_pre_value + " " + singular
	
	if not description_after_value.is_empty():
		we_have_string_builders_at_home = we_have_string_builders_at_home + " " + description_after_value
	
	description = we_have_string_builders_at_home
