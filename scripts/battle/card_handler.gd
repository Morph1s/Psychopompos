class_name CardHandler
extends Node2D

## only for testing purposes. cards are not properly initialized. 
## will be handled in $Run/DeckHandler in the final version.
const TEST_CHARACTER_CARDS = preload("res://resources/characters/card_library.tres")

## Assets preloud for mouse_changes
const UNAIMED_CURSOR = preload("res://assets/graphics/ui/cursor_unaimed.png")
const LOCKON_CURSOR = preload("res://assets/graphics/ui/cursor_lockOn.png")
const DEFAULT_CURSOR = preload("res://assets/graphics/ui/cursor_default.png")


const CARD = preload("res://scenes/card/card.tscn")
const DRAW_PILE_COORDS: Vector2 = Vector2(24.0, 148.0)
const MAX_HAND_SIZE: int = 10
const CARD_Y_POSITION: int = 152
const SCREEN_CENTER_X: int = 160
const CARD_WIDTH = 32
const CARD_DRAW_SPEED: float = 0.2
const DISCARD_PILE_COORDS: Vector2 = Vector2(360.0, 148.0)

## for the highligting and select process
var highlighted_card: Card
var second_card: Card
var selected_card: Card
var hovered_enemy_id: int = -1
var mouse_on_play_area: bool = false
 
const WARRIOR_STATS : PlayerStats = preload("res://resources/characters/Warrior_Stats.tres")

var draw_pile: Array[CardType]
var hand: Array[Card] = []
var discard_pile: Array[CardType] = []

## handels setup at beginning of battle.
## should only be called once to handle the initialization!
func initialize() -> void:
	draw_pile.append_array(DeckHandler.current_deck)
	draw_pile.shuffle()

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
		
	# instantiate new Card to CardHandler
	var new_card: Card = CARD.instantiate() as Card
	new_card.initialize(card_type)
	new_card.position = DRAW_PILE_COORDS
	self.add_child(new_card)
	# connect mouse-signal
	new_card.mouse_entered_card.connect(_on_mouse_entered_card)
	new_card.mouse_exited_card.connect(_on_mouse_exited_card)
	new_card.set_modifier_handler()
	# dynamicly moves card to apropiate position
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
	self.get_children()[index].index = index
	var card_distance: int = CARD_WIDTH - round(hand_count / 2) * 2
	var card_x_position = SCREEN_CENTER_X + index * card_distance - card_distance * (hand_count - 1) / 2
	return Vector2(card_x_position, CARD_Y_POSITION)
#endregion

#region card-state-handler
## handels state of cards (has some unconsidered edgecases)



func select_card() -> void:
	if selected_card:  
		selected_card.highlight(Card.HighlightMode.NONE)
	highlighted_card.highlight(Card.HighlightMode.SELECTED)
	selected_card = highlighted_card
	#change mouse cursor
	if selected_card.card_type.targeted:
		Input.set_custom_mouse_cursor(LOCKON_CURSOR)
	else:
		Input.set_custom_mouse_cursor(UNAIMED_CURSOR)

func deselect_card() -> void:
	if selected_card == highlighted_card:
		selected_card.highlight(Card.HighlightMode.HOVERED)
		selected_card = null
	else:
		selected_card.highlight(Card.HighlightMode.NONE)
		selected_card = null
	Input.set_custom_mouse_cursor(DEFAULT_CURSOR)

## handels state after mouseinput
func _input(event: InputEvent) -> void:
	# set card as an selected card
	if  event.is_action_released("left_click") && highlighted_card: 
		select_card()
	# realeses selected card
	if event.is_action_released("right_click") and selected_card:
		deselect_card()
	
	# play targeted card
	if selected_card:
		if event.is_action_released("left_click") and selected_card.card_type.targeted and hovered_enemy_id>-1:
			print("card cost: ", selected_card.card_type.energy_cost)
			for i in range(selected_card.card_type.energy_cost):
				WARRIOR_STATS.lose_one_energy()                      # resolve energy_cost
			selected_card.play(hovered_enemy_id)
			discard_card_from_hand(selected_card)
			deselect_card()
			
		
	# play untargeted card
	if selected_card:
		if event.is_action_released("left_click") and !selected_card.card_type.targeted and mouse_on_play_area:
			print("card cost: ", selected_card.card_type.energy_cost)
			for i in range(selected_card.card_type.energy_cost): 
				WARRIOR_STATS.lose_one_energy()                       # resolve energy_cost
			selected_card.play()
			discard_card_from_hand(selected_card)
			deselect_card()
			
		
	

## handels state after mouse enters card
func _on_mouse_entered_card(card):
	if highlighted_card == null :
		if selected_card != card:
			card.highlight(Card.HighlightMode.HOVERED)
		highlighted_card = card
	elif selected_card != card: 
		second_card = card
## handels state after mouse exits card
func _on_mouse_exited_card(card):
	if (card == highlighted_card):
		if card != selected_card:
			card.highlight(Card.HighlightMode.NONE)
		highlighted_card = null
	
	if (card == second_card):
		second_card = null
	
	if ((second_card != null) && (card != second_card)):
		second_card.highlight(Card.HighlightMode.HOVERED)
		highlighted_card = second_card
		second_card = null
#endregion

## for determening mouseposition
func _on_play_area_mouse_entered() -> void:
	mouse_on_play_area = true 


func _on_play_area_mouse_exited() -> void:
	mouse_on_play_area = false 
