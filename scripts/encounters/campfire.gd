class_name Campfire
extends Node2D

const HEAL_VALUE: float = 0.3

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
	EventBusHandler.show_deck_view_with_action.emit(DeckHandler.current_deck, Callable(self, "remove_card_from_deck"))

func remove_card_from_deck(card: CardType, _card_visual: CardVisualization, _deck_view: DeckView):
	DeckHandler.remove_card_from_deck(card)
	_finish_campfire()

func heal():
	var health_healed: int = RunData.player_stats.maximum_hitpoints * HEAL_VALUE
	health_healed += RunData.altered_values[RunData.AlteredValue.CAMPFIRE_HEAL]
	RunData.player_stats.current_hitpoints += health_healed
	_finish_campfire()

func _finish_campfire():
	heal_button.hide()
	remove_card.hide()
	continue_button.show()
