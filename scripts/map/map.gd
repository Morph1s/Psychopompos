class_name Map
extends Control

signal encounter_selected(encounter_data)
signal close_map

@onready var exit_button = $TopMargin/ExitButton
@onready var hbox = $TopMargin/MapIconsMargin/MapScrollContainer/HBoxContainer

var encounter_icons: Array[Texture] = [
	preload("res://assets/graphics/map/icon_battle.png"),
	preload("res://assets/graphics/map/icon_shop.png"),
	preload("res://assets/graphics/map/icon_campfire.png"),
	preload("res://assets/graphics/map/icon_random.png"),
]

func load_layers(map_layers):
	for child in hbox.get_children():
		child.queue_free()
	
	for layer: MapLayer in map_layers:
		var layer_container = VBoxContainer.new()
		layer_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
		hbox.add_child(layer_container)
		
		for encounter: Encounter in layer.encounters:
			var button = Button.new()
			button.icon = encounter_icons[encounter.type]
			button.pressed.connect(func(): _on_encounter_pressed(encounter))
			layer_container.add_child(button)

func _on_encounter_pressed(encounter: Encounter):
	hide()
	encounter_selected.emit(encounter)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect signals to buttons
	exit_button.pressed.connect(_on_exit_button_pressed)

## Called when the battle button gets pressed
#func _on_battle_button_pressed():
	#print("battle button pressed")
	#var encounter_data = "battle"
	#hide()
	#encounter_selected.emit(encounter_data)
	#
## Placeholder, called when another than the battle button gets pressed
#func _on_non_battle_button_pressed():
	#print("non battle button pressed")
	#hide()
	#close_map.emit()
#
# Called when the exit button gets pressed
func _on_exit_button_pressed():
	print("exit button pressed")
	hide()
	close_map.emit()
