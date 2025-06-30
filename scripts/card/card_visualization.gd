extends Control

signal card_selected(card: CardType)
signal show_tooltip(data: Array[TooltipData])
signal hide_tooltip

const CARD_ENERGY_BALL = preload("res://assets/graphics/cards/card_energy_ball.png")

@onready var card_frame = $CardFrame
@onready var highlight = $Highlight
@onready var card_image = $CardImage
@onready var card_name = $Name
@onready var description_box = $DescriptionBox
@onready var energy_ball_container = $EnergyBallContainer

var card_type: CardType

func initialize(card: CardType) -> void:
	if not is_node_ready():
		await ready
	
	# load card visuals
	card_type = card
	card_image.texture = card_type.texture
	card_name.text = card_type.card_name
	_create_energy_cost_balls(card_type.energy_cost)
	
	_set_description(card_type.first_description_icon, card_type.first_description_text)
	_set_description(card_type.second_description_icon, card_type.second_description_text)
	
	# set visuals based on rarity
	match card_type.rarity:
		CardType.Rarity.STARTING_CARD:
			card_name.add_theme_color_override("font_color", Color.WHITE)
			card_frame.texture = load("res://assets/graphics/cards/common/template_common_card.png")
		CardType.Rarity.COMMON_CARD:
			card_name.add_theme_color_override("font_color", Color.WHITE)
			card_frame.texture = load("res://assets/graphics/cards/common/template_common_card.png")
		CardType.Rarity.HERO_CARD:
			card_name.add_theme_color_override("font_color", Color.WHITE)
			card_frame.texture = load("res://assets/graphics/cards/hero/template_hero_card.png")
		CardType.Rarity.GODS_BOON:
			card_name.add_theme_color_override("font_color", Color.BLACK)
			card_frame.texture = load("res://assets/graphics/cards/god/template_god_card.png")

func _on_mouse_entered() -> void:
	highlight.show()
	show_tooltip.emit(card_type.tooltips)

func _on_mouse_exited() -> void:
	highlight.hide()
	hide_tooltip.emit()

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_released("left_click"):
		card_selected.emit(card_type)
		print("ofheivbwefiepfpqiehgipipeh")

func _set_description(icon: Texture, text: String) -> void:
	var container = HBoxContainer.new()
	container.add_theme_constant_override("separation", 1)
	container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	if icon:
		var sprite = TextureRect.new()
		sprite.texture = icon
		sprite.mouse_filter = Control.MOUSE_FILTER_IGNORE
		container.add_child(sprite)
	
	if text:
		var label = Label.new()
		label.text = text
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		container.add_child(label)
	
	description_box.add_child(container)

func _create_energy_cost_balls(amount: int) -> void:
	for i in amount:
		var new_ball = TextureRect.new()
		new_ball.texture = CARD_ENERGY_BALL
		energy_ball_container.add_child(new_ball)
