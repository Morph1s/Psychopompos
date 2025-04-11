extends Area2D

@export var stats: EnemyStats

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var id: int = 0

func initialize() -> void:
	sprite_2d.texture = stats.enemy_sprite
	collision_shape_2d.shape.size = sprite_2d.texture.get_size()
	
func take_damage(damage_amount:int) -> void:
	stats.take_damage(damage_amount)
	
func lose_hp(hp_loss:int) -> void:
	stats.lose_hp(hp_loss)
	
func gain_block(gain_block:int) -> void:
	stats.block += gain_block
