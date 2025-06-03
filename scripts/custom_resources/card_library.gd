class_name CardLibrary
extends Resource

@export_category("Cards")

@export_group("starting deck")
@export var starting_deck: Array[CardType]

@export_group("boon 1 (to be renamed)")
@export var common_cards_boon_one: Array[CardType]
@export var rare_cards_boon_one: Array[CardType]
@export var epic_cards_boon_one: Array[CardType]

@export_group("boon 2 (to be renamed)")
@export var common_cards_boon_two: Array[CardType]
@export var rare_cards_boon_two: Array[CardType]
@export var epic_cards_boon_two: Array[CardType]
