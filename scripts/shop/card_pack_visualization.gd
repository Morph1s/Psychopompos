class_name CardPackVisualization
extends Control

signal pack_selected(pack: CardPack)
signal show_tooltip(data: Array[TooltipData])
signal hide_tooltip

@onready var pack_image: TextureRect = $PackImage
@onready var price_label: Label = $PriceTag/Price
@onready var price_tag: TextureRect = $PriceTag

const TOO_EXPENSIVE_LABEL_COLOR: Color = Color.RED

var card_pack: CardPack
var shared_material: ShaderMaterial
var is_animating: bool = false

func initialize(pack: CardPack):
	if not is_node_ready():
		await ready
	
	card_pack = pack
	pack_image.texture = _get_pack_image()
	price_label.text = str(card_pack.price)

func _get_pack_image() -> Texture2D:
	match card_pack.pack_rarity:
		CardPack.PackRarity.RARE:
			return load("res://assets/graphics/cards/card_pack_rare_placeholder.png")
		CardPack.PackRarity.LEGENDARY:
			return load("res://assets/graphics/cards/card_pack_legendary_placeholder.png")
	
	return load("res://assets/graphics/cards/card_pack_common_placeholder.png")

func update_price_tag():
	price_label.add_theme_color_override("font_color", Color.WHITE)
	shared_material.set_shader_parameter("desaturation", 0.0)
	if card_pack.price > RunData.player_stats.coins:
		price_label.add_theme_color_override("font_color", Color.RED)
		shared_material.set_shader_parameter("desaturation", 0.8)

func apply_material():
	if not is_node_ready():
		await ready
	
	shared_material = ShaderMaterial.new()
	shared_material.shader = load("res://resources/shaders/desaturate_icon_shader.gdshader")
	
	pack_image.material = shared_material
	price_tag.material = shared_material
	price_label.material = shared_material

func _on_mouse_entered() -> void:
	show_tooltip.emit(card_pack.tooltips)

func _on_mouse_exited() -> void:
	hide_tooltip.emit()

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_released("left_click"):
		if card_pack.price > RunData.player_stats.coins:
			play_shake_animation()
		pack_selected.emit(card_pack)

func play_shake_animation():
	if is_animating:
		return
	
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
	is_animating = false
	mouse_filter = Control.MOUSE_FILTER_STOP
