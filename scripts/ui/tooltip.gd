class_name Tooltip
extends Control

@onready var descriptions_container = $Background/DescriptionsContainer

const MAX_LABEL_WIDTH: int = 100

var box_size: Vector2

func load_tooltips(data: Array[TooltipData]) -> void:
	box_size = Vector2(2, 0)
	
	if not is_node_ready():
		await ready
	
	for child in descriptions_container.get_children():
		child.queue_free()
	
	for entry in data:
		var entry_container = HBoxContainer.new()
		entry_container.add_theme_constant_override("separation", 2)
		descriptions_container.add_child(entry_container)
		
		if entry.icon:
			var icon = TextureRect.new()
			icon.stretch_mode = TextureRect.STRETCH_KEEP
			icon.texture = entry.icon
			entry_container.add_child(icon)
		
		var label = Label.new()
		label.text = entry.description
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		var label_size := theme.default_font.get_multiline_string_size(entry.description, HORIZONTAL_ALIGNMENT_LEFT, MAX_LABEL_WIDTH, 6)
		if label_size.y > 6:
			label_size.y += 3 * ((label_size.y / 6) - 1)
		label.custom_minimum_size = label_size
		entry_container.add_child(label)
		
		box_size.y += max(label_size.y, 8)  + 2
		box_size.x = max(box_size.x, label_size.x + 14)
