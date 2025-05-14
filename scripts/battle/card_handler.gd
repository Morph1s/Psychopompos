class_name CardHandler
extends Node2D

## only for testing purposes. cards are not properly initialized. 
## will be handled in $Run/DeckHandler in the final version.
const TEST_CHARACTER_CARDS = preload("res://resources/characters/test_character_cards.tres") 

const CARD = preload("res://scenes/card/card.tscn")
const DRAW_PILE_COORDS: Vector2 = Vector2(24.0, 148.0)
const MAX_HAND_SIZE: int = 10
const CARD_Y_POSITION: int = 152
const SCREEN_CENTER_X: int = 160
const CARD_WIDTH = 32
const CARD_DRAW_SPEED: float = 0.2
const DISCARD_PILE_COORDS: Vector2 = Vector2(360.0, 148.0)

var draw_pile: Array[CardType]
var hand: Array[Card] = []
var discard_pile: Array[CardType] = []

## handels setup at beginning of battle.
## should only be called once to handle the initialization!
func initialize() -> void:
	draw_pile.append_array(TEST_CHARACTER_CARDS.starting_deck)
	draw_pile.shuffle()

# ready fuction needs to be replaced by calling methods from battle later
# currently used for testing purposes
func _ready() -> void:
	initialize()
	EventBusHandler.connect_to_event(EventBus.Event.PLAYER_TURN_START, Callable(self, "_on_player_turn_start"))
	EventBusHandler.connect_to_event(EventBus.Event.PLAYER_TURN_END, Callable(self, "_on_player_turn_end"))

## draws "amount" cards from the drawpile to hand
func draw_cards(amount: int) -> void:
	for i in range(amount):
		
		# if the drawpile is empty, shuffle discard pile
		if draw_pile.size() == 0:
			if discard_pile.size() == 0:
				return
			else:
				shuffle_discard_pile_into_draw_pile()
		
		# create a card
		var front_card_card_type: CardType = draw_pile.pop_front()
		var success: bool = add_card_to_hand(front_card_card_type)
		if not success:
			return
		
		# wait for hand to be updated
		var timer = get_tree().create_timer(CARD_DRAW_SPEED)
		await timer.timeout

## adds the given card type to the players hand.
## THIS IS THE ONLY WAY CARDS SHOULD BE ADDED TO THE HAND!
func add_card_to_hand(card_type: CardType) -> bool:
	# check if handsize limit is reached
	if hand.size() == MAX_HAND_SIZE:
		print("hand size limit reached")
		return false
	
	var new_card: Card = CARD.instantiate() as Card
	new_card.initialize(card_type)
	new_card.position = DRAW_PILE_COORDS
	self.add_child(new_card)
	hand.push_front(new_card)
	_update_hand_positions()
	return true

## empties the discard pile into the draw pile and the shuffles the draw pile 
func shuffle_discard_pile_into_draw_pile() -> void:
	draw_pile.append_array(discard_pile)
	discard_pile = []
	draw_pile.shuffle()

func discard_hand() -> void:
	while hand.size() > 0:
		var card = hand.back()
		await discard_card_from_hand(card)

func discard_card_from_hand(card: Card) -> void:
	if not hand.has(card):
		return
	
	# remove the card from hand and add it to discard pile
	hand.erase(card)
	discard_pile.append(card.card_type)
	
	# animate discarding
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", DISCARD_PILE_COORDS, CARD_DRAW_SPEED)
	await tween.finished
	
	card.queue_free()
	
	if not hand.is_empty():
		_update_hand_positions()

#region local functions

# used to animate the cards to their respective position
func _update_hand_positions() -> void:
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	for i in hand.size():
		tween.tween_property(hand[i], "position", _calculate_card_position(i, hand.size()), CARD_DRAW_SPEED)

func _calculate_card_position(index: int, hand_count: int) -> Vector2:
	var card_distance: int = CARD_WIDTH - round(hand_count / 2) * 2
	var card_x_position = SCREEN_CENTER_X + index * card_distance - card_distance * (hand_count - 1) / 2
	return Vector2(card_x_position, CARD_Y_POSITION)

#endregion

#region game loop helpers

func _on_player_turn_start():
	draw_cards(5)

func _on_player_turn_end():
	discard_hand()

#endregion
