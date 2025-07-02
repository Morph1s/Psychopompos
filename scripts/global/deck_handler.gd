extends Node2D

var rarity_distribution: Dictionary = {
	CardType.Rarity.COMMON_CARD: 65,
	CardType.Rarity.HERO_CARD: 30,
	CardType.Rarity.GODS_BOON: 5
}

var card_library: CardLibrary
var current_deck: Array[CardType] = []


var rng: RandomNumberGenerator = RunData.sub_rngs["rng_deck_handler"]

func start_run_setup() -> void:
	card_library = null
	
	match RunData.selected_character:
		RunData.Characters.WARRIOR:
			card_library = load("res://resources/characters/warrior_cards.tres")
	
	# setting starting deck
	current_deck.clear()
	for card in card_library.starting_deck:
		current_deck.append(card.create_instance())

func add_card_to_deck(card: CardType) -> void:
	current_deck.append(card.create_instance())

func remove_card_from_deck(card: CardType) -> void:
	if current_deck.has(card):
		current_deck.erase(card)

func get_cards_for_card_rewards(amount: int) -> Array[CardType]:
	if amount <= 0:
		return []
	
	# setup temporary arrays 
	var selected_common_cards: Array[CardType] = []
	var selected_hero_cards: Array[CardType] = []
	var selected_gods_boon_cards: Array[CardType] = []
	
	# selecting amount cards and removing selected cards from the pool
	for i in range(amount):
		var rarity: CardType.Rarity = _get_card_rarity()
		var card_index: int = _get_card_index_by_rarity(rarity)
		match rarity:
			CardType.Rarity.COMMON_CARD:
				selected_common_cards.append(card_library.common_cards.pop_at(card_index))
			CardType.Rarity.HERO_CARD:
				selected_hero_cards.append(card_library.hero_cards.pop_at(card_index))
			CardType.Rarity.GODS_BOON:
				selected_gods_boon_cards.append(card_library.gods_boon_cards.pop_at(card_index))
	
	# adding removed cards back into the pool
	if selected_common_cards:
		card_library.common_cards.append_array(selected_common_cards)
	if selected_hero_cards:
		card_library.hero_cards.append_array(selected_hero_cards)
	if selected_gods_boon_cards:
		card_library.gods_boon_cards.append_array(selected_gods_boon_cards)
	
	return selected_gods_boon_cards + selected_hero_cards + selected_common_cards  

func get_cards_for_boss_card_rewards(amount: int) -> Array[CardType]:
	if amount <= 0:
		return []
	
	# setup temporary array
	var selected_cards: Array[CardType] = []
	
	# selecting amount cards and removing selected cards from the pool
	for i in range(amount):
		var card_index: int = _get_card_index_by_rarity(CardType.Rarity.GODS_BOON)
		selected_cards.append(card_library.gods_boon_cards.pop_at(card_index))
	
	# adding removed cards back into the pool
	card_library.gods_boon_cards.append_array(selected_cards)
	
	return selected_cards

#region local helper functions

func _get_card_rarity() -> CardType.Rarity:
	var rarity_roll = rng.randi_range(0, 100)
	
	for key in rarity_distribution:
		if rarity_roll <= rarity_distribution[key]:
			return key
		else:
			rarity_roll -= rarity_distribution[key]
	
	# failsafe
	push_error("error when selecting card rarity")
	return CardType.Rarity.COMMON_CARD


func _get_card_index_by_rarity(rarity: CardType.Rarity) -> int:
	match rarity:
		CardType.Rarity.COMMON_CARD:
			return rng.randi_range(0, card_library.common_cards.size() - 1)
		CardType.Rarity.HERO_CARD:
			return rng.randi_range(0, card_library.hero_cards.size() - 1)
		CardType.Rarity.GODS_BOON:
			return rng.randi_range(0, card_library.gods_boon_cards.size() - 1)
		_:
			push_error("Wrong card rarity selected: ", rarity)
			return -1

#endregion
