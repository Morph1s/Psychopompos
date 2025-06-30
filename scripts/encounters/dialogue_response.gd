class_name DialogueResponse
extends Resource

var displayed_response: String

#var consequences_types: Array[ConsequenceType]
#var consequences_values: Array


var consequences:Dictionary[ConsequenceType,Variant]  

enum ConsequenceType {
	GET_SPEZIFIC_CARD,
	GET_RANDOM_CARDS, 
	LOSE_CARDS, 
	HP, 
	MAX_HP, 
	SPEZIFIC_RELIC, 
	RANDOM_RELIC}


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
			ConsequenceType.LOSE_CARDS: # verliere value Karten
				print("somthing")
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
			ConsequenceType.SPEZIFIC_RELIC:
				
	
