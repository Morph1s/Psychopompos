class_name Map
extends Control

signal encounter_selected(encounter_data)
signal close_map

@onready var exit_button = $TopMargin/ExitButton
@onready var hbox = $TopMargin/MapIconsMargin/MapScrollContainer/MapLayerContainer
@onready var connection_drawer: MapConnectionDrawer = $TopMargin/MapIconsMargin/MapConnectionDrawer

var encounter_icons: Array[Texture] = [
	preload("res://assets/graphics/map/icon_battle.png"),
	preload("res://assets/graphics/map/icon_shop.png"),
	preload("res://assets/graphics/map/icon_campfire.png"),
	preload("res://assets/graphics/map/icon_random.png"),
]
var encounter_to_button: Dictionary = {}
var current_encounter: Encounter

func _process(delta: float) -> void:
	# update the connection lines on the map
	connection_drawer.queue_redraw()


func load_layers(map_layers):
	for child in hbox.get_children():
		child.queue_free()
	
	# each layer gets a VBoxContainer for displaying its encounters
	for layer: MapLayer in map_layers:
		var layer_container = VBoxContainer.new()
		layer_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
		layer_container.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		hbox.add_child(layer_container)
		
		for encounter: Encounter in layer.encounters:
			var button = Button.new()
			button.disabled = true
			button.icon = encounter_icons[encounter.type]
			button.pressed.connect(func(): _on_encounter_pressed(encounter))
			layer_container.add_child(button)
			encounter_to_button[encounter] = button
	
	# fill the encounter_to_button Dictionary
	connection_drawer.set_connections(encounter_to_button)
	
	update_layer_states()

func update_layer_states():
	# at the start all the encounters in the start layer should be enabled
	if current_encounter == null:
		for button in hbox.get_child(0).get_children():
			button.disabled = false
		return
	
	# update the state of every encounter button on the map
	for layer_container in hbox.get_children():
		for button in layer_container.get_children():
			var encounter = encounter_to_button.find_key(button)
			button.disabled = not current_encounter.connections_to.has(encounter)
			# change the appearance of already visited or the current encounter
			if encounter == current_encounter:
				button.modulate = Color(0.3, 0.3, 0.4)
				button.disabled = true
			elif encounter.completed:
				button.modulate = Color(0.5, 0.5, 0.5)
				button.disabled = true
			else:
				button.modulate = Color(1, 1, 1)

func _on_encounter_pressed(encounter: Encounter):
	hide()
	encounter_selected.emit(encounter)
	current_encounter = encounter
	encounter.completed = true
	update_layer_states()

func _on_exit_button_pressed():
	hide()
	close_map.emit()
