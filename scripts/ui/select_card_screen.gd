extends ColorRect

signal card_selected(card: CardType)

const CARD_VISUALIZATION = preload("res://scenes/card/card_visualization.tscn")

@onready var card_container = $HorizontalContainer/CardContainer

func initialize(cards: Array[CardType]) -> void:
	for child in card_container.get_children():
		child.queue_free()
	
	for card in cards:
		if card:
			var card_reward_scene = CARD_VISUALIZATION.instantiate()
			card_reward_scene.initialize(card)
			card_reward_scene.card_selected.connect(_on_card_reward_scene_card_selected)
			card_container.add_child(card_reward_scene)


func _on_card_reward_scene_card_selected(card: CardType) -> void:
	card_selected.emit(card)

func _on_skip_cards_button_up():
	card_selected.emit(null)
