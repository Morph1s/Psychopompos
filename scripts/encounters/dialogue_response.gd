class_name DialogueResponse
extends Resource

signal player_died

@export var displayed_response: String
var rng:RandomNumberGenerator = RandomNumberGenerator.new()
@export var next_block:Array[int]

@export var consequences:Dictionary[ConsequenceType,Variant]  

enum ConsequenceType {
	GET_SPEZIFIC_CARD,
	GET_RANDOM_CARDS, 
	LOSE_CARDS, 
	HP, 
	MAX_HP, 
	SPEZIFIC_ARTIFACT, 
	RANDOM_ARTIFACT}


func resolve_consequences():
	var value 
	for consequence in consequences:
		value = consequences[consequence] # der value ist der Wert der mit einer consequence etwas macht
		match consequence:
			ConsequenceType.GET_SPEZIFIC_CARD: # fuegt die value Karte dem Deck hinzu
				if value is not CardType:
					push_error("consequenzes is implemented wrong")
					return
				DeckHandler.add_card_to_deck(value)
			ConsequenceType.GET_RANDOM_CARDS:
				if value is not int:
					push_error("consequenzes is implemented wrong")
					return
				var cards = DeckHandler.get_cards_for_card_rewards(value)
				for card in cards:
					DeckHandler.add_card_to_deck(card)
			ConsequenceType.LOSE_CARDS: # verliere value Karten
				if value is not int:
					push_error("consequenzes is implemented wrong")
					return
				var counter:int = 0
				var discarded_card:CardType
				while  counter<value :
					discarded_card = DeckHandler.current_deck[rng.randi_range(0,DeckHandler.current_deck.size() - 1)]
					DeckHandler.remove_card_from_deck(discarded_card)
					counter += 1
			ConsequenceType.HP: # verliere/bekomme value momentane hp 
				if value is not int:
					push_error("consequenzes is implemented wrong")
					return
				if value > 0:
					RunData.player_stats.current_hitpoints += value
				else:
					RunData.player_stats.lose_hp(-value) 
			ConsequenceType.MAX_HP: #verliere/bekomme value maximale hp 
				if value is not int:
					push_error("consequenzes is implemented wrong")
					return
				RunData.player_stats.maximum_hitpoints += value
			ConsequenceType.SPEZIFIC_ARTIFACT:
				if value is not Artifact:
					push_error("consequenzes is implemented wrong")
					return
				for artifact in ArtifactHandler.available_artifacts:
					if value == artifact:
						ArtifactHandler.select_artifact(value)
				
			ConsequenceType.RANDOM_ARTIFACT:
				ArtifactHandler.select_artifact(ArtifactHandler.get_random_artifact())
			_:
				push_error("not availabel action")
			
		
	
