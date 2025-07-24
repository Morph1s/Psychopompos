class_name SpecialAction
extends Action

enum SpecialEffects {
	ERIS,
	THANATOS,
	POSEIDON,
	APOLLO,
}

@export var action_type: SpecialEffects

var card_handler: CardHandler
var player: Character
var enemies: Array[Node2D]

var rng: RandomNumberGenerator = RunData.sub_rngs["rng_special_action"]

func resolve(targets: Array[Node2D]) -> void:
	# the first target is the CardHandler, the second is the player, everything after are all enemies in the combat
	card_handler = targets[0]
	player = targets[1]
	for i in range(2, targets.size()):
		enemies.append(targets[i])
	
	match action_type:
		SpecialEffects.ERIS:
			await _resolve_eris()
		SpecialEffects.THANATOS:
			await _resolve_thanatos()
		SpecialEffects.POSEIDON:
			await _resolve_poseidon()
		SpecialEffects.APOLLO:
			await _resolve_apollo()

## discard 1-5 random cards, then draw 1-5 cards
func _resolve_eris() -> void:
	var cards_to_discard: int = rng.randi_range(1, 5)
	var cards_to_draw: int = rng.randi_range(1, 5)
	
	for i in cards_to_discard:
		if card_handler.hand.is_empty():
			break
		await card_handler.discard_card(card_handler.hand[rng.randi_range(0, card_handler.hand.size() - 1)])
	print("eris discarded ", cards_to_discard, "cards")
	
	await card_handler.draw_cards(cards_to_draw)
	print("eris drew ", cards_to_draw, "cards")

## double gather
func _resolve_thanatos() -> void:
	for effect: Effect in player.effect_handler.effect_collection.get_children():
		if effect.effect_name == "Gather":
			player.effect_handler.apply_effect("Gather", effect.stacks)

func _resolve_poseidon() -> void:
	# remove previous actions from the card
	if card_handler.played_card.card_type.on_play_action.size() > 1:
		for i in card_handler.played_card.card_type.on_play_action.size() -1:
			card_handler.played_card.card_type.on_play_action.pop_back()
	
	var actions_to_be_resolved: Array[Action]
	
	# create the attack action
	var attack_all_action: AttackAction = AttackAction.new()
	attack_all_action.damage_stat = 1
	attack_all_action.target_type = TargetedAction.TargetType.ENEMY_ALL_INCLUSIVE
	attack_all_action.modifier_handler = player.modifier_handler
	
	# create the block action
	var block_action: DefendAction = DefendAction.new()
	block_action.block_stat = 2
	block_action.target_type = TargetedAction.TargetType.PLAYER
	block_action.modifier_handler = player.modifier_handler
	
	# append the actions to the arrays
	for i in card_handler.draw_pile.size():
		actions_to_be_resolved.append(attack_all_action)
	
	for i in card_handler.discard_pile.size():
		actions_to_be_resolved.append(block_action)
	
	# add actions to the card
	card_handler.played_card.card_type.on_play_action.append_array(actions_to_be_resolved)

## heal 10 hp
func _resolve_apollo() -> void:
	player.stats.current_hitpoints += 10
