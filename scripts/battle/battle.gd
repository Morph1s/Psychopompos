class_name Battle
extends Node2D

@onready var card_handler: CardHandler = $CardHandler
@onready var enemy_handler: EnemyHandler = $EnemyHandler
@onready var state_machine: StateMachine = $StateMachine
@onready var player_character: Character = $PlayerCharacter


func _ready() -> void:
	player_character.initialize()
	card_handler.initialize()
	enemy_handler.initialize()
	state_machine.initialize()

func _exit_tree() -> void:
	EventBusHandler.call_event(EventBus.Event.BATTLE_ENDED)
	EventBusHandler.clear_all_battle_events()
