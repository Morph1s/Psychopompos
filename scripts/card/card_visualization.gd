extends Control

signal card_selected(card: CardType)

@onready var highlight = $Highlight
@onready var card_image = $CardImage
@onready var energy_cost = $EnergyCost
@onready var card_name = $Name
@onready var description_box = $DescriptionBox

var card: CardType

func initialize(card: CardType) -> void:
	if not is_node_ready():
		await ready
	
	self.card = card
	card_image.texture = card.texture
	card_name.text = card.card_name
	energy_cost.text = str(card.energy_cost)
	
	_set_description(card.first_description_icon, card.first_description_text,0)
	_set_description(card.second_description_icon, card.second_description_text, 1)

func _on_mouse_entered() -> void:
	highlight.show()

func _on_mouse_exited() -> void:
	highlight.hide()

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_released("left_click"):
		card_selected.emit(card)

func _set_description(icon: Texture, text: String, index: int) -> void:
	var container = HBoxContainer.new()
	container.add_theme_constant_override("separation", 1)
	
	if icon:
		var sprite = TextureRect.new()
		sprite.texture = icon
		container.add_child(sprite)
	
	if text:
		var label = Label.new()
		label.text = text
		#label.position = Vector2(9, (9 * index) + 2)
		container.add_child(label)
	
	description_box.add_child(container)
