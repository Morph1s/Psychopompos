class_name ShopTradingInterface
extends Control

signal change_card_selection(selected_cards: Array[CardType])
signal traded

@onready var selected_cards_container: HBoxContainer = $MarginContainer/TradingEquationContainer/CardsPart/SelectedCardsContainer
@onready var coins_display: Label = $MarginContainer/TradingEquationContainer/CoinsPartMargin/CoinsPart/CoinsDisplay/Coins
@onready var card_value_label: Label = $MarginContainer/TradingEquationContainer/CardsPart/CardValueLabel
@onready var card_display: Control = $MarginContainer/TradingEquationContainer/ResultPart/CardDisplay
@onready var probability_label: Label = $MarginContainer/TradingEquationContainer/ResultPart/ProbabilityLabel

const CARD_VISUALIZATION: PackedScene = preload("res://scenes/card/card_visualization.tscn")

const MAX_DIFF_TRADING_VALUE: int = 50
const MAX_NUM_POSSIBLE_TRADE_RESULTS: int = 6
const MIN_NUM_POSSIBLE_TRADE_RESULTS: int = 3
const CARD_VALUE_MODIFIER: float = 0.7

var selected_cards: Array[CardType] = []
var coins: int = 0:
	set(value):
		coins = max(0, min(value, RunData.player_stats.coins))
		coins_display.text = str(coins)
		trading_value = total_card_value + coins
var total_card_value: int = 0:
	set(value):
		total_card_value = value
		card_value_label.text = "Trade value: %d coins" % total_card_value
		trading_value = total_card_value + coins
var trading_value: int = 0:
	set(value):
		trading_value = value
		calculate_result()
var possible_trade_results: Dictionary[CardType, int]
var rng: RandomNumberGenerator = RunData.sub_rngs["rng_shop_trade"]
var card_visual: CardVisualization


func set_selected_cards(cards: Array[CardType]) -> void:
	for card: CardVisualization in selected_cards_container.get_children():
		card.queue_free()
	
	selected_cards = cards
	trading_value = 0
	total_card_value = 0
	
	for card: CardType in selected_cards:
		var card_visual: CardVisualization = CARD_VISUALIZATION.instantiate()
		card_visual.initialize(card)
		selected_cards_container.add_child(card_visual)
		total_card_value += int(card.card_value * CARD_VALUE_MODIFIER)

func calculate_result() -> void:
	possible_trade_results.clear()
	for child: CardVisualization in card_display.get_children():
		child.queue_free()
	var all_available_cards: Array[CardType] = DeckHandler.card_library.common_cards + DeckHandler.card_library.hero_cards + DeckHandler.card_library.gods_boon_cards
	
	# remove selected cards from the pool of possible trade results
	all_available_cards = all_available_cards.filter(func(card: CardType): 
		for selected_card: CardType in selected_cards:
			if card.card_name == selected_card.card_name:
				return false
		return true
	)
	
	# sort the available cards by value difference to trading_value from smallest to biggest
	all_available_cards.sort_custom(func(a: CardType, b: CardType): return abs(trading_value - a.card_value) < abs(trading_value - b.card_value))
	
	var total_weight: int = 0
	var highest_weight: int = 0
	var min_diff: int = abs(trading_value - all_available_cards.front().card_value)
	var alpha: float = 0.1
	var w_scale: int = 1000
	
	# add up to MAX_NUM_POSSIBLE_TRADE_RESULTS cards to possible_trade_results if constraints are met
	for i: int in MAX_NUM_POSSIBLE_TRADE_RESULTS:
		var card: CardType = all_available_cards[i]
		var diff: int = abs(trading_value - card.card_value)
		if diff > MAX_DIFF_TRADING_VALUE and possible_trade_results.size() >= MIN_NUM_POSSIBLE_TRADE_RESULTS:
			continue
		var relative_diff: int = diff - min_diff
		var weight_f: float = exp(- alpha * relative_diff)
		var weight: int = int(pow(max(1, int(round(weight_f * w_scale))), 3))
		
		possible_trade_results[card] = weight
		total_weight += weight
		if weight > highest_weight:
			highest_weight = weight
	
	card_visual = CARD_VISUALIZATION.instantiate()
	card_visual.initialize(possible_trade_results.find_key(highest_weight))
	card_display.add_child(card_visual)
	
	probability_label.text = "with a probability\nof %.2f" % ((float(highest_weight) / float(total_weight)) * 100)  + "%"

func choose_weighted_trade_result() -> void:
	var cards: Array[CardType] = possible_trade_results.keys()
	var cum_weights: Array[int] = possible_trade_results.values().duplicate()
	var card_result: CardType
	
	for w: int in cum_weights.size():
		if 0 < w:
			cum_weights[w] += cum_weights[w - 1]
	
	var random_index: int = randi64(cum_weights.back())
	
	for w: int in cum_weights:
		if w >= random_index:
			card_result = cards[cum_weights.find(w)]
			break
	
	var card_array: Array[CardType] = [card_result]
	var position_array: Array[Vector2] = [card_visual.global_position]
	EventBusHandler.card_picked_for_deck_add.emit(card_array, position_array)
	
	DeckHandler.add_card_to_deck(card_result)
	for card: CardType in selected_cards:
		DeckHandler.remove_card_from_deck(card)
	RunData.player_stats.coins -= coins

func randi64(max_value: int) -> int:
	var hi: int = rng.randi()
	var lo: int = rng.randi()
	var combined: int = (hi << 32) | lo
	return combined % max_value

func _on_exit_pressed() -> void:
	coins = 0
	total_card_value = 0
	selected_cards.clear()
	for card: CardVisualization in selected_cards_container.get_children():
		card.queue_free()
	hide()

func _on_change_card_selection_button_pressed() -> void:
	change_card_selection.emit(selected_cards)

func _on_plus_one_button_pressed() -> void:
	coins += 1

func _on_minus_one_button_pressed() -> void:
	coins -= 1

func _on_plus_10_button_pressed() -> void:
	coins += 10

func _on_minus_10_button_pressed() -> void:
	coins -= 10

func _on_trade_pressed() -> void:
	choose_weighted_trade_result()
	traded.emit()
	hide()
