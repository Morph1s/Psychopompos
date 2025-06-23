class_name SpecialAction
extends Action

enum SpecialEffects {
	ERIS,
	THANATOS,
}

@export var action_type: SpecialEffects

var card_handler: CardHandler
var player_effect_handler: EffectHandler

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func resolve(targets: Array[Node2D]) -> void:
	# the first target is the CardHandler for eris, the second is the player for thanatos 
	match action_type:
		SpecialEffects.ERIS:
			await _resolve_eris(targets[0])
		SpecialEffects.THANATOS:
			await _resolve_thanatos(targets[1].effect_handler)

## discard 1-5 random cards, then draw 1-5 cards
func _resolve_eris(card_handler: CardHandler) -> void:
	var cards_to_discard: int = rng.randi_range(1, 5)
	var cards_to_draw: int = rng.randi_range(1, 5)
	
	for i in cards_to_discard:
		await card_handler.discard_card(card_handler.hand[rng.randi_range(0, card_handler.hand.size() - 1)])
	print("eris discarded ", cards_to_discard, "cards")
	
	await card_handler.draw_cards(cards_to_draw)
	print("eris drew ", cards_to_draw, "cards")

## double gather
func _resolve_thanatos(player_effect_handler: EffectHandler) -> void:
	for effect: Effect in player_effect_handler.effect_collection.get_children():
		if effect.effect_name == "Gather":
			player_effect_handler.apply_effect("Gather", effect.stacks)
