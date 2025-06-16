extends Control
class_name EntityHud

var current_hp: int = 0
var max_hp: int = 100
var block_value: int = 0

@onready var hitpoints = $HitpointBackground/HitpointContainer/Hitpoints
@onready var block = $HitpointBackground/HitpointContainer/Block

func set_current_hp(value: int) -> void:
	current_hp = value
	_update_display()
	
func set_max_hp(value: int) -> void:
	max_hp = value	
	_update_display()

func set_block(value: int) -> void:
	block_value = value
	_update_display()

func _update_display() -> void:
	hitpoints.text = "%d/%d" % [current_hp, max_hp]
	block.text = "+%d" % [block_value]

func set_entity_size(size: Vector2) -> void:
	custom_minimum_size = size + Vector2(0, 8)
