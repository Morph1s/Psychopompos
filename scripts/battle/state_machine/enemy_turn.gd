class_name EnemyTurn
extends State

signal resolve_enemy_intents


func _ready() -> void:
	EventBusHandler.enemies_turn_resolved.connect(_on_event_bus_enemies_turn_resolved)

func enter():
	print("Entered EnemyTurn")
	# resolve enemy intent
	resolve_enemy_intents.emit()

func exit():
	print("Exited EnemyTurn")

func _on_event_bus_enemies_turn_resolved():
	state_machine.transition_to("EnemyEndTurn")
