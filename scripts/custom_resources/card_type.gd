class_name CardType
extends Resource

@export var texture : Texture
@export var on_play_action : Array[Action]
@export var on_graveyard_action : Array[Action]
@export var targeted : bool = false

## has to be called when adding a new card to the deck
func create_instance() -> CardType:
	var new_entity: CardType = self.duplicate(true)
	return new_entity

## adds a reference to the players modifier handler to all actions
func set_modifier_handler(player_modifier_handler: ModifierHandler) -> void:
	for action in on_play_action:
		action.modifier_handler = player_modifier_handler
	
	for action in on_graveyard_action:
		action.modifier_handler = player_modifier_handler
