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

var card_type: CardType
var is_perma_highlighted: bool = false
var is_shop: bool = false
var is_animating: bool = false
var is_mouse_over: bool = false


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
	is_mouse_over = true
	highlight.show()
	show_tooltip.emit(card_type.tooltips)

func _on_mouse_exited() -> void:
	is_mouse_over = false
	if not is_perma_highlighted:
		highlight.hide()
	hide_tooltip.emit()

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		if card_type.card_value > RunData.player_stats.coins and is_shop:
			play_shake_animation()
			return
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

func update_price_tag(modifier: float) -> void:
	if card_type.card_value > RunData.player_stats.coins:
		material.set_shader_parameter("desaturation", 0.8)
	
	price.text = str(int(card_type.card_value * modifier))
	price_tag.show()

func apply_material() -> void:
	if not is_node_ready():
		await ready
	
	material = ShaderMaterial.new()
	material.shader = load("res://resources/shaders/desaturation_shader.gdshader")
	material.set_shader_parameter("desaturation", 0.0)
	
	for ball: TextureRect in energy_ball_container.get_children():
		ball.use_parent_material = true
	
	for description: HBoxContainer in description_box.get_children():
		description.use_parent_material = true
		for child: Control in description.get_children():
			child.use_parent_material = true

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
	
	var shake_amount: int = 4
	var original_position: Vector2 = position
	
	tween.tween_property(self, "position:x", original_position.x - shake_amount, 0.02)
	tween.tween_property(self, "position:x", original_position.x + shake_amount, 0.04)
	tween.tween_property(self, "position:x", original_position.x, 0.02)
	
	tween.finished.connect(_on_shake_animation_finished)

func _on_shake_animation_finished():
	is_perma_highlighted = false
	is_animating = false
	if not is_mouse_over:
		highlight.hide()
	mouse_filter = Control.MOUSE_FILTER_STOP

func animate_card_collection(to: Vector2):
	if is_animating:
		return
	is_animating = true
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	var overshoot_scale = Vector2(1.2, 1.2)
	var mid_scale = Vector2(1.0, 1.0)
	var final_scale = mid_scale * 0.2
	var pop_dur = 0.2
	var fly_dur = 0.4
	
	var tween_pop = create_tween()
	
	tween_pop.tween_property(self, "scale", overshoot_scale, pop_dur).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween_pop.chain().tween_property(self, "scale", mid_scale, pop_dur).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	tween_pop.finished.connect(func():
		var tween_fly = create_tween().set_parallel()
		tween_fly.tween_property(self, "global_position", to, fly_dur).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		tween_fly.tween_property(self, "scale", final_scale, fly_dur).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
		tween_fly.finished.connect(_on_card_collection_animation_finished)
	)

func _on_card_collection_animation_finished():
	queue_free()
