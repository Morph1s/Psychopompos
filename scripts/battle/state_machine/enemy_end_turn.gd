class_name EnemyEndTurn
extends State

signal enemy_ends_turn


func _ready() -> void:
	EventBusHandler.enemies_end_of_turn_resolved.connect(_on_event_bus_enemies_end_of_turn_resolved)

func enter():
	print("Entered EnemyEndTurn")
	# for each enemy: resolve enemy end of turn effects
	enemy_ends_turn.emit()

func exit():
	print("Exited EnemyEndTurn")

func _on_event_bus_enemies_end_of_turn_resolved():
	state_machine.transition_to("PlayerStartTurn")
