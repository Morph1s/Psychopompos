class_name CardManipulationAction
extends Action

enum CardAction {
	DRAW_CARDS,
	DISCARD_RANDOM,
	DISCARD_ALL,
}

@export var card_action: CardAction 
@export var count: int

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func resolve(targets: Array[Node2D]) -> void : 
	match card_action:
		CardAction.DRAW_CARDS:
			await _draw_cards(targets[0])
		CardAction.DISCARD_RANDOM:
			await _discard_random(targets[0])
		CardAction.DISCARD_ALL:
			await _discard_all(targets[0])

func _discard_random(card_handler: CardHandler) -> void:
	for i in count:
		if card_handler.hand.is_empty():
			break
		var target: Card = card_handler.hand[rng.randi_range(0, card_handler.hand.size() - 1)]
		await card_handler.discard_card(target)

func _draw_cards(card_handler: CardHandler) -> void:
	await card_handler.draw_cards(count)

func _discard_all(card_handler: CardHandler) -> void:
	await card_handler.discard_hand()
