class_name Campfire
extends Node2D

@onready var heal_button: Button = $HealButton
@onready var remove_card: Button = $RemoveCardButton
@onready var continue_button: Button = $ContinueButton

const HEAL_VALUE: float = 0.3


func _on_continue_button_pressed() -> void:
	EventBusHandler.encounter_finished.emit()

func _on_heal_button_pressed() -> void:
	heal()

func _on_remove_card_button_pressed() -> void:
	open_remove_card_view()

func open_remove_card_view() -> void:
	EventBusHandler.show_deck_view_with_action.emit(DeckHandler.current_deck, Callable(self, "remove_card_from_deck"))

func remove_card_from_deck(card: CardType, _card_visual: CardVisualization, _deck_view: DeckView) -> void:
	DeckHandler.remove_card_from_deck(card)
	_finish_campfire()

func heal() -> void:
	var health_healed: int = RunData.player_stats.maximum_hitpoints * HEAL_VALUE
	health_healed += RunData.altered_values[RunData.AlteredValue.CAMPFIRE_HEAL]
	RunData.player_stats.current_hitpoints += health_healed
	_finish_campfire()

func _finish_campfire() -> void:
	heal_button.hide()
	remove_card.hide()
	continue_button.show()
