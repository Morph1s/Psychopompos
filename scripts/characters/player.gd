class_name Character
extends Node2D

@export var stats : PlayerStats 

@onready var modifier_handler: ModifierHandler = $ModifierHandler

func take_damage(damage_amount: int) -> void:
	damage_amount = modifier_handler.modify_value(damage_amount, ModifierHandler.ModifiedValue.DAMAGE_TAKEN)
	stats.take_damage(damage_amount)

func lose_hp(hp_loss: int) -> void:
	stats.lose_hp(hp_loss)

func gain_block(gain_block: int) -> void:
	stats.block += gain_block
