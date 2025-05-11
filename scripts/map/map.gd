class_name Map
extends Node2D

signal encounter_selected(encounter_data)
signal close_map

@onready var map_layer = $MapLayer
@onready var battle_button = $MapLayer/MapUI/SampleEncounterButtons/BattleButton
@onready var shop_button = $MapLayer/MapUI/SampleEncounterButtons/ShopButton
@onready var campfire_button = $MapLayer/MapUI/SampleEncounterButtons/CampfireButton
@onready var random_button = $MapLayer/MapUI/SampleEncounterButtons/RandomButton
@onready var exit_button = $MapLayer/MapUI/ExitButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect signals to buttons
	battle_button.pressed.connect(_on_battle_button_pressed)
	shop_button.pressed.connect(_on_non_battle_button_pressed)
	campfire_button.pressed.connect(_on_non_battle_button_pressed)
	random_button.pressed.connect(_on_non_battle_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)

# Called when the battle button gets pressed
func _on_battle_button_pressed():
	print("battle button pressed")
	var encounter_data = "battle"
	map_layer.hide()
	encounter_selected.emit(encounter_data)
	
# Placeholder, called when another than the battle button gets pressed
func _on_non_battle_button_pressed():
	print("non battle button pressed")
	map_layer.hide()
	close_map.emit()

# Called when the exit button gets pressed
func _on_exit_button_pressed():
	print("exit button pressed")
	map_layer.hide()
	close_map.emit()
