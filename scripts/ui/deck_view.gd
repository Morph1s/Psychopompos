extends Control

const CARD_VISUALIZATION = preload("res://scenes/card/card_visualization.tscn")

@onready var card_container = $Margin/CardScrollContainer/CardContainer

func _ready():
	DeckHandler.start_run_setup()
	load_cards(DeckHandler.current_deck)

func load_cards(card_pile: Array[CardType]) -> void:
	for card in card_container.get_children():
		card.queue_free()
	
	for card in card_pile:
		var card_visualization = CARD_VISUALIZATION.instantiate()
		card_visualization.initialize(card)
		card_container.add_child(card_visualization)
