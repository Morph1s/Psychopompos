extends Control

signal card_selected(card: CardType)
signal show_tooltip(data: Array[TooltipData])
signal hide_tooltip

const CARD_ENERGY_BALL = preload("res://assets/graphics/cards/card_energy_ball.png")
const ATTACK_LABEL_COLOR: Color = Color.RED

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
	
	var first_description_color: Color = Color.WHITE
	if card_type.on_play_action[0] is AttackAction:
		first_description_color = ATTACK_LABEL_COLOR
	
	_set_description(card_type.first_description_icon, card_type.first_description_text_value, first_description_color, card_type.first_description_text_addon)
	
	if card_type.on_play_action.size() > 1:
		var second_description_color: Color = Color.WHITE
		if card_type.on_play_action[1] is AttackAction:
			second_description_color = ATTACK_LABEL_COLOR
		
		_set_description(card_type.second_description_icon, card_type.second_description_text_value, second_description_color, card_type.second_description_text_addon)
	
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
	
	for index in card_type.tooltips.size():
		if index in range(card_type.on_play_action.size()):
			_set_tooltip_of_index(index)
		else:
			card_type.tooltips[index].set_description()

func _set_tooltip_of_index(index: int) -> void:
	if card_type.on_play_action[index] is AttackAction:
		card_type.tooltips[index].set_description(card_type.on_play_action[index].damage_stat)
	elif card_type.on_play_action[index] is DefendAction:
		card_type.tooltips[index].set_description(card_type.on_play_action[index].block_stat)
	elif card_type.on_play_action[index] is EffectAction:
		card_type.tooltips[index].set_description(card_type.on_play_action[index].effect_value)
	elif card_type.on_play_action[index] is SpecialAction:
		card_type.tooltips[index].set_description()
	elif card_type.on_play_action[index] is CardManipulationAction:
		card_type.tooltips[index].set_description(card_type.on_play_action[index].count)

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

func _set_description(icon: Texture, value_text: String, value_text_color: Color, addon_text: String) -> void:
	var container = HBoxContainer.new()
	container.add_theme_constant_override("separation", 1)
	container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	if icon:
		var sprite = TextureRect.new()
		sprite.texture = icon
		sprite.mouse_filter = Control.MOUSE_FILTER_IGNORE
		container.add_child(sprite)
	
	if value_text:
		var label = Label.new()
		label.add_theme_color_override("font_color", value_text_color)
		label.text = value_text
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		container.add_child(label)
	
	if addon_text:
		var label = Label.new()
		label.text = addon_text
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		container.add_child(label)
	
	description_box.add_child(container)

func _create_energy_cost_balls(amount: int) -> void:
	for i in amount:
		var new_ball = TextureRect.new()
		new_ball.texture = CARD_ENERGY_BALL
		energy_ball_container.add_child(new_ball)
