class_name EncounterHandler
extends Node2D

signal load_main_menu
signal load_rewards(boss_rewards: bool)

@onready var run: Run = $".."
@onready var map: Map = $"../UILayer/Map"

const GAME_OVER_SCREEN: PackedScene = preload("res://scenes/ui/game_over_screen.tscn")
const WIN_SCREEN = preload("res://scenes/ui/win_screen.tscn")

const BATTLE_STAGE_0: BattleEncounter = preload("res://resources/encounters/battle_stage_0.tres")
const BATTLES_STAGE_1: Array[BattleEncounter] = [
	preload("res://resources/encounters/battle_stage_1_1.tres"),
	preload("res://resources/encounters/battle_stage_1_2.tres"),
	preload("res://resources/encounters/battle_stage_1_3.tres"),
]
const BATTLES_STAGE_2: Array[BattleEncounter] = [
	preload("res://resources/encounters/battle_stage_2_1.tres"),
	preload("res://resources/encounters/battle_stage_2_2.tres"),
	preload("res://resources/encounters/battle_stage_2_3.tres"),
]

var current_encounter: Node = null
var previous_battle: BattleEncounter
var is_stage_2: bool = false

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
			_load_battle_encounter()
		Encounter.EncounterType.CAMPFIRE:
			_load_campfire_encounter()
		Encounter.EncounterType.MINI_BOSS:
			_load_mini_boss_encounter()
		Encounter.EncounterType.BOSS:
			_load_boss_encounter()
		Encounter.EncounterType.SHOP:
			_load_shop_encounter()
		Encounter.EncounterType.RANDOM:
			_load_random_encounter()
		_:
			print("Encounter type not implemented: ", Encounter.EncounterType.find_key(encounter_data.type))

func _load_win_screen():
	current_encounter.queue_free()
	var win_screen: GameOverScreen  = WIN_SCREEN.instantiate()
	self.add_child(win_screen)
	win_screen.back_to_main_menu_pressed.connect(_on_back_to_main_menu_pressed)

func _load_game_over_screen():
	current_encounter.queue_free()
	var game_over_screen: GameOverScreen = GAME_OVER_SCREEN.instantiate() 
	self.add_child(game_over_screen)
	game_over_screen.back_to_main_menu_pressed.connect(_on_back_to_main_menu_pressed)

func _load_reward_screen(boss_rewards: bool):
	current_encounter.queue_free()
	load_rewards.emit(boss_rewards)

func _end_encounter():
	current_encounter.queue_free()
	EventBusHandler.dialogue_finished.emit()

func _end_shop():
	current_encounter.queue_free()

func _on_back_to_main_menu_pressed():
	load_main_menu.emit()

func _load_battle_encounter():
	var current_map_layer_type: MapLayer.MapLayerType = run.map_layers[map.current_layer].type
	
	var battle_scene = load("res://scenes/encounters/battle.tscn").instantiate()
	battle_scene.load_game_over_screen.connect(_load_game_over_screen)
	battle_scene.load_battle_rewards.connect(_load_reward_screen)
	add_child(battle_scene)
	
	# starting layer encounter
	if current_map_layer_type == MapLayer.MapLayerType.START:
		battle_scene.initialize(BATTLE_STAGE_0)
	elif not is_stage_2:
		var available_battles: Array[BattleEncounter] = []
		for battle: BattleEncounter in BATTLES_STAGE_1:
			if not battle == previous_battle:
				available_battles.append(battle)
		var battle_to_load: BattleEncounter = available_battles[randi_range(0, available_battles.size() - 1)]
		battle_scene.initialize(battle_to_load)
		previous_battle = battle_to_load
	else:
		var available_battles: Array[BattleEncounter] = []
		for battle: BattleEncounter in BATTLES_STAGE_2:
			if not battle == previous_battle:
				available_battles.append(battle)
		var battle_to_load: BattleEncounter = available_battles[randi_range(0, available_battles.size() - 1)]
		battle_scene.initialize(battle_to_load)
		previous_battle = battle_to_load
	current_encounter = battle_scene

func _load_campfire_encounter():
	var campfire_scene = load("res://scenes/encounters/campfire.tscn").instantiate()
	add_child(campfire_scene)
	current_encounter = campfire_scene

func _load_mini_boss_encounter():
	var mini_boss_battle_scene = load("res://scenes/encounters/battle.tscn").instantiate()
	mini_boss_battle_scene.load_game_over_screen.connect(_load_game_over_screen)
	mini_boss_battle_scene.load_battle_rewards.connect(_load_reward_screen)
	add_child(mini_boss_battle_scene)
	mini_boss_battle_scene.initialize(load("res://resources/encounters/mini_boss_battle_minotaur.tres"))
	current_encounter = mini_boss_battle_scene
	is_stage_2 = true

func _load_boss_encounter():
	var boss_battle_scene: Battle = load("res://scenes/encounters/battle.tscn").instantiate()
	boss_battle_scene.load_game_over_screen.connect(_load_game_over_screen)
	boss_battle_scene.load_battle_rewards.connect(_load_reward_screen)
	boss_battle_scene.load_win_screen.connect(_load_win_screen)
	add_child(boss_battle_scene)
	boss_battle_scene.initialize(load("res://resources/encounters/boss_battle_medusa.tres"))
	current_encounter = boss_battle_scene

func _load_dialogue_encounter():
	# TODO: change to dialogue encounter loading once implemented
	_load_battle_encounter()

func _load_shop_encounter():
	var shop_scene = load("res://scenes/encounters/shop.tscn").instantiate()
	shop_scene.shop_finished.connect(_end_shop)
	add_child(shop_scene)
	shop_scene.initialize()
	current_encounter = shop_scene

func _load_random_encounter():
	# weights are shown in percentage values (must add up to 100)
	var possible_encounters: Dictionary[Encounter.EncounterType, int] = {
		Encounter.EncounterType.BATTLE: 20,
		Encounter.EncounterType.CAMPFIRE: 15,
		Encounter.EncounterType.DIALOGUE: 65,
	}
	var encounters: Array[Encounter.EncounterType] = possible_encounters.keys()
	var cum_weights: Array[int] = possible_encounters.values()
	var chosen_encounter: Encounter.EncounterType
	
	for w in cum_weights.size():
		if 0 < w:
			cum_weights[w] += cum_weights[w - 1]
	
	var random_index: int = randi_range(0, cum_weights.back())
	
	for w in cum_weights:
		if w >= random_index:
			chosen_encounter = encounters[cum_weights.find(w)]
	
	match chosen_encounter:
		Encounter.EncounterType.CAMPFIRE:
			print("Loading campfire from random")
			_load_campfire_encounter()
		Encounter.EncounterType.DIALOGUE:
			print("Loading dialogue from random")
			_load_dialogue_encounter()
		_:
			print("Loading battle from random")
			_load_battle_encounter()
