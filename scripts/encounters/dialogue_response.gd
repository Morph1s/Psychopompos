class_name DialogueResponse
extends Resource

signal player_died

@export var displayed_response: String
var rng: RandomNumberGenerator = RunData.sub_rngs["rng_dialogue_response"]
@export var next_block: Array[int]
@export var consequences: Dictionary[ConsequenceType, Variant]

enum ConsequenceType {
	GET_SPECIFIC_CARD,
	GET_RANDOM_CARDS, 
	LOSE_CARDS, 
	HP, 
	MAX_HP, 
	SPECIFIC_ARTIFACT, 
	RANDOM_ARTIFACT,
	}


func resolve_consequences():
	var value 
	for consequence in consequences:
		# value does something depending on the consequence
		value = consequences[consequence]
		match consequence:
			ConsequenceType.GET_SPECIFIC_CARD:
				if value is not CardType:
					push_error("consequences is implemented wrong")
					return
				DeckHandler.add_card_to_deck(value)
			ConsequenceType.GET_RANDOM_CARDS:
				if value is not int:
					push_error("consequences is implemented wrong")
					return
				var cards = DeckHandler.get_cards_for_card_rewards(value)
				for card in cards:
					DeckHandler.add_card_to_deck(card)
			ConsequenceType.LOSE_CARDS:
				if value is not int:
					push_error("consequenzes is implemented wrong")
					return
				var counter: int = 0
				var discarded_card: CardType
				while counter < value:
					discarded_card = DeckHandler.current_deck[rng.randi_range(0, DeckHandler.current_deck.size() - 1)]
					DeckHandler.remove_card_from_deck(discarded_card)
					counter += 1
			ConsequenceType.HP:
				if value is not int:
					push_error("consequences is implemented wrong")
					return
				if value > 0:
					RunData.player_stats.current_hitpoints += value
				else:
					RunData.player_stats.lose_hp(-value) 
			ConsequenceType.MAX_HP:
				if value is not int:
					push_error("consequences is implemented wrong")
					return
				RunData.player_stats.maximum_hitpoints += value
			ConsequenceType.SPECIFIC_ARTIFACT:
				if value is not Artifact:
					push_error("consequences is implemented wrong")
					return
				for artifact in ArtifactHandler.available_artifacts:
					if value == artifact:
						ArtifactHandler.select_artifact(value)
			ConsequenceType.RANDOM_ARTIFACT:
				ArtifactHandler.select_artifact(ArtifactHandler.get_random_artifact())
			_:
				push_error("not available action")
			
		
	
