extends Node2D





@onready var player_character: Character = $PlayerCharacter

enum possible_actions {
	GOLD, 
	GET_SPEZIFIC_CARD, 
	LOSE_CARDS, 
	HP, 
	MAX_HP, 
	SPEZIFIC_RELIC, 
	RANDOM_RELIC}

var action_map = {
	"gold": possible_actions.GOLD,
	"get spezific card": possible_actions.GET_SPEZIFIC_CARD,
	"lose cards": possible_actions.LOSE_CARDS,
	"hp": possible_actions.HP,
	"max hp": possible_actions.MAX_HP,
	"spezific relic" : possible_actions.SPEZIFIC_RELIC,
	"random relic": possible_actions.RANDOM_RELIC
	}

# for testing purpouse
func _ready() -> void:
	RunData.start_run(RunData.selected_character)


func initialize(data: BattleEncounter) -> void:
	player_character.initialize()


# Handels any action that occures on the encounter
func _on_dialogue_ui_an_action_occured(action: String, value: String) -> void:
	var action_enum = action_map.get(action)
	
	match action_enum:
		possible_actions.GOLD:
			var gain = int(value)
			print("You gained %d gold!", gain)
		possible_actions.HP:
			var gain = int(value)
			RunData.player_stats.current_hitpoints += gain
			print("You get %d hp", gain)
		possible_actions.MAX_HP:
			var gain = int(value)
			RunData.player_stats.maximum_hitpoints += gain
			print("you gain &d MaxHP", gain)
		_:
			print("not yet implemented or invalid action")


func _on_dialogue_ui_end_dialogue() -> void:
	pass # Replace with function body.
