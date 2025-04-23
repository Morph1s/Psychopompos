class_name CardHandler
extends Node2D



var draw_pile: Array[CardType]
var discard_pile: Array[CardType] = []

const STARTING_DECK: Array[CardType] = [
	preload("res://resources/cards/strike.tres"),
	preload("res://resources/cards/strike.tres"),
	preload("res://resources/cards/strike.tres"),
	preload("res://resources/cards/strike.tres"),
	preload("res://resources/cards/strike.tres"),
	preload("res://resources/cards/defend.tres"),
	preload("res://resources/cards/defend.tres"),
	preload("res://resources/cards/defend.tres"),
	preload("res://resources/cards/defend.tres"),
	preload("res://resources/cards/defend.tres"),
]

func initialize() -> void:
	draw_pile.append_array(STARTING_DECK)
