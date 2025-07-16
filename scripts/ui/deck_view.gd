class_name DeckView
extends Control

signal close_deck_view

const CARD_VISUALIZATION = preload("res://scenes/card/card_visualization.tscn")

@onready var card_container = $ScrollContainerMargin/CardScrollContainer/CardContainer
@onready var tooltip = $UIMargin/Tooltip

var card_selected_action: Callable

func load_cards(card_pile: Array[CardType]) -> void:
	if not is_node_ready():
		await ready
	
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

func _on_exit_pressed() -> void:
	for card in card_container.get_children():
		card.queue_free()
	close_deck_view.emit()

func _on_card_show_toopltip(data: Array[TooltipData]) -> void:
	tooltip.load_tooltips(data)
	tooltip.show()

func _on_card_hide_toopltip() -> void:
	tooltip.hide()

func _on_card_selected(card: CardType, _card_visual: CardVisualization) -> void:
	for card_vis in card_container.get_children():
		card_vis.queue_free()
	card_selected_action.call(card)
	close_deck_view.emit()
