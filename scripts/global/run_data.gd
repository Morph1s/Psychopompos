extends Node

enum Characters {
	WARRIOR,
}
enum AlteredValue {
	CARDS_DRAWN,
	CAMPFIRE_HEAL
}

var selected_character: Characters = Characters.WARRIOR
var player_stats: PlayerStats
var altered_values: Dictionary = {
	AlteredValue.CARDS_DRAWN: 0,
	AlteredValue.CAMPFIRE_HEAL: 0,
}

func start_run(character: Characters):
	if player_stats:
		player_stats = null
	
	selected_character = character
	
	match selected_character:
		Characters.WARRIOR:
			player_stats = load("res://resources/characters/Warrior_Stats.tres")

func reset_altered_battle_parameters() -> void:
	altered_values[AlteredValue.CARDS_DRAWN] = 0
