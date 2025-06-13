class_name Run
extends Node2D

@onready var encounter_handler = $EncounterHandler
@onready var map = $UILayer/Map
@onready var map_generator = $MapGenerator

func _ready():
	var map_layers = map_generator.generate_map()
	map.load_layers(map_layers)
	DeckHandler.start_run_setup()

# Uses the EncounterHandler to load the requested encounter
func _on_map_encounter_selected(encounter_data):
	encounter_handler.start_encounter(encounter_data)
