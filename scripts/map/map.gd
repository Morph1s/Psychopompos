class_name Map
extends Control

signal encounter_selected(encounter_data)
signal close_map

@onready var exit_button = $TopMargin/ExitButton
@onready var hbox = $TopMargin/MapIconsMargin/MapScrollContainer/HBoxContainer
@onready var connection_drawer: MapConnectionDrawer = $TopMargin/MapIconsMargin/MapConnectionDrawer

var encounter_icons: Array[Texture] = [
	preload("res://assets/graphics/map/icon_battle.png"),
	preload("res://assets/graphics/map/icon_shop.png"),
	preload("res://assets/graphics/map/icon_campfire.png"),
	preload("res://assets/graphics/map/icon_random.png"),
]
var encounter_to_button: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect signals to buttons
	exit_button.pressed.connect(_on_exit_button_pressed)

func _process(delta: float) -> void:
	connection_drawer.queue_redraw()


func load_layers(map_layers):
	for child in hbox.get_children():
		child.queue_free()
	
	for layer: MapLayer in map_layers:
		var layer_container = VBoxContainer.new()
		layer_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
		layer_container.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		hbox.add_child(layer_container)
		
		for encounter: Encounter in layer.encounters:
			var button = Button.new()
			button.icon = encounter_icons[encounter.type]
			button.pressed.connect(func(): _on_encounter_pressed(encounter))
			layer_container.add_child(button)
			encounter_to_button[encounter] = button
	
	connection_drawer.set_connections(encounter_to_button)

func _on_encounter_pressed(encounter: Encounter):
	hide()
	encounter_selected.emit(encounter)

# Called when the exit button gets pressed
func _on_exit_button_pressed():
	print("exit button pressed")
	hide()
	close_map.emit()
