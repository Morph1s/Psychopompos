class_name Character
extends Node2D

signal player_died

@onready var stats: PlayerStats = preload("res://resources/characters/Warrior_Stats.tres")

@onready var modifier_handler: ModifierHandler = $ModifierHandler
@onready var effect_handler: EffectHandler = $EffectHandler
@onready var character_image: Sprite2D = $CharacterImage
@onready var player_hud: EntityHud = $PlayerHud
@onready var hit_frame_timer: Timer = $HitFrameTimer

var size: Vector2


func take_damage(damage_amount: int) -> void:
	character_image.material.set_shader_parameter("intensity", 1.0)
	hit_frame_timer.start()
	damage_amount = modifier_handler.modify_value(damage_amount, ModifierHandler.ModifiedValue.DAMAGE_TAKEN)
	stats.take_damage(damage_amount)
	effect_handler._on_unit_take_damage()

func lose_hp(amount: int) -> void:
	stats.lose_hp(amount)

func gain_block(amount: int) -> void:
	stats.block += amount

func start_of_turn() -> void:
	stats.current_energy = stats.maximum_energy
	stats.block = 0
	effect_handler._on_unit_turn_start()

func end_of_turn() -> void:
	effect_handler._on_unit_turn_end()

func initialize() -> void:
	# Connecting Signals
	stats.died.connect(_on_died)
	stats.hitpoints_changed.connect(_on_hitpoints_changed)
	stats.block_changed.connect(_on_block_changed)
	
	size = character_image.texture.get_size()
	player_hud.set_entity_size(size)
	player_hud.set_initial_values(stats.maximum_hitpoints, stats.current_hitpoints, stats.block)
	
	effect_handler.initialize(self)
	EventBusHandler.player_played_attack.connect(effect_handler._on_unit_played_attack)

func get_attacked(damage_amount: int) -> void:
	take_damage(damage_amount)
	effect_handler._on_unit_get_attacked(damage_amount)

func hide_character_hud() -> void:
	player_hud.hide()

func show_character_hud() -> void:
	player_hud.show()

#region Signal methods

func _on_died() -> void:
	if hit_frame_timer.time_left:
		await hit_frame_timer.timeout
	player_died.emit()

func _on_hitpoints_changed(new_hp: int, max_hp: int) -> void:
	player_hud.set_current_hp(new_hp)
	player_hud.set_max_hp(max_hp)

func _on_block_changed(new_block: int) -> void:
	player_hud.set_block(new_block)

func _on_hit_frame_timer_timeout():
	character_image.material.set_shader_parameter("intensity", 0.0)

#endregion
