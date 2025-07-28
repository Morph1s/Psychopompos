class_name SelectCardsScreen
extends ColorRect

signal cards_selected(cards: Array[CardType], card_visuals: Array[CardVisualization])

const CARD_VISUALIZATION = preload("res://scenes/card/card_visualization.tscn")

@onready var card_container: HBoxContainer = $HorizontalContainer/CardContainer
@onready var tooltip: Tooltip = $Tooltip
@onready var select_cards_button: Button = $HorizontalContainer/ButtonContainer/SelectCards
@onready var header: Label = $HorizontalContainer/Header

var selected_cards: Array[CardType] = []
var selected_card_visuals: Array[CardVisualization] = []
var num_cards_to_choose: int


func initialize(cards: Array[CardType], choosable_count: int = 1) -> void:
	for child in card_container.get_children():
		child.queue_free()
	
	selected_cards = []
	selected_card_visuals = []
	select_cards_button.disabled = true
	
	header.text = _set_header(choosable_count)
	num_cards_to_choose = choosable_count
	
	for card in cards:
		if card:
			var card_reward_scene = CARD_VISUALIZATION.instantiate()
			card_reward_scene.initialize(card)
			card_reward_scene.card_selected.connect(_on_card_reward_scene_card_selected)
			card_reward_scene.show_tooltip.connect(_on_card_show_tooltip)
			card_reward_scene.hide_tooltip.connect(_on_card_hide_tooltip)
			card_container.add_child(card_reward_scene)


func _on_card_reward_scene_card_selected(card: CardType, scene: CardVisualization) -> void:
	if not selected_cards.has(card):
		if selected_cards.size() == num_cards_to_choose:
			var card_to_deselect: CardType = selected_cards.pop_front()
			selected_card_visuals.pop_front()
			for card_visual: CardVisualization in card_container.get_children():
				if card_visual.card_type == card_to_deselect:
					card_visual.is_perma_highlighted = false
					card_visual.highlight.hide()
		
		scene.is_perma_highlighted = true
		for card_visual: CardVisualization in card_container.get_children():
			if card_visual.card_type == card:
				selected_card_visuals.append(card_visual)
		selected_cards.append(card)
		select_cards_button.disabled = false
	else:
		scene.is_perma_highlighted = false
		selected_cards.erase(card)
		if selected_cards.is_empty():
			select_cards_button.disabled = true

func _set_header(card_count: int) -> String:
	if card_count == 1:
		return "SELECT A CARD"
	return str("SELECT ", card_count, " CARDS")

func _on_skip_cards_button_up():
	selected_cards = []
	selected_card_visuals = []
	cards_selected.emit(selected_cards, selected_card_visuals)

func _on_card_show_tooltip(data: Array[TooltipData]) -> void:
	tooltip.load_tooltips(data)
	tooltip.show()

func _on_card_hide_tooltip() -> void:
	tooltip.hide()

func _on_select_cards_button_up() -> void:
	cards_selected.emit(selected_cards, selected_card_visuals)
