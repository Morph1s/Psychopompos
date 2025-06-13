class_name Battle
extends Node2D

@onready var card_handler: CardHandler = $CardHandler
@onready var enemy_handler: EnemyHandler = $EnemyHandler
@onready var state_machine: StateMachine = $StateMachine
@onready var player_character: Character = $PlayerCharacter


var card_draw_amount: int = 5
var player_win: bool = false

func _ready() -> void:
	player_character.initialize()
	card_handler.initialize()
	enemy_handler.initialize()
	state_machine.initialize()

func _exit_tree() -> void:
	state_machine.transition_to("Exit")


#region signals

#region player turn

func _on_player_start_turn_draw_cards() -> void:
	card_handler.draw_cards(card_draw_amount)

func _on_player_start_turn_choose_enemy_intents() -> void:
	enemy_handler.choose_intent()

func _on_player_start_turn_player_starts_turn() -> void:
	player_character.start_of_turn()

func _on_player_end_turn_player_ends_turn() -> void:
	player_character.end_of_turn()

func _on_player_end_turn_discard_hand():
	card_handler.discard_hand()

#endregion

#region enemy turn

func _on_enemy_turn_resolve_enemy_intents() -> void:
	enemy_handler.resolve_intent()

func _on_enemy_start_turn_enemy_starts_turn() -> void:
	for enemy in enemy_handler.enemies:
		enemy.start_of_turn()

func _on_enemy_end_turn_enemy_ends_turn() -> void:
	for enemy in enemy_handler.enemies:
		enemy.end_of_turn()
#endregion

#endregion
