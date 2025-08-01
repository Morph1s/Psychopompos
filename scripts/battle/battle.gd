class_name Battle
extends Node2D

signal  load_game_over_screen
signal  load_win_screen
signal  load_battle_rewards(boss_rewards: bool)

@onready var card_handler: CardHandler = $CardHandler
@onready var enemy_handler: EnemyHandler = $EnemyHandler
@onready var state_machine: StateMachine = $StateMachine
@onready var player_character: Character = $PlayerCharacter
@onready var play_area_highlights = $PlayArea/Highlights

var boss_battle: bool = false
var the_end: bool = false


func initialize(data: BattleEncounter) -> void:
	player_character.initialize()
	player_character.show_character_hud()
	card_handler.initialize()
	enemy_handler.initialize(data.enemies)
	state_machine.initialize()
	
	if data.type == Encounter.EncounterType.MINI_BOSS or data.type == Encounter.EncounterType.BOSS:
		boss_battle = true
	if data.type == Encounter.EncounterType.BOSS:
		the_end = true

func _exit_tree() -> void:
	state_machine.transition_to("Exit")

#region signals

#region player turn

# resolve player start of turn effects & choose enemy intents & draw cards
func _on_player_start_turn_player_starts_turn() -> void:
	enemy_handler.choose_intent()
	await player_character.start_of_turn()
	ArtifactHandler._on_player_start_turn()
	await card_handler.draw_cards(RunData.player_stats.card_draw_amount)
	state_machine.transition_to("Idle")

# resolve player end of turn effects & discard hand
func _on_player_end_turn_player_ends_turn() -> void:
	await player_character.end_of_turn()
	await card_handler.discard_hand()
	state_machine.transition_to("EnemyStartTurn")

func _on_idle_entered_idle() -> void:
	card_handler.player_turn = true

func _on_idle_exited_idle() -> void:
	card_handler.player_turn = false

#endregion

#region enemy turn

# resolve enemy intents for each enemy
func _on_enemy_turn_resolve_enemy_intents() -> void:
	await enemy_handler.resolve_intent()
	state_machine.transition_to("EnemyEndTurn")

# resolve enemy start of turn effects for each enemy
func _on_enemy_start_turn_enemy_starts_turn() -> void:
	for enemy in enemy_handler.get_children():
		await enemy.start_of_turn()
	state_machine.transition_to("EnemyTurn")

# resolve enemy end of turn effects for each enemy
func _on_enemy_end_turn_enemy_ends_turn() -> void:
	for enemy in enemy_handler.get_children():
		await enemy.end_of_turn()
	state_machine.transition_to("PlayerStartTurn")

#endregion

# player dies in a battle -> game over
func _on_player_character_player_died() -> void:
	load_game_over_screen.emit()

# all enemies die in a battle -> player wins this battle
func _on_enemy_handler_all_enemies_died() -> void:
	if the_end:
		load_win_screen.emit()
		return
	load_battle_rewards.emit(boss_battle)

# show the card play area(s) when a card is selected:
# 1. card is not targeted:
func _on_card_handler_display_play_area_highlights(visibility: bool) -> void:
	if visibility:
		play_area_highlights.show()
	else:
		play_area_highlights.hide()

# 2. card is targeted:
func _on_card_handler_display_enemy_highlights(visibility: bool) -> void:
	enemy_handler.display_enemy_highlights(visibility)

#endregion
