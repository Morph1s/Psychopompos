class_name StateMachine
extends Node

var current_state: State = null
var states: Dictionary = {}

func _ready() -> void:
	# Add all state nodes to the states dictionary
	for child in get_children():
		if child is State:
			child.state_machine = self
			states[child.name] = child
		else:
			push_warning("Child node '%s' does not extend State" % child.name)
	
	# notify that combat started
	EventBusHandler.call_event(EventBus.Event.BATTLE_STARTED)
	
	# Set initial state
	current_state = states.get("PlayerStartTurn")
	if current_state:
		current_state.enter()
	else:
		push_error("Initial state 'PlayerStartTurn' not found.")

func transition_to(state_name: String):
	if not states.has(state_name):
		push_error("State '%s' not found." % state_name)
		return
	if current_state:
		current_state.exit()
	current_state = states[state_name]
	current_state.enter()
