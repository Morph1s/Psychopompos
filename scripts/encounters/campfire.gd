class_name Campfire
extends Node2D

@onready var heal_button: Button = $HealButton
@onready var remove_card: Button = $RemoveCardButton
@onready var continue_button: Button = $ContinueButton

func _on_continue_button_pressed() -> void:
	EventBusHandler.campfire_finished.emit()

func _on_heal_button_pressed() -> void:
	heal()

func _on_remove_card_button_pressed() -> void:
	open_remove_card_view()

func open_remove_card_view():
	EventBusHandler.show_deck_view.emit(DeckHandler.current_deck, Callable(self, "remove_card_from_deck"))

func remove_card_from_deck(card: CardType):
	DeckHandler.remove_card_from_deck(card)
	_finish_campfire()

func heal():
	RunData.player_stats.current_hitpoints += RunData.player_stats.maximum_hitpoints * 0.3
	_finish_campfire()

func _finish_campfire():
	heal_button.hide()
	remove_card.hide()
	continue_button.show()
