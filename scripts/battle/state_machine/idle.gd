class_name Idle
extends State

func _ready():
	EventBusHandler.connect_to_event(EventBus.Event.END_TURN_BUTTON, _on_event_bus_end_turn_button_pressed)

func enter():
	print("Entered Idle")
	
	EventBusHandler.call_event(EventBus.Event.ENTERED_IDLE)
	# check for card selected -> enter state card_highlighted
	# check for end of turn button pressed -> enter state player_end_turn

func exit():
	print("Exited Idle")


func _on_event_bus_end_turn_button_pressed() -> void:
	state_machine.transition_to("PlayerEndTurn")
