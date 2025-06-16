extends CanvasLayer


@onready var map: Map = $Map
@onready var run_ui = $RunUI

var battle_ui_reference: BattleUI 

const BATTLE_UI = preload("res://scenes/ui/battle_ui.tscn")
const BATTLE_REWARDS : PackedScene = preload("res://scenes/encounters/battle_rewards.tscn")

func _ready() -> void:
	EventBusHandler.battle_started.connect(_on_event_bus_battle_started)
	EventBusHandler.battle_ended.connect(_on_event_bus_battle_ended)

func load_battle_rewards():
	var battle_rewards: BattleRewards = BATTLE_REWARDS.instantiate()
	battle_rewards.load_common_rewards()
	battle_rewards.finished_selecting.connect(_on_battle_rewards_finished_selecting)
	add_child(battle_rewards)



func _on_run_ui_open_map():
	if map.visible:
		map.close_map()
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
	map.current_encounter.completed = true
	map.unlock_next_encounters()
	map.current_layer += 1

func _on_map_hidden():
	if battle_ui_reference:
		battle_ui_reference.show()

func _on_battle_rewards_finished_selecting() -> void:
	map.can_close = false
	map.show()
