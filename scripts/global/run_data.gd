extends Node

var player_stats: PlayerStats

func start_run():
	if player_stats:
		player_stats = null
	player_stats = load("res://resources/characters/Warrior_Stats.tres")
