class_name Run
extends Node2D

@onready var ui_layer: CanvasLayer = $UILayer
@onready var run_ui: RunUI = $UILayer/RunUI
@onready var encounter_handler = $EncounterHandler
@onready var map = $UILayer/Map
@onready var map_generator = $MapGenerator

signal load_main_menu

func _ready():
	var map_layers = map_generator.generate_map()
	map.load_layers(map_layers)
	RunData.start_run(RunData.Characters.WARRIOR)
	DeckHandler.start_run_setup()
	run_ui.initialize()
	RunData.player_stats.initialize()
	map.show()

# Uses the EncounterHandler to load the requested encounter
func _on_map_encounter_selected(encounter_data):
	encounter_handler.start_encounter(encounter_data)

#region Signals
func _on_encounter_handler_load_main_menu() -> void:
	load_main_menu.emit()

func _on_encounter_handler_load_rewards() -> void:
	ui_layer.load_battle_rewards()
#endregion
