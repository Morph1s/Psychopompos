class_name CardPackPanel
extends PanelContainer

@onready var card_pack_handler: CardPackHandler = $"../../../../../CardPackHandler"
@onready var packs_container: HBoxContainer = $PacksMargin/PacksContainer
@onready var tooltip: Tooltip = $"../../../../Tooltip"
@onready var select_cards_screen: SelectCardsScreen = $"../../../../SelectCardScreen"

const NUM_PACKS: int = 3
const NUM_CARDS_TO_SELECT: int = 2
const CARD_PACK_VISUALIZATION = preload("res://scenes/encounters/card_pack_visualization.tscn")

var packs: Array[CardPack] = []
var pack_distributions: Dictionary[CardPack.PackRarity, int] = {
	CardPack.PackRarity.COMMON: 60,
	CardPack.PackRarity.RARE: 30,
	CardPack.PackRarity.LEGENDARY: 10
}
var rng: RandomNumberGenerator = RunData.sub_rngs["rng_card_pack_panel"]
var current_card_pack: CardPack

func initialize():
	_create_packs()
	_fill_packs_panel()

func _create_packs() -> void:
	for i in NUM_PACKS:
		var pack_rarity := _get_pack_rarity()
		var pack := card_pack_handler.create_pack(pack_rarity)
		packs.append(pack)

func _get_pack_rarity() -> CardPack.PackRarity:
	var random_index := rng.randi_range(0, 100)
	
	for rar in pack_distributions:
		if random_index <= pack_distributions[rar]:
			return rar
		else:
			random_index -= pack_distributions[rar]
	
	return CardPack.PackRarity.COMMON

func _fill_packs_panel() -> void:
	for pack: CardPack in packs:
		if pack:
			var pack_visual = CARD_PACK_VISUALIZATION.instantiate()
			pack_visual.initialize(pack)
			pack_visual.show_tooltip.connect(_on_card_pack_show_tooltip)
			pack_visual.hide_tooltip.connect(_on_card_pack_hide_tooltip)
			pack_visual.pack_selected.connect(_on_card_pack_pack_selected)
			packs_container.add_child(pack_visual)

func _on_card_pack_show_tooltip(data: Array[TooltipData]):
	tooltip.load_tooltips(data)
	tooltip.show()

func _on_card_pack_hide_tooltip():
	tooltip.hide()

func _on_card_pack_pack_selected(pack: CardPack):
	if pack.price > RunData.player_stats.coins:
		return
	
	print("Selected a ", CardPack.PackRarity.find_key(pack.pack_rarity), " pack for the price of ", pack.price, " coins.")
	select_cards_screen.initialize(pack.cards, NUM_CARDS_TO_SELECT)
	select_cards_screen.show()
	
	current_card_pack = pack

func _on_select_card_screen_cards_selected(cards: Array[CardType]) -> void:
	select_cards_screen.hide()
	
	for card: CardType in cards:
		DeckHandler.add_card_to_deck(card)
		print("Add card ", card.card_name, " to deck")
	
	for pack: CardPackVisualization in packs_container.get_children():
		if pack.card_pack == current_card_pack:
			pack.queue_free()
