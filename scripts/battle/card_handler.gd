class_name CardHandler
extends Node2D

signal display_draw_pile
signal display_discard_pile
signal end_turn

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



func _on_draw_pile_button_up() -> void:
	display_draw_pile.emit()


func _on_discard_pile_button_up() -> void:
	display_discard_pile.emit()


func _on_end_turn_button_button_up() -> void:
	end_turn.emit()
