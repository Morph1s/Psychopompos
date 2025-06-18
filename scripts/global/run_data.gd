extends Node

enum Characters {
	WARRIOR,
}

var selected_character: Characters = Characters.WARRIOR
var player_stats: PlayerStats

func start_run(character: Characters):
	if player_stats:
		player_stats = null
	
	selected_character = character
	
	match selected_character:
		Characters.WARRIOR:
			player_stats = load("res://resources/characters/Warrior_Stats.tres")

#func change_mouse_cursor(cursor: Texture2D) -> void:
	#Input.set_custom_mouse_cursor(cursor)
