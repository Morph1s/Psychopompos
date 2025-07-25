class_name Idle
extends State

signal entered_idle
signal exited_idle


func _ready():
	EventBusHandler.end_turn_button_pressed.connect(_on_event_bus_end_turn_button_pressed)

func enter():
	entered_idle.emit()
	print("Entered Idle")

func exit():
	exited_idle.emit()
	print("Exited Idle")

func _on_event_bus_end_turn_button_pressed() -> void:
	state_machine.transition_to("PlayerEndTurn")
