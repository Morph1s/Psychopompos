class_name CardHandler
extends Node2D

signal display_play_area_highlights(visibility: bool)
signal display_enemy_highlights(visibility: bool)

## card scene
const CARD = preload("res://scenes/card/card.tscn")

# Assets preload for mouse_changes
const UNAIMED_CURSOR = preload("res://assets/graphics/cursors/cursor_unaimed.png")
const LOCKON_CURSOR = preload("res://assets/graphics/cursors/cursor_lock_on.png")
const DEFAULT_CURSOR = preload("res://assets/graphics/cursors/cursor_default.png")

# constants for quick adjusting
const DRAW_PILE_COORDS: Vector2 = Vector2(24.0, 148.0)
const MAX_HAND_SIZE: int = 10
const CARD_Y_POSITION: int = 150
const SCREEN_CENTER_X: int = 160
const CARD_WIDTH = 32
const CARD_DRAW_SPEED: float = 0.2
const DISCARD_PILE_COORDS: Vector2 = Vector2(360.0, 148.0)


# card piles
var draw_pile: Array[CardType]
var hand: Array[Card] = []
var discard_pile: Array[CardType] = []

# for the highligting and select process
var highlighted_card: Card
var second_card: Card
var selected_card: Card
var playing_card: bool

# determining targets
var hovered_enemy_id: int = -1:
	set(value):
		hovered_enemy_id = value
		_set_mouse_cursor()
var mouse_on_play_area: bool = false


## handels setup at beginning of battle.
## should only be called once to handle the initialization!
func initialize() -> void:
	draw_pile.append_array(DeckHandler.current_deck)
	draw_pile.shuffle()
	EventBusHandler.show_deck_view.connect(func(_parameter): _set_player_control(false))
	EventBusHandler.show_map.connect(func(): _set_player_control(false))
	EventBusHandler.back_to_battle.connect(func(): _set_player_control(true))

#region card drawing and adding

## draws "amount" cards from the drawpile
func draw_cards(amount: int) -> void:
	
	# alter the value
	amount += RunData.altered_values[RunData.AlteredValue.CARDS_DRAWN]
	
	# limit the amount of cards drawn to meet the maximum hand size
	amount = clamp(amount, 0, MAX_HAND_SIZE - hand.size())
	
	for i in range(amount):
		
		# if the drawpile is empty, shuffle discard pile
		if draw_pile.size() == 0:
			if discard_pile.size() == 0:
				_set_player_control(true)
				return
			else:
				shuffle_discard_pile_into_draw_pile()
		
		# create a card
		var front_card_card_type: CardType = draw_pile.pop_front()
		add_card_to_hand(front_card_card_type)
		
		# wait for hand to be updated
		var timer = get_tree().create_timer(CARD_DRAW_SPEED)
		await timer.timeout
	
	EventBusHandler.cards_drawn.emit()
	
	if not playing_card:
		_set_player_control(true)

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
	# dynamicly moves card to apropiate position
	hand.push_front(new_card)
	_update_hand_positions()
	return true

#endregion

#region card discarding

func discard_hand() -> void:
	_set_player_control(false)
	while hand.size() > 0:
		var card = hand.back()
		await discard_card(card)

func discard_card(card: Card) -> void:
	
	# remove card from hand
	if hand.has(card):
		hand.erase(card)
	
	# add it to discard pile
	discard_pile.append(card.card_type)
	
	# animate discarding
	var tween = create_tween()
	tween.tween_property(card, "position", DISCARD_PILE_COORDS, CARD_DRAW_SPEED)
	await tween.finished
	
	card.queue_free()
	
	if not hand.is_empty():
		_update_hand_positions()

#endregion

#region card playing

func _play_card(card: Card) -> void:
	# disable player control over cards
	playing_card = true
	_set_player_control(false)
	
	display_enemy_highlights.emit(false)
	display_play_area_highlights.emit(false)
	
	card.highlight(Card.HighlightMode.PLAYED)
	selected_card = null
	hand.erase(card)
	
	await card.play(hovered_enemy_id)
	
	EventBusHandler.card_deselected.emit()
	
	await discard_card(card)
	
	playing_card = false
	_set_player_control(true)

#endregion

#region card position functions

# used to animate the cards to their respective position
func _update_hand_positions() -> void:
	for i in hand.size():
		var tween: Tween = get_tree().create_tween()
		tween.set_parallel(false)
		tween.tween_property(hand[i], "position", _calculate_card_position(i, hand.size()), CARD_DRAW_SPEED)
		tween.tween_callback(hand[i].relocate_tooltip)

