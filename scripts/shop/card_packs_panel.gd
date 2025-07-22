class_name CardPackPanel
extends PanelContainer

@onready var packs_container: HBoxContainer = $PacksMargin/PacksContainer
@onready var tooltip: Tooltip = $"../../../../Tooltip"
@onready var select_cards_screen: SelectCardsScreen = $"../../../../SelectCardScreen"
@onready var direct_buy_panel: DirectBuyPanel = $"../DirectBuyPanel"
@onready var no_packs_label: Label = $PacksMargin/NoPacksLabel
@onready var pack_slots: Array[Control] = [
	$PacksMargin/PacksContainer/Pack0,
	$PacksMargin/PacksContainer/Pack1,
	$PacksMargin/PacksContainer/Pack2
]

const NUM_PACKS: int = 3
const NUM_CARDS_TO_SELECT: int = 2
const CARD_PACK_VISUALIZATION = preload("res://scenes/encounters/card_pack_visualization.tscn")
const PACK_SIZE: int = 5

var packs: Array[CardPack] = []
var pack_distributions: Dictionary[CardPack.PackRarity, int] = {
	CardPack.PackRarity.COMMON: 60,
	CardPack.PackRarity.RARE: 30,
	CardPack.PackRarity.LEGENDARY: 10
}
var card_distributions: Dictionary[CardPack.PackRarity, Dictionary] = {
	CardPack.PackRarity.COMMON: {
		CardType.Rarity.COMMON_CARD: 80,
		CardType.Rarity.HERO_CARD: 18,
		CardType.Rarity.GODS_BOON: 2
	},
	CardPack.PackRarity.RARE: {
		CardType.Rarity.COMMON_CARD: 55,
		CardType.Rarity.HERO_CARD: 35,
		CardType.Rarity.GODS_BOON: 10
	},
	CardPack.PackRarity.LEGENDARY: {
		CardType.Rarity.COMMON_CARD: 15,
		CardType.Rarity.HERO_CARD: 40,
		CardType.Rarity.GODS_BOON: 45
	},
}
var rng: RandomNumberGenerator = RunData.sub_rngs["rng_card_pack_panel"]
var current_card_pack: CardPack


func initialize():
	_create_packs()
	_fill_packs_panel()

func _create_packs() -> void:
	for i in NUM_PACKS:
		var pack_rarity: CardPack.PackRarity = _get_pack_rarity()
		var pack: CardPack = _create_pack(pack_rarity)
		packs.append(pack)

func _create_pack(rarity: CardPack.PackRarity) -> CardPack:
	var pack: CardPack = CardPack.new()
	pack.pack_rarity = rarity
	pack.price = _calculate_price(rarity)
	pack.cards = DeckHandler.get_card_selection(PACK_SIZE, card_distributions[rarity])
	var pack_tooltip: TooltipData = TooltipData.new()
	# TODO: make tooltip dynamic
	pack_tooltip.description = "Select 2 out of 5 random cards"
	pack.tooltips.append(pack_tooltip)
	return pack

func _calculate_price(rarity: CardPack.PackRarity) -> int:
	return {
		CardPack.PackRarity.COMMON: rng.randi_range(80, 110),
		CardPack.PackRarity.RARE: rng.randi_range(120, 150),
		CardPack.PackRarity.LEGENDARY: rng.randi_range(160, 200)
	}[rarity]

func _get_pack_rarity() -> CardPack.PackRarity:
	var random_index := rng.randi_range(0, 100)
	
	for rar in pack_distributions:
		if random_index <= pack_distributions[rar]:
			return rar
		else:
			random_index -= pack_distributions[rar]
	
	return CardPack.PackRarity.COMMON

func _fill_packs_panel() -> void:
	for i in pack_slots.size():
		var pack: CardPack = packs[i]
		if pack:
			var pack_visual: CardPackVisualization = CARD_PACK_VISUALIZATION.instantiate()
			pack_visual.initialize(pack)
			pack_visual.apply_material()
			pack_visual.show_tooltip.connect(_on_card_pack_show_tooltip)
			pack_visual.hide_tooltip.connect(_on_card_pack_hide_tooltip)
			pack_visual.pack_selected.connect(_on_card_pack_pack_selected)
			
			pack_slots[i].add_child(pack_visual)
			
	update_price_tags()

func _on_card_pack_show_tooltip(data: Array[TooltipData]) -> void:
	tooltip.load_tooltips(data)
	tooltip.show()

func _on_card_pack_hide_tooltip() -> void:
	tooltip.hide()

func _on_card_pack_pack_selected(pack: CardPack) -> void:
	if pack.price > RunData.player_stats.coins:
		return
	
	RunData.player_stats.coins -= pack.price
	
	print("Selected a ", CardPack.PackRarity.find_key(pack.pack_rarity), " pack for the price of ", pack.price, " coins.")
	select_cards_screen.initialize(pack.cards, NUM_CARDS_TO_SELECT)
	select_cards_screen.show()
	
	current_card_pack = pack

func _on_select_card_screen_cards_selected(cards: Array[CardType], card_visuals: Array[CardVisualization]) -> void:
	select_cards_screen.hide()
	
	var positions: Array[Vector2] = []
	
	for card: CardType in cards:
		DeckHandler.add_card_to_deck(card)
		positions.append(card_visuals[cards.find(card)].global_position)
		print("Add card ", card.card_name, " to deck")
	
	EventBusHandler.card_picked_for_deck_add.emit(cards, positions)
	
	for pack: Control in packs_container.get_children():
		if pack.get_children().is_empty():
			continue
		if pack.get_child(0).card_pack == current_card_pack:
			packs.erase(pack.get_child(0).card_pack)
			pack.get_child(0).queue_free()
	
	update_price_tags()
	direct_buy_panel.update_price_tags()
	
	if packs.is_empty():
		no_packs_label.show()

func update_price_tags() -> void:
	for pack: Control in packs_container.get_children():
		if pack.get_children().size() > 0:
			pack.get_child(0).update_price_tag()
