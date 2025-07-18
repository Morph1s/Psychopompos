class_name CardVisualization
extends Control

signal card_selected(card: CardType, scene: CardVisualization)
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
@onready var price_tag: TextureRect = $PriceTag
@onready var price: Label = $PriceTag/Price

# material is added to CardImage, CardFrame and DescriptionBox as well!
var shared_material: ShaderMaterial
var card_type: CardType
var is_perma_highlighted: bool = false
var is_shop: bool = false
var is_animating: bool = false


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
	
	var second_description_color: Color = Color.WHITE
	if card_type.on_play_action.size() > 1:
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
	if not is_perma_highlighted:
		highlight.hide()
	hide_tooltip.emit()

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		if card_type.card_value > RunData.player_stats.coins and is_shop:
			play_shake_animation()
		card_selected.emit(card_type, self)
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

func update_price_tag() -> void:
	price.add_theme_color_override("font_color", Color.WHITE)
	shared_material.set_shader_parameter("desaturation", 0.0)
	if card_type.card_value > RunData.player_stats.coins:
		price.add_theme_color_override("font_color", Color.BLACK)
		shared_material.set_shader_parameter("desaturation", 0.8)
	
	price.text = str(card_type.card_value)
	price_tag.show()

func apply_material() -> void:
	if not is_node_ready():
		await ready

	shared_material = ShaderMaterial.new()
	shared_material.shader = load("res://resources/shaders/desaturate_icon_shader.gdshader")
	
	for ball in energy_ball_container.get_children():
		ball.material = shared_material
	
	for child in description_box.get_child(0).get_children():
		child.material = shared_material
		
	for child in description_box.get_child(1).get_children():
		child.material = shared_material
	
	price_tag.material = shared_material
	card_image.material = shared_material
	card_frame.material = shared_material

func play_shake_animation():
	if is_animating:
		return
	
	is_perma_highlighted = true
	is_animating = true
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_loops(2)
	
	var shake_amount := 4
	var original_position := position
	
	tween.tween_property(self, "position:x", original_position.x - shake_amount, 0.02)
	tween.tween_property(self, "position:x", original_position.x + shake_amount, 0.04)
	tween.tween_property(self, "position:x", original_position.x, 0.02)
	
	tween.connect("finished", _on_shake_animation_finished)


func _on_shake_animation_finished():
	is_perma_highlighted = false
	is_animating = false
	mouse_filter = Control.MOUSE_FILTER_STOP
