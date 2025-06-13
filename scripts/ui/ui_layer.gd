extends CanvasLayer


@onready var map = $Map
@onready var run_ui = $RunUI

var battle_ui_reference: BattleUI 

const BATTLE_UI = preload("res://scenes/ui/battle_ui.tscn")
const BATTLE_REWARDS : PackedScene = preload("res://scenes/encounters/battle_rewards.tscn")

func _ready() -> void:
	EventBusHandler.connect_to_event(EventBus.Event.BATTLE_STARTED, _on_event_bus_battle_started)
	EventBusHandler.connect_to_event(EventBus.Event.BATTLE_ENDED, _on_event_bus_battle_ended)

func load_battle_rewards():
	var battle_rewards: BattleRewards = BATTLE_REWARDS.instantiate()
	battle_rewards.load_common_rewards()
	add_child(battle_rewards)



func _on_run_ui_open_map():
	if map.visible:
		map.hide()
		return
	
	map.show()
	
	if battle_ui_reference:
		battle_ui_reference.hide()

func _on_event_bus_battle_started() -> void:
	battle_ui_reference = BATTLE_UI.instantiate()
	add_child(battle_ui_reference)

func _on_event_bus_battle_ended() -> void:
	for child in get_children():
		if child is BattleUI:
			child.queue_free()
			print("Huiiiiiiiiiiiiiiiiiiii...")
			print(" ")
			print(" ")
			print(" ")
			print("AAAAAAhhhhhhhhhhhhhhhh!!!")
			break

func _on_map_hidden():
	if battle_ui_reference:
		battle_ui_reference.show()
