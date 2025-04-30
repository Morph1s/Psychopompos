extends Control
class_name EntityHud

var current_hp: int = 0
var max_hp: int = 100
var block_value: int = 0

@onready var hp_bar: TextureProgressBar = $HpBar
@onready var block_label: Label = $BlockLabel
@onready var hp_label: Label = $HpLabel


func set_current_hp(value: int) -> void:
	current_hp = value
	_update_display()
	
func set_max_hp(value: int) -> void:
	max_hp = value	
	hp_bar.max_value = max_hp
	_update_display()

func set_block(value: int) -> void:
	block_value = value
	_update_display()

func _update_display() -> void:
	hp_bar.value = current_hp
	hp_label.text = "HP: %d / %d" % [current_hp, max_hp]
	block_label.text = "Block: %d" % block_value
