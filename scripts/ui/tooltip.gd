class_name Tooltip
extends Control

@onready var descriptions_container: VBoxContainer = $Background/DescriptionsContainer

const MAX_LABEL_WIDTH: int = 120

var box_size: Vector2


func load_tooltips(data: Array[TooltipData]) -> void:
	box_size = Vector2(2, 0)
	
	if not is_node_ready():
		await ready
	
	for child: HBoxContainer in descriptions_container.get_children():
		child.queue_free()
	
	for entry: TooltipData in data:
		var entry_container := HBoxContainer.new()
		entry_container.add_theme_constant_override("separation", 2)
		entry_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
		descriptions_container.add_child(entry_container)
		
		if entry.icon:
			var icon := TextureRect.new()
			icon.stretch_mode = TextureRect.STRETCH_KEEP
			icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
			icon.texture = entry.icon
			entry_container.add_child(icon)
		
		var label := Label.new()
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		label.text = entry.description
		var label_size: Vector2 = theme.default_font.get_multiline_string_size(entry.description, HORIZONTAL_ALIGNMENT_LEFT, MAX_LABEL_WIDTH, 6)
		if label_size.y > 6:
			label_size.y += 3 * ((label_size.y / 6) - 1)
		label.custom_minimum_size = label_size
		entry_container.add_child(label)
		
		box_size.y += max(label_size.y, 8)  + 5
		box_size.x = max(box_size.x, label_size.x + 14)
