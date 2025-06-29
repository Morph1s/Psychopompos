class_name Idle
extends State

func _ready():
	EventBusHandler.end_turn_button_pressed.connect(_on_event_bus_end_turn_button_pressed)

func enter():
	print("Entered Idle")

func exit():
	print("Exited Idle")

func _on_event_bus_end_turn_button_pressed() -> void:
	state_machine.transition_to("PlayerEndTurn")
