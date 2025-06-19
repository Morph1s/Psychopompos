class_name Campfire
extends Node2D

@onready var heal: Button = $HealButton
@onready var remove_card: Button = $RemoveCardButton
@onready var continue_button: Button = $ContinueButton
@onready var deck_view = $DeckView


func _on_continue_button_pressed() -> void:
	pass # Replace with function body.

func _on_heal_button_pressed() -> void:
	_finish_campfire()

func _on_remove_card_button_pressed() -> void:
	open_remove_card_view()

func open_remove_card_view():
	deck_view.show()
	deck_view.load_cards(DeckHandler.current_deck)

func _finish_campfire():
	heal.hide()
	remove_card.hide()
	continue_button.show()
