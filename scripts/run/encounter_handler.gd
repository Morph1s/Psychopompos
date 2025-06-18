class_name EncounterHandler
extends Node2D

const GAME_OVER_SCREEN: PackedScene = preload("res://scenes/ui/game_over_screen.tscn")

signal load_main_menu()
signal load_rewards()

var current_encounter: Node = null

# Loads a requested encounter into the Run scene
func start_encounter(encounter_data: Encounter):
	# Remove current encounter if exists
	if current_encounter:
		current_encounter.queue_free()
		current_encounter = null
		# a wonderful fix for a race condition
		await get_tree().create_timer(0.1).timeout
	
	# Load requested encounter if implemented
	match encounter_data.type:
		Encounter.EncounterType.BATTLE:
			var battle_scene = preload("res://scenes/encounters/battle.tscn").instantiate()
			battle_scene.load_game_over_screen.connect(_load_game_over_screen)
			battle_scene.load_battle_rewards.connect(_load_reward_screen)
			add_child(battle_scene)
			battle_scene.initialize(encounter_data)
			current_encounter = battle_scene
		_:
			print("Encounter type not implemented: ", encounter_data)

func _load_game_over_screen():
	current_encounter.queue_free()
	var game_over_screen: GameOverScreen = GAME_OVER_SCREEN.instantiate() 
	self.add_child(game_over_screen)
	game_over_screen.back_to_main_menu_pressed.connect(_on_back_to_main_menu_pressed)

func _load_reward_screen():
	current_encounter.queue_free()
	load_rewards.emit()

func _on_back_to_main_menu_pressed():
	load_main_menu.emit()
