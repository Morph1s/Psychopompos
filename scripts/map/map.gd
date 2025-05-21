class_name Map
extends Control

signal encounter_selected(encounter_data)
signal close_map

@onready var battle_button = $SampleEncounterButtons/BattleButton
@onready var shop_button = $SampleEncounterButtons/ShopButton
@onready var campfire_button = $SampleEncounterButtons/CampfireButton
@onready var random_button = $SampleEncounterButtons/RandomButton
@onready var exit_button = $ExitButton

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
	hide()
	encounter_selected.emit(encounter_data)
	
# Placeholder, called when another than the battle button gets pressed
func _on_non_battle_button_pressed():
	print("non battle button pressed")
	hide()
	close_map.emit()

# Called when the exit button gets pressed
func _on_exit_button_pressed():
	print("exit button pressed")
	hide()
	close_map.emit()
