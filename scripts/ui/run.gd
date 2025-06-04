class_name Run
extends Node2D

@onready var encounter_handler = $EncounterHandler

func _ready():
	DeckHandler.start_run_setup()

# Uses the EncounterHandler to load the requested encounter
func _on_map_encounter_selected(encounter_data):
	encounter_handler.start_encounter(encounter_data)
