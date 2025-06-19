class_name Character
extends Node2D

signal player_died

@onready var stats: PlayerStats = preload("res://resources/characters/Warrior_Stats.tres")

@onready var modifier_handler: ModifierHandler = $ModifierHandler
@onready var effect_handler = $EffectHandler
@onready var character_image = $CharacterImage
@onready var player_hud: PlayerHud = $PlayerHud

var size: Vector2

func take_damage(damage_amount: int) -> void:
	damage_amount = modifier_handler.modify_value(damage_amount, ModifierHandler.ModifiedValue.DAMAGE_TAKEN)
	stats.take_damage(damage_amount)

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
	stats.energy_changed.connect(_on_energy_changed)
	stats.hitpoints_changed.connect(_on_hitpoints_changed)
	stats.block_changed.connect(_on_block_changed)
	
	size = character_image.texture.get_size()
	player_hud.set_entity_size(size)
	
	effect_handler.initialize(self)
	EventBusHandler.player_played_attack.connect(effect_handler._on_unit_played_attack)
	
	player_hud.set_current_hp(RunData.player_stats.current_hitpoints)
	player_hud.set_max_hp(RunData.player_stats.maximum_hitpoints)

func get_attacked(damage_amount: int) -> void:
	take_damage(damage_amount)
	effect_handler._on_unit_get_attacked()

#region Signal methods
func _on_died() -> void:
	player_died.emit()
	

func _on_energy_changed(new_energy: int, maximum_energy: int) -> void:
	player_hud.set_current_energy(new_energy)
	player_hud.set_max_energy(maximum_energy)
	print("Player Energy changed")

func _on_hitpoints_changed(new_hp: int, max_hp: int) -> void:
	player_hud.set_current_hp(new_hp)
	player_hud.set_max_hp(max_hp)
	print("Player HP changed")

func _on_block_changed(new_block: int) -> void:
	player_hud.set_block(new_block)
#endregion
