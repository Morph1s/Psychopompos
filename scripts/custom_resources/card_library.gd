class_name CardLibrary
extends Resource

@export_category("Cards")

@export_group("starting deck")
@export var starting_deck: Array[CardType]

@export_group("card rewards")
@export var common_cards: Array[CardType]
@export var hero_cards: Array[CardType]
@export var gods_boon_cards: Array[CardType]
