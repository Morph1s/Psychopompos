class_name DirectBuyPanel
extends PanelContainer

@onready var card_container: HBoxContainer = $MarginContainer/CardContainer
@onready var no_cards_label: Label = $MarginContainer/NoCardsLabel
@onready var packs_panel: CardPackPanel = $"../PacksPanel"
@onready var card_slots: Array[Control] = [
	$MarginContainer/CardContainer/Slot0,
	$MarginContainer/CardContainer/Slot1,
	$MarginContainer/CardContainer/Slot2
]


const NUM_CARDS: int = 3
const CARD_VISUALIZATION = preload("res://scenes/card/card_visualization.tscn")

var cards: Array[CardType] = []
var rarity_distribution: Dictionary[CardType.Rarity, int] = {
	CardType.Rarity.COMMON_CARD: 100,
	CardType.Rarity.HERO_CARD: 0,
	CardType.Rarity.GODS_BOON: 0
}


func initialize():
	_create_cards()
	_fill_cards_panel()


func _fill_cards_panel() -> void:
	for i in card_slots.size():
		var card: CardType = cards[i]
		if card:
			var card_visual: CardVisualization = CARD_VISUALIZATION.instantiate()
			card_visual.initialize(card)
			card_visual.is_shop = true
			card_visual.apply_material()
			card_visual.card_selected.connect(_on_card_selected)
			
			card_slots[i].add_child(card_visual)
			
	update_price_tags()


func _on_card_selected(card: CardType, scene: CardVisualization) -> void:
	if card.card_value > RunData.player_stats.coins:
		return
	
	RunData.player_stats.coins -= card.card_value
	
	scene.queue_free()
	cards.erase(card)
	if cards.is_empty():
		no_cards_label.show()
	
	DeckHandler.add_card_to_deck(card)
	
	var card_array: Array[CardType] = [card]
	var position_array: Array[Vector2] = [scene.global_position]
	EventBusHandler.card_picked_for_deck_add.emit(card_array, position_array)
	
	update_price_tags()
	packs_panel.update_price_tags()

func _create_cards() -> void:
	var new_cards := DeckHandler.get_card_selection(NUM_CARDS, rarity_distribution)
	for card in new_cards:
		cards.append(card)

func update_price_tags():
	for card_visual: Control in card_container.get_children():
		if card_visual.get_children().size() > 0:
			card_visual.get_child(0).update_price_tag()
