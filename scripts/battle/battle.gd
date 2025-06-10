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
	EventBusHandler.call_event(EventBus.Event.BATTLE_ENDED)
	EventBusHandler.clear_all_battle_events()



#region player start turn

func _on_player_start_turn_draw_cards() -> void:
	card_handler.draw_cards(card_draw_amount)

func _on_player_start_turn_choose_enemy_intents() -> void:
	enemy_handler.choose_intent()

func _on_player_start_turn_reset_energy() -> void:
	player_character.reset_energy()

#endregion

#region enemy turn

func _on_enemy_turn_resolve_enemy_intents() -> void:
	enemy_handler.resolve_intent()

#endregion
