extends Node2D

var rarity_distribution: Dictionary = {
	"common": 65,
	"rare": 30,
	"epic": 5
}

var selected_boons: Array[String]
var current_deck: Array[CardType] = []

# possible card rewards
var common_cards: Array[CardType] = []
var rare_cards: Array[CardType] = []
var epic_cards: Array[CardType] = []

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func start_run_setup(boons: Array[String] = ["Boon 1", "Boon 2"]) -> void:
	var card_library: CardLibrary = load("res://resources/characters/card_library.tres")
	
	# setting selected boons
	selected_boons = boons
	
	# setting possible card rewards
	_set_card_rewards(card_library)
	
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
	var selected_rare_cards: Array[CardType] = []
	var selected_epic_cards: Array[CardType] = []
	
	# selecting amount cards and removing selected cards from the pool
	for i in range(amount):
		var rarity: String = _get_card_rarity()
		var card_index: int = _get_card_index_by_rarity(rarity)
		match rarity:
			"common":
				selected_common_cards.append(common_cards.pop_at(card_index))
			"rare":
				selected_rare_cards.append(rare_cards.pop_at(card_index))
			"epic":
				selected_epic_cards.append(epic_cards.pop_at(card_index))
	
	# adding removed cards back into the pool
	if selected_common_cards:
		common_cards.append_array(selected_common_cards)
	if selected_rare_cards:
		rare_cards.append_array(selected_rare_cards)
	if selected_epic_cards:
		epic_cards.append_array(selected_epic_cards)
	
	return selected_epic_cards + selected_rare_cards + selected_common_cards  

#region local helper functions

func _set_card_rewards(card_library: CardLibrary) -> void:
	common_cards.clear()
	rare_cards.clear()
	epic_cards.clear()
	
	for boon in selected_boons:
		match boon:
			"Boon 1":
				common_cards.append_array(card_library.common_cards_boon_one)
				rare_cards.append_array(card_library.rare_cards_boon_one)
				epic_cards.append_array(card_library.epic_cards_boon_one)
			"Boon 2":
				common_cards.append_array(card_library.common_cards_boon_two)
				rare_cards.append_array(card_library.rare_cards_boon_two)
				epic_cards.append_array(card_library.epic_cards_boon_two)

func _get_card_rarity() -> String:
	var rarity_roll = rng.randi_range(0, 100)
	
	for key in rarity_distribution:
		if rarity_roll <= rarity_distribution[key]:
			return key
		else:
			rarity_roll -= rarity_distribution[key]
	
	# failsafe
	return "common"


func _get_card_index_by_rarity(rarity: String) -> int:
	match rarity:
		"common":
			return rng.randi_range(0, common_cards.size() - 1)
		"rare":
			return rng.randi_range(0, rare_cards.size() - 1)
		"epic":
			return rng.randi_range(0, epic_cards.size() - 1)
		_:
			push_error("Wrong card rarity selected: ", rarity)
			return -1

#endregion
