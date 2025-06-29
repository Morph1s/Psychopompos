extends Node

enum Characters {
	WARRIOR,
}
enum AlteredValue {
	CARDS_DRAWN,
	CAMPFIRE_HEAL
}

var master_seed: int
var rng_master: RandomNumberGenerator = RandomNumberGenerator.new()
var sub_rngs: Dictionary = {
	"rng_map_gen": RandomNumberGenerator.new(),
	"rng_map_visual": RandomNumberGenerator.new(),
	"rng_card_target": RandomNumberGenerator.new(),
	"rng_special_action": RandomNumberGenerator.new(),
	"rng_enemy": RandomNumberGenerator.new(),
	"rng_artifact": RandomNumberGenerator.new(),
	"rng_deck_handler": RandomNumberGenerator.new(),
	"rng_battle_rewards": RandomNumberGenerator.new(),
}
var selected_character: Characters = Characters.WARRIOR
var player_stats: PlayerStats
var altered_values: Dictionary = {
	AlteredValue.CARDS_DRAWN: 0,
	AlteredValue.CAMPFIRE_HEAL: 0,
}

func start_run(character: Characters):
	rng_master = RandomNumberGenerator.new()
	#rng_master.seed = 42
	master_seed = rng_master.seed
	_generate_sub_rngs()
	
	if player_stats:
		player_stats = null
	
	selected_character = character
	
	match selected_character:
		Characters.WARRIOR:
			player_stats = load("res://resources/characters/Warrior_Stats.tres")
	
	print("Run started with seed %d" % master_seed)

func reset_altered_battle_parameters() -> void:
	altered_values[AlteredValue.CARDS_DRAWN] = 0

func _generate_sub_rngs() -> void:
	for rng: String in sub_rngs:
		sub_rngs[rng].seed = rng_master.randi()
