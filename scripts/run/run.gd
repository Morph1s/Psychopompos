class_name Run
extends Node2D

signal load_main_menu

@onready var ui_layer: UILayer = $UILayer
@onready var run_ui: RunUI = $UILayer/RunUI
@onready var encounter_handler: EncounterHandler = $EncounterHandler
@onready var map: Map = $UILayer/Map
@onready var map_generator: MapGenerator = $MapGenerator

var map_layers: Array[MapLayer] = []


func _ready() -> void:
	RunData.start_run(RunData.Characters.WARRIOR)
	map_layers = map_generator.generate_map()
	map.load_layers(map_layers)
	DeckHandler.start_run_setup()
	ArtifactHandler.start_of_run_setup()
	run_ui.initialize()
	RunData.player_stats.initialize()
	run_ui.hitpoints.text = "%d/%d" % [RunData.player_stats.current_hitpoints, RunData.player_stats.maximum_hitpoints]
	run_ui.coins.text = str(RunData.player_stats.coins)
	map.show()

#region Signals

func _on_encounter_handler_load_main_menu() -> void:
	load_main_menu.emit()

# Uses the EncounterHandler to load the requested encounter
func _on_map_encounter_selected(encounter_data) -> void:
	encounter_handler.start_encounter(encounter_data)

func _on_encounter_handler_load_rewards(boss_rewards: bool) -> void:
	ui_layer.load_rewards(boss_rewards)

#endregion
