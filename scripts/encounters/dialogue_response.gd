class_name DialogueResponse
extends Resource

signal player_died

enum ConsequenceType {
	GET_SPECIFIC_CARD,
	GET_RANDOM_CARDS,
	RANDOM_CARD_OF_TIER,
	LOSE_CARDS,
	HP,
	HP_PERCENTILE,
	MAX_HP,
	SPECIFIC_ARTIFACT,
	RANDOM_ARTIFACT,
	COINS_ABSOLUTE,
	COINS_PERCENTILE,
}

@export var displayed_response: String
@export var next_block: Array[int]
@export var consequences: Dictionary[ConsequenceType, Variant]

var rng: RandomNumberGenerator = RunData.sub_rngs["rng_dialogue_response"]


func resolve_consequences() -> void:
	for consequence: ConsequenceType in consequences.keys():
		# value does something depending on the consequence
		var value: Variant = consequences[consequence]
		match consequence:
			ConsequenceType.GET_SPECIFIC_CARD:
				if value is not CardType:
					push_error("Expected CardType as cosequence value.")
					return
				DeckHandler.add_card_to_deck(value)
			ConsequenceType.GET_RANDOM_CARDS:
				if consequence is not int:
					push_error("Expected int as cosequence value.")
					return
				var cards: Array[CardType] = DeckHandler.get_card_selection(consequence)
				for card: CardType in cards:
					DeckHandler.add_card_to_deck(card)
			ConsequenceType.RANDOM_CARD_OF_TIER:
				if value is not String:
					push_error("Expected String as cosequence value.")
					return
				var card: Array[CardType]
				match value:
					"common card":
						card = DeckHandler.get_card_selection(1,{CardType.Rarity.COMMON_CARD:100})
					"hero card":
						card = DeckHandler.get_card_selection(1,{CardType.Rarity.HERO_CARD:100})
					"gods boon":
						card = DeckHandler.get_card_selection(1,{CardType.Rarity.GODS_BOON:100})
					_:
						push_error("No such CardType: " + value)
						card = DeckHandler.get_card_selection(1)
				DeckHandler.add_card_to_deck(card[0])
			ConsequenceType.LOSE_CARDS:
				if value is not int:
					push_error("Expected int as cosequence value.")
					return
				var counter: int = 0
				var discarded_card: CardType
				while counter < value:
					discarded_card = DeckHandler.current_deck[rng.randi_range(0, DeckHandler.current_deck.size() - 1)]
					DeckHandler.remove_card_from_deck(discarded_card)
					counter += 1
			ConsequenceType.HP:
				if value is not int:
					push_error("Expected int as cosequence value.")
					return
				if value > 0:
					RunData.player_stats.current_hitpoints += value
				else:
					RunData.player_stats.lose_hp(-value)
			ConsequenceType.HP_PERCENTILE:
				if value is int:
					value = float(value)
				if value is not float:
					push_error("Expected float as cosequence value.")
					return
				if 0 < value and value <= 1:
					RunData.player_stats.current_hitpoints += int(value * RunData.player_stats.current_hitpoints)
				elif -1 <= value and value <= 0:
					RunData.player_stats.lose_hp(int(-value * RunData.player_stats.current_hitpoints))
				else:
					push_error("Invalid float value (<-1 or >1)")
			ConsequenceType.MAX_HP:
				if value is not int:
					push_error("Expected int as cosequence value.")
					return
				RunData.player_stats.maximum_hitpoints += value
			ConsequenceType.SPECIFIC_ARTIFACT:
				if value is not Artifact:
					push_error("Expected Artifact as cosequence value.")
					return
				for artifact: Artifact in ArtifactHandler.available_artifacts:
					if value == artifact:
						ArtifactHandler.select_artifact(value)
			ConsequenceType.RANDOM_ARTIFACT:
				ArtifactHandler.select_artifact(ArtifactHandler.get_random_artifact())
			ConsequenceType.COINS_ABSOLUTE:
				if value is not int:
					push_error("Expected int as cosequence value.")
					return
				RunData.player_stats.coins += value
			ConsequenceType.COINS_PERCENTILE:
				if value is int:
					value = float(value)
				if value is not float:
					push_error("Expected float as cosequence value.")
					return
				RunData.player_stats.coins += int(value*RunData.player_stats.coins)
			_:
				push_error("No such consequence.")
