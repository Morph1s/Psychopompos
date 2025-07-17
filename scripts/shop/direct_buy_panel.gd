class_name DirectBuyPanel
extends PanelContainer

@onready var card_container: HBoxContainer = $MarginContainer/CardContainer
@onready var no_cards_label: Label = $MarginContainer/NoCardsLabel

const NUM_CARDS: int = 3
const CARD_VISUALIZATION = preload("res://scenes/card/card_visualization.tscn")

var template_mat: ShaderMaterial = preload("res://resources/shaders/color_settings.tres") as ShaderMaterial
var shared_mat: ShaderMaterial

var cards: Array[CardType] = []


var rarity_distribution: Dictionary[CardType.Rarity, int] = {
	CardType.Rarity.COMMON_CARD: 100,
	CardType.Rarity.HERO_CARD: 0,
	CardType.Rarity.GODS_BOON: 0
}


func initialize():
	shared_mat = template_mat as ShaderMaterial
	_create_cards()
	_fill_cards_panel()


func _fill_cards_panel() -> void:
	print("trying to fill cards panel")
	for card: CardType in cards:
		print("for working")
		if card:
			var card_visual: CardVisualization = CARD_VISUALIZATION.instantiate()
			card_visual.initialize(card)
			card_visual.apply_material(shared_mat)
			card_visual.set_price_tag()
			print(card_visual)
			print("card_visual initialize")
			card_visual.card_selected.connect(_on_card_selected)
			card_container.add_child(card_visual)


func _on_card_selected(card: CardType, scene: CardVisualization) -> void:
	if card.card_value > RunData.player_stats.coins:
		return
	
	RunData.player_stats.coins -= card.card_value
	
	scene.queue_free()
	cards.erase(card)
	if cards.is_empty():
		no_cards_label.show()
	
	DeckHandler.add_card_to_deck(card)
	
	for cardslot: CardVisualization in card_container.get_children():
		cardslot.set_price_tag()

	

func _create_cards() -> void:
	var new_cards := DeckHandler.get_card_selection(NUM_CARDS, rarity_distribution)
	for card in new_cards:
		cards.append(card)
		print(card.card_name)
		print("Card created")
		print("Card count: ", cards.size())
