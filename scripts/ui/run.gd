class_name Run
extends Node2D

@onready var map = $Map
@onready var encounter_handler = $EncounterHandler
@onready var open_map_button = $UILayer/RunUI/OpenMapButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	open_map_button.pressed.connect(_on_open_map_button_pressed)
	map.encounter_selected.connect(_on_encounter_selected)

# Called when the OpenMapButton gets pressed, shows the map
func _on_open_map_button_pressed():
	map.map_layer.show()

# Uses the EncounterHandler to load the requested encounter
func _on_encounter_selected(encounter_data):
	encounter_handler.start_encounter(encounter_data)
