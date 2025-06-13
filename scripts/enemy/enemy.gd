class_name Enemy
extends Area2D

signal action_resolved
signal mouse_entered_enemy(Node)
signal mouse_exited_enemy(Node)

@export var stats: EnemyStats
@export var enemy_hud: EnemyHud

@onready var image: Sprite2D = $EnemyImage
@onready var shape: CollisionShape2D = $EnemyShape
@onready var modifier_handler: ModifierHandler = $ModifierHandler
@onready var effect_handler = $EffectHandler

var id: int = 0
var intent: int = -1 # Damit in Runde eins der intent auf null erhöht werden kann
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func initialize() -> void:
	stats.initialize()
	stats.set_modifier_handler(modifier_handler)
	image.texture = stats.enemy_sprite
	shape.shape.size = image.texture.get_size()
	
	# Connecting Signals
	stats.intent_changed.connect(_on_intent_changed)
	stats.hitpoints_changed.connect(_on_hitpoints_changed)
	stats.block_changed.connect(_on_block_changed)
	stats.died.connect(_on_died)
	
	_on_hitpoints_changed(stats.current_hitpoints, stats.maximum_hitpoints)
	_on_block_changed(stats.block)
	
	effect_handler.initialize(self)

func start_of_turn() -> void:
	stats.block = 0
	effect_handler._on_unit_turn_start()

func end_of_turn() -> void:
	effect_handler._on_unit_turn_end()

func take_damage(damage_amount:int) -> void:
	damage_amount = modifier_handler.modify_value(damage_amount, ModifierHandler.ModifiedValue.DAMAGE_TAKEN)
	stats.take_damage(damage_amount)

func lose_hp(hp_loss:int) -> void:
	stats.lose_hp(hp_loss)

func gain_block(gain_block:int) -> void:
	stats.block += gain_block

func get_attacked(damage_amount: int) -> void:
	take_damage(damage_amount)
	effect_handler._on_unit_get_attacked()

func resolve_intent() -> void:
	var actions: Array[Action] = stats.actions[intent].action_catalogue
	var attacked: bool = false
	for action in actions:
		action.resolve(_get_targets(action.target_type))
		if action is AttackAction:
			attacked = true
	
	if attacked:
		effect_handler._on_unit_played_attack()
	
	action_resolved.emit()

func choose_intent() -> void:
	if stats.action_pattern == stats.ActionPattern.LINEAR :
		intent += 1
		if intent >= stats.actions.size():
			intent = 0
	else: 
		intent = rng.randi_range(0,stats.actions.size()-1)	

#region local functions

func _get_targets(targeting_mode: Action.TargetType) -> Array[Node2D]:
	var to_return: Array[Node2D] = []
	
	if targeting_mode == Action.TargetType.PLAYER:
		to_return.append(get_tree().get_first_node_in_group("player"))
		
	elif targeting_mode == Action.TargetType.ENEMY_SINGLE:
		to_return.append(self)
		
	elif targeting_mode == Action.TargetType.ENEMY_ALL_INCLUSIVE:
		to_return.append_array(get_tree().get_nodes_in_group("enemy"))
		
	elif targeting_mode == Action.TargetType.ENEMY_ALL_EXCLUSIVE:
		for enemy in get_tree().get_nodes_in_group("enemy"):
			if enemy.id != id:
				to_return.append(enemy)
		
	elif targeting_mode == Action.TargetType.ENEMY_RANDOM:
		var enemies := get_tree().get_nodes_in_group("enemy")
		to_return.append(enemies[rng.randi_range(0, enemies.size() -1)])
	
	return to_return

#endregion

#region Signal Methods
func _on_hitpoints_changed(new_hp: int, max_hp: int) -> void:
	enemy_hud.set_current_hp(new_hp)
	enemy_hud.set_max_hp(max_hp)

func _on_block_changed(new_block) -> void:
	enemy_hud.set_block(new_block)

func _on_intent_changed(new_intent) -> void:
	enemy_hud.set_intent(new_intent)

func _on_died() -> void:
	print("Enemy died")

func _on_mouse_entered() -> void:
	mouse_entered_enemy.emit(self)

func _on_mouse_exited() -> void:
	mouse_exited_enemy.emit(self)
#endregion
