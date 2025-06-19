class_name Tooltip
extends Control

@onready var descriptions_container = $Background/DescriptionsContainer

const MAX_LABEL_WIDTH: int = 100

func load_tooltips(data: Array[TooltipData]) -> void:
	if not is_node_ready():
		await ready
	
	for child in descriptions_container.get_children():
		child.queue_free()
	
	for entry in data:
		var entry_container = HBoxContainer.new()
		descriptions_container.add_child(entry_container)
		
		if entry.icon:
			var icon = TextureRect.new()
			icon.stretch_mode = TextureRect.STRETCH_KEEP
			icon.texture = entry.icon
			entry_container.add_child(icon)
		
		var label = Label.new()
		label.text = entry.description
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		label.custom_minimum_size = theme.default_font.get_multiline_string_size(entry.description, HORIZONTAL_ALIGNMENT_LEFT, MAX_LABEL_WIDTH, 6)
		entry_container.add_child(label)
