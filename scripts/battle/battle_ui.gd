class_name BattleUI
extends Control

@onready var end_turn_button: Button = $EndTurnButton
@onready var energy_text = $Energy/EnergyText
@onready var energy_cost_container = $Energy/ConsequenceContainer/EnergyCostContainer
@onready var energy_cost_text = $Energy/ConsequenceContainer/EnergyCostContainer/EnergyCostText
@onready var hitpoint_cost_container = $Energy/ConsequenceContainer/HitpointCostContainer
@onready var hitpoint_cost_text = $Energy/ConsequenceContainer/HitpointCostContainer/HitpointCostText


func _ready() -> void:
	EventBusHandler.set_player_control.connect(_on_eventbus_set_player_control)
	EventBusHandler.card_selected.connect(_on_event_bus_card_selected)
	EventBusHandler.card_deselected.connect(_on_event_bus_card_deselected)
	RunData.player_stats.energy_changed.connect(_on_run_data_player_stats_energy_changed)

func _on_discard_pile_gui_input(event: InputEvent) -> void:
	if event.is_action_released("left_click") and not get_tree().get_first_node_in_group("card_piles").discard_pile.is_empty():
		EventBusHandler.show_deck_view.emit(get_tree().get_first_node_in_group("card_piles").discard_pile)

func _on_end_turn_button_button_up() -> void:
	EventBusHandler.end_turn_button_pressed.emit()
	end_turn_button.disabled = true

func _on_draw_pile_gui_input(event: InputEvent) -> void:
	if event.is_action_released("left_click") and not get_tree().get_first_node_in_group("card_piles").draw_pile.is_empty():
		EventBusHandler.show_deck_view.emit(get_tree().get_first_node_in_group("card_piles").draw_pile)

func _on_eventbus_set_player_control(value: bool) -> void:
	end_turn_button.disabled = not value

#region energy hud

func _on_run_data_player_stats_energy_changed(energy_value: int, maximum_energy: int) -> void:
	energy_text.text = "%d/%d" % [clamp(energy_value, 0, 99), maximum_energy]

func _on_event_bus_card_selected(cost: int) -> void:
	var energy_after_paying_cost: int = RunData.player_stats.current_energy - cost
	
	if energy_after_paying_cost < 0:
		var excess_energy_payment = clamp(-energy_after_paying_cost, 0, cost)
		
		energy_cost_text.text = "-%d" % [cost - excess_energy_payment]
		energy_cost_container.show()
		
		hitpoint_cost_text.text = "-%d" % [RunData.player_stats.hp_loss_from_energy_calculation(excess_energy_payment)]
		hitpoint_cost_container.show()
	else:
		energy_cost_text.text = "-%d" % [cost]
		energy_cost_container.show()

func _on_event_bus_card_deselected() -> void:
	hitpoint_cost_container.hide()
	energy_cost_container.hide()

#endregion
