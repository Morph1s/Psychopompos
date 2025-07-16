class_name CardPackVisualization
extends Control

signal pack_selected(pack: CardPack)
signal show_tooltip(data: Array[TooltipData])
signal hide_tooltip

@onready var pack_image: TextureRect = $PackImage
@onready var price_tag: Label = $Price

const TOO_EXPENSIVE_LABEL_COLOR: Color = Color.RED

var card_pack: CardPack

func initialize(pack: CardPack):
	if not is_node_ready():
		await ready
	
	card_pack = pack
	pack_image.texture = _get_pack_image()
	price_tag.text = str(card_pack.price)
	set_price_label_color()

func _get_pack_image() -> Texture2D:
	match card_pack.pack_rarity:
		CardPack.PackRarity.RARE:
			return load("res://assets/graphics/cards/card_pack_rare_placeholder.png")
		CardPack.PackRarity.LEGENDARY:
			return load("res://assets/graphics/cards/card_pack_legendary_placeholder.png")
	
	return load("res://assets/graphics/cards/card_pack_common_placeholder.png")

func set_price_label_color():
	price_tag.add_theme_color_override("font_color", Color.WHITE)
	if card_pack.price > RunData.player_stats.coins:
		price_tag.add_theme_color_override("font_color", Color.RED)

func _on_mouse_entered() -> void:
	show_tooltip.emit(card_pack.tooltips)

func _on_mouse_exited() -> void:
	hide_tooltip.emit()

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_released("left_click"):
		pack_selected.emit(card_pack)
