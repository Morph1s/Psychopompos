class_name Idle
extends State

signal entered_idle
signal exited_idle


func _ready() -> void:
	EventBusHandler.end_turn_button_pressed.connect(_on_event_bus_end_turn_button_pressed)

func enter() -> void:
	entered_idle.emit()

func exit() -> void:
	exited_idle.emit()

func _on_event_bus_end_turn_button_pressed() -> void:
	state_machine.transition_to("PlayerEndTurn")
