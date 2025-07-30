class_name DeckView
extends Control

signal close_deck_view

const CARD_VISUALIZATION = preload("res://scenes/card/card_visualization.tscn")

@onready var card_container = $ScrollContainerMargin/CardScrollContainer/CardContainer
@onready var tooltip = $UIMargin/Tooltip
@onready var action_button: Button = $UIMargin/ActionButton
@onready var background_color: ColorRect = $BackgroundColor

var card_selected_action: Callable
var has_action_button: bool = false
var button_action: Callable
var exit_action: Callable


func load_cards(card_pile: Array[CardType]) -> void:
	if not is_node_ready():
		await ready
	
	action_button.disabled = true
	button_action = Callable()
	exit_action = Callable()
	
	for card in card_container.get_children():
		card.queue_free()
	
	for card in card_pile:
		var card_visualization = CARD_VISUALIZATION.instantiate()
		card_visualization.initialize(card)
		card_visualization.show_tooltip.connect(_on_card_show_toopltip)
		card_visualization.hide_tooltip.connect(_on_card_hide_toopltip)
		card_container.add_child(card_visualization)

func add_card_action(on_card_selected_action: Callable) -> void:
	card_selected_action = on_card_selected_action
	
	for card in card_container.get_children():
		card.card_selected.connect(_on_card_selected)

func add_button_action(on_button_pressed_action: Callable) -> void:
	button_action = on_button_pressed_action

func add_exit_action(on_exit_pressed_action: Callable) -> void:
	exit_action = on_exit_pressed_action

func set_background_color(color: Color) -> void:
	background_color.color = color

func _on_exit_pressed() -> void:
	for card: CardVisualization in card_container.get_children():
		card.queue_free()
	if exit_action:
		exit_action.call()
	action_button.hide()
	close_deck_view.emit()

func _on_card_show_toopltip(data: Array[TooltipData]) -> void:
	tooltip.load_tooltips(data)
	tooltip.show()

func _on_card_hide_toopltip() -> void:
	tooltip.hide()

func _on_card_selected(card: CardType, card_visual: CardVisualization) -> void:
	card_selected_action.call(card, card_visual, self)
	if not has_action_button:
		for card_vis in card_container.get_children():
			card_vis.queue_free()
		close_deck_view.emit()

func toggle_action_button():
	if has_action_button:
		action_button.show()
	else:
		action_button.hide()

func _on_action_pressed() -> void:
	button_action.call()
	for card: CardVisualization in card_container.get_children():
		card.queue_free()
	action_button.hide()
	close_deck_view.emit()
