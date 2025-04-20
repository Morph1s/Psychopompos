class_name CardLibrary
extends Resource

@export_category("Cards")

@export_group("starting deck")
@export var starting_deck: Array[CardType]

@export_group("possible card rewards")
@export var common_cards: Array[CardType]
@export var rare_cards: Array[CardType]
@export var epic_cards: Array[CardType]
