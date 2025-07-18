class_name DeckView
extends Control

signal close_deck_view

const CARD_VISUALIZATION = preload("res://scenes/card/card_visualization.tscn")

@onready var card_container = $ScrollContainerMargin/CardScrollContainer/CardContainer
@onready var tooltip = $UIMargin/Tooltip
@onready var action: Button = $UIMargin/ActionButton

var card_selected_action: Callable
var has_action_button: bool = false
var button_action: Callable

func load_cards(card_pile: Array[CardType]) -> void:
	if not is_node_ready():
		await ready
	
	action.disabled = true
	
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

func _on_exit_pressed() -> void:
	for card: CardVisualization in card_container.get_children():
		card.queue_free()
	action.hide()
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
		action.show()
	else:
		action.hide()

func _on_action_pressed() -> void:
	print("trololol")
	button_action.call()
	for card: CardVisualization in card_container.get_children():
		card.queue_free()
	action.hide()
	close_deck_view.emit()
