class_name CardType
extends Resource

enum Rarity {
	STARTING_CARD,
	COMMON_CARD,
	HERO_CARD,
	GODS_BOON,
}

signal energy_cost_changed(new_value: int)

@export var card_name: String = ""
@export var energy_cost : int:
	set(value):
		energy_cost = value
		energy_cost_changed.emit(value)
@export var rarity: Rarity
@export var texture : Texture
@export var on_play_action : Array[Action]
@export var on_graveyard_action : Array[Action]
@export var targeted : bool = false
## Icons for description box.
@export var first_description_icon: Texture
## Text for description box.
@export var first_description_text_value: String
@export var first_description_text_addon: String
## Icons for description box.
@export var second_description_icon: Texture
## Text for description box.
@export var second_description_text_value: String
@export var second_description_text_addon: String
@export var tooltips: Array[TooltipData]
## Coin value for shop
@export var card_value: int

## has to be called when adding a new card to the deck
func create_instance() -> CardType:
	var new_entity: CardType = self.duplicate(true)
	return new_entity

## adds a reference to the players modifier handler to all actions
func set_modifier_handler(player_modifier_handler: ModifierHandler) -> void:
	for action in on_play_action:
		if action is TargetedAction:
			action.modifier_handler = player_modifier_handler
	
	for action in on_graveyard_action:
		if action is TargetedAction:
			action.modifier_handler = player_modifier_handler
