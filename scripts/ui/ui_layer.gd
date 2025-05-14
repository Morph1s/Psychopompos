extends CanvasLayer

@onready var map = $Map

const BATTLE_UI = preload("res://scenes/ui/battle_ui.tscn")

func _ready() -> void:
	EventBusHandler.connect_to_event(EventBus.Event.BATTLE_STARTED, _on_event_bus_battle_started)
	EventBusHandler.connect_to_event(EventBus.Event.BATTLE_ENDED, _on_event_bus_battle_ended)

func _on_open_map_button_pressed():
	map.show()

func _on_event_bus_battle_started() -> void:
	add_child(BATTLE_UI.instantiate())

func _on_event_bus_battle_ended() -> void:
	for child in get_children():
		if child is BattleUI:
			child.queue_free()
			break
