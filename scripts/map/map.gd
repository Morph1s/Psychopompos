class_name Map
extends Control

signal encounter_selected(encounter_data)

@onready var exit_button: Button = $TopMargin/ExitButton
@onready var map_layer_container = $TopMargin/MapIconsMargin/MapScrollContainer/MapLayerContainer
@onready var connection_drawer: MapConnectionDrawer = $TopMargin/MapIconsMargin/MapConnectionDrawer
@onready var scroll_container: ScrollContainer = $TopMargin/MapIconsMargin/MapScrollContainer
@onready var layer_container: HBoxContainer = $TopMargin/MapIconsMargin/MapScrollContainer/MapLayerContainer

var rng: RandomNumberGenerator = RunData.sub_rngs["rng_map_visual"]
var map: Array[MapLayer] = []
var node_to_button: Dictionary[MapNode, Button] = {}
var current_node: MapNode
var current_layer: int = 0
var can_close: bool = false:
	set(value):
		if value:
			exit_button.show()
		else:
			exit_button.hide()
		can_close = value

func _process(_delta: float) -> void:
	# update the connection lines on the map
	connection_drawer.queue_redraw()


func load_layers(map_layers):
	for child in map_layer_container.get_children():
		child.queue_free()
	
	map = map_layers
	
	# each layer gets a VBoxContainer for displaying its encounters
	for layer: MapLayer in map_layers:
		var layer_container = VBoxContainer.new()
		layer_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
		layer_container.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		map_layer_container.add_child(layer_container)
		
		for node: MapNode in layer.nodes:
			if not node.active:
				continue
			
			var button_container = MarginContainer.new()
			button_container.add_theme_constant_override("margin_left", rng.randi_range(0, 8))
			button_container.add_theme_constant_override("margin_right", rng.randi_range(0, 8))
			
			var button = Button.new()
			button.flat = true
			# starting layer buttons should be enabled by default
			if layer.type != MapLayer.MapLayerType.START:
				button.disabled = true
			
			button.icon = node.encounter.icon
			button.pressed.connect(func(): _on_encounter_pressed(node))
			
			button_container.add_child(button)
			
			var completed_icon: TextureRect = TextureRect.new()
			completed_icon.texture = load("res://assets/graphics/map/icon_encounter_completed.png")
			completed_icon.position = button.get_global_position()
			completed_icon.mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE
			completed_icon.hide()
			
			button_container.add_child(completed_icon)
			layer_container.add_child(button_container)
			node_to_button[node] = button
	
	# fill the node_to_button Dictionary
	connection_drawer.set_connections(node_to_button)

func _scroll_to_current_layer():
	var layer := layer_container.get_child(current_layer + 1)
	var layer_pos = layer.position.x
	var layer_width = layer.size.x
	var scroll_width = scroll_container.size.x
	
	var target_scroll = layer_pos + layer_width / 2 - scroll_width / 2
	target_scroll = clamp(target_scroll, 0, scroll_container.get_h_scroll_bar().max_value)
	
	scroll_container.set_h_scroll(target_scroll)

func lock_layer():
	for button_container: MarginContainer in map_layer_container.get_child(current_layer).get_children():
		var button = button_container.get_child(0)
		var node: MapNode = node_to_button.find_key(button)
		button.disabled = true
		if node == current_node:
			button.modulate = Color(0.3, 0.3, 0.4)

func unlock_next_encounters():
	if current_layer >= map_layer_container.get_child_count() - 1:
		return
	
	for button_container: MarginContainer in map_layer_container.get_child(current_layer + 1).get_children():
		var button: Button = button_container.get_child(0)
		var completed_icon: TextureRect = button_container.get_child(1)
		var node: MapNode = node_to_button.find_key(button)
		button.disabled = not current_node.next_nodes.has(node)
		# change the appearance of already visited or the current encounter
		if node == current_node:
			button.modulate = Color(0.3, 0.3, 0.4)
			button.disabled = true
		elif node.encounter.completed:
			button.modulate = Color(0.5, 0.5, 0.5)
			button.disabled = true
		else:
			button.modulate = Color(1, 1, 1)
	
	# display a cross on top of the encounter button to indicate that it is completed
	var current_node_button_container = map_layer_container.get_child(current_layer).get_child(map[current_layer].nodes.find(current_node))
	current_node_button_container.get_child(1).show()
	
	_scroll_to_current_layer()

func close_map() -> bool:
	if can_close:
		hide()
		return true
	return false

func _on_encounter_pressed(node: MapNode):
	hide()
	can_close = true
	encounter_selected.emit(node.encounter)
	current_node = node
	lock_layer()

func _on_exit_button_pressed():
	close_map()
