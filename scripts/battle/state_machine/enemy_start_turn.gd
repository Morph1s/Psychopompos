class_name EnemyStartTurn
extends State

signal enemy_starts_turn


func _ready() -> void:
	EventBusHandler.enemies_start_of_turn_resolved.connect(_on_event_bus_handle_enemies_start_of_turn_resolved)

func enter():
	print("Entered EnemyStartTurn")
	# resolve enemy start of turn effects
	enemy_starts_turn.emit()

func exit():
	print("Exited EnemyStartTurn")

func _on_event_bus_handle_enemies_start_of_turn_resolved():
	state_machine.transition_to("EnemyTurn")