func _calculate_card_position(index: int, hand_count: int) -> Vector2:
	hand[index].index = index
	var card_distance: int = CARD_WIDTH - round(hand_count / 2) * 2
	var card_x_position = SCREEN_CENTER_X + index * card_distance - card_distance * (hand_count - 1) / 2
	return Vector2(card_x_position, CARD_Y_POSITION)
#endregion

#region card hovering and selecting
## handels state of cards (has no unconsidered edgecases)


## handels state after mouseinput
func _input(event: InputEvent) -> void:
	# set card as an selected card
	if  event.is_action_pressed("left_click") && highlighted_card: 
		_select_card()
	
	# realeses selected card
	elif event.is_action_released("right_click") and selected_card:
		_deselect_selected_card()
	
	# playing cards
	elif selected_card:
		# play targeted card
		if event.is_action_released("left_click") and selected_card.card_type.targeted and hovered_enemy_id > -1:
			_play_card(selected_card)
		
		# play untargeted card
		elif event.is_action_released("left_click") and !selected_card.card_type.targeted and mouse_on_play_area:
			_play_card(selected_card)
		
		_set_tooltips()


## handels state after mouse enters card
func _on_mouse_entered_card(card: Card):
	if highlighted_card == null:
		# hovered onto a card
		_hover_card(card)
		_set_tooltips()
	else:
		# hovered on boarder of second card under main card
		second_card = card

## handels state after mouse exits card
func _on_mouse_exited_card(card: Card):
	
	# hovered off highlighted card
	if card == highlighted_card:
		highlighted_card = null
		
		# remove highlighting
		if card != selected_card:
			card.highlight(Card.HighlightMode.NONE)
		
		# hovered second card
		if second_card != null:
			_hover_card(second_card)
			second_card = null
		
		# update tooltips
		_set_tooltips()
	
	# hovered off second card
	elif card == second_card:
		second_card = null

func _hover_card(card: Card) -> void:
	if selected_card != card:
		# going over all cards and setting hovering mode
		for card_instance in hand:
			if card_instance == card:
				card_instance.highlight(Card.HighlightMode.HOVERED)
			elif card_instance != selected_card:
				card_instance.highlight(Card.HighlightMode.NONE)
	
	highlighted_card = card

func _select_card() -> void:
	if selected_card:  
		selected_card.highlight(Card.HighlightMode.NONE)
		
		EventBusHandler.card_deselected.emit()
		
		if selected_card.card_type.targeted:
			display_enemy_highlights.emit(false)
		else:
			display_play_area_highlights.emit(false)
	
	highlighted_card.highlight(Card.HighlightMode.SELECTED)
	selected_card = highlighted_card
	
	EventBusHandler.card_selected.emit(selected_card.card_type.energy_cost)
	
	if selected_card.card_type.targeted:
		display_enemy_highlights.emit(true)
	else:
		display_play_area_highlights.emit(true)

func _deselect_selected_card() -> void:
	if selected_card == highlighted_card:
		selected_card.highlight(Card.HighlightMode.HOVERED)
		selected_card = null
	else:
		selected_card.highlight(Card.HighlightMode.NONE)
		selected_card = null
	
	display_enemy_highlights.emit(false)
	display_play_area_highlights.emit(false)
	
	EventBusHandler.card_deselected.emit()
	
	_set_mouse_cursor()

func _set_tooltips() -> void:
	for card in hand:
		card.tooltip.hide()
	if highlighted_card:
		highlighted_card.tooltip.show()

func _set_player_control(controlable: bool) -> void:
	for card in hand:
		card.playable = controlable
	EventBusHandler.set_player_control.emit(controlable)
	
	if not controlable and selected_card:
		_deselect_selected_card()
	
	_set_mouse_cursor()

#endregion

#region other helper functions

## empties the discard pile into the draw pile and the shuffles the draw pile 
func shuffle_discard_pile_into_draw_pile() -> void:
	draw_pile.append_array(discard_pile)
	discard_pile = []
	draw_pile.shuffle()

## for determening mouseposition
func _on_play_area_mouse_entered() -> void:
	mouse_on_play_area = true 
	_set_mouse_cursor()


func _on_play_area_mouse_exited() -> void:
	mouse_on_play_area = false
	_set_mouse_cursor()

func _set_mouse_cursor() -> void:
	if not selected_card:
		Input.set_custom_mouse_cursor(DEFAULT_CURSOR)
	elif -1 < hovered_enemy_id and selected_card.card_type.targeted:
		Input.set_custom_mouse_cursor(LOCKON_CURSOR)
	elif mouse_on_play_area and not selected_card.card_type.targeted:
		Input.set_custom_mouse_cursor(UNAIMED_CURSOR)
	else:
		Input.set_custom_mouse_cursor(DEFAULT_CURSOR)
#endregion
