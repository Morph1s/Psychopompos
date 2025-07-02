extends CanvasLayer

@onready var map: Map = $Map
@onready var run_ui = $RunUI
@onready var deck_view: DeckView = $DeckView

var battle_ui_reference: BattleUI

const BATTLE_UI = preload("res://scenes/ui/battle_ui.tscn")
const BATTLE_REWARDS : PackedScene = preload("res://scenes/encounters/battle_rewards.tscn")
const DECK_VIEW = preload("res://scenes/ui/deck_view.tscn")

func _ready() -> void:
	EventBusHandler.battle_started.connect(_on_event_bus_battle_started)
	EventBusHandler.battle_ended.connect(_on_event_bus_battle_ended)
	EventBusHandler.show_deck_view.connect(_on_eventbus_open_deck_view)
	EventBusHandler.show_deck_view_with_action.connect(_on_eventbus_open_deck_view_with_action)
	EventBusHandler.campfire_finished.connect(_on_eventbus_campfire_finished)
	EventBusHandler.dialogue_finished.connect(_on_eventbus_dialogue_finished)

func load_battle_rewards(boss_rewards: bool):
	var battle_rewards: BattleRewards = BATTLE_REWARDS.instantiate()
	
	if boss_rewards:
		battle_rewards.load_boss_rewards()
	else:
		battle_rewards.load_common_rewards()
	battle_rewards.finished_selecting.connect(_on_battle_rewards_finished_selecting)
	add_child(battle_rewards)

func _on_run_ui_open_map():
	if map.visible:
		map.close_map()
		return
	elif deck_view.visible:
		_close_deck_view()
	
	map.show()
	EventBusHandler.show_map.emit()
	
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
	map.current_node.encounter.completed = true
	map.unlock_next_encounters()
	map.current_layer += 1

func _on_map_hidden():
	if battle_ui_reference:
		battle_ui_reference.show()
	EventBusHandler.back_to_battle.emit()

func _on_battle_rewards_finished_selecting() -> void:
	map.can_close = false
	map.show()

func _on_eventbus_dialogue_finished():
	map.current_encounter.completed = true
	map.unlock_next_encounters()
	map.current_layer += 1
	map.can_close = false
	map.show()

func _on_eventbus_open_deck_view(deck: Array[CardType]) -> void:	
	if map.visible:
		map.hide()
	
	deck_view.show()
	deck_view.load_cards(deck)
	
	if battle_ui_reference:
		battle_ui_reference.hide()

func _on_eventbus_open_deck_view_with_action(deck: Array[CardType], on_card_selected_action: Callable) -> void:
	deck_view.show()
	deck_view.load_cards(deck)
	deck_view.add_card_action(on_card_selected_action)
	
	if battle_ui_reference:
		battle_ui_reference.hide()

func _close_deck_view():
	deck_view.hide()
	EventBusHandler.back_to_battle.emit()
	if not map.can_close:
		map.show()
		return
	if battle_ui_reference:
		battle_ui_reference.show()

func _on_eventbus_campfire_finished():
	map.current_node.encounter.completed = true
	map.unlock_next_encounters()
	map.current_layer += 1
	map.can_close = false
	map.show()

func _on_run_ui_open_deck_view():
	if deck_view.visible:
		_close_deck_view()
	else:
		EventBusHandler.show_deck_view.emit(DeckHandler.current_deck)
