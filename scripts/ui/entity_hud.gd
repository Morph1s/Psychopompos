extends Control
class_name EntityHud

const PLAYER_HP_BAR_OVER = preload("res://assets/graphics/hud/hp_bar/player_hp_bar_over.png")
const ENTITY_DEFEND_BAR_OVER = preload("res://assets/graphics/hud/hp_bar/entity_defend_bar_over.png")

@onready var hp_bar = $HpBar
@onready var hitpoints = $HpBar/LabelContainer/Hitpoints
@onready var block = $HpBar/LabelContainer/Block

var current_hp: int = 0
var max_hp: int = 100
var block_value: int = 0


func set_current_hp(value: int) -> void:
	current_hp = value
	hp_bar.value = value
	_update_display()
	
func set_max_hp(value: int) -> void:
	max_hp = value
	hp_bar.max_value = value
	_update_display()

func set_block(value: int) -> void:
	block_value = value
	_set_hp_bar_border()
	_update_display()

func _update_display() -> void:
	hitpoints.text = str(current_hp)
	
	if block_value:
		block.text = "+%d" % [block_value]
		block.show()
	else:
		block.hide()

func set_entity_size(size: Vector2) -> void:
	custom_minimum_size = size + Vector2(0, 8)

func _set_hp_bar_border() -> void:
	if block_value:
		hp_bar.texture_over = ENTITY_DEFEND_BAR_OVER
	else:
		hp_bar.texture_over = PLAYER_HP_BAR_OVER
