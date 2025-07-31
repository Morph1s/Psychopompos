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

func _on_player_start_turn_player_starts_turn() -> void:
	enemy_handler.choose_intent()
	await player_character.start_of_turn()
	ArtifactHandler._on_player_start_turn()
	await card_handler.draw_cards(RunData.player_stats.card_draw_amount)
	state_machine.transition_to("Idle")

func _on_player_end_turn_player_ends_turn() -> void:
	await player_character.end_of_turn()
	await card_handler.discard_hand()
	state_machine.transition_to("EnemyStartTurn")

func _on_idle_entered_idle():
	card_handler.player_turn = true

func _on_idle_exited_idle():
	card_handler.player_turn = false

#endregion

#region enemy turn

func _on_enemy_turn_resolve_enemy_intents() -> void:
	await enemy_handler.resolve_intent()
	await get_tree().create_timer(0.1).timeout
	state_machine.transition_to("EnemyEndTurn")

func _on_enemy_start_turn_enemy_starts_turn() -> void:
	await enemy_handler.start_of_enemy_turn()
	await get_tree().create_timer(0.1).timeout
	state_machine.transition_to("EnemyTurn")

func _on_enemy_end_turn_enemy_ends_turn() -> void:
	await enemy_handler.end_of_enemy_turn()
	await get_tree().create_timer(0.1).timeout
	state_machine.transition_to("PlayerStartTurn")

#endregion

func _on_player_character_player_died() -> void:
	load_game_over_screen.emit()

func _on_enemy_handler_all_enemies_died() -> void:
	if the_end:
		load_win_screen.emit()
		return
	load_battle_rewards.emit(boss_battle)

func _on_card_handler_display_play_area_highlights(visibility: bool) -> void:
	if visibility:
		play_area_highlights.show()
	else:
		play_area_highlights.hide()

func _on_card_handler_display_enemy_highlights(visibility: bool) -> void:
	enemy_handler.display_enemy_highlights(visibility)

#endregion
