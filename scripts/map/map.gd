class_name Map
extends Control

signal encounter_selected(encounter_data)

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
var current_layer = 0
var can_close: bool = false

func _process(_delta: float) -> void:
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
			# starting layer buttons should be enabled by default
			if layer.type != MapLayer.MapLayerType.START:
				button.disabled = true
			button.icon = encounter_icons[encounter.type]
			button.pressed.connect(func(): _on_encounter_pressed(encounter))
			layer_container.add_child(button)
			encounter_to_button[encounter] = button
	
	# fill the encounter_to_button Dictionary
	connection_drawer.set_connections(encounter_to_button)

func lock_layer():
	for button: Button in hbox.get_child(current_layer).get_children():
		var encounter = encounter_to_button.find_key(button)
		button.disabled = true
		if encounter == current_encounter:
			button.modulate = Color(0.3, 0.3, 0.4)

func unlock_next_encounters():
	if current_layer >= hbox.get_child_count() - 1:
		return
	
	for button in hbox.get_child(current_layer + 1).get_children():
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

func close_map() -> bool:
	if can_close:
		hide()
		return true
	return false

func _on_encounter_pressed(encounter: Encounter):
	hide()
	can_close = true
	encounter_selected.emit(encounter)
	current_encounter = encounter
	lock_layer()

func _on_exit_button_pressed():
	close_map()
