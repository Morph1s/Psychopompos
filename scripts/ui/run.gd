class_name Run
extends Node2D



@onready var ui_layer: CanvasLayer = $UILayer
@onready var encounter_handler = $EncounterHandler

signal load_main_menu()

func _ready():
	DeckHandler.start_run_setup()

# Uses the EncounterHandler to load the requested encounter
func _on_map_encounter_selected(encounter_data):
	encounter_handler.start_encounter(encounter_data)

#region Signals
func _on_encounter_handler_load_main_menu() -> void:
	load_main_menu.emit()

func _on_encounter_handler_load_rewards() -> void:
	ui_layer.load_battle_rewards()
#endregion
