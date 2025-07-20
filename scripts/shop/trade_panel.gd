class_name TradePanel
extends PanelContainer

@onready var trade: TextureRect = $TradePanelMargin/TradeContainer/TradeIcon
@onready var trading_interface: ShopTradingInterface = $"../../../../ShopTradingInterface"

const MAX_NUM_CARDS_TO_TRADE: int = 2

var selected_cards: Array[CardType] = []
var previously_selected_cards: Array[CardType] = []
var can_trade: bool = true


func initialize():
	trading_interface.change_card_selection.connect(_show_trading_deck_view)
	trading_interface.traded.connect(_disable_trading)
	trade.material.set_shader_parameter("desaturation", 0.0)

func _on_trade_icon_gui_input(event: InputEvent) -> void:
	if event.is_action_released("left_click") and can_trade:
		_show_trading_deck_view(selected_cards)

func select_card(card: CardType, card_visual: CardVisualization, deck_view: DeckView):
	# don't allow starting cards to be traded
	if card.rarity == CardType.Rarity.STARTING_CARD:
		card_visual.play_shake_animation()
		return
	
	if not selected_cards.has(card):
		if selected_cards.size() == MAX_NUM_CARDS_TO_TRADE:
			var card_to_deselect: CardType = selected_cards.pop_front()
			for card_vis: CardVisualization in deck_view.card_container.get_children():
				if card_vis.card_type == card_to_deselect:
					card_vis.is_perma_highlighted = false
					card_vis.highlight.hide()
		
		card_visual.is_perma_highlighted = true
		selected_cards.append(card)
		deck_view.action.disabled = false
	
	else:
		card_visual.is_perma_highlighted = false
		selected_cards.erase(card)
		if selected_cards.is_empty():
			deck_view.action.disabled = true

func set_selected_cards():
	for card: CardType in selected_cards:
		print("Selected ", card.card_name, " to trade")
	
	trading_interface.show()
	trading_interface.set_selected_cards(selected_cards)

func set_previously_selected_cards():
	for card: CardType in previously_selected_cards:
		print("Selected ", card.card_name, " to trade")
	
	trading_interface.show()
	trading_interface.set_selected_cards(previously_selected_cards)

func _show_trading_deck_view(selected_cards: Array[CardType]):
	previously_selected_cards = selected_cards.duplicate()
	self.selected_cards.clear()
	EventBusHandler.show_deck_view_with_action.emit(DeckHandler.current_deck, Callable(self, "select_card"), true, Callable(self, "set_selected_cards"), Callable(self, "set_previously_selected_cards"))

func _disable_trading():
	can_trade = false
	trade.material.set_shader_parameter("desaturation", 0.8)
