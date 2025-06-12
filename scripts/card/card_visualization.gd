extends TextureRect

signal card_selected(card: CardType)

@onready var highlight = $Highlight

var card: CardType

func initialize(card: CardType) -> void:
	self.card = card
	texture = card.texture


func _on_mouse_entered() -> void:
	highlight.show()

func _on_mouse_exited() -> void:
	highlight.hide()

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_released("left_click"):
		card_selected.emit(card)
