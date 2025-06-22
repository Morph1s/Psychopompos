class_name BattleUI
extends Control

const HUD_ENERGY_BALL = preload("res://scenes/ui/hud_energy_ball.tscn")
const HUD_NEGATIVE_ENERGY_BALL = preload("res://scenes/ui/hud_negative_energy_ball.tscn")

@onready var end_turn_button: Button = $EndTurnButton
@onready var energy_ball_container = $Energy/EnergyBallContainer
@onready var hitpoint_cost_label_container = $Energy/HitpointCostLabelContainer
@onready var hitpoint_cost_text = $Energy/HitpointCostLabelContainer/HitpointCostText
@onready var negative_energy_ball_container = $Energy/NegativeEnergyBallContainer

func _ready() -> void:
	EventBusHandler.set_player_control.connect(_on_eventbus_set_player_control)
	EventBusHandler.card_selected.connect(_on_event_bus_card_selected)
	EventBusHandler.card_deselected.connect(_on_event_bus_card_deselected)
	RunData.player_stats.energy_changed.connect(_on_run_data_player_stats_energy_changed)
	_spawn_energy_balls(RunData.player_stats.maximum_energy)

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

func _spawn_energy_balls(amount: int) -> void:
	for i in amount:
		var ball = HUD_ENERGY_BALL.instantiate()
		energy_ball_container.add_child(ball)
		
		if not ball.is_node_ready():
			await ball.ready

func _on_run_data_player_stats_energy_changed(energy_value: int, maximum_energy: int) -> void:
	var all_energy_balls: Array = energy_ball_container.get_children()
	
	# set maximum energy
	if all_energy_balls.size() != maximum_energy:
		for ball: HudEnergyBall in all_energy_balls:
			ball.queue_free()
			await ball.tree_exited
		await _spawn_energy_balls(maximum_energy)
		
		# reassign new energy balls to array
		all_energy_balls = energy_ball_container.get_children()
	
	# set current energy
	for i in maximum_energy:
		var ball: HudEnergyBall = all_energy_balls[i]
		if i < energy_value and not ball.active:
			ball.activate()
		elif i >= energy_value and ball.active:
			ball.spend_energy()
	
	# show the hp loss through the negative energy balls reacting 
	for negative_ball: HudNegativeEnergyBall in negative_energy_ball_container.get_children():
		negative_ball.explode()

func _on_event_bus_card_selected(cost: int) -> void:
	var energy_after_paying_cost: int = RunData.player_stats.current_energy - cost
	var all_energy_balls: Array = energy_ball_container.get_children()
	var excess_energy_payment = clamp(-energy_after_paying_cost, 0, cost)
	
	# check if the player hast to sacrifice HP to play the card
	if energy_after_paying_cost < 0:
		# show the hitpoint loss
		hitpoint_cost_text.text = "-%d" % [RunData.player_stats.hp_loss_from_energy_calculation(excess_energy_payment)]
		hitpoint_cost_label_container.show()
		
		# spawn negative energy balls to visualize the amount of excess energy
		for i in excess_energy_payment:
			negative_energy_ball_container.add_child(HUD_NEGATIVE_ENERGY_BALL.instantiate())
	
	# highlight all energy balls that would be spent from back to front
	for i in cost - excess_energy_payment:
		all_energy_balls[i + energy_after_paying_cost + excess_energy_payment].highlight()

func _on_event_bus_card_deselected() -> void:
	hitpoint_cost_label_container.hide()
	for negative_ball: HudNegativeEnergyBall in negative_energy_ball_container.get_children():
		if negative_ball.exploding:
			# if the negative energy ball is playing its animation it will free itself
			break
		negative_ball.queue_free()
	
	for ball: HudEnergyBall in energy_ball_container.get_children():
		if ball.active:
			ball.remove_highlight()

#endregion
